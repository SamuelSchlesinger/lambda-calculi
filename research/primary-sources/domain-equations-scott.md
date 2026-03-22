# Domain Equations and Recursive Types

## Historical Context

Dana Scott developed domain theory in the late 1960s-1970s to provide a mathematical
model for the untyped lambda calculus and to give a foundation for denotational semantics
(building on the work of Christopher Strachey).

## The Key Problem

Scott needed to solve the "domain equation" D ≅ [D → D], finding a domain that is
isomorphic to its own function space. This was previously thought impossible on
cardinality grounds for sets, but Scott showed it was possible in the category of
continuous lattices (later generalized to various categories of domains).

## Domain Equations as Recursive Types

Recursive types correspond to solutions of domain equations:
- μα. 1 + α       corresponds to the natural numbers
- μα. 1 + A × α   corresponds to lists of A
- μα. A + α × α   corresponds to binary trees with A at leaves

The equation D ≅ [D → D] is the domain-theoretic analogue of an unrestricted
recursive type μα. α → α.

## Fixed-Point Theorems

Solutions to domain equations are obtained via fixed-point constructions:
- Working with continuous functions between complete partial orders (CPOs)
- Using Tarski's fixed-point theorem for monotone functions on complete lattices
- Or via categorical colimit constructions (Adamek's theorem)

## Connection to Type Theory

- Least fixed points correspond to inductive types (initial algebras)
- Greatest fixed points correspond to coinductive types (terminal coalgebras)
- General recursive types correspond to solutions of domain equations that may
  not have a clear inductive/coinductive character

## Key References

- Dana Scott. "Continuous Lattices." In Toposes, Algebraic Geometry and Logic,
  Springer LNM 274, 1972.
- Dana Scott. "Data Types as Lattices." SIAM Journal on Computing, 5(3), 1976.
- Michael Smyth and Gordon Plotkin. "The Category-Theoretic Solution of
  Recursive Domain Equations." SIAM J. Comput. 11(4), 1982.
- Samson Abramsky and Achim Jung. "Domain Theory." In Handbook of Logic in
  Computer Science, Vol. 3, Oxford University Press, 1994.
