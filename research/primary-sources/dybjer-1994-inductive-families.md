# Dybjer: Inductive Families (1994)

## Citation
Dybjer, P. "Inductive Families." Formal Aspects of Computing, 6(4):440–465, 1994.

## Key Contributions
- General formulation of inductive and recursive definitions in Martin-Löf's type theory
- Extended Backhouse's "Do-It-Yourself Type Theory" to include inductive definitions
  of families of sets
- Definitions of functions by recursion on the way elements are generated
- Formulation in natural deduction, generalizing Martin-Löf's theory of iterated
  inductive definitions in predicate logic

## Formal Criteria
- Correct formation rules capturing definition by strictly positive, iterated,
  generalized induction
- An inversion principle for deriving elimination and equality rules from the
  formation and introduction rules

## Classic Examples
- Fin n: family of finite types indexed by n
- Vec A n: vectors of length n (dependent lists)
- Propositional equality as an inductive family

## Influence
- Foundation for Lean's kernel implementation of inductive types
- Basis for the theory of indexed inductive types in all major proof assistants

## Source
- Springer: https://link.springer.com/article/10.1007/BF01211308
