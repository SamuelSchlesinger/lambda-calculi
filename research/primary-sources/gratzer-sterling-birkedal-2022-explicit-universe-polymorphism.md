# Type Theory with Explicit Universe Polymorphism
## Daniel Gratzer, Jonathan Sterling, and Lars Birkedal (2022)

**Citation:** Gratzer, D., Sterling, J., and Birkedal, L. (2023). Type Theory
with Explicit Universe Polymorphism. In: 28th International Conference on Types
for Proofs and Programs (TYPES 2022). LIPIcs, vol 269, article 13.
DOI: 10.4230/LIPIcs.TYPES.2022.13

**Extended version (arXiv):** https://arxiv.org/abs/2212.03284

## Summary

This paper provides a formal account of type theory with explicit universe
polymorphism, refining proposals by Sozeau, Tabareau, and Voevodsky.

### Level Expression Grammar

Level expressions are built from level variables (α, β, ...) using:
- Supremum operation: l ∨ m (binary join / max)
- Successor operation: l⁺ (successor / +1)

These form a sup-semilattice with properties:
- l ∨ l⁺ = l⁺
- (l ∨ m)⁺ = l⁺ ∨ m⁺

The system deliberately excludes a "level zero" constant, ensuring all
universe-involving definitions remain polymorphic.

### Universe Formation (Tarski-style)

    l level
    ───────────
    Uₗ type           (universe at level l)

    A : Uₗ
    ───────────
    Tₗ(A) type         (decoding)

    l < m
    ──────────────────
    Uᵐₗ : Uₘ          (universe code in higher universe)
    Tₘ(Uᵐₗ) = Uₗ      (decoding recovers the universe)

Where l < m abbreviates m = l⁺ ∨ m.

### Level-Indexed Products

    A type (α level)
    ─────────────────
    [α]A type           (level-polymorphic type)

    t : [α]A    l level
    ─────────────────────
    t l : A(l/α)         (level application)

    u : A (α level)
    ─────────────────
    ⟨α⟩u : [α]A         (level abstraction)

    (⟨α⟩u) l = u(l/α)   (β-reduction for levels)

### Constraint System

A constraint ψ is a finite set of level equations l = m. The constraint set must
be acyclic (loop-free). Loop-checking is decidable in polynomial time.

### Constraint-Indexed Products

    A type (ψ)           (type valid under constraint ψ)
    ──────────────
    [ψ]A type            (constraint-polymorphic type)

    ψ valid
    ──────────────
    [ψ]A = A             (constraint discharge)

### Key Properties

- The paper conjectures (but does not formally prove) normalization
- Decidable type-checking is expected as a consequence
- Both Tarski-style (main text) and Russell-style (appendix) formulations given
