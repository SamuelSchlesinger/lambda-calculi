# Universe Polymorphism and Universe Hierarchies in Type Theory

## Overview

Universe polymorphism is a mechanism in dependent type theory that allows
definitions to be parameterized over universe levels, enabling code reuse across
the stratified hierarchy of type universes. Universes were introduced to avoid
the inconsistency that arises from the axiom Type : Type (Girard's paradox), but
the resulting stratification creates a practical burden: definitions must be
duplicated at each universe level they are needed. Universe polymorphism addresses
this by allowing a single definition to serve at multiple levels, either
implicitly (via typical ambiguity and constraint inference) or explicitly (via
level parameters and level-indexed products).

This document surveys the theory, design space, and practical implementations of
universe hierarchies and universe polymorphism, covering historical foundations,
formal definitions, the key design decisions made by major proof assistants, and
the current state of the art in the metatheory.

---

## 1. Historical Context

### 1.1 Martin-Lof's Type Theory and the Type-in-Type Problem

In 1971, Per Martin-Lof proposed a type theory with the axiom Type : Type --
a single universe containing itself. In 1972, Jean-Yves Girard demonstrated
that this system is inconsistent by adapting the Burali-Forti paradox from set
theory into the type-theoretic setting. The resulting inconsistency, known as
**Girard's paradox**, showed that one cannot simultaneously have:

1. A type of propositions (Prop)
2. Impredicativity (Prop : Prop or Type : Type)
3. Unrestricted large elimination

This result profoundly shaped all subsequent type theory. Martin-Lof's response
was to introduce **predicativity**: rather than a single self-containing universe,
the theory uses a hierarchy of universes U_0, U_1, U_2, ..., where U_i : U_{i+1}
but U_i does not contain itself. This is sometimes called an **external** or
**Russell-style** universe hierarchy (see Section 3).

### 1.2 Girard's Paradox in Detail

Girard (1972) showed that System U (which combines the polymorphism of System F
with a type of all types) is inconsistent. The key idea is to encode an analogue
of the Burali-Forti paradox: one constructs a well-ordering of all well-orderings,
which must be longer than itself, yielding a contradiction.

Hurkens (1995) provided a dramatically simplified version of the paradox,
constructing a shorter term of type bottom in System U^- (a subsystem of System
U). The Hurkens construction works by building a universe U with two functions
forming an isomorphism between U and the powerset of its powerset, which is
inherently contradictory. This simplified paradox is formalized in the Coq/Rocq
standard library (Coq.Logic.Hurkens).

### 1.3 Typical Ambiguity

The convention of **typical ambiguity**, originating with Russell and Whitehead's
Principia Mathematica, allows universe level annotations to be omitted. The
understanding is that some consistent assignment of levels exists, even if it is
not written explicitly. Martin-Lof adopted this convention for his type theory:
one writes Type without subscripts, understanding that each occurrence refers to
some level, and that all levels can be chosen consistently.

This convention was mechanized by Huet in early implementations of the Calculus
of Constructions, and formalized by Harper and Pollack (1991) as a constraint-
based inference algorithm. In this approach, each occurrence of Type is assigned
a fresh universe variable, and typing derivations generate constraints (such as
u < v) between these variables. The term is well-typed if and only if the
constraint graph is acyclic -- that is, the variables can be mapped to natural
numbers satisfying all constraints.

---

## 2. Why Universes Are Necessary

### 2.1 Type : Type is Inconsistent

The axiom Type : Type makes the type theory inconsistent as a logic. This means
every proposition becomes provable, destroying the system's utility for
formalization. The proof (via Girard's paradox) constructs a term of the empty
type, which should be uninhabited in a consistent system.

More precisely, System U (Girard 1972) and even its fragment U^- (Hurkens 1995,
building on Coquand 1986) are inconsistent. The lesson is that impredicativity
must be carefully controlled.

### 2.2 The Universe Hierarchy as a Solution

The standard solution is a countably infinite hierarchy of universes:

    Type_0 : Type_1 : Type_2 : Type_3 : ...

Each Type_i classifies types at level i, and is itself classified by Type_{i+1}.
No universe contains itself. This stratification is the type-theoretic analogue of
the cumulative hierarchy of sets in set theory (V_0 ⊂ V_1 ⊂ V_2 ⊂ ...).

### 2.3 Predicativity

A definition is **predicative** if it does not quantify over the universe in which
the defined entity lives. A definition is **impredicative** if it does. For
example, the type (forall A : Type_i, A -> A) lives in Type_i if the
quantification over A ranges over Type_i itself -- this is impredicative.

Most modern type theories maintain predicativity for computational universes
(Type / Set) while allowing impredicativity for the propositional universe (Prop),
since propositions are proof-irrelevant and the logical power of impredicative
quantification is needed for many constructions (e.g., encoding inductive types,
second-order logic).

---

## 3. Russell-Style vs. Tarski-Style Universes

There are two fundamental approaches to formalizing universes in type theory,
named by analogy with Russell's and Tarski's approaches to truth.

### 3.1 Russell-Style Universes

In a Russell-style universe, types are directly elements of the universe. The
universe U_i is itself a type, and if A : U_i, then A can be used directly as a
type in judgments:

    Formation:
        A : U_i
        ────────
        A type

    Type former (example, dependent product):
        A : U_i    x : A ⊢ B : U_i
        ────────────────────────────
        (x : A) -> B : U_i

There is no distinction between "codes for types" and "types themselves." A term
A : U_i is simultaneously a term (an element of the universe) and a type (which
can classify other terms). This conflation simplifies notation and usage but
creates subtleties around definitional equality and the interaction with inductive
types.

**Used by:** Coq/Rocq, Lean 4, Agda (all in practice use Russell-style)

### 3.2 Tarski-Style Universes

In a Tarski-style universe, the universe U_i contains **codes** (names) for
types, and a separate decoding function El_i (or T_i) maps codes to the actual
types they represent:

    Formation:
        a : U_i
        ────────────
        El_i(a) type

    Type former codes (example, dependent product):
        a : U_i    x : El_i(a) ⊢ b : U_i
        ──────────────────────────────────
        pi_i(a, b) : U_i

    Decoding:
        El_i(pi_i(a, b)) = (x : El_i(a)) -> El_i(b)

The decoding equation typically holds as a **judgmental equality** (strict Tarski
universes). In **weak Tarski universes** (Gallozzi 2014), it holds only as a
propositional equivalence, which is more compatible with homotopy type theory but
harder to work with in practice.

**Advantages of Tarski style:**
- Semantically more precise and foundationally cleaner
- Avoids the "confusion of levels" inherent in Russell style
- Better for metatheoretic analysis
- Required when nesting universe constructions with full precision

**Advantages of Russell style:**
- Simpler notation: no need for explicit El operators
- More natural for users
- Adopted by all major proof assistants for practical reasons

**Key result (negative):** For intensional type theories, Russell-style and
Tarski-style universes are **not** equivalent in general. Russell-style universes
can be incompatible with the general form of elimination rules for inductive
types.

### 3.3 Relationship

The Russell formulation can be viewed as an "informal abbreviation" of the Tarski
formulation, where the El operator is left implicit. In practice, proof assistants
use Russell-style presentation but may use Tarski-style representations
internally or in their metatheory.

---

## 4. Universe Hierarchies

### 4.1 The Basic Hierarchy

The standard universe hierarchy consists of an infinite tower:

    Type_0 : Type_1 : Type_2 : ... : Type_i : Type_{i+1} : ...

with the **axiom rules**:

    Type_i : Type_{i+1}    for all i in N

### 4.2 Prop as a Special Universe

Many type theories include a distinguished universe **Prop** (or Omega) for
propositions, which is **impredicative**: a product type (forall x : A, P x)
lives in Prop whenever P x : Prop, regardless of the universe level of A.

This impredicativity is consistent (unlike Type : Type) because Prop is
**proof-irrelevant** in an appropriate sense -- the computational content of
proofs is restricted. Specifically, large elimination from Prop into
computational universes is restricted to prevent inconsistency.

### 4.3 Coq/Rocq's Sort Design: Prop, Set, and Type

Coq/Rocq has a particularly nuanced sort structure:

- **Prop** : The impredicative universe of propositions. Prop : Type_1.
  Terms in Prop are proof-irrelevant (in the sense that the system restricts
  their computational use via elimination restrictions).

- **Set** : A predicative universe for "small" data types (natural numbers,
  booleans, lists, etc.). Set : Type_1. Since Coq 8.0 (2004), Set is
  predicative by default to maintain compatibility with classical axioms
  (specifically, the axiom of choice). Earlier versions had Set impredicative.

- **Type_i** (for i >= 1) : An infinite tower of predicative universes.
  Type_i : Type_{i+1}.

The **sort ordering** is: Prop <= Set <= Type_1 <= Type_2 <= ...

**Product formation rules in CIC:**

| Domain sort | Codomain sort | Product sort |
|------------|---------------|-------------|
| any sort s | Prop          | Prop (impredicative!) |
| Prop or Set| Set           | Set |
| Type_i     | Type_j        | Type(max(i,j)) |

The impredicativity of Prop is the first row: for any sort s (including
Type_i for arbitrarily large i), a product (forall x : s, P) where P : Prop
remains in Prop.

### 4.4 Lean 4's Sort Design: Prop, Type

Lean 4 uses a simpler two-tier design:

- **Sort 0** = **Prop** : The impredicative universe of propositions.
- **Sort (u+1)** = **Type u** : Predicative universes for data.
- **Type** = **Type 0** = **Sort 1** (when u is omitted).

Lean does **not** have a separate Set universe. The rules are:

- Prop is impredicative: a function returning Prop stays in Prop regardless of
  the domain's universe level.
- Type u is predicative: for (A : Type u) -> (B : Type v), the result lives in
  Type (max u v).
- The special level operation **imax u v** equals 0 when v = 0, and max(u, v)
  otherwise. This enables the rule that functions returning Prop stay in Prop.

### 4.5 Agda's Universe Design

Agda uses a simpler, non-cumulative hierarchy:

- **Set_0** (= Set) : Set_1 : Set_2 : ...
- No separate Prop universe (though --prop can enable one)
- **Non-cumulative**: A : Set_i does NOT imply A : Set_{i+1}
- **Setomega** : A universe above all Set_i, used to type expressions like
  (n : Level) -> Set n which do not fit in any Set_i.

Agda compensates for the lack of cumulativity through universe polymorphism
(see Section 7).

---

## 5. Universe Cumulativity

### 5.1 Subtyping-Based Cumulativity

In a **cumulative** universe hierarchy, any type belonging to a lower universe
automatically belongs to all higher universes:

    If A : Type_i and i <= j, then A : Type_j.

This is typically expressed as a subtyping relation:

    Type_i <= Type_j    when i <= j

Cumulativity extends to compound types via covariance and contravariance:

    If A' <= A and B <= B', then (A -> B) <= (A' -> B')

Cumulative universes are used by Coq/Rocq and in the HoTT Book's type theory.

### 5.2 Lifting-Based Approach

An alternative to cumulativity is to require **explicit lifting** operators.
If a type A : Type_i is needed at level j > i, one must apply a lift operator:

    Lift : Type_i -> Type_{i+1}

or more generally:

    ULift : Type_i -> Type_j    (for j >= i)

Lean 4 uses this approach (with the ULift and PLift types) since its universes
are **not** cumulative. If you have a type A : Type u and need it in Type (u+1),
you must explicitly wrap it using ULift.

### 5.3 Cumulative Inductive Types

Standard universe cumulativity applies only to sorts (Type_i <= Type_{i+1}).
**Cumulative inductive types** (Timany and Sozeau, 2018) extend cumulativity to
user-defined inductive types. Without this extension, an inductive type
Ind@{u} : Type_u is not a subtype of Ind@{v} : Type_v even when u <= v, forcing
explicit coercions.

The **Predicative Calculus of Cumulative Inductive Constructions (pCuIC)**
extends pCIC with cumulativity for inductive types using a **variance** system:

- **Covariant** (+) universe parameter: Ind@{u} <= Ind@{v} when u <= v
- **Contravariant** (-) universe parameter: Ind@{u} <= Ind@{v} when v <= u
- **Invariant** (=) universe parameter: Ind@{u} <= Ind@{v} only when u = v
- **Irrelevant** (*) universe parameter: Ind@{u} <= Ind@{v} always

Variance is automatically inferred by analyzing how universe parameters appear
in constructor types. For example, a record type whose fields are covariant in
a universe parameter will be covariant overall.

Timany and Sozeau (2017) proved the consistency of pCuIC relative to pCIC.

---

## 6. Universe Polymorphism: Motivation and Approaches

### 6.1 The Duplication Problem

Without universe polymorphism, one must define separate copies of common types
and functions at each universe level:

    -- In Agda without universe polymorphism:
    data List₀ (A : Set₀) : Set₀ where ...
    data List₁ (A : Set₁) : Set₁ where ...
    data List₂ (A : Set₂) : Set₂ where ...
    -- and every function on lists must be similarly duplicated

This is clearly untenable. Universe polymorphism allows a single definition:

    data List {l : Level} (A : Set l) : Set l where ...

### 6.2 Taxonomy of Approaches

Universe polymorphism exists on a spectrum of explicitness:

1. **Typical ambiguity** (Martin-Lof; Russell-Whitehead): Universe levels are
   simply omitted. The system checks that some consistent assignment exists.
   This is the least explicit approach.

2. **Implicit universe polymorphism** (Harper-Pollack 1991; Huet): Each
   definition has universe variables inferred automatically. Constraints between
   them are collected globally. This is the approach of early Coq.

3. **Local universe polymorphism** (Sozeau-Tabareau 2014): Definitions can be
   explicitly marked as universe-polymorphic. They carry local universe bindings
   and constraints, and can be instantiated at different levels. This is the
   approach of modern Coq/Rocq.

4. **Explicit universe polymorphism** (Lean 4; Gratzer-Sterling-Birkedal 2022):
   Universe level variables are explicitly declared, and level expressions (using
   max, successor, imax) appear in types. Definitions are universe-polymorphic
   by default.

5. **First-class universe levels** (Chan-Weirich 2025): Level expressions become
   first-class terms that can be abstracted over with dependent function types,
   subsuming level polymorphism through dependent quantification.

6. **Crude but effective stratification** (McBride): Every definition is given
   at the lowest possible concrete level, and a uniform "displacement" operation
   shifts all levels up by a constant when the definition is used at a higher
   level. Formalized order-theoretically by Favonia, Angiuli, and Mullanix (2023)
   using displacement algebras.

---

## 7. Universe Polymorphism in Practice

### 7.1 Coq/Rocq

Coq's universe polymorphism (Sozeau and Tabareau, 2014) allows declarations to
be parameterized by universe levels.

**Enabling polymorphism:**

    Set Universe Polymorphism.
    (* or use the #[universes(polymorphic)] attribute *)

**Declaring universes:**

    Universe u v.
    Constraint u < v.

**Polymorphic definitions:**

    Polymorphic Definition id {A : Type@{u}} (x : A) : A := x.

The definition id is now parameterized by universe level u. Each use of id can
instantiate u to a different level. Without polymorphism, a single global level
would be assigned, preventing self-application like (id id).

**Universe instances:**

    Check id@{Set} : Set -> Set.
    Check id@{Type} : Type -> Type.

**Cumulative inductive types:**

    #[universes(cumulative)]
    Inductive prod@{+u +v} (A : Type@{u}) (B : Type@{v}) : Type@{max(u,v)} :=
    | pair : A -> B -> prod A B.

The +u and +v annotations declare covariant universe parameters, enabling
prod@{u1 v1} <= prod@{u2 v2} when u1 <= u2 and v1 <= v2.

**Key commands and flags:**
- `Set Universe Polymorphism` : make all subsequent definitions polymorphic
- `Polymorphic` / `Monomorphic` : per-definition override
- `Universe` / `Universes` : declare named universe variables
- `Constraint` : add explicit constraints between universes
- `Set Polymorphic Inductive Cumulativity` : enable cumulative inductives
- `Universe Minimization ToSet` : minimize fresh universes to Set when possible

### 7.2 Agda

Agda's approach to universe polymorphism centers on the primitive **Level** type.

**The Level type and its operations:**

    Level  : primitive type
    lzero  : Level
    lsuc   : Level -> Level
    _⊔_    : Level -> Level -> Level

**Universe-polymorphic definitions:**

    data List {l : Level} (A : Set l) : Set l where
      []   : List A
      _::_ : A -> List A -> List A

    map : forall {l m} {A : Set l} {B : Set m} -> (A -> B) -> List A -> List B
    map f []       = []
    map f (x :: xs) = f x :: map f xs

**Level arithmetic properties** (handled automatically by the compiler):
- Idempotence, associativity, commutativity of ⊔
- Distributivity of lsuc over ⊔ : lsuc (a ⊔ b) = lsuc a ⊔ lsuc b
- Neutrality of lzero : lzero ⊔ a = a
- Absorption : a ⊔ lsuc a = lsuc a

**Setomega:**

Expressions like (l : Level) -> Set l do not fit in any Set_i. Agda introduces
Setomega (written Setω) to classify such types. Setomega stands above all
Set_i but exists outside the polymorphic hierarchy. In fact, there is an indexed
family Setω_i, where Setω_i : Setω_{i+1}.

**Configuration flags:**
- `--type-in-type` : disables universe consistency checking entirely
- `--omega-in-omega` : allows Setω : Setω (inconsistent)
- `{-# NO_UNIVERSE_CHECK #-}` : local exemption for specific datatypes

### 7.3 Lean 4

Lean 4 has explicit universe polymorphism built into the language from the ground up.

**Universe level expressions:**

    u + n     -- successor (n times)
    max u v   -- least upper bound
    imax u v  -- 0 if v = 0, else max u v

The **imax** operation is crucial: it ensures that a function type returning
Prop (Sort 0) remains in Prop regardless of the domain's universe level.
Specifically, Sort (imax u v) is Prop when v = 0.

**Universe-polymorphic definitions:**

    universe u v

    def id {α : Sort u} (a : α) : α := a

    -- or with auto-bound implicit universes (the default):
    def id' {α : Sort u} (a : α) : α := a

**Universe-polymorphic inductive types:**

    inductive List (α : Type u) : Type u where
      | nil  : List α
      | cons : α → List α → List α

**Key design principles:**
- Independent type arguments should have different universe variables
- The result type is typically in max of all universe variables (or one greater)
- Universe variables are auto-bound when autoImplicit is true (the default)
- The `universe` command explicitly declares universe variables for a scope

**Universe lifting types:**

Since Lean's universes are non-cumulative, explicit lifting is sometimes needed:
- `ULift.{v} (α : Type u) : Type (max u v)` -- lifts non-Prop types
- `PLift (α : Sort u) : Type u` -- lifts any sort (including Prop) by one level

---

## 8. Universe Level Expressions and Constraints

### 8.1 The Language of Level Expressions

Universe level expressions are built from a small algebra:

    l, m ::= x           -- level variable
           | 0           -- zero (base level)
           | l + 1       -- successor
           | max(l, m)   -- least upper bound (supremum)
           | imax(l, m)  -- impredicative max (Lean-specific)

This forms a **bounded semilattice** with the natural numbers as the standard
model: variables are mapped to natural numbers, max is the standard maximum,
and successor is +1.

Some systems (Gratzer-Sterling-Birkedal 2022) omit the zero constant
intentionally, to ensure that all universe-involving definitions remain
genuinely polymorphic.

### 8.2 Constraints

During type checking, **constraints** between universe level expressions are
generated:

    l = m       -- equality constraint
    l <= m      -- ordering constraint (l is at most m)
    l < m       -- strict ordering (equivalent to l + 1 <= m)

These constraints form a **constraint graph** where nodes are level variables
and edges represent ordering requirements. The system of constraints is
satisfiable if and only if the constraint graph is **acyclic** (for strict
constraints) or more precisely, if the variables can be assigned natural numbers
satisfying all constraints.

### 8.3 Constraint Solving Algorithms

The constraint solving problem reduces to:

1. Build a directed graph from the constraints
2. Check for cycles (involving at least one strict edge)
3. If acyclic, compute a topological ordering that assigns levels

This is decidable and can be done efficiently:

- **Cycle detection**: Decidable in polynomial time (linear in the size of the
  constraint graph via depth-first search)
- **Level assignment**: After confirming acyclicity, levels can be assigned by
  computing longest paths from source nodes
- **Universe minimization**: Assign each variable the smallest possible level
  consistent with all constraints

The algorithm used in Coq's type-checker refines the approach of Huet and
Harper-Pollack, maintaining a global constraint graph that is incrementally
updated as new definitions are checked.

### 8.4 Level Unification

When two universe-polymorphic terms must be unified (e.g., during elaboration),
the system must solve **level unification problems**: finding substitutions for
level variables that make two level expressions equal.

Level unification is more complex than constraint checking:

- It is **not unitary** in general (there may not be a single most general
  unifier)
- Whether it is finitary, infinitary, or of type zero (no algorithm exists that
  enumerates all solutions) remains an open question
- In practice, systems use heuristics and backtracking

### 8.5 Decidability

Thanks to normalization of the underlying type theory:

- **Type checking** in CC-omega (the Calculus of Constructions with a universe
  hierarchy) is **decidable**
- **Universe constraint satisfiability** is decidable (polynomial time)
- **Type inference** (computing the type of a term) is decidable in CC-omega,
  producing a term with universe variables and a set of constraints

---

## 9. Interaction with Other Features

### 9.1 Universe Polymorphism and Inductive Types

Inductive types interact with universes in several ways:

**Universe of an inductive type:** The universe level of an inductive type is
determined by the universe levels of its constructor argument types. For a
non-recursive inductive type with constructors taking arguments in Type_i, the
inductive type lives in Type_i (or Type_{i+1} if it is "large" -- i.e., has
constructors that take types as arguments).

**Strict positivity and universes:** The strict positivity requirement for
inductive types interacts with universe levels. An inductive type I : Type_i
can have constructors with arguments in Type_j only if j <= i (for
Russell-style universes).

**Universe-polymorphic inductive types:** In Coq and Lean, inductive types can
be parameterized by universe levels:

    -- Lean:
    inductive Sum (A : Type u) (B : Type v) : Type (max u v) where
      | inl : A -> Sum A B
      | inr : B -> Sum A B

**Elimination restrictions:** The elimination rules for inductive types in Prop
are restricted (in Coq and Lean) to prevent inconsistency. Specifically, a type
in Prop can only be eliminated into Prop (not into Type), unless the inductive
type has at most one constructor with no computational content (e.g., True, And,
Eq). This restriction, called the **singleton elimination** rule, is essential
for maintaining consistency with proof irrelevance.

### 9.2 Universe Polymorphism and Module Systems

Universe polymorphism interacts delicately with module systems:

- **Coq's module system** predates universe polymorphism and does not interact
  with it seamlessly. Functors (parameterized modules) do not support universe
  polymorphism directly.
- **Agda's module system** interacts well with universe polymorphism because
  Level is a first-class type that can be a module parameter.
- **Lean 4** does not have a traditional module system; its namespace mechanism
  does not create difficulties for universe polymorphism.

A key issue is **modularity**: with typical ambiguity / implicit polymorphism
(Harper-Pollack style), checking a definition requires knowing all the
constraints from all definitions it depends on. This global nature conflicts
with modular compilation. Explicit universe polymorphism (Sozeau-Tabareau;
Lean 4) addresses this by making universe parameters local to each definition.

### 9.3 Universe Polymorphism and Elaboration

The **elaborator** is responsible for:

1. Inserting universe metavariables for implicit universe arguments
2. Collecting universe constraints during type checking
3. Solving universe constraints (checking acyclicity)
4. Minimizing universe levels (assigning smallest consistent levels)

In Lean 4, the elaborator employs non-chronological backtracking and heuristics
for handling universe level inference. Universe variables that cannot be
determined from the context may be left as parameters (making the definition
universe-polymorphic) or defaulted.

In Coq, "flexible" universe variables (those not explicitly provided by the user)
can be instantiated during unification to enable successful type checking.
Universe minimization reduces unnecessary universe constraints, and the flag
`Universe Minimization ToSet` controls whether fresh universes collapse to Set.

---

## 10. Advanced Topics

### 10.1 Palmgren's Universe Constructions

Erik Palmgren studied universes in type theory from a proof-theoretic perspective,
introducing constructions of increasing strength:

- **Internal universe hierarchies**: (U_n, T_n) indexed internally by natural
  numbers, where each U_n is a universe containing codes for all types and all
  lower universes.

- **The superuniverse**: A universe (V, S) closed under construction of
  sub-universes. The superuniverse contains codes for all types and, for every
  indexed family, an inductive subuniverse. Martin-Lof type theory with a
  superuniverse (MLS) has proof-theoretic strength strictly above the
  Feferman-Schutte ordinal Gamma_0 but well below the Bachmann-Howard ordinal.

- **Higher-order universes**: Where the lowest level is a universe, the next
  level is a universe of universe operators, and higher levels express closure
  under applying operators from the next level.

These constructions, studied also by Rathjen, Griffor, and Setzer, explore the
boundary between predicative and impredicative type theories.

### 10.2 McBride's Crude but Effective Stratification

Conor McBride proposed a lightweight approach to universe polymorphism:
every top-level definition is implicitly polymorphic in a "secret" universe
level variable. Definitions are written with concrete (lowest possible) levels,
and a uniform displacement operation shifts all levels up by a constant offset
when the definition is used at a higher level.

This approach is simple to implement and reason about, but less expressive than
full universe polymorphism (it cannot express definitions where different
arguments are at independently varying levels). It has been implemented in the
redtt proof assistant and formalized by Favonia, Angiuli, and Mullanix (2023)
using **displacement algebras** -- an algebraic framework that generalizes
McBride's scheme and shows that every universe hierarchy can be embedded in a
displacement algebra.

### 10.3 Setomega and Large Eliminations

Some universe-polymorphic types do not fit in any level of the standard
hierarchy. For example, in Agda, the type (l : Level) -> Set l cannot be
assigned any universe level Set_i, because it quantifies over all levels
including i itself. Agda introduces **Setomega** (Setω) as a special universe
above all Set_i. However, Setω is not itself universe-polymorphic: there is no
"Level" for it. Instead, there is an indexed family Setω_i with
Setω_i : Setω_{i+1}.

This breaks the property that every expression has a type (since Setω is not in
any Set_i), but in a controlled way that maintains consistency.

### 10.4 Sort Polymorphism

Recent work (integrated in the Rocq prover) introduces **sort polymorphism**,
allowing definitions to abstract not just over universe levels but over
entire sorts (e.g., abstracting over whether something lives in Prop or Type).
This further reduces code duplication in systems with multiple sort hierarchies,
though its unbounded formulation creates expressiveness limitations.

---

## 11. Consistency and Metatheory

### 11.1 Consistency of Universe Hierarchies

The consistency of dependent type theory with a universe hierarchy (CC-omega,
CIC with Type_0 : Type_1 : ...) is established by:

1. **Set-theoretic models**: Interpreting Type_i as a set V_i in a cumulative
   hierarchy of Grothendieck universes (requires inaccessible cardinals in ZFC).

2. **Proof-theoretic analysis**: The proof-theoretic ordinal of type theory
   with n universes is well-understood; with omega-many universes, it
   corresponds to certain ordinal notations studied in ordinal analysis.

3. **Normalization proofs**: Strong normalization of the reduction relation
   implies consistency (a normalizing term cannot be a proof of False).

### 11.2 Consistency of Universe Polymorphism

Universe polymorphism does not add proof-theoretic strength beyond what the
underlying universe hierarchy provides. The key insight is that a
universe-polymorphic definition is equivalent to a schema of monomorphic
definitions, one for each valid level assignment. Consistency is therefore
reduced to the consistency of the base system.

For Coq's universe polymorphism specifically:
- Sozeau and Tabareau (2014) showed that their polymorphic extension is
  conservative over the monomorphic system
- Timany and Sozeau (2017) proved consistency of pCuIC (the system with
  cumulative inductive types) relative to pCIC

### 11.3 Subject Reduction and Universe Levels

Subject reduction (the property that reduction preserves typing) must be
verified carefully in the presence of universe polymorphism:

- Chan and Weirich (2025) showed that some prior systems with bounded first-class
  universe levels fail subject reduction, and designed a system that provably
  satisfies it (mechanized in Lean)
- Gratzer, Sterling, and Birkedal (2022) conjecture but do not formally prove
  normalization for their system with explicit universe polymorphism

### 11.4 Decidability

- Type checking in CC-omega is decidable (given decidable conversion)
- Universe constraint satisfiability is decidable in polynomial time
- Level unification (finding substitutions making level expressions equal) has
  more complex decidability properties and remains partially open

---

## 12. Summary of Design Choices by Proof Assistant

| Feature | Coq/Rocq | Agda | Lean 4 |
|---------|----------|------|--------|
| Universe style | Russell | Russell | Russell |
| Cumulativity | Yes (subtyping) | No | No |
| Cumulative inductives | Yes (pCuIC) | No | No |
| Prop (impredicative) | Yes | Optional (--prop) | Yes |
| Separate Set sort | Yes (predicative) | No (Set = Set_0) | No |
| Level representation | Variables + constraints | Level type (lzero, lsuc, ⊔) | Variables + max, imax, +n |
| Polymorphism style | Opt-in (Polymorphic) | Built-in (Level param) | Built-in (universe vars) |
| Level zero | Implicit (Set) | lzero : Level | 0 |
| Above-omega | No | Setω, Setω_i | No |
| Explicit lifting | Not needed (cumulative) | Not needed (polymorphic) | ULift, PLift |

---

## 13. Key References

### Foundational Works

1. **Martin-Lof, P.** (1973). An Intuitionistic Theory of Types: Predicative
   Part. In: Rose, H.E. and Shepherdson, J.C. (eds) Logic Colloquium '73.
   Studies in Logic and the Foundations of Mathematics, vol 80. North-Holland.

2. **Girard, J.-Y.** (1972). Interpretation fonctionnelle et elimination des
   coupures de l'arithmetique d'ordre superieur. PhD thesis, Universite Paris 7.

3. **Hurkens, A.J.C.** (1995). A Simplification of Girard's Paradox. In:
   Dezani-Ciancaglini, M. and Plotkin, G. (eds) Typed Lambda Calculi and
   Applications. TLCA 1995. LNCS, vol 902. Springer.

4. **Coquand, T.** (1986). An Analysis of Girard's Paradox. In: Proceedings
   of the First Annual IEEE Symposium on Logic in Computer Science (LICS '86).
   IEEE Computer Society Press.

### Universe Inference and Polymorphism

5. **Harper, R. and Pollack, R.** (1991). Type Checking with Universes.
   Theoretical Computer Science, 89(1), 107-136.

6. **Sozeau, M. and Tabareau, N.** (2014). Universe Polymorphism in Coq. In:
   Klein, G. and Gamboa, R. (eds) Interactive Theorem Proving. ITP 2014. LNCS,
   vol 8558. Springer.

7. **Gratzer, D., Sterling, J., and Birkedal, L.** (2023). Type Theory with
   Explicit Universe Polymorphism. In: 28th International Conference on Types
   for Proofs and Programs (TYPES 2022). LIPIcs, vol 269, article 13.

8. **Hou (Favonia), K.-B., Angiuli, C., and Mullanix, R.** (2023). An
   Order-Theoretic Analysis of Universe Polymorphism. Proceedings of the ACM on
   Programming Languages, 7(POPL), 1659-1685.

### Cumulative Inductive Types

9. **Timany, A. and Sozeau, M.** (2018). Cumulative Inductive Types in Coq.
   In: Kirchner, H. (ed) FSCD 2018. LIPIcs, vol 108, article 29.

10. **Timany, A. and Sozeau, M.** (2017). Consistency of the Predicative
    Calculus of Cumulative Inductive Constructions (pCuIC). arXiv: 1710.03912.

### Universes in Type Theory

11. **Palmgren, E.** (1998). On Universes in Type Theory. In: Sambin, G. and
    Smith, J.M. (eds) Twenty-Five Years of Constructive Type Theory. Oxford
    Logic Guides, vol 36. Oxford University Press.

12. **Luo, Z.** (2012). Notes on Universes in Type Theory. Lecture notes,
    Royal Holloway, University of London.

13. **Setzer, A.** Universes in Type Theory Part II -- Autonomous Mahlo.
    Technical report, University of Wales Swansea.

### First-Class and Bounded Universe Levels

14. **Chan, J. and Weirich, S.** (2025). Bounded First-Class Universe Levels in
    Dependent Type Theory. arXiv: 2502.20485. Submitted to FSCD 2025.

### Crude but Effective Stratification

15. **McBride, C.** Crude but Effective Stratification. Unpublished note.
    University of Strathclyde.

### Proof Assistant References

16. **Lean 4 Reference Manual.** Section 4.3: Universes.
    https://lean-lang.org/doc/reference/latest/The-Type-System/Universes/

17. **Agda Documentation.** Universe Levels.
    https://agda.readthedocs.io/en/latest/language/universe-levels.html

18. **Coq/Rocq Reference Manual.** Polymorphic Universes.
    https://rocq-prover.org/doc/v8.19/refman/addendum/universe-polymorphism.html

19. **Coq/Rocq Reference Manual.** Calculus of Inductive Constructions.
    https://rocq-prover.org/doc/v8.9/refman/language/cic.html

### Elaboration and Unification

20. **Ziliani, B. and Sozeau, M.** (2015). A Unification Algorithm for Coq
    Featuring Universe Polymorphism and Overloading. In: ICFP 2015.

21. **de Moura, L. and Avigad, J.** Elaboration in Dependent Type Theory.
    Carnegie Mellon University / Microsoft Research.

---

## Cross-References

- **Doc 05 (Lambda Cube):** The lambda cube uses only two sorts with a single axiom `* : box`, and the Pure Type Systems generalization provides the framework for understanding how universe hierarchies extend this to arbitrarily many sorts.

- **Doc 06 (Calculus of Constructions):** The Calculus of Constructions introduced the impredicative universe Prop, and its extension to CIC added a predicative hierarchy of Type universes to avoid Girard's paradox.

- **Doc 07 (Calculus of Inductive Constructions):** CIC as implemented in Coq/Rocq and Lean features a stratified universe hierarchy with cumulative or non-cumulative universes, and universe polymorphism is essential for practical definitions that must work across multiple universe levels.
