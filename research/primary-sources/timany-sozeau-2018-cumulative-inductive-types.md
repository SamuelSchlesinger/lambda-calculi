# Cumulative Inductive Types in Coq
## Amin Timany and Matthieu Sozeau (2018)

**Citation:** Timany, A. and Sozeau, M. (2018). Cumulative Inductive Types in
Coq. In: Kirchner, H. (ed) 3rd International Conference on Formal Structures
for Computation and Deduction (FSCD 2018). LIPIcs, vol 108, article 29.
DOI: 10.4230/LIPIcs.FSCD.2018.29

**Related:** Timany, A. and Sozeau, M. (2017). Consistency of the Predicative
Calculus of Cumulative Inductive Constructions (pCuIC).
arXiv: 1710.03912

## Summary

### Problem

Higher-order dependent type theories stratify using a hierarchy of universes
Type_0 : Type_1 : ... A type system is cumulative if A : Type_i implies
A : Type_{i+1}. However, in the standard pCIC (underlying Coq), cumulativity
applies only to sorts, not to inductive types.

### Contribution

The Predicative Calculus of Cumulative Inductive Constructions (pCuIC) extends
the cumulativity relation to inductive types themselves. This alleviates problems
when working with large inductive types (e.g., the category of small categories).

### Universe Variance for Inductive Types

Each universe parameter of a cumulative inductive type has a variance:
- **Irrelevant** (*): Any two instances are convertible regardless of parameters
- **Covariant** (+): Subtyping holds when universe parameters satisfy ≤
- **Invariant** (=): Only identical universe instances are convertible

Variance is automatically inferred by analyzing how universe parameters appear
in constructor types and fields.

### Consistency

The paper establishes soundness of pCuIC, proving it consistent relative to
the standard pCIC system.
