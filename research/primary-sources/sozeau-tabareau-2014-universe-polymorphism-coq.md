# Universe Polymorphism in Coq
## Matthieu Sozeau and Nicolas Tabareau (2014)

**Citation:** Sozeau, M. and Tabareau, N. (2014). Universe Polymorphism in Coq.
In: Klein, G. and Gamboa, R. (eds) Interactive Theorem Proving. ITP 2014.
Lecture Notes in Computer Science, vol 8558. Springer, Cham.
DOI: 10.1007/978-3-319-08970-6_32

**PDF:** https://sozeau.gitlabpages.inria.fr/www/research/publications/drafts/univpoly.pdf
**HAL:** https://hal.science/hal-00974721

## Summary

Universes are used in Type Theory to ensure consistency by checking that
definitions are well-stratified according to a hierarchy. In Coq, based on the
predicative Calculus of Inductive Constructions, this hierarchy is built from an
impredicative sort Prop and an infinite number of predicative Type_i universes.

### Problem Addressed

The globality of universe levels and constraints precludes generic constructions
on universes that could work at different levels. This forces code duplication.

### Key Contribution

Universe polymorphism extends the setup by adding local bindings of universes and
constraints, supporting generic definitions over universes, reusable at different
levels. The paper introduces special rules for:

- Introducing universe-monomorphic and universe-polymorphic constants
- Instantiating universe-polymorphic constants at different levels
- Universe constraint checking for consistency

### Approach

Following Huet's approach (refined by Harper and Pollack), universe variables are
associated to every occurrence of Type in a derivation. The derivation is sound if
the graph of constraints is acyclic (i.e., if universe variables are mappable to
positive integers satisfying the constraints). The paper refines this from implicit
"typical ambiguity" to explicit local polymorphism.

### Impact

This work was implemented in Coq and forms the basis of universe polymorphism in
modern Coq/Rocq versions. It has been subsequently extended with cumulative
inductive types (Timany and Sozeau, 2018).
