# Church and Rosser 1936 -- "Some Properties of Conversion"

## Citation

Church, A. and Rosser, J.B. (1936). "Some Properties of Conversion."
*Transactions of the American Mathematical Society*, 39(3), 472--482.

## Summary

This paper proved the Church-Rosser theorem: if a lambda term M can be reduced
(via beta-reduction) to both M1 and M2, then there exists a term M3 such that
both M1 and M2 can be reduced to M3.

Formally: if M ->>_beta M1 and M ->>_beta M2, then there exists M3 such that
M1 ->>_beta M3 and M2 ->>_beta M3.

## Key Corollaries

1. **Uniqueness of normal forms**: If a term has a normal form, that normal form
   is unique (up to alpha-equivalence).

2. **Consistency of the pure lambda calculus**: Not all equations between lambda
   terms are provable. In particular, the terms `true` and `false` (Church booleans)
   are not beta-equivalent.

## Historical Significance

This was the consistency proof for the pure lambda calculus that Church needed after
the Kleene-Rosser paradox showed his full foundational system was inconsistent.
The theorem remains one of the most fundamental results in lambda calculus theory.

## Later Proofs

- Tait and Martin-Lof gave a simplified proof using parallel reduction.
- Takahashi gave another simplified proof using the notion of complete development.
- Kozen (2010) gave a simplified proof in Fundamenta Informaticae.
