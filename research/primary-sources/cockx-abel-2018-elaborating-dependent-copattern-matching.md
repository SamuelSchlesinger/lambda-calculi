# Cockx, Abel 2018 — Elaborating Dependent (Co)pattern Matching

**Full Citation:**
Jesper Cockx and Andreas Abel. "Elaborating Dependent (Co)pattern Matching."
In *Proceedings of the ACM on Programming Languages*, vol. 2, no. ICFP,
article 75, pp. 75:1–75:30. ACM, 2018.
DOI: 10.1145/3236770

**Extended version:**
Jesper Cockx and Andreas Abel. "Elaborating Dependent (Co)pattern Matching:
No Pattern Left Behind." *Journal of Functional Programming*, vol. 30, e2.
Cambridge University Press, 2020.
DOI: 10.1017/S0956796819000182

**PDF Source:** https://jesper.sikanda.be/files/elaborating-dependent-copattern-matching.pdf

## Summary

This paper presents a formally verified algorithm for elaborating definitions by
dependent (co)pattern matching to a core language with well-typed case trees. The
algorithm is designed as an algorithmic version of typing rules for case trees,
where extra user input (the user-written clauses) guides the construction.

## Key Contributions

### 1. Typing Rules for Case Trees

The paper formalizes case trees with the following grammar:
- **done(v)**: a leaf returning value v
- **split(x, [c1 => t1, ..., cn => tn])**: splitting on variable x by constructor
- **cosplit([.f1 => t1, ..., .fn => tn])**: splitting by copattern (projection)
- **intro(x, t)**: introducing a lambda-bound variable

Each form has a typing rule ensuring the case tree is well-typed in context.

### 2. Coverage Checking Algorithm

The first coverage checking algorithm for fully dependent copatterns that:
- Desugars deep (co)pattern matching to well-typed case trees in a core language
- Proves correctness: if desugaring succeeds, the case tree's behavior corresponds
  precisely to the first-match semantics of the original clauses

### 3. First-Match Semantics Preservation

The paper identifies a subtle issue: the "shortcut rule" (where a clause fires
even if it doesn't match *all* earlier clauses) cannot be preserved when
elaborating to well-typed case trees. This theoretical finding uncovered a real
bug in Agda (#2964) that broke subject reduction.

### 4. The Elaboration Algorithm

The algorithm operates on a state consisting of:
- A list of user clauses with their patterns
- A current context (telescope of typed variables)
- A target type

It proceeds by:
1. Checking if any clause's patterns are all variables (base case: emit done)
2. Otherwise, finding a suitable variable to split on
3. For each constructor of that variable's type:
   a. Computing the unifier of the constructor's type with the expected type
   b. Applying the substitution to the context and remaining clauses
   c. Filtering out clauses whose patterns conflict with the constructor
   d. Recursing on the remaining clauses

### 5. Implementation in Agda

Based on this work, the authors reimplemented Agda's pattern matching checker,
making it more general and less complex while fixing bugs and usability issues.

## Significance

This paper bridges the gap between user-facing pattern matching syntax and the
internal core language of a proof assistant. It provides the first formally
verified coverage checking algorithm for dependent copattern matching and has
been adopted as the basis for Agda's implementation.
