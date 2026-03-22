# An Order-Theoretic Analysis of Universe Polymorphism
## Kuen-Bang Hou (Favonia), Carlo Angiuli, and Reed Mullanix (2023)

**Citation:** Hou (Favonia), K.-B., Angiuli, C., and Mullanix, R. (2023).
An Order-Theoretic Analysis of Universe Polymorphism. Proceedings of the ACM
on Programming Languages, 7(POPL), 1659-1685.
DOI: 10.1145/3571250

## Summary

This paper presents a novel formulation of universe polymorphism in dependent type
theory using monads on the category of strict partial orders.

### Key Contributions

1. **Displacement algebras**: Introduces displacement algebras as a general
   algebraic framework that can implement a generalized form of McBride's "crude
   but effective stratification" scheme.

2. **Generalized universe hierarchies**: Shows that every universe hierarchy can
   be embedded in a displacement algebra and implemented via their generalization
   of McBride's scheme.

3. **Exotic hierarchies**: Gives examples of exotic but consistent universe
   hierarchies beyond the standard natural-number-indexed tower.

### McBride's Crude but Effective Stratification

One way to think about this scheme: every top-level definition is polymorphic in
a secret universe level variable, which can be restricted along edges in the
universe level preorder. Global definitions are defined with fixed, constant
levels, and then uniformly incremented as needed.

### Implementation

The paper includes:
- An OCaml implementation (the mugen library)
- An Agda formalization of the metatheory
