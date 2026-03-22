# Dependent Pattern Matching

## Overview

Dependent pattern matching is the mechanism by which functions and proofs are defined
by case analysis and structural recursion in dependently typed languages. Unlike
pattern matching in ML or Haskell, where matching on a constructor only reveals the
constructor's arguments, dependent pattern matching also *refines types*: matching on
a constructor of an indexed inductive family constrains the indices, and this
constraint propagates to the types of all other variables in scope.

Dependent pattern matching provides a high-level, human-readable notation that
replaces the verbose and unintuitive use of raw eliminators (recursors). The
relationship between these two formulations — and the conditions under which they are
equivalent — is one of the central questions in the metatheory of dependently typed
languages.

**Cross-references:** This document extends the elimination principles for inductive
types described in Doc 07 (CIC), particularly Sections 7.1–7.3 on `match` expressions
and dependent elimination. The typing rules for the underlying calculus are in Doc 06
(CoC). Compilation strategies connecting to this material are discussed in Doc 09
(implementation techniques).

---

## 1. Historical Context: From Eliminators to Pattern Matching

### 1.1 Eliminators in Martin-Löf Type Theory

In Martin-Löf's Intuitionistic Type Theory (MLTT) and in CIC (Doc 07), each inductive
type comes equipped with an *elimination principle* (also called a *recursor* or
*induction principle*). For the natural numbers:

```
Nat-elim : (P : Nat -> Type) -> P 0 -> ((n : Nat) -> P n -> P (S n)) -> (n : Nat) -> P n
```

The motive `P` specifies the type of the result as a function of the input. The
eliminator takes a base case (`P 0`) and a step case (`(n : Nat) -> P n -> P (S n)`)
and produces a function defined for all natural numbers.

For an indexed family like vectors (`Vec A n`):

```
Vec-elim : (P : (n : Nat) -> Vec A n -> Type) ->
           P 0 vnil ->
           ((n : Nat) -> (x : A) -> (xs : Vec A n) -> P n xs -> P (S n) (vcons x xs)) ->
           (n : Nat) -> (xs : Vec A n) -> P n xs
```

The motive `P` now depends on both the index `n` and the vector `xs`.

### 1.2 The Usability Problem

While eliminators are logically complete (every definable function can be expressed
using them), they are notoriously difficult to use in practice:

1. **The motive must be given explicitly.** The user must supply the predicate `P`,
   which requires abstracting over the scrutinee and its indices. Getting the motive
   wrong produces inscrutable type errors.

2. **Nested matching is painful.** A function that matches on two arguments requires
   nested applications of eliminators, each with its own motive.

3. **Impossible cases must be handled.** The eliminator forces the user to provide
   branches for all constructors, even when index constraints make some constructors
   impossible. Dismissing impossible cases requires explicit proofs of absurdity.

4. **No direct recursion.** Structural recursion must be expressed through the
   eliminator, losing the direct recursive call syntax familiar from functional
   programming.

### 1.3 Coquand's Innovation (1992)

Thierry Coquand's 1992 paper "Pattern Matching with Dependent Types" introduced a
notation for defining functions in dependent type theory using clausal pattern matching,
in the style of ML and Haskell. The key insight was that matching on a constructor of
an indexed family could *unify the indices*, and this unification could propagate type
information to refine the types of other variables.

For example, instead of using `Vec-elim` with an explicit motive, one writes:

```
head : Vec A (S n) -> A
head (vcons x xs) = x
```

The pattern `vcons x xs` forces the index to be `S n`, and there is no `vnil` case
because `vnil` has index `0`, which cannot unify with `S n`. The system automatically
determines that the `vnil` case is impossible.

---

## 2. Typing Rules for Dependent Pattern Matching

### 2.1 Clausal Definitions

A function defined by dependent pattern matching has the form:

```
f : (x1 : A1) -> ... -> (xn : An) -> B
f p11 ... p1n = e1
f p21 ... p2n = e2
...
f pk1 ... pkn = ek
```

where each `pij` is a *pattern* — either a variable, a constructor applied to
sub-patterns, a dot pattern (inaccessible), or an absurd pattern.

### 2.2 Typing a Single Clause

A clause `f p1 ... pn = e` is well-typed if there exists a substitution `sigma`
such that:

1. The patterns `p1, ..., pn` are well-typed against the argument types `A1, ..., An`
   under `sigma`.
2. The right-hand side `e` has type `B[sigma]` in the context extended with the
   pattern variables.
3. The substitution `sigma` is the most general unifier of the constraints generated
   by matching the patterns against the argument types.

### 2.3 The Case Splitting Judgment

Following Cockx and Abel (2018), the typing of pattern matching can be formalized
through a judgment for *case trees*. A case tree is one of:

- **done(v)**: A leaf node returning value `v`.
- **split(x, [c1 y1 => t1, ..., cn yn => tn])**: A case split on variable `x`,
  branching by constructor `ci` with fresh variables `yi`, continuing with case
  tree `ti`.
- **absurd(x)**: A case split on variable `x` where all constructors are impossible
  (the type is empty after unification).

The typing judgment for case trees is:

```
                    Gamma |- v : A
                ---------------------- [Done]
                Gamma |- done(v) : A


    for each constructor ci of type (yi : Bi) -> D params ixsi:
      Gamma, yi : Bi, [x := ci yi] |- ti : A[x := ci yi]   (after unification of indices)
    ------------------------------------------------------------------- [Split]
    Gamma, x : D params ixs, Delta |- split(x, [...]) : A


    for each constructor ci of type (yi : Bi) -> D params ixsi:
      unification of ixs with ixsi fails
    ------------------------------------------------- [Absurd]
    Gamma, x : D params ixs, Delta |- absurd(x) : A
```

---

## 3. Unification of Indices

### 3.1 The Core Mechanism

When matching on a variable `x : D params i1 ... iq` with a constructor
`c : (y1 : B1) -> ... -> (ym : Bm) -> D params j1 ... jq`, the system must unify
each index `ik` with the corresponding constructor index `jk`:

```
i1 =? j1,  i2 =? j2,  ...,  iq =? jq
```

The resulting substitution refines the types of all variables in scope. If
unification fails (produces a conflict), the constructor is impossible in this
context, and the corresponding branch is omitted.

### 3.2 Unification Rules

The standard first-order unification rules for dependent pattern matching are:

| Rule | Input | Output | Requires K? |
|------|-------|--------|-------------|
| **Solution** | `x =? t` (x fresh) | `[x := t]` | No |
| **Injectivity** | `c s =? c t` | `s =? t` | No |
| **Conflict** | `c s =? d t` (c /= d) | Absurd | No |
| **Cycle** | `x =? t` (x in t, t /= x) | Absurd | No |
| **Deletion** | `t =? t` | Trivial | **Yes** |

The **deletion** rule is the one that requires axiom K. It says: if both sides of
an equation are identical, the equation can be discarded. This seems obviously correct,
but in HoTT, an equation `t = t` may carry non-trivial higher-dimensional content
(a loop in the identity type), so discarding it loses information.

### 3.3 Example: Matching on Vectors

Consider:
```
head : {A : Type} -> {n : Nat} -> Vec A (S n) -> A
head (vcons x xs) = x
```

When checking the clause against the type `Vec A (S n) -> A`:
1. The scrutinee has type `Vec A (S n)`.
2. Constructor `vcons` has type `A -> Vec A m -> Vec A (S m)`.
3. Unify the index: `S n =? S m`.
4. By injectivity of `S`: `n =? m`, solved by `[m := n]`.
5. Constructor `vnil` has type `Vec A 0`.
6. Unify: `S n =? 0`. Conflict! So `vnil` is impossible.

Result: only the `vcons` branch is needed, and in that branch, `m` is replaced
by `n` throughout.

---

## 4. Dot Patterns (Inaccessible / Forced Patterns)

### 4.1 Definition

A **dot pattern** (also called an **inaccessible pattern** or **forced pattern**)
is a pattern position whose value is entirely determined by other patterns through
unification. It is written `.t` in Agda and marked with inaccessibility annotations
in Lean.

Dot patterns do not participate in the actual pattern matching — they are not matched
against at runtime. They serve only to document the type-level constraints and to
make the definition well-typed.

### 4.2 When They Arise

Dot patterns arise when a function argument's value is forced by the dependent type
structure. Consider:

```
data Square : Nat -> Type where
  sq : (m : Nat) -> Square (m * m)
```

A function on `Square n` must have:
```
f : Square n -> ...
f (sq m) = ...     -- here n is forced to be m * m
```

In Agda, one writes `f {.(m * m)} (sq m) = ...` to mark the forced index `n = m * m`
as a dot pattern.

### 4.3 Formal Role

In the typing rules, dot patterns are checked but not matched:
- A dot pattern `.t` is well-typed if `t` has the expected type.
- It generates no case split and no pattern variables.
- It serves as documentation that the value at this position is determined.

In Agda, dot patterns are often optional — the system can infer them. In Lean,
inaccessible patterns are marked when needed but the equation compiler handles
most cases automatically.

---

## 5. The "with" Abstraction and the Convoy Pattern

### 5.1 The "with" Abstraction

The "with" construct, introduced by McBride and McKinna (2004), allows pattern
matching on the result of an intermediate computation. The syntax (in Agda) is:

```
filter : {A : Type} -> (A -> Bool) -> List A -> List A
filter p []       = []
filter p (x :: xs) with p x
... | true  = x :: filter p xs
... | false = filter p xs
```

**Semantics:** A with-abstraction `f args with e` is elaborated by:
1. Evaluating `e` to get an intermediate value.
2. Abstracting the goal type and all argument types over `e` (replacing all
   occurrences of `e` in types with a fresh variable).
3. Creating an auxiliary function that takes the value of `e` as an extra argument.
4. Pattern matching on this extra argument in the auxiliary function.

The key operation is **generalization**: all occurrences of `e` in the types of the
goal and arguments are replaced by a fresh variable. This ensures that the type
information flows correctly when `e` is matched against patterns.

### 5.2 The Convoy Pattern

The **convoy pattern** is a technique for dependent pattern matching in Coq (and
other systems that lack a built-in "with" construct) that threads type-level
information through a match expression by returning a function.

The problem: when matching on a value `x` on which other values' types depend, the
match expression's return type must be carefully specified to convey the information
gained from matching.

```coq
(* Without convoy pattern — FAILS *)
Definition head (n : nat) (v : Vec A (S n)) : A :=
  match v with
  | vcons x xs => x   (* Type error: Coq doesn't know n = S m *)
  end.

(* With convoy pattern — WORKS *)
Definition head (n : nat) (v : Vec A (S n)) : A :=
  match v in Vec _ m return match m with S _ => A | 0 => unit end with
  | vnil       => tt
  | vcons x xs => x
  end.
```

The return type annotation `match m with S _ => A | 0 => unit end` conveys that:
- In the `S _` case (which is the one we care about), the result is `A`.
- In the `0` case (which is impossible but must be handled syntactically), the
  result can be anything (here `unit`).

More generally, the convoy pattern works by:
1. Adding dependent values to the return annotation of the match.
2. Returning a *function* from the match that takes those dependent values as
   arguments.
3. Immediately applying the function to the actual dependent values after the match.

This forces Coq to specialize the types in each branch based on what the match
reveals.

### 5.3 Relationship

The "with" abstraction in Agda automates what the convoy pattern does manually in
Coq. Both solve the same problem: making type information gained from matching
available in the branches.

---

## 6. Case Trees: Compilation of Nested Patterns

### 6.1 From Clauses to Case Trees

A function defined by multiple clauses with nested patterns must be compiled into
a *case tree* — a decision tree that examines one variable at a time. This is the
standard compilation strategy for pattern matching, adapted to the dependent setting.

The compilation algorithm (based on Augustsson 1985, adapted by Coquand 1992 and
refined by Cockx and Abel 2018) works as follows:

**Input:** A list of clauses `[p1 => e1, ..., pk => ek]` and a context `Gamma`
with target type `A`.

**Algorithm:**
1. **Variable rule:** If all first patterns are variables, bind them and recurse on
   the remaining patterns.
2. **Constructor rule:** If some first patterns are constructors, pick a variable to
   split on. For each constructor `c` of that variable's type:
   a. Compute the unifier of the constructor's indices with the expected indices.
   b. If unification fails, this constructor is impossible — skip it.
   c. If unification succeeds, apply the substitution to the context and remaining
      clauses.
   d. Filter out clauses whose first pattern conflicts with `c`.
   e. Specialize remaining clauses (replace the constructor pattern with its
      argument patterns).
   f. Recurse.
3. **Empty rule:** If no clauses remain and no constructor is possible, emit
   `absurd`. If no clauses remain but some constructor is possible, report a
   coverage error.

**Output:** A well-typed case tree.

### 6.2 First-Match Semantics

User-written clauses have *first-match semantics*: patterns are tried top-to-bottom,
and the first matching clause fires. The case tree compilation must preserve this
semantics.

Cockx and Abel (2018) showed that the naive "shortcut rule" — where a clause can fire
even if it does not strictly match all earlier clauses, as long as the result would
be the same — is *unsound* for well-typed case trees. This discovery uncovered a real
bug in Agda (#2964) that broke subject reduction.

The correct approach is to emit case trees that precisely capture the first-match
order, potentially duplicating some clauses across branches.

### 6.3 Relationship to Non-Dependent Case Trees

In non-dependent languages (ML, Haskell), case tree compilation is a well-studied
problem (Augustsson 1985, Wadler 1987, Maranget 2008). The dependent setting adds
two complications:

1. **Index unification:** Each case split must unify indices, and the resulting
   substitution changes the types of all subsequent variables.
2. **Well-typedness of the tree:** The case tree itself must be type-checked,
   not just the leaves. Each split must produce a well-typed sub-tree in the
   refined context.

---

## 7. Coverage Checking with Dependent Types

### 7.1 The Problem

Coverage checking (exhaustiveness checking) ensures that a set of clauses handles all
possible inputs. In the dependent setting, this is more subtle than in ML:

- Some constructors may be *impossible* due to index constraints.
- The type of later arguments may depend on earlier ones, so the set of possible
  patterns for later arguments depends on which constructor was matched for earlier ones.
- In general, coverage checking is *undecidable* (it reduces to higher-order
  unification in the worst case).

### 7.2 Practical Approach

In practice, coverage checking proceeds alongside case tree construction:
1. Try to split on a variable.
2. For each constructor, check if unification succeeds.
3. If unification succeeds, recurse with the specialized clauses.
4. If unification fails for all constructors, the variable's type is empty in
   this context — no clause is needed.
5. If unification succeeds for some constructor but no clause covers it, report
   a missing case.

### 7.3 Interaction with Unification

Coverage checking depends critically on the power of the unification algorithm.
A stronger unification algorithm can determine more constructors to be impossible,
leading to fewer required cases. Conversely, a weaker algorithm may require the user
to provide more cases or to add explicit absurd patterns.

---

## 8. The Goguen-McBride-McKinna Algorithm

### 8.1 Overview

Goguen, McBride, and McKinna (2006) gave a *reduction-preserving translation* from
Coquand's dependent pattern matching into a traditional type theory with:
- Universes
- Inductive types and relations
- The axiom K (uniqueness of identity proofs)

This translation establishes that dependent pattern matching is a *conservative
extension* of the underlying type theory (modulo K).

### 8.2 The Translation

The algorithm translates a case tree into eliminator applications:

1. **Leaf nodes** translate to the right-hand side expression.
2. **Case splits** translate to applications of the inductive type's eliminator,
   with the motive derived from the case tree's target type.
3. **Index refinements** translate to applications of J (identity elimination) and
   K to transport values along the index equations.

For a split on `x : Vec A (S n)`:
- Apply `Vec-elim` with a motive that captures the target type.
- In the `vnil` branch: use the index equation `S n = 0` to derive absurdity
  (by `Nat-conflict`).
- In the `vcons` branch: use J to transport along `S n = S m`, then K to
  simplify `m = m` to `refl`.

### 8.3 Reduction Preservation

The translation preserves definitional equality: if `f (c args) = e` is a
clause of the original definition, then the translated term applied to `c args`
reduces (by iota-reduction of the eliminator) to the translation of `e`.

This means the compiled definition has the same computational behavior as the
original pattern matching definition.

---

## 9. Axiom K and Its Role in Pattern Matching

### 9.1 Statement of Axiom K

Axiom K (also called Streicher's axiom K, or the uniqueness of identity proofs
principle, UIP) states:

```
K : (A : Type) -> (x : A) -> (p : x = x) -> p = refl
```

Equivalently:
```
UIP : (A : Type) -> (x y : A) -> (p q : x = y) -> p = q
```

These two formulations are equivalent in the presence of J (path induction).

### 9.2 Why Pattern Matching Needs K

Consider matching on a proof of `n = n`:
```
f : (n : Nat) -> n = n -> ...
f n refl = ...
```

To check this clause, the system must unify the equation `n = n` with `refl : x = x`.
This requires:
1. Unifying `n` with `x` (solution rule): `[x := n]`.
2. After substitution, we have `n = n` matching `refl : n = n`.
3. The deletion rule says: the equation `n = n` is trivially true, so we can
   substitute `refl` for the proof variable.

Step 3 is exactly axiom K. Without K, we cannot assume that a proof of `n = n` must
be `refl` — it could be a non-trivial loop.

### 9.3 Where K Appears Implicitly

K appears in dependent pattern matching whenever:
- A variable appears in two index positions that are unified to be equal.
- An identity proof is matched against `refl` when neither endpoint is a fresh
  variable.
- The deletion rule is applied during index unification.

### 9.4 Hofmann-Streicher Groupoid Model

Hofmann and Streicher (1994) constructed a model of type theory (the groupoid
interpretation) in which J is valid but K fails. This proved that K is independent
of the standard rules of type theory — it is an additional axiom, not a consequence
of J.

In this model, types are interpreted as groupoids (categories where every morphism
is an isomorphism), and identity proofs are interpreted as morphisms. A type can
have multiple distinct morphisms from an object to itself (automorphisms), violating
UIP.

### 9.5 K and Consistency

Axiom K is *consistent* with CIC and MLTT — adding it does not lead to contradictions.
Many proof assistants (Coq, Lean) include K or equivalent principles by default.
However, K is *incompatible* with certain extensions:
- Univalence (from HoTT)
- Higher inductive types
- Any semantics where types have non-trivial homotopy structure

---

## 10. Pattern Matching without K

### 10.1 Motivation: HoTT Compatibility

Homotopy Type Theory (HoTT) interprets types as homotopy types (spaces up to
homotopy equivalence) and identity proofs as paths. Under univalence, the identity
type `A = B` in a universe is equivalent to the type of equivalences `A ≃ B`, which
can be non-trivial. This directly contradicts K.

To use dependent pattern matching in a HoTT-compatible type theory, one needs a
criterion for determining which pattern matching definitions are valid without K.

### 10.2 Cockx-Devriese-Piessens Criterion (2014)

Cockx, Devriese, and Piessens proposed a criterion: a definition is K-free if
every unification step used during case splitting can be justified without the
deletion rule.

The key insight is that the deletion rule (`t = t` is trivial) is the *only*
standard unification rule that requires K. All other rules — solution, injectivity,
conflict, cycle detection — are justified by the standard identity elimination
rule J.

A definition is K-free if:
- No unification step uses deletion.
- Equivalently, every equation solved during case splitting has at least one
  "flexible" side (a fresh variable not constrained by other patterns).

### 10.3 Proof-Relevant Unification (Cockx-Abel, 2018)

Cockx and Abel strengthened this approach by making unification *proof-relevant*:
each unification rule produces not just a substitution but also a proof of
equivalence between the original constraint set and the simplified constraint set.

This framework:
- Guarantees soundness by construction: only rules with valid proofs are accepted.
- Is modular: new rules can be added safely.
- Supports additional features like eta-equality for records and higher-dimensional
  unification rules.

### 10.4 Practical Impact

The K-free criterion has been implemented in:
- **Agda** (`--without-K` flag, later `--cubical` mode)
- **Coq/Equations** (optional K-free mode)
- The criterion allows most practical definitions to go through without K, since
  most pattern matching does not actually require deletion.

### 10.5 Examples

**K-free (valid without K):**
```
head : Vec A (S n) -> A
head (vcons x xs) = x
```
Here, `S n =? S m` is solved by injectivity (no deletion needed).

**Requires K (not valid without K):**
```
uip : (p : n = n) -> p = refl
uip refl = refl
```
Here, matching `refl` against `n = n` requires deletion of `n = n`.

**Requires K (subtle case):**
```
f : (n m : Nat) -> n = m -> n = m -> ...
f n .n refl refl = ...
```
After the first `refl` unifies `m` with `n`, the second `refl` must match against
`n = n`, requiring deletion.

---

## 11. Iota-Reduction: How Pattern Matching Computes

### 11.1 Definition

**Iota-reduction** (iota-reduction) is the computational rule for eliminators applied to
constructors. When an eliminator is applied to a value built from a constructor, it
reduces by selecting the appropriate branch and substituting the constructor's arguments.

For natural numbers:
```
Nat-elim P z s 0     -->  z                    (iota for zero)
Nat-elim P z s (S n) -->  s n (Nat-elim P z s n)  (iota for successor)
```

For a general inductive type with constructor `c`:
```
T-elim P branches... (c args...) -->  branch_c args... (recursive results...)
```

### 11.2 Pattern Matching as Iota-Reduction

When dependent pattern matching is taken as a primitive (as in Agda and Lean), the
computation rule is direct:

```
f (c args...) --> rhs_c[args...]
```

where `f` is defined by clauses and `c args...` matches the pattern of clause `c`.
This is sometimes called a *delta-iota reduction* (unfolding the definition and then
reducing the match).

### 11.3 Definitional vs. Propositional Reduction

In systems where pattern matching is compiled to eliminators (Coq's kernel, Equations),
the iota-reduction of the underlying eliminator governs computation. The compiled term
may have *different* definitional equalities than the original clausal definition:
- Simple structural recursion typically preserves definitional equalities.
- Well-founded recursion and complex pattern matching may only satisfy the
  equations *propositionally* (provably equal but not definitionally equal).

Equations generates "unfolding lemmas" for each clause, providing propositional
equalities that can be used in proofs when definitional equality is not available.

### 11.4 Commuting Conversions

A subtle point: iota-reduction for dependent match expressions in CIC includes
*commuting conversions* — rules that allow a match expression to commute with its
context. For example:

```
(match e with ... end) arg  -->  match e with ... (branch arg) ... end
```

These rules ensure that terms reduce to canonical form even when a match expression
is used in function position. They are essential for strong normalization but can
make the conversion relation more complex.

---

## 12. Dependent Pattern Matching in Practice

### 12.1 Agda

Agda was the first proof assistant to adopt dependent pattern matching as its primary
definition mechanism, following Coquand's 1992 approach. Key features:

- **Clausal definitions with dot patterns**: Functions are defined by clauses. The
  system performs unification on indices and marks forced positions as dot patterns.
- **With-abstraction**: The `with` construct allows matching on intermediate values.
- **Absurd patterns**: The `()` pattern marks impossible cases.
- **Coverage checking**: The system checks exhaustiveness, taking index constraints
  into account.
- **`--without-K` mode**: Since Cockx et al. (2014), Agda can optionally reject
  definitions that rely on axiom K.
- **Case trees as core representation**: Internally, Agda compiles definitions to
  case trees and uses them for reduction. Pattern matching is a *primitive* notion
  in Agda, not compiled to eliminators.
- **Proof-relevant unification**: Since Cockx and Abel (2018), Agda's unification
  algorithm produces correctness evidence, ensuring soundness.

### 12.2 Coq (Rocq)

Coq's kernel has a built-in `match` construct (Doc 07, Section 7.1) that supports
dependent elimination but not the full convenience of clausal dependent pattern
matching. The gap is filled by:

- **The `match ... in ... return ...` syntax**: Coq's primitive match requires
  explicit return type annotations with dependent types, using the "in" clause to
  bind index variables.
- **The convoy pattern**: A manual technique for threading type information through
  matches (Section 5.2 above).
- **`dependent destruction` / `dependent induction` tactics**: Tactics that automate
  McBride's equation-generalization technique.
- **The Equations plugin** (Sozeau, 2010; Sozeau and Mangin, 2019): Provides
  Agda-style clausal dependent pattern matching, compiled to eliminators. Supports
  well-founded recursion and generates proof principles automatically.

The Equations plugin compiles pattern matching to terms using only the kernel's
eliminators, J, and accessibility, keeping the trusted code base unchanged.

### 12.3 Lean

Lean's equation compiler (both Lean 3 and Lean 4) provides dependent pattern matching
with several features:

- **Clausal definitions**: Functions are defined by clauses with constructor patterns.
- **Inaccessible patterns**: Marked with explicit annotations when arguments are
  forced by type dependencies.
- **Structural recursion**: The equation compiler detects structurally recursive
  definitions and compiles them to recursors. Defining equations typically hold
  definitionally.
- **Well-founded recursion**: For non-structural recursion, Lean uses well-founded
  recursion with automatic termination proof search.
- **Kernel-level match**: Lean 4's kernel includes pattern matching as a primitive,
  unlike Coq where it must be compiled to raw eliminators.
- **Compilation to recursors**: The equation compiler's output is checked by the
  kernel, but the compiler itself is not part of the trusted code base.

### 12.4 Idris

Idris (both Idris 1 and Idris 2) follows Agda's approach closely:

- Clausal definitions with implicit and dot patterns.
- `with` abstraction for matching on intermediate values.
- Coverage checking with index-aware exhaustiveness.
- Quantitative type theory (Idris 2) adds usage annotations but the pattern matching
  mechanism is essentially the same.

---

## 13. Relationship to Eliminators: When Are They Equivalent?

### 13.1 Conservative Extension (with K)

Goguen, McBride, and McKinna (2006) proved:

**Theorem.** Every definition by dependent pattern matching (in Coquand's sense,
with structural recursion) can be translated into a definition using only eliminators,
universes, inductive types, and axiom K. The translation preserves reduction.

This means dependent pattern matching does not increase the logical strength of the
theory beyond what K already adds.

### 13.2 Conservative Extension (without K)

Cockx, Devriese, and Piessens (2014) proved:

**Theorem.** Every definition by K-free dependent pattern matching can be translated
into a definition using only eliminators, universes, and inductive types, *without*
axiom K. The translation preserves reduction.

This means that K-free pattern matching is a conservative extension of standard
type theory with eliminators — no additional axioms are needed.

### 13.3 When Eliminators Are Insufficient

Eliminators and pattern matching are *equally expressive* in the following precise
sense: any function definable by one mechanism is definable by the other. However,
there are practical asymmetries:

- **Eliminators cannot express overlapping patterns** directly. Pattern matching with
  overlapping clauses and first-match semantics can define functions that require
  more elaborate eliminator terms.
- **Eliminators make nested matching verbose.** A function matching on two values
  simultaneously requires nested eliminator calls with carefully crafted motives.
- **Pattern matching makes the motive implicit.** The motive is inferred from the
  clause structure, which is both a strength (less annotation) and a weakness (harder
  to debug when inference fails).

### 13.4 Primitive Pattern Matching vs. Compilation

There is a design choice for proof assistants:

1. **Pattern matching as primitive** (Agda, Lean 4): The kernel includes case trees
   or `match` expressions as primitives. The computational behavior is given directly
   by pattern matching reduction rules.

2. **Pattern matching compiled to eliminators** (Coq/Equations): The surface language
   has pattern matching, but it is compiled to eliminator-based terms before kernel
   checking. The kernel trusts only eliminators.

Approach (1) has simpler compilation but a larger trusted kernel. Approach (2) has a
smaller trusted kernel but the compilation step can lose definitional equalities and
is more complex.

---

## 14. Advanced Topics

### 14.1 Copattern Matching

Copattern matching (Abel, Pientka, Thibodeau, Setzer, 2013) extends dependent
pattern matching to *coinductive* (record) types. Instead of matching on how a value
was *constructed* (by which constructor), copattern matching specifies how a value
*behaves* (under each destructor/projection).

```
stream : Nat -> Stream Nat
head (stream n) = n
tail (stream n) = stream (S n)
```

Cockx and Abel (2018) unified copattern matching with dependent pattern matching in
a single framework, where case trees can contain both constructor splits and
projection (copattern) splits.

### 14.2 Higher-Dimensional Unification

In HoTT-compatible systems, the unification algorithm must handle identity proofs
between identity proofs (and higher). Cockx's proof-relevant unification framework
accommodates *higher-dimensional unification rules* that can solve equations between
identity proofs without assuming K.

### 14.3 Overlapping and Order-Independent Patterns

Standard first-match semantics makes the order of clauses significant. Some systems
explore *order-independent* pattern matching, where clauses must be non-overlapping
or must agree on overlapping inputs. This is important for:
- Parallel evaluation (no ordering dependence)
- Confluence of reduction
- Commuting case trees in the equational theory

---

## 15. Key References

### Seminal Papers

1. Thierry Coquand. "Pattern Matching with Dependent Types." *Proceedings of the
   1992 Workshop on Types for Proofs and Programs*, pp. 71–83, 1992.
   — The foundational paper introducing dependent pattern matching.

2. Conor McBride. "Elimination with a Motive." *TYPES 2000*, LNCS 2277, pp. 197–216.
   Springer, 2002.
   — Explains the conceptual bridge between eliminators and pattern matching.

3. Conor McBride and James McKinna. "The View from the Left." *Journal of Functional
   Programming* 14(1):69–111, 2004.
   — Introduces the "with" construct and views for dependent types.

4. Healfdene Goguen, Conor McBride, and James McKinna. "Eliminating Dependent Pattern
   Matching." *LNCS 4036*, pp. 521–540. Springer, 2006.
   — Proves that dependent pattern matching translates to eliminators + K.

### K-Free Pattern Matching

5. Martin Hofmann and Thomas Streicher. "The Groupoid Interpretation of Type Theory."
   *Twenty-Five Years of Constructive Type Theory*, Oxford Logic Guides 36, 1998.
   — Proves K is independent of J; the groupoid model.

6. Jesper Cockx, Dominique Devriese, and Frank Piessens. "Pattern Matching without K."
   *ICFP 2014*, pp. 257–268. ACM, 2014.
   — K-free criterion for dependent pattern matching.

7. Jesper Cockx and Dominique Devriese. "Unifiers as Equivalences: Proof-Relevant
   Unification of Dependently Typed Data." *ICFP 2016*. ACM, 2016.
   — Proof-relevant unification framework.

8. Jesper Cockx and Andreas Abel. "Sprinkles of Extensionality for Your Vanilla
   Type Theory." *TYPES 2016*, 2016.
   — Extends unification with eta-equality for records.

9. Jesper Cockx and Andreas Abel. "Elaborating Dependent (Co)pattern Matching."
   *PACMPL* 2(ICFP), article 75. ACM, 2018.
   — Formal case tree elaboration with first-match semantics.

10. Jesper Cockx and Andreas Abel. "Proof-Relevant Unification: Dependent Pattern
    Matching with Only the Axioms of Your Type Theory." *Journal of Functional
    Programming* 28, e6. Cambridge University Press, 2018.
    — Definitive proof-relevant unification framework.

### Implementations

11. Matthieu Sozeau. "Equations: A Dependent Pattern-Matching Compiler." *ITP 2010*,
    LNCS 6172, pp. 419–434. Springer, 2010.
    — The Equations plugin for Coq.

12. Matthieu Sozeau and Cyprien Mangin. "Equations Reloaded." *PACMPL* 3(ICFP),
    article 86. ACM, 2019.
    — Extended Equations with well-founded recursion and proof principles.

### Background

13. Lennart Augustsson. "Compiling Pattern Matching." *FPCA 1985*, LNCS 201.
    Springer, 1985.
    — Classic case tree compilation algorithm.

14. Peter Dybjer. "Inductive Families." *Formal Aspects of Computing* 6(4):440–465,
    1994.
    — Formalization of indexed inductive families.

15. Andreas Abel, Brigitte Pientka, David Thibodeau, and Anton Setzer. "Copatterns:
    Programming Infinite Structures by Observations." *POPL 2013*. ACM, 2013.
    — Introduction of copattern matching.
