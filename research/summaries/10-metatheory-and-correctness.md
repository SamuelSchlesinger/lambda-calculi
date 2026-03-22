# Metatheory and Correctness Proofs for Typed Lambda Calculi

## Overview

The metatheory of typed lambda calculi encompasses the collection of theorems
*about* type systems and their associated reduction relations, as opposed to
theorems proved *within* them. These results establish that type systems deliver
on their promises: well-typed programs do not go wrong (type safety), all
computations terminate (strong normalization), reduction order does not matter
(confluence), the logic is free from contradiction (consistency), and closed
programs compute to canonical values (canonicity). This document surveys the
principal metatheoretic results, the proof techniques used to establish them,
and the models that give them semantic backing.

**Cross-references:** The specific systems whose metatheory is discussed here include: the simply typed lambda calculus and System F (Docs 01-04), the lambda cube and Pure Type Systems (Doc 05), the Calculus of Constructions (Doc 06), the Calculus of Inductive Constructions (Doc 07), and coinductive extensions (Doc 08).

---

## 1. Type Safety

### 1.1 The Syntactic Approach: Progress and Preservation

Type safety asserts that well-typed programs cannot reach undefined ("stuck")
states during execution. The modern formulation, due to Wright and Felleisen
(1994), decomposes type safety into two properties:

**Progress.** If `∅ ⊢ e : τ`, then either `e` is a value or there exists `e'`
such that `e → e'`.

**Preservation (Subject Reduction).** If `Γ ⊢ e : τ` and `e → e'`, then
`Γ ⊢ e' : τ`.

Together, these imply that a well-typed closed term either diverges (takes
infinitely many steps) or reduces to a value --- it never gets "stuck" in a
non-value, non-reducible state.

### 1.2 Proof Technique

**Progress** is proved by induction on the typing derivation `∅ ⊢ e : τ`.
The key auxiliary result is a *canonical forms lemma*: if `∅ ⊢ v : τ` and `v`
is a value, then `v` has a specific syntactic shape determined by `τ`. For
example:
- If `v : Bool`, then `v` is `true` or `false`.
- If `v : σ → τ`, then `v = λx:σ. t` for some `t`.

**Preservation** is proved by induction on the typing derivation (or on the
reduction relation), using a *substitution lemma*:

> If `Γ, x:σ ⊢ t : τ` and `Γ ⊢ v : σ`, then `Γ ⊢ t[x := v] : τ`.

The substitution lemma itself requires auxiliary lemmas about weakening and
the permutation/exchange of typing contexts.

### 1.3 Historical Context

The term "subject reduction" originates in combinatory logic (Curry and Hindley),
where "subject" refers to the term being typed. Wright and Felleisen's
contribution was to show that combining subject reduction with a progress
theorem, formulated relative to a small-step operational semantics, yields a
clean and scalable method for proving type soundness. Their approach has become
the standard in PL research and pedagogy, extending readily to references,
exceptions, continuations, polymorphism, and subtyping.

### 1.4 Semantic and Logical Approaches

An alternative to the syntactic approach uses *semantic type soundness*:
define a semantic notion of well-typedness (e.g., via logical relations) and
show that syntactically well-typed terms are semantically well-typed. This
approach, exemplified by Timany et al. (2024) using the Iris framework,
scales to concurrency and higher-order state where syntactic methods become
unwieldy. The semantic approach proves a stronger property: not just that
programs do not get stuck, but that they behave according to a rich semantic
specification.

---

## 2. Strong Normalization

Strong normalization (SN) states that every reduction sequence starting from a
well-typed term is finite --- there are no infinite reduction paths, regardless
of the reduction strategy chosen.

### 2.1 Tait's Method for STLC (1967)

**The Problem.** A naive induction on typing derivations fails because the
application rule `Γ ⊢ t : σ → τ` and `Γ ⊢ u : σ` implies `Γ ⊢ t u : τ`
does not decrease any obvious measure (the term `t u` may reduce to something
larger before shrinking).

**The Solution: Reducibility Predicates.** Define a family of predicates
`RED_τ` on terms, indexed by types:

```
RED_ι(t)     ≡  t is strongly normalizing                 (base type)
RED_{σ→τ}(t) ≡  for all u, RED_σ(u) implies RED_τ(t u)   (function type)
```

These predicates satisfy three crucial closure conditions:

- **CR1:** If `RED_τ(t)`, then `t` is strongly normalizing.
- **CR2:** If `RED_τ(t)` and `t → t'`, then `RED_τ(t')`. (Closure under reduction.)
- **CR3:** If `t` is *neutral* (i.e., not a lambda abstraction) and every
  one-step reduct of `t` is in `RED_τ`, then `RED_τ(t)`. (Backward closure
  for neutral terms.)

**Fundamental Theorem (Adequacy).** If `Γ ⊢ t : τ` and `σ` is a substitution
such that `RED_{Γ(x)}(σ(x))` for every `x ∈ dom(Γ)`, then `RED_τ(t[σ])`.

*Proof.* By induction on the typing derivation. The lambda case uses CR3
and the induction hypothesis at a smaller type. The application case follows
directly from the definition of `RED_{σ→τ}`.

**Corollary.** Every well-typed term is strongly normalizing. (Apply the
fundamental theorem with the identity substitution, using CR3 to show that
variables are reducible, and CR1 to extract SN.)

### 2.2 Girard's Reducibility Candidates for System F (1972)

In System F, types contain universally quantified type variables (`∀α. τ`),
so `RED_τ` cannot be defined by induction on the type alone --- the type
variable `α` has no fixed interpretation.

**Solution.** A *reducibility candidate* (candidat de réductibilité) is any
set `C` of (open or closed) terms satisfying CR1, CR2, and CR3 above. Let
`RC` be the collection of all reducibility candidates.

The interpretation of types is parameterized by an assignment `ξ` mapping type
variables to reducibility candidates:

```
⟦α⟧ξ       = ξ(α)
⟦σ → τ⟧ξ   = { t | ∀u ∈ ⟦σ⟧ξ. t u ∈ ⟦τ⟧ξ }
⟦∀α. τ⟧ξ   = ⋂_{C ∈ RC} ⟦τ⟧(ξ[α ↦ C])
```

The crucial point: the interpretation of `∀α. τ` quantifies over *all*
reducibility candidates, not just those arising as denotations of syntactic
types. This handles the impredicativity of System F. One must verify that the
interpretation of each type connective again yields a reducibility candidate,
which requires careful checking of CR1--CR3.

**Main Theorem.** Every well-typed System F term belongs to the appropriate
reducibility candidate under any assignment, and is therefore strongly
normalizing.

Girard's reducibility candidates remain the only known technique for proving
strong normalization in second-order (and higher-order) polymorphic settings.

### 2.3 Extension to Dependent Types

Strong normalization for dependent type theories (such as the Calculus of
Constructions) is considerably more delicate because types depend on terms, and
terms depend on types. Approaches include:

- **Coquand's Kripke-style interpretation** for the Calculus of Constructions,
  using a Kripke model indexed by contexts.
- **Werner's extension** of Girard's candidates to the Calculus of Inductive
  Constructions (CIC).
- **Abel's methods** using sized types and lexicographic induction for systems
  with inductive and coinductive types.

### 2.4 Proof Structure Summary

All strong normalization proofs via logical predicates share a common skeleton:

1. Define a "good" predicate/set for each type (the reducibility predicate).
2. Show the predicate implies SN (CR1).
3. Show the predicate is closed under reduction (CR2) and backward-closed for
   neutral terms (CR3).
4. Prove the fundamental theorem: well-typed terms in "good" environments
   satisfy the predicate.
5. Conclude SN by instantiating with the identity environment.

---

## 3. Logical Relations and Logical Predicates

Logical relations are among the most versatile tools in PL metatheory, used for
normalization, equivalence, parametricity, compiler correctness, and more.

### 3.1 Unary Logical Predicates

A unary logical predicate assigns to each type `τ` a predicate `P_τ` on terms,
defined by induction on types. The definition at function types "logically"
relates inputs to outputs:

```
P_{σ→τ}(t) ≡ ∀u. P_σ(u) ⟹ P_τ(t u)
```

Primary use: proving termination/normalization properties (Tait's method,
as described above).

### 3.2 Binary Logical Relations

A binary logical relation assigns to each type a *relation* between pairs of
terms (or between terms and semantic values):

```
R_ι ⊆ T × T                                      (given at base types)
R_{σ→τ}(f, g) ≡ ∀(a,b) ∈ R_σ. (f a, g b) ∈ R_τ  (function types)
```

**Applications:**
- **Program equivalence:** Two terms are logically related iff they are
  contextually equivalent. Proving the logical relation is sound and complete
  with respect to contextual equivalence yields a useful proof method.
- **Parametricity:** Reynolds' abstraction theorem (1983) states that every
  System F term satisfies a relational property determined by its type.
  Wadler (1989) showed these yield powerful "free theorems."
- **Compiler correctness:** Source and target terms are related when the target
  correctly implements the source.

### 3.3 Step-Indexed Logical Relations

Introduced by Appel and McAllester (2001) for foundational proof-carrying code.

**Key Idea.** Index the relation by a natural number `k`:

```
(k, v) ∈ V⟦τ⟧  ≡  v behaves as a value of type τ for k reduction steps
```

A term `e` is in the relation at type `τ` if for every `k`, running `e` for
up to `k` steps either does not terminate or produces a value in `V⟦τ⟧` at
index `k`.

**Advantages:**
- Handles recursive types, general references, and impredicative polymorphism
  without domain theory or admissibility conditions.
- Mathematically simple: the model lives in ordinary set theory.

**Disadvantages:**
- Proofs involve step-index arithmetic that obscures the essential argument.

**Refinements:**
- Ahmed (2006) developed step-indexed logical relations for recursive and
  quantified types.
- Dreyer, Neis, and Birkedal (2011) introduced *Logical Step-Indexed Logical
  Relations* (LSLR), combining step-indexing with Kripke possible worlds to
  yield clean, high-level proof principles.

### 3.4 Kripke Logical Relations

Standard logical relations work for closed terms but break down for open terms
(terms with free variables), because weakening (adding variables to the context)
must preserve the relation.

**Solution.** A *Kripke logical relation* is indexed by a "possible world" `w`
(typically a typing context or more general structure):

```
R^w_τ(t)  with monotonicity:  if w ≤ w' and R^w_τ(t), then R^{w'}_τ(t[ρ])
```

where `ρ` is the weakening/renaming from `w` to `w'`.

This monotonicity condition ensures the relation is stable under context
extension, which is essential for the fundamental theorem to go through at
binders (lambda abstractions): when checking `λx. t`, one must consider `t`
in a world extended with `x`.

**Applications:**
- Normalization proofs for open terms in dependent type theories.
- Decidability of type-checking via normalization.
- Correctness proofs for normalization by evaluation (NbE).
- The POPLmark Reloaded benchmark specifically targets mechanization of
  Kripke-style logical relations proofs.

---

## 4. Confluence

### 4.1 Church-Rosser Theorem

The Church-Rosser property (confluence) states that if a term `M` reduces to
both `N₁` and `N₂` (via zero or more steps), then there exists a term `P`
such that both `N₁` and `N₂` reduce to `P`:

```
If M →* N₁ and M →* N₂, then ∃P. N₁ →* P and N₂ →* P.
```

This implies that normal forms, when they exist, are unique.

### 4.2 The Tait--Martin-Löf Parallel Reduction Method

The standard proof uses *parallel reduction* `⇉`, which contracts zero or more
redexes in a single step simultaneously.

**Definition.** Parallel reduction `M ⇉ N` is defined inductively:

```
x ⇉ x                                               (variable)
If M ⇉ M' then λx.M ⇉ λx.M'                        (abstraction)
If M ⇉ M' and N ⇉ N' then M N ⇉ M' N'              (application)
If M ⇉ M' and N ⇉ N' then (λx.M) N ⇉ M'[x:=N']    (parallel beta)
```

**Key Lemma (Diamond Property).** Parallel reduction satisfies the diamond
property: if `M ⇉ N₁` and `M ⇉ N₂`, then there exists `P` with
`N₁ ⇉ P` and `N₂ ⇉ P`.

The proof defines `M*` (the *complete development* of `M`, which contracts all
redexes simultaneously) and shows `N ⇉ M*` whenever `M ⇉ N`.

**From Diamond to Confluence.** Single-step beta reduction `→β` is contained
in `⇉`, and `⇉` is contained in `→*β`. Since `⇉` has the diamond property,
its reflexive-transitive closure (which equals `→*β`) is confluent.

### 4.3 Confluence for Typed Calculi

For typed lambda calculi, confluence follows immediately from confluence of the
untyped calculus (since typed reduction is a restriction of untyped reduction).
However, typed confluence can also be proved directly, and typing provides
additional structure:

- In strongly normalizing systems, confluence follows from *local* confluence
  (Newman's lemma): if all critical pairs can be joined, and all reduction
  sequences terminate, then the system is confluent.
- For systems with eta-expansion (`λx. f x →η f`), separate arguments are
  needed. The beta-eta Church-Rosser theorem holds for STLC and System F.

### 4.4 Extensions

- Takahashi (1995) gave a particularly clean proof using parallel reduction,
  defining the "complete development" operator.
- The Tait--Martin-Löf method extends to System F, System Fω, and the Calculus
  of Constructions.
- A recent Lean 4 framework by Cuellar (2025) implements parallel reduction,
  Newman's lemma, and the Hindley-Rosen lemma generically.

---

## 5. Consistency

### 5.1 What Inconsistency Means

Under the Curry-Howard correspondence, types are propositions and terms are
proofs. An *inconsistent* type theory is one in which the empty type `⊥` (False,
Empty) is inhabited --- that is, there exists a closed term `t : ⊥`. Since
`⊥` has no constructors, this means every type is inhabited (by `absurd t`),
so every proposition is provable.

Equivalently, inconsistency means the type theory is trivial as a logic.

### 5.2 Girard's Paradox: Type : Type

**The Problem.** If a type theory admits the rule `Type : Type` (a single
universe containing itself), it is inconsistent. Martin-Löf proposed such a
theory in 1971, and Girard showed it inconsistent by encoding a variant of the
Burali-Forti paradox (the paradox of the ordinal of all ordinals).

**Mechanism.** In System U (the pure type system with rules that allow
impredicative quantification at two levels), one can construct a well-ordering
`W` of all well-orderings, and then show `W` must be a member of itself, which
contradicts its own well-orderedness. The details are intricate and indirect.

**System U and System U⁻.** System U has three sorts `{*, □, △}` with axioms `{* : □, □ : △}` and
rules `{(*, *), (□, *), (□, □)}` (see Doc 05 for the full PTS specification). The rule `(□, *)` allows impredicative quantification at the kind level, which is the source of the paradox. System U⁻ drops the `(□, □)` rule but
remains inconsistent.

### 5.3 Hurkens' Simplified Paradox (1995)

Hurkens gave a shorter and more direct derivation of inconsistency in
System U⁻. The construction defines a "paradoxical universe" --- a type `U`
equipped with functions forming an isomorphism between `U` and `P(P(U))`
(the powerset of the powerset), which is impossible for cardinality reasons.

The construction is formalized in Rocq's standard library (`Coq.Logic.Hurkens`)
and serves as a standard test case for universe checking in proof assistants.

### 5.4 Universe Hierarchies as the Fix

The standard resolution is a cumulative hierarchy of universes:

```
Type₀ : Type₁ : Type₂ : Type₃ : ...
```

with the rule `Typeᵢ : Typeᵢ₊₁` but *not* `Typeᵢ : Typeᵢ`. The typing rules
ensure that quantification over `Typeᵢ` produces a type in `Typeᵢ₊₁` (or
higher), preventing the self-reference that enables paradoxes.

Variants:
- **Cumulative universes** (as in Rocq, Lean): `Typeᵢ ≤ Typeᵢ₊₁`, so a type
  in a lower universe is automatically in higher universes.
- **Non-cumulative universes** (as in Agda by default): explicit lifting is
  required.
- **Universe polymorphism** (Rocq, Lean, Agda): definitions can be parameterized
  by universe levels, avoiding code duplication.

### 5.5 Berardi's Paradox and Excluded Middle

Barbanera and Berardi (1996) showed that in the Calculus of Constructions,
the combination of:
1. Excluded middle (`∀P : Prop. P ∨ ¬P`)
2. Strong elimination from large types (large elimination from `Prop` into `Type`)

implies proof irrelevance (all proofs of a proposition are equal), which in
certain settings leads to inconsistency. This is why Rocq restricts
elimination from `Prop` to `Prop` (no large elimination from `Prop`), while
Lean places no restriction but uses a different universe architecture.

More generally, excluded middle is *consistent* with most type theories (it
does not derive `⊥`), but it destroys canonicity and computational content.

### 5.6 Other Paths to Inconsistency

The following feature combinations are known to be inconsistent in dependent
type theories:

- Two impredicative universes (System U)
- Impredicative strong pairs with projections
- Unrestricted large elimination from impredicative inductive types
- Negative or non-strictly-positive inductive types combined with impredicativity
- Impredicativity + excluded middle + large elimination (Berardi)
- `Type : Type` (Girard)
- Certain relaxed guardedness conditions for coinductive definitions

---

## 6. Canonicity

### 6.1 Definition

A type theory enjoys *canonicity* if every closed term of an inductive type
computes to a value built from constructors of that type. The prototypical
statement:

> Every closed term of type `Nat` is judgmentally equal to a numeral
> `S(S(...(S(0))...))`.

More generally, every closed term of type `Bool` computes to `true` or `false`,
every closed term of a sum type computes to an `inl` or `inr`, and so on.

### 6.2 Significance

Canonicity is what makes a type theory a *programming language*: closed programs
of observable type actually compute to observable values. Without canonicity,
a proof assistant could claim `2 + 2 = 5` is false but be unable to actually
evaluate `2 + 2` to `4`.

### 6.3 Canonicity and Axioms

Adding axioms to a type theory typically destroys canonicity by introducing
"stuck" terms --- closed terms that are neither values nor reducible. For
example:

- **Excluded middle:** `match LEM Goldbach with | inl _ => 0 | inr _ => 1`
  is a closed term of type `Nat` that cannot compute because `LEM Goldbach`
  is an axiom, not a constructor.
- **Function extensionality** (as an axiom, not a rule) creates stuck identity
  proofs.
- **The univalence axiom** (in its postulated form) creates stuck terms in
  identity types.

### 6.4 Canonicity in Different Settings

- **Intensional MLTT (without axioms):** Canonicity holds. This is a core
  design principle of Martin-Löf type theory.
- **Extensional type theory:** Canonicity fails because the reflection rule
  makes type-checking undecidable and allows non-canonical closed terms.
- **Cubical type theory:** Canonicity holds *with* the univalence axiom,
  because univalence is given a computational interpretation. Huber (2018)
  proved canonicity for cubical type theory. This is a major achievement:
  univalence becomes a *theorem* rather than an axiom, preserving computation.
- **HoTT (Book HoTT with postulated univalence):** Canonicity fails for
  the postulated axiom, motivating the development of cubical type theory.

### 6.5 Proof Techniques

Canonicity is typically proved using:
- **Logical relations / computability predicates** (as for normalization).
- **Normalization by evaluation** (NbE): if every term normalizes, and normal
  forms of closed terms at inductive types are constructor-headed, canonicity
  follows.
- **Sconing (glueing):** A categorical technique where the term model is
  "glued" to a simple model (such as sets) along the global sections functor.
  Sterling and collaborators have developed "synthetic Tait computability"
  as a framework for such proofs.

---

## 7. Decidability

### 7.1 Type Checking

| System | Type checking decidable? | Notes |
|--------|-------------------------|-------|
| STLC | Yes | Straightforward algorithm |
| System F (with annotations) | Yes | All beta-redexes annotated with types |
| Hindley-Milner | Yes | Algorithm W (Damas-Milner) |
| System F (bare terms) | **No** | Wells (1999) |
| MLTT (intensional) | Yes | Relies on normalization + decidable equality of normal forms |
| MLTT (extensional) | **No** | Reflection rule makes conversion checking undecidable |
| CoC / CIC | Yes | Relies on SN and decidable conversion |

### 7.2 Type Inference

**Hindley-Milner:** Type inference is decidable (and has a principal type
property), via Algorithm W based on first-order unification.

**System F:** Wells (1999) proved that both typability (given `e`, does there
exist `τ` with `⊢ e : τ`?) and type checking (given `e` and `τ`, does
`⊢ e : τ` hold?) are undecidable for System F. The proof reduces from
semi-unification (for type checking) and then from type checking to typability.
The two problems are equivalent and both undecidable.

**Practical Impact:** Languages like Haskell and ML use restricted forms of
polymorphism (rank-1 or rank-2 polymorphism, or bidirectional type checking
with annotations) to recover decidability.

### 7.3 Decidability of Conversion (βη-Equality)

**STLC:** βη-equivalence is decidable. One approach: normalize both terms
(guaranteed to terminate by SN) and compare normal forms syntactically.

**Complexity:** Statman (1979) showed that the normalization problem for STLC
is not elementary recursive --- the size of normal forms can grow non-elementarily
relative to input size. Despite decidability, the worst-case complexity is
enormous.

**Statman's Typical Ambiguity Theorem:** βη-equivalence is the *maximal*
consistent congruence on STLC terms that is closed under type substitution.
This provides a semantic characterization of βη-equality.

**Dependent Type Theory:** Conversion checking is decidable for intensional
MLTT (given SN and confluence). Abel and others have established decidability
of conversion for MLTT with one universe using Kripke logical relations and NbE.

---

## 8. Normalization by Evaluation (NbE)

### 8.1 Overview

Normalization by evaluation (NbE) is a technique for computing normal forms
of lambda terms by:
1. **Evaluating** the term in a semantic domain (typically a model in a meta-language).
2. **Quoting** (reifying) the semantic value back into a syntactic normal form.

### 8.2 Algorithm Sketch (for STLC with βη)

```
-- Semantic domain
data D = DLam (D → D) | DNe Ne
data Ne = NVar Name | NApp Ne D

-- Evaluation: Term → Env → D
eval (Var x)   ρ = ρ(x)
eval (Lam x t) ρ = DLam (λd. eval t (ρ, x↦d))
eval (App t u) ρ = app (eval t ρ) (eval u ρ)
  where app (DLam f) d = f d
        app (DNe n)  d = DNe (NApp n d)

-- Quotation: D → Level → NormalForm
quote (DLam f) ℓ = NLam xℓ (quote (f (DNe (NVar xℓ))) (ℓ+1))
quote (DNe n)  ℓ = quoteNe n ℓ
```

### 8.3 Correctness

Correctness of NbE requires proving:
- **Soundness:** The output normal form is βη-equal to the input term.
- **Completeness:** βη-equal inputs produce identical normal forms.

The standard proof technique uses a *logical relation* (often Kripke-style)
between syntactic terms and semantic values. The key result is the
*fundamental lemma*: if a term `t` evaluates to semantic value `d`, and `t`
is "related" to `d` at type `τ`, then `quote(d)` is the βη-normal form of `t`.

### 8.4 Categorical Perspective

NbE can be understood via *categorical glueing* (Artin glueing, sconing):
the term model is glued to a presheaf model along the interpretation functor,
producing a model where every element comes with both a syntactic and semantic
component. This is the categorical analogue of the logical relation used in the
proof. This perspective was developed by Altenkirch, Hofmann, and Streicher
(1995) and has been extended to dependent type theories by Abel and others.

### 8.5 Applications

NbE is the standard normalization algorithm in modern proof assistants (Agda,
Lean, and partially in Rocq). It is more efficient than iterated beta-reduction
because evaluation in the meta-language avoids repeated traversal and
substitution.

---

## 9. Parametricity

### 9.1 Reynolds' Abstraction Theorem (1983)

Reynolds introduced *relational parametricity* for System F. The abstraction
theorem states: if `⊢ t : τ` in System F, then `t` satisfies a relational
property `R⟦τ⟧` determined by its type, for any choice of relations at type
variables.

Formally, for each type variable `α`, choose a relation `R_α ⊆ A_α × B_α`.
Then the relational interpretation is:

```
R⟦α⟧           = R_α
R⟦σ → τ⟧(f,g)  = ∀(a,b) ∈ R⟦σ⟧. (f a, g b) ∈ R⟦τ⟧
R⟦∀α. τ⟧(f,g)  = ∀R_α. (f [A_α], g [B_α]) ∈ R⟦τ⟧[R_α/α]
```

**Abstraction Theorem.** Every System F term `t : τ` is related to itself:
`(t, t) ∈ R⟦τ⟧` for all choices of relations at type variables.

### 9.2 Free Theorems (Wadler 1989)

Wadler showed that parametricity yields powerful theorems "for free" from types
alone. Examples:

- `f : ∀α. α → α` implies `f = id` (the only parametric inhabitant).
- `f : ∀α. List α → List α` implies `f` commutes with `map`: for any
  `g : A → B`, `map g (f xs) = f (map g xs)`.
- `f : ∀α. (α → α) → α → α` (Church numeral type) implies `f` is a
  Church numeral.

### 9.3 Significance

Parametricity is the foundation for:
- Representation independence arguments
- Compiler optimizations (e.g., short-cut fusion in Haskell)
- Security properties (information hiding)
- Proofs of data abstraction

---

## 10. Models of Typed Lambda Calculi

### 10.1 Set-Theoretic Models

**STLC:** The simply typed lambda calculus has a standard set-theoretic model:
interpret base types as sets and `σ → τ` as the set of all functions from
`⟦σ⟧` to `⟦τ⟧`. This model is complete for βη-equivalence when base types
are interpreted as infinite sets.

**System F: Reynolds' Impossibility.** Reynolds (1984) proved that System F
*cannot* be modeled in classical set theory if `∀` is interpreted as an
intersection (product) over all sets. The type `∀α. α → α` would need to
belong to a set that is simultaneously a product over all sets including
itself, which is impossible by cardinality. Set-theoretic models of System F
can exist in *intuitionistic* set theory, however.

### 10.2 Domain-Theoretic Models

Scott (1969) constructed `D∞`, a domain (complete partial order) isomorphic to
its own continuous function space `[D∞ → D∞]`, providing the first
mathematical model of the untyped lambda calculus. Key features:

- Domains are directed-complete partial orders (dcpos) with a least element `⊥`.
- Morphisms are Scott-continuous functions (preserving directed suprema).
- `⊥` models non-termination.
- Solves recursive domain equations `D ≅ F(D)`.

Domain models are essential for languages with general recursion (fixpoint
combinators), where strong normalization fails.

### 10.3 Realizability Models

Originating with Kleene (1945) for Heyting arithmetic and refined by Kreisel
(1959) with *modified realizability* using typed terms:

- A formula `φ` is *realized* by a term `t` if `t` computationally witnesses
  the truth of `φ`.
- `φ → ψ` is realized by `t` if for all `u` realizing `φ`, `t u` realizes `ψ`.
- `∀x. φ(x)` is realized by `t` if for all `n`, `t n` realizes `φ(n)`.

Hyland's *effective topos* is the categorical incarnation of Kleene
realizability. Modified realizability toposes provide models for System F
and the Calculus of Constructions.

### 10.4 Categorical Models

The correspondence between type theories and categories is deep and systematic:

| Type Theory | Categorical Structure |
|------------|----------------------|
| STLC | Cartesian Closed Categories (CCCs) |
| STLC + coproducts | Bicartesian Closed Categories |
| Dependent type theory (MLTT) | Locally Cartesian Closed Categories (LCCCs) |
| Higher-order logic | Elementary Toposes |
| System F | Polymorphic fibrations, PL-categories |
| Linear logic / linear types | Symmetric Monoidal Closed Categories |
| HoTT (without univalence) | Locally cartesian closed (∞,1)-categories |
| HoTT (with univalence) | Elementary (∞,1)-toposes |

**Curry-Howard-Lambek Correspondence.** The STLC, intuitionistic propositional
logic, and CCCs are three presentations of the same mathematical structure:
- Types = objects = propositions
- Terms = morphisms = proofs
- β-reduction = composition of evaluation
- η-expansion = uniqueness of transpose

**Subtlety for Dependent Types.** In syntax, substitution is strictly
associative; categorically, pullback (which models substitution) is only
associative up to isomorphism. This *coherence problem* was addressed by
Hofmann (using categories with families), Voevodsky (using C-systems), and
Clairambault-Dybjer (using a 2-categorical equivalence).

### 10.5 Presheaf Models

Presheaves over a category `C` (functors `C^op → Set`) form a topos, providing
rich models:

- **Hofmann-Streicher groupoid model** (1998): Presheaves over groupoids show
  that uniqueness of identity proofs (UIP) is not derivable in MLTT. This
  was the first *independence result* in type theory.
- **Cubical sets:** Presheaves over the cube category model cubical type
  theory, giving computational content to univalence.
- **Simplicial sets:** Model homotopy type theory and (∞,1)-categorical
  structures.
- **NbE via glueing:** Normalization by evaluation arises from glueing the
  term model to a presheaf model, yielding a model where every element
  carries both syntactic and semantic information.

---

## 11. Formalized Metatheory

### 11.1 The POPLmark Challenge (2005)

Aydemir, Bohannon, Fairbairn, Foster, Pierce, Sewell, Vytiniotis, Washburn,
Weirich, and Zdancewic proposed a benchmark for mechanized metatheory of
programming languages, based on System F<: (System F with subtyping and
records). The challenge exercises:

- Variable binding at term and type levels
- Syntactic forms with variable numbers of binders
- Complex induction principles (e.g., for transitivity of subtyping)

Solutions were submitted in Isabelle/HOL, Twelf, Rocq (Coq), ATS, Abella,
Matita, and other systems. The challenge revealed significant differences in
how proof assistants handle binding and substitution.

### 11.2 POPLmark Reloaded (2019)

Abel, Allais, Momigliano, and others proposed *POPLmark Reloaded*, focusing
on mechanizing strong normalization proofs via logical relations. The benchmark
is the proof of strong normalization for STLC with booleans using Kripke-style
logical relations, which tests:

- Representation of well-typed syntax
- Simultaneous substitutions / renamings
- Kripke logical relations with monotonicity
- The fundamental theorem (adequacy)

### 11.3 Notable Mechanized Formalizations

- **Software Foundations** (Pierce et al.): Textbook-quality Rocq (Coq)
  formalizations of STLC, progress, preservation, normalization, and more.
- **Programming Language Foundations in Agda** (Wadler and Kokke): Complete
  formalization of STLC metatheory in Agda, including progress, preservation,
  confluence, and normalization.
- **CompCert** (Leroy et al., Rocq): Verified optimizing C compiler;
  includes formalized operational semantics and type safety for intermediate
  languages.
- **Altenkirch (1993):** Formalization of strong normalization for System F
  in LEGO using Girard's reducibility candidates.
- **Martin-Löf à la Coq** (Adjedj et al., 2023): Mechanization of the
  metatheory of Martin-Löf type theory in Rocq, including normalization.
- **Abel (2019), Sterling (2021):** Formalized NbE and normalization for
  dependent type theories, including cubical type theory.
- **Lean 4 framework (Cuellar 2025):** Modular framework for confluence
  and strong normalization proofs for lambda calculi with products and sums.
- **Mathlib:** While primarily a mathematics library, Lean's Mathlib includes
  formalized foundations relevant to lambda calculus and type theory.

### 11.4 Binding Representations

A major practical challenge in formalizing metatheory is representing variable
binding. Approaches include:

- **Named variables:** Natural but requires alpha-equivalence machinery.
- **de Bruijn indices:** Avoids alpha-equivalence but makes terms less readable
  and requires shifting.
- **Locally nameless:** Free variables are named, bound variables are indices.
  Used in much Rocq formalization work.
- **HOAS (Higher-Order Abstract Syntax):** Uses the meta-language's binding to
  represent object-language binding. Natural in Twelf and Beluga.
- **Intrinsically typed syntax:** Terms are indexed by types in the definition,
  ruling out ill-typed terms by construction. Natural in Agda and Lean.
- **Nominal techniques:** Use permutations and freshness conditions. Supported
  by Nominal Isabelle.

---

## 12. Key References

### Foundational Papers

1. **A. Church.** "A Formulation of the Simple Theory of Types." *Journal of
   Symbolic Logic*, 5(2):56--68, 1940.

2. **W. W. Tait.** "Intensional Interpretations of Functionals of Finite Type I."
   *Journal of Symbolic Logic*, 32(2):198--212, 1967.

3. **J.-Y. Girard.** "Interprétation fonctionnelle et élimination des coupures
   de l'arithmétique d'ordre supérieur." Thèse de doctorat d'état, Université
   Paris VII, 1972.

4. **G. D. Plotkin.** "Lambda-definability and logical relations." Memorandum
   SAI-RM-4, University of Edinburgh, 1973.

5. **R. Statman.** "The Typed λ-Calculus Is Not Elementary Recursive."
   *Theoretical Computer Science*, 9(1):73--81, 1979.

6. **R. Statman.** "Logical Relations and the Typed λ-Calculus."
   *Information and Control*, 65(2-3):85--97, 1985.

7. **J. C. Reynolds.** "Types, Abstraction and Parametric Polymorphism."
   *Information Processing 83*, pp. 513--523, 1983.

8. **J. C. Reynolds.** "Polymorphism Is Not Set-Theoretic." *Semantics of Data
   Types*, LNCS 173, pp. 145--156, 1984.

9. **P. Wadler.** "Theorems for Free!" *FPCA '89*, pp. 347--359, 1989.

10. **A. K. Wright and M. Felleisen.** "A Syntactic Approach to Type Soundness."
    *Information and Computation*, 115(1):38--94, 1994.

11. **A. Hurkens.** "A Simplification of Girard's Paradox." *TLCA '95*,
    LNCS 902, pp. 266--278, 1995.

12. **J. B. Wells.** "Typability and Type Checking in System F Are Equivalent
    and Undecidable." *Annals of Pure and Applied Logic*, 98:111--156, 1999.

### Books and Monographs

13. **J.-Y. Girard, Y. Lafont, and P. Taylor.** *Proofs and Types.* Cambridge
    Tracts in Theoretical Computer Science 7, Cambridge University Press, 1989.

14. **J. Lambek and P. J. Scott.** *Introduction to Higher Order Categorical
    Logic.* Cambridge Studies in Advanced Mathematics 7, Cambridge University
    Press, 1986.

15. **B. C. Pierce.** *Types and Programming Languages.* MIT Press, 2002.

16. **The Univalent Foundations Program.** *Homotopy Type Theory: Univalent
    Foundations of Mathematics.* Institute for Advanced Study, 2013.

17. **P. Martin-Löf.** *Intuitionistic Type Theory.* Bibliopolis, 1984.

### Formalization and Mechanization

18. **B. Aydemir et al.** "Mechanized Metatheory for the Masses: The POPLmark
    Challenge." *TPHOLs 2005*, LNCS 3603, pp. 50--65, 2005.

19. **A. Abel et al.** "POPLMark Reloaded: Mechanizing Proofs by Logical
    Relations." *Journal of Functional Programming*, 29:e19, 2019.

20. **A. W. Appel and D. McAllester.** "An Indexed Model of Recursive Types
    for Foundational Proof-Carrying Code." *ACM TOPLAS*, 23(5):657--683, 2001.

21. **A. Ahmed.** "Step-Indexed Syntactic Logical Relations for Recursive and
    Quantified Types." *ESOP 2006*, LNCS 3924, pp. 69--83, 2006.

### Normalization by Evaluation

22. **U. Berger and H. Schwichtenberg.** "An Inverse of the Evaluation
    Functional for Typed λ-Calculus." *LICS 1991*, pp. 203--211, 1991.

23. **T. Altenkirch, M. Hofmann, and T. Streicher.** "Categorical
    Reconstruction of a Reduction Free Normalization Proof." *CTCS 1995*,
    LNCS 953, pp. 182--199, 1995.

24. **A. Abel.** *Normalization by Evaluation: Dependent Types and
    Impredicativity.* Habilitation thesis, LMU Munich, 2013.

### Models

25. **D. S. Scott.** "Continuous Lattices." *Toposes, Algebraic Geometry and
    Logic*, LNM 274, pp. 97--136, 1972.

26. **M. Hofmann and T. Streicher.** "The Groupoid Interpretation of Type
    Theory." *In: Twenty-Five Years of Constructive Type Theory*, pp. 83--111,
    Oxford University Press, 1998.

27. **F. Barbanera and S. Berardi.** "Proof-Irrelevance out of Excluded-Middle
    and Choice in the Calculus of Constructions." *Journal of Functional
    Programming*, 6(3):519--525, 1996.

### Confluence

28. **A. Church and J. B. Rosser.** "Some Properties of Conversion." *Trans.
    Amer. Math. Soc.*, 39:472--482, 1936.

29. **M. Takahashi.** "Parallel Reductions in λ-Calculus." *Information and
    Computation*, 118(1):120--127, 1995.

### Canonicity and Cubical Type Theory

30. **S. Huber.** "Canonicity for Cubical Type Theory." *Journal of Automated
    Reasoning*, 2019.

31. **J. Sterling and C. Angiuli.** *Normalization for Cubical Type Theory.*
    *LICS 2021*, 2021.
