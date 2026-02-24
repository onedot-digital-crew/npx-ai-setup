---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Vitest

## When to use this skill

Use this skill when:

- Writing unit tests or integration tests in a Vite-based project
- Mocking modules, functions, timers, or network requests
- Testing Vue components with `@vue/test-utils` and Vitest
- Testing React components with React Testing Library and Vitest
- Measuring test coverage
- Debugging flaky tests or slow test suites

## Overview

Vitest is a Vite-native test runner. It shares the same Vite config (plugins, aliases, transforms) as the app, so setup is minimal. It is API-compatible with Jest, making migration straightforward.

### Core concepts

- **Test files** — `*.test.ts`, `*.spec.ts`, or files inside `__tests__/`
- **`describe` / `it` / `test`** — standard test structure (all interchangeable as top-level)
- **`expect`** — assertion library (same API as Jest)
- **`vi`** — Vitest's utility object: `vi.fn()`, `vi.mock()`, `vi.spyOn()`, `vi.useFakeTimers()`
- **`beforeEach` / `afterEach` / `beforeAll` / `afterAll`** — lifecycle hooks
- **`coverage`** — built-in via `@vitest/coverage-v8` or `@vitest/coverage-istanbul`

## Best Practices

### File co-location

Place test files next to the files they test:

```
src/
  utils/
    format.ts
    format.test.ts
  components/
    UserCard.vue
    UserCard.test.ts
```

### Test structure — Arrange, Act, Assert

```ts
describe('formatCurrency', () => {
  it('formats whole dollars without decimals', () => {
    // Arrange
    const amount = 1000

    // Act
    const result = formatCurrency(amount, 'USD')

    // Assert
    expect(result).toBe('$1,000.00')
  })
})
```

### Naming conventions

- `describe` block: the thing being tested — `formatCurrency`, `UserCard`, `useUserStore`
- `it` / `test` block: reads as a sentence — `it('returns null when list is empty')`
- File: `*.test.ts` for unit tests, `*.spec.ts` for integration/behavior tests (convention only)

### Avoid implementation details

Test behavior, not internals. Prefer `expect(result)` over asserting on private variables.

### One assertion concept per test

```ts
// Bad — multiple unrelated assertions
it('processes form', () => {
  expect(result.name).toBe('Alice')
  expect(result.email).toBe('alice@example.com')
  expect(mockSave).toHaveBeenCalledOnce()
  expect(router.currentRoute.value.path).toBe('/dashboard')
})

// Better — split into focused tests
it('saves form data with correct values', () => {
  expect(mockSave).toHaveBeenCalledWith({ name: 'Alice', email: 'alice@example.com' })
})

it('redirects to dashboard after save', () => {
  expect(router.currentRoute.value.path).toBe('/dashboard')
})
```

## Common Patterns

### Basic unit test

```ts
// src/utils/math.test.ts
import { describe, it, expect } from 'vitest'
import { add, clamp } from './math'

describe('add', () => {
  it('adds two positive numbers', () => {
    expect(add(2, 3)).toBe(5)
  })

  it('handles negative numbers', () => {
    expect(add(-1, 1)).toBe(0)
  })
})

describe('clamp', () => {
  it.each([
    [5,  0, 10, 5],
    [-5, 0, 10, 0],
    [15, 0, 10, 10],
  ])('clamp(%i, %i, %i) = %i', (value, min, max, expected) => {
    expect(clamp(value, min, max)).toBe(expected)
  })
})
```

### Mocking a module

```ts
import { vi, describe, it, expect, beforeEach } from 'vitest'
import { sendEmail } from './notifications'

// Hoist vi.mock — executed before imports
vi.mock('@/lib/mailer', () => ({
  sendMail: vi.fn().mockResolvedValue({ messageId: 'test-123' }),
}))

import { sendMail } from '@/lib/mailer'

describe('sendEmail', () => {
  beforeEach(() => vi.clearAllMocks())

  it('calls sendMail with correct arguments', async () => {
    await sendEmail('alice@example.com', 'Hello')

    expect(sendMail).toHaveBeenCalledOnce()
    expect(sendMail).toHaveBeenCalledWith(
      expect.objectContaining({ to: 'alice@example.com', subject: 'Hello' })
    )
  })
})
```

### Spying on methods

```ts
import { vi, it, expect } from 'vitest'

it('calls console.error on failure', async () => {
  const spy = vi.spyOn(console, 'error').mockImplementation(() => {})

  await riskyFunction()

  expect(spy).toHaveBeenCalledWith(expect.stringContaining('failed'))
  spy.mockRestore()
})
```

### Fake timers

```ts
import { vi, it, expect, beforeEach, afterEach } from 'vitest'

beforeEach(() => vi.useFakeTimers())
afterEach(() => vi.useRealTimers())

it('debounces the callback', async () => {
  const fn = vi.fn()
  const debounced = debounce(fn, 300)

  debounced()
  debounced()
  debounced()

  expect(fn).not.toHaveBeenCalled()

  vi.advanceTimersByTime(300)

  expect(fn).toHaveBeenCalledOnce()
})
```

### Testing Vue components

```ts
// UserCard.test.ts
import { describe, it, expect } from 'vitest'
import { mount } from '@vue/test-utils'
import UserCard from './UserCard.vue'

describe('UserCard', () => {
  it('renders user name and email', () => {
    const wrapper = mount(UserCard, {
      props: { user: { id: '1', name: 'Alice', email: 'alice@example.com' } },
    })

    expect(wrapper.text()).toContain('Alice')
    expect(wrapper.text()).toContain('alice@example.com')
  })

  it('emits delete event when delete button is clicked', async () => {
    const wrapper = mount(UserCard, {
      props: { user: { id: '1', name: 'Alice', email: 'alice@example.com' } },
    })

    await wrapper.find('[data-testid="delete-btn"]').trigger('click')

    expect(wrapper.emitted('delete')).toBeTruthy()
    expect(wrapper.emitted('delete')?.[0]).toEqual(['1'])
  })
})
```

### Testing with Pinia

```ts
import { setActivePinia, createPinia } from 'pinia'
import { useCartStore } from '@/stores/cart'

describe('useCartStore', () => {
  beforeEach(() => setActivePinia(createPinia()))

  it('adds item to cart', () => {
    const store = useCartStore()
    store.addItem({ id: 'p1', name: 'Widget', price: 9.99 })

    expect(store.items).toHaveLength(1)
    expect(store.total).toBeCloseTo(9.99)
  })
})
```

### Mocking fetch / network

```ts
import { vi, it, expect, afterEach } from 'vitest'

const mockFetch = vi.fn()
vi.stubGlobal('fetch', mockFetch)

afterEach(() => mockFetch.mockReset())

it('fetches user data', async () => {
  mockFetch.mockResolvedValueOnce({
    ok: true,
    json: () => Promise.resolve({ id: '1', name: 'Alice' }),
  })

  const user = await fetchUser('1')

  expect(user.name).toBe('Alice')
  expect(mockFetch).toHaveBeenCalledWith('/api/users/1')
})
```

### Coverage configuration

```ts
// vitest.config.ts
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      include: ['src/**/*.{ts,vue}'],
      exclude: ['src/**/*.d.ts', 'src/main.ts'],
      thresholds: {
        lines: 80,
        branches: 75,
        functions: 80,
      },
    },
  },
})
```

Run: `npx vitest run --coverage`

### Snapshot testing

```ts
it('renders the expected HTML structure', () => {
  const wrapper = mount(AlertBanner, { props: { type: 'error', message: 'Oops' } })
  expect(wrapper.html()).toMatchSnapshot()
})
```

Update snapshots: `npx vitest run --update-snapshots`

### Setup file

```ts
// vitest.config.ts
export default defineConfig({
  test: {
    setupFiles: ['./tests/setup.ts'],
  },
})

// tests/setup.ts
import { vi } from 'vitest'
import { config } from '@vue/test-utils'

// Global mocks
vi.mock('@/lib/analytics', () => ({ track: vi.fn() }))

// Global Vue Test Utils config
config.global.stubs = { RouterLink: true, RouterView: true }
```

## Vitest CLI reference

| Command                                | Description                    |
| -------------------------------------- | ------------------------------ |
| `npx vitest`                           | Watch mode (dev)               |
| `npx vitest run`                       | Single run (CI)                |
| `npx vitest run --reporter=verbose`    | Verbose output                 |
| `npx vitest run --coverage`            | Run with coverage report       |
| `npx vitest run path/to/file.test.ts`  | Run a specific test file       |
| `npx vitest run -t "test name"`        | Run tests matching pattern     |
| `npx vitest ui`                        | Open browser UI                |

## Resources

- [Vitest Docs](https://vitest.dev)
- [Vitest API Reference](https://vitest.dev/api/)
- [Vue Test Utils](https://test-utils.vuejs.org)
- [Testing Library](https://testing-library.com)
