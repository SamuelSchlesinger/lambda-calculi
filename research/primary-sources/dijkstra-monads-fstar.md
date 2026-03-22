# Dijkstra Monads and Effects in Dependent Type Theory

## Key Papers

### Swamy et al. (2016): Dependent Types and Multi-monadic Effects in F*
- **Authors:** Nikhil Swamy, Catalin Hritcu, Chantal Keller, et al.
- **Title:** Dependent Types and Multi-monadic Effects in F*
- **Venue:** POPL 2016
- **PDF:** https://fstar-lang.org/papers/mumon/paper.pdf

### Ahman et al. (2017): Dijkstra Monads for Free
- **Authors:** Danel Ahman, Catalin Hritcu, Kenji Maillard, et al.
- **Title:** Dijkstra Monads for Free
- **Venue:** POPL 2017
- **ArXiv:** https://arxiv.org/abs/1608.06499
- **Website:** https://fstar-lang.org/papers/dm4free/

Shows Dijkstra monads can be derived automatically via CPS translation of standard
monadic definitions. Correct-by-construction reasoning about user-defined effects.

### Maillard et al. (2019): Dijkstra Monads for All
- **Authors:** Kenji Maillard, Danel Ahman, Robert Atkey, et al.
- **Title:** Dijkstra Monads for All
- **Venue:** ICFP 2019
- **ArXiv:** https://arxiv.org/abs/1903.01237

General semantic framework: any monad morphism from a computational monad to a
specification monad gives rise to a Dijkstra monad.

## Core Concepts

A Dijkstra monad D is a monad-like structure indexed by a specification monad W (typically
a weakest-precondition monad). The computation type M t wp ties a computation of type t
to its semantic interpretation as a predicate transformer wp.

In F*, effects are declared with their Dijkstra monad structure:
- PURE for pure computations
- EXN for exceptions
- ST for stateful computations
- ALL for combining all effects

Each effect's wp (weakest precondition) enables verification of effectful code within
the dependent type system.

## Lean 4

Lean 4 uses a monadic approach to effects:
- IO monad for side effects, based on a state monad over RealWorld token
- do-notation as syntactic sugar for monadic bind
- Monad transformers (StateT, ExceptT, ReaderT) for composing effects
- Type class based monad infrastructure
