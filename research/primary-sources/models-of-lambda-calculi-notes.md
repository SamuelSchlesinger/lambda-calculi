# Models of Typed Lambda Calculi

## Set-Theoretic Models

### STLC
The simply typed lambda calculus has a natural set-theoretic model:
- Base types interpreted as sets
- Function types A → B interpreted as set of all functions from ⟦A⟧ to ⟦B⟧
- Complete for βη-equivalence when base types are infinite sets

### System F: Reynolds' Impossibility Result
Citation: J. C. Reynolds. "Polymorphism is not Set-Theoretic."
Semantics of Data Types, LNCS 173, pp. 145-156, 1984.

Result: System F has no set-theoretic model (in classical set theory) that
interprets ∀ as intersection over all sets. The polymorphic type ∀α.α→α
would need to be simultaneously contained in and equal to a product of
all its instances, which is impossible for cardinality reasons.

Exception: Set-theoretic models exist if the ambient set theory is intuitionistic.

## Domain-Theoretic Models

### Citation
D. S. Scott. "Continuous Lattices." Toposes, Algebraic Geometry and Logic,
LNM 274, pp. 97-136, 1972.

### Key Ideas
- Scott (1969) constructed D∞, a domain isomorphic to its own continuous
  function space, giving the first mathematical model of untyped lambda calculus
- Domains are directed-complete partial orders (dcpos) with a bottom element ⊥
  representing non-termination
- Morphisms are Scott-continuous (preserve directed suprema)
- Provides denotational semantics for recursive types and general recursion

### Significance
- Foundation of denotational semantics (Scott-Strachey)
- Models non-termination and partiality naturally
- Extended to various domain categories (algebraic, continuous, etc.)

## Realizability Models

### Origins
Kleene (1945): number realizability for Heyting arithmetic
Kreisel (1959): modified realizability using typed lambda terms

### Key Idea
A formula φ is realized by a term t if t "witnesses" φ computationally.
- ∀x.φ(x) is realized by t if for all n, t n realizes φ(n)
- φ → ψ is realized by t if for all u realizing φ, t u realizes ψ

### Applications to Type Theory
- Modified realizability toposes model System F and CoC
- Realizability models validate Church's thesis and other constructive principles
- Used to extract programs from proofs

## Categorical Models

### Simply Typed Lambda Calculus ↔ Cartesian Closed Categories (CCCs)
Citation: J. Lambek. "From Lambda Calculus to Cartesian Closed Categories."
In To H.B. Curry: Essays on Combinatory Logic, 1980.

- Types = objects, terms = morphisms
- Product types = categorical products
- Function types = exponential objects
- β-reduction = evaluation morphism
- η-expansion = uniqueness of exponential transpose
- Curry-Howard-Lambek correspondence

### Dependent Type Theory ↔ Locally Cartesian Closed Categories (LCCCs)
Citation: R.A.G. Seely. "Locally Cartesian Closed Categories and Type Theory."
Mathematical Proceedings of the Cambridge Philosophical Society, 95(1), 1984.

- Dependent types modeled by morphisms (display maps)
- Σ-types = dependent sums (left adjoint to pullback)
- Π-types = dependent products (right adjoint to pullback)
- Subtlety: substitution is strict in syntax but up-to-iso categorically
  (resolved by Hofmann, Clairambault-Dybjer via split fibrations)

### Toposes
- Every elementary topos is a CCC
- Internal language of a topos is a higher-order intuitionistic logic
- Provide models of impredicative type theories
- Effective topos (Hyland) models realizability

### (∞,1)-Categories
- HoTT without univalence ↔ locally cartesian closed (∞,1)-categories
- HoTT with univalence ↔ elementary (∞,1)-toposes

## Presheaf Models

### Key Ideas
- Presheaves over a category C form a topos [C^op, Set]
- Used by Hofmann-Streicher for groupoid model (identity types)
- Cubical sets (presheaves on cube category) model cubical type theory
- Simplicial sets model HoTT
- Normalization by evaluation can be understood via glueing on presheaf categories

### Applications
- Proving canonicity and normalization
- Modeling univalence computationally
- Independence results (e.g., uniqueness of identity proofs is not derivable)
