# Linear and Substructural Type Systems

## Overview

Linear and substructural type systems are type disciplines that control how values may be
used in a program by restricting or tracking the *structural rules* of the underlying logic.
Where conventional type systems treat values as freely copyable and discardable truths,
substructural systems treat them as *resources* that must be consumed according to
specified protocols. This perspective originates in Girard's linear logic (1987) and has
since ramified into a rich family of type systems with profound implications for resource
management, concurrency, memory safety, and the foundations of computation.

The Curry-Howard correspondence extends naturally to this setting: proofs in linear logic
correspond to programs in linear lambda calculus, and the resource-sensitivity of linear
logic maps onto precise control over how program values are created, used, and destroyed.

---

## 1. Historical Context: Girard's Linear Logic (1987)

### 1.1 Origins

Linear logic was introduced by Jean-Yves Girard in his landmark 1987 paper "Linear Logic"
(Theoretical Computer Science, 50: 1--102). The discovery arose from a semantic analysis of
the models of System F (the polymorphic lambda-calculus). Girard observed that the
denotational semantics of System F naturally decomposed the familiar logical connectives
into finer-grained operations, revealing a hidden resource structure beneath classical and
intuitionistic logic.

### 1.2 The Resource Interpretation

The central insight of linear logic is that propositions can be understood as *resources*
rather than eternal truths. In classical logic, if you know A, you know A forever -- you can
use it zero times, once, or a million times. In linear logic, a hypothesis A is a resource
that must be used *exactly once*. This interpretation has immediate computational relevance:
it captures notions of consumption, single-use, and state change at the logical level.

### 1.3 Connectives

Linear logic splits the classical connectives into *multiplicative* and *additive* variants:

**Multiplicative connectives** (simultaneous resource combination):
- **Tensor** (A ⊗ B): multiplicative conjunction -- "I have both A and B simultaneously"
- **Par** (A ⅋ B): multiplicative disjunction -- dual of tensor
- **Linear implication** (A ⊸ B): "consuming one A produces one B"
- **1**: multiplicative unit (of tensor)
- **⊥** (bottom): multiplicative unit (of par)

**Additive connectives** (alternative resource choice):
- **With** (A & B): additive conjunction -- "I can provide either A or B, your choice"
- **Plus** (A ⊕ B): additive disjunction -- "I choose to provide A or B"
- **⊤** (top): additive unit (of with)
- **0**: additive unit (of plus)

**Exponential modalities** (controlled structural rules):
- **Of-course** (!A): "I have an unlimited supply of A"
- **Why-not** (?A): dual of of-course

### 1.4 The Curry-Howard Correspondence for Linear Logic

The Curry-Howard correspondence extends to linear logic:
- Proofs of A ⊸ B correspond to functions that consume their argument exactly once
- Proofs of A ⊗ B correspond to pairs where both components must be used
- Proofs of A & B correspond to pairs where exactly one component is chosen
- Proofs of !A correspond to values that may be freely copied and discarded
- Cut elimination corresponds to beta-reduction

This gives rise to the *linear lambda calculus*, a computational interpretation of
intuitionistic linear logic.

---

## 2. Structural Rules and Their Removal

### 2.1 The Three Structural Rules

In sequent calculus, three *structural rules* govern the manipulation of hypotheses
independently of their logical content:

**Exchange** (reordering):
```
  Γ, A, B, Δ ⊢ C
  ─────────────────
  Γ, B, A, Δ ⊢ C
```
Hypotheses may be used in any order.

**Weakening** (discarding):
```
  Γ ⊢ B
  ─────────
  Γ, A ⊢ B
```
Unused hypotheses may be added (equivalently, hypotheses may be discarded without use).

**Contraction** (duplication):
```
  Γ, A, A ⊢ B
  ─────────────
  Γ, A ⊢ B
```
A hypothesis may be used more than once (duplicated).

### 2.2 Removal in Linear Logic

In linear logic, **weakening and contraction are not freely available**. They apply only
to formulas marked with the exponential modalities ! and ?:

- **Weakening for !**: Γ, !A ⊢ B implies Γ ⊢ B
- **Contraction for !**: Γ, !A, !A ⊢ B implies Γ, !A ⊢ B
- **Exchange** remains unrestricted (in standard linear logic)

This means unmarked formulas must be used exactly once: they cannot be silently discarded
(no weakening) or duplicated (no contraction).

---

## 3. The Substructural Hierarchy

Removing different combinations of structural rules yields a hierarchy of substructural
logics and their corresponding type systems:

### 3.1 Classification

| Type System  | Exchange | Weakening | Contraction | Usage Constraint     |
|-------------|----------|-----------|-------------|---------------------|
| **Ordered**     | No       | No        | No          | Exactly once, in order |
| **Linear**      | Yes      | No        | No          | Exactly once         |
| **Affine**      | Yes      | Yes       | No          | At most once         |
| **Relevant**    | Yes      | No        | Yes         | At least once        |
| **Unrestricted**| Yes      | Yes       | Yes         | Any number of times  |

### 3.2 Ordered Types

The most restrictive system: no structural rules at all. Variables must be used exactly
once and in the order they are introduced. This corresponds to non-commutative linear
logic (Lambek calculus). The categorical semantics uses *non-symmetric monoidal categories*.
Ordered types have applications in linguistics (Lambek's syntactic calculus) and in
stack-based computation.

### 3.3 Linear Types

Allow exchange but prohibit weakening and contraction. Every variable must be used
*exactly once*. This is the type-theoretic manifestation of Girard's linear logic.
The key property is *resource conservation*: what goes in must come out.

### 3.4 Affine Types

Allow exchange and weakening, but not contraction. Every variable may be used *at most
once* -- it can be silently discarded but not duplicated. This is the system closest to
Rust's ownership model. Affine types correspond to *affine logic*.

### 3.5 Relevant Types

Allow exchange and contraction, but not weakening. Every variable must be used *at least
once* -- it can be duplicated but not discarded. This ensures nothing is wasted. Relevant
types correspond to *relevance logic*.

---

## 4. Linear Lambda Calculus

### 4.1 Syntax

The linear lambda calculus extends the simply typed lambda calculus with linear types.
Types are built from the connectives of intuitionistic linear logic:

```
Types:    A, B ::= a                    -- base types
               |  A ⊸ B                -- linear function
               |  A ⊗ B                -- tensor (multiplicative pair)
               |  1                     -- tensor unit
               |  A & B                -- with (additive pair)
               |  ⊤                    -- top (additive unit)
               |  A ⊕ B                -- plus (additive sum)
               |  0                     -- zero (additive unit)
               |  !A                   -- of-course (exponential)

Terms:    M, N ::= x                    -- variable
               |  λx. M                -- linear abstraction
               |  M N                   -- application
               |  (M, N)               -- tensor pair
               |  let (x, y) = M in N  -- tensor elimination
               |  ⟨⟩                   -- unit
               |  let ⟨⟩ = M in N      -- unit elimination
               |  ⟨M, N⟩              -- additive pair
               |  π₁ M | π₂ M         -- projections
               |  inl M | inr M        -- injection
               |  case M of inl x ⇒ N₁ | inr y ⇒ N₂  -- case
               |  !M                   -- promotion
               |  let !x = M in N      -- dereliction
```

### 4.2 Typing Rules

The typing judgment has the form `Γ; Δ ⊢ M : A` where:
- Γ is the *unrestricted* (intuitionistic) context -- variables usable any number of times
- Δ is the *linear* context -- variables that must be used exactly once

Key rules (in natural deduction style):

**Linear variable:**
```
  ──────────────────
  Γ; x : A ⊢ x : A
```

**Linear abstraction:**
```
  Γ; Δ, x : A ⊢ M : B
  ─────────────────────────
  Γ; Δ ⊢ λx. M : A ⊸ B
```

**Application (context split):**
```
  Γ; Δ₁ ⊢ M : A ⊸ B    Γ; Δ₂ ⊢ N : A
  ──────────────────────────────────────────
  Γ; Δ₁, Δ₂ ⊢ M N : B
```

**Tensor introduction (context split):**
```
  Γ; Δ₁ ⊢ M : A    Γ; Δ₂ ⊢ N : B
  ──────────────────────────────────────
  Γ; Δ₁, Δ₂ ⊢ (M, N) : A ⊗ B
```

**Tensor elimination:**
```
  Γ; Δ₁ ⊢ M : A ⊗ B    Γ; Δ₂, x : A, y : B ⊢ N : C
  ──────────────────────────────────────────────────────────
  Γ; Δ₁, Δ₂ ⊢ let (x, y) = M in N : C
```

**Promotion (of-course introduction):**
```
  Γ; · ⊢ M : A
  ─────────────────
  Γ; · ⊢ !M : !A
```
(No linear variables may be used -- the linear context must be empty.)

**Dereliction (of-course elimination):**
```
  Γ; Δ₁ ⊢ M : !A    Γ, x : A; Δ₂ ⊢ N : B
  ─────────────────────────────────────────────
  Γ; Δ₁, Δ₂ ⊢ let !x = M in N : B
```
(The bound variable x moves to the unrestricted context.)

### 4.3 Reduction Rules

The key beta-reductions preserve the linear resource discipline:

```
(λx. M) N                      ⟶  M[N/x]
let (x, y) = (M, N) in P       ⟶  P[M/x, N/y]
let ⟨⟩ = ⟨⟩ in M               ⟶  M
πᵢ ⟨M₁, M₂⟩                   ⟶  Mᵢ
case (inl M) of inl x ⇒ N₁ | inr y ⇒ N₂  ⟶  N₁[M/x]
let !x = !M in N               ⟶  N[M/x]
```

### 4.4 Key Property

The crucial property is that **well-typed linear terms use every linear variable exactly
once**. This is not merely a syntactic constraint but a deep semantic invariant: it means
that every resource allocated is eventually consumed, and no resource is consumed twice.

---

## 5. The Exponential Modality (!) and Its Role

### 5.1 Recovering Classical Behavior

The exponential modality !A ("of course A") is the mechanism by which linear logic
recovers the full power of intuitionistic logic. A value of type !A is an unlimited
resource: it may be freely copied and discarded. Without !, linear logic would be too
restrictive for general-purpose programming.

The key equivalence is:
```
A → B  ≡  !A ⊸ B
```

That is, an ordinary (non-linear) function from A to B is the same as a linear function
that takes an unlimited supply of A and produces one B. This shows that the standard
function arrow is *derived* from the linear arrow and the exponential.

### 5.2 Rules for !

The exponential obeys four rules:

**Promotion** (introduction): If A can be proved using only unlimited resources,
then !A can be proved.

**Dereliction** (use once): From !A, extract one copy of A.

**Contraction** (duplicate): From !A, produce two copies of !A.

**Weakening** (discard): Discard !A without using it.

### 5.3 The Decomposition of !

Benton (1994) showed that the ! modality can be decomposed into an adjunction between
two worlds:
- F : C → L (embedding non-linear into linear)
- G : L → C (extracting non-linear from linear)
- F ⊣ G (F is left adjoint to G)
- !A = F(G(A))

This decomposition is the foundation of the Linear/Non-Linear (LNL) framework.

---

## 6. Intuitionistic Linear Logic and Its Type-Theoretic Interpretation

### 6.1 ILL vs. Classical Linear Logic

Intuitionistic linear logic (ILL) restricts sequents to have exactly one formula on the
right of the turnstile: Γ ⊢ A (single conclusion). This corresponds to the type-theoretic
requirement that a term has exactly one type. Classical linear logic allows multiple
conclusions (Γ ⊢ Δ) and has the involutive negation A⊥⊥ = A.

For type theory, ILL is the natural starting point because:
- Single-conclusion sequents correspond to well-typed terms
- The multiplicative fragment gives tensor products and linear functions
- The additive fragment gives sums and products with sharing
- The exponential ! gives controlled access to unrestricted computation

### 6.2 Connectives as Type Constructors

| ILL Connective | Type Constructor | Programming Interpretation |
|---------------|-----------------|---------------------------|
| A ⊸ B         | Linear function  | Consumes A, produces B |
| A ⊗ B         | Tensor product   | Pair where both used simultaneously |
| 1             | Unit             | No resources |
| A & B         | With (product)   | Choice by consumer |
| A ⊕ B         | Plus (sum)       | Choice by producer |
| !A            | Exponential      | Unlimited supply of A |

---

## 7. Linear/Non-Linear Adjoint Models (Benton 1994)

### 7.1 The LNL Framework

Nick Benton's 1994 paper "A Mixed Linear and Non-Linear Logic: Proofs, Terms and Models"
established the definitive categorical framework for understanding the relationship between
linear and intuitionistic logic.

The key insight is that the ! modality is *not* a primitive operation but arises from an
*adjunction* between two worlds:

- **L**: A symmetric monoidal closed category (the "linear" world)
- **C**: A cartesian closed category (the "non-linear" world)
- **F : C → L**: A symmetric monoidal functor (embedding non-linear into linear)
- **G : L → C**: A functor (projecting linear into non-linear)
- **F ⊣ G**: F is left adjoint to G

### 7.2 Reconstruction of !

Given the adjunction F ⊣ G:
- !A = F(G(A)): the comonad on L arising from the adjunction
- The counit ε : F(G(A)) → A gives dereliction
- The comultiplication δ : F(G(A)) → F(G(F(G(A)))) gives contraction

Dually, the composition G ∘ F gives a monad on C.

### 7.3 Term Calculus

Benton's system has two judgment forms:
- **Linear**: Γ; Δ ⊢_L M : A (in the linear world)
- **Non-linear**: Γ ⊢_C M : A (in the non-linear world)

Operations cross between worlds:
- **F-introduction**: takes a non-linear value into the linear world
- **G-elimination**: extracts a non-linear value from a linear one

### 7.4 Significance

The LNL framework shows that:
1. Linear and non-linear logic are *equally fundamental* -- neither is derived from the other
2. The ! modality is a *composite* arising from an adjunction
3. The connection generalizes to many settings (dependent types, graded types, effects)

---

## 8. DILL: Dual Intuitionistic Linear Logic (Barber-Plotkin)

### 8.1 Motivation

Andrew Barber (supervised by Gordon Plotkin) developed DILL as an alternative natural
deduction formulation of intuitionistic linear logic that makes the role of exponentials
more transparent.

### 8.2 Judgment Form

DILL uses a two-zone judgment:
```
Γ; Δ ⊢ M : A
```
where:
- Γ: intuitionistic (non-linear) context -- variables may be used any number of times
- Δ: linear context -- variables must be used exactly once

### 8.3 Key Rules

**Exponential Introduction:**
```
  Γ; · ⊢ M : A
  ─────────────────
  Γ; · ⊢ !M : !A
```
To introduce !A, derive A using *no linear assumptions* (the linear context must be empty).

**Exponential Elimination:**
```
  Γ; Δ₁ ⊢ M : !A    Γ, x : A; Δ₂ ⊢ N : B
  ─────────────────────────────────────────────
  Γ; Δ₁, Δ₂ ⊢ let !x = M in N : B
```
The variable x enters the intuitionistic context, making it freely usable.

### 8.4 Relationship to LNL

DILL can be embedded into Benton's ILT (Intuitionistic and Linear Type Theory), which
has no modality but two function spaces. The semantics of both systems are given by
monoidal adjunctions between symmetric monoidal closed categories and cartesian closed
categories, establishing their equivalence.

---

## 9. Quantitative Type Theory (QTT)

### 9.1 McBride's "I Got Plenty o' Nuttin'" (2016)

Conor McBride proposed annotating each variable binding in a dependent type theory with
*usage information* drawn from an algebraic structure. The key insight is that the binary
distinction between "linear" and "unrestricted" is unnecessarily coarse: a *semiring* of
usage annotations provides a unified framework that subsumes linearity, irrelevance, and
unrestricted use.

The three distinguished elements are:
- **0**: the variable is *erased* -- it plays no role at runtime (irrelevance)
- **1**: the variable is used *exactly once* (linearity)
- **ω** (omega): the variable may be used *without restriction*

### 9.2 Atkey's Formal Development (2018)

Robert Atkey formalized QTT in "Syntax and Semantics of Quantitative Type Theory"
(LICS 2018), providing:

**Semiring structure:** A semiring (Q, +, ·, 0, 1) where:
- (Q, +, 0) is a commutative monoid (combining usages)
- (Q, ·, 1) is a monoid (scaling usages)
- · distributes over +
- 0 · q = 0 = q · 0

**Typing judgments:** The form is:
```
Γ ⊢_σ M : A
```
where σ is a *usage vector* assigning a semiring element to each variable in Γ.

**Key typing rules:**

Variable rule:
```
  ──────────────────────────
  x :_1 A ⊢ x : A
```
(Variable x is used exactly once.)

Application rule:
```
  Γ ⊢_σ M : (x :_π A) → B    Γ ⊢_ρ N : A
  ──────────────────────────────────────────────
  Γ ⊢_(σ + π·ρ) M N : B[N/x]
```
(Usage of the argument is scaled by the multiplicity π of the function's parameter.)

**Realizability semantics:** Atkey gives a semantics using a variant of Linear Combinatory
Algebras, refining the usual realizability semantics of type theory to accurately track
resource behavior.

**Categorical semantics:** The paper introduces *Quantitative Categories with Families*,
extending the standard Categories with Families framework for modeling resource-sensitive
type theories.

### 9.3 Key Properties of QTT

1. **Subsumes linear types**: setting Q = {0, 1, ω} recovers the standard linear/non-linear distinction
2. **Subsumes irrelevance**: 0-annotated variables are guaranteed erased at runtime
3. **Dependent types compatible**: unlike many linear type theories, QTT supports full dependent types
4. **Parametric in the semiring**: different semirings yield different resource analyses

### 9.4 Idris 2: QTT in Practice

Edwin Brady's Idris 2 (ECOOP 2021) is the first full implementation of QTT in a
programming language. Idris 2 uses three multiplicities:

- **0** (erased): the variable exists at the type level but is guaranteed absent at runtime
- **1** (linear): the variable must be used exactly once at runtime
- **Unrestricted**: standard behavior, no usage restriction

Syntax:
```idris
-- Erased argument: n is not available at runtime
ignoreN : (0 n : Nat) -> Vect n a -> Nat

-- Linear argument: d must be used exactly once
openDoor : (1 d : Door Closed) -> Door Open
closeDoor : (1 d : Door Open) -> Door Closed
```

Key features:
- Implicit arguments default to erased (0)
- Linear resource protocols enforce state transitions at the type level
- A function with a 0-multiplicity argument is *parametric* in that argument
- Pattern matching on types is possible when the type argument has non-zero multiplicity
- First dependently typed language fully self-hosted

---

## 10. Graded Modal Types and Coeffect Systems

### 10.1 From Binary to Graded

The transition from linear/non-linear to QTT represents a shift from a *binary*
distinction to a *graded* one. Graded modal types generalize this further: instead of
a single semiring tracking usage counts, different algebraic structures can track
different resource properties.

### 10.2 Coeffect Systems

Coeffect systems (Petricek, Orchard, Mycroft, ICFP 2014) are the dual of effect systems:

- **Effect systems** track how a program *changes* its environment (side effects)
- **Coeffect systems** track how a program *depends on* its context (resource requirements)

Coeffects annotate variables and function types with elements of a semiring, capturing:
- Liveness analysis (is a variable dead or alive?)
- Implicit parameter tracking
- Caching requirements for dataflow programs
- Security levels for information flow control

### 10.3 Graded Modalities

A graded modality is an indexed family of modalities {□_r}_{r ∈ R} where R carries
algebraic structure (typically a semiring or ordered semiring). The grading reflects
the proof rules:

- □_0 A: the resource is not needed
- □_1 A: the resource is needed exactly once
- □_(r+s) A ⊸ □_r A ⊗ □_s A: splitting
- □_(r·s) A → □_r (□_s A): nesting

Semantically, graded necessity modalities are modeled by *graded comonads*, while graded
possibility modalities are modeled by *graded monads*.

### 10.4 The Granule Language

Granule (Orchard, Liepelt, Eades, ICFP 2019) is a research language implementing graded
modal types:

- Built on a linear type system foundation
- Two flavors of graded modalities:
  - Graded necessity/comonads for coeffects (properties of inputs)
  - Graded possibility/monads for effects (properties of outputs)
- Captures intensional properties: *how* a program computes, not just *what*
- Examples: tracking non-linearity, privacy levels, stateful protocols, session types

### 10.5 Combined Effects and Coeffects

Gaboardi, Katsumata, Orchard, Breuvart, and Uustalu (ICFP 2016) showed how to combine
effect-graded monads and coeffect-graded comonads via *graded distributive laws*, enabling
simultaneous tracking of both how a program uses its context and how it changes its
environment.

---

## 11. Session Types: Communication Protocols as Types

### 11.1 Origins

Session types were introduced by Kohei Honda in "Types for Dyadic Interaction" (CONCUR
1993). They provide static guarantees that concurrent programs respect structured
communication protocols.

### 11.2 Core Idea

In session-based concurrency:
- Processes communicate through *session channels* connecting exactly two participants
- Communication is disciplined by *session protocols*
- Actions occur in dual pairs: when one partner sends, the other receives

### 11.3 Connection to Linear Logic

The deep connection between session types and linear logic was established by:

**Caires and Pfenning (2010)**: "Session Types as Intuitionistic Linear Propositions"
- Linear logic propositions correspond to session types
- The programming language is a session-typed pi-calculus
- The type structure consists of ILL connectives

**Wadler (2012)**: "Propositions as Sessions" (ICFP 2012)
- Uses classical linear logic (single-sided sequents)
- Presents CP calculus where propositions are session types
- Cut reduction = communication
- Deadlock freedom follows from the linear logic correspondence

### 11.4 Correspondence Table

| Linear Logic | Session Type | Communication Action |
|-------------|-------------|---------------------|
| A ⊗ B       | Send        | Send A, then continue as B |
| A ⅋ B       | Receive     | Receive A, then continue as B |
| A ⊕ B       | Select      | Choose to continue as A or B |
| A & B       | Offer       | Offer choice between A and B |
| !A          | Server      | Replicated session (serve many clients) |
| 1           | Close       | End of session |

### 11.5 Multiparty Session Types

Honda, Yoshida, and Carbone extended binary session types to *multiparty* settings
(POPL 2008), where protocols involve more than two participants. The theory uses
*global types* describing the overall protocol and *local types* describing each
participant's view, with a projection operation connecting them.

---

## 12. Practical Applications

### 12.1 Rust's Ownership and Borrowing System

Rust implements an *affine* type system (not truly linear) at the language level:

**Ownership rules:**
- Each value has exactly one owner
- When the owner goes out of scope, the value is dropped
- Values can be *moved* (transferring ownership) -- this is the affine consumption

**Borrowing:**
- References (&T for shared, &mut T for exclusive) temporarily suspend affine rules
- Borrowing is region-bounded: the borrow checker ensures references do not outlive
  their referents
- Shared borrows allow multiple readers; mutable borrows ensure exclusive access

**Key distinction from linear types:**
- Rust's types are *affine*, not linear: values can be silently dropped without use
- The `Drop` trait provides destructor behavior, but drop is implicit
- `Copy` types are unrestricted (can be freely duplicated)
- There is active interest in "must-move" types that would enforce true linearity

**Formal treatment:** Weiss et al., "Oxide: The Essence of Rust" (2019), provides a
formal calculus capturing the essence of Rust's ownership and borrowing.

### 12.2 Linear Haskell

Bernardy, Boespflug, Newton, Peyton Jones, and Spiwack published "Linear Haskell:
practical linearity in a higher-order polymorphic language" (POPL 2018), introducing
the `-XLinearTypes` GHC extension.

**Design principles:**
1. *Backwards compatibility*: existing Haskell code remains valid
2. *Code reuse*: the same library works for linear and non-linear clients
3. *Linearity on arrows*: linearity annotates the function arrow, not types themselves

**Syntax:**
```haskell
-- Linear function: argument consumed exactly once
f :: a %1 -> b

-- Unrestricted function (standard)
g :: a -> b        -- sugar for a %Many -> b

-- Multiplicity-polymorphic function
h :: a %m -> b     -- works for both linear and unrestricted use
```

**Multiplicity kind:**
```haskell
data Multiplicity = One | Many
```

**Key property:** A function `f :: a %1 -> b` guarantees that if its result is consumed
exactly once, then its argument is consumed exactly once. This is a *relative* linearity
guarantee, not an absolute one.

**Applications demonstrated:**
- Mutable arrays with pure interfaces (safe in-place update)
- Protocol enforcement in I/O (e.g., file handle safety)

### 12.3 Clean's Uniqueness Types

Clean (developed at Radboud University since 1987) uses *uniqueness types* for safe
mutation in a pure functional setting:

- A *unique* type guarantees at most one reference to a value exists
- The compiler can optimize unique values with destructive in-place updates
- Uniqueness types provide the mechanism for I/O and mutable state
- Alternative to Haskell's monadic I/O approach
- Closely related to linear types but with a focus on implementation optimization

---

## 13. Call-by-Push-Value (Levy 2003)

### 13.1 Overview

Paul Blain Levy's call-by-push-value (CBPV) is a computational framework that
decomposes both call-by-value (CBV) and call-by-name (CBN) into finer-grained primitives.
While not itself a substructural system, CBPV illuminates the structure of computation
in ways deeply connected to linear logic.

### 13.2 The Key Distinction: Values vs. Computations

CBPV distinguishes two kinds of entity:

- **Value types** (A): classify *values* -- data that simply exists
  - Products, sums, base types, thunked computations (U B)
- **Computation types** (B): classify *computations* -- processes that run
  - Functions (A → B), returns (F A), products of computations

### 13.3 Connectives

Two key type constructors bridge the gap:

- **U B** ("thunk"): a value type wrapping a suspended computation of type B
  - Introduction: `thunk M` suspends computation M
  - Elimination: `force V` runs a thunked value V
- **F A** ("free" or "return"): a computation type that produces a value of type A
  - Introduction: `return V` produces value V
  - Elimination: `M to x. N` sequences computations

### 13.4 Relationship to Linear Logic

CBPV connects to LNL logic: when the linear context is restricted to at most one
variable, the judgmental structure of LNL aligns with CBPV's value/computation
distinction. The U and F type constructors correspond to the G and F functors of
Benton's adjunction.

### 13.5 Categorical Semantics

A CBPV model is an adjunction F ⊣ U between:
- A category of value types (with products, sums)
- A category of computation types (with function spaces)

This adjunction-based semantics directly parallels the LNL adjunction, with:
- The left adjoint F : Values → Computations
- The right adjoint U : Computations → Values
- The monad T = U ∘ F on values (corresponding to computational effects)
- The comonad ! = F ∘ U on computations

---

## 14. Categorical Semantics

### 14.1 Star-Autonomous Categories

A *-autonomous category is the categorical model of multiplicative classical linear logic
(MLL). It consists of:

- A symmetric monoidal closed category (C, ⊗, I, ⊸)
- A *dualizing object* ⊥ ∈ C such that the canonical map A → (A ⊸ ⊥) ⊸ ⊥ is an
  isomorphism for all A

**Key features:**
- Two monoidal structures: ⊗ (tensor) and ⅋ (par), related by de Morgan duality:
  A ⅋ B = (A* ⊗ B*)*
- Involutive duality: A** ≅ A
- Internal logic is exactly MLL

**Examples:**
- Finite-dimensional vector spaces (dualizing object = the base field k)
- Coherence spaces (Girard's original model)
- Phase spaces
- Game-theoretic models (Hyland-Ong games)
- The Chu construction

### 14.2 Compact Closed Categories

A compact closed category is a special *-autonomous category where the monoidal unit I
serves as the dualizing object, so ⊗ and ⅋ coincide. Examples include:
- Finite-dimensional vector spaces (when viewed as compact closed)
- Categories of relations
- Cobordism categories (in topological quantum field theory)

Compact closed categories are *too degenerate* for most linear logic applications because
they collapse the distinction between ⊗ and ⅋.

### 14.3 Symmetric Monoidal Closed Categories (SMCC)

The categorical model of the multiplicative fragment of intuitionistic linear logic is a
symmetric monoidal closed category: a symmetric monoidal category (C, ⊗, I) equipped with
internal homs [A, B] satisfying the adjunction:

```
C(A ⊗ B, C) ≅ C(A, [B, C])
```

This is the "linear" analog of a cartesian closed category.

### 14.4 Multicategories and Polycategories

More refined categorical semantics use:

- **Multicategories**: categories where morphisms can have multiple inputs but one output.
  These model intuitionistic sequents Γ ⊢ A naturally. A multicategory being *cartesian*
  corresponds to having contraction and weakening.

- **Polycategories**: categories where morphisms can have multiple inputs AND multiple
  outputs. These model classical sequents Γ ⊢ Δ. They provide the most natural framework
  for classical linear logic.

- **LNL polycategories** (Shulman, 2021): combine a symmetric polycategory of linear
  objects with a cartesian multicategory of non-linear objects, providing a unified
  categorical semantics for linear logic with exponentials.

### 14.5 Models of the Exponential

Categorically, !A is modeled by a comonad on the SMCC satisfying additional structure:
- ! is a symmetric monoidal comonad
- The coKleisli category of ! is cartesian closed
- Equivalently (Benton): ! arises from a symmetric monoidal adjunction between an SMCC
  and a CCC

---

## 15. Relationship to the Lambda Cube and Dependent Types

### 15.1 The Challenge

Combining linear types with dependent types is notoriously difficult. The fundamental
tension is:

- In dependent types, types can depend on terms: Π(x : A). B(x)
- In linear types, terms must be used exactly once
- But if B depends on x, then x appears in the *type* B(x) -- does this "use" count?

### 15.2 Solutions

**QTT (McBride/Atkey):** The solution is to distinguish *type-level* uses (which are
erased and don't count toward the usage budget) from *term-level* uses (which do count).
The 0 annotation marks type-level-only variables:

```
Π(0 x : A). B(x)   -- x appears in B but is erased at runtime
Π(1 x : A). B(x)   -- x used once at runtime and may appear in B
```

**Cervesato and Pfenning (2002):** "A Linear Logical Framework" provides dependent types
in a linear setting but with significant restrictions.

**Krishnaswami et al. (2015):** "Integrating Linear and Dependent Types" uses an
adjunction-based approach where linear and dependent parts coexist but interact through
controlled interfaces.

### 15.3 The Landscape

The lambda cube organizes type systems along three axes:
1. Terms depending on types (polymorphism)
2. Types depending on types (type operators)
3. Types depending on terms (dependent types)

Linear types add an orthogonal dimension: *resource sensitivity*. QTT shows that this
dimension can be integrated with all three axes of the lambda cube, yielding a dependent,
polymorphic, linear type theory.

---

## 16. Key References

### Foundational Works

1. **Girard, J.-Y.** (1987). "Linear Logic." *Theoretical Computer Science*, 50: 1--102.
   The seminal paper introducing linear logic.

2. **Wadler, P.** (1990). "Linear Types Can Change the World!" *IFIP Working Conference
   on Programming Concepts and Methods*.
   First major proposal for linear types in functional programming.

3. **Abramsky, S.** (1993). "Computational Interpretations of Linear Logic." *Theoretical
   Computer Science*, 111(1--2): 3--57.
   Comprehensive treatment of linear logic's computational interpretations.

### Type-Theoretic Foundations

4. **Benton, N.** (1994). "A Mixed Linear and Non-Linear Logic: Proofs, Terms and Models."
   *CSL 1994*, Springer LNCS.
   The LNL adjoint model of intuitionistic linear logic.

5. **Barber, A. and Plotkin, G.** (1996). "Dual Intuitionistic Linear Logic."
   *University of Edinburgh Technical Report ECS-LFCS-96-347*.
   DILL: the two-zone natural deduction formulation.

6. **Barber, A.** (1997). "Linear Type Theories, Semantics and Action Calculi."
   *PhD Thesis, University of Edinburgh*.

7. **Walker, D.** (2005). "Substructural Type Systems." In *Advanced Topics in Types
   and Programming Languages*, B. Pierce (ed.), MIT Press.
   Comprehensive survey chapter on the substructural hierarchy.

### Quantitative and Graded Types

8. **McBride, C.** (2016). "I Got Plenty o' Nuttin'." In *A List of Successes That Can
   Change the World -- Essays Dedicated to Philip Wadler*. Springer LNCS.
   Proposes usage-annotated dependent types.

9. **Atkey, R.** (2018). "Syntax and Semantics of Quantitative Type Theory." *LICS 2018*,
   pages 56--65. ACM.
   Formal development of QTT with semiring annotations.

10. **Petricek, T., Orchard, D., and Mycroft, A.** (2014). "Coeffects: A Calculus of
    Context-Dependent Computation." *ICFP 2014*. ACM.
    Introduces coeffect systems as dual to effect systems.

11. **Orchard, D., Liepelt, V.B., and Eades III, H.** (2019). "Quantitative Program
    Reasoning with Graded Modal Types." *ICFP 2019*. ACM.
    Graded modal types in the Granule language.

12. **Gaboardi, M., Katsumata, S., Orchard, D., Breuvart, F., and Uustalu, T.** (2016).
    "Combining Effects and Coeffects via Grading." *ICFP 2016*. ACM.

### Session Types

13. **Honda, K.** (1993). "Types for Dyadic Interaction." *CONCUR 1993*. Springer LNCS.
    Introduction of session types.

14. **Honda, K., Yoshida, N., and Carbone, M.** (2008). "Multiparty Asynchronous Session
    Types." *POPL 2008*. ACM.

15. **Caires, L. and Pfenning, F.** (2010). "Session Types as Intuitionistic Linear
    Propositions." *CONCUR 2010*. Springer LNCS.

16. **Wadler, P.** (2012). "Propositions as Sessions." *ICFP 2012*. ACM.
    Classical linear logic propositions as session types.

### Practical Implementations

17. **Bernardy, J.-P., Boespflug, M., Newton, R., Peyton Jones, S., and Spiwack, A.**
    (2018). "Linear Haskell: practical linearity in a higher-order polymorphic language."
    *POPL 2018*. ACM.

18. **Brady, E.** (2021). "Idris 2: Quantitative Type Theory in Practice." *ECOOP 2021*.
    Schloss Dagstuhl LIPIcs.

19. **Weiss, A. et al.** (2019). "Oxide: The Essence of Rust." arXiv:1903.00982.

### Call-by-Push-Value

20. **Levy, P.B.** (2003). *Call-by-Push-Value: A Functional/Imperative Synthesis*.
    Springer.

21. **Levy, P.B.** (2006). "Call-by-push-value: Decomposing call-by-value and
    call-by-name." *Higher-Order and Symbolic Computation*, 19(4): 377--414.

### Categorical Semantics

22. **Seely, R.A.G.** (1989). "Linear logic, *-autonomous categories and cofree
    coalgebras." *Contemporary Mathematics*, 92: 371--382.
    First categorical semantics for linear logic.

23. **Barr, M.** (1991). "*-Autonomous Categories and Linear Logic." *Mathematical
    Structures in Computer Science*, 1(2): 159--178.

24. **Mellies, P.-A.** (2009). "Categorical Semantics of Linear Logic." In *Interactive
    Models of Computation and Program Behaviour*, Panoramas et Syntheses 27.

25. **Shulman, M.** (2021). "LNL Polycategories and Doctrines of Linear Logic."
    arXiv:2106.15042.

### Other Important Works

26. **Girard, J.-Y.** (1995). "Linear Logic: Its Syntax and Semantics." In *Advances in
    Linear Logic*, Cambridge University Press.

27. **Cervesato, I. and Pfenning, F.** (2002). "A Linear Logical Framework." *Information
    and Computation*, 179(1): 19--75.

28. **Krishnaswami, N., Pradic, P., and Benton, N.** (2015). "Integrating Linear and
    Dependent Types." *POPL 2015*. ACM.

29. **Pfenning, F.** (2025). "Fundamentals of Substructural Type Systems." POPL 2025
    Tutorial.

30. **Abel, A., Danielsson, N.A., and Eriksson, A.S.** (2023). "A Graded Modal Dependent
    Type Theory with a Universe." *ICFP 2023*.

---

## Cross-References

- **Doc 02 (Simply Typed Lambda Calculus):** The STLC admits all three structural rules (weakening, contraction, exchange) unconditionally, and linear type systems arise precisely by restricting or tracking these rules.

- **Doc 05 (Lambda Cube):** Linear type systems are orthogonal to the lambda cube's three axes of polymorphism, dependent types, and type operators, and can be combined with any cube vertex to yield resource-sensitive variants.

- **Doc 16 (Effects and Monads):** Linear types provide an alternative to monadic encapsulation for controlling effects, since linearity can enforce single-use protocols and safe resource management without requiring a monadic discipline.
