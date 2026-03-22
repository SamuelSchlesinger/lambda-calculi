# Ahmed - Step-Indexed Syntactic Logical Relations for Recursive and Quantified Types (2006)

**Full Citation:**
Amal Ahmed. "Step-Indexed Syntactic Logical Relations for Recursive and Quantified Types."
In Proceedings of the 15th European Symposium on Programming (ESOP 2006),
Springer LNCS 3924, pages 69-83, 2006.

**Extended version:** Harvard University Technical Report TR-01-06.

**Sources:**
- https://link.springer.com/chapter/10.1007/11693024_6
- https://www.ccs.neu.edu/home/amal/papers/lr-recquant-techrpt.pdf

## Summary

This paper presents a sound and complete proof technique based on syntactic logical
relations for showing contextual equivalence of expressions in a lambda-calculus with
recursive types (mu-types) and impredicative universal and existential types.

### Building on Appel-McAllester

The development extends the step-indexed PER model of recursive types by Appel and
McAllester (2001). Ahmed showed how to extend the model to obtain a logical relation
that is transitive, as well as sound and complete with respect to contextual equivalence.

### Key Discovery

Ahmed discovered that a direct proof of transitivity of the original Appel-McAllester
model does not go through, leaving the "PER" status of the model in question.

### Step-Indexing Technique

The logical relation is indexed not just by types but also by the number of steps
available for future evaluation. The predicate associated with mu-alpha.tau at k
available steps is specified using the predicate for tau[mu-alpha.tau/alpha] at k-1
available steps, since "unfolding" consumes a step.

### Results

- Sound and complete for recursive and polymorphic types
- Sound but incomplete for existential types

## Predecessor: Appel & McAllester (2001)

Andrew W. Appel and David McAllester. "An indexed model of recursive types for
foundational proof-carrying code." ACM TOPLAS, 23(5), September 2001.
- First step-indexed model for recursive types
- Motivated by foundational proof-carrying code
- Needed semantic models of type systems on von Neumann machines
