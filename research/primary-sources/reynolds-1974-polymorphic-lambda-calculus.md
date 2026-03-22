# Reynolds' Polymorphic Lambda Calculus (1974)

## Source
John C. Reynolds, "Towards a theory of type structure," in Colloque sur la Programmation, Lecture Notes in Computer Science, vol. 19, pp. 408–425, Springer, 1974.

## Summary
Reynolds independently discovered the second-order polymorphic lambda calculus (what Girard called System F) from the perspective of programming language design. Reynolds proposed allowing types to be passed as parameters, with usage restricted to permit syntactic checking of type correctness.

## Key Contributions
1. **Independent Discovery**: Reynolds arrived at the same formal system as Girard but from a programming languages perspective rather than proof theory.

2. **Motivation**: Reynolds was motivated by the desire to build a type system for polymorphic programming, enabling functions and data structures to work generically across types.

3. **Type Structure**: The key innovation was allowing types themselves to be passed as a special kind of parameter, enabling parametric polymorphism.

## Relationship to Girard
The Girard-Reynolds isomorphism establishes a formal connection between the two perspectives:
- Girard's Representation Theorem gives a projection from second-order logic into System F
- Reynolds' Abstraction Theorem gives an embedding of System F into second-order logic
