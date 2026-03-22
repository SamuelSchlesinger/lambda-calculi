# Church (1940): A Formulation of the Simple Theory of Types

## Citation
Church, Alonzo. "A Formulation of the Simple Theory of Types."
*The Journal of Symbolic Logic*, Volume 5, Issue 2, pp. 56-68, 1940.
DOI: 10.2307/2266170

PDF available at: https://www.classes.cs.uchicago.edu/archive/2007/spring/32001-1/papers/church-1940.pdf

## Summary

This is the foundational paper introducing the simply typed lambda calculus. Church
developed the system as an attempt to avoid the paradoxical uses of the untyped lambda
calculus that he had encountered in his earlier work (1932-1933), where the untyped system
was shown to be inconsistent (able to derive Russell's paradox).

## Type System

Church assigns all expressions types using a subscript notation:
- iota (i) symbolizes the type of individuals
- omicron (o) symbolizes the type of truth values (propositions)
- If alpha and beta are type-symbols, then (alpha beta) is the type-symbol for
  functions from entities of type beta to entities of type alpha

Note: Church's convention for the arrow direction is the reverse of modern convention.
In modern notation, (alpha beta) would be written beta -> alpha.

## Key Features

- Uses lambda calculus to represent typed entities as functions qua rules of correspondence
  (not as sets or classes)
- Well-formed expressions are limited so that no expression's type is formed only from
  expressions of that identical type, preventing Russell's paradox
- The system includes an axiom of extensionality and a description operator
- Church adopted Schoenfinkel/Curry's method of reducing n-ary functions to iterated
  monadic functions (currying)

## Historical Context

- Church initially developed untyped lambda calculus (1932-1933) as a foundation for
  mathematics
- Kleene and Rosser (1935) showed the untyped system was inconsistent
- Church then developed the typed version (1940) to avoid paradoxes
- The simple theory of types builds on ideas from Russell's ramified type theory but
  simplifies it by removing the hierarchy of orders
