# Service Locator vs Pure DI

This document explains the two approaches implemented in this repo and the trade-offs.

Implemented artifacts

- Service Locator (get_it + injectable): default app pages (e.g., `TaskListPage`) use `get_it` to resolve dependencies. DI configuration lives in `lib/core/di` and generated code is `injection.config.dart`.
- Pure DI (constructor injection): `TaskListPureDIPage` demonstrates the same feature wired manually using an in-memory datasource (`InMemoryDataSource`) and direct constructor wiring.

Pros / Cons

- Service Locator (get_it + injectable)
  - Pros: concise setup, central registration, easy to swap implementations with environments, integrates well with code generation.
  - Cons: hides dependencies from constructors, can make unit testing slightly less explicit unless resolved via test setup, global state if misused.

- Pure DI (constructor injection)
  - Pros: dependencies are explicit in constructors, easier to reason about, straightforward to test by passing mocks.
  - Cons: more boilerplate to wire up deep graphs, especially for global/external dependencies (DB instances, SharedPreferences).

Recommendation

For large apps, prefer a hybrid approach: use pure DI for core modules and use a light service-locator for application bootstrap and environment wiring. The `TaskListPureDIPage` lets you prototype and test the exact wiring used by a module without relying on codegen.
