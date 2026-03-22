# Benton, N. (1994). A Mixed Linear and Non-Linear Logic: Proofs, Terms and Models.

## Publication
Proceedings of the 8th International Workshop on Computer Science Logic (CSL'94),
Kazimierz, Poland, September 1994. Springer LNCS.

## Summary

Establishes the Linear/Non-Linear (LNL) model of intuitionistic linear logic.
Shows that the categorical model of ILL is equivalent to having a symmetric monoidal
adjunction between a symmetric monoidal closed category and a cartesian closed category.

## Key Contributions

- The ! modality decomposes into two functors F and G forming an adjunction:
  F : C → L (from cartesian to linear world)
  G : L → C (from linear to cartesian world)
  where F ⊣ G
- !A = F(G(A)), the composition of the adjunction
- The linear world is a symmetric monoidal closed category (SMCC)
- The non-linear world is a cartesian closed category (CCC)
- Linear and non-linear exist on equal footing with operations passing both directions

## Categorical Semantics

A model consists of:
- A symmetric monoidal closed category L (linear types)
- A cartesian closed category C (non-linear types)
- A symmetric monoidal adjunction F ⊣ G : L → C

## Source
- https://link.springer.com/chapter/10.1007/BFb0022251
- nLab: https://ncatlab.org/nlab/show/linear-non-linear+logic
