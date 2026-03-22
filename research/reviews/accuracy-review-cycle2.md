# Accuracy Review -- Cycle 2 (Documents 11--17)

Reviewer: automated accuracy review
Date: 2026-03-22

---

## Summary

Seven new documents (11--17) were reviewed for factual errors, imprecisions,
misattributions, and citation inaccuracies. The documents are generally of
high quality. The findings below are organized by document, then summarized
in a severity table at the end.

---

## Document 11: Dependent Pattern Matching

### Finding 11-1 (Severity: Low -- Imprecision)
**File:** `11-dependent-pattern-matching.md`, Section 9.4
**Claim:** "Hofmann and Streicher (1994) constructed a model..."
**Issue:** The document says 1994, which is the date of the initial conference
paper (LICS 1994, "The groupoid model refutes uniqueness of identity proofs").
The fuller treatment is the 1998 book chapter "The Groupoid Interpretation of
Type Theory" in *Twenty-Five Years of Constructive Type Theory*. The document
in Section 15 (reference 5) cites the 1998 publication. The body text date
of 1994 is defensible (referring to the original result) but creates an
inconsistency with the reference list, which only cites the 1998 version.
**Correction:** Either change the body text to "Hofmann and Streicher (1994;
published 1998)" or add the 1994 LICS paper to the reference list.

### Finding 11-2 (Severity: Negligible -- Style)
**File:** `11-dependent-pattern-matching.md`, Section 10.3
**Claim:** "Cockx and Abel strengthened this approach... (Cockx-Abel, 2018)"
**Issue:** The reference list (items 9 and 10) lists two Cockx-Abel 2018
papers -- the ICFP paper and the JFP paper. The section heading says
"Proof-Relevant Unification (Cockx-Abel, 2018)" but the 2016 ICFP paper by
Cockx and Devriese (reference 7) is the one that introduced proof-relevant
unification. The 2018 papers refined and extended it. This is slightly
misleading about attribution.
**Correction:** Clarify that proof-relevant unification was introduced by
Cockx and Devriese (2016) and extended by Cockx and Abel (2018).

No other factual errors found in this document.

---

## Document 12: Homotopy Type Theory

### Finding 12-1 (Severity: Medium -- Date Error)
**File:** `12-homotopy-type-theory.md`, Section 1.3
**Claim:** "In 1970, Per Martin-Lof proposed a type theory with the axiom
Type : Type"
**Issue:** Martin-Lof's original type theory with Type : Type appeared in a
1971 preprint ("A Theory of Types," Technical Report 71-3). The 1970 work
("Notes on Constructive Mathematics") is a different publication. The
inconsistent system is conventionally dated to 1971.
**Correction:** Change "In 1970" to "In 1971".

### Finding 12-2 (Severity: Low -- Imprecision)
**File:** `12-homotopy-type-theory.md`, Section 1.3
**Claim:** Voevodsky's timeline lists "1984: As an undergraduate, Voevodsky
read Grothendieck's 'Esquisse d'un Programme'"
**Issue:** According to biographical sources, Voevodsky was given a copy of
the Esquisse by George Shabat when he was a first-year undergraduate at Moscow
University. Voevodsky was born in 1966 and entered university around 1983--84.
The Esquisse was submitted to CNRS in January 1984. The claim is plausible
but the document should note that Voevodsky received it from Shabat, since
the Esquisse was not publicly available at that time.
**Correction:** Minor; optionally add "via George Shabat" for precision.

### Finding 12-3 (Severity: Low -- Imprecision)
**File:** `12-homotopy-type-theory.md`, Section 1.3
**Claim:** "including his own 1992-93 work on presheaves with transfers"
**Issue:** According to biographical sources, the error in Voevodsky's work
on presheaves with transfers was discovered by Voevodsky himself during
lectures at IAS in 1999-2000 (not at the time of original writing). The
document's phrasing "his own 1992-93 work" correctly identifies the work
but could be read as implying the error was discovered in 1992-93. The
sentence is ambiguous but not strictly wrong.
**Correction:** No change strictly needed, but could be clarified.

### Finding 12-4 (Severity: Low -- Imprecision)
**File:** `12-homotopy-type-theory.md`, Section 4.2
**Claim:** "Voevodsky called this 'univalent' drawing on a Russian
translation of Boardman and Vogt's book where 'faithful functor' was
rendered as 'univalent functor.'"
**Issue:** This appears to be correct per Voevodsky's own account. However,
the Boardman-Vogt book is specifically "Homotopy Invariant Algebraic
Structures on Topological Spaces" (1973). The document does not name the
book. This is a minor omission, not an error.
**Correction:** Optionally add the book title for completeness.

### Finding 12-5 (Severity: Medium -- Date/Reference Error)
**File:** `12-homotopy-type-theory.md`, Section 17 (reference 4)
**Claim:** Reference 4 cites Hofmann-Streicher as being in the proceedings
of "Twenty-five years of constructive type theory (Venice, 1995)."
**Issue:** The conference took place in Venice in 1995, and the proceedings
were published in 1998. The reference correctly notes the 1998 publication
date. However, the document's Section 1.1 heading says "Hofmann-Streicher
and the Groupoid Model (1998)" while the body says "In 1994, Martin Hofmann
and Thomas Streicher constructed a model." The original result was presented
in 1994 (LICS). The heading date (1998) refers to the book chapter, not the
discovery. This is internally inconsistent.
**Correction:** Change heading to "(1994/1998)" or "(1994)" to reflect the
original discovery date consistently.

### Finding 12-6 (Severity: Low -- Imprecision)
**File:** `12-homotopy-type-theory.md`, Section 9.5
**Claim:** "CCHM cubical type theory (Cohen, Coquand, Huber, Mortberg;
originally presented at TYPES 2015, journal version 2018)"
**Issue:** The CCHM paper was posted on arXiv in November 2016
(arXiv:1611.02108) and the journal version appeared in Journal of Automated
Reasoning in 2018. The "TYPES 2015" attribution for the original presentation
is plausible (early versions of the ideas were presented there) but the
standard citation is to the 2016 arXiv preprint / 2018 journal paper.
**Correction:** Consider changing "originally presented at TYPES 2015" to
"arXiv preprint 2016" for accuracy.

### Finding 12-7 (Severity: Medium -- Attribution Error)
**File:** `12-homotopy-type-theory.md`, Section 7.2
**Claim:** "pi_k(S^n) = 0 for k < n (by the Freudenthal suspension theorem,
proved synthetically by Lumsdaine and Licata)"
**Issue:** The Freudenthal suspension theorem in HoTT was proved by
Lumsdaine, Finster, and Licata (not just "Lumsdaine and Licata"). The cited
LICS 2015 paper (reference 20) is by Licata and Brunerie, not Lumsdaine.
The attribution is confused. The vanishing of pi_k(S^n) for k < n follows
from connectivity arguments, and the Freudenthal suspension theorem is a
separate (though related) result.
**Correction:** Correct the attribution. The Freudenthal suspension theorem
was formalized by multiple authors; cite accurately.

No other significant errors found.

---

## Document 13: Linear and Substructural Types

### Finding 13-1 (Severity: Low -- Page Range)
**File:** `13-linear-and-substructural-types.md`, Section 1.1
**Claim:** "Girard in his landmark 1987 paper 'Linear Logic' (Theoretical
Computer Science, 50: 1--102)"
**Issue:** The page range is cited as 1--102 in the body text. Different
sources cite this as either 1--101 or 1--102. The Journal of Symbolic Logic
review and multiple standard databases cite pp. 1--101. ScienceDirect shows
pages 1--102 (counting the final page). This is a very minor discrepancy
that exists in the literature itself.
**Correction:** No change strictly needed; both paginations appear in
authoritative sources.

### Finding 13-2 (Severity: Low -- Imprecision)
**File:** `13-linear-and-substructural-types.md`, Section 13 (CBPV)
**Claim:** The document includes a full Section 13 on Call-by-Push-Value
(CBPV) that substantially overlaps with the CBPV coverage in Document 16.
**Issue:** This is a structural/redundancy concern, not a factual error. Both
treatments are accurate. However, the CBPV section in this document (Section
13) presents it as a substructural-adjacent topic, while Doc 16 presents it
as an effects topic. Both are valid framings.
**Correction:** Not a factual error; note for coherence review.

### Finding 13-3 (Severity: Negligible)
**File:** `13-linear-and-substructural-types.md`, Section 7.1
**Claim:** Benton 1994 paper cited as "A Mixed Linear and Non-Linear Logic:
Proofs, Terms and Models" at CSL 1994.
**Issue:** Verified correct.
**Correction:** None needed.

No significant factual errors found in this document.

---

## Document 14: Subtyping and Bounded Quantification

### Finding 14-1 (Severity: Low -- Imprecision)
**File:** `14-subtyping-and-bounded-quantification.md`, Decidability Results
**Claim:** "Benjamin Pierce proved in 1992 (published in Information and
Computation in 1994) that the subtyping problem for Full F<: is undecidable.
The proof proceeds by reduction from the halting problem for two-counter
Turing machines."
**Issue:** The reduction is from the halting problem for two-counter
*machines* (Minsky machines), not "two-counter Turing machines." Two-counter
machines are a specific model of computation (equivalent to Turing machines
in power) but are not themselves Turing machines. The distinction matters
because the encoding exploits the specific structure of counter operations.
**Correction:** Change "two-counter Turing machines" to "two-counter
machines" (or "two-counter Minsky machines").

### Finding 14-2 (Severity: Low -- Minor Historical)
**File:** `14-subtyping-and-bounded-quantification.md`, Decidability Results
**Claim:** "Castagna and Pierce (POPL 1994), though their initial formulation
required a corrigendum (POPL 1995)."
**Issue:** Verified correct. The corrigendum is real and was published at
POPL 1995.
**Correction:** None needed.

### Finding 14-3 (Severity: Low -- Imprecision)
**File:** `14-subtyping-and-bounded-quantification.md`, Function Subtyping
**Claim:** "a function of type `Vertebrate -> Cat` is a subtype of
`Mammal -> Mammal`"
**Issue:** This example is correct (Cat <: Mammal, Mammal <: Vertebrate),
but the slogan "accepts more and returns less" is stated with respect to the
*supertype*, which can be confusing. In the variance rule, S1 -> S2 <: T1 -> T2
requires T1 <: S1 and S2 <: T2. Here S1=Vertebrate, S2=Cat, T1=Mammal,
T2=Mammal. We need Mammal <: Vertebrate (yes) and Cat <: Mammal (yes). The
example is correct.
**Correction:** None needed; the example checks out.

No significant factual errors found in this document.

---

## Document 15: Recursive Types

### Finding 15-1 (Severity: Medium -- Date Error)
**File:** `15-recursive-types.md`, Historical Context
**Claim:** "Coquand and Paulin-Mohring, 1988; Paulin-Mohring, 1993"
regarding CIC.
**Issue:** The paper by Coquand and Paulin-Mohring was presented at the
COLOG-88 conference (held in 1988) but the proceedings (LNCS 417) were
published in 1990, not 1988. The standard citation is "Coquand and
Paulin-Mohring, 1990" (the publication date of the proceedings). However,
the reference list (item 8) correctly cites "COLOG-88, Springer LNCS 417,
1990." The body text saying "1988" refers to the conference date, which is
a common convention. This is a minor inconsistency between body and reference.
**Correction:** Consider changing body text to "Coquand and Paulin-Mohring,
1990" to match the reference list, or "Coquand and Paulin-Mohring, 1988
[published 1990]".

### Finding 15-2 (Severity: Low -- Imprecision)
**File:** `15-recursive-types.md`, Dreyer-Neis-Birkedal reference
**Claim:** Reference 13 cites "Derek Dreyer, Georg Neis, and Lars Birkedal
(2010)" with journal year 2012: "*JFP*, 22(4-5):477-528, 2012."
**Issue:** The body text (Section on Parametricity with Recursive Types)
says "Dreyer, Neis, and Birkedal (2010)" while the reference says 2012.
The POPL conference version appeared in 2010; the JFP journal version
appeared in 2012. The reference list year (2012) and the body text year
(2010) are inconsistent, though both are defensible depending on which
version is being cited.
**Correction:** Align the body text and reference list. If citing the journal
version, use 2012 in both places.

### Finding 15-3 (Severity: Negligible)
**File:** `15-recursive-types.md`, Scott Encodings
**Claim:** "Scott predecessor is O(1): `pred n = n (lambda x. x) 0`"
**Issue:** The predecessor for Scott-encoded naturals takes the successor
continuation and returns the predecessor directly. The term shown is correct:
`pred n = n (\x. x) 0` applies the number to two arguments; if it's `suc m`
then `(\x.x) m = m`, and if it's `0` then the result is `0`. This is correct.
**Correction:** None needed.

No other significant errors found.

---

## Document 16: Effects and Monads

### Finding 16-1 (Severity: Medium -- Attribution Error)
**File:** `16-effects-and-monads.md`, Section 5.1
**Claim:** "The idea of tracking effects in the type system originates with
David Gifford and John Lucassen's 'Integrating Functional and Imperative
Programming' (LFP 1986)."
**Issue:** The LFP 1986 paper is actually by John M. Lucassen and David K.
Gifford, with Lucassen as the first author. The document reverses the author
order (saying "David Gifford and John Lucassen"). While author order is not
always significant, it should be preserved accurately. The heading says
"Gifford and Lucassen (1986)" which also reverses the order. Reference 12
correctly lists "Gifford, D.K. and Lucassen, J.M." -- but actually, checking
the original paper, the authors are listed as "David K. Gifford and John M.
Lucassen" on the LFP 1986 paper. So the reference list reversal (Gifford
first) may actually be correct and the POPL 1988 paper has Lucassen first.
This is confusing but may not be an error.
**Correction:** Verify author order for the specific 1986 LFP paper vs the
1988 POPL paper. The 1986 paper has Gifford first; the 1988 paper has
Lucassen first.

### Finding 16-2 (Severity: Negligible -- Style)
**File:** `16-effects-and-monads.md`, Section 7.3
**Claim:** "control/prompt (Felleisen, 1988)" with paper title "The Theory
and Practice of First-Class Prompts"
**Issue:** Verified correct. The paper is at POPL 1988.
**Correction:** None needed.

### Finding 16-3 (Severity: Low -- Imprecision)
**File:** `16-effects-and-monads.md`, Section 3.1
**Claim:** "'Comprehending Monads' (1992): Showed that list comprehension
notation ... generalizes to arbitrary monads"
**Issue:** "Comprehending Monads" by Wadler was published in *Mathematical
Structures in Computer Science* 2(4), 1992. However, there was an earlier
conference version at LFP 1990. The document attributes the ideas to the
1992 journal version, which is fine.
**Correction:** None needed.

No other significant errors found in this document.

---

## Document 17: Universe Polymorphism

### Finding 17-1 (Severity: Medium -- Date Error)
**File:** `17-universe-polymorphism.md`, Section 1.1
**Claim:** "In 1970, Per Martin-Lof proposed a type theory with the axiom
Type : Type"
**Issue:** Same as Finding 12-1. The inconsistent system with Type : Type
appeared in a 1971 preprint, not 1970.
**Correction:** Change "In 1970" to "In 1971".

### Finding 17-2 (Severity: Medium -- Misattribution / Date)
**File:** `17-universe-polymorphism.md`, Section 1.1
**Claim:** "In 1972, Jean-Yves Girard demonstrated that this system is
inconsistent"
**Issue:** Girard's paradox is from his 1972 PhD thesis ("Interpretation
fonctionnelle et elimination des coupures de l'arithmetique d'ordre
superieur"). The inconsistency was communicated to Martin-Lof before the
thesis was completed, which is why the 1971 preprint was never published.
The document's attribution to 1972 is correct for the published thesis.
**Correction:** None strictly needed; the 1972 date refers to the thesis.

### Finding 17-3 (Severity: Medium -- Incorrect Date)
**File:** `17-universe-polymorphism.md`, Section 1.2 and Reference 4
**Claim:** "Coquand (1991)" for "An Analysis of Girard's Paradox" and
Reference 4 cites "Proceedings of the First Annual IEEE Symposium on Logic
in Computer Science (LICS '86)."
**Issue:** The reference says LICS '86 but cites Coquand (1991). Coquand's
"An Analysis of Girard's Paradox" was published at LICS 1986 (the first
LICS conference). The date "1991" in the body text is wrong; it should be
1986. The reference itself correctly identifies LICS '86 but then
parenthesizes (1991), which is contradictory. The paper was published in
1986 at LICS.
**Correction:** Change "Coquand 1991" to "Coquand 1986" in both the body
text and reference list. Reference 4 should read "(LICS '86). IEEE Computer
Society Press, 1986."

### Finding 17-4 (Severity: Low -- Imprecision)
**File:** `17-universe-polymorphism.md`, Section 5.2
**Claim:** "PLift (alpha : Sort u) : Type u -- lifts any sort (including
Prop) by one level"
**Issue:** In Lean 4, `PLift` is defined as
`structure PLift (a : Sort u) : Type u`. It lifts from `Sort u` to
`Type u` (i.e., from `Sort u` to `Sort (u+1)`). The document says it
"lifts any sort ... by one level," which is correct for the specific case
of lifting Prop (Sort 0) to Type 0 (Sort 1). However, for general Sort u,
PLift maps Sort u to Type u = Sort (u+1), which is indeed one level up.
The description is correct.
**Correction:** None needed.

### Finding 17-5 (Severity: Low -- Imprecision)
**File:** `17-universe-polymorphism.md`, Section 4.3
**Claim:** "Since Coq 8.0 (2004), Set is predicative by default"
**Issue:** Verified correct. Set was made predicative by default starting
from Coq 8.0, with the `-impredicative-set` flag available for backward
compatibility.
**Correction:** None needed.

### Finding 17-6 (Severity: Low -- Imprecision)
**File:** `17-universe-polymorphism.md`, Section 4.4
**Claim:** The description of Lean's `imax` operation
**Issue:** The document says "imax u v equals 0 when v = 0, and max(u, v)
otherwise." This is correct per Lean's definition.
**Correction:** None needed.

---

## Error Summary Table

| ID | Document | Severity | Category | Description |
|----|----------|----------|----------|-------------|
| 11-1 | 11 | Low | Date inconsistency | Hofmann-Streicher dated 1994 in text, 1998 in references |
| 11-2 | 11 | Negligible | Attribution | Proof-relevant unification origin (Cockx-Devriese 2016 vs Cockx-Abel 2018) |
| 12-1 | 12 | Medium | Date error | Martin-Lof Type:Type dated 1970, should be 1971 |
| 12-2 | 12 | Low | Imprecision | Voevodsky-Esquisse context could note Shabat |
| 12-3 | 12 | Low | Ambiguity | Voevodsky presheaves-with-transfers error timeline |
| 12-4 | 12 | Low | Omission | Boardman-Vogt book not named |
| 12-5 | 12 | Medium | Inconsistency | Hofmann-Streicher heading says 1998, body says 1994 |
| 12-6 | 12 | Low | Date imprecision | CCHM "originally presented at TYPES 2015" vs arXiv 2016 |
| 12-7 | 12 | Medium | Attribution error | Freudenthal suspension theorem attribution garbled |
| 13-1 | 13 | Low | Page range | Girard 1987 pages 1-102 vs 1-101 (ambiguous in literature) |
| 13-2 | 13 | Negligible | Redundancy | CBPV section overlaps with Doc 16 |
| 14-1 | 14 | Low | Terminology | "two-counter Turing machines" should be "two-counter machines" |
| 15-1 | 15 | Medium | Date inconsistency | Coquand-Paulin 1988 in text vs 1990 in reference list |
| 15-2 | 15 | Low | Date inconsistency | Dreyer-Neis-Birkedal 2010 in text vs 2012 in reference |
| 16-1 | 16 | Medium | Author order | Gifford-Lucassen author order needs verification per paper |
| 17-1 | 17 | Medium | Date error | Martin-Lof Type:Type dated 1970, should be 1971 |
| 17-3 | 17 | Medium | Date error | Coquand "Analysis of Girard's Paradox" dated 1991, should be 1986 |

### Severity Counts

| Severity | Count |
|----------|-------|
| Medium | 7 |
| Low | 8 |
| Negligible | 2 |
| **Total** | **17** |

### Most Critical Findings

1. **17-3 (Medium):** Document 17 cites Coquand's "An Analysis of Girard's
   Paradox" as "(1991)" and the reference lists it as "LICS '86" but with
   no coherent date. The correct date is 1986. This is a clear factual error
   in a citation.

2. **12-1 / 17-1 (Medium):** Both Documents 12 and 17 date Martin-Lof's
   Type:Type system to 1970. The correct date is 1971 (the preprint
   "A Theory of Types," Technical Report 71-3).

3. **12-7 (Medium):** The attribution of the Freudenthal suspension theorem
   formalization to "Lumsdaine and Licata" is garbled; the cited reference
   (Licata and Brunerie, LICS 2015) is a different paper.

4. **15-1 (Medium):** Coquand-Paulin body text says 1988, reference list
   says 1990. Should be consistent.

---

## Overall Assessment

The seven new documents are well-researched and largely accurate. The most
common category of error is date inconsistencies between body text and
reference lists (findings 11-1, 12-5, 15-1, 15-2). There are two instances
of a repeated date error (Martin-Lof 1970 vs 1971) across Documents 12 and
17, and one clear citation date error (Coquand 1991 vs 1986 in Document 17).
No fundamental conceptual or theoretical errors were found: all typing rules,
reduction rules, and theorem statements checked out as correct.
