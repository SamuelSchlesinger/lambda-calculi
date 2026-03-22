# Harper, R., Honsell, F., Plotkin, G. (1993). "A Framework for Defining Logics."

**Citation:** Harper, R., Honsell, F., and Plotkin, G. "A Framework for Defining Logics."
*Journal of the ACM*, 40(1):143-184, January 1993.

**PDF available at:** https://homepages.inf.ed.ac.uk/gdp/publications/Framework_Def_Log.pdf

## Summary

This paper introduces the Edinburgh Logical Framework (LF), based on the lambda-Pi
calculus (the system called lambda-P in the lambda cube). LF provides a means to define
(or present) logics using a general treatment of syntax, rules, and proofs by means of
a typed lambda calculus with dependent types.

### Key Contributions

1. **The Lambda-Pi Calculus**: A system of first-order dependent function types, related
   by the propositions-as-types principle to first-order minimal logic.

2. **Judgements as Types Principle**: A new principle whereby each judgement is identified
   with the type of its proofs, allowing uniform treatment of rules and proofs.

3. **Three Levels**: The calculus has entities at three levels: objects, types, and kinds
   (type families).

### Properties

- Predicative
- All well-typed terms are strongly normalizing
- Church-Rosser property holds
- Type-checking is decidable

### Relation to Lambda Cube

LF is based on the lambda-P corner of the lambda cube, which adds dependent types
(types depending on terms) to the simply typed lambda calculus. This corresponds to
the rules (*, *) and (*, square) in the PTS formulation.
