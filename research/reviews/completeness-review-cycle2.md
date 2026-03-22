# Completeness Review -- Cycle 2

**Reviewer:** Completeness Reviewer
**Date:** 2026-03-22
**Scope:** All 17 summary documents in `/research/summaries/`
**Previous review:** Cycle 1 completeness review (10 documents)

---

## Executive Summary

Cycle 1 identified 3 critical gaps, 5 significant gaps, and 5 moderate gaps. In Cycle 2, seven new documents (11--17) were added, directly targeting the highest-priority items. The critical gaps have been thoroughly addressed. The significant gaps have been substantially addressed. Several moderate gaps from Cycle 1 remain partially or wholly unaddressed. Cross-referencing between old and new documents is inadequate. A small number of new gaps have been introduced by the new documents. Overall, the corpus is now comprehensive for its core mission; the remaining gaps are "nice-to-haves" rather than critical omissions.

---

## 1. Assessment of Critical Gaps from Cycle 1

### 1.1 Dependent Pattern Matching -- FULLY ADDRESSED

**Cycle 1 flagged:** No treatment of Coquand (1992), elimination with a motive, case tree compilation, Goguen-McBride-McKinna, dot patterns, axiom K interaction, K-free pattern matching.

**Doc 11 covers:** All of these topics in depth. The document includes:
- Historical context from eliminators to Coquand's 1992 pattern matching (Section 1)
- Formal typing rules for clausal definitions and case trees (Section 2)
- Unification of indices with a table distinguishing K-dependent and K-free rules (Section 3)
- Dot/inaccessible patterns with examples (Section 4)
- The "with" abstraction and convoy pattern (Section 5)
- Case tree compilation algorithm with first-match semantics (Section 6)
- Coverage checking (Section 7)
- The Goguen-McBride-McKinna algorithm and its translation (Section 8)
- Axiom K: statement, necessity, Hofmann-Streicher groupoid model, compatibility (Section 9)
- K-free pattern matching: Cockx-Devriese-Piessens criterion, proof-relevant unification (Section 10)
- Practical treatment in Agda, Coq/Equations, Lean, and Idris (Section 12)
- Copattern matching (Section 14.1)
- 15 key references including all seminal papers

**Verdict:** Excellent. This gap is closed.

### 1.2 Homotopy Type Theory (HoTT) and Cubical Type Theory -- FULLY ADDRESSED

**Cycle 1 flagged:** No treatment of univalence, identity types' higher structure, UIP vs. proof-relevant identity, Hofmann-Streicher, HITs, cubical type theory, synthetic homotopy theory.

**Doc 12 covers:** All of these topics comprehensively. The document includes:
- Historical context: Hofmann-Streicher groupoid model, Awodey-Warren, Voevodsky (Section 1)
- Identity types in MLTT: formation, introduction, elimination (J), transport (Section 2)
- Groupoid and higher groupoid structure of types; types as weak infinity-groupoids (Section 3)
- Univalence axiom: statement, motivation, consequences including function extensionality (Section 4)
- n-Types, truncation hierarchy, propositional truncation (Section 5)
- Higher inductive types: circle, spheres, suspensions, pushouts, set quotients (Section 6)
- Synthetic homotopy theory: pi_1(S^1) = Z, Brunerie number, Hopf fibration (Section 7)
- Canonicity problem and its resolution (Section 8)
- Cubical type theory: CCHM (De Morgan) and Cartesian variants, Glue types, computational univalence (Section 9)
- Cubical Agda implementation (Section 9.8)
- Relationship to CIC (Section 10)
- K vs. univalence incompatibility (Section 11)
- Observational Type Theory as precursor (Section 12)
- Proof-relevant mathematics implications (Section 13)
- 25 references including the HoTT Book, CCHM, ABCFHL, Cubical Agda

**Verdict:** Excellent. This gap is closed. The coverage of OTT (Section 12) also partially addresses Cycle 1 moderate gap #11 (Observational Type Theory).

### 1.3 Universe Polymorphism -- FULLY ADDRESSED

**Cycle 1 flagged:** No thorough treatment of formal definitions, level variables and constraints, cumulativity vs. lifting, typical ambiguity vs. explicit polymorphism, interaction with inductive types, Agda/Lean/Coq approaches, Russell vs. Tarski universes.

**Doc 17 covers:** All of these topics in depth. The document includes:
- Historical context: Girard's paradox, Hurkens simplification, typical ambiguity (Section 1)
- Why universes are necessary; predicativity (Section 2)
- Russell-style vs. Tarski-style universes with formal rules (Section 3)
- Universe hierarchies: basic hierarchy, Prop, Coq's Prop/Set/Type, Lean's Prop/Type, Agda's Set hierarchy (Section 4)
- Universe cumulativity: subtyping-based, lifting-based, cumulative inductive types with variance (Section 5)
- Taxonomy of approaches: typical ambiguity through first-class levels (Section 6)
- Practical implementations in Coq, Agda, and Lean 4 with concrete syntax examples (Section 7)
- Level expressions, constraints, constraint solving, level unification (Section 8)
- Interactions with inductive types, module systems, elaboration (Section 9)
- Advanced topics: Palmgren's constructions, McBride's crude stratification, Setomega, sort polymorphism (Section 10)
- Consistency and metatheory (Section 11)
- Comparison table of design choices across proof assistants (Section 12)
- 21 references

**Verdict:** Excellent. This gap is closed.

---

## 2. Assessment of Significant Gaps from Cycle 1

### 2.1 Subtyping and Bounded Quantification -- FULLY ADDRESSED

**Cycle 1 flagged:** No treatment of System F<:, Kernel vs. Full F<:, decidability, coercive subtyping, universe cumulativity as subtyping, row polymorphism, variance.

**Doc 14 covers:** All of these topics. The document includes:
- Historical context: Reynolds, Cardelli, Liskov substitution (Section: Historical Context)
- Record subtyping (width, depth, permutation), function subtyping (Section: Simple Subtyping)
- Covariance and contravariance in type constructors (Section: Covariance and Contravariance)
- Top and bottom types (Section: Top and Bottom Types)
- Algorithmic subtyping, minimal typing, bidirectional checking (Section: Algorithmic Subtyping)
- System F<: syntax, subtyping rules, typing rules (Section: System F<:)
- Kernel F<: (decidable) vs. Full F<: (undecidable) with Pierce's undecidability proof (Sections: Kernel vs Full, Decidability)
- Bounded quantification uses including F-bounded quantification (Section: Bounded Quantification)
- Existential types with subtyping (Section: Existential Types)
- Intersection and union types, algebraic subtyping (Dolan) (Section: Intersection and Union Types)
- Coercive subtyping (Luo) (Section: Coercive Subtyping)
- Universe cumulativity as subtyping (Section: Universe Cumulativity as Subtyping)
- Row polymorphism as alternative (Section: Row Polymorphism)
- POPLmark Challenge (Section: POPLmark Challenge)
- Categorical perspectives including semantic subtyping (Section: Categorical Perspectives)
- 33 references

**Verdict:** Excellent. This gap is closed.

### 2.2 Linear and Substructural Types -- FULLY ADDRESSED

**Cycle 1 flagged:** No treatment of linear lambda calculus, linear logic correspondence, QTT, graded modalities, practical applications (Rust, Linear Haskell), CBPV connection.

**Doc 13 covers:** All of these topics. The document includes:
- Girard's linear logic: origins, resource interpretation, connectives, Curry-Howard correspondence (Section 1)
- Structural rules and their removal (Section 2)
- The substructural hierarchy: ordered, linear, affine, relevant, unrestricted (Section 3)
- Linear lambda calculus: full syntax, typing rules, reduction rules (Section 4)
- Exponential modality and its decomposition (Section 5)
- Intuitionistic linear logic (Section 6)
- Benton's LNL adjoint models (Section 7)
- DILL: Barber-Plotkin (Section 8)
- QTT: McBride's proposal, Atkey's formalization, Idris 2 implementation (Section 9)
- Graded modal types, coeffect systems, Granule language (Section 10)
- Session types and connection to linear logic (Section 11)
- Practical applications: Rust ownership, Linear Haskell, Clean uniqueness types (Section 12)
- CBPV and its relationship to linear logic (Section 13)
- Categorical semantics: star-autonomous categories, compact closed, SMCC, multicategories, polycategories (Section 14)
- Relationship to lambda cube and dependent types (Section 15)
- 30 references

**Verdict:** Excellent. This gap is closed.

### 2.3 Recursive Types -- FULLY ADDRESSED

**Cycle 1 flagged:** No treatment of mu types, iso-recursive vs. equi-recursive, fold/unfold, type-level fixed points, relationship to inductive types, step-indexed logical relations.

**Doc 15 covers:** All of these topics. The document includes:
- Historical context: Scott domains, ML/Miranda, Mendler (Section: Historical Context)
- Iso-recursive types: mu binder, fold/unfold, typing rules, reduction (Section: Iso-Recursive)
- Equi-recursive types: type equality up to unfolding, Amadio-Cardelli algorithm, decidability, regular trees, coinductive characterization (Section: Equi-Recursive)
- Comparison table: iso vs. equi trade-offs (Section: Comparison)
- Recursive types and Turing completeness: omega combinator, Y combinator, strict positivity (Section: Turing Completeness)
- Scott encodings vs. Church encodings (Section: Scott Encodings)
- Mendler-style recursion: mcata, hierarchy of combinators (Section: Mendler-Style)
- Recursive types in System F: impredicative encodings and their limitations (Section: Recursive Types in System F)
- Relationship to inductive types in CIC: strict positivity, guard condition, comparison table (Section: Relationship to CIC)
- Step-indexed logical relations: Appel-McAllester, Ahmed (Section: Step-Indexed)
- Parametricity with recursive types (Section: Parametricity)
- Domain equations and their connection (Section: Domain Equations)
- Practical usage in OCaml, Haskell, TypeScript, Rust (Section: Practice)
- Categorical semantics: initial algebras, terminal coalgebras, Adamek's theorem (Section: Categorical Semantics)
- 24 references

**Verdict:** Excellent. This gap is closed.

### 2.4 Eta Rules -- PARTIALLY ADDRESSED

**Cycle 1 flagged (gap #4):** No systematic treatment of beta-eta normal forms, eta in NbE, eta for products/unit/sum types, extensionality principles, definitional vs. propositional eta, function extensionality.

**Status:** This gap has been partially addressed across multiple new documents:
- Doc 12 (HoTT) discusses function extensionality as a consequence of univalence (Section 4.3) and the distinction between definitional and propositional equality.
- Doc 11 (dependent pattern matching) discusses eta-equality for records in the context of Cockx-Abel's proof-relevant unification (Section 10.3).
- Doc 17 (universe polymorphism) does not address eta directly.

**What remains unaddressed:**
- Beta-eta normal forms (long normal forms) as a systematic topic
- Eta-expansion's role in NbE (Doc 09 covers NbE but the eta treatment there was flagged as insufficient in Cycle 1)
- Positive eta laws for product types, unit types, sum types
- A comprehensive comparison of which systems adopt which eta rules

**Verdict:** Partially addressed through scattered coverage. Not critical since eta treatment appears in several documents; a dedicated section would be a nice-to-have.

### 2.5 Intersection and Union Types -- PARTIALLY ADDRESSED

**Cycle 1 flagged (gap #8):** No treatment of Coppo-Dezani-Salle, intersection types characterizing normalization, BCD system, union types, refinement types.

**Status:**
- Doc 14 (subtyping) includes a section on intersection and union types with subtyping rules, their role as meet/join in the subtype lattice, algebraic subtyping (Dolan), and decidability results.
- Doc 03 (System F) already had a brief section on intersection types.

**What remains unaddressed:**
- Coppo-Dezani-Salle system and intersection types as characterizing strong normalization (not covered in Doc 14)
- BCD type system in detail
- Refinement types and their relationship to intersections
- Modern uses in TypeScript, Flow, Scala (TypeScript mentioned briefly in Doc 14, but not TypeScript's intersection/union type system specifically)

**Verdict:** Partially addressed. The subtyping-focused treatment in Doc 14 covers the structural aspects but misses the normalization-theoretic perspective. This is a nice-to-have.

---

## 3. Assessment of Moderate Gaps from Cycle 1

### 3.1 Effects and Monads -- FULLY ADDRESSED

**Cycle 1 flagged (gap #9):** No treatment of Moggi's computational lambda calculus, algebraic effects, effect systems, IO monad, CBPV.

**Doc 16 covers:** All of these comprehensively:
- Moggi's computational lambda calculus and monadic metalanguage (Section 2)
- Monads in programming: Wadler's adaptation, IO monad, monad transformers, do-notation (Section 3)
- CBPV: value vs. computation types, F/U adjunction, CBV/CBN subsumption (Section 4)
- Effect systems: Gifford-Lucassen, polymorphic effects, row-based effects (Section 5)
- Algebraic effects and handlers: Plotkin-Power, Plotkin-Pretnar, free monad interpretation (Section 6)
- Practical languages: Eff, Koka, Frank, OCaml 5.0 (Section 6.5)
- Delimited continuations: shift/reset, control/prompt, Filinski's universality theorem (Section 7)
- Relationship to evaluation strategy (Section 8)
- Effects in dependent type theory: Dijkstra monads (F*), Lean 4, Idris 2 (Section 9)
- Categorical semantics: Kleisli categories, strong monads, Lawvere theories, Freyd categories (Section 10)
- 35 references

**Verdict:** Excellent. This gap is closed. Doc 13 (linear types) also covers CBPV (Section 13), providing complementary perspective.

### 3.2 Gradual Typing -- NOT ADDRESSED

**Cycle 1 flagged (gap #10):** No mention of gradual typing (Siek-Taha, blame calculus, gradual guarantee, gradual dependent types).

**Status:** None of the 7 new documents address gradual typing. No document in the corpus mentions Siek and Taha, blame calculus, or the gradual guarantee.

**Verdict:** Still absent. This is a nice-to-have rather than critical for a corpus focused on lambda calculi for formalization. Gradual typing is more relevant to practical programming language design than to proof assistants.

### 3.3 Observational Type Theory -- PARTIALLY ADDRESSED

**Cycle 1 flagged (gap #11):** No treatment of OTT, setoid models, extensional vs. intensional type theory, NuPRL.

**Status:** Doc 12 (HoTT) includes Section 12 on "Observational Type Theory as a Precursor," covering Altenkirch-McBride-Swierstra's OTT (2007) and its relationship to HoTT. This provides a solid overview of OTT but does not cover:
- Setoid models in detail
- NuPRL's computational type theory
- Extensional type theory as a distinct tradition

**Verdict:** Partially addressed. The OTT treatment in Doc 12 is adequate for contextualizing HoTT. A full treatment of extensional type theory and NuPRL would be a nice-to-have.

### 3.4 Quotient Types -- PARTIALLY ADDRESSED

**Cycle 1 flagged (gap #12):** No treatment of quotient type theory, quotient inductive types, relationship to setoids, HITs, Lean's Quot.

**Status:**
- Doc 12 (HoTT) covers set quotients as a special case of HITs (Section 6.2), with formation rules and the squash constructor forcing the result to be a set.
- Doc 12 also covers propositional truncation as a HIT.
- Doc 17 does not specifically discuss Lean's primitive Quot type.

**What remains:**
- Lean's Quot type as a kernel primitive (its formation, elimination, and computation rules)
- The relationship between quotients and setoids (why quotients are preferable)
- Quotient inductive-inductive types (QIITs) as used in constructing syntax

**Verdict:** Partially addressed via HoTT coverage. Lean's Quot type deserves treatment, ideally in Doc 07 (CIC) which already discusses Lean's kernel.

### 3.5 Induction-Recursion and Induction-Induction -- NOT ADDRESSED

**Cycle 1 flagged (gap #13):** Only one sentence in Doc 07. No formal definition, no examples, no proof-theoretic analysis.

**Status:** None of the 7 new documents address induction-recursion or induction-induction. The topic remains a single mention in Doc 07.

**Verdict:** Still absent. This is relevant primarily to Agda (which supports induction-recursion natively) and is a nice-to-have for a corpus that does not focus on Agda specifically.

---

## 4. Assessment of Shallow Coverage Items from Cycle 1

### 4.1 Program Extraction / Code Extraction -- NOT ADDRESSED

**Status:** Still only briefly mentioned in Docs 06 and 07. No new document covers extraction mechanisms, the Prop/Type distinction's role in extraction, or Lean's compilation approach.

**Verdict:** Nice-to-have. Could be added as a section to Doc 09 (implementation techniques).

### 4.2 Sized Types -- NOT ADDRESSED

**Status:** Still only in Doc 08 (coinductive types, Section 9). The known soundness issues with Agda's sized types are not discussed.

**Verdict:** Nice-to-have, especially given the soundness issues.

### 4.3 Proof Irrelevance and Squash Types -- PARTIALLY ADDRESSED

**Status:**
- Doc 17 covers Prop and proof irrelevance in the context of universe design (Sections 4.2--4.4), including singleton elimination restrictions.
- Doc 12 covers propositional truncation (the HoTT analogue of squash types) and the truncation hierarchy (Section 5).
- SProp in Coq (Gilbert et al.) is not specifically discussed.

**Verdict:** Adequately covered for the corpus's purposes through Docs 12 and 17.

### 4.4 Categorical Semantics of Dependent Types -- PARTIALLY ADDRESSED

**Status:**
- Doc 13 (linear types) includes categorical semantics for linear logic (Section 14).
- Doc 14 (subtyping) includes categorical perspectives on subtyping (Section: Categorical Perspectives).
- Doc 15 (recursive types) includes categorical semantics with initial algebras and terminal coalgebras (Section: Categorical Semantics).
- Doc 16 (effects) includes categorical semantics of effects: Kleisli categories, strong monads, Lawvere theories, Freyd categories (Section 10).
- Doc 17 (universes) discusses set-theoretic models with Grothendieck universes (Section 11).

**What remains:**
- Categories with Families (CwFs) -- still not formalized anywhere
- Comprehension categories
- Natural models (Awodey)
- The coherence problem for substitution (the "strictification" problem)
- A unified treatment connecting these categorical models to the dependent type theories in Docs 06-07

**Verdict:** Each new document includes relevant categorical semantics for its own topic, which is good. But a unified treatment of the categorical semantics of dependent type theory itself (CwFs, comprehension categories, the initiality conjecture) remains absent. This is a nice-to-have for the corpus.

---

## 5. Cross-Reference Assessment

### 5.1 Cross-References within New Documents (11--17)

**Doc 11 (Dependent Pattern Matching):** Has explicit cross-references to Docs 06, 07, and 09 in its overview. Also references Doc 07 Section 7.1 in Section 12.2. Good.

**Docs 12--17:** Have no explicit cross-references to other documents in the corpus. They are self-contained but do not link to the documents they complement.

### 5.2 Cross-References from Old Documents (01--10) to New Documents

**None.** The original 10 documents have not been updated to reference the 7 new documents. This means:

- Doc 01 (Untyped) does not point to Doc 15 (recursive types) for the omega combinator's typing.
- Doc 02 (STLC) mentions substructural types in a single table (Section 6.5) but does not point to Doc 13 (linear types).
- Doc 03 (System F) does not point to Doc 14 (subtyping/F<:) or Doc 13 (linear types).
- Doc 04 (System F-omega) mentions System F-mu-omega but does not point to Doc 15 (recursive types).
- Doc 05 (Lambda Cube) does not point to any new documents despite being the natural hub.
- Doc 06 (CoC) mentions universe polymorphism briefly but does not point to Doc 17.
- Doc 07 (CIC) does not point to Doc 11 (dependent pattern matching), Doc 12 (HoTT), or Doc 17 (universe polymorphism).
- Doc 08 (Coinductive) does not point to Doc 15 (recursive types, which covers terminal coalgebras).
- Doc 09 (Implementation) does not point to Doc 11 (dependent pattern matching) for case tree compilation.
- Doc 10 (Metatheory) has a general cross-reference header mentioning Docs 01-08, but no references to Docs 11-17.

### 5.3 Cross-References between New Documents

Minimal. Some natural links are missing:

- Doc 11 (dependent pattern matching) and Doc 12 (HoTT): Both discuss axiom K extensively but do not cross-reference each other. Doc 11 Section 10 discusses K-free pattern matching and HoTT compatibility; Doc 12 Section 11 discusses K vs. univalence. These should reference each other.
- Doc 13 (linear types) and Doc 16 (effects): Both cover CBPV but do not cross-reference. Doc 13 Section 13 and Doc 16 Section 4 cover CBPV from different angles.
- Doc 14 (subtyping) and Doc 17 (universe polymorphism): Doc 14 has a section on universe cumulativity as subtyping; Doc 17 has a section on cumulativity. They do not reference each other.
- Doc 15 (recursive types) and Doc 07 (CIC): Doc 15 has a section on the relationship to CIC inductive types but does not explicitly reference Doc 07.

### 5.4 Verdict on Cross-References

Cross-referencing remains inadequate. The new documents were written as standalone pieces. The original documents were not updated. This is the most significant remaining issue in the corpus -- not a content gap but a structural one.

**Recommendation:** Add cross-reference headers (similar to Doc 11's format) to all documents, and add forward-reference annotations to the original documents pointing to the relevant new documents.

---

## 6. Gaps Introduced by New Documents

### 6.1 Normalization by Evaluation (NbE) for Cubical Type Theory

Doc 12 mentions Sterling and Angiuli's normalization result for cubical type theory (reference 19) but does not discuss the technique. Doc 09 covers NbE generally but not for cubical type theory. This is a gap introduced by the cubical type theory coverage.

**Severity:** Nice-to-have.

### 6.2 Multiparty Session Types -- Shallow

Doc 13 Section 11.5 mentions multiparty session types (Honda-Yoshida-Carbone) in a single paragraph. Given the depth of the binary session types treatment, multiparty session types deserve either fuller treatment or explicit acknowledgment as out of scope.

**Severity:** Nice-to-have.

### 6.3 Graded Dependent Types

Doc 13 mentions Abel, Danielsson, and Eriksson (2023) "A Graded Modal Dependent Type Theory with a Universe" as reference 30 but does not discuss it. This is a natural extension of the QTT material and represents the current frontier of linear/graded dependent type theory.

**Severity:** Nice-to-have.

### 6.4 Scoped and Named Effect Handlers

Doc 16 mentions named and scoped handlers (in the Koka discussion) but does not treat them systematically. The distinction between deep and shallow handlers, and the semantics of effect scoping, are active research topics that are mentioned but not developed.

**Severity:** Nice-to-have.

---

## 7. Remaining Gaps Summary

### Critical Remaining Gaps

**None.** All three critical gaps from Cycle 1 have been fully addressed.

### Significant Remaining Gaps

**Cross-referencing (structural, not content).** The original documents (01--10) have not been updated with references to the new documents (11--17), and the new documents mostly lack cross-references to each other. This is the most important remaining issue.

### Nice-to-Have Gaps

Ranked by relevance to the corpus's focus on lambda calculi and formalization:

1. **Eta rules -- systematic treatment.** Partially addressed across documents but no unified treatment of beta-eta normal forms, positive eta laws, and the design space of eta rules in proof assistants. Could be a section added to Doc 09 or Doc 10.

2. **Quotient types in Lean.** Lean's primitive Quot type is mentioned (Doc 07) but its rules are not given. A section in Doc 07 would suffice.

3. **Categories with Families and the categorical semantics of dependent types.** A unified treatment would strengthen the corpus's theoretical foundations. Could be added to Doc 10 (metatheory) or as a new document.

4. **Intersection types as characterizing normalization.** The Coppo-Dezani-Salle perspective is missing from the subtyping document. Could be a section in Doc 14.

5. **Gradual typing.** Entirely absent. Relevant to bridging untyped and typed calculi but not critical for the formalization focus.

6. **Induction-recursion and induction-induction.** Still only a mention in Doc 07. Relevant for understanding Agda's expressiveness beyond CIC.

7. **Program extraction / code extraction.** Still shallow. Could be a section in Doc 09.

8. **Extensional type theory and NuPRL.** Partially covered via OTT in Doc 12 but the extensional type theory tradition is underrepresented.

9. **Sized types soundness issues.** Still only in Doc 08. The known unsoundness of Agda's `--sized-types` deserves mention.

---

## 8. Missing Examples from Cycle 1

The Cycle 1 review identified missing worked examples in several documents. These have not been addressed in the existing documents, as the existing documents were not modified. However, the new documents generally include good worked examples:

- Doc 11 includes the `head : Vec A (S n) -> A` example worked through in detail (Section 3.3), convoy pattern examples (Section 5.2), and K-free vs. K-requiring examples (Section 10.5).
- Doc 12 includes the encode-decode proof of pi_1(S^1) = Z (Section 7.1).
- Doc 13 includes typing rule derivations for linear lambda calculus (Section 4.2) and Idris 2 code examples (Section 9.4).
- Doc 15 includes the omega combinator and Y combinator constructions (Section: Turing Completeness) and practical code in OCaml, Haskell, TypeScript, and Rust.
- Doc 16 includes a state handler example and monad transformer examples.

---

## 9. Missing References Check

All 10 seminal papers flagged as missing in Cycle 1 are now cited:

1. Moggi (1991) "Notions of Computation and Monads" -- cited in Doc 16
2. Altenkirch, McBride, Swierstra (2007) "Observational Equality, Now!" -- cited in Doc 12
3. Siek and Taha (2006) "Gradual Typing" -- **still not cited** (gradual typing not covered)
4. Atkey (2018) "Quantitative Type Theory" -- cited in Doc 13
5. McBride (2002) "Elimination with a Motive" -- cited in Doc 11
6. Goguen, McBride, McKinna (2006) "Eliminating Dependent Pattern Matching" -- cited in Doc 11
7. HoTT Book (2013) -- cited in Doc 12
8. Cohen, Coquand, Huber, Mortberg (2018) "Cubical Type Theory" -- cited in Doc 12
9. Levy (2003) "Call-by-Push-Value" -- cited in Docs 13 and 16
10. Luo (1994) "Computation and Reasoning" -- **not cited** (Luo's coercive subtyping work is cited in Doc 14, but the 1994 ECC book is not)

9 of 10 are now cited. Siek-Taha remains uncited (consistent with gradual typing being absent). Luo (1994) ECC book is not cited but Luo's coercive subtyping papers (1997, 1999, 2013) are cited in Doc 14.

---

## 10. Overall Assessment

The corpus has improved dramatically from 10 to 17 documents. The three critical gaps and all significant gaps from Cycle 1 have been addressed with high-quality, in-depth documents. The coverage now spans:

- **Core lambda calculi:** Untyped, STLC, System F, System F-omega, Lambda Cube, CoC, CIC, coinductive types
- **Implementation and metatheory:** Implementation techniques, metatheory and correctness
- **Type theory extensions:** Dependent pattern matching, HoTT/cubical type theory, universe polymorphism
- **Type system paradigms:** Linear/substructural types, subtyping/bounded quantification, recursive types
- **Computational effects:** Effects, monads, algebraic effects, CBPV

**The most important remaining action item is adding cross-references between documents.** This is a structural improvement that would significantly enhance the corpus's usability without requiring new content.

**No new documents are critically needed.** The remaining gaps (eta rules, quotient types in Lean, categorical semantics of dependent types, gradual typing, induction-recursion) are all "nice-to-haves" that could be addressed as sections within existing documents rather than as new standalone documents.
