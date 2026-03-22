# Plotkin, Power, Pretnar: Algebraic Effects and Handlers

## Key Papers

### Plotkin & Power (2001/2003): Algebraic Operations and Generic Effects
- **Authors:** Gordon Plotkin, John Power
- **Title:** Algebraic Operations and Generic Effects
- **Venue:** Applied Categorical Structures 11(1), 69-94, 2003. (Conference version at MFPS 2001)
- **PDF:** https://homepages.inf.ed.ac.uk/gdp/publications/alg_ops_gen_effects.pdf
- **DOI:** https://doi.org/10.1023/A:1023064908962

Defines the notion of generic effect and shows that giving a generic effect is equivalent
to giving an algebraic operation. Shows how monadic semantics of the computational
lambda-calculus extends uniformly to incorporate generic effects.

Key insight: impure behavior arises from a set of operations (get/set for state,
read/print for I/O, raise for exceptions). These operations satisfy equational theories
that determine the computational monad.

### Plotkin & Pretnar (2009): Handlers of Algebraic Effects
- **Authors:** Gordon Plotkin, Matija Pretnar
- **Title:** Handlers of Algebraic Effects
- **Venue:** ESOP 2009, LNCS vol 5502
- **PDF:** https://homepages.inf.ed.ac.uk/gdp/publications/Effect_Handlers.pdf

Introduces effect handlers as a programming abstraction. Handlers generalize exception
handlers to arbitrary algebraic effects. A handler for an effect provides interpretations
for each operation, with access to the continuation (the rest of the computation).

### Plotkin & Pretnar (2013): Handling Algebraic Effects
- **Authors:** Gordon Plotkin, Matija Pretnar
- **Title:** Handling Algebraic Effects
- **Venue:** Logical Methods in Computer Science (LMCS), 2013
- **PDF:** https://homepages.inf.ed.ac.uk/gdp/publications/handling-algebraic-effects.pdf

Journal version of the 2009 ESOP paper with full details.

## Tutorial
- **Authors:** Matija Pretnar
- **Title:** An Introduction to Algebraic Effects and Handlers
- **PDF:** https://www.eff-lang.org/handlers-tutorial.pdf
