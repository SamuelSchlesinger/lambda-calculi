# Accuracy Review -- Cycle 1

Reviewer: Automated accuracy review
Date: 2026-03-22

This review examines all 10 summary documents for factual errors, imprecisions, misattributions, and unsupported claims.

---

## Document 01: Untyped Lambda Calculus

### Finding 1.1 -- Kleene-Rosser paradox characterization
**Claim (line 38):** "Using Godel's arithmetization technique, they showed that Richard's paradox could be derived within the systems."
**Issue:** The Kleene-Rosser paradox is not a derivation of Richard's paradox per se. Kleene and Rosser used a diagonal/self-referential argument (closer to the Richard paradox in flavor) to show inconsistency, but characterizing it as deriving "Richard's paradox" is misleading. The result is its own paradox -- a derivation of a contradiction using a Godelian diagonal argument. The connection to Richard's paradox is loose and informal.
**Severity:** Minor imprecision.

### Finding 1.2 -- Turing 1936 page numbers
**Claim (line 70):** Turing's paper appeared on pages "230--265."
**Issue:** The correct pagination of Turing's 1936 paper in the Proceedings of the London Mathematical Society, Series 2, Volume 42, is pages 230--265, with a correction in volume 43 (1937), pages 544--546. The citation is correct as given but could note it is Series 2.
**Severity:** Negligible.

### Finding 1.3 -- Exponentiation encoding
**Claim (line 673):** "exp = lambda m. lambda n. n m" with comment "n^m; applies m to n."
**Issue:** The Church encoding `exp = lambda m. lambda n. n m` computes m^n, not n^m. Church numeral exponentiation `exp b e = e b` gives b^e. With the given definition `exp m n = n m`, this is m^n. The comment "n^m" is incorrect; it should be "m^n". (Applying the Church numeral n to function m yields m composed n times, i.e., m^n.)
**Correction:** The comment should read "m^n" rather than "n^m".
**Severity:** Error.

### Finding 1.4 -- Scott-Curry theorem dates
**Claim (line 771):** "Theorem (Scott, 1963; Curry, 1969)."
**Reference (line 787):** "Scott, D.S. (1975). 'Lambda calculus: Some models, some philosophy.'"
**Issue:** The theorem is attributed to "Scott, 1963" but the reference given is Scott 1975. Scott's result dates from an unpublished 1963 lecture/manuscript, which was later published in 1975. The 1963 date for Scott and 1969 date for Curry are conventionally accepted. No error per se, but the reference is to the later publication, which should be noted.
**Severity:** Negligible.

### Finding 1.5 -- Bohm's theorem date
**Claim (line 798):** "Theorem (Bohm, 1968)."
**Issue:** Bohm's separability result is traditionally dated to 1968 (the publication year of his note). This is correct.
**Severity:** No error.

### Finding 1.6 -- xor encoding
**Claim (line 647):** "xor = lambda p. lambda q. p (q false true) q"
**Issue:** This encoding is incorrect. When p = true: `true (q false true) q` reduces to `q false true`, which for q = true gives `false` and q = false gives `true` -- correct. When p = false: `false (q false true) q` reduces to `q`. For q = true this gives `true`, but xor(false, true) should be `true` -- correct. For q = false this gives `false`, and xor(false, false) should be `false` -- correct. Actually, checking more carefully: this is correct for xor. No error.
**Severity:** No error (retracted upon verification).

---

## Document 02: Simply Typed Lambda Calculus

### Finding 2.1 -- STLC-definable functions claim
**Claim (line 518-520):** "The set of STLC-definable functions over the natural numbers (with Church numerals or in System T) includes all functions provably total in Peano arithmetic, but not all computable functions."
**Issue:** This conflates STLC with System T. The pure STLC (even with Church numerals) can only define extended polynomials -- a very weak class of functions. System T (STLC + primitive recursion on Nat) can express all functions provably total in first-order Peano Arithmetic, which is much stronger but still not all computable functions. The claim as written is imprecise because it lumps "STLC with Church numerals" and "System T" together, when their expressive power differs drastically.
**Correction:** Should say "System T (STLC extended with natural numbers and primitive recursion) can express all functions provably total in Peano arithmetic." Pure STLC with Church numerals is far weaker.
**Severity:** Significant imprecision.

### Finding 2.2 -- Kleene-Rosser paradox and Russell's paradox
**Claim (line 32):** "Kleene and Rosser (1935) showed that the untyped system was logically inconsistent -- it could encode Russell's paradox."
**Issue:** The Kleene-Rosser paradox is not Russell's paradox. It uses a different diagonal argument (as noted in Document 01, it is closer to Richard's paradox). Russell's paradox concerns set self-membership; the Kleene-Rosser paradox uses arithmetization and a different construction. This is a mischaracterization.
**Correction:** "it could encode a variant of the liar/Richard paradox" or simply "the system was inconsistent."
**Severity:** Error in characterization.

### Finding 2.3 -- Goedel 1958 System T
**Claim (line 814-815):** "System T (Goedel 1958) is STLC extended with natural numbers and primitive recursion."
**Issue:** This is correct. Goedel's Dialectica interpretation paper is from 1958.
**Severity:** No error.

---

## Document 03: System F

### Finding 3.1 -- Girard's supervisor
**Claim (line 15):** Girard's thesis was "completed at Universite Paris VII under the supervision of Jean-Louis Krivine."
**Issue:** This requires verification. Girard's thesis was indeed at Universite Paris VII. The supervisor is not always uniformly reported in secondary sources. Some sources list the thesis advisor differently. However, Krivine is commonly cited as the advisor.
**Severity:** Likely correct; low confidence.

### Finding 3.2 -- Representation Theorem characterization
**Claim (line 19):** "every function on natural numbers that can be proved total in second-order intuitionistic predicate logic (P2) can be represented as a term in System F (F2)."
**Issue:** The precise statement is about provably total functions of second-order Peano arithmetic (PA2 / HA2), not second-order predicate logic generically. Additionally, the converse direction (that System F definable functions are exactly the provably total functions of second-order arithmetic) is the full characterization. The statement as written is one direction and is not wrong but uses "second-order intuitionistic predicate logic" loosely. The standard reference is second-order Heyting arithmetic (HA2).
**Severity:** Minor imprecision.

### Finding 3.3 -- Church numeral encoding
**Claim (line 206):** "Church naturals: Nat = forall alpha : *. alpha -> (alpha -> alpha) -> alpha"
**Issue:** The order of arguments is non-standard. The standard Church numeral type is `forall alpha. (alpha -> alpha) -> alpha -> alpha`, with the successor function first and the zero element second. In the main System F document (line 222), it is given correctly as `Nat = forall alpha. (alpha -> alpha) -> alpha -> alpha`. However, in the lambda cube document, the order is reversed. This inconsistency could cause confusion but the reversed order is a valid alternative encoding.
**Severity:** Minor inconsistency across documents (not an error per se).

### Finding 3.4 -- Reynolds impossibility year
**Claim (line 615):** "Reynolds (1984) proved a fundamental negative result."
**Issue:** Reynolds' paper "Polymorphism is not set-theoretic" was presented at a 1984 conference and published in LNCS 173. This is correct.
**Severity:** No error.

### Finding 3.5 -- Kfoury and Wells 1999 for rank-2
**Claim (line 571):** "Rank 2: Decidable, Kfoury and Wells (1999)."
**Issue:** The decidability of rank-2 type inference (typability) was shown by Kfoury and Wells, but the precise attribution deserves care. Kfoury and Wells (1999, POPL) showed decidability for rank-2 intersection types. The decidability of rank-2 polymorphism for System F specifically was shown earlier. The citation is acceptable but slightly imprecise in context.
**Severity:** Minor.

---

## Document 04: System F-omega

### Finding 4.1 -- PTS rules for CoC
**Claim (line 334):** "Compare with... the Calculus of Constructions, which has all four rules including (*, Box, Box) for dependent types."
**Issue:** The missing rule that CoC adds to System F-omega is `(*, Box)` (types depending on terms / dependent types), not `(*, Box, Box)`. In the lambda cube PTS convention where rules are (s1, s2) with the product landing in s2, the dependent types rule is written `(*, Box)`. However, in full PTS notation, `(*, Box, Box)` means "if A : * and B : Box then Pi(x:A).B : Box", which is indeed the dependent types rule. So the statement is correct in full PTS notation, but the label "for dependent types" applied to `(*, Box, Box)` is correct.
**Severity:** No error.

### Finding 4.2 -- Lambda cube table notation
**Claim (line 302-318):** The lambda cube table lists "lambda-omega" at position 1+2 as "System F-omega" but uses the notation "lambda-omega" with the underline absent.
**Issue:** In Barendregt's notation, lambda-underline-omega (with underline) is type operators alone (no polymorphism), while lambda-omega (without underline) is System F-omega (polymorphism + type operators). The table correctly distinguishes these in the "System" column (line 314 says "lambda-omega (System F-omega)"), so this is fine. However, in the Curry-Howard table (lines 438-448), the entry for "lambda-omega" says "Propositional logic with higher-order predicates," which should be for lambda-underline-omega (weak omega, type operators only). The entry for System F-omega should be "Higher-order propositional intuitionistic logic." Looking more carefully, the table has separate entries for both. This is correct.
**Severity:** No error.

### Finding 4.3 -- Seely 1987 characterization
**Claim (line 403):** "The standard approach uses hyperdoctrines (Seely 1987)."
**Issue:** Seely's 1987 paper is about categorical semantics for System F, not hyperdoctrines in general. The term "hyperdoctrine" was introduced by Lawvere (1969). Seely used a PL-category (polymorphic lambda-category) framework. Calling it "hyperdoctrines" is a simplification. Seely's paper showed that locally cartesian closed categories with additional structure model System F, using indexed categories. The term is loosely applied here.
**Severity:** Minor imprecision.

---

## Document 05: Lambda Cube

### Finding 5.1 -- PTS rule for dependent types
**Claim (line 250):** "R = {(*, *, *), (*, box, box)}" for lambda-P.
**Issue:** This is correct. In the lambda cube, the dependent types rule `(*, box)` becomes `(*, box, box)` in full PTS notation since s3 = s2 = box.
**Severity:** No error.

### Finding 5.2 -- System U specification
**Claim (lines 595-599):** System U has "S = {*, box, triangle}, A = {(*, box), (box, triangle)}, R = {(*, *), (box, *), (box, box)}."
**Issue:** This is the specification of System U-minus, not System U. System U additionally includes the rule `(triangle, *)`. The document says "System U (and its fragment System U-minus)" and then gives one specification. Since the specification given lacks `(triangle, *)`, it is actually U-minus. The text conflates the two.
**Correction:** The specification given is for System U-minus. System U has the additional rule `(triangle, *)` (or sometimes presented differently depending on the source). The text should clarify which system the specification belongs to.
**Severity:** Error.

### Finding 5.3 -- Girard's paradox discovery
**Claim (line 615-616):** "This was first discovered by Jean-Yves Girard in 1972, who showed that System U is inconsistent."
**Issue:** Girard discovered the paradox (inconsistency of System U) as part of his 1972 thesis work, but the explicit connection to System U as a PTS came later. The dating is approximately correct. Martin-Lof's original (1971) type theory with Type:Type was shown inconsistent by Girard's technique.
**Severity:** No error.

### Finding 5.4 -- ECC attribution
**Claim (line 654):** "The Extended Calculus of Constructions (ECC): Adds a hierarchy of universes... Due to Zhaohui Luo (1989)."
**Issue:** Luo's ECC thesis was completed in 1990 (PhD, University of Edinburgh), with publications starting from 1989. The 1989 date is acceptable for the initial publication.
**Severity:** No error.

### Finding 5.5 -- Abstraction rule in PTS
**Claim (lines 421-425):** The PTS abstraction rule in the lambda cube section checks "Gamma |- A : s1" and "Gamma, x : A |- B : s2" separately, but the PTS section (lines 533-536) uses "Gamma |- Pi(x:A).B : s" instead.
**Issue:** The document correctly notes (lines 550-553) that the PTS abstraction rule "differs slightly from the lambda cube presentation." This is a known distinction. The lambda cube version requires checking A and B have appropriate sorts separately; the PTS version requires the product type to be well-typed. The two are equivalent for lambda cube systems but differ for exotic PTS. This is correctly explained.
**Severity:** No error (well-handled).

---

## Document 06: Calculus of Constructions

### Finding 6.1 -- CoC publication venue
**Claim (line 29):** "The initial presentation appeared at EUROCAL '85."
**Issue:** The first presentation of the Calculus of Constructions was at EUROCAL 1985 as stated. However, the conference name was actually a joint EUROCAL conference. The 1985 paper by Coquand and Huet appeared in the proceedings of the EUROCAL conference. This is correct.
**Severity:** No error.

### Finding 6.2 -- Coquand's thesis date and institution
**Claim (line 25):** "Thierry Coquand presented the first version of the Calculus of Constructions in his PhD thesis at the University of Paris VII, defended on January 31, 1985."
**Issue:** Coquand's thesis was indeed defended in January 1985 at Paris VII. This appears correct.
**Severity:** No error.

### Finding 6.3 -- The rule (Box, *) description
**Claim (line 154):** "(Box, *) -- Terms depending on types (polymorphism). If A : Type and B : Prop (possibly depending on x : A), then Pi(x : A). B : Prop. This allows universal quantification over types in propositions -- e.g., forall(alpha : Type). alpha -> alpha is a proposition (the type of the polymorphic identity)."
**Issue:** The example "forall(alpha : Type). alpha -> alpha" is stated to be a proposition (in Prop). However, `alpha -> alpha` has sort Prop only if alpha : Prop. If alpha : Type, then `alpha -> alpha` has sort Type (by the rule (Box, Box)). So `forall(alpha : Type). alpha -> alpha` has sort Prop only if the body `alpha -> alpha` is in Prop for all alpha : Type. But `alpha -> alpha` is formed by (Box, Box) or (*, *) depending on the sort of alpha. When alpha : Type, the type `alpha` has sort Type, so `alpha -> alpha : Type` (by rule (Box, Box)). Then `forall(alpha : Type). (alpha -> alpha)` would have sort... wait. We need to check: `alpha : Type` so `alpha : Box`. The body `alpha -> alpha` is `Pi(_ : alpha). alpha`. Here alpha : * (since alpha is a term variable of type Type, i.e., alpha : Box... no. Let me reconsider. In CoC, `Type` is Box. A variable `alpha : Type` means `alpha` has sort Box, so alpha is a type-level entity. Then `alpha` has sort `*` (since alpha : Type means we declared alpha : Type in context, and Type = Box, so this reads as alpha : Box). Actually, this is getting into subtle PTS territory. The point is: `forall(alpha : Type). alpha -> alpha` is actually of sort `*` (Prop) by the rule (Box, *), since the domain `Type` has sort Box and the codomain `alpha -> alpha` has sort `*`. But wait, `alpha -> alpha` has sort `*` only if alpha : *. But alpha : Type means alpha : Box. So `alpha` is a sort-Box entity, and `alpha -> alpha` = `Pi(_ : alpha). alpha` where the domain `alpha : Box` and codomain `alpha : Box`, giving `Pi(_ : alpha). alpha : Box` by rule (Box, Box). So the body has sort Box, not *. Then `forall(alpha : Type). Pi(_ : alpha). alpha` has domain sort Box and body sort Box, giving sort Box by (Box, Box), not Prop.

Actually, I think the example is wrong. `forall(alpha : Type). alpha -> alpha` does NOT have sort Prop. The correct example for (Box, *) would be something like `forall(alpha : Type). P alpha` where `P alpha : Prop`.
**Correction:** The example is incorrect. `forall(alpha : Type). alpha -> alpha` has sort `Type` (Box), not `Prop`. A correct example for the (Box, *) rule producing a proposition would be `forall(A : Type). A -> A -> Prop` or a specific proposition that quantifies over types, like a Leibniz equality.
**Severity:** Error.

### Finding 6.4 -- Paulin-Mohring and Pfenning attribution
**Claim (line 38):** "Christine Paulin-Mohring and Frank Pfenning extended CoC with primitive inductive types."
**Issue:** The original extension of CoC with inductive types was by Coquand and Paulin-Mohring (1990, COLOG-88), and separately by Pfenning and Paulin-Mohring (1989). Pfenning's role was specifically in the MFPS 1989 paper. The joint attribution is correct. However, the CIC as implemented in Coq is primarily due to Paulin-Mohring's work (her thesis and the 1993 TLCA paper).
**Severity:** No error.

---

## Document 07: Calculus of Inductive Constructions

### Finding 7.1 -- Lean 1.0 release date
**Claim (line 69):** "2014: Lean 1.0 released (using a CIC variant)."
**Issue:** Lean 1.0 was released around 2014. The first CADE paper about Lean was from 2015. The 2014 date for "Lean 1.0" is approximately correct, though the exact release date of version 1.0 is debatable. Lean 2 was the first widely used version.
**Severity:** Minor, approximately correct.

### Finding 7.2 -- Werner equiconsistency claim
**Claim (lines 896-904):** "CIC with n universes is equiconsistent with ZFC + n inaccessible cardinals."
**Issue:** This is the standard claim from Werner (1997), "Sets in Types, Types in Sets." The precise statement requires careful formulation (it depends on which exact variant of CIC is used, and whether we include the impredicative Prop). Werner's result establishes mutual interpretability, which is close to equiconsistency but technically distinct. The claim as stated is standard in the literature.
**Severity:** Minor simplification of a technical result.

### Finding 7.3 -- Dybjer 1997 for W-types encoding
**Claim (line 741):** "Dybjer (1997) showed that non-nested strictly positive inductive types can be represented using W-types."
**Issue:** Dybjer's 1994 paper "Inductive Families" is the relevant reference for the treatment of inductive families. The encoding of inductive types via W-types has been studied by multiple authors. The 1997 date may refer to a different Dybjer paper or be a misattribution. The standard reference for encoding inductive types as W-types is Abbott, Altenkirch, and Ghani (2004-2005). Dybjer's contributions are more about the general theory of inductive families.
**Correction:** The attribution "Dybjer (1997)" for the W-type encoding claim needs verification. The 2004 Abbott-Altenkirch-Ghani paper is the standard reference for showing W-types encode strictly positive types.
**Severity:** Possible misattribution.

---

## Document 08: Coinductive Constructions

### Finding 8.1 -- Park 1981 and bisimulation history
**Claim (lines 29-31):** "David Park (1981) made the crucial observation that Milner's equivalence was not actually a fixed point of the relevant functional."
**Issue:** The historical narrative is slightly misleading. Milner's observational equivalence was defined as the largest relation satisfying certain conditions, which is indeed a greatest fixed point. Park's contribution was to formalize and name "bisimulation" and to develop the proof technique. The claim that Milner's equivalence "was not actually a fixed point" is debatable -- it depends on which functional is considered. Park formalized the correct functional and showed that bisimilarity (greatest fixed point) was the right notion.
**Severity:** Minor historical imprecision.

### Finding 8.2 -- Forti and Honsell 1983
**Claim (line 19):** "Aczel's Anti-Foundation Axiom (AFA), first studied by Forti and Honsell (1983)."
**Issue:** This is correct. Forti and Honsell studied non-well-founded set theories before Aczel's 1988 monograph popularized the AFA. The attribution is accurate.
**Severity:** No error.

### Finding 8.3 -- Sized types introduction date
**Claim (line 490):** "Sized types, introduced by Hughes, Pareto, and Sabry (1996)."
**Issue:** This is correct. The Hughes, Pareto, and Sabry POPL 1996 paper is the standard first reference for sized types.
**Severity:** No error.

---

## Document 09: Implementation Techniques

### Finding 9.1 -- Landin SECD machine date
**Claim (line 570):** "The SECD machine (Landin, 1964)."
**Issue:** Landin's paper "The Mechanical Evaluation of Expressions" appeared in The Computer Journal in 1964. This is correct.
**Severity:** No error.

### Finding 9.2 -- Huet undecidability year
**Claim (line 411):** "Unification modulo beta-eta-equality is undecidable in general (Huet, 1973)."
**Issue:** Huet's 1973 paper "The Undecidability of Unification in Third Order Logic" (Information and Control) showed undecidability of third-order unification. Second-order unification was shown undecidable by Goldfarb (1981). The claim about "beta-eta-equality" unification being undecidable in general is correct, but the specific attribution to Huet 1973 is for third-order; the general higher-order case follows. This is an acceptable simplification.
**Severity:** Minor imprecision.

### Finding 9.3 -- Krivine machine publication
**Claim (line 592):** "The Krivine machine (Krivine, 2007, describing work from the 1980s)."
**Issue:** This is correct. Krivine's work on his abstract machine dates from the 1980s but was formally published as "A call-by-name lambda-calculus machine" in Higher-Order and Symbolic Computation in 2007.
**Severity:** No error.

---

## Document 10: Metatheory and Correctness

### Finding 10.1 -- System U-minus rules
**Claim (lines 357-358):** "System U has sorts *, Box with axioms * : Box and rules (*, *), (Box, *), (Box, Box). System U-minus drops the (Box, Box) rule but remains inconsistent."
**Issue:** This contradicts the specification given in Document 05. More importantly, System U-minus is usually defined as having rules {(*, *), (Box, *), (Box, Box)} with an EXTRA sort triangle and axioms {(*, Box), (Box, triangle)} and additional rules. The description here oversimplifies and is inconsistent with Document 05's specification of System U. The standard System U (Girard) has three sorts and the inconsistency arises from having impredicative quantification at the level of Box (the rule (triangle, *) or equivalent). The description in this document is too simplified.
**Correction:** The specification of System U and U-minus should be made consistent across documents. System U has three sorts {*, Box, triangle}, two axioms {* : Box, Box : triangle}, and specific rules. System U-minus is a fragment that is still inconsistent.
**Severity:** Error (inconsistency across documents and oversimplification).

### Finding 10.2 -- Barbanera and Berardi attribution
**Claim (lines 393-399):** "Barbanera and Berardi (1996) showed that in the Calculus of Constructions, the combination of: 1. Excluded middle... 2. Strong elimination from large types... implies proof irrelevance."
**Issue:** The result about excluded middle + strong elimination implying proof irrelevance is sometimes attributed to Berardi alone (1990), and sometimes to Barbanera and Berardi (1996). The 1996 JFP paper is the standard reference. This attribution is correct.
**Severity:** No error.

### Finding 10.3 -- Statman 1979 characterization
**Claim (line 517-518):** "Statman (1979) showed that the normalization problem for STLC is not elementary recursive."
**Issue:** Statman's 1979 paper shows that the typed lambda-calculus is not elementary recursive -- specifically, that the function mapping a typed term to its normal form grows non-elementarily. This is correct.
**Severity:** No error.

### Finding 10.4 -- Appel and McAllester 2001
**Claim (line 215):** "Introduced by Appel and McAllester (2001) for foundational proof-carrying code."
**Issue:** This is correct. The 2001 TOPLAS paper by Appel and McAllester introduced step-indexed logical relations.
**Severity:** No error.

---

## Cross-Document Issues

### Finding X.1 -- System U specification inconsistency
Documents 05 and 10 give different specifications for System U/U-minus. Document 05 gives a three-sort specification; Document 10 gives a two-sort specification. These cannot both be correct. The standard definition uses three sorts.
**Severity:** Error.

### Finding X.2 -- Church numeral argument order inconsistency
Document 03 (line 222) uses `Nat = forall alpha. (alpha -> alpha) -> alpha -> alpha` (successor first, zero second). Document 05 (line 206) uses `Nat = forall alpha : *. alpha -> (alpha -> alpha) -> alpha` (zero first, successor second). Both are valid encodings, but the inconsistency may cause confusion when cross-referencing.
**Severity:** Minor inconsistency.

### Finding X.3 -- Consistent use of "Calculus of Constructions" dates
The CoC is dated 1985-1988 across documents, which is correct (thesis 1985, journal 1988). This is handled well.
**Severity:** No error.

---

## Summary of Findings

| ID | Document | Severity | Category |
|----|----------|----------|----------|
| 1.3 | 01-untyped | Error | Formal definition |
| 2.1 | 02-stlc | Significant imprecision | Technical precision |
| 2.2 | 02-stlc | Error | Historical claim |
| 5.2 | 05-lambda-cube | Error | Formal definition |
| 6.3 | 06-coc | Error | Formal definition / example |
| 7.3 | 07-cic | Possible misattribution | Citation |
| 10.1 | 10-metatheory | Error | Formal definition |
| X.1 | 05 vs 10 | Error | Cross-document inconsistency |

### Errors requiring correction:
1. **Doc 01, line 673:** Exponentiation comment says "n^m" but should say "m^n".
2. **Doc 02, line 32:** Kleene-Rosser paradox is mischaracterized as encoding "Russell's paradox."
3. **Doc 02, lines 518-520:** Conflation of STLC with System T regarding expressiveness.
4. **Doc 05, lines 595-599:** System U specification is actually System U-minus; should be clarified.
5. **Doc 06, line 154:** Example `forall(alpha : Type). alpha -> alpha` is claimed to be in Prop; it is actually in Type.
6. **Doc 10, lines 357-358:** System U specification is inconsistent with Document 05 and oversimplified.
