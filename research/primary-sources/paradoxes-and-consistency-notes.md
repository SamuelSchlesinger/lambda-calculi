# Paradoxes and Consistency in Type Theory

## Girard's Paradox (1972)

### Citation
J.-Y. Girard. "Interprétation fonctionnelle et élimination des coupures de
l'arithmétique d'ordre supérieur." Thèse de doctorat d'état, Université Paris VII, 1972.

### Core Issue
Adding the axiom Type : Type (a universe containing itself) leads to logical
inconsistency. This is the type-theoretic analogue of the Burali-Forti paradox
(the paradox of the ordinal of all ordinals).

### Mechanism
System U allows impredicative quantification at two universe levels simultaneously.
This enables encoding a variant of the Burali-Forti paradox: one can construct
a well-ordering that must be both a member of and strictly greater than itself.

### Historical Note
Martin-Löf's original (1971) type theory had Type : Type and was shown
inconsistent by Girard. This led to the introduction of universe hierarchies.

## Hurkens' Paradox (1995)

### Citation
A. Hurkens. "A Simplification of Girard's Paradox." Typed Lambda Calculi and
Applications (TLCA), LNCS 902, pp. 266-278, 1995.

### Key Contribution
Simplified Girard's paradox to work in System U⁻ (a smaller system).
The construction defines:
- A type U with functions τ and σ forming an isomorphism between U and P(P(U))
  (the powerset of the powerset of U)
- This creates a contradiction by size/cardinality arguments

### Implementation
Available in Rocq's standard library as Coq.Logic.Hurkens.

## Berardi's Paradox

### Citation
F. Barbanera and S. Berardi. "Proof-irrelevance out of Excluded-middle and
Choice in the Calculus of Constructions." Journal of Functional Programming,
6(3):519-525, 1996.

### Result
In the Calculus of Constructions, excluded middle + strong elimination from
large types implies proof irrelevance, which can be combined to derive
inconsistency in certain settings.

### Mechanism
The paradox shows that classical logic (excluded middle) is incompatible with
certain features of intensional type theory when combined with strong
elimination principles.

## Universe Hierarchies (The Fix)
The standard solution is a cumulative hierarchy of universes:
  Type₀ : Type₁ : Type₂ : ...
with Typeᵢ : Typeᵢ₊₁ but NOT Typeᵢ : Typeᵢ.
This prevents the self-reference that enables paradoxes.
