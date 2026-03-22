# Cockx, Devriese, Piessens 2014 — Pattern Matching without K

**Full Citation:**
Jesper Cockx, Dominique Devriese, and Frank Piessens. "Pattern Matching without K."
In *Proceedings of the 19th ACM SIGPLAN International Conference on Functional
Programming (ICFP 2014)*, pp. 257–268. ACM, 2014.
DOI: 10.1145/2628136.2628139

**PDF Source:** https://jesper.sikanda.be/files/pattern-matching-without-K.pdf

## Summary

This paper proposes a new criterion for determining when a definition by dependent
pattern matching is valid without relying on axiom K (uniqueness of identity proofs).
The criterion is proven correct by translation to eliminators in the style of
Goguen et al. (2006), but without using K in the translation.

## Motivation

Dependent pattern matching as formalized by Coquand (1992) implicitly relies on
axiom K. This axiom states that any proof of `x = x` is equal to `refl`, which is
incompatible with Homotopy Type Theory (HoTT), where identity types can have
non-trivial higher structure (e.g., in the universe, identity proofs correspond
to type isomorphisms, and there can be many distinct isomorphisms).

Agda had an experimental `--without-K` flag that attempted to detect K-dependent
definitions via a syntactic check, but this check:
- Was too conservative (rejecting valid definitions)
- Had a previously undetected bug (accepting some invalid definitions)
- Lacked a formal correctness proof

## Key Contributions

### 1. The K-free Criterion

A pattern matching definition is K-free if every unification step in the case
splitting can be justified without K. The critical distinction is:

- **deletion** (`x = x` implies nothing new): This step uses K and must be
  forbidden in a K-free setting.
- **conflict** (distinct constructors cannot be equal): K-free.
- **injectivity** (constructors are injective): K-free.
- **cycle detection** (x cannot equal a term containing x): K-free.
- **solution** (x = t where x is fresh): K-free.

The paper identifies exactly which unification steps require K (deletion of
reflexive equations) and which are justified by the standard rules of type theory.

### 2. Formal Correctness

The authors prove that any definition accepted by their criterion can be translated
to eliminator-based terms using only J (path induction), without K. This ensures
the definition is compatible with HoTT.

### 3. Detection of Agda Bug

The formal analysis uncovered a previously unknown bug in Agda's `--without-K`
check, where certain definitions that used K were incorrectly accepted.

## Significance

This paper made dependent pattern matching compatible with HoTT for the first time,
with a formally verified criterion. It was implemented in Agda and influenced the
design of other proof assistants. The subsequent work by Cockx on proof-relevant
unification (2016, 2018) further refined and extended these ideas.
