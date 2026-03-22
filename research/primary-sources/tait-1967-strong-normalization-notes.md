# Tait 1967 - Strong Normalization via Logical Predicates

## Citation
W. W. Tait. "Intensional Interpretations of Functionals of Finite Type I."
Journal of Symbolic Logic, 32(2):198-212, 1967.

## Key Ideas

Tait introduced the method of "computability predicates" (later called logical
predicates or reducibility predicates) to prove strong normalization of the
simply typed lambda calculus.

## The Method

### Problem
Direct induction on typing derivations fails for strong normalization because
the application rule does not decrease term size in the right way.

### Solution: Reducibility Predicates
Define a family of predicates RED_τ indexed by types:
- RED_ι(t) iff t is strongly normalizing (for base types ι)
- RED_{σ→τ}(t) iff for all u, if RED_σ(u) then RED_τ(t u)

### Key Properties (CR1-CR3)
CR1: If RED_τ(t), then t is strongly normalizing
CR2: If RED_τ(t) and t →* t', then RED_τ(t')
CR3: If t is neutral and all one-step reducts of t are in RED_τ, then RED_τ(t)

### Main Lemma (Fundamental Theorem)
If Γ ⊢ t : τ and σ is a substitution such that RED_{Γ(x)}(σ(x)) for all x in Γ,
then RED_τ(t[σ]).

### Conclusion
Every well-typed term t : τ is in RED_τ (use identity substitution with variables,
which are neutral). By CR1, t is strongly normalizing.

## Why It Works
The logical predicate is defined by induction on the structure of types,
which provides the induction measure that direct approaches lack.

## Legacy
- Extended by Girard to System F (reducibility candidates)
- Generalized by Statman and others
- Foundation for all logical relations methods
