# Brandt & Henglein - Coinductive Axiomatization of Recursive Type Equality and Subtyping (1998)

**Full Citation:**
Michael Brandt and Fritz Henglein. "Coinductive Axiomatization of Recursive Type Equality and Subtyping."
Fundamenta Informaticae, 33(4):309-338, 1998.

**Conference version:** TLCA 1997, Springer LNCS 1210.

**Sources:**
- https://journals.sagepub.com/doi/10.3233/FI-1998-33401
- https://link.springer.com/chapter/10.1007/3-540-62688-3_29

## Summary

This paper presents sound and complete axiomatizations of type equality and subtype
inequality for a first-order type language with regular recursive types.

The rules are motivated by coinductive characterizations of:
- Type containment via simulation
- Type equality via bisimulation

### Key Innovation: The Fixpoint Rule

The main novelty is the fixpoint rule (coinduction principle):

    From A, P |- P, deduce A |- P

where P is either a type equality (tau = tau') or type containment (tau <= tau'),
and the proof of the premise must be *contractive*.

### Advantages Over Amadio-Cardelli

The axiomatizations are more concise than Amadio-Cardelli's, particularly for type
containment, since no separate axiomatization of type equality is required.

### Operational Interpretation

Proofs have a natural operational interpretation as coercions, with the fixpoint rule
corresponding to definition by recursion.

### Algorithmic Connection

The axiomatization gives rise to O(n^2) time algorithms for deciding type equality
and type containment, and for constructing efficient coercions.
