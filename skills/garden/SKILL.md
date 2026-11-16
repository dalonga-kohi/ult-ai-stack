---
name: garden
description: How to shape code so the codebase stays small, modular and easy to change. Use when designing a module or interface, adding a file, refactoring, or deciding whether an abstraction or a comment is justified.
---

# Tend the garden

A codebase is a garden. Every change either tends it or lets it overgrow. You plant little, prune often, and leave each bed tidier than you found it.

Stack rules: [TS.md](TS.md) for TypeScript, React and Next.js. [SYSTEMS.md](SYSTEMS.md) for Rust and Go. Read the one that matches the code before writing it.

## Shape

- **Deep modules.** A module hides a lot of behavior behind a small interface. The interface is everything a caller must know: types, ordering, errors, configuration. Fewer methods, fewer parameters, more hidden inside.
- **The deletion test.** Imagine the module deleted. If complexity disappears, it was a pass-through; remove it. If the complexity reappears in every caller, it earns its place.
- **One reason to exist.** If you need "and" to say what a module does, split it. If two modules always change together, merge them.
- **Model the domain in data.** A state machine beats scattered booleans. A table beats a branch ladder. A type that makes the bad state unrepresentable beats a check for it.
- **Accept dependencies, return results.** Pass collaborators in; return values instead of mutating. The interface callers use is the interface tests use.
- **One adapter is a hypothesis; two is a seam.** Do not add an interface, a plugin point or a config option until something really varies across it.

## Prune

- **Subtract first.** Before adding code, look for what can go: a dead branch, a duplicate helper, a flag that is always true. A diff that removes lines and meets the goal is the best diff.
- **Three uses before an abstraction.** Two similar blocks stay as two blocks. Extract on the third, when the shape is known.
- **Migrate, then delete.** When you replace something, move every caller and remove the old path in the same change. No parallel old and new, no compatibility shim nobody asked for.
- **Fix the cause.** A guard added where the symptom shows leaves the bug alive. Follow the bad value to where it was made and fix it there.
- **Stay in your bed.** Touch only what the goal needs. Mess you notice elsewhere goes to `ult:defer`.

## Easy to replace

Modular means a part can be swapped without its callers noticing. That comes from what a module hides, never from extra layers.

- **Nothing from behind the interface crosses it.** No ORM row, SDK response or vendor error in a signature. Translate at the edge, and replacing the dependency changes one module.
- **One place builds it.** Construct the module in one spot and pass it in. Callers that build their own copy each have to change on a swap.
- **Tests at the interface are the replacement contract.** A rewrite is finished when the same tests pass unchanged. A test that reaches inside pins the implementation and blocks the swap.
- **General by subtraction.** A module becomes reusable by knowing less about its callers: plain data in and out, fewer assumptions. Never by adding options for callers that do not exist.

## Second draft

The first version that passes is a draft, written before you knew the answer. With the check green and before the commit, reread the slice and ask what the simplest version looks like now: a branch ladder that is a table, a parameter every caller passes the same, two functions that are one, a name that makes a condition obvious. Make the change if the result is smaller or clearer, and keep the check green. One pass, then commit.

## Comments

The default is no comment. Code says what; names say why. Before writing one, try in order: a better name, an extracted function with that name, a type that carries the constraint, a test that pins the behavior.

A comment may stay only if it is one of:

- a doc comment that defines a public API's contract;
- a constraint forced by something you cannot change (a vendor bug, a protocol, a platform), with a link;
- a license header.

Never write: what the next line does, why you made this change, a note that something is temporary, an apology for a workaround, a banner or divider, commented-out code. Each of these marks a place where the code should have been made better. Make it better.

## Before you commit

- Could a reader new to this file follow it without you? If not, rename until they can.
- Did every new function, parameter, option and file get used by the goal? Delete the rest.
- Is the diff the smallest that meets the goal?
