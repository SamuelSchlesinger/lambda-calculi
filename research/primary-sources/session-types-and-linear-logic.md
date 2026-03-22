# Session Types and Linear Logic

## Key Papers

### Honda, K. (1993). Types for Dyadic Interaction. CONCUR 1993.
- Introduces session types for structured communication protocols
- Processes communicate through session channels connecting exactly two subsystems
- Actions occur in dual pairs: send/receive, offer/select

### Caires, L. and Pfenning, F. (2010). Session Types as Intuitionistic Linear Propositions.
- Linear logic propositions correspond to session types
- Programming language is a session-typed pi-calculus
- Type structure consists of connectives of intuitionistic linear logic
- Published in CONCUR 2010

### Wadler, P. (2012). Propositions as Sessions. ICFP 2012.
- Classical linear logic propositions as session types
- Presents CP calculus and GV (linear functional language)
- Translation from GV into CP
- Deadlock freedom follows from linear logic correspondence
- Cut reduction = communication

## Correspondence Table
- A ⊗ B: Send A then behave as B
- A ⅋ B: Receive A then behave as B
- A ⊕ B: Select between A and B
- A & B: Offer choice between A and B
- !A: Server (replicable session)
- 1: Close channel

## Sources
- Wadler: https://homepages.inf.ed.ac.uk/wadler/papers/propositions-as-sessions/propositions-as-sessions.pdf
- Caires-Pfenning: https://www.cs.cmu.edu/~fp/papers/mscs13.pdf
