# Type Safety for STLC: Progress and Preservation

## Key References

1. Wright, Andrew K. and Felleisen, Matthias. "A Syntactic Approach to Type Soundness."
   *Information and Computation*, 115(1), pp. 38-94, 1994.
   - Established the modern "syntactic" approach to type soundness via progress
     and preservation (subject reduction).

2. Pierce, Benjamin C. *Types and Programming Languages*. MIT Press, 2002.
   - Standard textbook treatment, Chapter 9 covers STLC type safety.

3. Software Foundations (Pierce et al.), Volume 2: Programming Language Foundations.
   - Mechanized Coq proofs of all results below.
   https://softwarefoundations.cis.upenn.edu/plf-current/StlcProp.html

## Canonical Forms Lemma

If e is a closed, well-typed value:
- If |- e : Bool, then e = true or e = false
- If |- e : T1 -> T2, then e = \x:T1. body for some x and body

Proof: Case analysis on the value predicate combined with inversion on the
typing derivation.

## Progress Theorem

**Statement:** If |- e : T (i.e., e is a closed, well-typed term), then either:
  (a) e is a value, or
  (b) there exists e' such that e --> e'

**Proof technique:** Induction on the typing derivation.
- Variable case: impossible (empty context).
- Abstraction case: already a value.
- Application case: by IH on subterms. If the function position is a value,
  use canonical forms to show it must be a lambda; then beta-reduction applies.
  If the function position can step, use the congruence rule.

## Preservation Theorem (Subject Reduction)

**Statement:** If |- e : T and e --> e', then |- e' : T

**Proof technique:** Induction on the typing derivation.
- The critical case is beta-reduction: (\x:T1. body) v --> [x := v] body
- This case requires the Substitution Lemma.

## Substitution Lemma

**Statement:** If (x : U, Gamma |- e : T) and (|- v : U), then (Gamma |- [x:=v]e : T)

**Proof:** Induction on the structure of e.
- Variable case: if x = y, the substitution replaces y with v of type U = T.
  If x /= y, the variable remains unchanged.
- Abstraction case: requires care with variable capture; alpha-conversion or
  Barendregt convention assumed.
- Application case: straightforward by IH.

## Weakening Lemma

**Statement:** If Gamma |- e : T and Gamma is a subset of Gamma', then Gamma' |- e : T

**Proof:** Induction on the typing derivation, using context inclusion.

## Type Soundness

**Corollary:** If |- e : T and e -->* e' (multi-step reduction), then e' is not stuck.
That is, e' is either a value or can take another step.

**Proof:** By induction on the number of steps, applying preservation at each step
and progress at the end.
