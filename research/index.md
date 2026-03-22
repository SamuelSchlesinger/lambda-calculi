# Lambda Calculi Research Corpus

## Overview

This research corpus provides comprehensive coverage of the lambda calculus landscape, from the untyped foundations introduced by Alonzo Church in the 1930s through the modern Calculus of (Co-)Inductive Constructions that underlies contemporary proof assistants such as Coq/Rocq and Lean. The 17 summary documents, supported by over 80 primary source notes, span the full spectrum of typed lambda calculi: their syntax and semantics, their metatheory (normalization, confluence, consistency, decidability), their categorical models, and their practical implementation.

The corpus is organized around two complementary axes. The first axis traces the *vertical development* of type systems from simple types through polymorphism, type operators, dependent types, and inductive/coinductive constructions, following the structure of Barendregt's lambda cube and its extensions. The second axis explores *horizontal extensions* that enrich the core calculi with features demanded by programming practice and mathematical foundations: substructural resource tracking, subtyping and bounded quantification, recursive types, computational effects, universe polymorphism, and the homotopy-theoretic reinterpretation of identity types.

Together, these documents form a self-contained reference suitable for researchers, proof assistant developers, and students seeking a rigorous understanding of the theory, metatheory, and implementation of typed lambda calculi. Each summary document includes formal definitions, historical context, key references, and cross-references to related documents in the corpus.

---

## Document Map

### Foundations

These documents cover the bedrock systems on which all subsequent developments are built.

- **[01 -- Untyped Lambda Calculus](summaries/01-untyped-lambda-calculus.md)**
  Church's original calculus of function abstraction and application. Covers syntax, alpha/beta/eta equivalence, Church-Rosser theorem, reduction strategies, Church encodings, fixed-point combinators, and the equivalence with Turing machines.

- **[02 -- Simply Typed Lambda Calculus](summaries/02-simply-typed-lambda-calculus.md)**
  The foundational typed calculus (STLC / lambda-arrow). Covers Church-style and Curry-style typing, type safety (progress and preservation), strong normalization, the Curry-Howard correspondence with intuitionistic propositional logic, and the Curry-Howard-Lambek correspondence with cartesian closed categories.

### The Lambda Cube

These documents trace the path from simple types to the full Calculus of Constructions, following the three axes of Barendregt's lambda cube: polymorphism, type operators, and dependent types.

- **[03 -- System F](summaries/03-system-f.md)**
  The polymorphic lambda calculus (lambda-2). Covers Girard's and Reynolds' independent discovery, type abstraction and application, Church encodings of data types via impredicative quantification, strong normalization via reducibility candidates, parametricity, and the undecidability of type inference.

- **[04 -- System F-omega](summaries/04-system-f-omega.md)**
  The higher-order polymorphic lambda calculus. Covers the kind system, type-level lambda calculus, type operators as first-class entities, higher-kinded polymorphism, the PTS formulation, and practical relevance to Haskell/GHC Core and ML module systems.

- **[05 -- The Lambda Cube](summaries/05-lambda-cube.md)**
  Barendregt's systematic classification of eight typed lambda calculi along three orthogonal axes. Covers all eight vertices, the universal typing rules, Pure Type Systems (PTS) as a generalization, strong normalization for all cube systems, Girard's paradox, and the relationship between the cube and the broader PTS landscape.

- **[06 -- Calculus of Constructions](summaries/06-calculus-of-constructions.md)**
  The apex of the lambda cube (lambda-C / lambda-P-omega). Covers Coquand and Huet's original formulation, the unification of all three dependency axes, the impredicative sort Prop, higher-order intuitionistic predicate logic via Curry-Howard, and the system's role as the foundation of the Coq proof assistant.

### Inductive and Coinductive Extensions

These documents cover the extension of the Calculus of Constructions with primitive inductive and coinductive type definitions, and the high-level pattern matching mechanisms that make them usable in practice.

- **[07 -- Calculus of Inductive Constructions](summaries/07-calculus-of-inductive-constructions.md)**
  The type theory underlying Coq/Rocq and (in variant form) Lean. Covers primitive inductive types, the strict positivity condition, structural recursion and the guard condition, the Prop/Type distinction, universe hierarchies, dependent elimination, and the limitations of Church encodings that motivated primitive inductive types.

- **[08 -- Coinductive Constructions](summaries/08-coinductive-constructions.md)**
  Greatest fixed points and final coalgebras in type theory. Covers coinductive types (streams, infinite trees, processes), corecursion and the productivity/guardedness condition, bisimulation as a coinductive proof principle, Aczel's anti-foundation axiom, and implementations in Coq and Agda.

- **[11 -- Dependent Pattern Matching](summaries/11-dependent-pattern-matching.md)**
  The mechanism for defining functions by case analysis over indexed inductive families. Covers Coquand's innovation, unification of indices, dot patterns, the "with" abstraction and convoy pattern, case tree compilation, coverage checking, the Goguen-McBride-McKinna translation to eliminators, axiom K and pattern matching without K (HoTT compatibility), and copattern matching.

### Type System Extensions

These documents cover orthogonal extensions to the type-theoretic core that address resource management, type hierarchies, data abstraction, and universe stratification.

- **[13 -- Linear and Substructural Types](summaries/13-linear-and-substructural-types.md)**
  Type systems that control how values are used by restricting structural rules. Covers Girard's linear logic, the linear lambda calculus, affine/relevant/ordered type systems, the exponential modality (!), Benton's LNL adjunction, session types, quantitative type theory, and practical systems (Rust's ownership, Granule, Linear Haskell).

- **[14 -- Subtyping and Bounded Quantification](summaries/14-subtyping-and-bounded-quantification.md)**
  Subtype relations and their interaction with polymorphism. Covers structural subtyping for records and functions, the subsumption rule, System F-sub (F<:), bounded quantification, undecidability of F<: subtyping (Pierce 1992), coercive subtyping, and applications to object-oriented type systems.

- **[15 -- Recursive Types](summaries/15-recursive-types.md)**
  Fixed-point types and their metatheory. Covers iso-recursive vs. equi-recursive approaches, fold/unfold operations, the Amadio-Cardelli algorithm, Scott and Church encodings, Mendler-style recursion, the connection to domain theory, strict positivity, step-indexed logical relations, and practical use in OCaml, Haskell, TypeScript, and Rust.

- **[17 -- Universe Polymorphism](summaries/17-universe-polymorphism.md)**
  Parameterization of definitions over universe levels. Covers the Type-in-Type inconsistency (Girard's paradox), universe hierarchies, cumulativity, typical ambiguity, explicit vs. implicit polymorphism, constraint-based level inference, and the designs adopted by Coq, Lean, and Agda.

### Computational Extensions

- **[16 -- Effects and Monads](summaries/16-effects-and-monads.md)**
  Integrating computational effects into the lambda calculus. Covers Moggi's monadic metalanguage, Wadler's monads for functional programming, Levy's call-by-push-value, effect systems, algebraic effects and handlers, delimited continuations, and Dijkstra monads for verification.

### Modern Developments

- **[12 -- Homotopy Type Theory / Cubical Type Theory](summaries/12-homotopy-type-theory.md)**
  The homotopy-theoretic interpretation of type theory. Covers the Hofmann-Streicher groupoid model, Voevodsky's univalence axiom, higher inductive types, the n-type hierarchy (h-levels), cubical type theory (CCHM and cartesian variants), the cubical set model, and computational content of univalence.

### Cross-Cutting Concerns

These documents address themes that span multiple type systems rather than belonging to any single one.

- **[09 -- Implementation Techniques](summaries/09-implementation-techniques.md)**
  Practical algorithms for implementing type-theoretic lambda calculi. Covers variable representation (named, de Bruijn indices, locally nameless, HOAS/PHOAS), substitution strategies (explicit substitution, hereditary substitution), type checking and bidirectional typing, normalization (NbE, abstract machines), elaboration from surface to core language, and the elaboration zoo.

- **[10 -- Metatheory and Correctness](summaries/10-metatheory-and-correctness.md)**
  Theorems *about* type systems. Covers type safety (progress and preservation), strong normalization (Tait's method, Girard's reducibility candidates, logical relations), confluence, consistency, canonicity, decidability, logical relations for parametricity and representation independence, and semantic models (set-theoretic, domain-theoretic, categorical, realizability).

---

## Dependency Graph

The following diagram shows how the documents relate to one another. An arrow `A --> B` means that document B builds on or extends the concepts in document A.

```
                                    12 HoTT/Cubical
                                        ^
                                        |
                         07 CIC --------+--------> 08 Coinductive
                          ^  ^                          ^
                          |  |                          |
          06 CoC ---------+  +--- 11 Dep. Pattern      |
            ^                      Matching             |
            |                                           |
          05 Lambda Cube ---- (framework for 02-04, 06) |
          ^ ^ ^                                         |
         /  |  \                                        |
        /   |   \                                       |
  03 Sys F  |  04 Sys Fw                                |
       ^    |    ^                                      |
        \   |   /                                       |
         \  |  /                                        |
       02 STLC                                          |
            ^                                           |
            |                                           |
       01 Untyped                                       |
                                                        |
  ---- Orthogonal extensions (can be combined with any of the above) ----

  13 Linear/Substructural Types     (extends 02, relates to 03)
  14 Subtyping/Bounded Quant.       (extends 02, 03)
  15 Recursive Types                (extends 02, 03, relates to 07, 08)
  16 Effects and Monads             (extends 02, relates to 13)
  17 Universe Polymorphism          (extends 05, 06, 07)

  ---- Cross-cutting ----

  09 Implementation Techniques      (applies to all systems)
  10 Metatheory and Correctness     (applies to all systems)
```

### Detailed Dependencies

| Document | Depends on | Extended by |
|----------|-----------|-------------|
| 01 Untyped Lambda Calculus | -- | 02 |
| 02 Simply Typed Lambda Calculus | 01 | 03, 04, 05, 13, 14, 15, 16 |
| 03 System F | 02 | 04, 05, 14 |
| 04 System F-omega | 02, 03 | 05, 06 |
| 05 Lambda Cube | 02, 03, 04 | 06, 17 |
| 06 Calculus of Constructions | 05 | 07, 12 |
| 07 CIC | 06 | 08, 11, 12, 17 |
| 08 Coinductive Constructions | 07 | -- |
| 09 Implementation Techniques | 01--08 (all) | -- |
| 10 Metatheory and Correctness | 01--08 (all) | -- |
| 11 Dependent Pattern Matching | 06, 07 | -- |
| 12 HoTT / Cubical Type Theory | 06, 07 | -- |
| 13 Linear and Substructural Types | 02 | -- |
| 14 Subtyping and Bounded Quant. | 02, 03 | -- |
| 15 Recursive Types | 02, 03 | -- |
| 16 Effects and Monads | 02 | -- |
| 17 Universe Polymorphism | 05, 06, 07 | -- |

---

## Reading Paths

### "I want to understand the lambda cube"

A path through the core type systems, culminating in the full Calculus of Constructions.

1. [01 -- Untyped Lambda Calculus](summaries/01-untyped-lambda-calculus.md) -- the computational substrate
2. [02 -- Simply Typed Lambda Calculus](summaries/02-simply-typed-lambda-calculus.md) -- the base vertex (lambda-arrow)
3. [03 -- System F](summaries/03-system-f.md) -- adding polymorphism (terms depending on types)
4. [04 -- System F-omega](summaries/04-system-f-omega.md) -- adding type operators (types depending on types)
5. [05 -- The Lambda Cube](summaries/05-lambda-cube.md) -- the full framework, including dependent types and PTS
6. [06 -- Calculus of Constructions](summaries/06-calculus-of-constructions.md) -- the apex, combining all three axes

### "I want to implement a type checker"

A path focused on practical implementation of dependently typed languages.

1. [02 -- Simply Typed Lambda Calculus](summaries/02-simply-typed-lambda-calculus.md) -- basic typing rules and type checking
2. [03 -- System F](summaries/03-system-f.md) -- type inference challenges (undecidability), type application
3. [09 -- Implementation Techniques](summaries/09-implementation-techniques.md) -- variable representation, substitution, bidirectional typing, NbE, elaboration
4. [05 -- The Lambda Cube](summaries/05-lambda-cube.md) -- PTS as a unifying implementation target
5. [06 -- Calculus of Constructions](summaries/06-calculus-of-constructions.md) -- dependent type checking, conversion checking
6. [07 -- CIC](summaries/07-calculus-of-inductive-constructions.md) -- inductive types, positivity checking, guard condition
7. [11 -- Dependent Pattern Matching](summaries/11-dependent-pattern-matching.md) -- case tree compilation, unification of indices
8. [17 -- Universe Polymorphism](summaries/17-universe-polymorphism.md) -- universe level inference and constraint solving

### "I want to understand the metatheory"

A path through the key metatheoretic results and proof techniques.

1. [02 -- Simply Typed Lambda Calculus](summaries/02-simply-typed-lambda-calculus.md) -- type safety, strong normalization (Tait's method), Curry-Howard
2. [03 -- System F](summaries/03-system-f.md) -- reducibility candidates, parametricity, Reynolds' abstraction theorem
3. [10 -- Metatheory and Correctness](summaries/10-metatheory-and-correctness.md) -- comprehensive survey of proof techniques: logical relations, normalization, consistency, semantic models
4. [15 -- Recursive Types](summaries/15-recursive-types.md) -- step-indexed logical relations, domain equations, interaction with normalization
5. [07 -- CIC](summaries/07-calculus-of-inductive-constructions.md) -- strong normalization of CIC, the Prop/Type distinction, strict positivity
6. [08 -- Coinductive Constructions](summaries/08-coinductive-constructions.md) -- productivity, bisimulation, final coalgebras

### "I want to understand modern type theory developments"

A path through the frontier of type-theoretic research.

1. [06 -- Calculus of Constructions](summaries/06-calculus-of-constructions.md) -- the starting point for modern proof assistants
2. [07 -- CIC](summaries/07-calculus-of-inductive-constructions.md) -- the practical foundation (Coq, Lean)
3. [12 -- HoTT / Cubical Type Theory](summaries/12-homotopy-type-theory.md) -- univalence, higher inductive types, cubical models
4. [11 -- Dependent Pattern Matching](summaries/11-dependent-pattern-matching.md) -- pattern matching without K, HoTT compatibility
5. [17 -- Universe Polymorphism](summaries/17-universe-polymorphism.md) -- level polymorphism, first-class levels, cumulativity
6. [13 -- Linear and Substructural Types](summaries/13-linear-and-substructural-types.md) -- quantitative type theory, graded modalities
7. [16 -- Effects and Monads](summaries/16-effects-and-monads.md) -- algebraic effects, Dijkstra monads, effects in dependent type theory

---

## Primary Sources Index

The [primary-sources/](primary-sources/) directory contains detailed notes on individual papers, books, and technical reports cited throughout the summary documents. They are organized below by topic.

### Foundational Lambda Calculus

- `church-1932-1933-set-of-postulates.md` -- Church's original logical system
- `church-1936-unsolvable-problem.md` -- Undecidability of the Entscheidungsproblem
- `church-1940-simple-theory-of-types.md` -- Introduction of the simply typed lambda calculus
- `church-rosser-1936-consistency.md` -- The Church-Rosser confluence theorem
- `kleene-rosser-1935-paradox.md` -- The inconsistency result that motivated types
- `curry-howard-correspondence.md` -- The propositions-as-types correspondence
- `scott-1969-1970-domain-theory.md` -- Denotational semantics for lambda calculi
- `models-of-lambda-calculi-notes.md` -- Survey of semantic models
- `de-bruijn-representation.md` -- De Bruijn indices for variable binding
- `scott-encodings.md` -- Scott encodings of data types
- `domain-equations-scott.md` -- Recursive domain equations

### Polymorphism and System F

- `girard-1972-system-f-notes.md` -- Girard's original System F
- `reynolds-1974-polymorphic-lambda-calculus.md` -- Reynolds' independent discovery
- `reynolds-1983-parametricity.md` -- Relational parametricity
- `wadler-1989-theorems-for-free.md` -- Free theorems from parametricity
- `mitchell-plotkin-1988-existential-types.md` -- Abstract types have existential type
- `girard-reducibility-candidates-notes.md` -- Normalization via reducibility candidates
- `wells-1999-undecidability.md` -- Undecidability of System F type inference
- `system-f-omega-references.md` -- References for System F-omega

### The Lambda Cube and Pure Type Systems

- `barendregt-1991-intro-generalized-type-systems.md` -- The lambda cube paper
- `barendregt-lambda-calculi-with-types.md` -- Comprehensive Handbook chapter
- `barendregt-lambda-calculus-overview.md` -- Overview of Barendregt's framework
- `harper-honsell-plotkin-1993-lf.md` -- The Edinburgh Logical Framework (lambda-P)
- `paradoxes-and-consistency-notes.md` -- Girard's paradox and consistency

### Calculus of Constructions and CIC

- `coc-bibliography.md` -- Bibliography for the Calculus of Constructions
- `coquand-paulin-1990-inductively-defined-types.md` -- Inductive types in CoC
- `pfenning-paulin-mohring-1989-inductively-defined-types-in-cc.md` -- Early inductive types
- `paulin-mohring-1993-inductive-definitions-coq.md` -- Inductive definitions in Coq
- `werner-1994-thesis-inductive-constructions.md` -- Werner's thesis on CIC
- `dybjer-1994-inductive-families.md` -- Inductive families
- `mendler-1987-inductive-types.md` -- Mendler-style inductive types

### Coinductive Types

- `gimenez-1995-guarded-definitions.md` -- Guarded corecursive definitions
- `coinductive-types-nlab.md` -- nLab reference on coinductive types
- `coq-coinductive-types.md` -- Coinductive types in Coq
- `agda-coinduction.md` -- Coinduction in Agda
- `terminal-coalgebras-nlab.md` -- Terminal coalgebras
- `non-well-founded-sets-sep.md` -- Aczel's non-well-founded sets

### Dependent Pattern Matching

- `coquand-1992-pattern-matching-dependent-types.md` -- The foundational paper
- `mcbride-2000-elimination-with-a-motive.md` -- Eliminators and pattern matching
- `mcbride-mckinna-2004-view-from-the-left.md` -- The "with" construct and views
- `goguen-mcbride-mckinna-2006-eliminating-dependent-pm.md` -- Translation to eliminators
- `cockx-devriese-piessens-2014-pattern-matching-without-K.md` -- Pattern matching without K
- `cockx-2018-proof-relevant-unification.md` -- Proof-relevant unification
- `cockx-abel-2018-elaborating-dependent-copattern-matching.md` -- Copattern matching elaboration
- `sozeau-2010-equations-coq.md` -- The Equations plugin for Coq

### Homotopy Type Theory

- `hott-key-references.md` -- Key references for HoTT
- `favonia-angiuli-mullanix-2023-order-theoretic-analysis.md` -- Order-theoretic analysis

### Linear and Substructural Types

- `girard-linear-logic-1987.md` -- Girard's linear logic
- `wadler-linear-types-1990.md` -- Linear types in practice
- `barber-plotkin-dill-1996.md` -- DILL (Dual Intuitionistic Linear Logic)
- `benton-lnl-1994.md` -- Benton's Linear/Non-Linear adjunction
- `atkey-qtt-2018.md` -- Quantitative Type Theory
- `mcbride-plenty-2016.md` -- McBride's "I Got Plenty o' Nuttin'"
- `session-types-and-linear-logic.md` -- Session types
- `practical-linear-types.md` -- Practical linear type systems
- `granule-graded-modal-types.md` -- The Granule language

### Subtyping and Bounded Quantification

- `pierce-subtyping-bibliography.md` -- Bibliography for subtyping
- `amadio-cardelli-1993-subtyping-recursive-types.md` -- Subtyping recursive types
- `brandt-henglein-1998-coinductive-recursive-subtyping.md` -- Coinductive subtyping
- `categorical-models-subtyping-coraglia.md` -- Categorical models
- `luo-coercive-subtyping-publications.md` -- Coercive subtyping

### Recursive Types

- `ahmed-2006-step-indexed-logical-relations.md` -- Step-indexed logical relations

### Effects and Monads

- `moggi-1989-computational-lambda-calculus.md` -- Moggi's computational lambda calculus
- `moggi-1991-notions-of-computation.md` -- Notions of computation and monads
- `wadler-1992-1995-monads.md` -- Monads for functional programming
- `levy-2003-call-by-push-value.md` -- Call-by-push-value
- `plotkin-power-pretnar-algebraic-effects.md` -- Algebraic effects and handlers
- `effect-systems-gifford-lucassen.md` -- Effect systems
- `delimited-continuations.md` -- Delimited continuations
- `dijkstra-monads-fstar.md` -- Dijkstra monads in F*
- `languages-with-algebraic-effects.md` -- Survey of languages with algebraic effects

### Universe Polymorphism

- `harper-pollack-1991-type-checking-universes.md` -- Type checking with universes
- `sozeau-tabareau-2014-universe-polymorphism-coq.md` -- Universe polymorphism in Coq
- `timany-sozeau-2018-cumulative-inductive-types.md` -- Cumulative inductive types
- `gratzer-sterling-birkedal-2022-explicit-universe-polymorphism.md` -- Explicit universe polymorphism
- `chan-weirich-2025-bounded-first-class-levels.md` -- First-class universe levels

### Metatheory and Proof Techniques

- `tait-1967-strong-normalization-notes.md` -- Tait's reducibility method
- `strong-normalization-logical-relations.md` -- Logical relations for normalization
- `logical-relations-notes.md` -- General logical relations
- `wright-felleisen-1994-notes.md` -- Syntactic type safety
- `type-safety-progress-preservation.md` -- Progress and preservation

### Implementation

- `elaboration-zoo-kovacs.md` -- Kovacs' elaboration zoo
- `bauer-how-to-implement-dtt.md` -- How to implement dependent type theory
- `nbe-christiansen-tutorial.md` -- Normalization by evaluation tutorial
- `nbe-four-ways-bowman.md` -- Four approaches to NbE
- `debruijn-plfa-intrinsic.md` -- Intrinsically typed de Bruijn representation
- `phoas-fstar-tutorial.md` -- PHOAS in F*

---

## Review History

Each summary document in this corpus has undergone multiple rounds of author-review-revise cycles to ensure quality across four dimensions:

- **Accuracy review**: Verification of formal definitions, typing rules, reduction rules, and stated theorems against the primary sources.
- **Completeness review**: Assessment of coverage breadth and depth, identification of missing topics or underexplored areas within each document's scope.
- **Implementation review**: Evaluation of the practical relevance and correctness of implementation-oriented material, including algorithms, data structures, and code-level descriptions.
- **Coherence review**: Examination of cross-document consistency in notation, terminology, and cross-references, ensuring the corpus functions as a unified whole rather than isolated summaries.

Review notes are archived in the [reviews/](reviews/) directory.
