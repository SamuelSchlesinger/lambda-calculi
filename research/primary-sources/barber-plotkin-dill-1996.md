# Barber, A. and Plotkin, G. (1996). Dual Intuitionistic Linear Logic.

## Publication
University of Edinburgh, Department of Computer Science, Technical Report ECS-LFCS-96-347.

## Summary

DILL is an alternative natural deduction formulation of intuitionistic linear logic
that uses two kinds of assumptions: linear and intuitionistic.

## Key Features

- Sequent form: Gamma; Delta |- A
  - Gamma: intuitionistic (non-linear) assumptions
  - Delta: linear assumptions
- The ! modality introduction: deduce !A from A when NO linear assumptions used
- The ! modality elimination: !A substitutes for an intuitionistic assumption A
- Clean separation of linear and intuitionistic reasoning

## Relationship to Benton's LNL

- DILL can be embedded into ILT (Intuitionistic and Linear Type Theory)
- ILT has no modality but has two function spaces
- Semantics given by monoidal adjunctions between SMCC and CCC

## Source
- https://www.lfcs.inf.ed.ac.uk/reports/96/ECS-LFCS-96-347/ECS-LFCS-96-347.pdf
