# Girard, J.-Y. (1987). Linear Logic. Theoretical Computer Science, 50: 1-102.

## Summary

This seminal paper introduces linear logic, a refinement of classical and intuitionistic
logic that treats propositions as resources. The key insight comes from a semantic analysis
of System F (polymorphic lambda-calculus) models.

## Key Contributions

- Splits classical connectives into multiplicative and additive variants
- Multiplicative: tensor (A ⊗ B), par (A ⅋ B), linear implication (A ⊸ B)
- Additive: with (A & B), plus (A ⊕ B)
- Introduces exponential modalities: of-course (!A) and why-not (?A)
- Exponentials control structural rules (weakening, contraction)
- Involutive linear negation: A⊥⊥ = A
- Phase semantics for completeness
- Proof nets as graph-based proof representation

## Structural Rules

In linear logic, contraction and weakening are NOT freely available.
They apply only to formulas marked with ! or ?:
- Weakening: Γ, !A ⊢ B implies Γ ⊢ B (can discard !A)
- Contraction: Γ, !A, !A ⊢ B implies Γ, !A ⊢ B (can duplicate !A)
- Exchange remains unrestricted

## Source
- Original: https://www.sciencedirect.com/science/article/pii/0304397587900454
- SEP entry: https://plato.stanford.edu/entries/logic-linear/
