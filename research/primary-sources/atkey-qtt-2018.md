# Atkey, R. (2018). Syntax and Semantics of Quantitative Type Theory.

## Publication
LICS '18: Proceedings of the 33rd Annual ACM/IEEE Symposium on Logic in Computer Science,
pages 56-65. DOI: 10.1145/3209108.3209189

## Summary

Presents Quantitative Type Theory (QTT), a dependent type theory that records usage
information for each variable in a judgement, based on McBride's earlier system.

## Key Contributions

- Semiring-annotated variables: usage tracked by elements of a semiring (Q, +, *, 0, 1)
  - 0: variable is erased (not used at runtime)
  - 1: variable is used exactly once (linear)
  - omega: variable used without restriction
- Generalizes both irrelevance (0-usage) and linearity (1-usage)
- Extends system with dependent multiplicative pair and unit types
- Realizability semantics using Linear Combinatory Algebras
- Introduces Quantitative Categories with Families for categorical semantics

## Semiring Structure

A semiring (S, +, *, 0, 1) where:
- (S, +, 0) is a commutative monoid
- (S, *, 1) is a monoid
- * distributes over +
- 0a = 0 = a0

## Source
- https://bentnib.org/quantitative-type-theory.html
