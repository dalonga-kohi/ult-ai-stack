---
name: map
description: Create or update the feature map in docs/map, the index of what the product does and where each feature lives in the code. Use when a repo has no map, or after a change to behavior, entry points or verification commands.
---

# Feature map

The map answers four questions without a search: what does this product do, why does each feature exist, where does it live, and how do I prove it still works. It is the first thing an agent reads and the reason exploration stays cheap. It describes intent and points at code; the code and its tests hold every detail. A wrong map is worse than none, so it changes in the same PR as the code, and `ult-doccheck` proves its pointers still resolve.

## Layout

```
docs/map/
  README.md        index, at most 60 lines
  <feature>.md     one per feature, at most 60 lines
```

**README.md**

```markdown
# <Product> map

<Two sentences: what the product is and who uses it.>

## Run and check
- Start: `<command>`
- Checks: see `## Checks` in CLAUDE.md

## Features
- [Checkout](checkout.md): cart to paid order. `src/checkout/`
- [Search](search.md): query to ranked results. `src/search/`

## Shared ground
- `src/db/`: schema and queries. Every feature goes through `db.query`.
- <cross-cutting rule in one line: auth, errors, config>
```

**<feature>.md**

```markdown
# <Feature>

## What
<One paragraph: what a user can do, in the product's words.>

## Why
<Who needed it and the problem it solves. Name the epic or ADR it came from: #40, ADR 0003.>

## Entry points
- UI: `src/checkout/CheckoutPage.tsx` `CheckoutPage`
- API: `POST /api/orders` -> `src/checkout/createOrder.ts` `createOrder`

## Flow
cart -> price -> pay -> persist -> email

## Invariants
- An order is never persisted without a successful charge. Test: `src/checkout/createOrder.test.ts`

## Verify
- `pnpm test src/checkout` -> all pass
- `pnpm e2e checkout` -> order appears in `/orders`

## Gotchas
- <a trap that cost time and that the code cannot express>
```

## Rules

- **Feature means something a user or caller would name**, not a folder or a layer.
- **Intent in words, detail by pointer.** `What`, `Why` and `Invariants` are in the product's words. No value, limit, format, signature or step that the code holds: name the symbol or the test that holds it. A line that would need editing when the code changes, without the feature changing, does not belong here.
- **Pointers in a checkable form.** A path in backticks, root-relative, and its symbol right after it in backticks: `` `src/a.ts` `createOrder` ``. That is the form `ult-doccheck` verifies.
- **Every claim is checked against the code** when written. Open the file; confirm the symbol exists.
- **Drop a section that has nothing to say.** No placeholders.
- **Proofs and design live here too**: a feature covered by `ult:prove` lists the proof file and the commit it was last checked against.

## Create (no map yet)

Send `ult:scout` agents, one per top-level area and in parallel, each asked for user-facing features, entry points and test commands. Write the index and feature files from their reports, then open two entry points per feature yourself to confirm them, and run `ult-doccheck`. Cover the features that exist; do not invent structure the repo does not have.

## Update (after a change)

Edit only the feature files your diff affects. New feature: add the file and one index line. Removed feature: delete both. Renamed symbol or moved file: fix the pointer. Then run `ult-doccheck` from the quiet runner's `bin/` folder (`ult-doccheck.ps1` in PowerShell). It prints `PASS` or one `BROKEN` line per missing path, missing symbol or dead link; fix each one.
