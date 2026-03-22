# The Calculus of Constructions

## Overview

The Calculus of Constructions (CoC), denoted λC or λPω, is a higher-order typed lambda calculus and type theory introduced by Thierry Coquand and Gérard Huet in 1985-1988. It occupies the apex of Barendregt's lambda cube, unifying all three dimensions of type dependency: terms depending on types (polymorphism), types depending on types (type operators), and types depending on terms (dependent types). Through the Curry-Howard correspondence, CoC serves as a proof system for higher-order intuitionistic predicate logic. It is the theoretical foundation of the Coq/Rocq proof assistant (via its extension, the Calculus of Inductive Constructions).

CoC is characterized by several remarkable properties: strong normalization (all reduction sequences terminate), confluence (the Church-Rosser property), decidability of type checking, an impredicative universe of propositions, and the ability to express both programs and proofs within a single unified formalism.

**Cross-references:** CoC is situated in the lambda cube as described in Doc 05. Its extension with primitive inductive types (the Calculus of Inductive Constructions) is the subject of Doc 07. Metatheoretic properties and proof techniques for CoC and related systems are surveyed in Doc 10.

---

## 1. Historical Context

### 1.1 The Automath Lineage

The Calculus of Constructions emerged from several converging lines of research in logic, type theory, and proof formalization:

- **N.G. de Bruijn and Automath (1968-1970s).** De Bruijn initiated the Automath project at Eindhoven University of Technology, the first large-scale attempt to formalize and mechanically verify mathematical proofs. Automath introduced several key ideas that influenced CoC: the use of the Curry-Howard isomorphism as a foundational principle for proof verification, a unified syntax where proofs and terms share the same language, and the technique of de Bruijn indices for handling bound variables. The project culminated in van Benthem Jutting's verification of Landau's *Grundlagen der Analysis* in the 1970s.

- **Per Martin-Löf and Intuitionistic Type Theory (1971-1984).** Martin-Löf developed his intuitionistic type theory as a constructive foundation for mathematics, introducing dependent types, contexts, identity types, and a predicative universe hierarchy. From Martin-Löf's type theory, CoC adopted the dependent product (Pi-type) and the concept of propositions-as-types with contexts.

- **Jean-Yves Girard and System F (1972).** Girard's System F (the polymorphic lambda calculus) and its higher-order extension System Fω provided the mechanism of impredicative polymorphism -- the ability to quantify over all types, including the type of the quantified expression itself. From System Fω, CoC adopted impredicative quantification over the universe of propositions.

### 1.2 Coquand and Huet

Thierry Coquand presented the first version of the Calculus of Constructions in his PhD thesis at the University of Paris VII, defended on January 31, 1985. The system combined features from Martin-Löf's type theory and Girard's System Fω in a higher-order extension of the Automath framework:

- The system used a single binding operator for both universal quantification (dependent product at the type level) and functional abstraction (lambda) at the term level, in the manner of Automath.
- Substitution (beta-reduction) was implemented using de Bruijn's indices.

The initial presentation appeared at EUROCAL '85 as "Constructions: A Higher Order Proof System for Mechanizing Mathematics" (Coquand and Huet, 1985). The definitive journal paper, "The Calculus of Constructions," was published in *Information and Computation*, 76(2-3):95-120 (1988).

Coquand's metamathematical investigation of the system, including the strong normalization proof, circulated privately in February 1987 and was later published in 1990 in Odifreddi's *Logic and Computer Science*.

### 1.3 Subsequent Developments

- **Barendregt's Lambda Cube (1991).** Henk Barendregt systematized the landscape of typed lambda calculi by organizing eight systems into a cube, with CoC at the apex. He also introduced the framework of Pure Type Systems (PTS), which provides a uniform syntax for all systems in the cube and beyond.

- **Calculus of Inductive Constructions (1989-1993).** Christine Paulin-Mohring and Frank Pfenning extended CoC with primitive inductive types, creating the Calculus of Inductive Constructions (CIC), which became the theoretical basis for the Coq proof assistant.

---

## 2. Syntax

### 2.1 Sorts

The Calculus of Constructions has two sorts:

- **Prop** (also written ∗ or `*`): the sort of propositions. Prop is impredicative.
- **Type** (also written □ or `Box`): the sort of types (the sort that classifies Prop and other type-level entities).

The axiom relating them is:

```
Prop : Type
```

In Barendregt's notation: `∗ : □`.

### 2.2 Terms

The syntax of CoC terms is remarkably uniform. All entities -- terms, types, propositions, and proofs -- live in a single syntactic category:

```
t, T ::= x                    -- variables
       | Prop                  -- sort of propositions
       | Type                  -- sort of types
       | λ(x : A). t           -- lambda abstraction
       | Π(x : A). B           -- dependent product (Pi-type)
       | t₁ t₂                 -- application
```

When `x` does not appear free in `B`, the dependent product `Π(x : A). B` is written as the non-dependent function type `A → B`.

### 2.3 Contexts

A context Γ is an ordered sequence of variable declarations:

```
Γ ::= ∅ | Γ, x : A
```

where each variable is declared with its type. The typing judgment has the form `Γ ⊢ t : T`, meaning "in context Γ, term t has type T."

---

## 3. Typing Rules

The typing rules of CoC can be presented as a Pure Type System. As a PTS, CoC is defined by:

- **Sorts:** S = {∗, □}
- **Axioms:** A = {(∗, □)}   (i.e., Prop : Type)
- **Rules:** R = {(∗, ∗), (□, ∗), (∗, □), (□, □)}

The rules specify which dependent products can be formed: a rule (s₁, s₂) means that if `A : s₁` and `B : s₂` (where `B` may depend on a variable of type `A`), then `Π(x : A). B : s₂`.

### 3.1 Inference Rules

The formal inference rules are as follows:

**(Axiom)**
```
─────────────────
  ∅ ⊢ Prop : Type
```

**(Start / Variable Introduction)**
```
  Γ ⊢ A : s       s ∈ {Prop, Type}
──────────────────────────────────────
  Γ, x : A ⊢ x : A
```

**(Weakening)**
```
  Γ ⊢ t : T       Γ ⊢ A : s       s ∈ {Prop, Type}
───────────────────────────────────────────────────────
  Γ, x : A ⊢ t : T
```

**(Product / Π-Formation)**
```
  Γ ⊢ A : s₁       Γ, x : A ⊢ B : s₂       (s₁, s₂) ∈ R
──────────────────────────────────────────────────────────────
  Γ ⊢ Π(x : A). B : s₂
```

**(Abstraction / λ-Introduction)**
```
  Γ, x : A ⊢ t : B       Γ ⊢ Π(x : A). B : s       s ∈ {Prop, Type}
────────────────────────────────────────────────────────────────────────
  Γ ⊢ λ(x : A). t : Π(x : A). B
```

**(Application)**
```
  Γ ⊢ f : Π(x : A). B       Γ ⊢ a : A
──────────────────────────────────────────
  Γ ⊢ f a : B[x := a]
```

**(Conversion)**
```
  Γ ⊢ t : A       A =_β B       Γ ⊢ B : s       s ∈ {Prop, Type}
────────────────────────────────────────────────────────────────────
  Γ ⊢ t : B
```

### 3.2 The Four Rule Triples

The four rules in R correspond to four distinct capabilities of the system. Each rule (s₁, s₂) governs the formation of Π(x : A). B where A : s₁ and B : s₂:

1. **(∗, ∗) -- Terms depending on terms.** This is the rule for ordinary function types. If A : Prop and B : Prop, then Π(x : A). B : Prop. This corresponds to logical implication: if A and B are propositions, then "A implies B" is a proposition.

2. **(□, ∗) -- Terms depending on types (polymorphism).** If A : Type and B : Prop (possibly depending on x : A), then Π(x : A). B : Prop. This allows universal quantification over types in propositions. Note that the example must land in Prop: e.g., Leibniz equality `Eq := λ(A : Type). λ(x y : A). Π(P : A → Prop). P x → P y` has type `Π(A : Type). A → A → Prop`, which is a proposition (since the body `A → A → Prop` is in Prop for each `A : Type`). By contrast, `Π(α : Type). α → α` has sort Type, not Prop, because when `α : Type`, the body `α → α` has sort Type (by the (□, □) rule), so the product is formed by (□, □) and lands in Type.

3. **(∗, □) -- Types depending on terms (dependent types).** If A : Prop and B : Type (possibly depending on x : A), then Π(x : A). B : Type. This allows type families indexed by proof terms.

4. **(□, □) -- Types depending on types (type operators).** If A : Type and B : Type (possibly depending on x : A), then Π(x : A). B : Type. This allows type-level functions, such as `List : Type → Type`.

These four rules correspond exactly to the four faces of the lambda cube that CoC activates. In contrast:
- The simply typed lambda calculus (λ→) has only rule (∗, ∗).
- System F (λ2) adds (□, ∗).
- λP (LF) adds (∗, □) to λ→.
- System Fω adds (□, □) to System F.

---

## 4. Reduction

### 4.1 Beta Reduction

The fundamental computation rule is beta-reduction:

```
(λ(x : A). t) a  →_β  t[x := a]
```

where `t[x := a]` denotes the capture-avoiding substitution of `a` for `x` in `t`.

Beta-reduction extends to a compatible relation on terms: it can be applied at any position within a term. We write `→_β` for the one-step reduction, `→_β*` for its reflexive-transitive closure (multi-step reduction), and `=_β` for the equivalence relation generated by `→_β` (beta-convertibility).

### 4.2 Confluence (Church-Rosser Property)

Beta-reduction in CoC is confluent: if `t →_β* u₁` and `t →_β* u₂`, then there exists a term `v` such that `u₁ →_β* v` and `u₂ →_β* v`. This ensures that every term has at most one beta-normal form.

Confluence for CoC follows from the general confluence theorem for the untyped lambda calculus (since CoC beta-reduction is a restriction of untyped beta-reduction), though typed confluence proofs also exist.

### 4.3 Eta-Reduction and Eta-Expansion

Some presentations of CoC also include eta-reduction:

```
λ(x : A). f x  →_η  f       (when x ∉ FV(f))
```

or equivalently, eta-expansion. The eta rule corresponds to the extensionality principle for functions. In the Coq/Rocq implementation, eta-conversion (βη-convertibility) is part of the definitional equality used in type checking.

### 4.4 Delta and Iota Reduction

In the extended Calculus of Inductive Constructions (CIC), additional reduction rules appear:
- **Delta-reduction (δ):** Unfolding of defined constants.
- **Iota-reduction (ι):** Computation rules for eliminators of inductive types (pattern matching).
- **Zeta-reduction (ζ):** Unfolding of local let-bindings.

These are not part of the pure CoC but are essential in practical implementations.

---

## 5. Strong Normalization

### 5.1 Statement

**Theorem (Strong Normalization).** Every well-typed term in the Calculus of Constructions is strongly normalizing: there is no infinite sequence of beta-reductions starting from any well-typed term.

Equivalently: every reduction sequence from a well-typed term eventually reaches a (unique, by confluence) beta-normal form.

### 5.2 Consequences

Strong normalization has several critical consequences:

- **Consistency.** The type `Π(A : Prop). A` (the proposition "for all propositions A, A holds") is not inhabited by any closed term. If it were, we could derive a proof of any proposition, including falsehood. Strong normalization prevents the construction of such terms through non-terminating self-application.

- **Decidability of beta-convertibility.** To check whether `A =_β B`, it suffices to reduce both `A` and `B` to their normal forms and compare them for alpha-equivalence. Since reduction always terminates, this is decidable.

- **Decidability of type checking** (see Section 6).

### 5.3 Proof Techniques

Several distinct proof techniques have been developed for strong normalization of CoC:

1. **Kripke-style reducibility / saturated sets (Coquand and Gallier, 1990).** The original proof by Coquand used a Kripke-style interpretation. Coquand and Gallier (1990) gave a proof using a Kripke-like interpretation where types are interpreted as sets of strongly normalizing terms, indexed over possible extensions of the context.

2. **Girard's reducibility candidates.** An adaptation of Girard's method (originally for System F) interprets types as sets of strongly normalizing terms (reducibility candidates or saturated sets) satisfying closure conditions. The key difficulty is handling the impredicativity of Prop: since Prop allows quantification over all types including Prop itself, the interpretation must be carefully stratified.

3. **Reduction to System Fω (Geuvers and Nederhof, 1991).** A modular approach showing that strong normalization of CoC can be reduced to strong normalization of System Fω. Since Fω's strong normalization is known (via Girard's proof), this yields a modular proof.

4. **Short proof via saturated sets (Barras and Werner, 1997).** A relatively short direct proof using two different interpretations based on saturated sets, exploiting the idea of interpreting types as specific sets of strongly normalizing lambda-terms.

5. **Topos-theoretic approach.** A "generic" strong normalization argument based on the topos generated from a quotient of strongly normalizing untyped lambda-terms, reducing the property to the validity of two "stripping arguments."

### 5.4 The Role of Impredicativity

The impredicativity of Prop is the principal source of difficulty in strong normalization proofs for CoC, compared to predicative systems like Martin-Löf type theory. The type `Π(A : Prop). ...` quantifies over all propositions, including the very proposition being defined. This circularity must be broken in the semantic interpretation -- typically by showing that the interpretation is well-defined despite the apparent circularity, using fixed-point arguments or careful stratification.

---

## 6. Decidability of Type Checking

### 6.1 Statement

**Theorem.** Type checking for the Calculus of Constructions is decidable. That is, there exists an algorithm which, given a context Γ, a term t, and a type T, determines whether `Γ ⊢ t : T` is derivable.

### 6.2 Proof Sketch

The decidability of type checking follows from two key properties:

1. **Strong normalization** ensures that every well-typed term has a normal form, and that reduction to normal form terminates.

2. **Confluence** ensures that normal forms are unique (up to alpha-equivalence).

Together, these properties make beta-convertibility (`A =_β B`) decidable: normalize both sides and compare. Since the conversion rule is the only rule that requires checking convertibility, and all other rules are syntax-directed, type checking reduces to:
- Recursively synthesizing or checking types according to the syntax of the term.
- Checking beta-convertibility at conversion points (which is decidable).

### 6.3 Type Inference

A stronger result holds: **type inference** is also decidable for CoC. Given a context Γ and a term t (with full type annotations on lambda-binders), one can compute the type T such that `Γ ⊢ t : T`, or determine that no such type exists. The algorithm proceeds by structural recursion on terms, using normalization to compare types.

### 6.4 Undecidability of Inhabitation

While type checking is decidable, **type inhabitation** (given Γ and T, does there exist a term t with `Γ ⊢ t : T`?) is undecidable. This corresponds, via Curry-Howard, to the undecidability of provability in higher-order intuitionistic predicate logic.

---

## 7. Curry-Howard Correspondence: CoC as Higher-Order Intuitionistic Predicate Logic

### 7.1 The Correspondence

The Calculus of Constructions realizes a deep extension of the Curry-Howard correspondence (also called the Curry-Howard-de Bruijn isomorphism). Under this correspondence:

| **Logic**                        | **Type Theory (CoC)**                    |
|----------------------------------|------------------------------------------|
| Proposition                      | Type (in sort Prop)                      |
| Proof of proposition A           | Term of type A                           |
| Implication A → B                | Function type Π(_ : A). B               |
| Universal quantification ∀x:D.P | Dependent product Π(x : D). P           |
| Conjunction A ∧ B                | Encoded as Π(C : Prop). (A → B → C) → C |
| Disjunction A ∨ B                | Encoded as Π(C : Prop). (A → C) → (B → C) → C |
| Existential ∃x:D.P              | Encoded as Π(C : Prop). (Π(x : D). P → C) → C |
| Falsehood ⊥                     | Π(C : Prop). C                          |
| Negation ¬A                      | A → ⊥, i.e., A → Π(C : Prop). C        |
| Truth ⊤                          | Π(C : Prop). C → C                      |

### 7.2 Higher-Order Quantification

The key advance of CoC over simpler typed lambda calculi is that it supports quantification over propositions and predicates. The rule (□, ∗) allows forming types like:

```
Π(P : A → Prop). ...
```

This corresponds to second-order (and higher-order) quantification in logic: "for all predicates P on A, ..."

More generally, CoC corresponds to **higher-order intuitionistic predicate logic** (also called higher-order many-sorted intuitionistic predicate logic). Geuvers (1993) established the precise relationship, showing that the Curry-Howard-de Bruijn isomorphism maps the type system λPREDω (a subsystem of CoC) onto higher-order many-sorted intuitionistic predicate logic.

### 7.3 Natural Deduction

CoC can be viewed as a natural deduction system for higher-order intuitionistic logic:
- Lambda abstraction corresponds to the introduction rule for implication (and universal quantification).
- Application corresponds to the elimination rule (modus ponens / universal instantiation).
- Beta-reduction corresponds to cut elimination / proof normalization.

Strong normalization of CoC then corresponds to the cut-elimination theorem for higher-order intuitionistic predicate logic.

---

## 8. Expressiveness

### 8.1 What Can Be Encoded

Despite its minimal syntax, CoC can encode a remarkable range of mathematical and logical concepts:

**Logical connectives.** As shown in Section 7.1, all standard logical connectives (conjunction, disjunction, negation, existential quantification, falsehood, truth) can be defined using impredicative encodings over Prop.

**Natural numbers (Church-style).**
```
Nat := Π(A : Prop). A → (A → A) → A
zero := λ(A : Prop). λ(z : A). λ(s : A → A). z
succ := λ(n : Nat). λ(A : Prop). λ(z : A). λ(s : A → A). s (n A z s)
```

**Polymorphic identity.**
```
id := λ(A : Type). λ(x : A). x  :  Π(A : Type). A → A
```

**Leibniz equality.**
```
Eq := λ(A : Type). λ(x : A). λ(y : A). Π(P : A → Prop). P x → P y
```

**Iteration principles.** Church encodings support iteration (primitive recursion on the structure of terms via their Church encoding).

### 8.2 Large Eliminations

CoC supports **large eliminations**: functions from terms to types. For example, one can define type-valued functions:

```
f : Bool → Type
f true  = Nat
f false = Bool
```

where Bool and Nat are suitably encoded. This is made possible by the rule (∗, □), which allows types to depend on terms.

---

## 9. Limitations: What Cannot Be Encoded Without Extensions

### 9.1 The Induction Problem

The most significant limitation of pure CoC is the **inability to derive induction principles** for Church-encoded data types. While natural numbers, booleans, lists, and other data types can be Church-encoded, the resulting encodings only support *iteration* (fold/catamorphism), not full *induction* (recursion with access to the induction hypothesis).

Concretely, for Church-encoded natural numbers `Nat := Π(A : Prop). A → (A → A) → A`, one cannot construct a term of type:

```
Π(P : Nat → Prop). P zero → (Π(n : Nat). P n → P (succ n)) → Π(n : Nat). P n
```

This is a fundamental limitation: no matter how cleverly natural numbers are encoded in pure CoC, the full induction principle is not derivable.

### 9.2 Consequences

This limitation means that:
- Many natural mathematical theorems cannot be proven in pure CoC.
- Efficient pattern matching and case analysis on data types is not directly available.
- Recursive function definitions that require structural recursion (beyond iteration) cannot be expressed.

### 9.3 Solutions

Several approaches address this limitation:

1. **Calculus of Inductive Constructions (CIC).** The most successful approach, introduced by Paulin-Mohring and Pfenning (1989, 1993), extends CoC with primitive inductive type definitions, complete with constructors, eliminators, and computation rules (iota-reduction). This is the foundation of Coq/Rocq.

2. **Self Types (Stump, 2014).** A more minimal extension that adds "self types" to CoC, enabling the derivation of induction principles without the full machinery of CIC.

3. **Impredicative encodings with axioms.** One can postulate induction principles as axioms, but this sacrifices the computational content (axioms do not reduce).

---

## 10. Impredicativity of Prop

### 10.1 Definition

The sort Prop in CoC is **impredicative**: the rule (□, ∗) allows the formation of propositions that quantify over all types, including Prop itself. Concretely, if `A : Type` (which includes Prop, since Prop : Type) and `B : Prop` (with `x : A` in scope), then `Π(x : A). B : Prop`.

This means a proposition can quantify over all propositions:

```
Π(P : Prop). P → P   :   Prop
```

The defining proposition "for all propositions P, P implies P" is itself a proposition -- it belongs to the very universe over which it quantifies. This is the hallmark of impredicativity.

### 10.2 Contrast with Predicative Systems

In predicative systems like Martin-Löf type theory:
- Types are stratified into a hierarchy: Type₀, Type₁, Type₂, ...
- A type quantifying over Type_i lives in Type_{i+1}.
- There is no universe that contains types quantifying over itself.

### 10.3 Consequences of Impredicativity

**Power.** Impredicativity enables the Church encodings of logical connectives and data types described in Section 8. Without impredicativity, one cannot define `∀(A : Prop). ...` as a proposition.

**Second-order encodings.** The impredicative encodings of connectives (Section 7.1) are essentially the same as those in System F, which is also impredicative.

**Consistency.** Despite the apparent circularity, CoC with impredicative Prop is consistent (as established by the strong normalization theorem). However, Girard's paradox shows that unrestricted impredicativity (Type : Type) leads to inconsistency. CoC avoids this by having only Prop be impredicative, while Type is stratified (in extended versions).

**Set-theoretic models.** Impredicativity complicates the construction of set-theoretic models. Naive set-theoretic interpretations fail because one cannot form a set of all sets. Successful models require more sophisticated constructions (see Section 14).

---

## 11. Relationship to Martin-Löf Type Theory

### 11.1 Shared Features

Both CoC and Martin-Löf type theory (MLTT) share:
- Dependent function types (Pi-types / dependent products)
- The propositions-as-types paradigm
- Constructive foundations (no excluded middle by default)
- Contexts and typing judgments of the same general form

### 11.2 Key Differences

| **Feature**                 | **Martin-Löf Type Theory**           | **Calculus of Constructions**          |
|-----------------------------|--------------------------------------|----------------------------------------|
| **Prop universe**           | No distinguished Prop sort           | Impredicative Prop sort                |
| **Predicativity**           | Fully predicative                    | Impredicative at Prop level            |
| **Universe hierarchy**      | Type₀ : Type₁ : Type₂ : ...         | Prop : Type (basic); extended versions add Type hierarchy |
| **Inductive types**         | Primitive (W-types, identity types)  | Not primitive (must be added as CIC)   |
| **Proof relevance**         | All proofs are relevant              | Supports proof irrelevance for Prop    |
| **Polymorphism**            | Via universe polymorphism            | Via impredicative quantification       |
| **Logical strength**        | Predicative (weaker)                 | Impredicative (stronger)               |

### 11.3 Philosophical Differences

Martin-Löf type theory is designed as a **meaning explanation** -- types are defined by what it means to construct an object of that type, and the theory is justified by a pre-mathematical understanding of construction. Every type former has a constructive interpretation.

The Calculus of Constructions, by contrast, is justified more **proof-theoretically**: consistency follows from strong normalization, which is established by semantic methods (reducibility candidates, etc.). The impredicativity of Prop does not have an obvious constructive meaning explanation in Martin-Löf's sense.

---

## 12. Proof Irrelevance

### 12.1 The Concept

Proof irrelevance is the principle that two proofs of the same proposition are considered equal (interchangeable). In the context of CoC:

- For types in Prop, one may consider all inhabitants (proofs) as equal.
- For types in Type, distinct inhabitants (programs) are distinguishable.

### 12.2 Role in CoC

In the pure Calculus of Constructions, proof irrelevance is not built into the system as a judgmental equality -- distinct proof terms of the same type are syntactically distinct. However:

- **Semantic proof irrelevance.** The simplest set-theoretic model of CoC interprets all proof terms of a given proposition as a single object (typically a singleton set or a distinguished element). This is the proof-irrelevant model studied by Werner (1997). While conceptually simple, this model raises subtle difficulties related to the soundness of the interpretation at the impredicative level.

- **Prop vs. Type distinction.** In implementations like Coq/Rocq, the distinction between Prop and Type is closely tied to proof irrelevance: terms in Prop are erased during extraction (compilation to executable code), reflecting the view that proofs carry no computational content.

- **Berardi's result.** Berardi (1990) showed that in the presence of excluded middle and the axiom of choice, proof irrelevance is derivable in CoC. More precisely: if one assumes classical logic axioms within CoC, then any two proofs of the same proposition in Prop are provably equal (via Leibniz equality).

### 12.3 Consequences

- Proof irrelevance supports program extraction: proofs can be erased without affecting computational behavior.
- It justifies the view that Prop classifies "mere propositions" (homotopy level -1 in HoTT terminology).
- It interacts subtly with universe polymorphism and large eliminations.

---

## 13. Universe Hierarchies and Universe Polymorphism

### 13.1 The Basic CoC

In the minimal presentation, CoC has only two sorts: Prop and Type, with Prop : Type. This is sufficient for the core theory but leads to limitations in practice -- one cannot stratify the Type level.

### 13.2 Extended Universe Hierarchy

In practice (and in CIC as implemented in Coq/Rocq), the universe hierarchy is:

```
Prop : Type₀ : Type₁ : Type₂ : ...
```

with cumulativity: if `A : Type_i`, then also `A : Type_{i+1}`.

The rules for product formation in the extended system:
- **Impredicative Prop:** If `A : Type_i` and `B : Prop`, then `Π(x : A). B : Prop` (the sort does not "go up").
- **Predicative Type:** If `A : Type_i` and `B : Type_j`, then `Π(x : A). B : Type_{max(i,j)}`.

This hybrid system maintains the impredicativity of Prop while keeping all Type levels predicative, avoiding Girard's paradox.

### 13.3 Universe Polymorphism

Universe polymorphism, formalized by Sozeau and Tabareau (2014) for Coq, allows definitions to be polymorphic over universe levels:

- A definition can be parameterized by universe level variables: `u, v, ...`.
- Universe constraints (e.g., `u < v`, `u ≤ v`) are tracked and checked.
- This enables generic definitions that work at any universe level, avoiding code duplication.

For example, a universe-polymorphic identity function:
```
id@{u} : Type@{u} → Type@{u}
```

Universe polymorphism is essential for practical use of the type theory, allowing library code to be reused across different universe levels without manual stratification.

### 13.4 Typical Ambiguity

An alternative to explicit universe polymorphism is **typical ambiguity** (as in the original Automath): the user writes `Type` without a level annotation, and the system infers consistent level assignments. This is less expressive but simpler to use.

---

## 14. Consistency and Logical Strength

### 14.1 Consistency

The consistency of CoC follows from strong normalization:

1. Strong normalization implies that every well-typed term has a normal form.
2. By inspection of the typing rules, the type `Π(A : Prop). A` (falsehood, interpreted as "every proposition is provable") has no closed normal inhabitant.
3. Therefore, CoC is consistent: it does not prove every proposition.

### 14.2 Logical Strength

The logical strength of CoC is substantially greater than that of predicative systems:

- CoC is **stronger than second-order arithmetic** (PA₂ / Z₂). The impredicative quantification over Prop gives it the power of higher-order logic.
- CoC is **comparable in strength to higher-order arithmetic** (HOA), though the precise relationship depends on the exact formulation.
- The exact **proof-theoretic ordinal** of CoC is not known. Current techniques for ordinal analysis are limited to predicative systems (with ordinals below the Bachmann-Howard ordinal or Γ₀), and impredicative systems like CoC are well beyond the reach of existing ordinal analysis methods.
- CoC is **consistent relative to** ZFC set theory (and much weaker theories suffice -- e.g., the existence of an inaccessible cardinal suffices for many extensions of CIC).

### 14.3 What CoC Proves

- All theorems of higher-order intuitionistic predicate logic.
- All theorems provable in System Fω (since CoC extends Fω).
- The consistency of Peano Arithmetic (via Gentzen-style encoding).
- Various results in constructive mathematics that can be expressed using the available encodings.

### 14.4 What CoC Does Not Prove (Without Additional Axioms)

- The law of excluded middle (A ∨ ¬A).
- The axiom of choice (though weaker forms are derivable).
- Induction principles for Church-encoded data types (see Section 9).
- Results requiring large cardinal strength or impredicative set-theoretic principles beyond what CoC's impredicativity provides.

---

## 15. Models of CoC

### 15.1 Set-Theoretic Models

The simplest class of models interprets types as sets and terms as elements:

- **Proof-irrelevant model.** Propositions (types in Prop) are interpreted as elements of {0, 1} (truth values), and all proof terms of a given proposition are mapped to a single element. Types in Type are interpreted as sets. Function types are interpreted as set-theoretic function spaces. This model validates consistency but, as Werner (1997) showed, the soundness proof for this model is surprisingly delicate due to the impredicative level.

- **CC-structures.** A set-theoretic notion of model introduced for strong normalization proofs, where types are interpreted as sets of strongly normalizing lambda-terms with appropriate closure conditions.

### 15.2 Realizability Models

Realizability models interpret types as sets of "realizers" (typically lambda-terms or codes for computable functions):

- **Modified realizability.** Hyland and Ong showed that given a conditionally partial combinatory algebra, one can construct a modified realizability topos with sufficient completeness properties to provide categorical semantics for CoC.

- **Realizability toposes.** The effective topos and related constructions provide models where types are interpreted as assemblies or partial equivalence relations (PERs) on a partial combinatory algebra.

### 15.3 Categorical Models

The most abstract class of models uses category theory:

- **Locally cartesian closed categories (LCCCs).** Dependent type theories (including CoC, with additional structure) can be modeled in LCCCs, where:
  - Types are objects.
  - Terms are morphisms.
  - Dependent products are right adjoints to pullback functors.
  - Contexts are objects in a slice category.

- **Toposes.** An elementary topos with a natural numbers object provides enough structure to model much of CoC. The impredicative Prop corresponds to the subobject classifier Ω of the topos.

- **Categories with families (CwFs).** A more refined categorical semantics using categories with families, as developed by Dybjer and others, provides a close match to the syntax of type theories including CoC.

- **Hyland-Pitts models.** Hyland and Pitts (1989) developed topos-theoretic models specifically for the Calculus of Constructions, establishing the categorical semantics of the theory.

### 15.4 Domain-Theoretic Models

Domain-theoretic models interpret types as domains (complete partial orders or similar structures) and terms as continuous functions. These models are particularly relevant for understanding the computational aspects of CoC.

---

## 16. Key References

### Foundational Papers

- Coquand, T. and Huet, G. (1988). "The Calculus of Constructions." *Information and Computation*, 76(2-3):95-120.
- Coquand, T. (1985). *Une Théorie des Constructions.* PhD thesis, University of Paris VII.
- Coquand, T. (1990). "Metamathematical Investigations of a Calculus of Constructions." In *Logic and Computer Science*, Academic Press.

### Lambda Cube and Pure Type Systems

- Barendregt, H. (1991). "Introduction to Generalized Type Systems." *Journal of Functional Programming*, 1(2):125-154.
- Barendregt, H. (1992). *Lambda Calculi with Types.* In *Handbook of Logic in Computer Science*, Vol. 2, Oxford University Press.

### Strong Normalization

- Coquand, T. and Gallier, J.H. (1990). "A Proof of Strong Normalization for the Theory of Constructions Using a Kripke-Like Interpretation."
- Geuvers, H. and Nederhof, M.J. (1991). "A Modular Proof of Strong Normalization for the Calculus of Constructions." *Journal of Functional Programming*, 1(2):155-189.
- Barras, B. and Werner, B. (1997). "A Short and Flexible Proof of Strong Normalization for the Calculus of Constructions."

### Curry-Howard and Higher-Order Logic

- Geuvers, H. (1993). "The Calculus of Constructions and Higher Order Logic."
- Howard, W.A. (1980). "The formulae-as-types notion of construction." In *To H.B. Curry: Essays on Combinatory Logic, Lambda Calculus, and Formalism*, Academic Press.

### Models and Semantics

- Hyland, M. and Pitts, A. (1989). "The Theory of Constructions: Categorical Semantics and Topos-Theoretic Models."
- Werner, B. (1997). "The Not So Simple Proof-Irrelevant Model of CC."

### Extensions

- Paulin-Mohring, C. (1993). "Inductive Definitions in the System Coq: Rules and Properties."
- Sozeau, M. and Tabareau, N. (2014). "Universe Polymorphism in Coq." *ITP 2014*.

### Historical Predecessors

- de Bruijn, N.G. (1970). "The Mathematical Language AUTOMATH."
- Martin-Löf, P. (1984). *Intuitionistic Type Theory.* Bibliopolis.
- Girard, J.-Y. (1972). *Interprétation fonctionnelle et élimination des coupures de l'arithmétique d'ordre supérieur.* PhD thesis, Paris VII.
