# Coherence Review -- Cycle 2

## Scope

This review covers the integration of 7 new documents (Docs 11--17) with the existing 10 (Docs 01--10). The new documents are:

- **Doc 11:** Dependent Pattern Matching
- **Doc 12:** Homotopy Type Theory and Cubical Type Theory
- **Doc 13:** Linear and Substructural Type Systems
- **Doc 14:** Subtyping and Bounded Quantification
- **Doc 15:** Recursive Types
- **Doc 16:** Effects, Monads, and Computational Lambda Calculi
- **Doc 17:** Universe Polymorphism and Universe Hierarchies

---

## 1. Cross-Reference Gaps (Critical)

### 1.1 Six of seven new documents have no cross-references

Docs 11 and 12 (the first two new documents) include explicit cross-reference sections using the established "Doc NN" convention:

- **Doc 11** references Docs 06, 07, and 09 in its header and body.
- **Doc 12** has no "Doc NN" references at all despite obvious connections.

**Docs 12, 13, 14, 15, 16, and 17 contain zero cross-references to any other document in the corpus.** This is a significant regression from the pattern established in Docs 01--10, where cross-references were standard (either as a dedicated section or inline).

**Actionable fixes:**

| Document | Missing cross-references (add these) |
|----------|--------------------------------------|
| Doc 12 (HoTT) | Doc 05 (lambda cube), Doc 06 (CoC), Doc 07 (CIC), Doc 10 (metatheory), Doc 11 (dependent pattern matching -- the K axiom and deletion rule connect directly to HoTT) |
| Doc 13 (Linear types) | Doc 01 (untyped lambda calculus), Doc 02 (STLC -- structural rules), Doc 03 (System F -- Girard invented linear logic from studying System F's semantics) |
| Doc 14 (Subtyping) | Doc 03 (System F -- F<: extends System F), Doc 07 (CIC -- universe cumulativity), Doc 17 (universe polymorphism -- cumulativity as subtyping) |
| Doc 15 (Recursive types) | Doc 01 (untyped -- domain theory, Y combinator), Doc 02 (STLC -- strong normalization broken by recursive types), Doc 07 (CIC -- inductive types as disciplined recursive types), Doc 08 (coinduction -- greatest fixed points) |
| Doc 16 (Effects/Monads) | Doc 02 (STLC -- the pure calculus that effects extend), Doc 13 (linear types -- resource management connection) |
| Doc 17 (Universes) | Doc 05 (lambda cube -- the `* : Box` axiom), Doc 06 (CoC -- Prop/Type distinction), Doc 07 (CIC -- universe hierarchy in practice), Doc 14 (subtyping -- universe cumulativity) |

### 1.2 Existing documents do not reference new documents

None of Docs 01--10 reference any of Docs 11--17. This is expected (they were written first), but some backward links would strengthen coherence:

- **Doc 07 (CIC)** should reference Doc 11 (dependent pattern matching) as the elaboration of its `match` construct.
- **Doc 07 (CIC)** should reference Doc 17 (universe polymorphism) for the universe hierarchy treatment.
- **Doc 05 (Lambda Cube)** should reference Doc 17 for universe polymorphism beyond the cube.
- **Doc 10 (Metatheory)** should reference Doc 12 (HoTT -- canonicity and homotopy canonicity).

---

## 2. Notation Inconsistencies

### 2.1 Substitution notation (persists from Cycle 1, now worse)

Cycle 1 identified three substitution notations across Docs 01--10. The new documents introduce no new notations but perpetuate the inconsistency:

| Notation | Used in |
|----------|---------|
| `M[x := N]` (colon-equals) | Docs 01, 02, 04, 09, 10, 11, 16 (partially) |
| `t[s/x]` or `M[N/x]` (slash) | Docs 03, 05, 06, 07, 13, 15, 16 (partially) |
| `[x := v] e` (prefix) | Doc 02 (beta-reduction rule only) |

**Doc 13 (Linear types)** uses the slash notation `M[N/x]` consistently.
**Doc 15 (Recursive types)** uses the slash notation `tau[mu alpha. tau / alpha]` consistently.
**Doc 16 (Effects/Monads)** uses both: `N[V/x]` in reduction rules and `N[k := lambda x...]` in the delimited continuations section.

**Fix:** Adopt `t[x := s]` as the corpus standard (matching the majority of existing documents). Update Docs 03, 05, 06, 07, 13, and 15 to use it. Note the slash convention as an alternative in Doc 01 only.

### 2.2 Reduction arrow notation

The new documents use inconsistent reduction arrows:

- **Doc 11** uses `-->` (ASCII).
- **Doc 13** uses `⟶` (Unicode long arrow).
- **Doc 15** uses `-->` (ASCII).
- **Doc 16** uses `-->` (ASCII) and `=` for equational rules.

The existing documents also vary: Docs 01, 02, 05, 07 use `-->` or `->_beta`; Docs 03, 04 use `⟶_β` (Unicode). This was not flagged in Cycle 1 but is now more noticeable with 17 documents. Recommend standardizing on Unicode `⟶` for reduction and reserving `→` for function types.

### 2.3 Lambda notation in new documents

- **Doc 13 (Linear types)** uses `λx. M` (no type annotation) for the linear lambda calculus. This is appropriate for Curry-style, but it should note that this differs from the Church-style `λx:τ. e` used in Docs 02--07.
- **Doc 15 (Recursive types)** uses `lambda x : D` (ASCII, with spaces and colon). The existing documents use either `λx:τ. e` (Unicode) or `\x:T. e` (backslash). This is a third convention.
- **Doc 16 (Effects/Monads)** uses `lambda x:A. M` (ASCII) in the metalanguage.

**Fix:** Standardize on `λx:τ. e` (Unicode lambda, colon annotation) for Church-style typed calculi. Use ASCII `lambda` only in code blocks showing specific language syntax (Coq, Agda, etc.).

---

## 3. Terminology Consistency

### 3.1 "STLC" naming

- Docs 02, 13, 14, 15 all use "STLC" or "simply typed lambda calculus" consistently.
- Doc 16 refers to "the simply typed lambda calculus" without the abbreviation STLC. Minor but worth standardizing.

### 3.2 "CIC" usage

- Doc 11 correctly refers to "CIC (Doc 07)" and "MLTT."
- Doc 17 discusses CIC-based systems (Coq, Lean) but never uses the abbreviation "CIC" itself, instead saying "Calculus of Inductive Constructions" in full or referring to individual proof assistants. This is fine but a parenthetical "(CIC, see Doc 07)" would aid navigation.

### 3.3 "Inductive types" vs "recursive types" vs "algebraic data types"

Doc 15 (Recursive types) and Doc 07 (CIC) cover overlapping territory from different angles:

- **Doc 07** treats inductive types as primitives with strict positivity and structural recursion.
- **Doc 15** treats recursive types via a general mu-binder, covering iso-recursive and equi-recursive approaches.

The relationship between these treatments is never explicitly stated. Doc 15 mentions the positivity restriction in passing (line 288: "Strict positivity: The recursive variable must not appear in negative position... This is the approach taken by Coq/Lean/Agda.") but does not reference Doc 07. A cross-reference here would close the gap.

### 3.4 Coinductive types in Doc 15 vs Doc 08

Doc 15 discusses greatest fixed points (`nu`) and mentions Mendler-style corecursion, but does not reference Doc 08 (Coinduction), which covers the same territory in much greater depth. Add a forward reference.

---

## 4. Narrative Arc Assessment

### 4.1 Overall coherence

The 17-document corpus now covers five rough clusters:

1. **Core lambda calculi** (Docs 01--06): Untyped through CoC. Well-integrated.
2. **Dependent types in practice** (Docs 07, 08, 11, 17): CIC, coinduction, pattern matching, universes. Doc 11 integrates well; Doc 17 is standalone.
3. **Homotopy foundations** (Doc 12): Self-contained, somewhat disconnected from the main arc.
4. **Extensions and variations** (Docs 13, 14, 15): Linear types, subtyping, recursive types. Each is self-contained with minimal integration.
5. **Implementation and metatheory** (Docs 09, 10, 16): Cross-cutting concerns.

The main narrative arc (Cluster 1) remains coherent. The new documents in Clusters 3--4 are topically appropriate but structurally isolated. They read as independent reference documents rather than chapters in a connected story.

### 4.2 Doc 12 (HoTT) positioning

Doc 12 covers HoTT and cubical type theory comprehensively but is disconnected from the rest of the corpus. Key connections that should be made explicit:

- HoTT is based on Martin-Lof type theory, which is closely related to CIC (Doc 07).
- The axiom K / UIP discussion in Doc 12 directly relates to Doc 11's deletion rule in pattern matching unification (Doc 11 Section 3.2 discusses this well; Doc 12 should reference it).
- Cubical type theory extends the CoC (Doc 06) with path types and Kan operations.
- Doc 05 already references Doc 08 as "Cubical Type Theory" in its cross-references, but this label is wrong -- Doc 08 is about coinductive constructions, not cubical type theory. This is a pre-existing error that becomes more visible now that Doc 12 actually covers cubical type theory.

### 4.3 Doc 16 (Effects/Monads) positioning

Doc 16 is well-written but has no connections to the rest of the corpus. Key missing links:

- Moggi's computational lambda calculus extends the STLC (Doc 02).
- The relationship between linear types (Doc 13) and effect systems is noted in the literature but not in the corpus.
- Call-by-push-value (Doc 16 Section 4) clarifies the value/computation distinction relevant to implementation (Doc 09).

---

## 5. Redundancy Check

### 5.1 Universe hierarchies

Universe hierarchies are discussed in:
- **Doc 05** (lambda cube -- two sorts `*` and `Box`).
- **Doc 07** (CIC -- `Prop`, `Set`, `Type(i)`).
- **Doc 14** (Subtyping -- universe cumulativity as subtyping, Section "Universe Cumulativity as Subtyping").
- **Doc 17** (Universe Polymorphism -- comprehensive treatment).

Doc 14's treatment of universe cumulativity overlaps significantly with Doc 17's Sections 4--5. The overlap is acceptable if cross-references are added, but currently neither document references the other.

### 5.2 Girard's paradox

Girard's paradox is discussed in:
- **Doc 05** (Section on System U).
- **Doc 17** (Section 1.2, "Girard's Paradox in Detail").

Doc 17's treatment is more detailed (includes Hurkens' simplification). Both are well-written but should reference each other.

### 5.3 Strict positivity

Strict positivity is discussed in:
- **Doc 07** (CIC -- Section on the positivity condition for inductive types).
- **Doc 15** (Recursive types -- briefly, as a way to preserve normalization).

No cross-reference exists. Add one.

---

## 6. Specific Errors

### 6.1 Doc 05 cross-reference error (pre-existing)

Doc 05's cross-references section (lines 843--849) contains:

- "Doc 07 (Lean's Type Theory)" -- Doc 07 is about the Calculus of Inductive Constructions, not specifically Lean's type theory.
- "Doc 08 (Cubical Type Theory)" -- Doc 08 is about coinductive constructions, not cubical type theory.

These are factual errors in the cross-reference labels that should have been caught in Cycle 1. They are now more confusing because Doc 12 actually covers cubical type theory.

**Fix:** Correct Doc 05's cross-references to:
- "Doc 07 (Calculus of Inductive Constructions)"
- "Doc 08 (Coinductive Constructions)"
- Add: "Doc 12 (HoTT and Cubical Type Theory)"

---

## 7. Priority Action Items

**Critical (blocks coherence):**
1. Add cross-reference sections to Docs 12, 13, 14, 15, 16, and 17, following the convention of Docs 01--11.
2. Fix Doc 05's incorrect cross-reference labels for Docs 07 and 08.

**High priority (notation consistency):**
3. Standardize substitution notation to `t[x := s]` across all 17 documents.
4. Standardize lambda notation to Unicode `λ` in formal rules (allow ASCII in code blocks).

**Medium priority (narrative integration):**
5. Add backward references from Docs 07 and 10 to the new documents they connect to.
6. Add a connecting paragraph in Doc 15 (Recursive types) noting the relationship between general mu-types and CIC's inductive types (Doc 07).
7. Add mutual references between Doc 14 (universe cumulativity section) and Doc 17 (universe cumulativity section).
8. Add mutual references between Doc 15 (greatest fixed points) and Doc 08 (coinduction).

**Low priority (polish):**
9. Standardize reduction arrow notation across all documents.
10. Add "CIC (Doc 07)" parentheticals in Docs 12 and 17 where the Calculus of Inductive Constructions is discussed.
