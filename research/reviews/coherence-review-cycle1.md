# Coherence Review -- Cycle 1

## Summary

The ten summary documents form a broadly coherent body of knowledge that traces the evolution of lambda calculi from untyped foundations through the Calculus of Inductive Constructions and coinduction, with cross-cutting documents on implementation and metatheory. The narrative arc is logically sound and the overall quality is high. However, there are notable inconsistencies in notation, terminology, and framing that should be resolved before the collection can serve as a unified reference.

---

## 1. Notation Inconsistencies

### 1.1 Sorts: `*` vs `Prop` vs `Type`, `Box` vs `square`

The notation for sorts varies across documents without a clear convention being established and then followed:

- **Doc 04 (System Fw)** uses `*` and `Box` (written as `square` in the PTS specification), with `*` pronounced "star" or "type."
- **Doc 05 (Lambda Cube)** uses `*` and `box`, noting parenthetically that `*` is "also written `Prop` or `Type`" and `box` is "also written `Kind`." This equating of `*` with both `Prop` and `Type` is misleading -- in CIC (Doc 07), `Prop` and `Type` are distinct sorts with different properties (impredicativity, proof irrelevance).
- **Doc 06 (CoC)** introduces `Prop` and `Type` as the primary notation, then notes the Barendregt aliases `*` and `Box`. This is the clearest presentation.
- **Doc 07 (CIC)** uses `Prop`, `Set`, and `Type(i)`, which is appropriate but the relationship to the `*`/`Box` notation of earlier documents is never explicitly stated.

**Recommendation:** Establish a notational convention early (e.g., in Doc 02 or Doc 05) that explicitly distinguishes `*`/`Prop` and `Box`/`Type` as aliases used in different contexts, and warn that `*` = `Prop` is only valid in systems where propositions and types are not distinguished.

### 1.2 Arrow kinds: `=>` vs `->` at the kind level

- **Doc 04 (System Fw)** explicitly uses `=>` for kind arrows to distinguish them from type-level `->`, noting: "We use `=>` at the kind level to distinguish from `->` at the type level, though many presentations use `->` for both."
- **Doc 05 (Lambda Cube)** uses `->` for all arrows (kind, type, and term levels) via the PTS unification where `Pi` subsumes all product types.
- **Doc 07 (CIC)** uses `->` uniformly.

This is not strictly a contradiction (since the lambda cube unifies arrows via Pi-types), but the shift from Doc 04's careful distinction to Doc 05's unified notation happens without comment. A reader moving from Doc 04 to Doc 05 may find the change confusing.

### 1.3 Type abstraction: `Lambda` vs `lambda`

- **Doc 03 (System F)** uses `Lambda` (capital lambda) for type abstraction at the term level, distinct from `lambda` for term abstraction. This follows the conventional Girard/Reynolds notation.
- **Doc 04 (System Fw)** continues this convention with `Lambda alpha:kappa. e`.
- **Doc 05 (Lambda Cube)** uses `Lambda` in the System F examples but then switches to the PTS unified syntax where `lambda` is used for all abstractions (type and term), distinguished only by the sort of the bound variable's type.
- **Doc 06 (CoC)** uses only `lambda` (lowercase), consistent with the PTS formulation.

The transition from the two-lambda convention (Docs 03-04) to the single-lambda convention (Docs 05-06) is a real notational shift that is never explicitly acknowledged or explained.

**Recommendation:** Add a note in Doc 05 or Doc 06 explaining that the PTS formulation unifies `Lambda` and `lambda` into a single binder, and that the earlier distinction was a surface-syntax convention.

### 1.4 Universal quantification: `forall` vs `Pi`

- **Docs 03-04** use `forall` for universal quantification over types.
- **Doc 05 (Lambda Cube)** uses `Pi` as the uniform binder in the PTS presentation, noting that `Pi x : A. B` is written `A -> B` when `x` does not appear free in `B`.
- **Doc 06 (CoC)** uses `Pi` in the formal rules but `forall` in informal discussion and Curry-Howard tables.
- **Doc 07 (CIC)** uses `forall` (Coq syntax) throughout.

The relationship between `forall` and `Pi` is stated in Doc 06 but not in Doc 05, which simply starts using `Pi` without relating it back to the `forall` of Docs 03-04.

### 1.5 Substitution notation

- **Doc 01 (Untyped)** uses `M[x := N]`.
- **Doc 02 (STLC)** uses `[x := v] e` (prefix notation, substitution before the term).
- **Doc 03 (System F)** uses both `t[s/x]` and `tau[sigma/alpha]`.
- **Doc 04 (System Fw)** uses `e_1[x := e_2]` and `tau_1[alpha := tau_2]`.
- **Doc 06 (CoC)** uses `t[a/x]`.

Three different substitution notations appear across the documents: `M[x := N]`, `[x := v] e`, and `t[s/x]`. While all are standard in the literature, using them interchangeably within a single body of work is confusing.

**Recommendation:** Pick one notation (e.g., `t[x := s]`) and use it consistently, noting alternatives in a single location.

---

## 2. Terminology Inconsistencies

### 2.1 "Strong normalization" vs "termination"

All documents consistently use "strong normalization" as the primary term. Doc 02 (STLC) correctly equates it with termination: "every well-typed term reduces to a (unique) normal form in finitely many steps -- equivalently, every STLC program terminates." This is used consistently and is not a problem.

### 2.2 "Confluence" vs "Church-Rosser"

- **Doc 01** titles its section "The Church-Rosser Theorem (Confluence)" and treats them as synonymous.
- **Doc 05** uses "Church-Rosser Property (Confluence)" as a heading.
- **Doc 06** uses "Confluence (Church-Rosser Property)."
- **Doc 10 (Metatheory)** section 4 is titled "Confluence" and section 4.1 is "Church-Rosser Theorem."

The terms are used interchangeably, which is standard practice. This is consistent.

### 2.3 "Type safety" vs "type soundness"

- **Doc 02 (STLC)** uses "Type Safety: Progress and Preservation" as a section heading and mentions "type soundness" only in passing via Wright and Felleisen.
- **Doc 10 (Metatheory)** section 1 is titled "Type Safety" and uses this term consistently, mentioning "type soundness" as an alternative in 1.3.

This is handled well.

### 2.4 "Reducibility candidates" vs "logical predicates" vs "logical relations"

The proof technique for strong normalization is referred to by different names across documents:

- **Doc 02 (STLC)** calls it "Tait's method of logical predicates" and "hereditary termination."
- **Doc 03 (System F)** calls it "reducibility candidates (candidats de reductibilite)" and contrasts it with "Tait's method of logical predicates/computability."
- **Doc 04 (System Fw)** says "reducibility candidates (also called saturated sets or logical relations)."
- **Doc 10 (Metatheory)** section 2 carefully distinguishes: Tait's method uses "reducibility predicates" (unary), Girard's method uses "reducibility candidates," and section 3 treats "logical relations" (binary) as a separate generalization.

Doc 04's parenthetical "(also called saturated sets or logical relations)" conflates three genuinely different concepts. Reducibility candidates are a specific formulation of unary logical predicates satisfying CR1-CR3; logical relations are binary. Saturated sets are yet another formulation. Doc 10 handles this distinction carefully, but earlier documents blur it.

**Recommendation:** Align Docs 02-04 with the careful taxonomy in Doc 10. In particular, fix Doc 04's parenthetical to say "(also called saturated sets)" without "or logical relations."

### 2.5 "Dependent product" vs "Pi-type" vs "function type"

- **Doc 05** uses "dependent product" as the term for `Pi(x:A).B`.
- **Doc 06** uses both "dependent product (Pi-type)" and "Pi-Formation" for the typing rule.
- **Doc 07** uses "product" in rule names (`Prod-Prop`, `Prod-Set`, `Prod-Type`) but `forall` in the syntax.

The relationship between `forall` (Coq syntax), `Pi` (type-theoretic syntax), and "dependent product" (semantic terminology) should be stated once and referenced thereafter.

---

## 3. Conceptual Progression and Cross-References

### 3.1 Strong forward references

The documents generally build well on each other:

- Doc 02 (STLC) explicitly mentions System F and System T as extensions.
- Doc 03 (System F) explicitly extends STLC and references it.
- Doc 04 (System Fw) explicitly extends System F and references it.
- Doc 05 (Lambda Cube) unifies all previous systems and references them by name.
- Doc 06 (CoC) references the lambda cube and its position at the apex.
- Doc 07 (CIC) explicitly motivates itself as extending CoC.

### 3.2 Missing backward references

- **Doc 08 (Coinduction)** does not explicitly reference Docs 06 or 07 in its main body, even though coinductive types are introduced within CIC. The document is largely self-contained with a category-theoretic and process-algebraic presentation. It discusses Coq's `CoFixpoint` and Agda's coinductive records but does not connect back to the formal CIC framework of Doc 07.
- **Doc 09 (Implementation)** is properly cross-cutting but rarely refers to specific earlier documents by number. It discusses "dependent type theories" generically.
- **Doc 10 (Metatheory)** similarly treats systems generically. This is appropriate for a cross-cutting document, but it could benefit from explicit back-references (e.g., "the strong normalization proof for System F described in Doc 03, Section 7").

### 3.3 The untyped-to-typed transition

Doc 01 (Untyped) and Doc 02 (STLC) both stand well on their own, but the transition between them could be stronger. Doc 02 mentions Church's motivation (restoring consistency after the Kleene-Rosser paradox) but does not reference the detailed treatment of the paradox that appears in Doc 01. A cross-reference would strengthen the narrative.

---

## 4. Redundancy

### 4.1 Church encodings

Church encodings of booleans and natural numbers are presented in full detail in:

- Doc 01 (Untyped) -- untyped versions
- Doc 03 (System F) -- typed versions
- Doc 04 (System Fw) -- same as System F, presented again
- Doc 06 (CoC) -- presented again with Prop/Type

The System Fw document explicitly notes "same as System F" for booleans and naturals, which is good. But the CoC document re-derives them without referencing the earlier presentations. Consider adding cross-references: "The Church encoding of natural numbers (see Doc 03, Section 5.2) carries over to CoC..."

### 4.2 The lambda cube

The lambda cube is described in:

- Doc 04 (System Fw), Section "The Lambda Cube" -- a brief table
- Doc 05 (Lambda Cube) -- the full treatment
- Doc 06 (CoC), Section 3.2 -- a brief summary of CoC's position

The brief treatments in Docs 04 and 06 are appropriate as contextual summaries, but Doc 04's table has a minor issue: it lists `lambda-omega` as the notation for System Fw's position (axes 1+2), which is correct, but uses the exact same symbol `lambda-omega` as the weak omega system (axis 2 alone). Doc 05 distinguishes these as `lambda-omega` (Fw) vs `lambda-underline-omega` (weak omega). Doc 04's table does not make this distinction clear.

### 4.3 PTS specifications

PTS specifications for the same system appear in multiple documents:

- System F's PTS spec appears in Docs 03, 04, and 05.
- System Fw's PTS spec appears in Docs 04 and 05.
- CoC's PTS spec appears in Docs 05 and 06.

These are consistent with each other, which is good. The redundancy is acceptable for standalone readability.

### 4.4 Strong normalization proofs

The conceptual structure of Girard's reducibility candidates proof is described in Docs 03, 04, 06, and 10. The treatments are compatible and progressively more general. Doc 10 provides the most comprehensive treatment. Minor recommendation: Docs 03 and 04 could point forward to Doc 10 for the definitive treatment.

### 4.5 Bidirectional type checking

Bidirectional type checking is described in both Doc 02 (Section 5.3) and Doc 09 (Section 3.1). The presentations are compatible and both reference Dunfield and Krishnaswami. Doc 02's treatment is briefer and specific to STLC; Doc 09's is more general. This overlap is acceptable.

---

## 5. Framing Consistency

### 5.1 STLC as a fragment of System F

Doc 02 (STLC) describes STLC as "the most fundamental typed lambda calculus" and discusses its extensions. Doc 03 (System F) describes itself as extending STLC with universal quantification over types. These framings are consistent.

### 5.2 System F as a fragment of System Fw

Doc 03 does not discuss System Fw directly. Doc 04 (Fw) explicitly describes System F as a fragment of Fw (Section "System F as a Fragment"), which is correct and well-framed.

### 5.3 CoC as the apex of the lambda cube

Doc 05 (Lambda Cube) and Doc 06 (CoC) both frame CoC as the apex of the cube, and their descriptions are consistent. However, there is a subtle framing tension:

- Doc 05 describes CoC's computational power as "As strong as System F-omega in computational terms, with the additional expressive power of dependent types for specifying properties."
- Doc 06 frames CoC more as a logic/proof system, emphasizing the Curry-Howard correspondence with higher-order predicate logic.

These are compatible perspectives, but the shift in emphasis between the documents is noticeable. Doc 05 adopts a computational/PL perspective; Doc 06 adopts a logical/proof-theoretic perspective.

### 5.4 CIC vs CoC

Doc 06 (CoC) clearly motivates the need for CIC by discussing the induction problem (Section 9). Doc 07 (CIC) echoes this motivation (Section 2). The framings are consistent and complementary.

### 5.5 Coinduction's position in the narrative

Doc 08 (Coinduction) is somewhat disconnected from the main narrative arc. It is framed as a self-contained treatment of coinductive types rather than as an extension of CIC. The document does discuss Coq and Agda implementations, but it does not position coinduction within the lambda cube or PTS framework. This is perhaps inevitable given that coinduction is not naturally part of the PTS story, but a brief framing paragraph connecting it to CIC (e.g., "CIC as described in Doc 07 is extended with coinductive types via the `CoInductive` keyword...") would help.

---

## 6. Gaps in the Narrative Arc

### 6.1 Missing: The Curry-Howard thread

Each document mentions Curry-Howard, but there is no single place where the progressive deepening of the correspondence is made explicit:

- STLC <-> propositional logic
- System F <-> second-order propositional logic
- Fw <-> higher-order propositional logic
- CoC <-> higher-order predicate logic
- CIC <-> higher-order predicate logic with induction

Doc 04 (Fw) has the most complete table (Section "Curry-Howard Perspective"), and Doc 05 has a similar table. But the thread could be made more explicit across the full arc.

### 6.2 Missing: Explicit discussion of the predicativity shift

Docs 03 and 04 treat impredicative systems (System F, Fw). Doc 07 (CIC) introduces a predicative hierarchy (`Type(i)`) alongside an impredicative `Prop`. This is a fundamental design decision that is discussed within Doc 07 but the contrast with the fully impredicative systems of Docs 03-04 is not made sharp. Doc 04 does have a section on "Stratification and Predicativity Considerations" that discusses predicative variants, which is helpful.

### 6.3 Missing: Recursion and fixed points

The untyped lambda calculus (Doc 01) discusses fixed-point combinators (the Y combinator) extensively. The typed documents (Docs 02-06) emphasize strong normalization, which precludes general recursion. But the practical story -- how real programming languages and proof assistants recover recursion (through general recursive types, structural recursion on inductive types, well-founded recursion) -- is only partially told. Doc 07 (CIC) discusses structural recursion and the `fix` construct, and Doc 09 discusses implementation, but there is a narrative gap between "all well-typed terms terminate" (Docs 02-06) and "here is how we do recursion in practice" (Doc 07).

### 6.4 Missing: Eta-reduction treatment

Eta-reduction is handled inconsistently:

- Doc 01 discusses eta-reduction and eta-expansion.
- Doc 02 does not discuss eta.
- Doc 03 mentions eta rules as "optional."
- Doc 06 says "Some presentations of CoC also include eta-reduction."
- Doc 10 discusses beta-eta equivalence for STLC and System F.

There is no clear statement of when eta is or is not part of the system, and the implications of including/excluding it (e.g., for confluence, decidability, NbE) are scattered.

---

## 7. Style Consistency

### 7.1 Section numbering

- Docs 01-03, 06, 10 use numbered sections (1, 2, 3...).
- Docs 04-05 use named sections without numbers.
- Docs 07-09 use numbered sections.

This is a minor inconsistency but affects navigation.

### 7.2 Level of formality

All documents maintain a high level of formality, presenting typing rules, reduction rules, and proof sketches. The level of detail is generally consistent, though:

- Doc 01 (Untyped) is the most comprehensive relative to its topic, covering advanced material like Bohm's theorem and Scott's D-infinity model.
- Doc 08 (Coinduction) is similarly comprehensive, covering both the categorical foundations and the implementation in proof assistants.
- Docs 09-10 (Implementation, Metatheory) are broad surveys that necessarily sacrifice depth on individual topics.

The depth is appropriate for each document's role. Doc 09 is perhaps the most "survey-like" in style, while Docs 01-08 are more "reference-like."

### 7.3 Use of examples

Docs 01-04 and 06-08 provide concrete examples (Church encodings, typing derivations, Coq/Agda code). Doc 05 (Lambda Cube) is more abstract, with fewer worked examples. Doc 10 (Metatheory) provides proof sketches but fewer concrete examples. This variation is appropriate.

### 7.4 Reference sections

All documents include reference sections. These are generally well-curated and non-overlapping, though key references (Barendregt 1992, Pierce 2002, Girard 1972) recur across multiple documents. This is acceptable and expected.

---

## 8. Specific Errors or Misleading Statements

### 8.1 Doc 05 (Lambda Cube): `*` equated with `Prop` and `Type`

Line 137 of Doc 05 says: "`*` (star, also written `Prop` or `Type`) -- the sort of types / propositions". Equating `Prop` and `Type` here is misleading. In systems with a Prop/Type distinction (CoC, CIC), these are different sorts with different properties. In the pure lambda cube, `*` is a single sort, but calling it both `Prop` and `Type` sets up confusion for the reader moving to Docs 06-07.

### 8.2 Doc 04 (System Fw): Lambda cube table

The table in Doc 04 lists the eight systems but uses `lambda-omega` for the weak omega system (axis 2 alone) in the "System" column entry "lambda-omega" for row "2 | Types on types | lambda-omega (type operators)". Then the same notation `lambda-omega` appears for the combined axes 1+2 entry "1+2 | Both 1 and 2 | lambda-omega (System Fw)". These should be distinguished (e.g., `lambda-underline-omega` for weak omega, as Doc 05 does).

### 8.3 Doc 07 (CIC): Nat encoding in CoC

Doc 07 Section 2 writes `Nat := forall (X : Type), X -> (X -> X) -> X` but Doc 06 Section 8.1 writes `Nat := Pi(A : Prop). A -> (A -> A) -> A`. The difference (`Type` vs `Prop`, `X` vs `A`) reflects a real design choice -- whether naturals are encoded in `Prop` or `Type`. Doc 07 uses `Type` to motivate the weakness of encodings (no dependent elimination), while Doc 06 uses `Prop` consistent with impredicative encodings for logical purposes. This should be noted explicitly as an intentional choice, not left as an apparent inconsistency.

---

## 9. Overall Assessment

**Strengths:**
- The narrative arc from untyped through CIC is logically sound.
- Each document is individually high-quality and well-referenced.
- The PTS specifications across documents are consistent.
- The conceptual progression (adding features along lambda cube axes) is well-motivated.

**Priority fixes:**
1. Harmonize substitution notation across all documents.
2. Fix the `*`/`Prop`/`Type` conflation in Doc 05.
3. Fix the `lambda-omega` ambiguity in Doc 04's table.
4. Correct Doc 04's claim that reducibility candidates are "also called logical relations."
5. Add a brief framing paragraph in Doc 08 (Coinduction) connecting it to the CIC framework of Doc 07.
6. Acknowledge the Lambda/lambda notational transition when moving from Docs 03-04 to the PTS formulation in Doc 05.

**Lower-priority improvements:**
7. Add cross-references for Church encodings to reduce redundancy.
8. Add a note about the forall/Pi relationship when Pi is first introduced.
9. Standardize section numbering across all documents.
10. Add a paragraph somewhere in the arc (perhaps Doc 07) about how structural recursion recovers practical programmability despite strong normalization.
