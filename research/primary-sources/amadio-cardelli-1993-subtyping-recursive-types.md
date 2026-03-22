# Amadio & Cardelli - Subtyping Recursive Types (1993)

**Full Citation:**
Roberto M. Amadio and Luca Cardelli. "Subtyping Recursive Types."
ACM Transactions on Programming Languages and Systems (TOPLAS), Volume 15, Issue 4, September 1993, pages 575-631.
DOI: 10.1145/155183.155231

**Source:** https://dl.acm.org/doi/10.1145/155183.155231

## Summary

This paper provides a thorough study of the metatheory of equi-recursive subtyping in a
simply typed lambda-calculus. The two fundamental questions addressed are:

1. Whether two recursive types are in the subtype relation
2. Whether a term has a type

The paper relates various definitions of type equivalence and subtyping induced by:
- A model
- An ordering on infinite trees
- An algorithm
- A set of type rules

They demonstrate soundness and completeness among the rules, the algorithm, and the
tree semantics. The "Amber rules" are proved to be sound and complete with respect to
the tree model interpretation of equi-recursive subtyping.

Two recursive types are subtypes if their infinite unfoldings are subtypes. The paper
provides the foundational algorithmic framework for deciding equi-recursive type equality
and subtyping, which has been widely adopted in subsequent work.
