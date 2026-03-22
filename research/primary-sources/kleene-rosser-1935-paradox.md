# Kleene and Rosser 1935 -- The Kleene-Rosser Paradox

## Citation

Kleene, S.C. and Rosser, J.B. (1935). "The Inconsistency of Certain Formal Logics."
*Annals of Mathematics*, 36(3), 630--636.

## Summary

Stephen Kleene and J. Barkley Rosser, both students of Alonzo Church, demonstrated
that Church's original formal systems from 1932 and 1933 were inconsistent. Using
Godel's technique of arithmetizing syntax, they showed that Richard's paradox could
be derived within Church's system.

The key insight was that Church's systems were able to characterize and enumerate
their provably total, definable number-theoretic functions, which enabled the
construction of a self-referential term replicating Richard's paradox.

## Consequence

This result forced Church to abandon his original goal of a comprehensive foundation
for mathematics based on lambda calculus. However, Church, Kleene, and Rosser
responded by extracting the pure lambda calculus -- the portion dealing solely with
function abstraction and application -- and proving its consistency via the
Church-Rosser theorem (1936).

## Also Applies To

The paradox also applies to Haskell Curry's combinatory logic (introduced 1930),
demonstrating that it too is inconsistent when extended with certain logical axioms.
