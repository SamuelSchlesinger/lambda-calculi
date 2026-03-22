# Effect Systems: Gifford-Lucassen and Subsequent Work

## Key Papers

### Gifford & Lucassen (1986): Integrating Functional and Imperative Programming
- **Authors:** David K. Gifford, John M. Lucassen
- **Title:** Integrating Functional and Imperative Programming
- **Venue:** ACM Conference on LISP and Functional Programming (LFP '86), 1986
- **DOI:** https://doi.org/10.1145/319838.319848

Introduces "fluent languages" with distinct sublanguages for functional and imperative
programming. A static checking system simultaneously determines the type and the effect
class of every expression. Effect checking guarantees side-effect invariants.

### Lucassen & Gifford (1988): Polymorphic Effect Systems
- **Authors:** John M. Lucassen, David K. Gifford
- **Title:** Polymorphic Effect Systems
- **Venue:** POPL 1988
- **DOI:** https://doi.org/10.1145/73560.73564

Extends effect systems with polymorphism.

### Talpin & Jouvelot (1992/1994): The Type and Effect Discipline
- **Authors:** Jean-Pierre Talpin, Pierre Jouvelot
- **Title:** Polymorphic Type, Region and Effect Inference
- **Venue:** Journal of Functional Programming 2(3), 1992; full version in Information and Computation 111(2), 1994
- **DOI (journal):** https://doi.org/10.1006/inco.1994.1046

Types abstract values; effects denote imperative operations on regions; regions abstract
sets of possibly aliased memory locations. Provides a reconstruction algorithm for
principal types and minimal effects.

## Concept

An effect system annotates types with information about what computational effects
an expression may perform. A judgment has the form:

    Gamma |- e : A ! epsilon

where epsilon is an effect annotation (e.g., {read, write, raise, diverge}).

Effect systems enable:
- Determining purity of expressions
- Optimizations based on effect information
- Ensuring effect safety (e.g., no unhandled exceptions)
