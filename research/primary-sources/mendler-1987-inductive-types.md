# Mendler - Inductive Types and Type Constraints in the Second-Order Lambda Calculus (1987)

**Full Citation:**
Nax Paul Mendler. "Inductive types and type constraints in the second-order lambda calculus."
In Proceedings of the 2nd Annual IEEE Symposium on Logic in Computer Science (LICS 1987), pages 30-36.

**PhD Thesis:**
Nax Paul Mendler. "Inductive Definition in Type Theory." PhD thesis, Cornell University, 1987.

**Sources:**
- https://lics.siglog.org/archive/1987/Mendler-RecursiveTypesandTy.html
- http://www.nuprl.org/documents/Mendler/InductiveDefinition.html

## Summary

Mendler added to the second-order lambda calculus (System F) type constructors mu and nu,
which give the least and greatest solutions to positively defined type expressions.

### Key Results

- Strong normalizability of typed terms was shown using Girard's candidates for reduction method
- The induction principle associated with mu types lets one define well-founded recursive functions
- The dual principle for nu types lets one inductively define their "infinite" elements

### Mendler-Style Recursion

The Mendler-style approach to recursion is distinctive in that:
1. It does not require the underlying type to be a functor (no fmap needed)
2. It guarantees termination even for negative inductive datatypes
3. It provides a uniform treatment of recursive types via abstract cast functions

### Categorical Interpretation

Uustalu and Vene (1999) gave a categorical account of Mendler-style induction:
- "Mendler-Style Inductive Types, Categorically"
- Nordic Journal of Computing 6(1999), 343-361
- The Mendler-style algebra can be seen as an application of the Yoneda lemma
