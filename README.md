# lambda-calculi

A Lean 4 formalization of the simply typed lambda calculus (STLC) and System F with complete type safety proofs.

## Key idea

Types and terms are parameterized by a type `p` that gates polymorphic constructors:

- `p = Empty` — only STLC constructors are available (no type variables, no `forall`, no type abstraction)
- `p = Unit` — all System F constructors become available

This lets a single set of definitions and proofs cover both systems.

## Metatheory

The following are proved for the full parametric system (covering both STLC and System F):

- **Progress**: a well-typed closed term is either a value or can step
- **Preservation**: if a well-typed term steps, the result has the same type

## Building

Requires [Lean 4](https://lean-lang.org/) (v4.28.0).

```
lake build
```
