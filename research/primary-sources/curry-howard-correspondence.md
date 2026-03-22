# The Curry-Howard Correspondence

## Key References

1. Curry, Haskell B. and Feys, Robert. *Combinatory Logic, Volume I*.
   North-Holland, 1958.
   - First observed the correspondence between types in combinatory logic and
     propositions in intuitionistic logic.

2. Howard, William A. "The Formulae-as-Types Notion of Construction."
   1969 manuscript, published in: Seldin, J.P. and Hindley, J.R. (eds.),
   *To H.B. Curry: Essays on Combinatory Logic, Lambda Calculus and Formalism*,
   pp. 479-490, Academic Press, 1980.
   - Made explicit the syntactic analogy between programs of simply typed lambda
     calculus and proofs of natural deduction for intuitionistic logic.

3. de Bruijn, Nicolaas Govert. "The Mathematical Language AUTOMATH, Its Usage,
   and Some of Its Extensions." In *Symposium on Automatic Demonstration*,
   Lecture Notes in Mathematics, Vol. 125, pp. 29-61, Springer, 1970.
   - Independently discovered the correspondence in the context of the Automath
     proof checker.

## The Correspondence

| Simply Typed Lambda Calculus | Intuitionistic Logic (Natural Deduction) |
|------------------------------|------------------------------------------|
| Types                        | Propositions                             |
| Terms (programs)             | Proofs                                   |
| Arrow type A -> B            | Implication A => B                       |
| Product type A x B           | Conjunction A /\ B                       |
| Sum type A + B               | Disjunction A \/ B                       |
| Unit type                    | Truth (top)                              |
| Empty/Void type              | Falsity (bottom)                         |
| Lambda abstraction           | Implication introduction                 |
| Function application         | Implication elimination (modus ponens)   |
| Variable                     | Hypothesis / assumption                  |
| Beta reduction               | Proof normalization (cut elimination)    |
| Type inhabitation            | Provability                              |
| Normal forms                 | Normal proofs (Prawitz)                  |

## Extended Correspondence (Curry-Howard-Lambek)

Lambek (1980) observed that the correspondence extends to a three-way isomorphism:

| Lambda Calculus     | Logic              | Category Theory              |
|---------------------|--------------------|------------------------------|
| Types               | Propositions       | Objects                      |
| Terms               | Proofs             | Morphisms                    |
| Arrow type A -> B   | Implication A => B | Exponential object B^A       |
| Product type A x B  | Conjunction A /\ B | Categorical product A x B    |
| Sum type A + B      | Disjunction A \/ B | Coproduct A + B              |
| Unit type           | Truth              | Terminal object 1            |
| Void type           | Falsity            | Initial object 0             |
| Beta reduction      | Cut elimination    | Composition of morphisms     |

## Significance

- Type checking = proof verification
- Program execution = proof normalization
- Strong normalization of STLC = every proof in the implicational fragment
  of intuitionistic propositional logic can be normalized
- The type inhabitation problem for STLC is equivalent to provability in
  the implicational fragment of intuitionistic propositional logic (PSPACE-complete)
