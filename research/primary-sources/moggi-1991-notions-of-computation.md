# Moggi (1991): Notions of Computation and Monads

## Bibliographic Information
- **Author:** Eugenio Moggi
- **Title:** Notions of Computation and Monads
- **Venue:** Information and Computation, Volume 93, Issue 1, July 1991, pp. 55-92
- **PDF:** https://www.cs.cmu.edu/~crary/819-f09/Moggi91.pdf
- **DOI:** https://doi.org/10.1016/0890-5401(91)90052-4

## Summary

Expanded journal version of the 1989 LICS paper. Systematically develops the idea that
a notion of computation can be modeled by a strong monad on a base category. Provides
an extensive catalog of computational monads:

1. **Partiality:** T(A) = A_bottom (lifting monad)
2. **Nondeterminism:** T(A) = P(A) (powerset monad)
3. **Side effects (state):** T(A) = (A x S)^S for state set S
4. **Exceptions:** T(A) = A + E for exception type E
5. **Continuations:** T(A) = R^(R^A) for answer type R
6. **Interactive I/O:** T(A) = mu X. (A + (X^I x O x X))

Each of these forms a monad, and the computational lambda calculus provides a uniform
syntax for programming with any of these effects.

## Categorical Framework

A computational model consists of:
- A category C with finite products (the category of values)
- A strong monad (T, eta, mu, t) on C

The Kleisli category C_T gives the category of computations:
- Objects: same as C
- Morphisms A -> B in C_T are morphisms A -> TB in C

The strength t_{A,B}: A x TB -> T(A x B) allows values to interact with computations.
