# Levy (2003): Call-By-Push-Value

## Bibliographic Information
- **Author:** Paul Blain Levy
- **Title:** Call-By-Push-Value: A Functional/Imperative Synthesis
- **Publisher:** Springer, 2003
- **DOI:** https://doi.org/10.1007/978-94-007-0954-6
- **Thesis PDF:** https://www.cs.bham.ac.uk/~pbl/papers/thesisqmwphd.pdf

## Earlier Paper
- **Title:** Call-By-Push-Value: A Subsuming Paradigm
- **Venue:** TLCA 1999
- **PDF:** https://www.cs.bham.ac.uk/~pbl/papers/tlca99.pdf

## Also
- **Title:** Call-by-push-value: Decomposing call-by-value and call-by-name
- **Venue:** Higher-Order and Symbolic Computation, 2006
- **DOI:** https://doi.org/10.1007/s10990-006-0480-6

## Summary

CBPV distinguishes two kinds of types:
- **Value types** (A): classify data that can be freely duplicated/discarded
- **Computation types** (B): classify potentially effectful expressions

Motto: "Values are, computations do."

### Key Type Constructors

- **U B** (thunk): A value type. Values of type U B are suspended computations of type B.
  - Introduction: thunk M (where M : B) produces a value of type U B
  - Elimination: force V (where V : U B) produces a computation of type B

- **F A** (free/returner): A computation type. Computations of type F A produce values of type A.
  - Introduction: return V (where V : A) produces a computation of type F A
  - Elimination: M to x. N (bind; if M : F A and N : B with x:A, then M to x. N : B)

### Subsumption of CBV and CBN

- CBV type A maps to value type A, with CBV function type A -> B mapping to U(A -> F B')
- CBN type A maps to computation type A, with CBN function type A -> B mapping to UA -> B
- Variables range over values in both embeddings

### Adjunction Model

F and U form an adjunction F -| U between a category of values and a category of
computations. This adjunction gives rise to a monad UF on the value category (the
standard computational monad) and a comonad FU on the computation category.
