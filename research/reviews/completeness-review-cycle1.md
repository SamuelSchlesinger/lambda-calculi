# Completeness Review -- Cycle 1

**Reviewer:** Completeness Reviewer
**Date:** 2026-03-22
**Scope:** All 10 summary documents in `/research/summaries/`

---

## Summary Assessment

The 10 documents provide thorough coverage of a progression from the untyped lambda calculus through the Calculus of Inductive Constructions, with strong supporting documents on coinductive types, implementation techniques, and metatheory. The core "lambda cube" path is well-developed. However, several important topics in the modern lambda calculus and type theory landscape are absent or significantly underexplored. This review is organized by priority.

---

## CRITICAL GAPS

### 1. Dependent Pattern Matching and the Elaboration of Case Expressions

**What is missing:** None of the documents give a dedicated treatment of *dependent pattern matching* -- its theory, its relationship to eliminators, and the subtleties of unification of indices, the "with" abstraction, and the convoy pattern. Document 07 (CIC) mentions `match` expressions and generated eliminators but does not address:

- Coquand's 1992 paper "Pattern Matching with Dependent Types"
- McBride's work on elimination with a motive
- The compilation of nested dependent pattern matching into case trees
- The Goguen-McBride-McKinna algorithm for coverage and unification
- Dot patterns (forced/inaccessible patterns)
- The distinction between Agda-style dependent pattern matching (axiom K) and K-free pattern matching (as needed for HoTT)

**Why it matters:** Dependent pattern matching is the primary user-facing mechanism for defining functions and proofs in Lean, Agda, and Coq. Without understanding it, one cannot bridge the gap between the theoretical CIC and practical proof development. This is also critical for formalization work in Lean 4.

### 2. Homotopy Type Theory (HoTT) and Univalence

**What is missing:** The documents contain only passing references to HoTT (document 10 mentions cubical type theory canonicity in section 6.4; document 07 mentions cubical/HIT in the Agda comparison table). There is no treatment of:

- The univalence axiom and its motivation
- Identity types and their higher structure (path types, higher groupoid structure)
- The distinction between UIP (uniqueness of identity proofs) and proof-relevant identity
- The Hofmann-Streicher groupoid model (mentioned briefly in doc 10)
- Higher inductive types (HITs) -- circles, pushouts, truncations
- Cubical type theory (Cohen-Coquand-Huber-Mortberg) as a computational interpretation of univalence
- The connection between CIC and HoTT
- Synthetic homotopy theory

**Why it matters:** HoTT represents one of the most significant developments in type theory in the last 15 years. It directly relates to the type theories underlying Agda (cubical mode) and is increasingly relevant to formalization. The Univalent Foundations Program book (2013) is a landmark reference that the corpus should engage with.

### 3. Universe Polymorphism -- Detailed Treatment

**What is missing:** Document 06 (CoC) mentions universe polymorphism briefly in section 13.3 (citing Sozeau-Tabareau 2014), and document 07 (CIC) mentions it in section 12.3. But there is no thorough treatment of:

- The formal definition of universe-polymorphic type theories
- Universe level variables, constraints, and their solving
- Cumulativity vs. lifting (Coq vs. Agda vs. Lean approaches)
- The McBride-style "typical ambiguity" vs. explicit universe polymorphism
- The interaction of universe polymorphism with inductive types
- Agda's universe levels and `Level` type
- Lean's explicit universe level arithmetic
- The Russell vs. Tarski style universes debate

**Why it matters:** Universe polymorphism is fundamental to practical proof assistants. It is the mechanism that prevents code duplication and enables large-scale libraries (Mathlib, etc.). A thorough treatment is needed for anyone implementing or formalizing a dependently typed language.

---

## SIGNIFICANT GAPS

### 4. Eta-Expansion and Eta-Long (Beta-Eta Normal) Forms

**What is missing:** Eta reduction is mentioned in documents 01, 03, 06, and 08, but there is no systematic treatment of:

- Beta-eta normal forms (long normal forms) vs. beta normal forms
- The role of eta-expansion in bidirectional type checking and NbE
- Eta for product types, unit types, sum types (positive eta laws)
- Extensionality principles and their computational content
- The distinction between definitional (judgmental) eta and propositional eta
- Function extensionality as an axiom vs. a rule

**Why it matters:** Eta rules are central to NbE implementations and definitional equality in modern proof assistants. The choice of which eta rules to include has significant consequences for decidability and implementation complexity.

### 5. Subtyping and Bounded Quantification

**What is missing:** Subtyping is not treated in any document. The following topics are absent:

- System F-sub (F<:) -- bounded quantification (Cardelli and Wegner)
- Kernel F-sub vs. full F-sub and the decidability question
- Subtyping in the presence of dependent types
- Coercive subtyping (as in Luo's work)
- The POPLmark challenge, which is specifically about F<: (mentioned in doc 10 but the system itself is not presented)
- Universe cumulativity as a form of subtyping (mentioned but not formalized)
- Row polymorphism as an alternative to subtyping
- Variance (covariance, contravariance) in type constructors

**Why it matters:** Subtyping is fundamental to object-oriented programming foundations and appears in the universe cumulativity of Coq/Lean. System F<: is one of the most studied systems in PL theory.

### 6. Linear and Affine Type Systems

**What is missing:** Document 02 (STLC) briefly mentions linear, affine, relevant, and ordered types in section 6.5 (a single table). There is no treatment of:

- Linear lambda calculus and its relationship to linear logic (Girard 1987)
- The linear logic propositions-as-types correspondence
- Intuitionistic linear type theory
- Quantitative type theory (QTT, Atkey 2018; McBride 2016)
- Graded modalities and resource tracking
- Practical applications: Rust's ownership/borrowing as affine types, session types
- Linear types in Haskell (LinearTypes extension)
- The connection between linearity and evaluation strategies

**Why it matters:** Linear/substructural type systems represent a major branch of type theory research. Quantitative type theory is increasingly relevant to proof assistants (Idris 2 is based on QTT). Rust's type system has brought affine types into mainstream programming.

### 7. Recursive Types (Equi-recursive and Iso-recursive)

**What is missing:** Recursive types are mentioned tangentially (document 04 mentions System Fmu-omega; document 07 covers inductive types). But there is no treatment of:

- Mu types (iso-recursive vs. equi-recursive)
- The fold/unfold approach to iso-recursive types
- Type-level fixed points and their metatheory
- Recursive types in System F (encoding vs. primitive)
- The relationship between recursive types and inductive types
- Step-indexed logical relations for recursive types (Ahmed 2006)

**Why it matters:** Recursive types are fundamental to programming language theory and are the basis for understanding general recursive data structures outside of the inductive types framework.

### 8. Intersection and Union Types

**What is missing:** Document 03 (System F) has a brief section (13) on intersection types. There is no treatment of:

- The Coppo-Dezani-Salle system
- Intersection types as characterizing strong normalization
- The BCD type system (subtyping + intersection types)
- Union types (dually)
- Refinement types and their relationship to intersections
- Modern uses in TypeScript, Flow, Scala

**Why it matters:** Intersection types provide an alternative characterization of normalization properties and have become practically important in mainstream languages.

---

## MODERATE GAPS

### 9. Effect Systems and Monadic Effects

**What is missing:** No document discusses how effects are handled in typed lambda calculi:

- Moggi's computational lambda calculus and monads (1989, 1991)
- Algebraic effects and handlers (Plotkin and Power, Pretnar)
- Effect systems (Gifford and Lucassen, Nielson and Nielson)
- The IO monad as used in Haskell
- The relationship between effects and evaluation strategy
- Levy's call-by-push-value (CBPV)

**Why it matters:** Effects are central to using lambda calculi as foundations for real programming languages. Moggi's monadic metalanguage is one of the most influential ideas in PL theory.

### 10. Gradual Typing

**What is missing:** No mention of gradual typing appears in any document:

- Siek and Taha's original gradual typing (2006)
- The dynamic type and casts
- Blame calculus (Wadler and Findler)
- The gradual guarantee
- Gradual dependent types (work by Eremondi, Tanter, et al.)

**Why it matters:** Gradual typing bridges untyped and typed settings, which is directly relevant to the progression from document 01 (untyped) to document 02 (STLC).

### 11. Observational Type Theory and Setoid Models

**What is missing:** No discussion of:

- Observational Type Theory (Altenkirch, McBride, Swierstra 2007)
- Setoid models and their role in interpreting type theory
- The difference between propositional and definitional equality in practice
- Extensional type theory and its relationship to intensional type theory
- NuPRL's approach (computational type theory with extensional equality)

**Why it matters:** These topics address the fundamental question of what equality means in type theory, which is essential context for understanding the design choices in Coq, Lean, and Agda.

### 12. Quotient Types

**What is missing:** Document 07 (CIC) mentions that Lean has primitive quotient types, but there is no treatment of:

- The theory of quotient types and their formation/elimination rules
- Quotient inductive types
- The relationship between quotients and setoids
- Higher quotient types (HITs)
- Implementation approaches (Lean's `Quot` type)

**Why it matters:** Quotient types are primitives in Lean's kernel and are essential for practical mathematics formalization.

### 13. Induction-Recursion and Induction-Induction

**What is missing:** Document 07 mentions Dybjer-Setzer induction-recursion in one sentence (section 18.3) but provides no detail:

- The formal definition of induction-recursion
- Induction-induction (Forsberg and Setzer)
- Their proof-theoretic strength
- How they extend beyond CIC's inductive types
- Practical examples (e.g., defining universes, well-typed syntax)

**Why it matters:** Induction-recursion is a key feature of Agda that goes beyond what CIC natively supports. It is important for understanding the landscape of type-theoretic frameworks.

---

## SHALLOW COVERAGE (Topics Present but Underdeveloped)

### 14. Program Extraction / Code Extraction

Documents 06 and 07 mention extraction briefly. A fuller treatment should cover:
- The extraction mechanism in Coq (Letouzey's work)
- The Prop/Type distinction and its role in extraction
- Lean's approach (compilation rather than extraction)
- Verified extraction (MetaCoq)

### 15. Sized Types

Document 08 covers sized types for coinductive types (section 9) but does not discuss:
- Sized types for inductive types (termination checking)
- Known soundness issues with sized types in Agda (the `--sized-types` flag was marked unsafe)
- The formal metatheory of sized types with dependent types

### 16. Proof Irrelevance and Squash Types

Document 06 discusses proof irrelevance (section 12). Missing:
- SProp in Coq (strict proof irrelevance)
- The relationship to truncation levels in HoTT (mere propositions)
- Gilbert et al.'s work on definitional proof irrelevance

### 17. Categorical Semantics of Dependent Types

The categorical semantics sections in documents 04, 06, and 10 could be expanded:
- Categories with families (CwFs) -- mentioned but not formalized
- Comprehension categories
- Natural models (Awodey)
- The coherence problem for substitution (mentioned briefly in doc 10)
- Fibered/indexed categories and their role

---

## MISSING CROSS-REFERENCES

1. **Doc 01 (Untyped) to Doc 09 (Implementation):** The untyped document discusses reduction strategies and normal forms extensively, but does not point to the implementation document's treatment of abstract machines (SECD, Krivine, CEK), which provide operational realizations of these strategies.

2. **Doc 03 (System F) to Doc 09 (Implementation):** System F's type inference undecidability (Wells 1999) should cross-reference the practical workarounds discussed in doc 09 (bidirectional checking, constraint-based approaches).

3. **Doc 06 (CoC) to Doc 07 (CIC):** The limitation section in doc 06 (section 9) motivates CIC but could more explicitly connect to doc 07's solutions.

4. **Doc 07 (CIC) to Doc 08 (Coinductive):** The CIC document mentions coinductive types briefly (section 19 comparison table) but does not cross-reference doc 08 for details.

5. **Doc 05 (Lambda Cube) to all others:** The lambda cube document is the natural hub connecting all typed systems but lacks explicit forward references to documents 06, 07, and 08.

6. **Doc 10 (Metatheory) to Docs 01-08:** The metatheory document proves results *about* the systems described in the other documents but rarely gives explicit cross-references.

---

## MISSING EXAMPLES

1. **Doc 04 (System F-omega):** Could benefit from a worked example showing how Haskell's type class mechanism (e.g., `Functor`) maps to System F-omega abstractions.

2. **Doc 05 (Lambda Cube):** The less-studied vertices (lambda-P-omega, lambda-P2) lack concrete examples. Even simple examples would help readers understand what these systems can and cannot express.

3. **Doc 06 (CoC):** The section on large eliminations (8.2) gives a one-line example. More substantive examples of dependent elimination would be valuable.

4. **Doc 07 (CIC):** Missing a worked example of a non-trivial induction proof using the generated eliminator, showing the match/fix desugaring.

5. **Doc 10 (Metatheory):** The logical relations sections could benefit from a complete worked strong normalization proof for a small system.

---

## MISSING REFERENCES

### Seminal Papers Not Cited Anywhere

1. **Moggi, E.** "Notions of Computation and Monads." *Information and Computation*, 93(1):55-92, 1991. (Monadic metalanguage for effects)

2. **Altenkirch, T., McBride, C., and Swierstra, W.** "Observational Equality, Now!" *PLPV 2007*. (Observational type theory)

3. **Siek, J. and Taha, W.** "Gradual Typing for Functional Languages." *Scheme and Functional Programming Workshop, 2006*. (Gradual typing)

4. **Atkey, R.** "Syntax and Semantics of Quantitative Type Theory." *LICS 2018*. (Quantitative type theory)

5. **McBride, C.** "Elimination with a Motive." *TYPES 2000*. (Dependent pattern matching)

6. **Goguen, H., McBride, C., and McKinna, J.** "Eliminating Dependent Pattern Matching." *Algebra, Meaning and Computation, 2006*. (Compilation of dependent pattern matching)

7. **The Univalent Foundations Program.** *Homotopy Type Theory: Univalent Foundations of Mathematics.* IAS, 2013. (HoTT Book)

8. **Cohen, C., Coquand, T., Huber, S., and Mortberg, A.** "Cubical Type Theory: A Constructive Interpretation of the Univalence Axiom." *TYPES 2015 / JFP 2018*. (Cubical type theory)

9. **Levy, P. B.** *Call-By-Push-Value: A Functional/Imperative Synthesis.* Springer, 2003. (CBPV)

10. **Luo, Z.** *Computation and Reasoning: A Type Theory for Computer Science.* Oxford, 1994. (ECC/UTT)

---

## TOPICS THAT DESERVE THEIR OWN DOCUMENTS

The following subjects are substantial enough to warrant separate summary documents rather than subsections:

1. **Dependent Pattern Matching** (currently absent; could draw from CIC, Agda, and Lean perspectives). This is arguably the most important missing standalone topic.

2. **Homotopy Type Theory and Cubical Type Theory** (currently absent; significant enough for its own document covering univalence, HITs, cubical models, and the computational interpretation).

3. **Linear and Substructural Type Systems** (currently a single table in doc 02; deserves full treatment covering linear logic correspondence, resource management, quantitative type theory).

4. **Subtyping and Bounded Quantification** (currently absent; System F<: and its variants form a major branch of PL theory with direct practical relevance).

---

## OVERALL RECOMMENDATIONS

**Priority 1 (should be addressed before the corpus can be considered comprehensive):**
- Add coverage of dependent pattern matching (either in doc 07 or as a new document)
- Add a document or major section on HoTT/cubical type theory
- Expand universe polymorphism treatment

**Priority 2 (significant omissions that should be filled):**
- Add coverage of subtyping (System F<:)
- Add coverage of linear/substructural types
- Add coverage of recursive types
- Add cross-references between documents

**Priority 3 (desirable for completeness):**
- Add coverage of effects/monads
- Add coverage of quotient types
- Expand categorical semantics of dependent types
- Add more worked examples throughout
