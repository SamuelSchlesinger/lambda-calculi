# Practical Linear and Substructural Type Systems

## Rust: Affine Types in Practice

Rust's ownership system implements affine types:
- Most types are affine: can be used at most once (moved or dropped)
- Move semantics = affine type consumption
- Borrowing suspends affine rules for delimited regions
- Copy trait = unrestricted types (can be used many times)
- NOT truly linear: values can be silently dropped without use

Key reference: Weiss, A. et al. "Oxide: The Essence of Rust." arXiv:1903.00982, 2019.

## Linear Haskell (GHC LinearTypes extension)

Bernardy, J.-P., Boespflug, M., Newton, R., Peyton Jones, S., and Spiwack, A. (2018).
Linear Haskell: practical linearity in a higher-order polymorphic language. POPL 2018.

Key design decisions:
- Linearity attached to function arrows, not types
- Linear arrow: a %1 -> b (argument consumed exactly once)
- Unrestricted arrow: a -> b (standard)
- Multiplicity-polymorphic arrow: a %m -> b
- Multiplicity kind: data Multiplicity = One | Many
- Backwards compatible with existing Haskell
- Code reuse across linear and non-linear users

Applications:
- Mutable data with pure interfaces
- Enforcing protocols in I/O functions

## Clean: Uniqueness Types

Clean uses uniqueness types (since 1987):
- Unique type guarantees single reference to an object
- Enables safe in-place update within pure functional framework
- Compiler optimizes unique values with destructive updates
- Alternative to Haskell's monadic I/O

## Idris 2: Quantitative Type Theory in Practice

Brady, E. (2021). Idris 2: Quantitative Type Theory in Practice. ECOOP 2021.

Multiplicities:
- 0: erased at runtime (compile-time only)
- 1: used exactly once at runtime (linear)
- Unrestricted: used any number of times

Applications:
- Erasure for runtime efficiency
- Linear resource protocols (e.g., file handles, doors, sessions)
- First full implementation of QTT in a programming language
- First dependently typed language implemented in itself

## Sources
- Rust forum: https://users.rust-lang.org/t/what-are-affine-types-in-rust/23755
- Linear Haskell: https://arxiv.org/abs/1710.09756
- Idris 2: https://arxiv.org/abs/2104.00480
- Clean: https://clean.cs.ru.nl/Clean
