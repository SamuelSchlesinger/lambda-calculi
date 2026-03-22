# Giménez: Codifying Guarded Definitions with Recursive Schemes (1995)

## Citation
Giménez, E. "Codifying guarded definitions with recursive schemes."
In Types for Proofs and Programs (TYPES 1994). LNCS 996, pp. 39–59.
Springer, 1995.

## Key Contributions
- Extended CIC with coinductive types using a syntactic guardedness condition
- Showed that conditions for accepting recursive definitions proposed by Coquand
  were not sufficient for the full Calculus of Constructions
- Modified the guard condition appropriately
- Developed a general method to codify fixed-point definitions satisfying the
  guard condition using well-known recursive schemes (primitive recursion, co-recursion)

## Guardedness Condition
- Recursive calls must be on strict subterms of the original argument (for inductive types)
- For coinductive types, recursive calls must be guarded by constructors
  (each recursive call must appear directly under a coconstructor)
- This ensures productive computation: initial output is produced before recursive calls

## Related Work
- Coquand's original formalization of coinductive types via syntactic guardedness
- Giménez's implementation in Coq
- Later analysis: "Analysis of a guard condition in type theory" (1998)

## Source
- Springer: https://link.springer.com/chapter/10.1007/3-540-60579-7_3
