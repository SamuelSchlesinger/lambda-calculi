# Logical Relations and Logical Predicates

## Overview
Logical relations are a proof technique where properties of terms are established
by defining relations indexed by types and proving a "fundamental theorem" that
all well-typed terms satisfy the relation.

## Unary Logical Predicates
Used primarily for normalization proofs.

### Definition (for STLC)
P_ι(t) = t is strongly normalizing (base type)
P_{σ→τ}(t) = ∀u. P_σ(u) ⟹ P_τ(t u)

### Fundamental Theorem
If Γ ⊢ t : τ and γ satisfies P at Γ, then P_τ(t[γ]).

### Origin
Tait (1967) for STLC. Extended by Girard (1972) for System F.

## Binary Logical Relations
Used for equivalence, parametricity, and representation independence.

### Definition (for STLC)
R_ι ⊆ Terms × Terms (given base relation)
R_{σ→τ}(f, g) = ∀(a, b) ∈ R_σ. (f a, g b) ∈ R_τ

### Applications
- Program equivalence / contextual equivalence
- Reynolds' parametricity / abstraction theorem
- Wadler's "free theorems"
- Compiler correctness
- Representation independence

### Origin
Plotkin (1973) coined "logical relations."
Statman (1985) proved completeness results.

## Step-Indexed Logical Relations

### Citation
A. W. Appel and D. McAllester. "An Indexed Model of Recursive Types for
Foundational Proof-Carrying Code." ACM TOPLAS, 23(5):657-683, 2001.

### Key Idea
Index the logical relation by a natural number k (the "step index"):
(k, v) ∈ V⟦τ⟧ means v behaves as type τ for k steps of computation.

### Advantages
- Handles recursive types without domain theory
- Handles mutable references
- Simpler mathematical foundations
- Suitable for foundational proof-carrying code

### Disadvantages
- Proofs involve tedious step-index arithmetic
- Obscures the essential proof structure

### Refinements
- Ahmed (2006): step-indexed for recursive and quantified types
- Dreyer et al. (2011): Logical Step-Indexed Logical Relations (LSLR)
  combines step-indexing with Kripke worlds

## Kripke Logical Relations

### Key Idea
Index the logical relation not just by types but by "possible worlds"
that track the set of free variables (or more generally, the context).

### Definition
A Kripke logical relation R is indexed by worlds w:
R^w_τ(t) with monotonicity: if w ≤ w' and R^w_τ(t) then R^{w'}_τ(t[ρ])
where ρ is the weakening from w to w'.

### Why Needed
For normalization of open terms: when proving the fundamental theorem
for lambda abstractions (λx.t), we need to consider the body t in
extended contexts. Kripke structure handles this naturally.

### Applications
- Normalization proofs for dependent type theories
- Decidability of type checking
- NbE correctness proofs

### Citation
Altenkirch, Hofmann, Streicher (1995) used Kripke-style relations.
Coquand used Kripke interpretation for strong normalization of CoC.
