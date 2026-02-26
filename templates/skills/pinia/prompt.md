---
model: sonnet
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# Pinia State Management

## When to use this skill

Use this skill when:

- Creating or modifying Pinia stores in a Vue 3 or Nuxt 3 project
- Deciding between Options API and Composition API store styles
- Handling async actions, loading states, and error handling in stores
- Persisting store state across page reloads
- Testing Pinia stores in isolation
- Composing multiple stores together

## Overview

Pinia is the official state management library for Vue 3. It replaces Vuex with a simpler API, full TypeScript support, and first-class support for the Composition API.

### Core concepts

- **Store** — a reactive, singleton unit of state + logic, created with `defineStore`
- **State** — reactive data (like `data()` in a component)
- **Getters** — computed values derived from state (like `computed`)
- **Actions** — methods that mutate state or call async APIs (like `methods`)
- **`$patch`** — batch-update multiple state properties atomically
- **`storeToRefs`** — destructure reactive state from a store without losing reactivity

### Two store styles

**Options Store** (familiar to Vuex users):

```ts
export const useCounterStore = defineStore('counter', {
  state: () => ({ count: 0 }),
  getters: {
    doubled: (state) => state.count * 2,
  },
  actions: {
    increment() { this.count++ },
  },
})
```

**Setup Store** (recommended — more flexible, better TypeScript):

```ts
export const useCounterStore = defineStore('counter', () => {
  const count = ref(0)
  const doubled = computed(() => count.value * 2)
  function increment() { count.value++ }
  return { count, doubled, increment }
})
```

## Best Practices

### File and naming conventions

- One store per file in `stores/` directory
- Name files after the domain: `stores/user.ts`, `stores/cart.ts`
- Export as `use{Domain}Store` — `useUserStore`, `useCartStore`
- Store ID must match the composable name minus `use` and `Store`: `defineStore('user', ...)`

### Structuring a store

```ts
// stores/user.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { User } from '@/types'

export const useUserStore = defineStore('user', () => {
  // State
  const user = ref<User | null>(null)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Getters
  const isLoggedIn = computed(() => user.value !== null)
  const fullName = computed(() =>
    user.value ? `${user.value.firstName} ${user.value.lastName}` : ''
  )

  // Actions
  async function fetchUser(id: string) {
    isLoading.value = true
    error.value = null
    try {
      user.value = await api.getUser(id)
    } catch (e) {
      error.value = e instanceof Error ? e.message : 'Failed to fetch user'
    } finally {
      isLoading.value = false
    }
  }

  function reset() {
    user.value = null
    error.value = null
  }

  return { user, isLoading, error, isLoggedIn, fullName, fetchUser, reset }
})
```

### Using a store in components

```vue
<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useUserStore } from '@/stores/user'

const store = useUserStore()

// Destructure reactive state with storeToRefs — keeps reactivity
const { user, isLoading, error } = storeToRefs(store)

// Actions can be destructured directly (they are not reactive values)
const { fetchUser, reset } = store

onMounted(() => fetchUser('123'))
</script>

<template>
  <div v-if="isLoading">Loading...</div>
  <div v-else-if="error" class="text-red-600">{{ error }}</div>
  <div v-else-if="user">Welcome, {{ user.firstName }}</div>
</template>
```

### Always use `storeToRefs` for state destructuring

```ts
// Wrong — loses reactivity
const { user, isLoading } = useUserStore()

// Correct
const { user, isLoading } = storeToRefs(useUserStore())
```

### Batch updates with `$patch`

```ts
// Update multiple properties atomically
store.$patch({
  count: store.count + 1,
  lastUpdated: new Date(),
})

// Function form for complex mutations
store.$patch((state) => {
  state.items.push({ id: Date.now(), name: 'New item' })
  state.count++
})
```

### Cross-store composition

```ts
// stores/cart.ts — uses the user store
import { useUserStore } from './user'

export const useCartStore = defineStore('cart', () => {
  const userStore = useUserStore()
  const items = ref<CartItem[]>([])

  async function checkout() {
    if (!userStore.isLoggedIn) throw new Error('Must be logged in')
    // ...
  }

  return { items, checkout }
})
```

Call stores inside actions — not at the top level — to avoid circular dependency issues during SSR.

### Reset pattern

```ts
export const useFormStore = defineStore('form', () => {
  const initialState = () => ({ name: '', email: '', submitted: false })
  const state = reactive(initialState())

  function reset() {
    Object.assign(state, initialState())
  }

  return { ...toRefs(state), reset }
})
```

## Common Patterns

### Async action with loading/error state

```ts
async function loadProducts() {
  isLoading.value = true
  error.value = null
  try {
    products.value = await fetchProducts()
  } catch (e) {
    error.value = 'Could not load products'
    console.error(e)
  } finally {
    isLoading.value = false
  }
}
```

### Pinia in Nuxt 3

Install `@pinia/nuxt`:

```ts
// nuxt.config.ts
export default defineNuxtConfig({
  modules: ['@pinia/nuxt'],
})
```

Stores work identically. Nuxt auto-imports stores from `stores/` when `@pinia/nuxt` is configured.

For SSR-safe data fetching, combine with `useAsyncData`:

```ts
// pages/products.vue
const store = useProductStore()
await useAsyncData('products', () => store.fetchProducts())
```

### Persisting state (pinia-plugin-persistedstate)

```ts
// stores/auth.ts
export const useAuthStore = defineStore('auth', () => {
  const token = ref<string | null>(null)
  // ...
  return { token, ... }
}, {
  persist: true, // persists entire store to localStorage
})
```

Or selectively:

```ts
}, {
  persist: {
    key: 'auth',
    storage: persistedState.localStorage,
    paths: ['token'], // only persist the token
  },
})
```

### Subscribe to store changes

```ts
const store = useCartStore()

store.$subscribe((mutation, state) => {
  localStorage.setItem('cart', JSON.stringify(state.items))
})
```

### Testing a store

```ts
import { setActivePinia, createPinia } from 'pinia'
import { useUserStore } from '@/stores/user'

describe('useUserStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('sets user on fetchUser', async () => {
    const store = useUserStore()
    vi.spyOn(api, 'getUser').mockResolvedValue({ id: '1', firstName: 'Alice' })

    await store.fetchUser('1')

    expect(store.user?.firstName).toBe('Alice')
    expect(store.isLoading).toBe(false)
  })
})
```

## Resources

- [Pinia Docs](https://pinia.vuejs.org)
- [Nuxt + Pinia](https://pinia.vuejs.org/ssr/nuxt.html)
- [pinia-plugin-persistedstate](https://prazdevs.github.io/pinia-plugin-persistedstate/)
