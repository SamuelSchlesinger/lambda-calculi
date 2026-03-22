# Coinductive Types and Corecursive Functions in Coq/Rocq

Source: https://rocq-prover.org/refman/language/core/coinductive.html

## CoInductive Type Definition

Syntax:
  CoInductive [identifier] : [type] := [constructor_definitions]

Unlike inductive types, coinductive types admit infinite objects.
No induction principles are derived; only case analysis elimination is available.

## Stream Example

```coq
CoInductive Stream : Set := Seq : nat -> Stream -> Stream.

Definition hd (x:Stream) := let (a,s) := x in a.
Definition tl (x:Stream) := let (a,s) := x in s.
```

## Coinductive Predicates (Bisimulation)

```coq
CoInductive EqSt : Stream -> Stream -> Prop :=
  eqst : forall s1 s2:Stream,
    hd s1 = hd s2 -> EqSt (tl s1) (tl s2) -> EqSt s1 s2.
```

## CoFixpoint

Syntax:
  CoFixpoint [name] [binders] : [type] := [term]

Guardedness Condition: each recursive call must be protected by at least one
constructor, and only by constructors.

Valid:
```coq
CoFixpoint from (n:nat) : Stream := Seq n (from (S n)).
```

Invalid (filter -- unguarded recursive call in else branch):
```coq
CoFixpoint filter (p:nat -> bool) (s:Stream) : Stream :=
  if p (hd s) then Seq (hd s) (filter p (tl s))
  else filter p (tl s).  (* REJECTED *)
```

## Reduction Semantics

Corecursive definitions reduce lazily -- expansion occurs only when the definition
is at the head of an application which is the argument of a case analysis expression.

```coq
Eval compute in (hd (from 0)).  (* = 0 : nat *)
Eval compute in (tl (from 0)).  (* = (cofix from...) 1 : Stream *)
```

## Negative Coinductive Types (Primitive Projections)

Since Coq 8.5, primitive record syntax preserves subject reduction:

```coq
Set Primitive Projections.
CoInductive Stream : Set := Seq { hd : nat; tl : Stream }.
```

Propositional eta-equality can be recovered through an axiom.
