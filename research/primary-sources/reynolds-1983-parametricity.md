# Reynolds' Abstraction Theorem / Parametricity (1983)

## Source
John C. Reynolds, "Types, Abstraction and Parametric Polymorphism," in Information Processing 83, Proceedings of the IFIP 9th World Computer Congress, Paris, France, September 19–23, 1983, pp. 513–523.

## Summary
Reynolds defined a relational interpretation of System F types and proved the Abstraction Theorem: interpretations of a term in related contexts yield related results. This foundational result constrains interpretations of polymorphic types and establishes the principle of relational parametricity.

## Key Concepts

### Relational Interpretation of Types
Reynolds built a semantics of logical relations on top of a set-theoretic denotational semantics:
- Types are interpreted as sets, terms as elements
- Relation-lifted definitions of type constructors build relations from relations
- The universal quantifier ∀α.τ is interpreted as requiring the relation to hold for all related type instantiations

### Abstraction Theorem
Every well-typed term satisfies a relational property derivable from its type. This is the formal statement of parametricity.

### Impact
- Foundation for Wadler's "Theorems for free!" (1989)
- Establishes that polymorphic functions must act uniformly across all type instantiations
- Motivated by the study of data abstraction in programming languages

## Reynolds' Impossibility Result (1984)
In "Polymorphism is not set-theoretic" (1984), Reynolds proved that there is no set-theoretic model of System F where function spaces are interpreted as full function spaces. This showed that naive set-theoretic semantics is insufficient for polymorphic lambda calculus.
