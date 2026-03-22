# Wadler: Monads in Functional Programming

## Key Papers

### "The Essence of Functional Programming" (1992)
- **Author:** Philip Wadler
- **Venue:** 19th Symposium on Principles of Programming Languages (POPL), Albuquerque, NM, January 1992
- **URL:** https://jgbm.github.io/eecs762f19/papers/wadler-monads.pdf

Explores monads for structuring functional programs. Shows how an interpreter can be
incrementally extended with error handling, state, output, and nondeterminism by changing
only the monad, not the interpreter code.

### "Comprehending Monads" (1992)
- **Author:** Philip Wadler
- **Venue:** Mathematical Structures in Computer Science, 2(4), 1992
Shows that list comprehension notation generalizes to arbitrary monads.

### "Monads for Functional Programming" (1995)
- **Author:** Philip Wadler
- **Venue:** Advanced Functional Programming, First International Spring School, Bastad, 1995
- **PDF:** https://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf

Tutorial paper. Three case studies: (1) modifying a simple evaluator with monads,
(2) arrays with in-place update, (3) monadic parsing.

### "Imperative Functional Programming" (1993, with Peyton Jones)
- **Authors:** Simon Peyton Jones, Philip Wadler
- **Venue:** POPL 1993
Introduces the IO monad for Haskell.

### "The Marriage of Effects and Monads" (1998/2003)
- **Author:** Philip Wadler
Unifies effect typing and monadic approaches.

## Wadler's Monads Page
- https://homepages.inf.ed.ac.uk/wadler/topics/monads.html
