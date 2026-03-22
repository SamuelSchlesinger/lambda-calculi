# Mitchell & Plotkin: Abstract Types Have Existential Type (1988)

## Source
John C. Mitchell and Gordon D. Plotkin, "Abstract types have existential type," ACM Transactions on Programming Languages and Systems (TOPLAS), vol. 10, no. 3, pp. 470–502, 1988.

## Summary
Mitchell and Plotkin established the foundational connection between abstract data types (ADTs) in programming languages and existential types in second-order lambda calculus. They introduced SOL, a second-order typed lambda calculus with existential types, and showed that abstract type declarations in languages like CLU, Ada, and ML can be encoded using existential quantification.

## Key Ideas

### Existential Types as ADTs
An existential type ∃α.τ packages:
- A hidden representation type (the witness for α)
- Operations on that type (described by τ)

### Encoding in System F
Existential types can be encoded in System F using the Church encoding:
  ∃α.τ  ≡  ∀β.(∀α.τ → β) → β

### Operations
- **pack**: Creates an existential package by providing a witness type and implementation
- **unpack** (or open/elim): Uses an existential package, with the representation type held abstract

### Significance
This work showed that data abstraction is a type-theoretic concept, providing formal foundations for module systems and information hiding in programming languages.
