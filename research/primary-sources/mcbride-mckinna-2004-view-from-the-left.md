# McBride, McKinna 2004 — The View from the Left

**Full Citation:**
Conor McBride and James McKinna. "The View from the Left." *Journal of Functional
Programming*, vol. 14, no. 1, pp. 69–111. Cambridge University Press, 2004.
DOI: 10.1017/S0956796803004829

**Source:** https://www.cambridge.org/core/journals/journal-of-functional-programming/article/view-from-the-left/F8A44CAC27CCA178AF69DD84BC585A2D

## Summary

This paper presents the type theory and design ideas behind Epigram, focusing on
types and pattern matching. It develops a programming notation for dependent type
theory that elaborates pattern matching in several ways, including the "with"
construct for pattern matching on intermediate computations.

## Key Contributions

### 1. Dependent Pattern Matching as Primary Mechanism

The paper treats pattern matching as the primary mechanism for both programming and
theorem proving: if types are viewed as theorems, pattern matching provides proof
by case analysis and induction.

### 2. The "with" Construct

The paper formalizes the "with" rule, which allows pattern matching on the result
of an intermediate computation. This is essential when the value to be matched is
not a direct argument but a computed result.

For example, to define `filter` on vectors:
```
filter p (x :: xs) with p x
filter p (x :: xs) | true  = x :: filter p xs
filter p (x :: xs) | false = filter p xs
```

The "with" construct is handled by generalizing the goal over the intermediate
value, creating an auxiliary function that takes the value as an extra argument.

### 3. Views

The paper generalizes Wadler's (1987) notion of "views" to the dependent setting.
A view of a type provides an alternative decomposition that can be used directly
in pattern matching. For example, a "parity view" of natural numbers:
```
data Parity : Nat -> Set where
  even : (k : Nat) -> Parity (2 * k)
  odd  : (k : Nat) -> Parity (2 * k + 1)
```

A function `parity : (n : Nat) -> Parity n` computes the decomposition, and
then `with parity n` allows matching on whether n is even or odd.

### 4. Typechecker Example

The paper develops a complete typechecker for the simply-typed lambda calculus,
demonstrating that pattern matching on dependent types provides a proof that
typechecking is decidable.

## Significance

This paper established the practical idioms for programming with dependent types
that are used in Agda, Idris, and other languages. The "with" construct became a
standard feature of dependently typed languages.
