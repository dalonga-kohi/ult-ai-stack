# Rust and Go

## Both

- Make illegal states unrepresentable with types before reaching for runtime checks.
- Errors carry what failed and with which input; add context where the error crosses a module boundary, once.
- Measure before optimizing. A benchmark and a profile come before any change made for speed; see the hillclimb reference in `ult:goal`.
- Concurrency has one owner per piece of mutable state. Share by passing messages or by a lock with a documented, single acquisition order.
- Property-based tests for parsers, encoders, data structures and anything with an invariant.

## Rust

- No `unwrap`, `expect` or `panic!` on paths reachable from input. Return `Result` and use `?`. `expect` is for invariants the type system cannot state, with a message that names the invariant.
- Library errors are enums (`thiserror`); application edges may use `anyhow` with context.
- Borrow by default: `&str`, `&[T]`, `impl AsRef`. Clone only where ownership is needed, and never to quiet the borrow checker. If the borrow checker fights you, the ownership design is wrong.
- Newtypes for identifiers and units (`UserId`, `Millis`), not bare integers and strings.
- `unsafe` needs a `// SAFETY:` contract comment stating the invariant upheld, a safe wrapper, and a test under Miri. This is the one comment that is mandatory.
- Prefer iterators and slices over index loops; prefer enums over trait objects until something outside the crate must extend it.
- `cargo clippy -- -D warnings` and `cargo fmt --check` are part of the fast check. Fix the lint; do not allow it away.

## Go

- Handle every error where it happens: return it wrapped (`fmt.Errorf("load config %s: %w", path, err)`) or act on it. Never `_ =` an error.
- Accept interfaces, return structs. Define an interface where it is consumed, and only when there are two implementations or a test needs a fake.
- `context.Context` is the first parameter of anything that blocks or does I/O, and is honored.
- Every goroutine has a known owner and a known way to stop. No goroutine is started without a plan for its exit.
- Zero values should be useful; constructors only when an invariant needs one.
- Small packages named for what they provide. No `util`, `common`, `helpers`.
- Table-driven tests; `go vet`, `staticcheck` and `go test -race` are part of the checks.
