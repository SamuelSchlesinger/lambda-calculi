# Girard's Reducibility Candidates for System F

## Citation
J.-Y. Girard. "Interprétation fonctionnelle et élimination des coupures de
l'arithmétique d'ordre supérieur." Thèse de doctorat d'état, Université Paris VII, 1972.

Also presented in:
J.-Y. Girard, Y. Lafont, and P. Taylor. "Proofs and Types." Cambridge Tracts
in Theoretical Computer Science 7, Cambridge University Press, 1989.

## Key Ideas

### The Challenge of System F
Tait's method for STLC defines RED_τ by induction on the type τ. But in System F,
types contain type variables (∀α. τ), so we cannot simply induct on type structure.

### Solution: Reducibility Candidates
A reducibility candidate is a set C of terms satisfying:
- CR1: Every t ∈ C is strongly normalizing
- CR2: If t ∈ C and t → t', then t' ∈ C (closure under reduction)
- CR3: If t is neutral and all its one-step reducts are in C, then t ∈ C

Let RC denote the set of all reducibility candidates.

### Interpretation of Types
Given an assignment ξ mapping type variables to reducibility candidates:
- ⟦α⟧ξ = ξ(α)
- ⟦σ → τ⟧ξ = {t | ∀u ∈ ⟦σ⟧ξ. t u ∈ ⟦τ⟧ξ}
- ⟦∀α.τ⟧ξ = ⋂_{C ∈ RC} ⟦τ⟧ξ[α↦C]

### Key Insight
The interpretation of ∀α.τ quantifies over ALL reducibility candidates,
not just those arising as interpretations of types. This handles the
impredicativity of System F.

### Main Result
Every well-typed System F term belongs to the appropriate reducibility candidate,
and therefore is strongly normalizing.

## Significance
- Only known technique for SN in second-order settings
- Extended to Calculus of Constructions, System Fω
- Foundational for proof theory of polymorphic/dependent type systems
