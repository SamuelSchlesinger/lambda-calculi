# Bounded First-Class Universe Levels in Dependent Type Theory
## Jonathan Chan and Stephanie Weirich (2025)

**Citation:** Chan, J. and Weirich, S. (2025). Bounded First-Class Universe
Levels in Dependent Type Theory. Submitted to FSCD 2025.
arXiv: 2502.20485

## Summary

This paper addresses the formal semantics and syntax of bounded first-class
universe levels in dependent type theory.

### Motivation

The work addresses a fundamental tension: being able to refer to a type universe
as a term itself increases expressive power, but requires mechanisms to prevent
Girard's paradox from introducing logical inconsistency.

### Progression of Expressiveness

The authors identify increasingly expressive approaches:
1. **Basic hierarchy**: Universes indexed by natural numbers
2. **Level polymorphism**: Abstracting over level variables with level expressions
3. **First-class levels**: Level expressions as terms, subsuming polymorphism
   through dependent quantification
4. **Bounded polymorphism**: Adding explicit constraints on level variables

### Key Contribution

An explicit syntax for a type theory with bounded first-class levels,
parametrized over arbitrary well-founded sets of levels. Prior bounded level
polymorphism systems had proven problematic — some fail to satisfy subject
reduction.

### Mechanized Results (in Lean)

- Subject reduction
- Type safety
- Consistency
- Canonicity
