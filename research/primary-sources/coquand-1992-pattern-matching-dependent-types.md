# Coquand 1992 — Pattern Matching with Dependent Types

**Full Citation:**
Thierry Coquand. "Pattern Matching with Dependent Types." In *Proceedings of the 1992
Workshop on Types for Proofs and Programs*, Båstad, Sweden, June 1992, pp. 71–83.
Chalmers University of Technology, 1992.

**PDF Source:** https://wonks.github.io/type-theory-reading-group/papers/proc92-coquand.pdf

## Summary

This is the seminal paper that introduces definitions by pattern matching in
Martin-Löf's logical framework (a dependent type theory). Before this paper,
functions in dependent type theory were defined using eliminators (recursors),
which are powerful but verbose and unintuitive. Coquand showed how the familiar
pattern matching notation from functional programming languages (ML, Haskell)
could be adapted to the dependently typed setting.

## Key Contributions

1. **Formalization of dependent pattern matching**: Coquand gave the first formal
   treatment of pattern matching in the presence of dependent types, where matching
   on a constructor can refine the types of other variables in scope.

2. **Unification of indices**: When matching on a value of an indexed inductive family
   (e.g., Vec A n), the indices must be unified with the constructor's index pattern.
   For example, matching on `vcons : Vec A (S m)` when the index is `n` requires
   unifying `n = S m`, which substitutes `S m` for `n` throughout the goal.

3. **Case splitting algorithm**: Coquand described an algorithm that, given a set of
   clauses defined by pattern matching, checks that the patterns are exhaustive and
   well-typed, and produces a case tree that can be evaluated.

4. **Structural recursion**: The paper addresses recursive definitions, where pattern
   matching is combined with structural recursion to define functions by induction on
   the structure of data.

## Technical Approach

Coquand's approach works by:
- Taking a function defined by a sequence of clauses with patterns
- Performing case analysis on the first non-variable column of patterns
- For each constructor, unifying the constructor's type indices with the expected indices
- Substituting the resulting unifier throughout all types and remaining patterns
- Recursively processing the remaining patterns

This process produces a case tree that can be type-checked and evaluated.

## Significance

This paper established dependent pattern matching as a viable alternative to
eliminators for defining functions in dependent type theories. It directly
influenced the design of Agda, Epigram, Idris, and (via the Equations plugin) Coq.
The Goguen-McBride-McKinna 2006 paper later showed that Coquand's pattern matching
can be translated back to eliminators (plus axiom K), establishing formal equivalence.
