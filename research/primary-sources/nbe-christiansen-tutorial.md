# Checking Dependent Types with Normalization by Evaluation: A Tutorial
# David Christiansen
# URL: https://davidchristiansen.dk/tutorials/nbe/

## Overview

Tutorial deriving a normalizer from an evaluator through two steps:
1. Evaluating expressions in a runtime environment to produce values
2. Reading those values back into normal form syntax (reification/readback)

## Key Technical Details

### Syntax vs Values
- Expressions follow lambda-calculus grammar
- Values represent only normalizable forms (no redexes)
- Critical separation enables the NbE approach

### Evaluation with Environments
- CLOS structure: packages unevaluated expression with its creation environment and bound variable
- Runtime environment (ρ): association list mapping variables to values
- Two procedures: `val` evaluates expressions; `do-ap` applies function values to arguments

### Neutral Terms
To handle free variables:
- N-var: represents a variable without a value
- N-ap: represents application where function position is neutral
- Enable normalization under binders

### Read-Back (Reification)
For closures:
1. Generate fresh variable name using `freshen`
2. Create neutral value for that variable
3. Recursively evaluate closure body with fresh variable bound
4. Read back result and wrap in λ-expression

### Bidirectional Type Checking
Two judgment forms:
- Synthesis (⇒): derives type from expression
- Checking (⇐): verifies expression has given type

Rules:
- Variables and eliminations support synthesis
- Constructors (λ, zero, add1) require checking
- Type annotations (`the`) bridge synthesis and checking

### Type Equality via Normalization
For dependent types where types contain programs, type equality is
checked by comparing normal forms via `convert`.
