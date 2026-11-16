# TypeScript, React, Next.js

## Types

- Parse at the boundary, trust inside. Validate external data (HTTP, env, storage, user input) once with a schema and pass typed values on. No re-validation deeper in.
- No `any`, no `as` to silence the checker, no non-null `!`. If the type is wrong, fix the type. `unknown` plus narrowing at boundaries.
- Model variants as discriminated unions and switch on the tag with an exhaustive `never` check. No optional-field soup where some combinations are illegal.
- Derive types from one source (`z.infer`, `typeof`, `ReturnType`, `satisfies`). Never write the same shape twice.
- Errors that callers must handle are return values (a result union). `throw` is for bugs and for the framework's own error boundaries.

## Modules

- Export the minimum. One public entry per feature folder; siblings import from it, not from internals.
- Group by feature (`checkout/`), not by kind (`hooks/`, `utils/`, `types/`). A `utils` file is a sign a module is missing.
- Functions take an object when they have more than two parameters or any boolean.
- `async` functions are awaited or explicitly handed off. No floating promises.

## React

- Derive, do not sync. If a value can be computed from props or state, compute it during render. `useEffect` is for talking to things outside React, never for copying state to state.
- State lives at the lowest component that needs it. Server data lives in the server-state layer the repo already uses, not in `useState`.
- A component does one thing. Split when it has unrelated state or needs a comment to separate sections.
- Stable keys from data, never the array index for lists that reorder.
- Reach for `useMemo` and `useCallback` only after a measurement shows a problem.

## Next.js (App Router)

- Server Components by default. Add `"use client"` at the smallest leaf that needs interactivity.
- Fetch on the server, next to where the data is used. Mutations go through Server Actions or route handlers that validate input and check authorization themselves.
- Secrets and server-only modules never cross into client files.
- Every route segment that loads data has `loading`, `error` and not-found handling.

## Tests

- Test through the public interface with real collaborators where cheap; fake only what crosses a process boundary (network, clock, filesystem).
- Components: assert what the user sees and does (roles, labels, text), not implementation.
- Test names state the behavior: "rejects an expired coupon".
