# Scott 1969--1972 -- Domain Theory and Models of Lambda Calculus

## Key Publications

- Scott, D.S. (1969). "Lattice-theoretic models for the lambda-calculus." Unpublished manuscript.
- Scott, D.S. (1970). "Outline of a mathematical theory of computation."
  4th Annual Princeton Conference on Information Sciences and Systems, 169--176.
- Scott, D.S. (1972). "Continuous lattices." In *Toposes, Algebraic Geometry and Logic*,
  Lecture Notes in Mathematics, Vol. 274, Springer, 97--136.
- Scott, D.S. (1976). "Data types as lattices." *SIAM Journal on Computing*, 5(3), 522--587.

## The Problem

The fundamental challenge: to give the untyped lambda calculus a mathematical
(set-theoretic/topological) semantics, one needs a domain D that is isomorphic to
its own function space D -> D. In naive set theory, this is impossible for
cardinality reasons when D has more than one element.

## Scott's Solution (November 1969)

While visiting Oxford to work with Christopher Strachey, Scott proved on a
"quiet Saturday in November 1969" that:

1. If domains D and E have a countable basis of finite elements, then so does
   the continuous function space [D -> E].

2. Restricting to *continuous* functions (rather than all functions), one can
   construct a domain D_infinity as the inverse limit of a chain:

   D_0 <- D_1 <- D_2 <- ...

   where D_{n+1} = [D_n -> D_n] (the space of continuous functions from D_n to D_n).

3. The limit D_infinity is naturally isomorphic to [D_infinity -> D_infinity],
   providing the first mathematical model of the untyped lambda calculus.

## Key Concepts

- **Complete partial order (cpo)**: A partially ordered set with a least element
  (bottom) in which every directed subset has a supremum.
- **Continuous function**: A monotone function that preserves directed suprema.
- **Scott topology**: The topology on a cpo whose open sets are upward-closed sets
  that are inaccessible by directed suprema.
- **Scott domain**: A cpo that is algebraic (every element is the supremum of
  compact elements below it) and has a countable basis.

## Significance

Scott's construction resolved a 30-year open problem and founded denotational
semantics of programming languages. It showed that the untyped lambda calculus
has non-trivial mathematical models, providing a bridge between syntax and semantics.

## Other Models

Later models include:
- P(omega) models (Scott 1976)
- Graph models / Engeler algebras (Engeler 1981)
- Filter models
- Categorical models (see Barendregt Ch. 5)
