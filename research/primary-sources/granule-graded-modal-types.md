# Granule and Graded Modal Types

## Key Papers

### Orchard, D., Liepelt, V.B., and Eades III, H. (2019).
Quantitative Program Reasoning with Graded Modal Types. ICFP 2019.

### Petricek, T., Orchard, D., and Mycroft, A. (2014).
Coeffects: A Calculus of Context-Dependent Computation. ICFP 2014.

### Gaboardi, M., Katsumata, S., Orchard, D., Breuvart, F., and Uustalu, T. (2016).
Combining Effects and Coeffects via Grading. ICFP 2016.

## Granule Language

A functional programming language with:
- Linear type system as foundation
- Graded modal types for fine-grained effects and coeffects
- Captures intensional properties (how a program computes, not just what)

## Graded Modalities

- Graded necessity/comonads for coeffects (properties of inputs)
- Graded possibility/monads for effects (properties of outputs)
- Indexed family of modalities with algebraic structure on indices
- Modelled by graded exponential comonads

## Coeffect Systems

- Dual to effect systems
- Capture dataflow of values by annotating variables with semiring elements
- Track context dependence: liveness analysis, implicit parameters, caching
- Semantics via indexed comonads

## Sources
- Granule project: https://granule-project.github.io/
- ICFP 2019 paper: https://www.cs.kent.ac.uk/people/staff/dao7/publ/granule-icfp19.pdf
