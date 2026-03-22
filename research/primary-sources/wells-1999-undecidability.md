# Wells' Undecidability Results for System F (1999)

## Source
J. B. Wells, "Typability and type checking in System F are equivalent and undecidable," Annals of Pure and Applied Logic, vol. 98, no. 1–3, pp. 111–156, 1999.

## Summary
Wells proved two landmark undecidability results for System F (in Curry style, i.e., with implicit type annotations):

1. **Type checking is undecidable**: Given a term t and a type τ, it is undecidable whether t can be assigned type τ. Proved by reduction from semi-unification.

2. **Typability is undecidable**: Given a term t, it is undecidable whether there exists any type τ such that t can be assigned type τ. Proved by reduction from type checking.

3. **Equivalence**: The two problems (typability and type checking) are equivalent in System F.

## Significance
- First resolution of whether these problems are decidable for System F
- Contrasts sharply with Hindley-Milner, where both problems are decidable
- Semi-unification (first-order unification combined with first-order matching) serves as the key intermediate problem
- Motivates the study of restricted fragments (rank-n polymorphism) and partial type inference approaches

## Note on Church-style vs Curry-style
In Church-style System F (with explicit type annotations), type checking is decidable. The undecidability applies to Curry-style System F where type abstractions and applications are implicit.
