# Sozeau 2010 — Equations: A Dependent Pattern-Matching Compiler

**Full Citation:**
Matthieu Sozeau. "Equations: A Dependent Pattern-Matching Compiler." In
*Interactive Theorem Proving (ITP 2010)*, LNCS vol. 6172, pp. 419–434.
Springer, 2010. DOI: 10.1007/978-3-642-14052-5_29

**Extended version:**
Matthieu Sozeau and Cyprien Mangin. "Equations Reloaded: High-Level Dependently-Typed
Functional Programming and Proving in Coq." *Proceedings of the ACM on Programming
Languages*, vol. 3, no. ICFP, article 86. ACM, 2019.

**Project page:** https://mattam82.github.io/Coq-Equations/

## Summary

Equations is a plugin for Coq (now Rocq) that implements dependent pattern matching
and well-founded recursion, compiling everything down to eliminators for inductive
types, equality, and accessibility. It provides a definitional extension to the
Coq kernel without adding axioms.

## Key Contributions

### 1. Dependent Pattern Matching for Coq

Coq's built-in `match` construct is limited: it does not natively support the full
power of dependent pattern matching as in Agda. The Equations plugin fills this gap,
providing Agda-like notation for writing functions by clausal pattern matching with
dependent types.

### 2. No-Confusion Properties

At the core of the system is a simplifier for dependent equalities based on the
"no-confusion" property of constructors: distinct constructors produce distinct
values, and constructors are injective. This property is derived for each inductive
type and used to simplify the equations arising during pattern matching.

### 3. Compilation to Eliminators

All definitions written using Equations are compiled to terms using only:
- Eliminators (recursors) for inductive types
- J (equality elimination)
- Accessibility and well-founded recursion principles

This means Equations does not extend the trusted code base (the kernel).

### 4. Proof Principles

Equations automatically derives useful proof principles for defined functions:
- Functional elimination lemmas
- Unfolding lemmas for each clause
- No-confusion lemmas

### 5. Well-Founded Recursion

Beyond structural recursion, Equations supports well-founded recursion, where the
user specifies a well-founded relation and the system generates the proof obligations
for termination.

### 6. HoTT Compatibility

Equations can work with the HoTT/Coq library, producing definitions that are
compatible with homotopy type theory (no axiom K).

## Significance

Equations brings the convenience of Agda-style dependent pattern matching to Coq
while maintaining Coq's small trusted kernel. It demonstrates that dependent pattern
matching can be implemented as an elaboration pass rather than a kernel primitive.
