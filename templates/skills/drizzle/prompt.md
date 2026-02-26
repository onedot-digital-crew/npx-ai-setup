---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Drizzle ORM

## When to use this skill

Use this skill when:

- Defining database schemas with Drizzle's table/column builders
- Writing type-safe queries with the Drizzle query builder
- Managing database migrations with `drizzle-kit`
- Configuring Drizzle for PostgreSQL, MySQL, or SQLite
- Handling relations between tables
- Optimizing query performance with indexes and joins

## Overview

Drizzle ORM is a TypeScript-first ORM that generates fully type-safe SQL. Unlike ORMs that abstract SQL away, Drizzle keeps queries close to SQL while providing compile-time type checking.

### Core concepts

- **Schema** — TypeScript definitions that describe tables, columns, and relations
- **drizzle()** — creates the database client bound to a connection
- **Query builder** — chainable API: `db.select().from(table).where(...).orderBy(...)`
- **Relational queries** — `db.query.users.findMany({ with: { posts: true } })` — Drizzle-specific high-level API
- **`drizzle-kit`** — CLI for generating and running migrations from schema changes

### Adapter matrix

| Database   | Package              | Import from              |
| ---------- | -------------------- | ------------------------ |
| PostgreSQL | `drizzle-orm/pg-core` | `drizzle-orm/node-postgres` or `drizzle-orm/postgres-js` |
| MySQL      | `drizzle-orm/mysql-core` | `drizzle-orm/mysql2`  |
| SQLite     | `drizzle-orm/sqlite-core` | `drizzle-orm/better-sqlite3` or `drizzle-orm/libsql` |

## Best Practices

### Schema definition

Define all schemas in a `db/schema/` directory, one file per domain:

```ts
// db/schema/users.ts
import { pgTable, uuid, varchar, timestamp, boolean } from 'drizzle-orm/pg-core'

export const users = pgTable('users', {
  id:        uuid('id').defaultRandom().primaryKey(),
  email:     varchar('email', { length: 255 }).notNull().unique(),
  name:      varchar('name', { length: 100 }),
  isActive:  boolean('is_active').notNull().default(true),
  createdAt: timestamp('created_at').notNull().defaultNow(),
  updatedAt: timestamp('updated_at').notNull().defaultNow(),
})

// Infer TypeScript types from schema
export type User    = typeof users.$inferSelect
export type NewUser = typeof users.$inferInsert
```

### Indexes

Define indexes in the schema to avoid N+1 on frequently filtered columns:

```ts
import { pgTable, uuid, varchar, index, uniqueIndex } from 'drizzle-orm/pg-core'

export const posts = pgTable('posts', {
  id:       uuid('id').defaultRandom().primaryKey(),
  userId:   uuid('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  slug:     varchar('slug', { length: 255 }).notNull(),
  status:   varchar('status', { length: 20 }).notNull().default('draft'),
  // ...
}, (table) => ({
  userIdIdx:    index('posts_user_id_idx').on(table.userId),
  slugUniqueIdx: uniqueIndex('posts_slug_unique_idx').on(table.slug),
  statusIdx:    index('posts_status_idx').on(table.status),
}))
```

### Relations

Declare relations separately from table definitions:

```ts
// db/schema/relations.ts
import { relations } from 'drizzle-orm'
import { users } from './users'
import { posts } from './posts'

export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
}))

export const postsRelations = relations(posts, ({ one }) => ({
  author: one(users, {
    fields: [posts.userId],
    references: [users.id],
  }),
}))
```

### Database client setup

```ts
// db/index.ts
import { drizzle } from 'drizzle-orm/postgres-js'
import postgres from 'postgres'
import * as schema from './schema'

const client = postgres(process.env.DATABASE_URL!)

export const db = drizzle(client, { schema })
```

### Drizzle Kit configuration

```ts
// drizzle.config.ts
import type { Config } from 'drizzle-kit'

export default {
  schema:    './db/schema',
  out:       './db/migrations',
  dialect:   'postgresql',
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
} satisfies Config
```

Migration commands:

```bash
npx drizzle-kit generate   # generate migration files from schema diff
npx drizzle-kit migrate    # apply pending migrations
npx drizzle-kit push       # push schema directly (dev only, no migration files)
npx drizzle-kit studio     # open Drizzle Studio GUI
```

## Common Patterns

### Basic CRUD

```ts
import { db } from '@/db'
import { users } from '@/db/schema/users'
import { eq, and, ilike, desc } from 'drizzle-orm'
import type { NewUser } from '@/db/schema/users'

// SELECT
const allUsers = await db.select().from(users)

// SELECT with filter
const activeUsers = await db
  .select()
  .from(users)
  .where(and(eq(users.isActive, true), ilike(users.email, '%@example.com')))
  .orderBy(desc(users.createdAt))
  .limit(20)

// SELECT specific columns
const emails = await db
  .select({ id: users.id, email: users.email })
  .from(users)

// INSERT
const [newUser] = await db
  .insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' } satisfies NewUser)
  .returning()

// UPDATE
const [updated] = await db
  .update(users)
  .set({ name: 'Bob', updatedAt: new Date() })
  .where(eq(users.id, '123'))
  .returning()

// DELETE
await db.delete(users).where(eq(users.id, '123'))
```

### Relational queries

```ts
// Fetch user with all their posts
const userWithPosts = await db.query.users.findFirst({
  where: eq(users.id, userId),
  with: {
    posts: {
      where: eq(posts.status, 'published'),
      orderBy: [desc(posts.createdAt)],
      limit: 10,
    },
  },
})

// Nested relations
const fullData = await db.query.users.findMany({
  with: {
    posts: {
      with: {
        comments: true,
      },
    },
  },
})
```

### Join queries

```ts
// Explicit join (use when relational queries are insufficient)
const result = await db
  .select({
    userId:    users.id,
    userEmail: users.email,
    postTitle: posts.title,
  })
  .from(users)
  .innerJoin(posts, eq(posts.userId, users.id))
  .where(eq(posts.status, 'published'))
```

### Transactions

```ts
const result = await db.transaction(async (tx) => {
  const [order] = await tx.insert(orders).values({ userId, total }).returning()
  await tx.insert(orderItems).values(
    items.map((item) => ({ orderId: order.id, ...item }))
  )
  await tx
    .update(inventory)
    .set({ stock: sql`${inventory.stock} - ${item.quantity}` })
    .where(eq(inventory.productId, item.productId))
  return order
})
```

### Dynamic queries

```ts
import { SQL, sql } from 'drizzle-orm'

function buildUserQuery(filters: { search?: string; isActive?: boolean }) {
  const conditions: SQL[] = []

  if (filters.search) {
    conditions.push(ilike(users.name, `%${filters.search}%`))
  }
  if (filters.isActive !== undefined) {
    conditions.push(eq(users.isActive, filters.isActive))
  }

  return db
    .select()
    .from(users)
    .where(conditions.length > 0 ? and(...conditions) : undefined)
}
```

### Pagination

```ts
async function paginate(page: number, pageSize = 20) {
  const offset = (page - 1) * pageSize

  const [items, [{ count }]] = await Promise.all([
    db.select().from(posts).limit(pageSize).offset(offset),
    db.select({ count: sql<number>`count(*)::int` }).from(posts),
  ])

  return { items, total: count, page, pageSize }
}
```

### Upsert

```ts
await db
  .insert(users)
  .values({ email: 'alice@example.com', name: 'Alice' })
  .onConflictDoUpdate({
    target: users.email,
    set: { name: 'Alice Updated', updatedAt: new Date() },
  })
```

## Resources

- [Drizzle ORM Docs](https://orm.drizzle.team)
- [Drizzle Kit Migrations](https://orm.drizzle.team/kit-docs/overview)
- [Drizzle Studio](https://orm.drizzle.team/drizzle-studio/overview)
