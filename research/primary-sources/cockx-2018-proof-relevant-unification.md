# Cockx, Abel 2018 — Proof-Relevant Unification

**Full Citation:**
Jesper Cockx and Andreas Abel. "Proof-Relevant Unification: Dependent Pattern
Matching with Only the Axioms of Your Type Theory." *Journal of Functional
Programming*, vol. 28, e6. Cambridge University Press, 2018.
DOI: 10.1017/S095679681700029X

**Source:** https://www.cambridge.org/core/journals/journal-of-functional-programming/article/proofrelevant-unification-dependent-pattern-matching-with-only-the-axioms-of-your-type-theory/E54D56DC3F5D5361CCDECA824030C38E

## Summary

This paper presents a proof-relevant framework for dependent pattern matching
unification. Instead of computing just a unifier, each unification rule also
produces a correctness proof (an equivalence between the original set of equations
and the simplified set). This ensures that the unification algorithm is sound with
respect to the type theory being used.

## Key Contributions

### 1. Proof-Relevant Unification Rules

Standard unification rules are reformulated to produce evidence:
- **Solution**: Given `x = t` where x is fresh, produce an equivalence showing
  the equation set with x is equivalent to the substituted set.
- **Injectivity**: Given `c s = c t`, produce an equivalence showing this is
  equivalent to `s = t` (for constructor c).
- **Conflict**: Given `c s = d t` for distinct constructors c, d, produce a
  proof of absurdity.
- **Cycle**: Given `x = t` where x occurs in t, produce a proof of absurdity.
- **Deletion**: Given `x = x`, discharge it. **This is the step that requires K.**

### 2. Modularity

New unification rules can be safely added (e.g., eta-equality for record types,
higher-dimensional unification for identity proofs) as long as they produce
valid equivalences. This makes the framework extensible.

### 3. Implementation in Agda

The authors completely overhauled Agda's unification algorithm using this
framework, replacing ad-hoc restrictions with formally verified rules. This
fixed a substantial number of bugs in the process.

## Significance

This work provides the definitive theoretical foundation for implementing
dependent pattern matching in a way that is provably sound for any type theory.
It unifies the previous work on pattern matching without K with a general
framework that can accommodate future extensions.
