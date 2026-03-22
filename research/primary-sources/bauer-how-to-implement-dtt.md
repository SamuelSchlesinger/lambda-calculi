# How to Implement Dependent Type Theory I & II
# Andrej Bauer
# URL: https://math.andrej.com/2012/11/08/how-to-implement-dependent-type-theory-i/

## Variable Representation (OCaml)

Three-variant approach:
```ocaml
type variable =
 | String of string       (* user-typed identifiers *)
 | Gensym of string * int (* generated fresh variables *)
 | Dummy                  (* unused variables *)
```

Gensym with unique integers prevents capture during substitution.

## Context Management

```ocaml
type context = (Syntax.variable * (Syntax.expr * Syntax.expr option)) list
```

Association list mapping variables to (type, optional-definition) pairs.
New bindings shadow existing ones for natural scoping.

## Type Checking Strategy

Type inference (not checking), with five core rules:
1. Variables: lookup in context
2. Universes: Type_k has type Type_(k+1)
3. Products: type depends on universe levels of domain and codomain
4. Lambdas: infer type as dependent product
5. Application: perform substitution in result type

## Normalization

Beta-reduction and definition unfolding, normalizing under binders.
Two-step equality check: normalize then syntactically compare.

## Practical Observation

Of 618 lines total, only 92 lines are core logic. Infrastructure
(parsing, pretty-printing, REPL) dominates.
