# Recursive Types

## Overview

Recursive types allow type definitions to refer to themselves, providing a general mechanism
for defining data structures of unbounded size---lists, trees, streams, and other recursive
data---within a typed lambda calculus. Rather than introducing each inductive data structure
as a separate language primitive, a single type-level recursion operator mu gives rise to all
of them.

The type `mu alpha. tau` denotes the fixed point of the type operator `alpha |-> tau`, meaning
the type tau where every occurrence of alpha has been replaced by the whole `mu alpha. tau`
itself. This simple idea has profound consequences: it enables the encoding of essentially all
common data types, but in its unrestricted form it also breaks strong normalization and renders
a type system Turing-complete.

Two fundamentally different approaches to recursive types have been studied: **iso-recursive**
types, where the recursion is explicitly mediated by `fold` and `unfold` operations, and
**equi-recursive** types, where a recursive type is silently identified with its unfolding.
These two approaches lead to quite different metatheories, implementation strategies, and
expressiveness trade-offs.

---

## Historical Context and Motivation

The study of recursive types has roots in several distinct traditions:

1. **Domain theory (late 1960s-1970s).** Dana Scott's work on providing mathematical models
   for the untyped lambda calculus required solving "domain equations" like D = [D -> D].
   Scott showed such equations have solutions in the category of continuous lattices, providing
   the first rigorous semantics for self-referential type definitions. The general theory of
   solutions of recursive domain equations was further developed by Smyth and Plotkin (1982).

2. **Programming language design (1970s-1980s).** Languages like ML and its descendants needed
   to type recursive data structures (lists, trees) that are fundamental to functional
   programming. The algebraic data type mechanisms in ML, Miranda, and Haskell can be
   understood as restricted forms of recursive types.

3. **Type theory (1980s).** Mendler (1987) studied the addition of least and greatest fixed
   point type constructors (mu and nu) to System F, establishing strong normalization under
   a positivity restriction. The Calculus of Inductive Constructions (Coquand and Paulin-Mohring,
   1990; Paulin-Mohring, 1993) incorporated inductive types---a disciplined form of recursive
   types---as core primitives.

4. **Subtyping and type equivalence (1990s).** Amadio and Cardelli (1993) gave the definitive
   treatment of equi-recursive subtyping, relating algorithmic, denotational, and axiomatic
   characterizations. Brandt and Henglein (1998) provided an elegant coinductive axiomatization.

---

## Iso-Recursive Types

### The Mu Binder: mu alpha. tau

In the iso-recursive approach, recursive types are introduced via a binding construct
`mu alpha. tau`, where `alpha` is a type variable that may appear free in `tau`. The type
`mu alpha. tau` represents the "solution" to the equation `alpha = tau`.

For example:
- Natural numbers: `Nat = mu alpha. 1 + alpha`
- Lists of A: `List A = mu alpha. 1 + A * alpha`
- Binary trees: `Tree A = mu alpha. A + alpha * alpha`

Crucially, in the iso-recursive approach, the type `mu alpha. tau` is **not** considered
equal to its unfolding `tau[mu alpha. tau / alpha]`. Instead, they are merely isomorphic,
and the programmer must use explicit coercion operations to move between them.

### Fold and Unfold Operations

The two operations mediating between a recursive type and its unfolding are:

- **fold** (also called "roll" or "in"): converts a value of the unfolded type into the
  recursive type.
- **unfold** (also called "unroll" or "out"): converts a value of the recursive type into
  the unfolded type.

These form an isomorphism:

```
fold   : tau[mu alpha. tau / alpha]  ->  mu alpha. tau
unfold : mu alpha. tau  ->  tau[mu alpha. tau / alpha]
```

### Typing Rules

The typing rules for iso-recursive types are:

```
  Gamma |- e : tau[mu alpha. tau / alpha]
  ----------------------------------------  (T-Fold)
  Gamma |- fold [mu alpha. tau] e : mu alpha. tau


  Gamma |- e : mu alpha. tau
  -----------------------------------------------  (T-Unfold)
  Gamma |- unfold [mu alpha. tau] e : tau[mu alpha. tau / alpha]
```

### Reduction: Fold/Unfold Cancellation

The key computational rule is that fold and unfold cancel each other:

```
  unfold (fold v)  -->  v       (where v is a value)
```

This is the only reduction rule involving fold/unfold. The operations are computationally
trivial---they are identity functions at runtime---but they play a crucial role in the
type system by mediating between the recursive type and its one-step unfolding.

### Connection to Algebraic Data Types

In practice, iso-recursive types correspond closely to how algebraic data types work in
languages like OCaml and Haskell:

- Each constructor implicitly performs a `fold`
- Each pattern match implicitly performs an `unfold`

For example, in OCaml, given `type nat = Zero | Succ of nat`:
- `Succ n` implicitly folds `Inr n` into type `nat`
- `match n with Zero -> ... | Succ m -> ...` implicitly unfolds `n`

---

## Equi-Recursive Types

### Type Equality Up to Unfolding

In the equi-recursive approach, a recursive type `mu alpha. tau` is considered **definitionally
equal** to its unfolding `tau[mu alpha. tau / alpha]`:

```
  mu alpha. tau  =  tau[mu alpha. tau / alpha]
```

No fold or unfold operations are needed; the type checker silently treats a recursive type and
its unfolding as interchangeable. This makes programming more convenient but complicates the
type theory and implementation.

The key insight is that if we unfold a mu-type repeatedly, we obtain an infinite tree. Two
mu-types are equal if and only if they give rise to the same infinite tree (equivalently, the
same regular tree, since mu-types always produce regular---i.e., finitely representable---
infinite trees).

### Amadio-Cardelli Algorithm for Equi-Recursive Subtyping

Amadio and Cardelli (1993) provided the definitive treatment, relating four characterizations
of equi-recursive type equality and subtyping:

1. **Tree model:** Types are interpreted as (possibly infinite) labeled trees. Two types are
   related if their tree interpretations are related by the natural extension of the subtyping
   relation on type constructors.

2. **Algorithmic characterization:** A decision procedure that maintains a set of "assumptions"
   (pairs of types assumed to be in the subtype relation) and checks subtyping by structural
   decomposition, adding new assumptions as recursive types are unfolded. The algorithm
   terminates because the set of subproblems is finite (bounded by pairs of subexpressions).

3. **Amber rules:** A set of inference rules named after Cardelli's Amber language, which
   carry a set of type variable pairs representing assumed subtyping relationships. When
   encountering `mu alpha. tau1 <: mu beta. tau2`, one adds the assumption `alpha <: beta`
   and checks `tau1 <: tau2` under this extended assumption set.

4. **Axiomatic characterization:** A formal proof system for deriving subtyping judgments.

Amadio and Cardelli showed that all four characterizations are equivalent (sound and complete
with respect to each other).

### Decidability of Type Equality

Type equality for equi-recursive types is decidable. The decision procedure works as follows:

1. Represent types as finite automata (or equivalently, as systems of recursive equations).
2. Check whether the two automata accept the same regular tree language.
3. This reduces to checking bisimilarity of finite-state systems, which is decidable in
   polynomial time.

More precisely, two mu-types are equal if and only if their canonical infinite unfoldings are
identical regular trees. Since regular trees are in bijection with states of deterministic
finite automata (up to bisimulation), equality is decidable.

### Regular Trees and Coinductive Characterization

A **regular tree** is an infinite tree with only finitely many distinct subtrees. Every mu-type
denotes a regular tree, and conversely, every regular tree can be represented by a mu-type.
Regular trees are equivalently:

- Solutions of finite systems of recursive equations
- Infinite trees recognized by finite automata
- The rational elements of the terminal coalgebra of the type constructor functor

The coinductive characterization (Brandt and Henglein, 1998) views type equality as the
greatest bisimulation on the tree representation of types. The key axiom is the **fixpoint
rule** (coinduction principle):

```
  A, P |- P       (where the derivation is contractive)
  ------
  A |- P
```

Here P is a type equality `tau = tau'` or containment `tau <= tau'`. The contractiveness
condition ensures that the coinductive proof makes progress, preventing trivial circular
reasoning.

---

## Comparison: Iso-Recursive vs Equi-Recursive Trade-offs

| Aspect                  | Iso-Recursive                        | Equi-Recursive                       |
|-------------------------|--------------------------------------|--------------------------------------|
| Type equality           | Syntactic (modulo alpha-equivalence) | Structural (infinite tree equality)  |
| Fold/unfold             | Explicit in terms                    | Implicit / not needed                |
| Type checking           | Simpler (syntax-directed)            | More complex (requires coinductive   |
|                         |                                      | algorithms for equality)             |
| Programming convenience | Less convenient (explicit coercions)  | More convenient (no coercions)       |
| Type inference          | Straightforward                      | Can infer unintended recursive types |
| Subtyping               | Simpler (Amber rules)                | Well-studied but complex algorithms  |
| Error messages          | More precise (fold/unfold localized)  | Can be confusing (unexpected types)  |
| Implementation          | Easier                               | Harder                               |

**Languages using iso-recursive types:** OCaml (default), Haskell, Rust, most ML-family
languages. Algebraic data type declarations act as iso-recursive type definitions with
implicit fold/unfold at constructors and pattern matches.

**Languages using equi-recursive types:** Java and C# (for class-based recursive types),
OCaml with `-rectypes` flag, TypeScript (structural type system).

The iso-recursive approach is overwhelmingly more common in practice because:
1. Algebraic data types naturally provide the fold/unfold discipline.
2. Equi-recursive type inference can accept programs that the programmer did not intend,
   silently inferring recursive types where none were expected.
3. Error messages are clearer when fold/unfold points are explicit.

---

## Recursive Types and Turing Completeness

Adding unrestricted recursive types to the simply typed lambda calculus makes the resulting
system Turing-complete and destroys strong normalization. The key construction is the
self-application type.

### Constructing Non-Termination

With the type `D = mu alpha. alpha -> alpha`, we can type the omega combinator:

```
  delta = lambda x : D. (unfold x) x
  omega = delta (fold delta)
```

Type checking:
- `x : D`, so `unfold x : D -> D`
- `(unfold x) x : D`
- `delta : D -> D`
- `fold delta : D`
- `omega = delta (fold delta) : D`

Evaluating omega:
```
  delta (fold delta)
  = (unfold (fold delta)) (fold delta)
  = delta (fold delta)
  = ...    (infinite loop)
```

### The Y Combinator

More generally, we can type the Y combinator (fixed-point combinator). Using
`T = mu alpha. alpha -> A` for any type A:

```
  Y = lambda f : (A -> A).
        (lambda x : T. f ((unfold x) x))
        (fold (lambda x : T. f ((unfold x) x)))
```

This gives `Y : (A -> A) -> A`, which is the type of a fixed-point combinator. The existence
of a typed fixed-point combinator means every type is inhabited, which destroys:
- Strong normalization (some well-typed terms diverge)
- Logical consistency (under the Curry-Howard correspondence, every proposition is "provable")
- The property that the type system can serve as a logic

### Preserving Normalization

To retain normalization while allowing recursive data types, one must restrict recursive types:
- **Strict positivity:** The recursive variable must not appear in negative position (to the
  left of an odd number of arrows). This is the approach taken by Coq/Lean/Agda.
- **Guarded recursion:** Recursive occurrences must appear under a constructor (a "guard").
- **Sized types:** Recursive types carry size annotations ensuring well-foundedness.

---

## Scott Encodings

Scott encodings provide an alternative to Church encodings for representing algebraic data
types in the lambda calculus. While Church encodings represent data by their fold (iterator),
Scott encodings represent data by their case analysis (eliminator).

### Definition

For a data type with constructors C_1, ..., C_n, the Scott encoding of a value built with
constructor C_i(v_1, ..., v_k) is:

```
  lambda c_1 ... c_n. c_i v_1 ... v_k
```

Each encoded value takes n arguments (one per constructor) and applies the one corresponding
to its actual constructor.

### Example: Natural Numbers

```
  0     = lambda s z. z
  suc n = lambda s z. s n
```

Contrast with Church numerals where `suc n = lambda s z. s (n s z)`. The Scott predecessor
is O(1): `pred n = n (lambda x. x) 0`, whereas the Church predecessor is O(n).

### Typing Requires Recursive Types

The type of Scott-encoded natural numbers satisfies:

```
  Nat = forall A. (Nat -> A) -> A -> A
```

This is a recursive type equation. In System F alone, this cannot be expressed. One needs
either:
- Recursive types: `Nat = mu alpha. forall A. (alpha -> A) -> A -> A`
- Or equivalently, System F extended with mu-types (System F-mu)

### Church-Scott Comparison

Church encodings can be typed in pure System F (no recursive types needed) but only support
iteration, not general recursion over the data. Scott encodings require recursive types but
support constant-time destructors and general recursion. The **Parigot encoding** (also called
Church-Scott encoding) combines both, providing both iteration and constant-time case analysis,
but at the cost of larger term representations.

---

## Mendler-Style Recursion

Mendler-style recursion, introduced by Nax Paul Mendler (1987), provides an alternative
approach to defining recursive functions over recursive types that avoids explicit fold/unfold
operations and does not require the type constructor to be a functor.

### The Key Idea

In conventional recursion over `mu F`, one needs:
1. F to be a functor (i.e., we need `fmap : (A -> B) -> F A -> F B`)
2. An F-algebra `phi : F A -> A`
3. The catamorphism `cata phi : mu F -> A`

Mendler-style recursion instead provides the recursive caller as an abstract function:

```
  mcata : (forall R. (R -> A) -> F R -> A) -> mu F -> A
```

The algebra `forall R. (R -> A) -> F R -> A` receives:
- A function `R -> A` representing the recursive call (where R is abstract)
- A value `F R` representing the current layer

Since R is abstract (universally quantified), the algebra cannot inspect or construct values
of type R---it can only use the provided recursive function. This ensures termination.

### Advantages

1. **No functor requirement:** The type constructor F need not support `fmap`. This is
   significant for types with negative occurrences.
2. **Guaranteed termination:** The parametricity of the abstract type R ensures that Mendler
   catamorphisms always terminate, even for non-strictly-positive type constructors.
3. **Uniform treatment:** Works for a broader class of recursive types than conventional
   catamorphisms.

### Categorical Connection

Uustalu and Vene (1999) showed that Mendler-style algebras correspond categorically to
algebras for the Yoneda embedding. Specifically, a Mendler algebra for F is equivalent to
a natural transformation from Hom(-, mu F) to Hom(F-, A), which by the Yoneda lemma gives
back the conventional F-algebra structure when F is a functor.

### Hierarchy of Mendler Combinators

Ahn and Sheard (2011) developed a hierarchy of Mendler-style recursion combinators:
- **mcata:** Mendler catamorphism (iteration)
- **mprim:** Mendler primitive recursion (access to original substructure)
- **mhist:** Mendler histomorphism (access to results of all sub-computations)
- **msfcata:** Mendler-style course-of-values iteration

Each level in the hierarchy provides strictly more expressive power while maintaining
termination guarantees.

---

## Recursive Types in System F

### Encoding via Impredicative Polymorphism

In pure System F (without recursive types), inductive types can be encoded using
impredicative polymorphism. The Church encoding of natural numbers is:

```
  Nat = forall alpha. (alpha -> alpha) -> alpha -> alpha
```

More generally, the least fixed point of a positive type operator F can be encoded as:

```
  mu F = forall alpha. (F alpha -> alpha) -> alpha
```

This works because a value of type `mu F` is essentially a "Church-encoded" fold: given any
F-algebra `F alpha -> alpha`, it produces a value of type `alpha`.

### Limitations of Impredicative Encodings

1. **Only iteration, not primitive recursion:** Church-encoded data supports the fold
   (catamorphism) pattern but not direct structural recursion. The predecessor function on
   Church naturals requires O(n) time because it must rebuild the entire numeral.

2. **Weak induction principles:** In the Calculus of Constructions, impredicatively encoded
   inductive types satisfy only weak (non-dependent) elimination, not the full dependent
   elimination principle needed for proofs by induction.

3. **Extensionality issues:** Two Church-encoded values that compute the same function on
   all algebras are propositionally equal, but proving this internally requires parametricity.

### Primitive Recursive Types

For these reasons, most typed lambda calculi used in practice extend System F with primitive
recursive types rather than relying on encodings:

- **System F-mu:** System F extended with iso-recursive mu-types. This is the standard
  theoretical framework for studying recursive types with polymorphism.
- **System F-omega-mu:** Adds type-level recursion to System F-omega (with higher-kinded
  type operators).

---

## Relationship to Inductive Types in CIC

### Inductive Types as "Guarded" Recursive Types

The inductive types of the Calculus of Inductive Constructions (CIC), as implemented in
Coq/Rocq and Lean, can be understood as a disciplined form of recursive types with two key
restrictions:

1. **Strict positivity:** The recursive type variable must occur only in strictly positive
   positions in the constructor types.
2. **Guarded recursion:** Recursive calls in fixpoint definitions must be on structurally
   smaller arguments (the guard condition).

These restrictions ensure:
- Strong normalization (all well-typed terms terminate)
- Logical consistency (the type system is sound as a logic)
- Decidable type checking

### Strict Positivity as a Restriction of General Recursion

A type constructor F(alpha) is **strictly positive** in alpha if alpha never appears to the
left of a function arrow in F. More precisely:

- alpha is strictly positive in alpha itself
- alpha is strictly positive in `T1 -> T2` if alpha does not occur in T1 and is strictly
  positive in T2
- alpha is strictly positive in `F T1 ... Tn` if alpha is strictly positive in each Ti
  (and F is itself an inductive type with only strictly positive recursive occurrences)

**Why is this needed?** Without strict positivity, one can construct non-terminating terms
and derive logical inconsistencies. The classic counterexample (Coquand and Paulin):

```
  Inductive bad := wrap : (bad -> bad) -> bad.
```

This allows defining:
```
  unwrap : bad -> (bad -> bad)
  omega : bad := wrap (fun x => (unwrap x) x)
```

which leads to `(unwrap omega) omega = omega` and non-termination.

More subtly, even non-strictly-positive (but positive) occurrences can cause problems in the
presence of impredicativity. The type:

```
  Inductive bad2 := r : ((bad2 -> Prop) -> Prop) -> bad2.
```

is positive (bad2 appears under two arrows) but not strictly positive, and it allows
reconstructing the Cantor-Russell paradox, yielding a proof of False. The three ingredients
that together enable this paradox are: (1) non-strictly-positive definitions, (2)
impredicativity, and (3) universe types. Removing any one preserves consistency.

### Inductive vs General Recursive Types

| Feature                | Inductive Types (CIC)          | General Recursive (mu) Types    |
|------------------------|--------------------------------|---------------------------------|
| Positivity restriction | Strictly positive only         | No restriction                  |
| Termination            | Guaranteed                     | Not guaranteed                  |
| Logical consistency    | Preserved                      | Destroyed                       |
| Dependent elimination  | Full (induction principles)    | Not available                   |
| Expressiveness         | Cannot express all recursive   | Can express all recursive types |
|                        | types (e.g., no negative rec.) |                                 |
| Fixed-point character  | Least fixed point (initial alg)| General fixed point             |

---

## Step-Indexed Logical Relations for Recursive Types

### The Problem

Constructing logical relations for languages with recursive types is challenging because the
standard approach defines the logical relation by induction on types---but recursive types
have no finite inductive structure.

### Appel-McAllester (2001): The Step-Indexed Approach

Appel and McAllester introduced the step-indexed technique for modeling recursive types in
the context of foundational proof-carrying code. The key idea: index the semantic
interpretation of types not only by the type itself, but also by a natural number k
representing the number of computation steps available.

The interpretation of `mu alpha. tau` at step index k is defined in terms of the
interpretation of `tau[mu alpha. tau / alpha]` at step index k-1. This is well-founded
because the step index decreases, even though the type "increases" through unfolding.

Formally, the value relation V[[tau]](k) defines when a closed value v is in the
interpretation of tau for k steps:

```
  v in V[[mu alpha. tau]](k)  iff  v = fold v'  and  v' in V[[tau[mu alpha. tau / alpha]]](k-1)
```

### Ahmed (2006): Logical Relations for Contextual Equivalence

Amal Ahmed extended the Appel-McAllester model to establish a logical relation that is:
- **Transitive** (the original model's transitivity was problematic)
- **Sound and complete** for contextual equivalence of a lambda-calculus with recursive types
  and impredicative polymorphism (universal and existential types)

The step-indexed logical relation defines when two terms are related at a type for k steps.
The key properties:
- Soundness: if two terms are logically related at all step indices, they are contextually
  equivalent
- Completeness: if two terms are contextually equivalent, they are logically related at all
  step indices (for recursive and universal types; only sound for existentials)

### Impact

Step-indexed logical relations have become the dominant technique for reasoning about
programs with recursive types, general references, and other features that resist traditional
inductive logical relations. The approach has been incorporated into major verification
frameworks including Iris and VST.

---

## Parametricity with Recursive Types

Parametricity (Reynolds, 1983; Wadler, 1989) states that polymorphic functions act uniformly
across all type instantiations. Extending parametricity to languages with recursive types is
non-trivial.

### Challenges

1. **Defining the logical relation:** The standard parametricity proof defines the logical
   relation by induction on types, which fails for recursive types (as discussed above).

2. **Interaction with fixed points:** One must verify that the existence of typed fixed-point
   combinators (arising from recursive types) does not violate the parametricity property.

3. **Combining with other features:** When recursive types are combined with general references
   or other stateful features, establishing parametricity requires sophisticated techniques
   such as possible-world semantics with world-indexed logical relations.

### Solutions

- **Step-indexed parametricity:** Ahmed (2006) showed how step-indexed logical relations can
  establish parametricity for System F with recursive types.
- **Relational parametricity for references and recursive types:** Dreyer, Neis, and Birkedal
  (2010) developed relational parametricity for a language combining impredicative polymorphism,
  general references, and recursive types using parameterized logical relations over a
  universal domain.

---

## Domain Equations and Their Connection to Recursive Types

### The Problem of Self-Reference

The fundamental problem that domain theory addresses is: how can we give meaning to type
definitions like `D = D -> D` or `D = 1 + D * D`? In naive set theory, the equation
`D = D -> D` has no non-trivial solution (the function space is always strictly larger than
the domain). Scott's breakthrough was recognizing that by restricting to **continuous functions**
on **domains** (certain partially ordered sets), such equations do have solutions.

### Solving Domain Equations

The general approach (Smyth and Plotkin, 1982) works in a category of domains where:

1. Each type constructor (product, function space, sum) extends to a functor on this category.
2. Recursive types correspond to fixed points of these functors.
3. Fixed points are constructed as limits of approximation chains:
   ```
   0  ->  F(0)  ->  F(F(0))  ->  F(F(F(0)))  ->  ...
   ```
   The colimit (or bilimit) of this chain gives the solution.

### Covariant vs Mixed-Variance

- For **covariant** (positive) type constructors, the functor is covariant and we can use
  Adamek's theorem: the colimit of the chain `0 -> F(0) -> F^2(0) -> ...` is an initial
  algebra (least fixed point).

- For **mixed-variance** type constructors (involving the function space), the functor
  operates on a category of embedding-projection pairs. The construction produces a
  **bilimit** that is simultaneously a limit and a colimit.

### Connection to Recursive Types

| Domain-Theoretic Concept    | Type-Theoretic Concept              |
|-----------------------------|-------------------------------------|
| Least fixed point           | Inductive type (mu)                 |
| Greatest fixed point        | Coinductive type (nu)               |
| Bilimit solution            | General recursive type              |
| Continuous function         | Monotone/well-behaved type operator |
| Embedding-projection pair   | fold/unfold isomorphism             |
| Approximation chain         | Iterated unfolding                  |

---

## Recursive Types in Practice

### OCaml

OCaml uses **iso-recursive** types by default. Every algebraic data type definition introduces
a new recursive type, with constructors acting as `fold` and pattern matching as `unfold`.

```ocaml
type nat = Zero | Succ of nat
(* Zero is fold (Inl ())  *)
(* Succ n is fold (Inr n) *)
(* match n with Zero -> ... | Succ m -> ... is unfold *)
```

OCaml also supports equi-recursive types via the `-rectypes` compiler flag, which allows
types like `'a -> 'a` to be unified with `'a`. By default, cycles in type expressions must
pass through an object type or polymorphic variant constructor; `-rectypes` removes this
restriction. The flag is rarely used in practice because it can mask programming errors
by silently inferring recursive types.

### Haskell

Haskell uses iso-recursive types through `data` and `newtype` declarations. The `newtype`
mechanism is particularly close to the theoretical fold/unfold:

```haskell
newtype Fix f = Fix { unFix :: f (Fix f) }
-- Fix  is fold
-- unFix is unfold
```

This pattern is the basis for recursion schemes (catamorphisms, anamorphisms, etc.) in
Haskell:

```haskell
data ListF a r = NilF | ConsF a r  deriving Functor
type List a = Fix (ListF a)

cata :: Functor f => (f a -> a) -> Fix f -> a
cata alg = alg . fmap (cata alg) . unFix
```

Haskell does not support equi-recursive types; every recursive type must be introduced via
a `data` or `newtype` declaration.

### TypeScript

TypeScript uses **equi-recursive** (structural) types, allowing recursive type aliases:

```typescript
type Json = string | number | boolean | null | Json[] | { [key: string]: Json };
type LinkedList<T> = { value: T; next: LinkedList<T> | null };
```

TypeScript's structural type system means that two structurally identical recursive types are
considered equal, regardless of their names. The type checker handles recursive types via
lazy unfolding with a recursion depth limit.

### Rust

Rust requires explicit indirection (via `Box`, `Rc`, etc.) for recursive types, which is
a form of iso-recursive typing where the heap allocation acts as the "guard":

```rust
enum List<T> {
    Nil,
    Cons(T, Box<List<T>>),  // Box provides indirection
}
```

---

## Categorical Semantics

### Initial Algebras

An **F-algebra** for an endofunctor F : C -> C consists of an object A and a morphism
`alpha : F(A) -> A`. An **initial F-algebra** is an initial object in the category of
F-algebras. By Lambek's lemma, the structure map of an initial algebra is an isomorphism:

```
  If (mu F, in : F(mu F) -> mu F) is initial, then in is an isomorphism.
  That is: mu F  is isomorphic to  F(mu F).
```

This is exactly the defining property of a recursive type: `mu alpha. F(alpha)` is
isomorphic to `F(mu alpha. F(alpha))`.

### Fixed Points of Functors

The initial algebra `mu F` is the **least fixed point** of F:
- It satisfies F(mu F) = mu F (up to isomorphism)
- It has a universal property: for any F-algebra `phi : F(A) -> A`, there is a unique
  homomorphism (catamorphism) `cata phi : mu F -> A`

Dually, the **terminal coalgebra** `nu F` is the **greatest fixed point**:
- It satisfies F(nu F) = nu F (up to isomorphism)
- For any F-coalgebra `psi : A -> F(A)`, there is a unique cohomomorphism (anamorphism)
  `ana psi : A -> nu F`

### Adamek's Theorem

For an endofunctor F on a category with an initial object 0 and countable colimits, if F
preserves colimits of omega-chains, then the initial algebra exists and is the colimit of:

```
  0  ->  F(0)  ->  F^2(0)  ->  F^3(0)  ->  ...
```

where the morphisms are obtained by applying F iteratively to the unique morphism `0 -> F(0)`.

### Examples

| Functor F(X)     | Initial Algebra mu F | Terminal Coalgebra nu F |
|------------------|----------------------|-------------------------|
| 1 + X            | Natural numbers N    | Conatural numbers N_inf |
| 1 + A * X        | Finite lists [A]     | Streams/partial lists   |
| A + X * X        | Finite binary trees  | Infinite binary trees   |
| X -> X           | No initial algebra   | (unrestricted recursion)|
|                  | (not positive)       |                         |

---

## Key References

### Foundational

1. Dana Scott. "Continuous Lattices." In *Toposes, Algebraic Geometry and Logic*,
   Springer LNM 274, 1972.

2. Dana Scott. "Data Types as Lattices." *SIAM Journal on Computing*, 5(3):522-587, 1976.

3. Gordon Plotkin and Michael Smyth. "The Category-Theoretic Solution of Recursive Domain
   Equations." *SIAM Journal on Computing*, 11(4):761-783, 1982.

### Metatheory of Recursive Types

4. Roberto M. Amadio and Luca Cardelli. "Subtyping Recursive Types." *ACM TOPLAS*,
   15(4):575-631, 1993.

5. Michael Brandt and Fritz Henglein. "Coinductive Axiomatization of Recursive Type Equality
   and Subtyping." *Fundamenta Informaticae*, 33(4):309-338, 1998.

6. Jens Palsberg, Mitchell Wand, and Patrick O'Keefe. "Efficient Recursive Subtyping."
   *Mathematical Structures in Computer Science*, 5(1):113-125, 1995.

### Inductive Types and Mendler-Style Recursion

7. Nax Paul Mendler. "Inductive Types and Type Constraints in the Second-Order Lambda
   Calculus." In *LICS 1987*, pages 30-36.

8. Thierry Coquand and Christine Paulin-Mohring. "Inductively Defined Types." In *COLOG-88*,
   Springer LNCS 417, 1990.

9. Tarmo Uustalu and Varmo Vene. "Mendler-Style Inductive Types, Categorically." *Nordic
   Journal of Computing*, 6(4):343-361, 1999.

10. Ki Yung Ahn and Tim Sheard. "A Hierarchy of Mendler Style Recursion Combinators: Taming
    Inductive Datatypes with Negative Occurrences." In *ICFP 2011*, ACM SIGPLAN Notices,
    46(9):234-246.

### Step-Indexed Models and Logical Relations

11. Andrew W. Appel and David McAllester. "An Indexed Model of Recursive Types for
    Foundational Proof-Carrying Code." *ACM TOPLAS*, 23(5):657-683, 2001.

12. Amal Ahmed. "Step-Indexed Syntactic Logical Relations for Recursive and Quantified Types."
    In *ESOP 2006*, Springer LNCS 3924, pages 69-83.

13. Derek Dreyer, Georg Neis, and Lars Birkedal. "The Impact of Higher-Order State and
    Control Effects on Local Relational Reasoning." *JFP*, 22(4-5):477-528, 2012.

### Parametricity

14. John C. Reynolds. "Types, Abstraction and Parametric Polymorphism." In *Information
    Processing 83*, pages 513-523, 1983.

15. Philip Wadler. "Theorems for Free!" In *FPCA 1989*, pages 347-359.

16. Amal Ahmed, Derek Dreyer, and Andreas Rossberg. "State-Dependent Representation
    Independence." In *POPL 2009*.

### Encodings

17. Herman Geuvers. "The Church-Scott Representation of Inductive and Coinductive Data."
    Types 2014 workshop, 2014.

18. Michel Parigot. "Recursive Programming with Proofs." *Theoretical Computer Science*,
    94(2):335-356, 1992.

### Textbooks

19. Benjamin C. Pierce. *Types and Programming Languages*. MIT Press, 2002. Chapters 20-21.

20. Robert Harper. *Practical Foundations for Programming Languages*. Cambridge University
    Press, 2nd edition, 2016. Chapter 15.

21. Samson Abramsky and Achim Jung. "Domain Theory." In *Handbook of Logic in Computer
    Science*, Vol. 3, Oxford University Press, 1994.

### Categorical Semantics

22. Jiri Adamek and Jiri Rosicky. *Locally Presentable and Accessible Categories*. Cambridge
    University Press, 1994.

23. Bart Jacobs. *Categorical Logic and Type Theory*. Elsevier, 1999.

24. Francois Metayer. "Fixed Points of Functors." Unpublished note, IRIF.
    https://www.irif.fr/~metayer/PDF/fix.pdf

---

## Cross-References

- **Doc 01 (Untyped Lambda Calculus):** The Y combinator from the untyped lambda calculus can be typed using recursive types, demonstrating how general recursion re-emerges in a typed setting through the mu type constructor.

- **Doc 07 (Calculus of Inductive Constructions):** Inductive types in CIC can be understood as recursive types restricted by strict positivity and guarded recursion, ensuring termination and logical consistency.

- **Doc 08 (Coinductive Constructions):** Coinductive types are the greatest fixed points of type operators, dual to the least fixed points (inductive/recursive types), and model infinite data such as streams and processes.

- **Doc 10 (Metatheory and Correctness):** Step-indexed logical relations, developed by Appel-McAllester and Ahmed, are the principal technique for establishing semantic properties of languages with recursive types where standard inductive methods fail.
