# Wadler's "Theorems for Free!" (1989)

## Source
Philip Wadler, "Theorems for free!" in Proceedings of the Fourth International Conference on Functional Programming Languages and Computer Architecture (FPCA '89), pp. 347–359, ACM, 1989.

## Summary
Wadler showed how to derive theorems about polymorphic functions purely from their types, using Reynolds' parametricity/abstraction theorem. These "free theorems" follow from the type signature alone, without any knowledge of the implementation.

## Key Ideas

### From Types to Theorems
Given a most-general polymorphic type signature, one can generate a theorem that any inhabitant of that type must satisfy. The method works by building a structurally inductive function from types to set-theoretic mathematical relations.

### Classic Example: Lists
A function of type `∀α. [α] → [α]` must commute with `map`:
For any function f, if r : ∀α. [α] → [α], then map f ∘ r = r ∘ map f.

This means any such function can only rearrange list elements; it cannot inspect or create values of the polymorphic type.

### Example: Identity Type
For `∀α. α → α`, the only inhabitant is the identity function.

### Methodology
Parametricity is a reformulation of Reynolds' abstraction theorem: terms evaluated in related environments yield related values. By instantiating the abstraction theorem for specific types, we obtain free theorems.
