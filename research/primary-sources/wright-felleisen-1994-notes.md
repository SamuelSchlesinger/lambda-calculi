# Wright & Felleisen 1994 - A Syntactic Approach to Type Soundness

## Citation
A. K. Wright and M. Felleisen. "A Syntactic Approach to Type Soundness."
Information and Computation, 115(1):38-94, 1994.

## Key Ideas

- Introduced the progress + preservation decomposition for type soundness
- Adapted subject reduction theorems from combinatory logic to programming languages
- Used rewriting techniques (reduction semantics) for language specification
- Extended to polymorphic exceptions, continuations, and references
- First type soundness proof for polymorphic exceptions and continuations in ML

## Progress Theorem
A well-typed closed term is either a value or can take a step.
Formally: If ∅ ⊢ e : τ then either e is a value, or ∃ e'. e → e'

## Preservation Theorem (Subject Reduction)
If a well-typed term takes a step, the result is well-typed at the same type.
Formally: If Γ ⊢ e : τ and e → e', then Γ ⊢ e' : τ

## Type Soundness (Corollary)
Well-typed programs don't get stuck: they either diverge or produce a value.

## Proof Technique
- Progress: by induction on the typing derivation
- Preservation: by induction on the reduction relation, using substitution lemma
- Key lemma: substitution preserves typing

## Impact
Became the standard approach for proving type soundness in PL research.
Taught universally in graduate PL courses. Scales to complex language features.
