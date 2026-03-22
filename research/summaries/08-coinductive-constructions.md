# Co-Inductive Types and Co-Inductive Constructions

## Overview

Coinductive types extend the Calculus of Inductive Constructions (see Doc 07) with types defined by their observations rather than their constructors. Where CIC's inductive types are characterized as least fixed points (initial algebras), coinductive types are greatest fixed points (final coalgebras), enabling the representation of potentially infinite data and non-terminating interactive processes within a total, consistent type theory.

Coinductive types are the categorical dual of inductive types. Where inductive types model finite data built from constructors (least fixed points of functors, initial algebras), coinductive types model potentially infinite data characterized by observations (greatest fixed points of functors, final/terminal coalgebras). Coinduction provides both a method of definition (corecursion) and a method of proof (the coinduction principle, of which bisimulation is the most prominent instance).

Coinductive types are essential for representing infinite data structures such as streams, infinite trees, and non-terminating processes. They are crucial in the formal verification of reactive systems and concurrent programs, and they appear throughout theoretical computer science in process algebra, automata theory, and the semantics of programming languages.

**Cross-references:** The Calculus of Inductive Constructions, which coinductive types extend, is described in Doc 07. The underlying Calculus of Constructions is covered in Doc 06. Metatheoretic properties relevant to coinductive types (strong normalization, consistency, subject reduction) are surveyed in Doc 10.

---

## 1. Historical Context

### 1.1 Coalgebra in Mathematics

The mathematical theory of coalgebras emerged as a dual to the well-established theory of universal algebra. While algebras describe how to construct complex objects from simpler parts (via operations), coalgebras describe how to observe or decompose objects (via transitions or projections). The categorical framework for coalgebras was developed extensively by Rutten, Jacobs, and others through the 1990s and 2000s. Bart Jacobs' *Introduction to Coalgebra: Towards Mathematics of States and Observation* (Cambridge University Press, 2016) serves as the definitive modern reference, presenting coalgebra as "the mathematics of computational dynamics," unifying ideas from dynamical systems theory and state-based computation.

### 1.2 Aczel's Non-Well-Founded Sets

Peter Aczel's *Non-Well-Founded Sets* (1988) provided a set-theoretic foundation for circular and infinite structures. The standard Axiom of Foundation in ZFC set theory prohibits infinite descending membership chains (e.g., sets containing themselves). Aczel's Anti-Foundation Axiom (AFA), first studied by Forti and Honsell (1983), replaces Foundation with the principle:

> **AFA:** Every accessible pointed graph (apg) has a unique decoration.

An accessible pointed graph is a directed graph with a distinguished node such that every node is reachable from the distinguished node. A *decoration* assigns a set to each node such that the set assigned to a node equals the collection of sets assigned to its children. AFA asserts that such decorations exist and are unique, allowing equations like x = {x} to have exactly one solution (the Quine atom).

The connection to coalgebra is direct: AFA provides a set-theoretic manifestation of final coalgebras. Two nodes in a graph receive the same decoration if and only if a bisimulation relates them, linking AFA to the coinductive proof method.

### 1.3 Milner's CCS and the Discovery of Bisimulation

Robin Milner developed the Calculus of Communicating Systems (CCS) in the late 1970s as a formal framework for reasoning about concurrent processes. Milner initially used an inductively defined notion of observational equivalence based on a monotone functional over a complete lattice.

David Park (1981) made the crucial contribution of formalizing and naming *bisimulation* as a concept and developing the associated proof technique. Park, drawing on his expertise in fixed-point theory, defined *bisimilarity* as the greatest fixed point of the relevant functional and showed how to establish equivalence of processes by exhibiting a bisimulation relation. Milner immediately and enthusiastically adopted Park's formulation, making it the cornerstone of the theory of CCS.

This historical development is significant: bisimulation, the most widely used instance of coinduction, arose precisely from the recognition that greatest fixed points (coinductive definitions) were needed where least fixed points (inductive definitions) fell short.

---

## 2. Duality with Inductive Types: Initial Algebras vs. Final Coalgebras

### 2.1 F-Algebras and Initial Algebras

Given an endofunctor F : C -> C on a category C, an **F-algebra** is a pair (A, alpha) where A is an object of C and alpha : F(A) -> A is a morphism. A homomorphism between F-algebras (A, alpha) and (B, beta) is a morphism h : A -> B such that:

```
h . alpha = beta . F(h)
```

An **initial F-algebra** is an initial object in the category of F-algebras: for every F-algebra (B, beta), there exists a unique homomorphism from the initial algebra to (B, beta). This unique morphism is the *catamorphism* (fold), which captures the principle of structural recursion.

**Lambek's Lemma (for algebras):** If (A, alpha) is an initial F-algebra, then alpha is an isomorphism: F(A) ~ A. This means the carrier of the initial algebra is a fixed point of F -- specifically, the *least* fixed point.

The natural numbers N are the initial algebra for the functor F(X) = 1 + X, where 1 + X represents the coproduct (disjoint union). The algebra structure alpha : 1 + N -> N provides zero (from the 1 component) and successor (from the X component).

### 2.2 F-Coalgebras and Final Coalgebras

Dually, an **F-coalgebra** is a pair (C, gamma) where C is an object of C and gamma : C -> F(C) is a morphism. A homomorphism between F-coalgebras (C, gamma) and (D, delta) is a morphism h : C -> D such that:

```
delta . h = F(h) . gamma
```

A **final (terminal) F-coalgebra** is a terminal object in the category of F-coalgebras: for every F-coalgebra (C, gamma), there exists a unique homomorphism from (C, gamma) to the final coalgebra. This unique morphism is the *anamorphism* (unfold), which captures the principle of coiteration/corecursion.

**Lambek's Lemma (for coalgebras):** If (Z, zeta : Z -> F(Z)) is a final F-coalgebra, then zeta is an isomorphism: Z ~ F(Z). The carrier of the final coalgebra is a fixed point of F -- specifically, the *greatest* fixed point.

*Proof sketch:* Construct a coalgebra structure on F(Z) via F(zeta) : F(Z) -> F(F(Z)). By finality, there exists a unique coalgebra morphism f : F(Z) -> Z. One shows f . zeta = id_Z and zeta . f = id_{F(Z)}, establishing the isomorphism.

### 2.3 The Duality Summarized

| Concept | Inductive (Algebraic) | Coinductive (Coalgebraic) |
|---|---|---|
| Categorical semantics | Initial F-algebra | Final F-coalgebra |
| Fixed point | Least fixed point (mu) | Greatest fixed point (nu) |
| Structure map direction | F(A) -> A (constructors) | C -> F(C) (observations) |
| Definitional principle | Recursion (catamorphism) | Corecursion (anamorphism) |
| Proof principle | Induction | Coinduction |
| Data character | Finite, well-founded | Potentially infinite |
| Defining property | How to build | How to observe |

### 2.4 Adamek's Theorem

**Theorem (Adamek):** If C has a terminal object 1 and the limit L of the chain:

```
... -> F^3(1) -> F^2(1) -> F(1) -> 1
```

exists and is preserved by F, then L carries a final F-coalgebra structure.

This is dual to the construction of initial algebras as colimits of chains starting from the initial object 0.

---

## 3. Coinductive Types: Syntax and Formation Rules

### 3.1 Formation Rules

In type theory, a coinductive type is introduced by specifying its *destructors* (observations/projections), dual to specifying constructors for inductive types. Given a type former M and destructors d_1, ..., d_n, the coinductive type is characterized by:

**Formation rule:**
```
         Gamma |- A_1 type   ...   Gamma |- A_n type
         -----------------------------------------------
                  Gamma |- nu X. F(X) type
```

where F is a (strictly positive) type operator.

### 3.2 Introduction Rules (Corecursion)

The introduction rule for coinductive types is corecursion. Given a "seed" type S and functions specifying each observation:

```
   Gamma |- s : S    Gamma |- f_1 : S -> A_1   ...   Gamma |- f_n : S -> A_n x S
   ---------------------------------------------------------------------------------
                         Gamma |- corec(s, f_1, ..., f_n) : nu X. F(X)
```

### 3.3 Elimination Rules (Destructors/Observations)

Elimination is by observation (projection):

```
   Gamma |- t : nu X. F(X)
   -------------------------
   Gamma |- d_i(t) : A_i          (for each destructor d_i)
```

### 3.4 Computation Rules (beta-reduction)

```
   d_i(corec(s, f_1, ..., f_n)) -->  f_i(s)       (for non-recursive components)
   d_j(corec(s, f_1, ..., f_n)) -->  corec(g(s), f_1, ..., f_n)  (for recursive components)
```

where g extracts the new seed from the old one.

### 3.5 Uniqueness Principle (eta-expansion)

The eta rule for coinductive types states that any element is determined by its observations:

```
   t = corec(t, d_1, ..., d_n)
```

This rule is computationally problematic and is often omitted or treated propositionally rather than definitionally. In Agda, eta-equality for coinductive records is disabled by default because it can cause the type checker to loop. In Coq, propositional eta-equality for coinductive types can be recovered through an axiom.

---

## 4. Examples

### 4.1 Streams

Streams (infinite sequences) are the paradigmatic coinductive type. For a type A, Stream A is the final coalgebra of the functor F(X) = A x X.

**Destructor signature:**
```
head : Stream A -> A
tail : Stream A -> Stream A
```

**In Coq:**
```coq
CoInductive Stream (A : Type) : Type :=
  Cons : A -> Stream A -> Stream A.
```

**In Agda (coinductive record):**
```agda
record Stream (A : Set) : Set where
  coinductive
  field
    hd : A
    tl : Stream A
```

**Example -- the stream of natural numbers from n:**
```coq
CoFixpoint from (n : nat) : Stream nat := Cons n (from (S n)).
```

**In Agda with copatterns:**
```agda
from : Nat -> Stream Nat
hd (from n) = n
tl (from n) = from (suc n)
```

### 4.2 Colists (Potentially Infinite Lists)

Colists are the final coalgebra of F(X) = 1 + A x X. They may be finite (terminating with nil) or infinite.

```agda
record Colist (A : Set) : Set where
  coinductive
  field
    decons : Maybe (A x Colist A)
```

Alternatively, in Coq:
```coq
CoInductive CoList (A : Type) : Type :=
  | conil : CoList A
  | cocons : A -> CoList A -> CoList A.
```

Colists are important because they demonstrate a key difference from streams: the filter function is definable on colists but not productively so (one cannot guarantee that a matching element will ever be found).

### 4.3 Infinite Trees

Infinite (potentially) binary trees are the final coalgebra of F(X) = A x X x X:

```agda
record Tree (A : Set) : Set where
  coinductive
  field
    label : A
    left  : Tree A
    right : Tree A
```

More generally, infinitely branching trees with branching factor given by a type B are the final coalgebra of F(X) = A x (B -> X).

### 4.4 Processes (Labelled Transition Systems)

Process types capture the behavior of concurrent systems. A simple process type for a set of actions Act:

```agda
record Process : Set where
  coinductive
  field
    step : Act -> Maybe Process
```

This models a labelled transition system: at each state, for each action, the process either transitions to a new state or is undefined (deadlocks).

### 4.5 Conatural Numbers

The conatural numbers are the final coalgebra of F(X) = 1 + X, representing natural numbers extended with infinity:

```agda
record Conat : Set where
  coinductive
  field
    pred : Maybe Conat
```

The element infinity is defined corecursively:
```agda
omega : Conat
pred omega = just omega
```

---

## 5. Corecursion and Coiteration

### 5.1 Coiteration (Anamorphism)

The **coiteration** (or anamorphism) principle arises directly from the finality of the terminal coalgebra. Given a functor F with final coalgebra (Z, zeta), for any F-coalgebra (S, sigma : S -> F(S)), there exists a unique morphism unfold(sigma) : S -> Z making the following diagram commute:

```
    S ----sigma----> F(S)
    |                  |
 unfold(sigma)     F(unfold(sigma))
    |                  |
    v                  v
    Z ----zeta-----> F(Z)
```

Concretely, for streams (F(X) = A x X), a coiterator takes a seed s : S and functions:
- obs : S -> A (the observation)
- next : S -> S (the state transition)

and produces the stream obs(s), obs(next(s)), obs(next(next(s))), ...

### 5.2 Primitive Corecursion (Apomorphism)

**Primitive corecursion** (apomorphism) generalizes coiteration by allowing the corecursive process to stop early by providing a value from the final coalgebra directly. For streams with F(X) = A x X, a corecursor takes:
- obs : S -> A
- next : S -> S + Z  (either continue with a new seed, or stop with a stream)

Corecursion is not more expressive than coiteration (corec can be defined in terms of coiter), but it is more convenient in practice.

### 5.3 Course-of-Value Coiteration (Futumorphism)

The **futumorphism** dualizes the histomorphism. Where a histomorphism has access to all previously computed results (the "history"), a futumorphism can produce multiple layers of output at once (the "future"). This is captured by replacing F with the cofree comonad on F in the coiteration scheme.

### 5.4 Corecursion in Type Theory

In type-theoretic settings, corecursion is typically expressed through cofixpoint definitions. The key constraint is that such definitions must be *productive*: every finite prefix of the output must be computable in finite time. This is enforced through various mechanisms discussed in the next section.

---

## 6. Productivity and the Guardedness Condition

### 6.1 The Need for Productivity Checking

Without restrictions on corecursive definitions, one could write non-productive definitions that loop forever without producing any output, leading to logical inconsistency in proof assistants. For example:

```coq
(* This would be unsound if allowed: *)
CoFixpoint bad : Stream nat := bad.
```

This "definition" never produces any constructor, so it cannot be unfolded to yield a head element. In a proof assistant, allowing such definitions would let one prove False.

Productivity is the coinductive analogue of termination: a corecursive definition is productive if every observation on the result can be computed in finite time. Formally, a stream definition is productive if for every n, the first n elements can be computed in finite time.

### 6.2 Syntactic Guardedness (Gimenez, Coquand)

The **guardedness condition**, introduced by Gimenez (1994, 1995) and building on ideas of Coquand, is a syntactic criterion ensuring productivity. The condition requires:

> Each corecursive call in the definition must be directly under (guarded by) at least one constructor of the coinductive type, and only by constructors.

**Formally:** In a cofixpoint definition `CoFixpoint f (x) := body`, every occurrence of `f` in `body` must appear as a direct argument to a constructor of the coinductive type being defined. No function applications, case analyses, or other eliminations may intervene between the constructor and the recursive call.

**Example (accepted):**
```coq
CoFixpoint from (n : nat) : Stream nat := Seq n (from (S n)).
```
Here `from (S n)` is directly under the constructor `Seq`.

**Example (rejected):**
```coq
CoFixpoint filter (p : nat -> bool) (s : Stream) : Stream :=
  if p (hd s) then Seq (hd s) (filter p (tl s))
  else filter p (tl s).
```
In the `else` branch, `filter p (tl s)` is not under any constructor. This is correctly rejected: if no element of the stream satisfies `p`, the filter would never produce output.

### 6.3 Why Syntactic Guardedness is Necessary but Limited

The guardedness condition is decidable and simple to implement, but it is overly conservative. It rejects many definitions that are in fact productive:

1. **Composition of corecursive functions:** If `f` and `g` are both productive corecursive functions, `f . g` may be rejected because the guardedness checker does not look through function definitions.

2. **Higher-order corecursion:** Passing a corecursive function as an argument to a higher-order function breaks guardedness, even when the higher-order function preserves productivity.

3. **Corecursion through intermediate data structures:** Building an intermediate inductive structure and then converting it to a coinductive one may fail the guardedness check.

4. **Process-like definitions:** Many natural definitions of processes and reactive systems involve case analysis on input before producing output, which can violate guardedness.

The fundamental issue is that syntactic guardedness is a *local* criterion applied to the *syntax* of a definition, but productivity is a *global* semantic property. No decidable criterion can be both sound and complete for productivity (since productivity is Pi^0_2-complete in the arithmetic hierarchy).

### 6.4 Gimenez's Analysis of the Guard Condition

Gimenez's 1995 paper "Codifying guarded definitions with recursive schemes" formalized an extension of the Calculus of Constructions with inductive and coinductive types. Key contributions include:

- Showing that the conditions for accepting recursive definitions from Martin-Lof's type theory were not sufficient for the Calculus of Constructions, necessitating modifications.
- Developing a general method to codify fixpoint definitions using well-known recursive schemes (primitive recursion and corecursion).
- Providing the theoretical basis for Coq's `CoFixpoint` mechanism.

---

## 7. Copatterns (Abel, Pientka, Thibodeau, Setzer)

### 7.1 Motivation and Core Idea

Copatterns, introduced by Abel, Pientka, Thibodeau, and Setzer (POPL 2013), provide a programming paradigm for defining coinductive data through *observations* rather than *constructions*. The key insight is:

- **Inductive types** are defined by their constructors and eliminated by pattern matching (analyzing how data was built).
- **Coinductive types** are defined by their destructors/observations and introduced by copattern matching (specifying how data is observed).

This leads to a symmetric language design where patterns and copatterns can be freely mixed.

### 7.2 Observation-Based Semantics

In the copattern approach, one defines a coinductive value by specifying what each observation/destructor returns when applied to it. For a stream:

```agda
record Stream (A : Set) : Set where
  coinductive
  constructor _:>_
  field
    head : A
    tail : Stream A
```

A stream is defined not by saying "here is a constructor application" but by saying "here is what you get when you observe the head" and "here is what you get when you observe the tail":

```agda
zeros : Stream Nat
head zeros = 0
tail zeros = zeros
```

### 7.3 Mixing Patterns and Copatterns

A crucial advantage of copatterns is that they compose naturally with ordinary patterns. One can define a function by simultaneously pattern-matching on arguments and copattern-matching on results:

```agda
zipWith : {A B C : Set} -> (A -> B -> C) -> Stream A -> Stream B -> Stream C
head (zipWith f sa sb) = f (head sa) (head sb)
tail (zipWith f sa sb) = zipWith f (tail sa) (tail sb)
```

More complex examples mix nested copatterns with standard pattern matching:

```agda
cycleNats : Nat -> Nat -> Stream Nat
head (cycleNats _ x) = x
tail (cycleNats N zero) = cycleNats N N
tail (cycleNats N (suc x)) = cycleNats N x
```

### 7.4 Typing and Operational Semantics

Abel et al. present a core language with a type system and operational semantics based on (co)pattern matching. Key properties:

- **Type soundness** is proved for the core language.
- The language naturally supports both call-by-name and call-by-value interpretations.
- **Coverage checking** for copatterns ensures that all observations are defined.
- The approach can be seamlessly integrated into existing languages like Haskell and ML.

### 7.5 Follow-Up Work

- **Unnesting of Copatterns** (Setzer, Abel, Pientka, Thibodeau, 2014): Addresses the transformation of nested copattern definitions into simpler forms.
- **Wellfounded Recursion with Copatterns** (Abel and Pientka, ICFP 2013): Combines copatterns with sized types to provide a unified approach to termination and productivity checking.
- **Normalization results:** Strong normalization has been proved for a core language based on System F-omega with patterns and copatterns.

---

## 8. Bisimulation and Coinductive Proofs

### 8.1 The Coinduction Proof Principle

The coinduction proof principle is dual to induction. While induction proves that a property holds for *all* elements of an inductively defined set (by showing it holds for base cases and is preserved by constructors), coinduction proves that two elements of a coinductively defined type are *equal* (or related) by exhibiting a bisimulation.

**Lattice-theoretic formulation (Knaster-Tarski):** Let F be a monotone function on a complete lattice L. Then:
- The least fixed point mu(F) = intersection of all F-closed sets (pre-fixed points): mu(F) = inf { X | F(X) <= X }
- The greatest fixed point nu(F) = union of all F-consistent sets (post-fixed points): nu(F) = sup { X | X <= F(X) }

The **coinduction proof principle** states: To show x in nu(F), it suffices to find a set X such that x in X and X <= F(X) (i.e., X is F-consistent or a "post-fixed point").

### 8.2 Bisimulation Relations

A **bisimulation** on a coalgebra (or between two coalgebras) is a relation R satisfying the requirement that related states have matching observations and their successors are again related.

For labelled transition systems with transitions s --a--> s':

A relation R is a **bisimulation** if whenever (s, t) in R:
1. If s --a--> s', then there exists t' such that t --a--> t' and (s', t') in R.
2. If t --a--> t', then there exists s' such that s --a--> s' and (s', t') in R.

Two states s and t are **bisimilar** (written s ~ t) if there exists a bisimulation R with (s, t) in R. Bisimilarity is the greatest bisimulation, i.e., the union of all bisimulations.

For streams, a bisimulation is a relation R on Stream A such that whenever R(s, t):
- head(s) = head(t)
- R(tail(s), tail(t))

### 8.3 The Coinduction Proof Method

To prove that two coinductive values x and y are bisimilar:
1. Define a relation R such that (x, y) in R.
2. Show that R is a bisimulation (i.e., R is F-consistent).
3. Conclude x ~ y by the coinduction principle.

**Example:** Prove that `map f (repeat a) ~ repeat (f a)` for streams.

Define R = { (map f (repeat a), repeat (f a)) | a : A }.

Show R is a bisimulation:
- head(map f (repeat a)) = f(a) = head(repeat (f a)). Check.
- tail(map f (repeat a)) = map f (tail (repeat a)) = map f (repeat a).
- tail(repeat (f a)) = repeat (f a).
- So (tail(map f (repeat a)), tail(repeat (f a))) in R. Check.

### 8.4 Bisimulation Up-To Techniques

Plain bisimulations can be very large, making proofs cumbersome. **Bisimulation up-to** techniques allow working with smaller relations by permitting certain enhancements:

- **Bisimulation up to bisimilarity:** R need not itself be a bisimulation; it suffices that related states can reach related successors *up to bisimilarity*. Formally, R is a bisimulation up to ~ if R <= F(~ . R . ~), where . denotes relational composition.

- **Bisimulation up to equivalence closure:** R need not be an equivalence relation; it suffices to show that its reflexive-symmetric-transitive closure is a bisimulation.

- **Bisimulation up to context:** In process algebras, R need only relate subterms; contexts can be filled in around related terms.

The soundness of up-to techniques requires careful analysis. Notably, the class of sound up-to functions is not closed under arbitrary composition, necessitating a systematic theory of compatible up-to techniques (Pous and Sangiorgi).

### 8.5 Coinductive Predicates

Beyond bisimulation (a binary relation), coinduction can define unary predicates. For example, the predicate "always eventually produces output" on processes, or "infinitely often satisfies P" on streams, are naturally coinductive.

---

## 9. Sized Types as Alternative to Guardedness

### 9.1 Motivation

The syntactic guardedness condition is simple but overly restrictive. Sized types, introduced by Hughes, Pareto, and Sabry (1996) and extensively developed by Abel (2006, 2008, 2010, 2017) and others (Amadio and Coupet-Grimal 1998; Barthe et al. 2004; Sacchini 2013, 2015), provide a *type-based* approach to termination and productivity checking that is more compositional and expressive.

### 9.2 Core Ideas

Sized types annotate (co)inductive types with *size* information indicating the depth of construction or observation:

- For **inductive types**, the size bounds the *height* of the value: Nat^i means a natural number built with at most i constructors. Recursive functions on Nat^i must produce calls on values of size < i, ensuring termination.

- For **coinductive types**, the size bounds the *depth of observation*: Stream^i A means a stream that can be observed to at least depth i. Corecursive functions producing Stream^i must guarantee that the result can be observed to depth i, ensuring productivity.

Size variables range over ordinals, with a distinguished size omega representing the fully infinite (unlimited) case. The key typing principle:

```
If  f : forall i. Stream^i A -> Stream^i B
then  f : Stream^omega A -> Stream^omega B
```

### 9.3 Size Annotations and Subtyping

The size system includes:
- **Size variables:** i, j, k, ...
- **Successor size:** i+1 (also written s(i) or i^)
- **Limit size:** omega (the size of fully infinite objects)
- **Size polymorphism:** forall i. ...
- **Size subtyping:** If i <= j, then Stream^i A is a subtype of Stream^j A (a stream observable to greater depth is also observable to lesser depth). Note: this is *contravariant* for inductive types (Nat^i <= Nat^j when i <= j) and also covariant for coinductive types.

### 9.4 Advantages over Syntactic Guardedness

1. **Compositionality:** Sized types allow productive corecursive definitions to be composed. If `f : Stream^i A -> Stream^i B` and `g : Stream^i B -> Stream^i C`, then `g . f : Stream^i A -> Stream^i C` is automatically productive.

2. **Higher-order functions:** Functions like `map` get informative size types, allowing them to be used freely in corecursive definitions without breaking the productivity check.

3. **Separation of concerns:** Productivity checking is reduced to type checking. The size information in types carries the productivity argument, so no separate syntactic check is needed.

4. **Mixed induction-coinduction:** Sized types handle the interaction of recursion and corecursion naturally, tracking both the decrease of inductive arguments and the increase of coinductive results.

### 9.5 Example

With sized types, the problematic `map` composition is handled:

```agda
map : forall {i A B}. (A -> B) -> Stream A {i} -> Stream B {i}
hd (map f s) = f (hd s)
tl (map f s) = map f (tl s)
```

The size annotation `{i}` ensures that `map` preserves the observation depth, making it safe to use in corecursive definitions:

```agda
interleave : forall {i A}. Stream A {i} -> Stream A {i} -> Stream A {i}
hd (interleave s t) = hd s
tl (interleave s t) = interleave t (tl s)
```

### 9.6 Implementations

- **Agda** has built-in support for sized types, integrated with copatterns and the termination/productivity checker. This is the most mature implementation.
- **Coq/Rocq:** Sacchini (2013, 2015) developed CIC^hat, a version of the Calculus of Inductive Constructions with sized types. A prototype implementation exists but sized types are not part of the standard Coq distribution.
- **MiniAgda** (Abel, 2010): A research prototype exploring the design space of sized types with dependent types.

### 9.7 Challenges

- **Consistency:** Proving consistency of sized types with dependent types is non-trivial. Issues have been found with certain combinations of sized types and universe polymorphism in Agda.
- **Inference:** Size inference is desirable to reduce annotation burden but is undecidable in general. Practical systems use a combination of inference and explicit annotation.
- **Subject reduction:** Maintaining subject reduction in the presence of size subtyping requires care.

---

## 10. Coinduction in Categorical Semantics

### 10.1 Final Coalgebras as Terminal Objects

In the category CoAlg(F) of F-coalgebras, the final coalgebra (Z, zeta) is the terminal object. For any coalgebra (C, gamma), the unique morphism unfold(gamma) : C -> Z is the *anamorphism* or *coiterator*. This captures the universal property:

```
For all (C, gamma) in CoAlg(F), there exists a unique h : C -> Z
such that zeta . h = F(h) . gamma.
```

### 10.2 The Corecursion Principle

The finality gives rise to corecursion: to define a function into Z, one need only specify a coalgebra structure on the domain. This is dual to the recursion principle for initial algebras: to define a function out of the initial algebra, one need only specify an algebra structure on the codomain.

### 10.3 The Limit Construction

By Adamek's theorem (dual to the initial algebra as a colimit construction), the final coalgebra can be constructed as the limit of the terminal sequence:

```
Z = lim (... -> F^n(1) -> ... -> F^2(1) -> F(1) -> 1)
```

For the functor F(X) = A x X on Set, this gives:
```
Z = lim (... -> A^3 -> A^2 -> A -> 1) = A^omega
```

which is the set of infinite sequences over A (streams), as expected.

### 10.4 Polynomial Functors and Their Coalgebras

Many coinductive types arise as final coalgebras of *polynomial functors*. A polynomial functor on Set has the form:

```
F(X) = Sigma_{a : A} X^{B(a)}
```

where A is a set of "shapes" and B(a) is the set of "positions" in shape a. The final coalgebra of a polynomial functor is an M-type (dual to W-types for initial algebras of polynomial functors).

---

## 11. Coinductive Types in Proof Assistants

### 11.1 Coq/Rocq

Coq uses the `CoInductive` command to declare coinductive types and `CoFixpoint` for corecursive definitions. The system enforces the syntactic guardedness condition.

**Syntax:**
```coq
CoInductive Stream : Set := Seq : nat -> Stream -> Stream.

CoFixpoint from (n : nat) : Stream := Seq n (from (S n)).
```

**Guardedness condition:** Each recursive call must be directly under a constructor. The reduction of cofixpoints is lazy: a cofixpoint unfolds only when it is the scrutinee of a `match` expression.

**Negative coinductive types (since Coq 8.5):** Using `Set Primitive Projections`, coinductive types can be defined via their projections, preserving subject reduction:

```coq
Set Primitive Projections.
CoInductive Stream : Set := Seq { hd : nat; tl : Stream }.
```

**Coinductive proofs:** The `cofix` tactic implements coinductive proof by bisimulation. The `paco` library (Hur et al.) provides an alternative that avoids the syntactic guardedness issue for proofs by using parameterized coinduction.

**Limitations:**
- The guardedness checker rejects many natural definitions.
- Eta-equality for coinductive types is not built in; it can be postulated as an axiom.
- Subject reduction can fail for positive coinductive types (before primitive projections).

### 11.2 Agda

Agda has evolved through three approaches to coinduction:

**Musical notation (legacy):** Uses delay/force operators (sharp and flat) with a special datatype for suspended computations:
```agda
data Conat : Set where
  zero : Conat
  suc  : inf Conat -> Conat
```
This approach has known issues and is deprecated in favor of copatterns.

**Copatterns (current, recommended):** Coinductive types are defined as coinductive records, and values are defined by copattern matching on destructors:
```agda
record Stream (A : Set) : Set where
  coinductive
  field
    hd : A
    tl : Stream A

repeat : {A : Set} -> A -> Stream A
hd (repeat a) = a
tl (repeat a) = repeat a
```

**Sized types (current, recommended):** Size annotations enable compositional productivity checking:
```agda
record Stream (A : Set) (i : Size) : Set where
  coinductive
  field
    hd : A
    tl : {j : Size< i} -> Stream A j
```

The guardedness checker is integrated with the size-change termination checker, allowing interesting combinations of inductive and coinductive definitions.

**Key restriction:** Eta-equality for coinductive records is disabled by default (it can make the type checker loop). The `ETA` pragma can force it but is forbidden in `--safe` mode.

### 11.3 Lean

Lean 4 does not have built-in coinductive types in the same way as Coq or Agda. Instead, coinductive types can be constructed through several mechanisms:

**Quotients of Polynomial Functors (QPF):** The theoretical foundation, developed by Avigad, Carneiro, and Huber (2019), shows that a broad class of data types -- including arbitrary nestings of inductive types, coinductive types, and quotients -- can be represented as quotients of polynomial functors. The QPF framework provides:
- Compositional construction of (co)inductive types
- Principles of recursion and corecursion based on functorial maps
- The ability to mix fixed points, co-fixed points, and quotient constructions

**The QpfTypes library** (Keizer) implements a `codata` command for Lean 4 that provides syntax similar to inductive type declarations:
```lean
codata Stream (A : Type) where
  | cons : A -> Stream A -> Stream A
```

Low-level corecursion principles are available through `MvQPF.Cofix.corec`.

**Current status:** Coinductive types in Lean are less mature than in Coq or Agda. The QPF approach is theoretically elegant but the tooling is still under active development.

---

## 12. Interaction Between Induction and Coinduction

### 12.1 Mixed Inductive-Coinductive Types

Some natural data structures combine inductive and coinductive aspects. The canonical example is **stream processors**:

```agda
data SP (A B : Set) : Set where
  get : (A -> SP A B) -> SP A B
  put : B -> inf (SP A B) -> SP A B
```

A stream processor either reads an input (`get`, inductively -- it must eventually produce output) or writes an output (`put`, coinductively -- it may produce output forever). The `get` constructor is inductive (finite reads before an output), while `put` is coinductive (potentially infinite outputs).

### 12.2 Nested (Co)Inductive Types

When inductive and coinductive types are nested, subtle issues arise:

- **Nesting coinductive inside inductive:** A type like `data T = MkT (Stream T)` (where Stream is coinductive) nests a coinductive type inside an inductive one. This is generally safe.

- **Nesting inductive inside coinductive:** A type like `record S : Set where { coinductive; field next : List S }` nests an inductive type inside a coinductive one. Termination/productivity checking for operations on such types requires careful analysis.

- **Mutual inductive-coinductive definitions:** Mutually defined inductive and coinductive types can express complex behaviors but require sophisticated totality checking.

### 12.3 Size-Change Principle for Mixed Types

Abel (2012) and subsequent work (Hyvernat, 2024) adapt the size-change principle to handle mixed inductive-coinductive types. The key insight is that naive application of the size-change principle is unsound for nested types, but it can be adapted to check "totality" -- a property that corresponds to correctness with respect to the type's (co)inductive nature. This requires tracking both the decrease of inductive components and the increase (in observation depth) of coinductive components.

### 12.4 Guarded Recursive Types

An alternative approach to mixing induction and coinduction uses **guarded recursion** with a modal operator "later" (written |>). Developed by Nakano (2000) and extensively studied by Birkedal, Mogelberg, and others, this approach uses the type |> A (read "later A") to represent data available one time step in the future. Guarded recursive types are fixed points of functors involving |>, and they can express both inductive and coinductive behavior in a uniform framework.

---

## 13. Consistency Considerations

### 13.1 Productivity and Logical Consistency

In proof assistants based on the Curry-Howard correspondence, every type must be inhabited only by "well-behaved" terms. For inductive types, this means termination of recursive functions (ensuring that proofs by induction are valid). For coinductive types, this means productivity of corecursive functions (ensuring that coinductive proofs are valid).

An unproductive corecursive definition could inhabit any coinductive type, including coinductive propositions, leading to proofs of False. Therefore, productivity checking is essential for logical consistency.

### 13.2 Subject Reduction

Coinductive types in their "positive" presentation (defined by constructors, as in early Coq) can break subject reduction: a well-typed term may reduce to an ill-typed term. This was a long-standing issue in Coq, resolved by the introduction of **primitive projections** (negative coinductive types) in Coq 8.5. In the negative presentation, coinductive types are defined by their projections, and reduction preserves typing.

### 13.3 Eta-Equality

Eta-equality for coinductive types states that any value equals the result of observing and then reconstructing it. While logically natural, definitional eta-equality for coinductive types is computationally problematic:

- In Agda, eta-equality for coinductive records is disabled by default because it can cause the type checker to loop.
- In Coq, propositional eta-equality can be postulated as an axiom without inconsistency, but it is not built in.

### 13.4 Guard Condition and Consistency

The soundness of the guard condition has been formally verified for specific type theories. Gimenez proved that the guarded corecursion principle is consistent with the Calculus of Inductive Constructions. Abel proved strong normalization for a calculus with guarded recursive types. However, bugs in guardedness checkers have been found in practice (e.g., Agda issue #1209 regarding inconsistency with copatterns), highlighting the subtlety of these checks.

### 13.5 Sized Types and Consistency

The consistency of sized types with full dependent types remains an active area of research. Known issues include:
- Interactions between sized types and universe polymorphism can lead to inconsistency if not handled carefully.
- Size quantification must be restricted to avoid paradoxes analogous to Girard's paradox.
- The system CIC^hat (Sacchini) provides a consistent fragment with sized types for the Calculus of Inductive Constructions.

---

## 14. Key References

### Foundational Works

1. **Aczel, P.** (1988). *Non-Well-Founded Sets*. CSLI Lecture Notes, Number 14. Stanford: CSLI Publications.

2. **Park, D.** (1981). "Concurrency and automata on infinite sequences." In *Theoretical Computer Science*, LNCS 104, pp. 167--183. Springer.

3. **Milner, R.** (1989). *Communication and Concurrency*. Prentice Hall.

### Coinductive Types in Type Theory

4. **Coquand, T.** (1994). "Infinite objects in type theory." In *Types for Proofs and Programs*, LNCS 806, pp. 62--78. Springer.

5. **Gimenez, E.** (1995). "Codifying guarded definitions with recursive schemes." In *Types for Proofs and Programs*, LNCS 996, pp. 39--59. Springer.

6. **Gimenez, E.** (1996). "An application of co-inductive types in Coq: Verification of the alternating bit protocol." In *Types for Proofs and Programs*, LNCS 1158, pp. 135--152. Springer.

### Coalgebra and Categorical Semantics

7. **Rutten, J.J.M.M.** (2000). "Universal coalgebra: a theory of systems." *Theoretical Computer Science*, 249(1), pp. 3--80.

8. **Jacobs, B.** (2016). *Introduction to Coalgebra: Towards Mathematics of States and Observation*. Cambridge Tracts in Theoretical Computer Science, Number 59. Cambridge University Press.

### Bisimulation and Coinduction

9. **Sangiorgi, D.** (2012). *Introduction to Bisimulation and Coinduction*. Cambridge University Press.

10. **Sangiorgi, D. and Rutten, J.** (eds.) (2012). *Advanced Topics in Bisimulation and Coinduction*. Cambridge Tracts in Theoretical Computer Science, Number 52. Cambridge University Press.

11. **Sangiorgi, D.** (2009). "On the origins of bisimulation and coinduction." *ACM Transactions on Programming Languages and Systems*, 31(4), Article 15.

12. **Pous, D. and Sangiorgi, D.** (2012). "Enhancements of the bisimulation proof method." In *Advanced Topics in Bisimulation and Coinduction*, pp. 233--289. Cambridge University Press.

### Copatterns

13. **Abel, A., Pientka, B., Thibodeau, D., and Setzer, A.** (2013). "Copatterns: programming infinite structures by observations." In *Proceedings of the 40th ACM SIGPLAN-SIGACT Symposium on Principles of Programming Languages (POPL '13)*, pp. 27--38. ACM.

14. **Setzer, A., Abel, A., Pientka, B., and Thibodeau, D.** (2014). "Unnesting of copatterns." In *Rewriting and Typed Lambda Calculi*, LNCS 8560, pp. 31--45. Springer.

15. **Abel, A. and Pientka, B.** (2013). "Wellfounded recursion with copatterns: a unified approach to termination and productivity." In *Proceedings of the 18th ACM SIGPLAN International Conference on Functional Programming (ICFP '13)*, pp. 185--196. ACM.

### Sized Types

16. **Hughes, J., Pareto, L., and Sabry, A.** (1996). "Proving the correctness of reactive systems using sized types." In *Proceedings of the 23rd ACM SIGPLAN-SIGACT Symposium on Principles of Programming Languages (POPL '96)*, pp. 410--423. ACM.

17. **Abel, A.** (2008). "Semi-continuous sized types and termination." *Logical Methods in Computer Science*, 4(2).

18. **Abel, A.** (2010). "MiniAgda: Integrating sized and dependent types." In *Proceedings of the Workshop on Partiality and Recursion in Interactive Theorem Provers (PAR '10)*, EPTCS 43, pp. 14--28.

19. **Abel, A.** (2017). "Compositional coinduction with sized types." In *Foundations of Software Science and Computation Structures (FoSSaCS '16)*, LNCS 9634, pp. 5--10. Springer.

20. **Sacchini, J.L.** (2013). "Type-based productivity checking for coinductive definitions." In *Typed Lambda Calculi and Applications*, LNCS 7941, pp. 356--371. Springer.

21. **Amadio, R. and Coupet-Grimal, S.** (1998). "Analysis of a guard condition in type theory." In *Foundations of Software Science and Computation Structures*, LNCS 1378, pp. 48--62. Springer.

### Mixed Inductive-Coinductive Types

22. **Abel, A.** (2007). "Mixed inductive/coinductive types and strong normalization." In *Programming Languages and Systems (APLAS '07)*, LNCS 4807, pp. 286--301. Springer.

23. **Basold, H.** (2018). *Mixed Inductive-Coinductive Reasoning: Types, Programs and Logic*. PhD thesis, Radboud University Nijmegen.

### Lean and QPF

24. **Avigad, J., Carneiro, M., and Huber, S.** (2019). "Data types as quotients of polynomial functors." In *Interactive Theorem Proving (ITP '19)*, LIPIcs 141, pp. 6:1--6:19. Schloss Dagstuhl.

25. **Keizer, A.** (2022). "Implementing a definitional (co)datatype package in Lean 4." MSc thesis, Vrije Universiteit Amsterdam.

### Guarded Recursion

26. **Nakano, H.** (2000). "A modality for recursion." In *Proceedings of the 15th Annual IEEE Symposium on Logic in Computer Science (LICS '00)*, pp. 255--266. IEEE.

27. **Atkey, R. and McBride, C.** (2013). "Productive coprogramming with guarded recursion." In *Proceedings of the 18th ACM SIGPLAN International Conference on Functional Programming (ICFP '13)*, pp. 197--208. ACM.

### Mechanization and Proof Assistants

28. **Paulson, L.C.** (1997). "Mechanizing coinduction and corecursion in higher-order logic." *Journal of Logic and Computation*, 7(2), pp. 175--204.

29. **Hur, C.-K., Neis, G., Dreyer, D., and Vafeiadis, V.** (2013). "The power of parameterization in coinductive proof." In *Proceedings of the 40th ACM SIGPLAN-SIGACT Symposium on Principles of Programming Languages (POPL '13)*, pp. 193--206. ACM.

30. **Chlipala, A.** (2013). *Certified Programming with Dependent Types*. MIT Press. Chapter on Coinductive types.

### Corecursion and Anamorphisms

31. **Uustalu, T. and Vene, V.** (1999). "Primitive (co)recursion and course-of-value (co)iteration, categorically." *Informatica*, 10(1), pp. 5--26.

32. **Capretta, V.** (2005). "General recursion via coinductive types." *Logical Methods in Computer Science*, 1(2).
