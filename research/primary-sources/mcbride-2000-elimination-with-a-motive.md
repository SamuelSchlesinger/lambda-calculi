# McBride 2000 — Elimination with a Motive

**Full Citation:**
Conor McBride. "Elimination with a Motive." In *Types for Proofs and Programs
(TYPES 2000)*, LNCS vol. 2277, pp. 197–216. Springer, 2002.

**Source:** https://link.springer.com/chapter/10.1007/3-540-45842-5_13

**Accessible summary:** http://web.mit.edu/~ezyang/Public/motive/motive.html

## Summary

McBride argues that elimination rules should be parametrized by the *goal* (the
"motive") rather than just producing immediate consequences. The paper's slogan:
"we should exploit a hypothesis not in terms of its immediate consequences, but in
terms of the leverage it exerts on an arbitrary goal."

## Key Contributions

### 1. The Motive as a Predicate

An elimination rule with an indexed motive variable P justifies a kind of pattern
analysis that "matches" P's arguments in the conclusion (goal patterns) against P's
arguments in the premises (subgoal patterns), with P's arguments in inductive
hypotheses (recursion patterns) allowing recursive calls.

For natural numbers, the motive P : Nat -> Type turns induction into:
```
nat_elim : (P : Nat -> Type) -> P 0 -> ((n : Nat) -> P n -> P (S n)) -> (n : Nat) -> P n
```

### 2. Indexed Motives for Relations

For inductively defined relations (like `le : Nat -> Nat -> Prop`), the motive
must account for indices:
```
le_elim : (P : Nat -> Nat -> Prop) ->
          (forall n, P n n) ->
          (forall m n, le m n -> P m n -> P m (S n)) ->
          forall m n, le m n -> P m n
```

When the eliminated hypothesis is instantiated (e.g., `le m 0`), McBride's
technique introduces equations to constrain the motive.

### 3. The Equation-Generalization Technique

To perform elimination on an instantiated hypothesis, one must:
1. Generalize over the concrete indices, replacing them with variables
2. Add equality constraints between the variables and the original indices
3. Apply the elimination principle with this generalized motive
4. In each branch, use the equality constraints to recover type information

This is exactly the technique implemented by Coq's `dependent induction` tactic
and is the precursor to the convoy pattern.

### 4. JMeq (John Major Equality)

McBride introduced heterogeneous equality to handle cases where equations between
values of different types arise:
```
JMeq : (A : Type) -> A -> (B : Type) -> B -> Prop
```
This allows stating `xs == xxs` even when `xs : Vec A n` and `xxs : Vec A (S m)`.
JMeq is equivalent to Martin-Löf equality plus axiom K.

## Significance

This paper provides the conceptual bridge between raw eliminators and dependent
pattern matching. It shows that pattern matching is, at its core, elimination with
a suitably chosen motive. The equation-generalization technique became the standard
method for implementing dependent pattern matching in proof assistants.
