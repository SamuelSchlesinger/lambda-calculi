# Normalization by Evaluation Four Ways
# William J. Bowman
# URL: https://williamjbowman.com/tmp/nbe-four-ways/

## The Four NbE Designs

### Choice {1,1}: Intensional Residualizing Readback Semantics
- Extends Value domain with NeutralValue (variables or applications)
- Evaluator accepts neutrals
- Separate readback converts values to expressions without type information
- Produces β-normal forms only

### Choice {1,2}: Intensional Residualizing Reify Semantics
- Calls reify eagerly within the application operation
- Evaluator and normalizer are mutually recursive
- Neutral terms guaranteed to be expressions by construction
- Produces β-normal forms only

### Choice {2}: Extensional (Meta-circular) Semantics
- Preserves original meta-circular semantics
- Introduces reflect and reify functions parameterized by types
- Models η-equivalence naturally
- Produces βη-normal forms

### Choice {3}: Extensional Residualizing Semantics
- Uses explicit closure structures instead of meta-circular functions
- Neutral values wrapped as (reflect Type Neutral) to preserve type information
- Produces βη-normal forms

## Key Design Decisions

The fundamental choice: handling the type mismatch when reifying semantic functions.
A semantic function cannot be directly applied to a syntactic variable.

1. Should the evaluator be modified to accept non-procedure values, or should
   reification handle the conversion?
2. If modifying the evaluator, should neutral terms embed raw Values or reified Expressions?
3. Should the semantics use meta-circular functions or explicit closure structures?

## Key Distinction
- Intensional approaches: β-normal forms only
- Extensional approaches: βη-normal forms, require type annotations on reification
