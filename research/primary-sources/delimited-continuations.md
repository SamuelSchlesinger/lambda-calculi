# Delimited Continuations

## Key Papers

### Danvy & Filinski (1990): Abstracting Control
- **Authors:** Olivier Danvy, Andrzej Filinski
- **Title:** Abstracting Control
- **Venue:** ACM Conference on Lisp and Functional Programming (LFP), 1990
Introduces shift and reset operators for delimited continuations.

### Felleisen (1988): The Theory and Practice of First-Class Prompts
- **Author:** Matthias Felleisen
- **Title:** The Theory and Practice of First-Class Prompts
- **Venue:** POPL 1988
Introduces control and prompt operators.

### Filinski (1994): Representing Monads
- **Author:** Andrzej Filinski
- **Title:** Representing Monads
- **Venue:** POPL 1994
Shows that any expressible monad can be represented using shift/reset.

### Filinski (1999): Representing Layered Monads
- **Author:** Andrzej Filinski
- **Title:** Representing Layered Monads
- **Venue:** POPL 1999
Extends the 1994 result to layered/stacked effects.

### Dybvig, Peyton Jones, Sabry (2007): A Monadic Framework for Delimited Continuations
- **Authors:** R. Kent Dybvig, Simon Peyton Jones, Amr Sabry
- **Venue:** Journal of Functional Programming, 2007
- **PDF:** https://www.microsoft.com/en-us/research/wp-content/uploads/2005/01/jfp-revised.pdf

## Core Concepts

### shift/reset (Danvy-Filinski)
- reset(M) delimits the continuation captured by shift within M
- shift(k. N) captures the current continuation up to the nearest reset, binds it to k,
  and evaluates N
- The captured continuation k is a function (composable/delimited)

### control/prompt (Felleisen)
- prompt(M) is the delimiter
- control(k. N) captures up to nearest prompt, but does NOT include a reset around N

### Typing
- reset : (alpha -> alpha) -> alpha  (answer type must match)
- shift : ((alpha -> beta) -> beta) -> alpha

### Connection to Effects
- Delimited continuations can encode any monadic effect (Filinski 1994)
- Algebraic effect handlers are essentially a typed, structured form of delimited continuations
- Each handler acts as a delimiter; performing an operation captures to that delimiter
