# Girard's System F (1972)

## Source
Jean-Yves Girard, "Interprétation fonctionnelle et élimination des coupures de l'arithmétique d'ordre supérieur," PhD thesis, Université Paris VII, 1972.

## Summary
Girard developed System F (the second-order polymorphic lambda calculus) in his 1972 PhD thesis as part of his work on proof theory. The system was designed to study normalization properties in second-order logic.

## Key Contributions
1. **Definition of System F**: A typed lambda calculus extending simply typed lambda calculus with universal quantification over types (∀α.τ), type abstraction (Λα.t), and type application (t[τ]).

2. **Strong Normalization Proof**: Girard proved that all well-typed terms in System F are strongly normalizing using the technique of *reducibility candidates* (candidats de réductibilité). This was one of the major results of the thesis.

3. **Representation Theorem**: Every function on natural numbers that can be proved total in second-order intuitionistic predicate logic (P2) can be represented in System F (F2).

4. **Curry-Howard Correspondence**: System F corresponds to second-order intuitionistic propositional logic under the Curry-Howard isomorphism. Girard's motivation was the study of second-order arithmetic via a functional interpretation in the BHK style.

## Later Retrospective
Girard published "The system F of variable types, fifteen years later" (Theoretical Computer Science, 1986) reflecting on the development and impact of System F.
