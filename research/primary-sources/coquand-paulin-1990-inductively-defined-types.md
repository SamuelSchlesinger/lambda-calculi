# Coquand and Paulin: Inductively Defined Types (1990)

## Citation
Coquand, T. and Paulin, C. "Inductively Defined Types." In COLOG-88, edited by
P. Martin-Löf and G. Mints. LNCS 417. Springer Berlin Heidelberg, 1990.

## Key Contributions
- First systematic treatment of adding inductive types to the Calculus of Constructions
- Showed that impredicative encodings of data types in CoC are insufficient for practical
  reasoning and program extraction
- Established the strict positivity condition as necessary for consistency
- Demonstrated that non-strictly-positive types (even positive ones) can lead to
  inconsistency in the presence of impredicativity

## The Counterexample for Non-Strict Positivity
If one allows the type:
```
Inductive A : Type := introA : ((A -> Prop) -> Prop) -> A.
```
Then one can construct an injection from (A -> Prop) to A via the operator
Phi(a) = (a -> Prop) -> Prop. Combined with the standard diagonal argument
(Russell/Cantor style), this yields a contradiction.

The three necessary ingredients are:
1. Non-strictly-positive definitions
2. Impredicativity (Prop quantifying over all of Prop)
3. A universe type for Prop

Remove any one and the system remains consistent.

## Source
- Springer: https://link.springer.com/chapter/10.1007/3-540-52335-9_47
