# Type Checking with Universes
## Robert Harper and Robert Pollack (1991)

**Citation:** Harper, R. and Pollack, R. (1991). Type Checking with Universes.
Theoretical Computer Science, 89(1), 107-136.

**Related:** Harper, R. and Pollack, R. (1989). Type Checking, Universe
Polymorphism, and Typical Ambiguity in the Calculus of Constructions (Draft).
In: Ehrig, H., et al. (eds) TAPSOFT '89. LNCS, vol 352. Springer.

## Summary

This seminal paper addresses type checking and universe polymorphism in the
Calculus of Constructions with an infinite hierarchy of universes (CCω).

### Key Contributions

1. **Type synthesis is effective in CCω**: Given a term, a set of constraints can
   be computed that characterize all types of all well-typed instances.

2. **Universe inference algorithm**: The paper develops an algorithm for
   automatically inferring universe levels, making the universe hierarchy
   transparent to the user in typical cases.

3. **Typical ambiguity**: Following Huet's approach, universe subscripts are
   elided and it is asserted that some correctly stratified level assignment
   exists. The mechanization of this concept forms the basis of universe
   polymorphism in proof assistants.

### Limitations

- The approach to implicit universe polymorphism is problematic with respect to
  modularity — universe level disambiguation can be a costly operation.
- Global constraints can slow down type-checking significantly.
- Cannot express genuine universe-polymorphic definitions that are reusable at
  different levels (addressed by Sozeau-Tabareau 2014).

### Influence

This paper's constraint-based approach to universe levels directly influenced the
design of universe handling in Coq, Lean, and other proof assistants. The
algorithm used in Coq's type-checker refines the Huet and Harper-Pollack approach.
