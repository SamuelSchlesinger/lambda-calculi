# De Bruijn Representation for Simply Typed Lambda Calculus

## Key Reference

de Bruijn, Nicolaas Govert. "Lambda calculus notation with nameless dummies,
a tool for automatic formula manipulation, with application to the Church-Rosser theorem."
*Indagationes Mathematicae*, 34, pp. 381-392, 1972.

## Overview

De Bruijn indices replace named bound variables with natural numbers that indicate
how many enclosing binders to count to find the corresponding binding site.

## Syntax

Types:
  T ::= B | T1 -> T2

Contexts (as lists of types):
  Gamma ::= . | Gamma, T

Terms:
  e ::= n | e1 e2 | lambda e

where n is a natural number (the de Bruijn index).

## Examples

| Named representation    | De Bruijn representation |
|-------------------------|--------------------------|
| lambda x. x            | lambda 0                 |
| lambda x. lambda y. x  | lambda (lambda 1)        |
| lambda x. lambda y. y  | lambda (lambda 0)        |
| lambda f. lambda x. f x| lambda (lambda (1 0))    |

## Typing with De Bruijn Indices

Variables are represented as lookup judgments into the context:

  Gamma |- 0 : T     if Gamma = Gamma', T
  Gamma |- n+1 : T   if Gamma = Gamma', S  and  Gamma' |- n : T

In Agda (from PLFA):

```
data _ni_ : Context -> Type -> Set where
  Z : forall {Gamma A} -> (Gamma , A) ni A
  S : forall {Gamma A B} -> Gamma ni A -> (Gamma , B) ni A
```

## Substitution

Substitution in de Bruijn notation requires "shifting" (incrementing free variable
indices when passing under binders):

  shift(d, c, n) = n           if n < c
  shift(d, c, n) = n + d       if n >= c
  shift(d, c, lambda e) = lambda (shift(d, c+1, e))
  shift(d, c, e1 e2) = shift(d, c, e1) shift(d, c, e2)

Single substitution [n := s] e:
  [n := s] m = s               if m = n
  [n := s] m = m               if m /= n (with appropriate shifting)
  [n := s] (lambda e) = lambda ([n+1 := shift(1, 0, s)] e)
  [n := s] (e1 e2) = ([n := s] e1) ([n := s] e2)

## Intrinsically Typed de Bruijn Terms

In the intrinsically typed representation (as used in PLFA), terms are indexed
by both their context and type. This means that substitution is type-preserving
by construction -- ill-typed terms cannot even be represented.

## Advantages

1. Alpha-equivalence is syntactic equality
2. No need for alpha-conversion during substitution
3. Canonical representatives for equivalence classes of terms
4. Natural fit for mechanized metatheory in proof assistants
5. Context becomes a simple list of types (no variable names needed)

Source: https://plfa.github.io/DeBruijn/
