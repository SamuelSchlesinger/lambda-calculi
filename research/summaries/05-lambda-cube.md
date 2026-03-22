# The Lambda Cube (Barendregt's Lambda-Cube)

## Overview

The **lambda cube** (or **Barendregt's lambda-cube**) is a framework introduced by Henk
Barendregt that systematically classifies eight typed lambda calculi along three
orthogonal dimensions of abstraction. The cube provides a fine-structure analysis of the
Calculus of Constructions (Coquand and Huet, 1988), decomposing it into independent
features that can be combined in all possible ways. The simply typed lambda calculus
(STLC) sits at one corner of the cube, and the Calculus of Constructions sits at the
diagonally opposite corner, with the six other systems occupying intermediate positions.

All eight systems share a common foundation: terms depending on terms (ordinary function
abstraction). They differ in which additional forms of dependency they permit between terms
and types. The cube is further generalized by the theory of **Pure Type Systems** (PTS),
which subsumes all eight systems as specific instantiations of a single parametric
framework.

---

## Historical Context

### Barendregt's Unifying Framework

The lambda cube was introduced in:

- **Barendregt, H.P.** "Introduction to generalized type systems." *Journal of Functional
  Programming*, 1(2):125-154, April 1991.

The most comprehensive treatment appears in:

- **Barendregt, H.P.** "Lambda Calculi with Types." In *Handbook of Logic in Computer
  Science*, Volume 2, Oxford University Press, 1992.

Barendregt's motivation was to understand the Calculus of Constructions not as a monolithic
system but as a combination of three independent extensions to the simply typed lambda
calculus. This decomposition revealed that each feature -- polymorphism, dependent types,
and type operators -- could be studied in isolation or in any combination.

### Predecessors and Contemporaries

The systems at the cube's vertices had been studied individually before Barendregt's
unification:

- **Simply Typed Lambda Calculus** (Church, 1940; Curry, 1934)
- **System F** (Girard, 1972; Reynolds, 1974) -- polymorphic lambda calculus
- **Calculus of Constructions** (Coquand and Huet, 1988) -- the full system
- **Lambda-P / LF** (Harper, Honsell, Plotkin, 1987/1993) -- dependent types for logical
  frameworks

The generalization to Pure Type Systems was independently discovered by:

- **Stefano Berardi** (1988) -- showed that generalized type systems could describe many
  logical systems
- **Jan Terlouw** (1988/1989) -- independently introduced the same generalization

Barendregt discussed and popularized this generalization in his subsequent papers,
establishing the standard terminology and notation.

---

## The Three Axes / Dimensions

The lambda cube is organized along three orthogonal axes, each representing a new form
of dependency that can be added to the simply typed lambda calculus. All systems include
the base capability of **terms depending on terms** (ordinary functions).

### Axis 1: Terms Depending on Types (Polymorphism)

**Direction:** lambda-arrow to lambda-2 (System F)

This axis adds the ability for **terms to abstract over types**. A polymorphic function
can take a type as an argument and produce a term. This is polymorphism in the sense of
Girard and Reynolds.

**Example:** The polymorphic identity function:

    id : forall (alpha : *). alpha -> alpha
    id = Lambda (alpha : *). lambda (x : alpha). x

In the PTS framework, this corresponds to the rule **(box, *)**, which allows forming
a product `Pi (alpha : box). B` where `alpha` ranges over types (sort box) and the
result `B` is a type (sort *). This produces types like `forall alpha. alpha -> alpha`.

**Curry-Howard:** Corresponds to **second-order universal quantification** over
propositions.

### Axis 2: Types Depending on Types (Type Operators)

**Direction:** lambda-arrow to lambda-omega (weak)

This axis adds the ability for **types to abstract over types** -- that is, type-level
functions or type operators. One can write functions at the type level that take types
as input and produce types as output.

**Example:** A type-level list constructor:

    List : * -> *
    List = lambda (alpha : *). forall (beta : *). (alpha -> beta -> beta) -> beta -> beta

In the PTS framework, this corresponds to the rule **(box, box)**, which allows forming
a product `Pi (alpha : box). B` where both `alpha` and `B` inhabit sorts at the kind level.

**Curry-Howard:** Corresponds to **higher-order propositional logic**, where one can
quantify over predicates or propositional functions.

### Axis 3: Types Depending on Terms (Dependent Types)

**Direction:** lambda-arrow to lambda-P

This axis adds the ability for **types to depend on terms** -- the type of a result can
vary depending on the value of an argument. This is the most distinctive feature,
enabling types to carry information about term-level values.

**Example:** A vector type indexed by its length:

    Vec : Nat -> * -> *
    Vec 0 alpha = Unit
    Vec (S n) alpha = alpha * Vec n alpha

In the PTS framework, this corresponds to the rule **(*, box)**, which allows forming
a product `Pi (x : A). B` where `A` is a type (sort *) and `B` is a kind (sort box).
This produces type families indexed by terms.

**Curry-Howard:** Corresponds to **first-order universal quantification** over
individuals (not propositions), yielding predicate logic.

---

## All Eight Vertices of the Cube

### Common Structure

All eight systems share:

- **Sorts:** S = {*, box}
  - `*` (star) -- the sort of types / propositions. Note: in the pure lambda cube,
    `*` is a single sort of types. In the Calculus of Inductive Constructions (CIC)
    used by Coq/Rocq and Lean (see Docs 06-07), `Prop` and `Type` are **distinct**
    sorts with different properties (e.g., `Prop` is impredicative and proof-irrelevant
    in Coq, while `Type` is predicative and stratified into a universe hierarchy).
  - `box` (square, also written `Kind`) -- the sort of kinds / type constructors

- **Axioms:** A = {* : box}
  - This axiom states that the collection of all types is itself classified by a kind.

- **Base Rule:** All systems include the rule (*, *, *), which allows forming ordinary
  (non-dependent) function types `A -> B` where both `A` and `B` are types.

The systems differ only in which additional rules they include from the set
{(*, box), (box, *), (box, box)}.

### Notational Unification: `Λ`/`λ` and `∀`/`Π`

In presentations of individual systems (e.g., System F in Doc 03, System Fω in
Doc 04), distinct symbols are often used: `λ` for term abstraction, `Λ` for type
abstraction, `→` for function types, and `∀` for universal quantification. The
lambda cube and PTS framework **unify** these into a single abstraction form `λ(x:A).M`
and a single product form `Π(x:A).B`. The universal quantifier `∀α:*.τ` is simply
the dependent product `Π(α:*).τ` where the bound variable does not appear free in
a term-level sense, and the function type `A → B` is `Π(x:A).B` where `x` does not
appear free in `B`. This unification is one of the key insights that makes the PTS
framework possible.

### Formal Rule Specifications

For a rule (s1, s2, s3), the product formation rule is:

    Gamma |- A : s1    Gamma, x : A |- B : s2
    -------------------------------------------
           Gamma |- Pi(x : A). B : s3

In the lambda cube, s3 = s2 always, so the rules are written as pairs (s1, s2):

    Gamma |- A : s1    Gamma, x : A |- B : s2
    -------------------------------------------
           Gamma |- Pi(x : A). B : s2

### The Eight Systems

#### 1. lambda-arrow (Simply Typed Lambda Calculus, STLC)

**Rules:** {(*, *)}

**Features:** Terms depending on terms only. This is the base system with simple
function types `A -> B`.

**Computational Power:** Corresponds to extended polynomials. Very weak -- not even all
primitive recursive functions are expressible.

**Curry-Howard:** (Intuitionistic) **Propositional Calculus** with implication only. Types
are propositions, terms are proofs, and `A -> B` corresponds to implication.

**PTS Specification:**
- S = {*, box}
- A = {(*, box)}
- R = {(*, *, *)}

---

#### 2. lambda-2 (System F, Second-Order Lambda Calculus)

**Rules:** {(*, *), (box, *)}

**Features:** Terms depending on terms + terms depending on types (polymorphism). Adds
type abstraction `Lambda (alpha : *). M` and type application `M [A]`.

**Computational Power:** Extremely powerful. The functions definable in lambda-2 are
exactly those provably total in second-order Peano arithmetic. Can encode natural numbers,
booleans, lists, and other data types impredicatively.

**Curry-Howard:** **Second-Order Propositional Calculus**. The type `forall alpha. P(alpha)`
corresponds to universal quantification over propositions.

**PTS Specification:**
- S = {*, box}
- A = {(*, box)}
- R = {(*, *, *), (box, *, *)}

**Key Examples:**
- Polymorphic identity: `Lambda alpha : *. lambda x : alpha. x : forall alpha. alpha -> alpha`
- Church naturals: `Nat = forall alpha : *. alpha -> (alpha -> alpha) -> alpha`
- Church booleans: `Bool = forall alpha : *. alpha -> alpha -> alpha`

---

#### 3. lambda-underline-omega (Weak Omega / Type Operators Only)

**Rules:** {(*, *), (box, box)}

**Features:** Terms depending on terms + types depending on types (type operators). Adds
type-level lambda abstraction but no polymorphism at the term level.

**Computational Power:** Same as lambda-arrow in terms of definable functions. Type
operators add no term-level expressiveness, only the ability to construct types
systematically.

**Curry-Howard:** **Weakly Higher-Order Propositional Calculus**. One can define
propositional operators (like conjunction or disjunction as type-level functions) but
cannot quantify over propositions.

**PTS Specification:**
- S = {*, box}
- A = {(*, box)}
- R = {(*, *, *), (box, box, box)}

---

#### 4. lambda-P (LF / Dependent Types)

**Rules:** {(*, *), (*, box)}

**Features:** Terms depending on terms + types depending on terms (dependent types). The
type of a result can depend on the value of an argument.

**Computational Power:** Same as lambda-arrow. Having dependent types does not enhance
computational power; it only enables more precise type properties to be expressed.

**Curry-Howard:** **First-Order Predicate Logic** (with implication as only connective).
The dependent product `Pi (x : A). B(x)` corresponds to universal quantification
`forall x : A. P(x)` over individuals of domain `A`.

**PTS Specification:**
- S = {*, box}
- A = {(*, box)}
- R = {(*, *, *), (*, box, box)}

**Relation to LF:** The Edinburgh Logical Framework (Harper, Honsell, Plotkin 1987/1993)
is essentially this system. It uses dependent types to encode logics via the
"judgements-as-types" principle. The three levels of LF -- objects, types, and kinds --
correspond to terms classified by `*` and types classified by `box`.

**Key Examples:**
- Dependent function: `Pi (n : Nat). Vec n A -> Vec (S n) A`
- Predicate as type family: `Even : Nat -> *`

---

#### 5. lambda-P2 (Second-Order Dependent Types)

**Rules:** {(*, *), (*, box), (box, *)}

**Features:** Combines dependent types and polymorphism. Types can depend on terms (as in
lambda-P) and terms can depend on types (as in lambda-2).

**Curry-Howard:** **Second-Order Predicate Calculus**. One has both quantification over
individuals (from dependent types) and quantification over propositions (from
polymorphism).

**PTS Specification:**
- S = {*, box}
- A = {(*, box)}
- R = {(*, *, *), (*, box, box), (box, *, *)}

---

#### 6. lambda-P-underline-omega (Dependent Type Operators)

**Rules:** {(*, *), (*, box), (box, box)}

**Features:** Combines dependent types and type operators. Types can depend on terms (as
in lambda-P) and types can depend on types (as in lambda-omega-underline).

**Curry-Howard:** **Weak Higher-Order Predicate Calculus**. One has quantification over
individuals and type-level operators, but no polymorphism (no term-level quantification
over types).

**PTS Specification:**
- S = {*, box}
- A = {(*, box)}
- R = {(*, *, *), (*, box, box), (box, box, box)}

---

#### 7. lambda-omega (System F-omega)

**Rules:** {(*, *), (box, *), (box, box)}

**Features:** Combines polymorphism and type operators. Terms can depend on types (as in
lambda-2) and types can depend on types (as in lambda-omega-underline). This is an
extremely powerful system.

**Computational Power:** Extremely strong. System F-omega has been considered as a basis
for programming languages. It is the internal language used in GHC (Haskell's compiler)
as an intermediate representation.

**Curry-Howard:** **Higher-Order Propositional Calculus**. One can quantify over
propositions and define propositional operators.

**PTS Specification:**
- S = {*, box}
- A = {(*, box)}
- R = {(*, *, *), (box, *, *), (box, box, box)}

---

#### 8. lambda-C (Calculus of Constructions, lambda-P-omega, CC)

**Rules:** {(*, *), (*, box), (box, *), (box, box)}

**Features:** Combines all three features: dependent types, polymorphism, and type
operators. This is the most expressive system in the cube, sitting at the corner
diagonally opposite to lambda-arrow.

**Computational Power:** As strong as System F-omega in computational terms, with the
additional expressive power of dependent types for specifying properties.

**Curry-Howard:** **Higher-Order Predicate Calculus** (the Calculus of Constructions
itself). Full quantification over both individuals and propositions, with type operators
for systematic construction of predicates.

**PTS Specification:**
- S = {*, box}
- A = {(*, box)}
- R = {(*, *, *), (*, box, box), (box, *, *), (box, box, box)}

**Practical Importance:** The Calculus of Constructions is the foundation of the Coq/Rocq
proof assistant (extended with inductive types to form the Calculus of Inductive
Constructions, CIC). It is also closely related to the type theories underlying Lean and
Agda.

**Key Examples:**
- Impredicative natural numbers: `Nat := Pi (P : *). P -> (Pi (x : P). P) -> P`
- Leibniz equality: `Eq : Pi (A : *). A -> A -> * := lambda A a b. Pi (P : A -> *). P a -> P b`

---

## Summary Table

| System | Rules | Poly | Dep | TyOp | Curry-Howard |
|--------|-------|------|-----|------|--------------|
| lambda-arrow | (*,*) | No | No | No | Propositional Calculus |
| lambda-2 | (*,*) (box,*) | Yes | No | No | 2nd-Order Prop. Calculus |
| lambda-underline-omega | (*,*) (box,box) | No | No | Yes | Weak HO Prop. Calculus |
| lambda-P | (*,*) (*,box) | No | Yes | No | 1st-Order Pred. Logic |
| lambda-P2 | (*,*) (*,box) (box,*) | Yes | Yes | No | 2nd-Order Pred. Calculus |
| lambda-P-underline-omega | (*,*) (*,box) (box,box) | No | Yes | Yes | Weak HO Pred. Calculus |
| lambda-omega | (*,*) (box,*) (box,box) | Yes | No | Yes | HO Prop. Calculus |
| lambda-C | (*,*) (*,box) (box,*) (box,box) | Yes | Yes | Yes | HO Pred. Calculus (CC) |

---

## Universal Typing Rules

All eight systems share the following typing rules. The only rule that varies is the
product/abstraction rule, which is parameterized by the allowed (s1, s2) pairs.

### Syntax

All systems use a unified syntax of **pseudo-terms**:

    T ::= x          (variable)
        | s          (sort: * or box)
        | T T        (application)
        | lambda x : T . T    (abstraction)
        | Pi x : T . T        (dependent product)

When `x` does not appear free in `B`, the product `Pi x : A. B` is written `A -> B`.

### Contexts

    Gamma ::= empty
            | Gamma, x : A

### Reduction

**Beta-reduction:** `(lambda x : A . M) N -->_beta M[N/x]`

**Beta-equivalence:** `=_beta` is the reflexive-symmetric-transitive closure of `-->_beta`.

### Typing Rules

**(Axiom)**

    ------------- (s1, s2) in A
    |- s1 : s2

**(Start)**

    Gamma |- A : s
    ----------------------- (x not in Gamma)
    Gamma, x : A |- x : A

**(Weakening)**

    Gamma |- A : B    Gamma |- C : s
    --------------------------------- (x not in Gamma)
    Gamma, x : C |- A : B

**(Product)**

    Gamma |- A : s1    Gamma, x : A |- B : s2
    ------------------------------------------- (s1, s2) in R
    Gamma |- Pi(x : A). B : s2

**(Abstraction)**

    Gamma |- A : s1    Gamma, x : A |- M : B    Gamma, x : A |- B : s2
    --------------------------------------------------------------------- (s1, s2) in R
    Gamma |- lambda(x : A). M : Pi(x : A). B

**(Application)**

    Gamma |- M : Pi(x : A). B    Gamma |- N : A
    ------------------------------------------
    Gamma |- M N : B[N/x]

**(Conversion)**

    Gamma |- A : B    B =_beta B'    Gamma |- B' : s
    -------------------------------------------------
    Gamma |- A : B'

---

## Properties of All Lambda Cube Systems

All eight systems in the lambda cube enjoy the following properties:

### 1. Church-Rosser Property (Confluence)

If `M -->*_beta N1` and `M -->*_beta N2`, then there exists `Q` such that
`N1 -->*_beta Q` and `N2 -->*_beta Q`.

This holds for the untyped pseudo-terms and is inherited by the typed systems.

### 2. Subject Reduction

If `Gamma |- M : A` and `M -->_beta M'`, then `Gamma |- M' : A`.

Types are preserved under reduction.

### 3. Uniqueness of Types

If `Gamma |- M : A` and `Gamma |- M : B`, then `A =_beta B`.

Types are unique up to beta-equivalence. (In PTS terminology, all lambda cube systems
are **functional**.)

### 4. Strong Normalization

Every well-typed term in any lambda cube system has a normal form, and there are no
infinite reduction sequences starting from well-typed terms.

This is one of the deepest results about the cube. It implies:

- **Decidability of type checking:** Since all terms normalize, one can decide whether
  `Gamma |- M : A` by reducing to normal form and comparing syntactically.
- **Logical consistency (under Curry-Howard):** The corresponding logics are consistent --
  there is no closed proof of the empty type (falsity).
- **Non-Turing-completeness:** No lambda cube system can express all computable functions.
  Programs always terminate.

### 5. Decidability

Type checking is decidable for all eight systems. Type inference is also decidable
(given a term, one can find its type if it has one).

---

## Pure Type Systems (PTS) as Generalization

### Motivation

The lambda cube demonstrates that eight different type systems can be obtained by varying
the allowed rules over two sorts. Pure Type Systems generalize this idea by allowing
**arbitrary** sets of sorts, axioms, and rules.

### Definition

A **Pure Type System** (PTS) is specified by a triple S = (S, A, R) where:

- **S** is a (possibly infinite) set of elements called **sorts**
- **A** is a set of **axioms** of the form (s1, s2) with s1, s2 in S, asserting `|- s1 : s2`
- **R** is a set of **rules** of the form (s1, s2, s3) with s1, s2, s3 in S, governing
  the formation of dependent products

The typing rules are identical to those of the lambda cube, generalized to use S, A, R
instead of the specific {*, box}, {(*, box)}, and specific rule sets.

### PTS Typing Rules

Given a specification (S, A, R):

**(Axiom)**

    ------------- (s1, s2) in A
    |- s1 : s2

**(Start)**

    Gamma |- A : s
    ----------------------- (x fresh)
    Gamma, x : A |- x : A

**(Weakening)**

    Gamma |- A : B    Gamma |- C : s
    --------------------------------- (x fresh)
    Gamma, x : C |- A : B

**(Product)**

    Gamma |- A : s1    Gamma, x : A |- B : s2
    ------------------------------------------- (s1, s2, s3) in R
    Gamma |- Pi(x : A). B : s3

**(Abstraction)**

    Gamma, x : A |- M : B    Gamma |- Pi(x : A). B : s
    ----------------------------------------------------
    Gamma |- lambda(x : A). M : Pi(x : A). B

**(Application)**

    Gamma |- M : Pi(x : A). B    Gamma |- N : A
    ------------------------------------------
    Gamma |- M N : B[N/x]

**(Conversion)**

    Gamma |- M : A    A =_beta B    Gamma |- B : s
    ------------------------------------------------
    Gamma |- M : B

Note: The PTS abstraction rule differs slightly from the lambda cube presentation. In the
PTS formulation, one requires that the product type `Pi(x:A).B` itself be well-typed
(has some sort `s`), rather than separately checking that A and B have appropriate sorts.
This is equivalent in the lambda cube systems but differs for more exotic PTS.

### Lambda Cube as PTS Instances

Each lambda cube system corresponds to a PTS with:

- S = {*, box}
- A = {(*, box)}
- R as specified per system (using the convention that rules (s1, s2) in the cube
  correspond to (s1, s2, s2) in PTS notation)

---

## Properties and Classification of PTSs

### Functional PTS

A PTS is **functional** if for each sort s1, there is at most one s2 such that
(s1, s2) is in A. In a functional PTS, the type of a term is unique up to
beta-equivalence. All lambda cube systems are functional.

### Injective PTS

A PTS is **injective** if for each s2, there is at most one s1 such that (s1, s2) is
in A (i.e., no sort is the target of more than one axiom). Injective PTS have a
particularly clean type-checking algorithm based on purely syntactic criteria.

### Singly Sorted PTS

A PTS is **singly sorted** if each sort appears as the left component of at most one
axiom. This prevents ambiguity in the sort hierarchy.

### Normalizing PTS

A PTS is **(strongly) normalizing** if every well-typed term has a normal form and no
infinite reduction sequences exist. Strong normalization implies:

- Decidability of type checking
- Consistency (under a Curry-Howard reading)

**Not all PTSs are normalizing.** The most famous counterexamples are **System U**
and its fragment **System U-minus**, where Girard's paradox produces a term of type
`False`.

**System U-minus** has the specification:

- S = {*, box, triangle}
- A = {(*, box), (box, triangle)}
- R = {(*, *), (box, *), (box, box)}

The rule (box, *) allows "polymorphism at the level of kinds," which combined with the
sort hierarchy creates enough power to encode a paradox.

**System U** (the full version) extends U-minus with an additional rule that closes
the system under all product formations involving the third sort:

- S = {*, box, triangle}
- A = {(*, box), (box, triangle)}
- R = {(*, *), (box, *), (box, box), (triangle, *), (triangle, box), (triangle, triangle)}

The additional rules involving triangle allow quantification at the level of the
third sort, making the system strictly more expressive (and still inconsistent).

### The Barendregt-Geuvers-Klop Conjecture

An important open problem (as of the early literature): Does **weak normalization**
(every well-typed term *has* a normal form) imply **strong normalization** (there are no
infinite reduction sequences)? This is known as the Barendregt-Geuvers-Klop conjecture.
All known examples of PTS that are not strongly normalizing are also not weakly
normalizing.

### Consistency and Girard's Paradox

The rule **Type : Type** (having a sort that is its own type) leads to inconsistency.
This was first discovered by Jean-Yves Girard in 1972, who showed that System U is
inconsistent. Martin-Lof's original 1971 type theory suffered from the same problem.

This result has profound consequences for the design of proof assistants:

- Coq/Rocq uses a stratified hierarchy of universes: `Prop : Type_0 : Type_1 : ...`
- Agda similarly uses universe levels
- Lean uses a universe hierarchy with universe polymorphism

The lambda cube avoids this problem because it has only two sorts with a single axiom
`* : box`, and `box` is not typed by anything (it is a "top sort").

---

## The Cube as a Substructure of the PTS Landscape

The lambda cube occupies a very specific region of the vast landscape of all possible
Pure Type Systems:

1. **Two sorts only:** The cube uses exactly S = {*, box}. PTSs can have arbitrarily many
   sorts, enabling universe hierarchies.

2. **Single axiom:** The cube has only A = {(*, box)}. PTSs can have multiple axioms
   creating complex sort hierarchies.

3. **Restricted rules:** The cube varies over 4 possible rules. PTSs can have arbitrary
   rules, including ones that lead to inconsistency.

4. **All normalizing:** Every system in the cube is strongly normalizing. The broader
   PTS landscape includes non-normalizing (and hence inconsistent) systems.

### Beyond the Cube

Important PTSs outside the cube include:

- **System U / System U-minus:** Non-normalizing, inconsistent systems demonstrating
  Girard's paradox.

- **The Extended Calculus of Constructions (ECC):** Adds a hierarchy of universes
  `*_0 : *_1 : *_2 : ...` to the Calculus of Constructions. Due to Zhaohui Luo (1989).

- **The Calculus of Inductive Constructions (CIC):** Extends CC with inductive types and
  universe hierarchy. The foundation of Coq/Rocq.

- **UTT (Unified Theory of Dependent Types):** Luo's predicative type theory with
  universes.

---

## Relationships Between the Systems

The eight systems form a partial order under inclusion (every well-typed term in a smaller
system is also well-typed in a larger system). The inclusion relationships form the edges
of the cube:

```
                lambda-C (CC)
               / |        \  \
              /  |         \  \
         lambda-P-omega   lambda-P2   lambda-omega (F-omega)
            |     \        / |        / |
            |      \      /  |       /  |
         lambda-P   lambda-underline-omega   lambda-2
            \        |        /
             \       |       /
              lambda-arrow (STLC)
```

Edges of the cube represent single-feature additions:

- **Bottom face** (no dependent types): lambda-arrow, lambda-2, lambda-underline-omega,
  lambda-omega
- **Top face** (with dependent types): lambda-P, lambda-P2, lambda-P-underline-omega,
  lambda-C
- **Vertical edges** add dependent types (the (*, box) rule)
- **Left-right edges** add polymorphism (the (box, *) rule)
- **Front-back edges** add type operators (the (box, box) rule)

### Expressiveness Hierarchy

In terms of the functions definable at base type (e.g., Nat -> Nat):

1. **lambda-arrow, lambda-P, lambda-underline-omega, lambda-P-underline-omega:** Extended
   polynomials. Dependent types and type operators alone do not add computational power.

2. **lambda-2, lambda-P2:** Functions provably total in second-order Peano arithmetic.
   Polymorphism alone provides enormous computational power.

3. **lambda-omega, lambda-C:** At least as strong as lambda-2; System F-omega is
   considered extremely strong.

---

## Curry-Howard Correspondence at Each Vertex

The Curry-Howard correspondence establishes a deep connection between each lambda cube
system and a system of logic:

| System | Logic | Quantification |
|--------|-------|---------------|
| lambda-arrow | Minimal propositional logic (implication only) | None |
| lambda-2 | Second-order propositional logic | Over propositions |
| lambda-underline-omega | Weak higher-order propositional logic | Prop. operators |
| lambda-P | First-order predicate logic (implication only) | Over individuals |
| lambda-P2 | Second-order predicate calculus | Over individuals + propositions |
| lambda-P-underline-omega | Weak higher-order predicate calculus | Individuals + pred. operators |
| lambda-omega | Higher-order propositional calculus | Over propositions + prop. operators |
| lambda-C | Higher-order predicate calculus | All forms |

Under the Curry-Howard reading:

- **Types are propositions** (or predicates, for dependent types)
- **Terms are proofs**
- **Pi-types are universal quantifiers** (or implications when non-dependent)
- **Function application is modus ponens**
- **Lambda abstraction is proof by assumption**
- **Strong normalization implies consistency** -- there is no closed term of the empty type

The correspondence grows richer along each axis:

- **Polymorphism axis:** Adds quantification over propositions (second-order logic)
- **Dependent types axis:** Adds quantification over individuals (predicate logic)
- **Type operators axis:** Adds propositional/predicate operators (higher-order logic)

---

## Key References

### Primary Sources

1. **Barendregt, H.P.** "Introduction to generalized type systems." *Journal of Functional
   Programming*, 1(2):125-154, 1991.
   - The original lambda cube paper.

2. **Barendregt, H.P.** "Lambda Calculi with Types." In *Handbook of Logic in Computer
   Science*, Volume 2, eds. S. Abramsky, D.M. Gabbay, T.S.E. Maibaum, Oxford University
   Press, 1992.
   - Comprehensive survey; the standard reference for the lambda cube and PTS.

3. **Coquand, T. and Huet, G.** "The Calculus of Constructions." *Information and
   Computation*, 76(2-3):95-120, 1988.
   - The original Calculus of Constructions paper.

4. **Girard, J.-Y.** "Interpretation fonctionnelle et elimination des coupures de
   l'arithmetique d'ordre superieur." These de doctorat d'etat, Universite Paris VII,
   1972.
   - Introduction of System F (polymorphic lambda calculus).

5. **Reynolds, J.C.** "Towards a theory of type structure." In *Colloque sur la
   Programmation*, Lecture Notes in Computer Science 19, Springer, 1974.
   - Independent discovery of System F.

6. **Harper, R., Honsell, F., and Plotkin, G.** "A Framework for Defining Logics."
   *Journal of the ACM*, 40(1):143-184, 1993.
   - The Edinburgh Logical Framework (LF), based on lambda-P.

### On Pure Type Systems

7. **Berardi, S.** "Type dependence and constructive mathematics." Ph.D. thesis,
   University of Turin, 1988.
   - Independent introduction of generalized/pure type systems.

8. **Terlouw, J.** "Een nadere bewijstheoretische analyse van GSTTs." Manuscript,
   University of Nijmegen, 1989.
   - Independent introduction of pure type systems.

9. **Geuvers, H.** "Logics and Type Systems." Ph.D. thesis, University of Nijmegen, 1993.
   - Comprehensive study of PTS properties and the normalization question.

### On Normalization and Consistency

10. **Girard, J.-Y.** "Interpretation fonctionnelle..." (1972, cited above).
    - Proof of strong normalization for System F via reducibility candidates.

11. **Coquand, T.** "An Analysis of Girard's Paradox." In *Proceedings of the First
    Annual Symposium on Logic in Computer Science (LICS)*, IEEE, 1986.
    - Analysis of why System U is inconsistent.

### Textbooks and Surveys

12. **Sorensen, M.H. and Urzyczyn, P.** *Lectures on the Curry-Howard Isomorphism.*
    Elsevier, 2006.
    - Textbook covering the lambda cube and Curry-Howard correspondence.

13. **Nederpelt, R. and Geuvers, H.** *Type Theory and Formal Proof: An Introduction.*
    Cambridge University Press, 2014.
    - Modern textbook covering the lambda cube and dependent type theory.

14. **Pierce, B.C.** *Types and Programming Languages.* MIT Press, 2002.
    - Standard PL textbook covering System F and System F-omega.

---

## Cross-References

- **Doc 06 (Calculus of Inductive Constructions):** CIC extends the Calculus of
  Constructions (λC, the top vertex of the cube) with inductive types, a universe
  hierarchy, and the distinction between `Prop` and `Type` (which are **not**
  identified as they are in the pure lambda cube's single sort `*`).

- **Doc 07 (Calculus of Inductive Constructions):** Lean's type theory is based on CIC with
  modifications including quotient types and a non-cumulative universe hierarchy,
  building on the CC vertex of the lambda cube.

- **Doc 08 (Coinductive Constructions):** Cubical type theory provides an alternative
  foundation for homotopy type theory that goes beyond the lambda cube framework,
  adding path types and the univalence axiom as computational rules.
