# Non-Well-Founded Set Theory

Source: https://plato.stanford.edu/entries/nonwellfounded-set-theory/

## Aczel's Anti-Foundation Axiom (AFA)

Formulated by Forti and Honsell (1983) and systematized by Aczel (1988).

AFA states: Every accessible pointed graph has a unique decoration.

This replaces the Foundation Axiom in ZFA, enabling circular object definitions
while maintaining consistency.

## Connection to Coalgebras

The document establishes a categorical duality:
- Algebras (initial): model bottom-up construction via recursion
- Coalgebras (final): model top-down observation via corecursion

The final coalgebra theorem shows that greatest fixed points of polynomial
functors correspond to final coalgebras, enabling corecursive definitions
without explicit base cases.

## Bisimulation Equivalence

Two graph nodes decorate identically if and only if a bisimulation relates them --
providing a unified framework for self-similar structures and recursive domain equations.

## Applications

AFA gives tools for modeling circular phenomena: self-referential sets,
streams (infinite sequences), infinite trees. The equation x = {x} has
exactly one solution (the Quine atom).
