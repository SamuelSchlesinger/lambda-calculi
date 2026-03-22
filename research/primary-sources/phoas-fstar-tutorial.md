# Higher-Order Abstract Syntax and Parametric HOAS
# Source: F* Tutorial
# URL: https://fstar-lang.org/tutorial/book/part2/part2_phoas.html

## HOAS Core Idea

HOAS leverages the host language's binding mechanisms. Rather than syntactically
encoding variable binding (e.g., through de Bruijn indexes), HOAS uses the
meta-language's lambda abstractions to represent object-language binders.

## HOAS in F*

```fstar
type term : typ -> Type =
  | Lam : #t1:typ -> #t2:typ ->
          (denote_typ t1 -> term t2) ->
          term (Arrow t1 t2)
```

The `Lam` constructor accepts a function `denote_typ t1 -> term t2`,
embedding variable binding directly.

## Exotic Terms Problem

Direct HOAS can encode "exotic terms" -- syntactically valid constructions
that don't correspond to genuine object-language programs (e.g., a function
that case-splits on the structure of its variable argument).

## PHOAS Solution

```fstar
type term0 (v: typ -> Type) : typ -> Type =
  | Var : #t:typ -> v t -> term0 v t
  | Lam : #t1:typ -> #t2:typ ->
          (v t1 -> term0 v t2) ->
          term0 v (Arrow t1 t2)

let term (t:typ) = v:(typ -> Type) -> term0 v t
```

PHOAS introduces a type parameter `v` representing the representation of
variables. The type `term` is universally quantified over all possible variable
representations, ensuring only legitimate terms are representable via parametricity.

## Denotational Semantics with PHOAS

```fstar
let rec denote_term (#t:typ) (e:term t)
  : Tot (denote_typ t)
  = match e with
    | Var x -> x
    | Lam f -> fun x -> denote_term (f x)
```

Function application in the object language directly maps to host language
function application. Variable binding is handled transparently.
