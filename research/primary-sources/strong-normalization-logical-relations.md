# Strong Normalization of STLC via Logical Relations

## Key References

1. Tait, William W. "Intensional Interpretations of Functionals of Finite Type I."
   *The Journal of Symbolic Logic*, 32(2), pp. 198-212, 1967.
   - Introduced the reducibility method (now called "Tait's method") to prove
     strong normalization for the simply typed lambda calculus.

2. Girard, Jean-Yves. "Interprétation fonctionnelle et élimination des coupures
   de l'arithmétique d'ordre supérieur." Thèse de doctorat d'état, Université
   Paris VII, 1972.
   - Generalized Tait's method to "reducibility candidates" (candidats de
     réductibilité) for System F.

3. Plotkin, Gordon D. "Lambda-definability and Logical Relations."
   Memorandum SAI-RM-4, University of Edinburgh, 1973.
   - Introduced logical relations as a general technique, used to characterize
     lambda-definable elements of a model.

## The Reducibility / Logical Relation

The key idea is to define a family of sets of terms indexed by types, called
the "reducibility predicate" or "logical relation," by induction on the
structure of types.

### Definition

For each type T, define a set SN_T of "reducible" (or "strongly normalizing")
terms:

**Base type B:**
  SN_B(e)  iff  (|- e : B) and e terminates (e is strongly normalizing)

**Arrow type T1 -> T2:**
  SN_{T1 -> T2}(e)  iff  (|- e : T1 -> T2) and e terminates
                          and for all e', if SN_{T1}(e') then SN_{T2}(e e')

### Key Properties to Establish

1. **CR1 (Reducible terms are SN):** If SN_T(e) then e is strongly normalizing.
   - Immediate from the definition (termination is built in).

2. **CR2 (Backward closure / Head expansion):** If e -> e' and SN_T(e'),
   then SN_T(e).
   - Proved by induction on types.

3. **CR3 (Neutral terms):** If e is neutral (variable or application stuck on
   a variable) and all one-step reducts of e are in SN_T, then SN_T(e).
   - Proved by induction on types.

### Main Theorem

**Theorem (Fundamental Lemma / Adequacy):**
If G |- e : T and sigma is a substitution such that for all (x : S) in G,
SN_S(sigma(x)), then SN_T(sigma(e)).

**Proof:** By induction on the typing derivation.

**Corollary (Strong Normalization):**
Every well-typed term of STLC is strongly normalizing.

**Proof:** Apply the fundamental lemma with the identity substitution.
Variables are neutral terms, so by CR3 they are reducible. Hence any
well-typed term is reducible, and by CR1, strongly normalizing.

## Proof Structure Summary

1. Define the logical relation SN_T by induction on types
2. Prove the three "CR" properties
3. Prove the fundamental lemma by induction on typing derivations
4. Derive strong normalization as a corollary

Source: https://continuation.passing.style/blog/Strong_Normalization_of_STLC.html
Also: https://people.mpi-sws.org/~dg/teaching/pt2012/sn.pdf
