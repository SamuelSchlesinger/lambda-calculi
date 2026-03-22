# Goguen, McBride, McKinna 2006 — Eliminating Dependent Pattern Matching

**Full Citation:**
Healfdene Goguen, Conor McBride, and James McKinna. "Eliminating Dependent Pattern
Matching." In *Algebra, Meaning, and Computation: Essays Dedicated to Joseph A.
Goguen on the Occasion of His 65th Birthday*, LNCS vol. 4036, pp. 521–540.
Springer, 2006. DOI: 10.1007/11780274_27

**Source:** https://link.springer.com/chapter/10.1007/11780274_27

## Summary

This paper presents a reduction-preserving translation from Coquand's dependent
pattern matching into a traditional type theory with universes, inductive types
and relations, and the axiom K. This translation serves three purposes:

1. **Proof of termination**: It establishes that structurally recursive pattern
   matching programs terminate, by translating them to well-founded uses of
   eliminators.

2. **Compilation technique**: It provides an implementable compilation strategy
   in the style of functional programming languages.

3. **Equivalence proof**: It demonstrates the equivalence between a type theory
   with pattern matching and a more easily understood type theory with only
   eliminators.

## Key Technical Contributions

### The Translation Algorithm

The algorithm works by:
1. Taking a definition by pattern matching (a sequence of clauses)
2. Constructing a case tree by case-splitting on variables
3. At each case split, unifying the constructor's type indices with expected indices
4. Using the resulting substitution to refine types in subgoals
5. Translating the case tree into nested applications of eliminators and
   identity-type eliminators

### Role of Axiom K

The translation crucially relies on axiom K (uniqueness of identity proofs) to
handle the unification of indices. When pattern matching forces an index equation
like `S m = S n`, we derive `m = n`, but reconciling this in the eliminator
translation requires K to discharge the identity proofs that arise.

Specifically, the translation produces terms that use J (path induction) and K to:
- Transport values along identity proofs
- Collapse reflexivity proofs when indices are unified

### Reduction Preservation

The translation preserves the computational behavior: if the original pattern
matching definition reduces (by matching a constructor), the translated
eliminator-based definition also reduces (by iota-reduction), and the results
are convertible.

## Significance

This paper is the definitive reference establishing that dependent pattern matching
is a conservative extension of type theory with eliminators (given axiom K). It
provides the theoretical foundation for implementing pattern matching in proof
assistants while maintaining logical consistency. The later work of Cockx et al.
extends this by showing how to do the translation *without* K.
