# Elaboration Zoo
# András Kovács
# URL: https://github.com/AndrasKovacs/elaboration-zoo

## Project Structure

Series of Haskell implementations for elaborating dependently typed languages,
with progressively more features:

- 01-eval-closures-debruijn: Evaluation with closures and de Bruijn indices
- 01-eval-closures-names: Evaluation with closures and names
- 01-eval-HOAS-names: Evaluation with HOAS and names
- 02-typecheck-closures-debruijn: Type checking with closures and de Bruijn indices
- 02-typecheck-closures-names: Type checking with closures and names
- 02-typecheck-HOAS-names: Type checking with HOAS and names
- 03-holes: Elaborator with holes and pattern unification
- 04-implicit-args: Implicit argument handling
- 05-pruning: Pruning techniques for meta-variable solving
- 06-first-class-poly: First-class polymorphism

## Core Design

Based on Coquand's algorithm ("elaboration with normalization-by-evaluation"
or "semantic elaboration"). This is becoming the de facto standard design
for dependently typed elaboration.

## Key Implementation Techniques

- NbE for conversion checking
- Pattern unification for meta-variable solving
- Bidirectional type checking
- Implicit argument insertion
- Pruning for meta-variable dependencies

## Related Project: smalltt

Demo for high-performance type theory elaboration, also by Kovács.
Demonstrates that dependent type checking can be made very fast with
careful engineering.
