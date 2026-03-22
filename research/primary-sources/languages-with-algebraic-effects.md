# Programming Languages with Algebraic Effects

## Eff
- **Authors:** Andrej Bauer, Matija Pretnar
- **Paper:** Programming with Algebraic Effects and Handlers (2012/2015)
- **ArXiv:** https://arxiv.org/abs/1203.1539
- **Journal:** Journal of Logical and Algebraic Methods in Programming, 2015
- **Website:** https://www.eff-lang.org/
- **GitHub:** https://github.com/matijapretnar/eff

First language designed from the ground up around algebraic effects and handlers.
Supports first-class effects and handlers; effects are accessed through operations,
behavior determined by handlers.

## Koka
- **Author:** Daan Leijen (Microsoft Research)
- **Paper:** Koka: Programming with Row-polymorphic Effect Types (2014)
- **ArXiv:** https://arxiv.org/abs/1406.2061
- **Paper:** Type Directed Compilation of Row-Typed Algebraic Effects (POPL 2017)
- **Paper:** Algebraic Effects for Functional Programming (MSR-TR-2016, 2016)
- **Website:** https://koka-lang.github.io/koka/doc/book.html
- **GitHub:** https://github.com/koka-lang/koka

Uses row-polymorphic effect types with Hindley-Milner style inference. Effect rows
use duplicate labels for precise typing of effect elimination.

## Frank
- **Authors:** Sam Lindley, Conor McBride
- **Paper:** Do Be Do Be Do (POPL 2017)
- **ArXiv:** https://arxiv.org/abs/1611.09259

Strict functional language built around effect handlers as the primary abstraction.
Generalizes functional abstraction to handle effects without a separate handler
construct. Uses call-by-push-value distinction and novel "ambient ability" for
effect polymorphism.

## Multicore OCaml (OCaml 5.0)
- **Developers:** KC Sivaramakrishnan, Stephen Dolan, Leo White, et al.
- **Website:** https://github.com/ocaml-multicore/ocaml-effects-tutorial
- **Slides:** https://kcsrk.info/slides/handlers_edinburgh.pdf

OCaml 5.0 includes algebraic effect handlers primarily for concurrency. Uses one-shot
continuations implemented via fibers (heap-allocated stack chunks). Supports resumable
exceptions, async I/O, cooperative threading.
