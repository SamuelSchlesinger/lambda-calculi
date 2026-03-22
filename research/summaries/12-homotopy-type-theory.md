# Homotopy Type Theory (HoTT) and Cubical Type Theory

## Overview

Homotopy type theory (HoTT) is a foundational program that interprets Martin-Lof's intensional type theory through the lens of homotopy theory, treating types as spaces, terms as points, identity proofs as paths, proofs of identity between identity proofs as homotopies, and so on up through all dimensions. The central innovation is Voevodsky's **univalence axiom**, which asserts that equivalent types are identical, together with **higher inductive types** (HITs) that allow the synthetic construction of spaces with prescribed higher-dimensional structure. **Cubical type theory** arose as a solution to the computational deficiencies introduced by treating univalence as an axiom, providing a type theory in which univalence is a theorem with computational content.

---

## 1. Historical Context

### 1.1 Precursors: Hofmann-Streicher and the Groupoid Model (1998)

The story begins with a negative result. In 1994, Martin Hofmann and Thomas Streicher constructed a model of intensional Martin-Lof type theory in the category of groupoids, demonstrating that the **uniqueness of identity proofs** (UIP) -- the principle that any two proofs of the same identity `p, q : Id_A(a, b)` are themselves propositionally equal -- is **not derivable** in intensional type theory.

In their groupoid model:
- Types are interpreted as groupoids (categories where every morphism is an isomorphism).
- Terms are objects of groupoids.
- Identity proofs between terms are morphisms.
- Two distinct morphisms between the same objects give distinct identity proofs.

This was the first indication that identity types carry non-trivial higher-dimensional structure. Hofmann and Streicher also observed that their model satisfies a principle they called **universe extensionality**: in the universe of sets (0-types), identity between types corresponds to isomorphism. This is precisely the restriction of the univalence axiom to 1-types, anticipating Voevodsky's work by a decade.

### 1.2 Awodey-Warren: Homotopy-Theoretic Models (2005-2009)

Steve Awodey and his student Michael Warren extended the Hofmann-Streicher insight to full homotopy theory. In their 2007 preprint (published 2009), "Homotopy theoretic models of identity types," they showed that a form of intensional type theory can be soundly modelled in **any Quillen model category**. This generalized the groupoid model: where Hofmann-Streicher used 1-groupoids (capturing one level of non-trivial identity), Awodey-Warren used the full homotopy-theoretic structure of model categories, in which types correspond to objects with the homotopy type of CW-complexes and identity types correspond to path spaces.

Independently and around the same time, Vladimir Voevodsky arrived at similar ideas from a different direction.

### 1.3 Voevodsky and Univalent Foundations (2006-2013)

Vladimir Voevodsky, a Fields Medalist for his work on motivic cohomology, came to type theory through a practical crisis: he had encountered persistent, hard-to-detect errors in complex mathematical proofs (including his own) and concluded that only computer verification could provide adequate certainty for abstract mathematics.

Key timeline:
- **1984**: As an undergraduate, Voevodsky read Grothendieck's "Esquisse d'un Programme," sparking his interest in higher-dimensional structures.
- **~2000**: After encountering errors in published proofs (including his own 1992-93 work on presheaves with transfers and an ongoing uncertainty about a 1989 paper with Kapranov on infinity-groupoids questioned by Simpson in 1998), Voevodsky decided that computer verification was essential.
- **2005-2006**: Began developing univalent models, formulating the concept of a "univalent fibration."
- **2009**: Realized that identity types could be combined with univalent universes, and that univalence could be stated as a simple axiom added to Martin-Lof type theory. First public presentation at LMU Munich in November 2009.
- **2010**: Created the first Coq library called "Foundations" (later incorporated into UniMath).
- **2012-2013**: Organized "A Special Year on Univalent Foundations of Mathematics" at the Institute for Advanced Study (IAS) in Princeton, bringing together researchers in topology, computer science, category theory, and mathematical logic. The program was co-organized by Awodey, Coquand, and Voevodsky.

The IAS special year produced the **HoTT Book** ("Homotopy Type Theory: Univalent Foundations of Mathematics," The Univalent Foundations Program, 2013), a collaboratively written textbook that remains the standard reference.

---

## 2. Identity Types in Martin-Lof Type Theory

### 2.1 Formation, Introduction, Elimination, and Computation

Identity types are the type-theoretic representation of equality. Their rules in Martin-Lof's intensional type theory are:

**Formation rule.** Given a type `A` and terms `a, b : A`, there is a type `Id_A(a, b)` (also written `a =_A b`).

**Introduction rule (refl).** For any `a : A`, there is a canonical proof of self-identity:
```
refl_a : Id_A(a, a)
```

**Elimination rule (J).** Given:
- A type family `C : (x : A) -> (y : A) -> Id_A(x, y) -> Type`
- A term `d : (x : A) -> C(x, x, refl_x)`
- Terms `a, b : A` and `p : Id_A(a, b)`

there is a term `J(C, d, a, b, p) : C(a, b, p)`.

The J rule says: to prove something about an arbitrary identity proof `p : Id_A(a, b)`, it suffices to prove it for `refl_a : Id_A(a, a)` for all `a`.

**Computation rule (beta).** `J(C, d, a, a, refl_a)` computes (reduces definitionally) to `d(a)`.

### 2.2 Based Path Induction (Paulin-Mohring J)

An equivalent formulation fixes one endpoint:

Given `a : A`, a type family `C : (y : A) -> Id_A(a, y) -> Type`, and a term `d : C(a, refl_a)`, for any `b : A` and `p : Id_A(a, b)`, there is a term `J'(C, d, b, p) : C(b, p)` with `J'(C, d, a, refl_a) = d`.

This is sometimes more convenient and is provably equivalent to the standard J rule.

### 2.3 Transport

A key derived operation is **transport**. Given a type family `P : A -> Type` and a path `p : Id_A(a, b)`, transport produces a function:
```
transport(P, p) : P(a) -> P(b)
```
This witnesses that identifications in the base can be "lifted" to move between fibers. In homotopy-theoretic terms, transport corresponds to the action of a fibration on paths in the base space.

Transport is derivable from J: set `C(x, y, _) = P(x) -> P(y)` and `d(x) = id_{P(x)}`.

---

## 3. The Groupoid and Higher Groupoid Structure of Types

### 3.1 Groupoid Operations from Identity Types

Using the J eliminator alone, one can derive the following structure on any type `A`:

- **Reflexivity**: `refl : a = a` (given by the introduction rule)
- **Symmetry** (inverse): `sym : (a = b) -> (b = a)`
- **Transitivity** (composition): `trans : (a = b) -> (b = c) -> (a = c)`
- **Groupoid laws hold up to higher paths**:
  - `trans(p, refl) = p` (right unit, up to a 2-path)
  - `trans(refl, p) = p` (left unit, up to a 2-path)
  - `trans(p, sym(p)) = refl` (right inverse, up to a 2-path)
  - `trans(sym(p), p) = refl` (left inverse, up to a 2-path)
  - Associativity of `trans` holds up to a 2-path

Crucially, these laws hold only **up to higher paths**, not definitionally. The witnesses of these laws are themselves elements of iterated identity types, and they satisfy their own coherence laws up to yet higher paths, and so on ad infinitum.

### 3.2 Types as Weak Infinity-Groupoids

This structure makes every type into a **weak infinity-groupoid**: a structure with objects (points), morphisms (paths), 2-morphisms (paths between paths), 3-morphisms, and so on, with composition and inverses at every level satisfying coherence laws only up to the next level.

The Hofmann-Streicher groupoid model captured the first level of this structure. The full omega-groupoid structure was implicit in Martin-Lof type theory all along but was not recognized until the homotopy-theoretic interpretation was developed.

Peter Lumsdaine (2009) and Benno van den Berg and Richard Garner (2011) independently proved that the types of Martin-Lof type theory carry the structure of weak omega-groupoids.

---

## 4. The Univalence Axiom

### 4.1 Statement

Let `U` be a universe (a type of types). For types `A, B : U`, there is a canonical function:

```
idtoequiv : (A =_U B) -> (A ≃ B)
```

constructed by transport along the identity function on `U`. This sends `refl_A` to the identity equivalence on `A`.

**The Univalence Axiom** states that `idtoequiv` is itself an equivalence:

```
ua : (A =_U B) ≃ (A ≃ B)
```

Here, `A ≃ B` denotes the type of **equivalences** between `A` and `B`. An equivalence is a function `f : A -> B` such that each fiber is contractible -- equivalently, `f` has a two-sided inverse up to homotopy (a "bi-invertible map" or "half-adjoint equivalence").

In the reverse direction, `ua` provides a function:
```
ua : (A ≃ B) -> (A =_U B)
```
that converts any equivalence into a path in the universe. The computation rule says that transporting along `ua(e)` is the same as applying `e`.

### 4.2 Motivation

Univalence captures a principle that mathematicians use constantly but that traditional foundations do not formalize: **equivalent structures are interchangeable**. In ZFC, isomorphic groups are "the same for all purposes" but are not literally equal. Univalence makes this informal practice precise: if `A ≃ B`, then `A =_U B`, so any property or construction that applies to `A` automatically applies to `B`.

Voevodsky called this "univalent" drawing on a Russian translation of Boardman and Vogt's book where "faithful functor" was rendered as "univalent functor."

### 4.3 Consequences

**Function extensionality.** Univalence implies that pointwise equal functions are equal:
```
funext : ((x : A) -> f(x) = g(x)) -> f = g
```
This is not provable in plain Martin-Lof type theory but follows from univalence. The proof goes through the observation that the type of equivalences `(A -> B) ≃ (A -> B)` can be characterized using pointwise equality, and univalence converts this to a path.

**Propositional extensionality.** Logically equivalent mere propositions are equal.

**Structure identity principle.** Isomorphic mathematical structures (groups, rings, etc.) are identical when formalized in the appropriate way. This is the mathematical content of univalence: it implements the "principle of equivalence" from category theory at the foundational level.

**No definable property distinguishes equivalent types.** Any predicate `P : U -> Type` satisfies `P(A) ≃ P(B)` whenever `A ≃ B`. This means that in univalent type theory, one cannot "see" the implementation details of a type, only its structure up to equivalence.

---

## 5. n-Types and Truncation Levels

### 5.1 The Truncation Hierarchy

Types in HoTT are stratified by the complexity of their identity structure, indexed by **truncation level** (also called **h-level**), starting at -2:

| Truncation level | Name | Definition | Examples |
|---|---|---|---|
| -2 | Contractible type | There exists a center `c : A` with `(x : A) -> c = x` | Unit type `1` |
| -1 | Mere proposition (h-proposition) | Any two elements are equal: `(x y : A) -> x = y` | Empty type `0`, truth values |
| 0 | Set (h-set) | Any two equality proofs are equal: `(x y : A) -> (p q : x = y) -> p = q` | Natural numbers, booleans |
| 1 | 1-type (groupoid) | Equality proofs between equality proofs are unique | Sets with non-trivial automorphism groups |
| n | n-type | All identity types of level > n are contractible | ... |

A type is an **n-type** if all its iterated identity types above dimension n are contractible. The hierarchy is cumulative: every n-type is also an (n+1)-type.

### 5.2 Truncation

From the homotopy-theoretic viewpoint, an n-type has trivial homotopy groups above dimension n. The **n-truncation** operation takes any type and "kills" its structure above level n, producing an n-type. The most important case is:

### 5.3 Propositional Truncation (the Bracket Type)

The **propositional truncation** (or (-1)-truncation) of a type `A`, written `||A||` or `|A|_{-1}`, is a mere proposition that is inhabited if and only if `A` is inhabited. It "forgets" all information about *which* element of `A` exists, retaining only *whether* one exists.

It can be defined as a higher inductive type with constructors:
- `|a| : ||A||` for each `a : A`
- `trunc : (x y : ||A||) -> x = y` (path constructor making it a proposition)

The elimination principle says: to define a function out of `||A||`, the target must itself be a mere proposition.

This is essential for doing constructive mathematics in HoTT. The statement "there exists an x with property P" is formalized as `||(x : A) * P(x)||` -- the propositional truncation of the sigma type -- ensuring existence claims carry no computational content about witnesses.

---

## 6. Higher Inductive Types (HITs)

### 6.1 Definition

Higher inductive types generalize ordinary inductive types by allowing constructors that produce not just points but also paths (identities) and higher paths. Whereas an ordinary inductive type is generated only by point constructors, a HIT may additionally specify:
- **Path constructors**: elements of the identity type
- **2-path constructors**: elements of the identity type of the identity type
- And so on for arbitrary dimensions

### 6.2 Key Examples

**The circle S^1:**
```
data S^1 : Type where
  base : S^1
  loop : base = base
```
One point constructor and one path constructor: a point `base` and a non-trivial loop from `base` to itself.

**The 2-sphere S^2:**
```
data S^2 : Type where
  base2 : S^2
  surf : refl_{base2} = refl_{base2}
```
One point and one 2-path constructor.

**Suspension:**
```
data Susp (X : Type) : Type where
  north : Susp X
  south : Susp X
  merid : X -> north = south
```

**Pushouts:**
```
data Pushout {A B C : Type} (f : C -> A) (g : C -> B) : Type where
  inl : A -> Pushout f g
  inr : B -> Pushout f g
  push : (c : C) -> inl (f c) = inr (g c)
```
Many homotopy-theoretic constructions (suspensions, joins, mapping cones, homotopy coequalizers) are special cases of pushouts.

**Set quotients:**
```
data A/R : Type where
  proj : A -> A/R
  relate : (x y : A) -> R x y -> proj x = proj y
  squash : (x y : A/R) -> (p q : x = y) -> p = q
```
The `squash` constructor forces the result to be a set (0-type).

**Propositional truncation** (as above) is itself a HIT.

### 6.3 Elimination Principles

The recursion principle for a HIT requires specifying where each constructor maps. For example, to define a function `f : S^1 -> X`, one must provide:
- A point `x : X` (the image of `base`)
- A loop `l : x = x` (the image of `loop`)

The induction principle additionally requires that the image data is coherent with respect to dependent paths. The key operations used are `ap` (functorial action of functions on paths) for recursion and `apd` (dependent action) for induction.

---

## 7. Synthetic Homotopy Theory

### 7.1 pi_1(S^1) = Z

The first major result of synthetic homotopy theory, due to Licata and Shulman (2013), is the calculation that the fundamental group of the circle is the integers:
```
pi_1(S^1) ≅ Z
```

The proof uses the **encode-decode method**:

1. **Define the universal cover**: a type family `code : S^1 -> Type` where `code(base) = Z` and transport along `loop` acts as the successor function on Z. This uses univalence: the successor function is an equivalence `Z ≃ Z`, so `ua(succ) : Z =_U Z`, which can be used to define the action of `loop` on the code.

2. **Encode**: define `encode : (x : S^1) -> (base = x) -> code(x)` by `encode(x, p) = transport(code, p, 0)`.

3. **Decode**: define `decode : (x : S^1) -> code(x) -> (base = x)` by circle induction.

4. Show encode and decode are mutually inverse.

This is a purely type-theoretic proof with no reference to topological spaces, simplicial sets, or other models -- hence "synthetic."

### 7.2 Higher Homotopy Groups

Further results formalized in HoTT include:
- `pi_n(S^n) ≅ Z` for all n >= 1
- `pi_k(S^n) = 0` for k < n (by the Freudenthal suspension theorem, proved synthetically by Licata and Brunerie (LICS 2015))
- The Hopf fibration `S^1 -> S^3 -> S^2` constructed synthetically
- `pi_3(S^2) ≅ Z` via the Hopf fibration
- `pi_4(S^3) ≅ Z/2Z`: Brunerie's thesis (2016) gives a synthetic constructive proof. The proof reduces to computing a "Brunerie number" beta that should equal +/- 2. Ljungstrom and Mortberg (2023) formalized this in Cubical Agda, finding a simplified proof where the Brunerie number normalizes to -2.

---

## 8. The Problem with Univalence as an Axiom: Loss of Canonicity

### 8.1 Canonicity

A type theory enjoys **canonicity** if every closed term of a basic type (e.g., natural numbers) reduces to a canonical form (e.g., a numeral). Canonicity is closely related to decidability of type checking and is a key computational property.

### 8.2 The Problem

When univalence is added as a bare axiom to Martin-Lof type theory (as in the HoTT Book), it introduces **stuck terms**: a closed term of type `Nat` might involve a transport along a path produced by `ua`, and if `ua` has no reduction behavior, the term cannot reduce further. The result is a normal form that is not a numeral.

More precisely:
- `ua(e)` produces a path `A =_U B` but this path has no computational content.
- `transport(P, ua(e), x)` should compute by applying `e` to `x`, but with `ua` as an axiom, this reduction does not happen.
- Consequently, closed terms of type `Nat` may contain `transport(_, ua(_), _)` subterms that block reduction.

This is the **homotopy canonicity problem**: finding a type theory that satisfies both univalence and canonicity. It was one of the open problems listed in the HoTT Book.

### 8.3 Partial Solutions and the Path to Cubical Type Theory

Several approaches were pursued:
- Bezem, Coquand, and Huber (2013) constructed a model of type theory in cubical sets where univalence holds, but initially could not handle all HITs or achieve full canonicity.
- **Homotopy canonicity** (a weaker property: every closed term of type `Nat` is *path-equal* to a numeral, though not necessarily definitionally equal) was proved by Shulman (2019) and Sattler for Book HoTT.
- The definitive solution came from **cubical type theory**, where univalence is a theorem rather than an axiom, and full canonicity is restored.

---

## 9. Cubical Type Theory

### 9.1 Core Idea: The Interval and Path Types

Cubical type theory replaces the inductively defined identity type with **path types** defined using a primitive **interval** `I`. The interval has two endpoints `0` and `1` (sometimes written `i0` and `i1`), but unlike the boolean type, the interval is not discrete: the sequent `i : I |- i = 0 \/ i = 1` does not hold. The interval genuinely has "interior points."

A **path** from `a` to `b` in type `A` is a function `p : I -> A` such that `p(0) = a` and `p(1) = b`. The path type is:
```
Path A a b  =  (i : I) -> A  [i = 0 |-> a, i = 1 |-> b]
```

This makes paths computationally transparent: they are functions from the interval that happen to satisfy boundary constraints. Reflexivity is simply the constant function: `refl = \i. a`. Symmetry (path inverse) is `\i. p(~i)` where `~` is the reversal operation on the interval (in De Morgan cubical type theory).

### 9.2 Face Formulas and Partial Elements

The theory features **face formulas** (also called cofibrations) `phi` built from:
- Endpoint constraints: `i = 0`, `i = 1`
- Conjunctions and disjunctions: `phi /\ psi`, `phi \/ psi`

A **partial element** of type `A` at face `phi` is an element defined only when `phi` holds. This allows specifying boundary data for cubes.

### 9.3 Kan Operations

The computational content of paths requires operations that fill higher-dimensional cubes. These are the **Kan operations**, analogous to the Kan condition in the theory of simplicial/cubical sets.

**Composition (comp/hcomp).** Given a line of types `A : I -> Type`, a partial tube (an open box with one face missing), and a base element, composition produces the missing face. Homogeneous composition `hcomp` is the special case where the type is constant along the line.

Formally, `hcomp` takes:
- A type `A`
- A face formula `phi`
- A "system" `u : I -> Partial phi A` (the walls of the box)
- A base `u0 : A` (the bottom of the box, agreeing with `u` on `phi`)
and produces a term `hcomp u u0 : A` (the lid of the box).

**Transport (transp/coe).** Given a line of types `A : I -> Type` and an element `a : A(0)`, transport produces an element of `A(1)`:
```
transp A a : A(1)
```
When `A` is constant, transport is the identity.

In some formulations (CCHM), composition is a single primitive operation. In Cubical Agda (following a variant of CCHM), it is decomposed into `transp` (heterogeneous transport) and `hcomp` (homogeneous composition), which simplifies the treatment of higher inductive types.

**Filling.** The **filling** operation produces the interior of a cube given its boundary. It can be derived from composition by composing to a fresh dimension variable.

### 9.4 Glue Types and Computational Univalence

The central innovation enabling computational univalence is the **Glue type**. Given:
- A type `B`
- A face formula `phi`
- Types `A_phi` with equivalences `e_phi : A_phi ≃ B` defined on `phi`

the Glue type `Glue B phi (A_phi, e_phi)` is a type that agrees with `A_phi` on face `phi` and with `B` elsewhere, glued together by the equivalences.

Using Glue types, univalence becomes a theorem:
```
ua : (A ≃ B) -> Path Type A B
ua e i = Glue B [ i = 0 |-> (A, e), i = 1 |-> (B, idEquiv B) ]
```

The computation rule for transport along `ua(e)` **definitionally** applies `e`:
```
transport (ua e) a = e(a)
```

This is the key achievement: univalence has computational content. There are no stuck terms.

### 9.5 CCHM Cubical Type Theory (De Morgan)

The **CCHM** cubical type theory (Cohen, Coquand, Huber, Mortberg; originally presented at TYPES 2015, journal version 2018) uses **De Morgan cubical sets** as its semantic basis. The cube category has:

- **Face maps** (projections to boundaries)
- **Degeneracies** (weakening)
- **Connections**: maps `I x I -> I` corresponding to binary min (`/\`) and max (`\/`) operations
- **Reversal**: a map `~ : I -> I` satisfying De Morgan laws with the connections

The De Morgan algebra structure gives:
- `~0 = 1`, `~1 = 0`, `~~i = i`
- `i /\ j` (min/meet), `i \/ j` (max/join)
- De Morgan: `~(i /\ j) = ~i \/ ~j`

Key features:
- Path reversal (symmetry) is primitive: `sym p = \i. p(~i)`
- Connections enable direct construction of many coherences
- Composition is a single primitive operation
- Function extensionality and univalence are theorems
- Higher inductive types are supported

An experimental implementation, `cubicaltt`, was developed by Mortberg.

### 9.6 Cartesian Cubical Type Theory (ABCFHL)

The **Cartesian** variant, developed by Angiuli, Brunerie, Coquand, Favonia (Hou), Harper, and Licata (first presented 2017, journal version in *Mathematical Structures in Computer Science*), uses the **Cartesian cube category**, which has:

- **Face maps** (boundary projections)
- **Degeneracies** (weakening)
- **Diagonal maps** (duplication: `delta : I -> I x I`)
- **Symmetries** (permutation of dimensions)

But crucially, **no connections and no reversal**. This is a more austere setting.

Key differences from CCHM:
- Path reversal must be derived (using composition) rather than being primitive
- Connections can be defined but satisfy computation rules only up to a path ("weak connections")
- The Kan composition operation uses different generating (trivial) cofibrations
- The theory achieves univalence through a different version of Glue types
- Models in cubical sets with the Cartesian cube category

The Cartesian approach has been used in the **redtt** and **cooltt** proof assistants developed at Carnegie Mellon.

### 9.7 De Morgan vs. Cartesian: Comparison

| Feature | De Morgan (CCHM) | Cartesian (ABCFHL) |
|---|---|---|
| Reversal `~i` | Primitive | Derived via composition |
| Connections `i /\ j`, `i \/ j` | Primitive | Derivable (weak) |
| Symmetry of paths | Definitional (`\i. p(~i)`) | Propositional |
| Diagonal maps | Not needed (derivable from connections) | Primitive |
| Composition | Single operation | Decomposed into transp + hcomp |
| Canonicity | Proved (Huber 2018) | Proved (Angiuli-Favonia-Harper 2018) |
| Implementation | cubicaltt, Cubical Agda | redtt, cooltt |

Evan Cavallo and collaborators (CSL 2020) showed that both approaches can be unified as special cases of a general framework parameterized by the choice of cube category structure.

### 9.8 Cubical Agda

**Cubical Agda** (Vezzosi, Mortberg, Abel; ICFP 2019) extends the Agda proof assistant with cubical primitives based on a variant of CCHM cubical type theory. It is currently the most mature and widely used implementation of cubical type theory.

Key features:
- The interval `I` with De Morgan algebra operations (`_/\_`, `_\/_`, `~_`)
- Heterogeneous path types `PathP : (A : I -> Type l) -> A i0 -> A i1 -> Type l`
- Homogeneous paths as a special case: `Path A a b = PathP (\_ -> A) a b`
- Primitives `transp` and `hcomp`
- Glue types for univalence
- Higher inductive types as data types with path constructors:
  ```agda
  data S^1 : Set where
    base : S^1
    loop : base ≡ base
  ```
- Pattern matching on path constructors gives definitional computation rules
- The `--cubical` flag activates cubical mode
- The `--safe` flag can be used with `--cubical` for trusted proofs

The `agda/cubical` library provides a large formalized mathematics library built on Cubical Agda, including synthetic homotopy theory, algebra, and the formalization of `pi_4(S^3) = Z/2Z`.

---

## 10. Relationship to the Calculus of Inductive Constructions (CIC)

CIC (the foundation of Coq/Rocq) and cubical type theory share a common ancestor in Martin-Lof type theory but differ in several ways:

**What stays the same:**
- Dependent function types (Pi types) and dependent pair types (Sigma types)
- Universe hierarchy (with cumulativity)
- Inductive types and their elimination principles
- The general structure of type checking and term elaboration

**What changes:**
- **Identity types**: CIC uses inductively defined identity types with the J eliminator. Cubical type theory replaces these with path types defined via the interval. The J eliminator is derivable from path types and transport but holds only with a propositional (not definitional) computation rule.
- **Universes**: In cubical type theory, universes are univalent by construction (via Glue types). In standard CIC, one must add univalence as an axiom (losing canonicity).
- **Pattern matching**: CIC + Equations uses dependent pattern matching which implicitly relies on Axiom K. Cubical Agda uses pattern matching without K.
- **Proof irrelevance**: CIC has a separate impredicative `Prop` universe. In HoTT/cubical type theory, mere propositions are defined as types with at most one element up to paths, without a separate universe.
- **HITs**: Standard CIC does not have built-in higher inductive types (though they can be partially simulated). Cubical type theory has native support.

---

## 11. Axiom K vs. Univalence: The Fundamental Incompatibility

### 11.1 Axiom K (Streicher's Axiom)

Axiom K states that any proof of self-identity is equal to reflexivity:
```
K : (A : Type) -> (a : A) -> (p : a = a) -> p = refl
```

Equivalently, this is the **uniqueness of identity proofs** (UIP) principle: for any `a, b : A` and `p, q : a = b`, we have `p = q`.

Axiom K implies that all types are h-sets (0-types): identity types carry no interesting higher structure.

### 11.2 Why K and Univalence are Incompatible

Consider the universe `U` and the type `Bool : U`. The function `not : Bool -> Bool` (negation) is an equivalence, and `not ≠ id`. By univalence:
```
ua(not) : Bool =_U Bool
```
This gives a non-trivial self-identity of `Bool` in the universe. But Axiom K for the universe would require `ua(not) = refl`, which would imply `not = id` (by transporting), a contradiction.

More generally, any type with a non-trivial automorphism (a self-equivalence distinct from the identity) witnesses a failure of K at the universe level. Univalence provides many such automorphisms.

### 11.3 Pattern Matching Without K

Standard dependent pattern matching (as in Agda without `--without-K` or in standard Coq/Rocq) implicitly uses Axiom K when matching on `refl`: it assumes the matched proof is the *only* proof of that identity. The `--without-K` flag in Agda restricts pattern matching to avoid this assumption, making it compatible with univalence. Jesper Cockx's work "Pattern Matching Without K" (2014) provides the theoretical basis for this restriction.

---

## 12. Observational Type Theory as a Precursor

Thorsten Altenkirch, Conor McBride, and Wouter Swierstra's "Observational Equality, Now!" (PLPV 2007) proposed a type theory where equality reflects observable behavior rather than syntactic construction. Key features:

- **Extensional equality**: Functions are equal if they produce equal outputs on equal inputs (function extensionality is built in).
- **Proof irrelevance for propositions**: Proofs of propositions are considered equal.
- **Canonicity preserved**: Unlike adding extensionality axioms, OTT retains strong normalization, decidable type checking, and canonicity.
- **Substitutivity**: The equality type supports reasoning by replacing equals for equals.

OTT anticipated several themes of HoTT:
- The idea that equality should be defined by observable behavior (cf. univalence: types are equal if equivalent)
- The distinction between propositions (proof-irrelevant) and general types (proof-relevant)
- The goal of achieving extensionality principles without sacrificing computation

However, OTT works at the set level (all types are h-sets) and does not capture higher-dimensional structure. It can be seen as a 0-truncated precursor to cubical type theory: both solve the extensionality problem computationally, but cubical type theory does so for the full higher-dimensional setting.

More recent work by Altenkirch, McBride, and others on "Observational Equality, Now for Good" extends observational ideas to handle higher structure, moving toward a convergence with cubical approaches.

---

## 13. Proof-Relevant Mathematics and Its Implications

### 13.1 The Shift from Proof Irrelevance to Proof Relevance

In classical mathematics and in extensional type theory, proofs of propositions are interchangeable -- it does not matter *which* proof you have, only *that* you have one. HoTT introduces a graduated notion of proof relevance:

- **Mere propositions** (-1-types): Proof-irrelevant. Any two proofs are equal. These correspond to the traditional notion of "proposition."
- **Sets** (0-types): Equality proofs are irrelevant (UIP holds within the type), but the inhabitants themselves are distinguishable. This is the world of "ordinary" mathematics.
- **Groupoids** (1-types) and higher: Equality proofs carry meaningful structure. Different proofs of `a = b` represent genuinely different identifications.

### 13.2 Implications

**For algebra**: In univalent foundations, the "automorphism group" of a type is literally the loop space of the universe at that type. Group theory becomes part of homotopy theory.

**For category theory**: Categories must be formulated as types where the type of objects is a 1-type (a "univalent category" or "saturated category"), ensuring that isomorphic objects are identical. This eliminates the "evil" of distinguishing isomorphic objects.

**For constructive mathematics**: Propositional truncation allows the careful distinction between "there exists" (truncated, proof-irrelevant) and the stronger "we can construct" (untruncated, proof-relevant). This is more expressive than both classical and traditional constructive approaches.

**For formalization**: The structure identity principle means that proofs about one representation of a mathematical structure automatically transfer to any equivalent representation. This dramatically reduces the "formalization overhead" of translating between different but equivalent definitions.

---

## 14. Key References

### Books and Surveys

1. The Univalent Foundations Program. *Homotopy Type Theory: Univalent Foundations of Mathematics*. Institute for Advanced Study, 2013. Available at https://homotopytypetheory.org/book/

2. Emily Riehl. *An Introduction to Homotopy Type Theory & Univalent Foundations*. Available at https://emilyriehl.github.io/files/Intro-HoTT-UF.pdf

3. Egbert Rijke. *Introduction to Homotopy Type Theory*. Cambridge University Press (forthcoming/recent). Chapters on contractible types, propositions, sets, truncation levels.

### Foundational Papers

4. Martin Hofmann and Thomas Streicher. "The groupoid interpretation of type theory." In *Twenty-five years of constructive type theory* (Venice, 1995), Oxford Logic Guides, vol. 36, Oxford University Press, 1998, pp. 83-111.

5. Steve Awodey and Michael Warren. "Homotopy theoretic models of identity types." *Mathematical Proceedings of the Cambridge Philosophical Society* 146(1), 2009, pp. 45-55. arXiv:0709.0248.

6. Vladimir Voevodsky. "The Origins and Motivations of Univalent Foundations." IAS, 2014. https://www.ias.edu/ideas/2014/voevodsky-origins

7. Peter LeFanu Lumsdaine. "Weak omega-categories from intensional type theory." *TLCA 2009*. Also: Benno van den Berg and Richard Garner. "Types are weak omega-groupoids." *Proceedings of the London Mathematical Society* 102(2), 2011, pp. 370-394.

### Cubical Type Theory

8. Cyril Cohen, Thierry Coquand, Simon Huber, and Anders Mortberg. "Cubical Type Theory: a constructive interpretation of the univalence axiom." *Journal of Automated Reasoning* 63, 2018. arXiv:1611.02108.

9. Carlo Angiuli, Guillaume Brunerie, Thierry Coquand, Kuen-Bang Hou (Favonia), Robert Harper, and Daniel R. Licata. "Syntax and Models of Cartesian Cubical Type Theory." *Mathematical Structures in Computer Science* 31(4), 2021.

10. Andrea Vezzosi, Anders Mortberg, and Andreas Abel. "Cubical Agda: a dependently typed programming language with univalence and higher inductive types." *Proceedings of the ACM on Programming Languages* 3(ICFP), 2019, Article 87.

11. Evan Cavallo, Anders Mortberg, and Andrew W Swan. "Unifying Cubical Models of Univalent Type Theory." *CSL 2020*.

### Synthetic Homotopy Theory

12. Daniel R. Licata and Michael Shulman. "Calculating the Fundamental Group of the Circle in Homotopy Type Theory." *LICS 2013*. arXiv:1301.3443.

13. Guillaume Brunerie. "On the homotopy groups of spheres in homotopy type theory." PhD thesis, Universite de Nice Sophia Antipolis, 2016. arXiv:1606.05916.

14. Axel Ljungstrom and Anders Mortberg. "Formalising pi_4(S^3) = Z/2Z and Computing a Brunerie Number in Cubical Agda." *LICS 2023*. arXiv:2302.00151.

### Related Work

15. Thorsten Altenkirch, Conor McBride, and Wouter Swierstra. "Observational Equality, Now!" *PLPV 2007*.

16. Jesper Cockx, Dominique Devriese, and Frank Piessens. "Pattern Matching Without K." *ICFP 2014*.

17. Simon Huber. "Canonicity for Cubical Type Theory." *Journal of Automated Reasoning* 63, 2019.

18. Carlo Angiuli, Kuen-Bang Hou (Favonia), and Robert Harper. "Cartesian Cubical Computational Type Theory: Constructive Reasoning with Paths and Equalities." *CSL 2018*.

19. Jonathan Sterling and Carlo Angiuli. "Normalization for Cubical Type Theory." *LICS 2021*. arXiv:2101.11479.

20. Dan Licata and Guillaume Brunerie. "A Cubical Approach to Synthetic Homotopy Theory." *LICS 2015*.

### Software and Libraries

21. Cubical Agda documentation: https://agda.readthedocs.io/en/latest/language/cubical.html
22. agda/cubical library: https://github.com/agda/cubical
23. cubicaltt (experimental): https://github.com/mortberg/cubicaltt
24. UniMath (Voevodsky's Coq library): https://github.com/UniMath/UniMath
25. HoTT/Coq library: https://github.com/HoTT/Coq-HoTT

---

## Cross-References

- **Doc 06 (Calculus of Constructions):** The Calculus of Constructions provides the foundational type theory that HoTT extends with univalence and higher inductive types.

- **Doc 07 (Calculus of Inductive Constructions):** CIC serves as the base system for most HoTT implementations, including the HoTT/Coq library and Voevodsky's UniMath.

- **Doc 11 (Dependent Pattern Matching):** Pattern matching without the K axiom is essential for HoTT, since K implies uniqueness of identity proofs, which is incompatible with univalence.

- **Doc 17 (Universe Polymorphism):** Universe hierarchies and universe polymorphism are critical in HoTT for formulating univalence at each universe level and for the construction of higher inductive types.
