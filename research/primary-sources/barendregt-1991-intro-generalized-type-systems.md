# Barendregt, H.P. (1991). "Introduction to generalized type systems."

**Citation:** Barendregt, H.P. "Introduction to generalized type systems." *Journal of Functional Programming*, 1(2):125-154, April 1991.

**PDF available at:** https://homepages.inf.ed.ac.uk/wadler/papers/barendregt/pure-type-systems.pdf

## Summary

This is the seminal paper introducing the lambda cube framework. Barendregt provides a
fine-structure analysis of Coquand and Huet's Calculus of Constructions (1988) in the form
of a canonical cube of eight type systems ordered by inclusion.

### Key Contributions

1. **The Lambda Cube**: A systematic classification of eight typed lambda calculi arranged
   as vertices of a three-dimensional cube, with the simply typed lambda calculus at one
   corner and the Calculus of Constructions at the opposite corner.

2. **Three Axes**: The cube is organized along three dimensions:
   - Terms depending on types (polymorphism)
   - Types depending on terms (dependent types)
   - Types depending on types (type operators)

3. **Pure Type Systems (PTS)**: Barendregt discusses the generalization of the lambda cube
   systems into Pure Type Systems, parameterized by a specification triple (S, A, R).

4. **Historical Note**: Berardi (1988) and Terlouw (1988) independently generalized the
   method of constructing systems in the lambda cube. Berardi showed that the generalized
   type systems are flexible enough to describe many logical systems.

### The Eight Systems

All systems share sorts S = {*, square}, axiom * : square, and the base rule (*, *).
They differ in which additional rules from {(*, square), (square, *), (square, square)}
they include.
