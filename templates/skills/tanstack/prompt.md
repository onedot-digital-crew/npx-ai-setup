---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# TanStack Query and TanStack Router

## When to use this skill

Use this skill when:

- Fetching, caching, and synchronizing server data with TanStack Query
- Handling loading, error, and stale states for async data
- Implementing optimistic updates and mutations
- Setting up file-based or code-based routing with TanStack Router
- Prefetching data for route transitions
- Using TanStack Query with Vue, React, or Nuxt

## Overview

**TanStack Query** (formerly React Query) manages server state — async data that lives outside the app. It handles caching, background refetching, deduplication, and stale-while-revalidate semantics automatically.

**TanStack Router** is a fully type-safe router for React and Vue with first-class search param support, nested layouts, and built-in data loading.

### Key TanStack Query concepts

- **`useQuery`** — fetch and cache data; returns `{ data, isLoading, isError, error, refetch }`
- **`useMutation`** — trigger writes (POST/PUT/DELETE); returns `{ mutate, isPending, isError }`
- **Query keys** — arrays that uniquely identify a query and drive cache invalidation
- **`invalidateQueries`** — mark cached data stale, triggering background refetch
- **`queryClient`** — the cache manager; typically a singleton provided at the app root
- **staleTime** — how long data is considered fresh (no refetch); `0` = always refetch

## Best Practices

### Query key conventions

Use structured array keys — they enable precise invalidation:

```ts
// Factory pattern — keeps keys consistent across files
const userKeys = {
  all:    () => ['users'] as const,
  lists:  () => ['users', 'list'] as const,
  list:   (filters: UserFilters) => ['users', 'list', filters] as const,
  detail: (id: string) => ['users', 'detail', id] as const,
}

// Usage
useQuery({ queryKey: userKeys.detail(userId), queryFn: () => fetchUser(userId) })

// Invalidate all user queries
queryClient.invalidateQueries({ queryKey: userKeys.all() })

// Invalidate only list queries
queryClient.invalidateQueries({ queryKey: userKeys.lists() })
```

### Separating query functions

Extract query functions into dedicated files for reuse:

```ts
// api/users.ts
export async function fetchUser(id: string): Promise<User> {
  const res = await fetch(`/api/users/${id}`)
  if (!res.ok) throw new Error('Failed to fetch user')
  return res.json()
}

export async function updateUser(id: string, data: Partial<User>): Promise<User> {
  const res = await fetch(`/api/users/${id}`, {
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  })
  if (!res.ok) throw new Error('Failed to update user')
  return res.json()
}
```

### Error handling

Always throw on non-OK responses — TanStack Query only treats thrown errors as failures:

```ts
// Correct — throw on failure
async function fetchProducts() {
  const res = await fetch('/api/products')
  if (!res.ok) {
    const body = await res.json().catch(() => ({}))
    throw new Error(body.message ?? `HTTP ${res.status}`)
  }
  return res.json() as Promise<Product[]>
}

// Wrong — returning null/undefined won't trigger error state
async function fetchProducts() {
  const res = await fetch('/api/products')
  if (!res.ok) return null  // DON'T do this
}
```

### staleTime configuration

Set appropriate staleTime per query to avoid unnecessary refetches:

```ts
// Static reference data — refetch every hour
useQuery({
  queryKey: ['countries'],
  queryFn: fetchCountries,
  staleTime: 60 * 60 * 1000,
})

// User-specific data — refetch when tab regains focus (default: 0)
useQuery({
  queryKey: userKeys.detail(userId),
  queryFn: () => fetchUser(userId),
})

// Real-time data — refetch every 30 seconds
useQuery({
  queryKey: ['notifications'],
  queryFn: fetchNotifications,
  staleTime: 0,
  refetchInterval: 30_000,
})
```

## Common Patterns

### React: basic query

```tsx
import { useQuery } from '@tanstack/react-query'
import { fetchUser } from '@/api/users'

function UserProfile({ userId }: { userId: string }) {
  const { data: user, isLoading, isError, error } = useQuery({
    queryKey: ['users', 'detail', userId],
    queryFn: () => fetchUser(userId),
    staleTime: 5 * 60 * 1000, // 5 minutes
  })

  if (isLoading) return <Spinner />
  if (isError) return <ErrorMessage message={error.message} />

  return <div>{user.name}</div>
}
```

### Vue: basic query

```vue
<script setup lang="ts">
import { useQuery } from '@tanstack/vue-query'
import { fetchUser } from '@/api/users'

const props = defineProps<{ userId: string }>()

const { data: user, isLoading, isError, error } = useQuery({
  queryKey: computed(() => ['users', 'detail', props.userId]),
  queryFn: () => fetchUser(props.userId),
})
</script>

<template>
  <div v-if="isLoading">Loading...</div>
  <div v-else-if="isError">{{ error?.message }}</div>
  <div v-else-if="user">{{ user.name }}</div>
</template>
```

### Mutation with cache invalidation

```tsx
import { useMutation, useQueryClient } from '@tanstack/react-query'

function EditUserForm({ user }: { user: User }) {
  const queryClient = useQueryClient()

  const mutation = useMutation({
    mutationFn: (data: Partial<User>) => updateUser(user.id, data),
    onSuccess: (updatedUser) => {
      // Update the cache directly (avoids a refetch)
      queryClient.setQueryData(['users', 'detail', user.id], updatedUser)
      // Also invalidate the list so it stays in sync
      queryClient.invalidateQueries({ queryKey: ['users', 'list'] })
    },
    onError: (error) => {
      console.error('Update failed:', error)
    },
  })

  return (
    <form onSubmit={(e) => {
      e.preventDefault()
      mutation.mutate({ name: e.currentTarget.name.value })
    }}>
      <input name="name" defaultValue={user.name} />
      <button type="submit" disabled={mutation.isPending}>
        {mutation.isPending ? 'Saving...' : 'Save'}
      </button>
      {mutation.isError && <p>{mutation.error.message}</p>}
    </form>
  )
}
```

### Optimistic updates

```ts
const mutation = useMutation({
  mutationFn: (newTodo: Todo) => createTodo(newTodo),
  onMutate: async (newTodo) => {
    await queryClient.cancelQueries({ queryKey: ['todos'] })
    const previous = queryClient.getQueryData<Todo[]>(['todos'])
    queryClient.setQueryData<Todo[]>(['todos'], (old = []) => [...old, { ...newTodo, id: 'temp' }])
    return { previous }
  },
  onError: (_err, _vars, context) => {
    queryClient.setQueryData(['todos'], context?.previous)
  },
  onSettled: () => {
    queryClient.invalidateQueries({ queryKey: ['todos'] })
  },
})
```

### Dependent queries

```ts
const { data: user } = useQuery({
  queryKey: ['users', userId],
  queryFn: () => fetchUser(userId),
})

// Only runs when user is loaded
const { data: orders } = useQuery({
  queryKey: ['orders', user?.id],
  queryFn: () => fetchOrders(user!.id),
  enabled: !!user?.id,
})
```

### Infinite / paginated queries

```ts
const { data, fetchNextPage, hasNextPage, isFetchingNextPage } = useInfiniteQuery({
  queryKey: ['products', filters],
  queryFn: ({ pageParam = 1 }) => fetchProducts({ page: pageParam, ...filters }),
  getNextPageParam: (lastPage) => lastPage.nextPage ?? undefined,
  initialPageParam: 1,
})

// Flatten pages
const products = data?.pages.flatMap((page) => page.items) ?? []
```

### TanStack Router setup (React)

```tsx
// router.tsx
import { createRouter, createRoute, createRootRoute } from '@tanstack/react-router'

const rootRoute = createRootRoute({ component: RootLayout })

const indexRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/',
  component: HomePage,
})

const userRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/users/$userId',
  loader: ({ params }) => fetchUser(params.userId), // prefetch on navigation
  component: UserPage,
})

export const router = createRouter({
  routeTree: rootRoute.addChildren([indexRoute, userRoute]),
})
```

### QueryClient setup

```tsx
// main.tsx (React)
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 30 * 1000, // 30 seconds default
      retry: 1,
    },
  },
})

ReactDOM.createRoot(document.getElementById('root')!).render(
  <QueryClientProvider client={queryClient}>
    <App />
  </QueryClientProvider>
)
```

```ts
// plugins/tanstack-query.ts (Nuxt 3)
import { VueQueryPlugin, QueryClient } from '@tanstack/vue-query'

export default defineNuxtPlugin((nuxtApp) => {
  const queryClient = new QueryClient({ defaultOptions: { queries: { staleTime: 30_000 } } })
  nuxtApp.vueApp.use(VueQueryPlugin, { queryClient })
})
```

## Resources

- [TanStack Query Docs](https://tanstack.com/query/latest)
- [TanStack Router Docs](https://tanstack.com/router/latest)
- [TanStack Query DevTools](https://tanstack.com/query/latest/docs/react/devtools)
