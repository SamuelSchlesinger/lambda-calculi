# Coinductive Types - nLab

Source: https://ncatlab.org/nlab/show/coinductive+type

## Definition

The notion of coinductive types is dual to that of inductive types.

## Categorical Semantics

Where the categorical semantics of an inductive type is an initial algebra for an endofunctor,
the semantics of a coinductive type is a terminal coalgebra of an endofunctor.

## Examples

1. Streams -- infinite sequences of elements
2. Infinite trees -- trees with branches that may be infinite
3. Conatural numbers -- the coinductive counterpart to natural numbers

## Challenges in HoTT

The universal property defining (internal) coinductive types in HoTT is dual to the one defining
(internal) inductive types. However, the rules for external W-types cannot be dualized in a naive way,
due to some asymmetry of HoTT related to dependent types as maps into a 'type of types' (a universe).

The proposed solution involves constructing coinductive types from indexed inductive types.

## Related Concepts

- Coinduction and corecursion
- Coinductive definitions
- Higher coinductive types
- Codependent type theory
