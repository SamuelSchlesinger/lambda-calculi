# Effects, Monads, and Computational Lambda Calculi

## Overview

The problem of computational effects -- state, exceptions, I/O, nondeterminism,
continuations -- has been one of the central concerns of programming language theory
since the 1960s. Pure lambda calculus, with its clean equational theory (beta-eta
equivalence), cannot directly account for the fact that real programs interact with
the world, fail, diverge, or maintain mutable state. This document traces the major
theoretical developments that address this tension: Moggi's monadic metalanguage,
Wadler's adaptation for Haskell, Levy's call-by-push-value, effect systems, algebraic
effects and handlers, delimited continuations, and their categorical and type-theoretic
foundations.

---

## 1. Historical Context: Landin, ISWIM, and the Problem of Effects

Peter Landin's "The Next 700 Programming Languages" (1966) proposed ISWIM (If You See
What I Mean), a family of languages based on the lambda calculus augmented with
imperative features: mutable variables, assignment, and the J operator for control flow.
ISWIM was hugely influential -- it is an ancestor of ML, Haskell, and most modern
functional languages.

The fundamental tension Landin identified persists: the lambda calculus provides a
beautiful equational theory for reasoning about programs, but imperative features break
this theory. In the pure lambda calculus, if `M =_beta N` then `M` and `N` are
interchangeable in any context. But with side effects, the order of evaluation matters,
substitution can duplicate or discard effects, and beta-eta equivalence is no longer
sound.

Two broad responses emerged:

1. **Restrict the language:** Remove imperative features entirely (pure functional
   programming), then find principled ways to reintroduce effects.
2. **Refine the theory:** Develop a calculus that correctly accounts for effects from
   the start.

Moggi's work (1989, 1991) achieved the second by giving a *computational* lambda calculus
in which the equational theory is correct for *all* notions of computation.

---

## 2. Moggi's Computational Lambda Calculus (1989, 1991)

### 2.1 The Key Insight: Values vs. Computations

Eugenio Moggi's foundational insight, presented in "Computational Lambda-Calculus and
Monads" (LICS 1989) and expanded in "Notions of Computation and Monads" (Information
and Computation, 1991), is a *categorical* distinction between **values** and
**computations**:

- A **value** of type `A` is a fully evaluated datum.
- A **computation** of type `TA` is a program that, when executed, may perform effects
  and (if it terminates) produces a value of type `A`.

The type constructor `T` is the crux: it internalizes the notion of "effectful
computation" into the type system. Different choices of `T` yield different notions
of computation.

### 2.2 The Monadic Metalanguage (lambda_c)

Moggi defines a metalanguage extending the simply typed lambda calculus with:

**Types:**
```
A, B ::= base types | A -> B | TA
```

**Terms:**
```
M, N ::= x | lambda x:A. M | M N | [M] | let x <= M in N
```

where `[M]` (often written `return M` or `eta M`) lifts a value into a trivial
computation, and `let x <= M in N` (often written `M >>= \x. N` or `bind`) sequences
computations.

**Key Typing Rules:**

```
  Gamma |- V : A
  -------------------- (unit)
  Gamma |- [V] : TA

  Gamma |- M : TA    Gamma, x:A |- N : TB
  ----------------------------------------- (let)
  Gamma |- let x <= M in N : TB
```

### 2.3 The Equational Theory

The equational theory of lambda_c corresponds precisely to the monad laws:

1. **Left unit:** `let x <= [V] in N  =  N[V/x]`
2. **Right unit:** `let x <= M in [x]  =  M`
3. **Associativity:** `let y <= (let x <= L in M) in N  =  let x <= L in (let y <= M in N)`

These are exactly the Kleisli category laws for a monad. The crucial point is that this
equational theory is *sound* for any computational monad -- unlike beta-eta equivalence,
which is only sound for pure computations.

### 2.4 Examples of Computational Monads

Moggi catalogs several monads, each capturing a different notion of computation:

| Effect | Monad T(A) | Description |
|--------|-----------|-------------|
| Partiality | A_bot (A + {bottom}) | May diverge |
| Nondeterminism | P(A) (powerset) | Multiple possible results |
| Exceptions | A + E | May raise exception from E |
| State | (A x S)^S | Read/write state S |
| Continuations | R^(R^A) | First-class continuations |
| Output | A x O* | Produces output in monoid O* |
| Interactive I/O | mu X. (A + X^I + O x X) | Reads input, writes output |

Each monad determines a Kleisli category, and the metalanguage is interpreted uniformly
in any such category.

### 2.5 Categorical Semantics

A **computational model** in Moggi's sense consists of:

- A category **C** with finite products (modeling values and their types)
- A **strong monad** (T, eta, mu, t) on **C**

where:
- `eta_A : A -> TA` is the unit (embedding values as trivial computations)
- `mu_A : T(TA) -> TA` is the multiplication (flattening nested computations)
- `t_{A,B} : A x TB -> T(A x B)` is the **strength** (allowing a value to be paired
  with a computation)

The **Kleisli category** C_T has:
- Objects: same as C
- Morphisms A -> B: morphisms A -> TB in C (i.e., effectful functions)
- Composition via the Kleisli extension (bind)

The strength is essential: it allows the metalanguage to interpret function application
where the argument has already been evaluated (the value `A`) but the body may be
effectful (producing `TB`).

---

## 3. Monads in Programming

### 3.1 Wadler's Adaptation for Haskell (1992, 1995)

Philip Wadler translated Moggi's categorical insights into a practical programming idiom
in a series of influential papers:

- **"The Essence of Functional Programming"** (POPL 1992): Demonstrated that an
  interpreter can be written in monadic style, and that changing the monad -- from
  identity to error-handling to state to nondeterminism -- changes the interpreter's
  behavior without changing its structure. This paper required no knowledge of category
  theory and made monads accessible to working programmers.

- **"Comprehending Monads"** (1992): Showed that list comprehension notation (familiar
  from set-builder notation in mathematics) generalizes to arbitrary monads, giving a
  uniform syntax for state, exceptions, parsing, and more.

- **"Monads for Functional Programming"** (1995): A tutorial presenting three extended
  examples -- evaluator modification, in-place array update, and parser combinators --
  all structured using monads.

### 3.2 The IO Monad

The most consequential application of Moggi's insight to programming was the **IO monad**
in Haskell, introduced by Peyton Jones and Wadler in "Imperative Functional Programming"
(POPL 1993).

The problem: Haskell is a *lazy*, *purely functional* language. There is no fixed
evaluation order, and every function is referentially transparent. How can such a
language perform I/O, which is inherently sequential and side-effecting?

The solution: I/O actions have type `IO a`, where `IO` is an abstract monad. A value of
type `IO a` is a *description* of an I/O action that, when executed by the runtime,
produces a value of type `a`. The monadic bind `(>>=) : IO a -> (a -> IO b) -> IO b`
sequences actions, and `return : a -> IO a` creates a trivial action. The `main`
function has type `IO ()`, and the runtime executes this action.

Key properties:
- Pure functions cannot perform I/O (the type system enforces this)
- I/O actions are first-class values that can be composed, stored, and passed around
- Sequencing is explicit via bind, resolving the evaluation-order problem
- Laziness is preserved for pure computations

Peyton Jones later wrote "Tackling the Awkward Squad" (2001), a comprehensive tutorial
covering I/O, concurrency, exceptions, and foreign function calls in Haskell, all
structured monadically.

### 3.3 Monad Transformers

A single monad captures a single effect. Real programs typically need multiple effects
simultaneously (e.g., state *and* exceptions *and* I/O). **Monad transformers** address
this by providing composable building blocks.

Liang, Hudak, and Jones, in "Monad Transformers and Modular Interpreters" (POPL 1995),
systematized the approach:

- A monad transformer `t` takes a monad `m` and produces a new monad `t m`
- Standard transformers: `StateT s m a = s -> m (a, s)`, `ExceptT e m a = m (Either e a)`,
  `ReaderT r m a = r -> m a`, `WriterT w m a = m (a, w)`, `ContT r m a = (a -> m r) -> m r`
- A `lift` operation embeds actions from the inner monad `m` into the transformed monad `t m`

The order of transformer application matters: `StateT s (ExceptT e m)` (state is rolled
back on exception) differs from `ExceptT e (StateT s m)` (state is preserved on exception).

Challenges with monad transformers:
- The number of required `lift` operations grows with the transformer stack
- Not all transformer combinations are well-behaved
- Some effects (notably continuations) interact poorly with others
- Monad transformer stacks are not commutative in general

### 3.4 Do-Notation and Monadic Syntax

Haskell's `do`-notation provides syntactic sugar for monadic code:

```haskell
do x <- action1
   y <- action2 x
   return (f x y)
```

desugars to:

```haskell
action1 >>= \x -> action2 x >>= \y -> return (f x y)
```

This makes monadic code read like imperative code with sequential statements. The
notation has been adopted (with variations) by Scala (`for` comprehensions), F#
(`computation expressions`), Lean 4 (`do` blocks), Idris, and others.

---

## 4. Call-By-Push-Value (Levy, 2003)

### 4.1 Motivation

Paul Blain Levy's call-by-push-value (CBPV), developed in his 2003 book and earlier
papers (TLCA 1999), provides a refined analysis of the value/computation distinction
that *subsumes* both call-by-value (CBV) and call-by-name (CBN) as special cases.

Levy's memorable slogan: **"Values are, computations do."**

### 4.2 Value Types vs. Computation Types

CBPV has two *kinds* of types:

**Value types** `A` classify data -- things that simply *exist* and can be freely
duplicated or discarded:
```
A ::= 1 | A1 x A2 | A1 + A2 | UB
```

**Computation types** `B` classify code -- things that *do* something when executed:
```
B ::= FA | A -> B | B1 & B2
```

### 4.3 The Shift Types: F and U

The two key type constructors that mediate between values and computations are:

**U B** ("thunk"): A value type wrapping a suspended computation.
- Introduction: `thunk M` where `M : B` produces a value of type `UB`
- Elimination: `force V` where `V : UB` produces a computation of type `B`
- Equations: `force(thunk M) = M` and `thunk(force V) = V`

**F A** ("free" or "returner"): A computation type that produces a value.
- Introduction: `return V` where `V : A` produces a computation of type `FA`
- Elimination: `M to x. N` (bind) where `M : FA`, `x:A |- N : B` produces `N : B`
- Equations: `(return V) to x. N = N[V/x]` and `M to x. (return x) = M`

### 4.4 Subsumption of CBV and CBN

CBPV subsumes both evaluation strategies via embeddings:

**CBV embedding:** A CBV type `tau` maps to a CBPV value type `tau_v`. A CBV term
`M : tau` maps to a CBPV computation `M_v : F(tau_v)`. The CBV function type `tau -> sigma`
maps to `U(tau_v -> F(sigma_v))` -- a thunked computation that takes a value and returns
a computation producing a value.

**CBN embedding:** A CBN type `tau` maps to a CBPV computation type `tau_n`. A CBN term
`M : tau` maps to a CBPV computation `M_n : tau_n`. The CBN function type `tau -> sigma`
maps to `U(tau_n) -> sigma_n` -- a function taking a thunked computation.

The key insight: in CBV, variables range over *values* (already evaluated); in CBN,
variables range over *thunked computations* (not yet evaluated). CBPV makes this explicit.

### 4.5 Adjunction Models

The F and U type constructors form an adjunction:

```
F -| U : Comp -> Val
```

This adjunction gives rise to:
- A monad `UF` on the value category (the computational monad, analogous to Moggi's `T`)
- A comonad `FU` on the computation category

CBPV denotational models consist of:
- A category **Val** with finite products (for value types)
- A category **Comp** (for computation types)
- An adjunction `F -| U` between them

This is more refined than Moggi's framework: where Moggi has one category plus a monad,
CBPV decomposes the monad into an adjunction, recovering the two categories that give
rise to it.

---

## 5. Effect Systems

### 5.1 Gifford and Lucassen (1986)

The idea of tracking effects in the type system originates with David Gifford and
John Lucassen's "Integrating Functional and Imperative Programming" (LFP 1986). They
introduced **effect classes** -- static annotations that classify whether an expression
is pure (PURE), performs reads (READ), performs writes (WRITE), or performs arbitrary
side effects (IO).

A typing judgment in an effect system has the form:

```
Gamma |- e : A ! epsilon
```

where `epsilon` is a set of effect labels. The effect system tracks which operations
an expression may perform:

- A pure expression has effect `{}` (empty set)
- Reading state has effect `{read}`
- Writing state has effect `{write}`
- An expression performing both has effect `{read, write}`
- Function application propagates effects: if `f : A ->{epsilon1} B` and the argument
  has effect `epsilon2`, the application has effect `epsilon1 ∪ epsilon2`

### 5.2 Polymorphic Effect Systems

Lucassen and Gifford extended this to **polymorphic effect systems** (POPL 1988),
allowing effect variables that can be universally quantified:

```
map : forall alpha, epsilon. (alpha ->{epsilon} beta) -> List alpha ->{epsilon} List beta
```

This captures the fact that `map` itself is pure, but its effect depends on the function
argument.

Talpin and Jouvelot (1992, 1994) developed this further into "The Type and Effect
Discipline," adding **regions** (abstracting sets of memory locations) and providing
a complete type-and-effect inference algorithm based on Hindley-Milner.

### 5.3 Row-Based Effect Systems

Modern effect systems, particularly in the context of algebraic effects, often use
**row polymorphism** to track effects. In Daan Leijen's Koka language (2014), effect
types are structured as rows:

```
fun map(xs : list<a>, f : (a) -> <e> b) : <e> list<b>
```

An effect row is either:
- Empty `<>` (pure)
- An extension `<l | epsilon>` (effect `l` plus the rest `epsilon`)
- A polymorphic effect variable `<e>` (any effects)

Row polymorphism provides:
- Principal type inference (Hindley-Milner style)
- Natural effect polymorphism without explicit quantification
- Precise typing for effect elimination (e.g., catching exceptions removes `exn`
  from the effect row)

A distinctive feature of Koka's system is that effect labels may be **duplicated**:
`<exn, exn>` is not equivalent to `<exn>`. This enables principal unification without
extra constraints and provides precise types for scoped effect handlers.

---

## 6. Algebraic Effects and Handlers

### 6.1 Plotkin and Power's Algebraic Effects (2001/2003)

Gordon Plotkin and John Power, in "Algebraic Operations and Generic Effects" (Applied
Categorical Structures, 2003; conference version MFPS 2001), observed that many
computational effects arise from **algebraic operations** -- operations whose behavior
is determined by an equational theory.

The key insight: a computational effect can be specified by:
1. A **signature** of operations, each with an arity
2. An **equational theory** specifying laws the operations satisfy

For example, mutable state over a set of locations `L` with values in `V` is specified by:

**Operations:**
- `get_l : V -> A` for each `l in L` (read location `l`, continue with the value)
- `put_l : V x A -> A` for each `l in L` (write a value to `l`, then continue)

**Equations (selection):**
- `get_l(x. get_l(y. M)) = get_l(x. M[x/y])` (reading twice gives the same value)
- `put_l(v, get_l(x. M)) = put_l(v, M[v/x])` (reading after writing gives the written value)
- `put_l(v, put_l(w, M)) = put_l(w, M)` (only the last write matters)

The **free model** of an equational theory gives rise to a monad -- precisely the
monad for that effect. This provides a *compositional* account: effects are built up
from operations, and the monad is derived rather than given directly.

A **generic effect** is a natural transformation from the free algebra to the monad.
Plotkin and Power showed that giving a generic effect is equivalent to giving an algebraic
operation, unifying the operational and denotational views.

### 6.2 Plotkin and Pretnar's Handlers (2009/2013)

Gordon Plotkin and Matija Pretnar, in "Handlers of Algebraic Effects" (ESOP 2009, journal
version LMCS 2013), introduced **effect handlers** -- a programming construct that
generalizes exception handlers to arbitrary algebraic effects.

An effect handler provides an interpretation for a set of operations. When an operation
is performed during the execution of a handled computation, control transfers to the
handler, which receives:
- The operation's arguments
- A **continuation** representing the rest of the computation

The handler can then:
- Invoke the continuation zero times (like catching an exception)
- Invoke it once (like modifying the operation's return value)
- Invoke it multiple times (like implementing nondeterminism)
- Store the continuation for later use (like implementing coroutines)

**Handler syntax (informal):**

```
handle M with
  | return x   -> N_ret
  | op1(x, k)  -> N_1
  | op2(x, k)  -> N_2
```

where `k` is the captured continuation. The `return` clause specifies what to do when
the computation completes normally.

**Example: Implementing state with handlers**

```
handle M with
  | return x       -> fun s -> x
  | get((), k)     -> fun s -> (k s) s
  | put(s', k)     -> fun _ -> (k ()) s'
```

This handler transforms a stateful computation into a function from initial state to
result. When `get` is performed, the handler passes the current state to the continuation.
When `put` is performed, the handler discards the old state and continues with the new
one.

### 6.3 Typing Effect Handlers

The typing of handlers involves **effect rows** (or effect sets) that change as
operations are handled:

```
  Gamma |- M : A ! {op1, op2, ...} ∪ epsilon
  handler handles {op1, op2, ...} transforming A to B
  ------------------------------------------------
  Gamma |- handle M with handler : B ! epsilon
```

The handler *removes* the handled operations from the effect set and may change the
return type. The remaining effects `epsilon` pass through unhandled.

### 6.4 Free Monad Interpretation

Algebraic effects have a natural interpretation via **free monads**. Given an operation
signature (a functor `F`), the free monad `Free F` is:

```
data Free f a = Pure a | Op (f (Free f a))
```

- `Pure a` represents a completed computation returning `a`
- `Op` represents a computation that performs an operation and then continues

For a signature with operations `op1 : A1 -> B1`, `op2 : A2 -> B2`, ..., the
signature functor is:

```
F(X) = (A1 x (B1 -> X)) + (A2 x (B2 -> X)) + ...
```

Each summand represents one operation: the `Ai` is the operation's parameter, and
`Bi -> X` is the continuation parameterized by the operation's result.

An effect handler is then an **algebra** (fold) for this free monad:

```
handle : Free F A -> B
```

given by providing:
- A function `A -> B` (the return clause)
- An `F`-algebra `F(B) -> B` (clauses for each operation)

The connection: the free monad for the signature is the initial algebra, and a handler
is a homomorphism from this initial algebra to some other algebra.

This perspective connects algebraic effects directly to Swierstra's "Data Types a la
Carte" (JFP 2008), which uses coproducts of functors and free monads to compose
effects modularly.

### 6.5 Practical Languages with Algebraic Effects

#### Eff (Bauer and Pretnar, 2012)

Eff is the first programming language designed from the ground up around algebraic
effects and handlers. Created by Andrej Bauer and Matija Pretnar, it supports:

- First-class effects and handlers
- Operations as the interface to effects
- Handlers as homomorphisms from free algebras
- Type-and-effect inference

Eff demonstrated that algebraic effects can express exceptions, state, I/O,
nondeterminism, cooperative concurrency, backtracking, and more -- all as user-defined
libraries rather than built-in primitives.

#### Koka (Leijen, 2014-)

Daan Leijen's Koka language (Microsoft Research) combines algebraic effects with:

- **Row-polymorphic effect types** with Hindley-Milner inference
- **Evidence-passing translation** for efficient compilation (POPL 2017)
- Support for named and scoped handlers
- Perceus reference counting for memory management

Koka shows that algebraic effects generalize over common constructs like exception
handling, iterators, async/await, and coroutines.

#### Frank (Lindley and McBride, 2017)

Frank, described in "Do Be Do Be Do" (POPL 2017), takes a radical approach:

- Built on Levy's call-by-push-value
- **No separate handler construct** -- ordinary function abstraction is generalized to
  handle effects
- Novel **ambient ability** for implicit effect polymorphism (effects propagate inward
  rather than accumulating outward)
- Explicit distinction between value types and computation types

#### Multicore OCaml / OCaml 5.0

OCaml 5.0 (released 2022) integrates algebraic effect handlers, primarily designed for
concurrency:

- **One-shot continuations** (can be resumed at most once) for efficiency
- Implemented via **fibers** -- heap-allocated stack segments
- Untyped effects at the language level (effect typing via external tools)
- Used to implement schedulers, async I/O, generators, and concurrency primitives

The design prioritizes performance and practical concurrency over type-level effect
tracking.

---

## 7. Delimited Continuations

### 7.1 Background

A **continuation** represents "the rest of the computation." In a standard evaluation
context `E[M]`, the continuation of `M` is `E[-]`. Undelimited continuations (as in
Scheme's `call/cc`) capture the *entire* rest of the program and do not return a value
-- they are *abortive*.

**Delimited continuations** capture only a *segment* of the continuation, up to a
designated delimiter. They are *composable* -- they behave like functions, accepting
an argument and returning a result.

### 7.2 shift/reset (Danvy and Filinski, 1990)

Olivier Danvy and Andrzej Filinski introduced `shift` and `reset` in "Abstracting
Control" (LFP 1990):

- `reset M` installs a delimiter around the evaluation of `M`
- `shift k. N` captures the current continuation up to the nearest `reset`, binds it
  to `k`, and evaluates `N`

Reduction rule (informal):

```
reset E[shift k. N]  -->  reset N[k := lambda x. reset E[x]]
```

The captured continuation `k` is a function: calling `k v` resumes the computation
with `v` in place of the `shift` expression, but the resumed computation is itself
delimited by a `reset`.

### 7.3 control/prompt (Felleisen, 1988)

Matthias Felleisen's `control` and `prompt` operators (POPL 1988) are similar but differ
in whether the delimiter is reinstalled around the body:

```
prompt E[control k. N]  -->  prompt N[k := lambda x. E[x]]
```

Note: `k` does *not* reinstall a `prompt` around `E[x]`, unlike `shift`'s behavior with
`reset`. This makes `control` *non-composable* by default.

### 7.4 Typing Delimited Continuations

The answer type -- the type of the overall computation delimited by `reset` -- plays a
central role in typing:

```
reset : (forall alpha. alpha) -> alpha     -- simplified
shift : ((A -> B) -> B) -> A               -- simplified
```

More precise typings require **answer-type polymorphism** or **answer-type modification**
(Danvy and Filinski 1989, Asai and Kameyama 2007).

### 7.5 Connection to Effects

Delimited continuations are deeply connected to algebraic effects:

- **Filinski's theorem** (POPL 1994): any monad whose unit and bind are expressible as
  purely functional terms can be *represented* (implemented) using `shift` and `reset`
  in a call-by-value language. This means delimited continuations are a *universal*
  effect mechanism.

- Algebraic effect handlers are essentially a *typed, structured* form of delimited
  continuations. Each handler is a delimiter; performing an operation captures the
  continuation up to the handler.

- Filinski extended this in "Representing Layered Monads" (POPL 1999), showing that
  multiple layers of effects can be simulated by layered continuation-passing.

---

## 8. Relationship to Evaluation Strategy

The interaction between effects and evaluation strategy is fundamental:

### 8.1 Call-by-Value (CBV)

In CBV, arguments are evaluated before function application. The evaluation order is:
1. Evaluate the function to a value
2. Evaluate the argument to a value
3. Apply

This makes effects predictable: effects happen in left-to-right order (in most
languages). CBV is the natural home for effects, which is why most effectful languages
(ML, OCaml, Scheme, Java, etc.) use CBV.

In Moggi's framework, a CBV type `A` is interpreted as a value type, and a CBV function
`A -> B` is interpreted as a morphism `A -> TB` in the Kleisli category -- a function
that takes a value and returns a computation.

### 8.2 Call-by-Name (CBN)

In CBN, arguments are not evaluated before being passed; they are substituted
unevaluated and computed only when (and if) they are used. This means:
- An argument's effects may happen zero, one, or many times
- Effects are interleaved unpredictably
- The evaluation order depends on the function's internal structure

CBN is rarely used with effects in practice (Haskell uses lazy evaluation, which is
call-by-*need* -- CBN with memoization -- and wraps all effects in the IO monad precisely
to control this).

In Moggi's framework, a CBN type `A` is interpreted as `TA` (a computation), and
substitution of a CBN variable triggers the computation.

### 8.3 CBPV's Resolution

Levy's CBPV resolves the tension by making the distinction explicit:
- In the CBV embedding, variables range over values (already evaluated)
- In the CBN embedding, variables range over thunked computations
- The type system tracks which is which, making evaluation strategy a *type-level*
  concern rather than a language-level one

---

## 9. Effects in Dependent Type Theory

### 9.1 The Challenge

Dependent type theory poses special challenges for effects:
- Types can depend on terms, so effectful terms in types could cause problems
- Type checking must be decidable, but evaluating effectful terms may diverge or
  have side effects
- Proofs and programs are identified, so effects could compromise logical consistency

### 9.2 Dijkstra Monads (F*)

F* (F-star) is a dependently typed language with a sophisticated effect system based on
**Dijkstra monads**. A Dijkstra monad pairs a computational monad with a **specification
monad** (typically a weakest-precondition transformer):

- Each effectful computation `M : A` has a type `M t wp` tying it to a predicate
  transformer `wp`
- Verification conditions are generated automatically from the Dijkstra monad structure
- Different effects (PURE, EXN, ST, ALL) have different Dijkstra monads

Key results:
- **"Dijkstra Monads for Free"** (Ahman et al., POPL 2017): Dijkstra monads can be
  *derived automatically* by CPS-translating standard monadic definitions
- **"Dijkstra Monads for All"** (Maillard et al., ICFP 2019): Any monad morphism from
  a computational monad to a specification monad gives rise to a Dijkstra monad

### 9.3 Lean 4

Lean 4 takes a pragmatic approach:
- **IO monad:** `IO a` is defined as a state monad over an abstract `RealWorld` token,
  similar to Haskell's approach
- **do-notation:** Lean 4's do-blocks support monadic sequencing, mutable variables
  (via `StateT`), early return, for loops, and other imperative features
- **Monad transformers:** `StateT`, `ExceptT`, `ReaderT` etc. compose effects
- **Type classes:** `Monad`, `MonadState`, `MonadExcept` etc. provide abstract interfaces
- The logical fragment (proofs) remains pure; `IO` is used only for executable programs

### 9.4 Other Approaches

- **Idris 2** uses quantitative type theory with an algebraic effect system
- **Hoare Type Theory** (Nanevski, Morrisett, Birkedal) uses Hoare-style pre/post
  conditions in a dependent type theory
- **Coq/Rocq** uses monadic encoding (via type classes or canonical structures) for
  effects in extracted programs, and the `IO` monad for executables

---

## 10. Categorical Semantics

### 10.1 Kleisli Categories

Given a monad `(T, eta, mu)` on a category **C**, the **Kleisli category** **C**_T has:
- Objects: same as **C**
- Morphisms `A -> B`: morphisms `A -> TB` in **C**
- Identity: `eta_A : A -> TA`
- Composition: `g . f = mu_B . Tg . f` for `f : A -> TB`, `g : B -> TC`

The Kleisli category is the natural semantic domain for effectful programs: morphisms
represent computations that take a value and produce an effectful result.

### 10.2 Strong Monads

A **strong monad** on a category with finite products is a monad equipped with a
**strength** natural transformation:

```
t_{A,B} : A x TB -> T(A x B)
```

satisfying coherence conditions with the monoidal structure of products. The strength
is essential for interpreting the computational lambda calculus: it allows a value to
be paired with a computation, which is needed to interpret function application in an
effectful setting.

A monad is **commutative** if the strength is symmetric:

```
t'_{A,B} : TA x B -> T(A x B)
```

commutes with `t` in the sense that `T(swap) . t . swap = t'`. Commutative monads model
effects where order does not matter (e.g., the reader monad). Non-commutative monads
model effects where order matters (e.g., state, I/O).

On the category **Set**, every monad has a unique strength, so the distinction is only
relevant in more general settings (enriched categories, presheaf categories, etc.).

### 10.3 Lawvere Theories

A **Lawvere theory** is a category `L` with finite products and a strict
product-preserving identity-on-objects functor from the opposite of the category of
finite cardinals. Models of a Lawvere theory in **Set** are product-preserving functors
`L -> Set`.

Plotkin and Power connected Lawvere theories to computational effects:

- An algebraic effect is given by a (countable) Lawvere theory
- The category of models of this theory is equivalent to the category of algebras for
  the corresponding monad
- The free model functor gives the monad

This provides a **presentation** of computational monads: instead of giving the monad
directly (which can be opaque), one gives a Lawvere theory (a set of operations and
equations), from which the monad is derived.

Hyland and Power, in "The Category Theoretic Understanding of Universal Algebra: Lawvere
Theories and Monads" (ENTCS, 2007), showed that the equivalence between Lawvere theories
and finitary monads (on Set) extends to enriched settings relevant to computer science.

### 10.4 Freyd Categories

Sam Staton showed that **Freyd categories** (a pair of categories with the same objects
connected by an identity-on-objects functor) are equivalent to **enriched Lawvere
theories**. A Freyd category consists of:

- A category of values **V** with finite products
- A category of computations **C** with the same objects
- An identity-on-objects functor `J : V -> C`

The Kleisli category of a strong monad forms a Freyd category. This unifies the
categorical semantics of effects: Moggi's monads, Levy's CBPV adjunctions, Plotkin
and Power's Lawvere theories, and Freyd categories are all different presentations of
the same underlying structure.

---

## 11. Summary of Relationships

The various approaches to computational effects are deeply interconnected:

```
Moggi's monads (1989)
    |
    |-- Wadler: programming idiom (1992)
    |       |-- IO monad in Haskell (1993)
    |       |-- Monad transformers (1995)
    |
    |-- Levy: decompose monad into adjunction (1999/2003)
    |       |-- CBPV: F -| U adjunction
    |       |-- Frank language (2017)
    |
    |-- Plotkin & Power: decompose monad into operations (2001/2003)
    |       |-- Algebraic effects: operations + equations -> monad
    |       |-- Plotkin & Pretnar: handlers (2009/2013)
    |               |-- Eff language (2012)
    |               |-- Koka language (2014-)
    |               |-- OCaml 5.0 effects (2022)
    |
    |-- Filinski: represent monads via delimited continuations (1994)
    |       |-- shift/reset as universal effect mechanism
    |
    |-- F*: Dijkstra monads for verification (2016-)
    |       |-- Weakest preconditions for effects
    |
    |-- Gifford & Lucassen: effect systems (1986)
            |-- Talpin & Jouvelot: type-and-effect discipline (1994)
            |-- Wadler: marriage of effects and monads (1998)
            |-- Row-polymorphic effects in Koka (2014)
```

The central theme: a computational effect is determined by **operations** that programs
can perform, subject to **equations** they satisfy. This data determines:
- A **monad** (the denotational semantics)
- A **Lawvere theory** (the algebraic structure)
- An **effect handler** (the programming abstraction)
- An **effect type** (the static analysis)

These are different perspectives on the same phenomenon.

---

## 12. Key References

### Foundational

1. **Landin, P.J.** "The Next 700 Programming Languages." *Communications of the ACM*
   9(3), 1966.
   URL: https://www.cs.cmu.edu/~crary/819-f09/Landin66.pdf

2. **Moggi, E.** "Computational Lambda-Calculus and Monads." *Proceedings of LICS*, 1989.
   URL: https://www.cs.cmu.edu/~crary/819-f09/Moggi89.pdf

3. **Moggi, E.** "Notions of Computation and Monads." *Information and Computation*
   93(1):55-92, 1991.
   URL: https://www.cs.cmu.edu/~crary/819-f09/Moggi91.pdf

### Monads in Programming

4. **Wadler, P.** "The Essence of Functional Programming." *POPL*, 1992.
   URL: https://jgbm.github.io/eecs762f19/papers/wadler-monads.pdf

5. **Wadler, P.** "Comprehending Monads." *Mathematical Structures in Computer Science*
   2(4), 1992.

6. **Wadler, P.** "Monads for Functional Programming." *Advanced Functional Programming*,
   Springer LNCS, 1995.
   URL: https://homepages.inf.ed.ac.uk/wadler/papers/marktoberdorf/baastad.pdf

7. **Peyton Jones, S. and Wadler, P.** "Imperative Functional Programming." *POPL*, 1993.

8. **Peyton Jones, S.** "Tackling the Awkward Squad: monadic input/output, concurrency,
   exceptions, and foreign-language calls in Haskell." 2001.
   URL: https://www.microsoft.com/en-us/research/wp-content/uploads/2016/07/mark.pdf

9. **Liang, S., Hudak, P., and Jones, M.** "Monad Transformers and Modular Interpreters."
   *POPL*, 1995.
   URL: https://web.engr.oregonstate.edu/~walkiner/teaching/cs583-sp21/files/Liang-MonadTransformers.pdf

### Call-by-Push-Value

10. **Levy, P.B.** *Call-By-Push-Value: A Functional/Imperative Synthesis.* Springer, 2003.
    Thesis: https://www.cs.bham.ac.uk/~pbl/papers/thesisqmwphd.pdf

11. **Levy, P.B.** "Call-By-Push-Value: A Subsuming Paradigm." *TLCA*, 1999.
    URL: https://www.cs.bham.ac.uk/~pbl/papers/tlca99.pdf

### Effect Systems

12. **Gifford, D.K. and Lucassen, J.M.** "Integrating Functional and Imperative
    Programming." *LFP*, 1986.

13. **Lucassen, J.M. and Gifford, D.K.** "Polymorphic Effect Systems." *POPL*, 1988.

14. **Talpin, J.-P. and Jouvelot, P.** "The Type and Effect Discipline." *Information
    and Computation* 111(2):245-296, 1994.

15. **Wadler, P.** "The Marriage of Effects and Monads." *ICFP*, 1998.

### Algebraic Effects and Handlers

16. **Plotkin, G. and Power, J.** "Algebraic Operations and Generic Effects." *Applied
    Categorical Structures* 11(1):69-94, 2003.
    URL: https://homepages.inf.ed.ac.uk/gdp/publications/alg_ops_gen_effects.pdf

17. **Plotkin, G. and Pretnar, M.** "Handlers of Algebraic Effects." *ESOP*, 2009.
    URL: https://homepages.inf.ed.ac.uk/gdp/publications/Effect_Handlers.pdf

18. **Plotkin, G. and Pretnar, M.** "Handling Algebraic Effects." *Logical Methods in
    Computer Science*, 2013.
    URL: https://homepages.inf.ed.ac.uk/gdp/publications/handling-algebraic-effects.pdf

19. **Pretnar, M.** "An Introduction to Algebraic Effects and Handlers." *Invited
    tutorial paper.* Electronic Notes in Theoretical Computer Science 319, 2015.
    URL: https://www.eff-lang.org/handlers-tutorial.pdf

### Practical Languages

20. **Bauer, A. and Pretnar, M.** "Programming with Algebraic Effects and Handlers."
    *Journal of Logical and Algebraic Methods in Programming*, 2015.
    ArXiv: https://arxiv.org/abs/1203.1539

21. **Leijen, D.** "Koka: Programming with Row Polymorphic Effect Types." *MSFP*, 2014.
    ArXiv: https://arxiv.org/abs/1406.2061

22. **Leijen, D.** "Type Directed Compilation of Row-Typed Algebraic Effects." *POPL*, 2017.
    URL: https://www.microsoft.com/en-us/research/wp-content/uploads/2016/12/algeff.pdf

23. **Lindley, S., McBride, C., and McLaughlin, C.** "Do Be Do Be Do." *POPL*, 2017.
    ArXiv: https://arxiv.org/abs/1611.09259

### Delimited Continuations

24. **Felleisen, M.** "The Theory and Practice of First-Class Prompts." *POPL*, 1988.

25. **Danvy, O. and Filinski, A.** "Abstracting Control." *LFP*, 1990.

26. **Filinski, A.** "Representing Monads." *POPL*, 1994.

27. **Filinski, A.** "Representing Layered Monads." *POPL*, 1999.

28. **Dybvig, R.K., Peyton Jones, S., and Sabry, A.** "A Monadic Framework for Delimited
    Continuations." *Journal of Functional Programming*, 2007.
    URL: https://www.microsoft.com/en-us/research/wp-content/uploads/2005/01/jfp-revised.pdf

### Free Monads and Modularity

29. **Swierstra, W.** "Data Types a la Carte." *Journal of Functional Programming*
    18(4):423-436, 2008.

### Effects in Dependent Types

30. **Swamy, N. et al.** "Dependent Types and Multi-monadic Effects in F*." *POPL*, 2016.
    URL: https://fstar-lang.org/papers/mumon/paper.pdf

31. **Ahman, D. et al.** "Dijkstra Monads for Free." *POPL*, 2017.
    ArXiv: https://arxiv.org/abs/1608.06499

32. **Maillard, K. et al.** "Dijkstra Monads for All." *ICFP*, 2019.
    ArXiv: https://arxiv.org/abs/1903.01237

### Categorical Semantics

33. **Hyland, M. and Power, J.** "The Category Theoretic Understanding of Universal
    Algebra: Lawvere Theories and Monads." *ENTCS* 172:437-458, 2007.
    URL: https://www.irif.fr/~mellies/mpri/mpri-ens/articles/hyland-power-lawvere-theories-and-monads.pdf

34. **Staton, S.** "Freyd Categories are Enriched Lawvere Theories." *WACT*, 2014.
    URL: https://www.cs.ox.ac.uk/people/samuel.staton/papers/freyd-lawvere-2014.pdf

### Bibliographies

35. **Effects Bibliography** (collaborative, maintained by Jeremy Yallop et al.).
    GitHub: https://github.com/yallop/effects-bibliography

---

## Cross-References

- **Doc 01 (Untyped Lambda Calculus):** The choice of evaluation strategy (call-by-name vs. call-by-value) in the lambda calculus fundamentally determines how effects are sequenced, motivating Moggi's distinction between values and computations.

- **Doc 02 (Simply Typed Lambda Calculus):** The STLC serves as the pure, effect-free base calculus that monadic and algebraic effect systems extend with controlled computational effects.

- **Doc 13 (Linear and Substructural Types):** Linear types offer a complementary approach to effect tracking, using resource-sensitive typing to enforce protocols and safe state management without requiring monadic encapsulation.
