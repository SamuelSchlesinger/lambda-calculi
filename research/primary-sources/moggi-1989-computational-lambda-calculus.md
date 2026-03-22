# Moggi (1989): Computational Lambda-Calculus and Monads

## Bibliographic Information
- **Author:** Eugenio Moggi
- **Title:** Computational Lambda-Calculus and Monads
- **Venue:** Proceedings of the Fourth Annual Symposium on Logic in Computer Science (LICS), 1989
- **PDF:** https://www.cs.cmu.edu/~crary/819-f09/Moggi89.pdf
- **Alt PDF:** https://www.irif.fr/~mellies/mpri/mpri-ens/articles/moggi-computational-lambda-calculus-and-monads.pdf

## Summary

This paper introduces the computational lambda calculus (lambda_c), which extends the
simply typed lambda calculus with a type constructor T and a let-binding construct for
sequencing computations. The key insight is to distinguish between values (of type A) and
computations (of type TA). A monad (T, eta, mu) provides the categorical semantics: eta
maps values to trivial computations, and the Kleisli composition sequences effectful
computations.

## Key Typing Rules

- If Gamma |- M : A, then Gamma |- [M] : TA  (unit/return)
- If Gamma |- M : TA and Gamma, x:A |- N : TB, then Gamma |- let x <= M in N : TB  (let/bind)

## Key Equations (beta and eta for let)

- let x <= [V] in N = N[V/x]  (beta)
- let x <= M in [x] = M  (eta)
- let y <= (let x <= L in M) in N = let x <= L in (let y <= M in N)  (associativity)

These correspond precisely to the monad laws (left unit, right unit, associativity).
