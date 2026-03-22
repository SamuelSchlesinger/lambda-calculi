# Implementation Techniques for Type-Theoretic Lambda Calculi

## Overview

Implementing a type-theoretic lambda calculus requires solving a constellation of interrelated design problems: how to represent variables and binding, how to perform substitution efficiently, how to check and infer types, how to normalize terms, and how to execute programs. Each choice has ramifications for correctness, performance, and the ease of formalization. This document surveys the primary techniques used in practice and in research, drawing on seminal papers and notable implementations.

---

## 1. Variable Representation Strategies

The representation of variables and binding is the most fundamental design decision in any lambda calculus implementation. It affects the complexity of substitution, alpha-equivalence checking, and the ergonomics of the entire system.

### 1.1 Named Variables

The most natural representation uses string (or symbol) names for variables, mirroring mathematical notation.

**Syntax:**
```
e ::= x | λx. e | e₁ e₂
```

**Advantages:**
- Direct correspondence to mathematical notation
- Easy to read and debug
- Simple parsing

**Disadvantages:**
- Alpha-equivalence is non-trivial: `λx. x` and `λy. y` are syntactically distinct but semantically identical
- Substitution requires careful avoidance of variable capture
- Freshness conditions and Barendregt's variable convention are needed
- Shadowing can introduce subtle bugs

In practice, named variables are almost never used alone in serious implementations. They appear in surface syntax but are translated to other representations during elaboration.

### 1.2 De Bruijn Indices

Introduced by Nicolaas Govert de Bruijn (1972), de Bruijn indices replace variable names with natural numbers indicating the number of binders between the variable occurrence and its binding site (counting from the inside out).

**Syntax:**
```
e ::= n | λ. e | e₁ e₂
```

where `n ∈ ℕ` is the index.

**Example:**
```
λx. λy. x y   becomes   λ. λ. 1 0
λf. λx. f (f x)   becomes   λ. λ. 1 (1 0)
```

The identity `λx. x` is always `λ. 0` regardless of the name chosen.

**Shifting:** When a term is moved under additional binders, free variables must be incremented. The shift operation `↑ᵈₖ(t)` adds `d` to all indices ≥ `k`:

```
↑ᵈₖ(n)     = n            if n < k
↑ᵈₖ(n)     = n + d        if n ≥ k
↑ᵈₖ(λ. t)  = λ. ↑ᵈₖ₊₁(t)
↑ᵈₖ(t₁ t₂) = ↑ᵈₖ(t₁) ↑ᵈₖ(t₂)
```

**Substitution:** `t[n := s]` replaces index `n` in `t` with `s`:

```
m[n := s]      = s          if m = n
m[n := s]      = m          if m < n
m[n := s]      = m - 1      if m > n
(λ. t)[n := s] = λ. (t[n+1 := ↑¹₀(s)])
(t₁ t₂)[n := s] = t₁[n := s] t₂[n := s]
```

**Advantages:**
- Alpha-equivalent terms are syntactically identical (canonical forms)
- No need for freshness conditions
- Efficient comparison

**Disadvantages:**
- Shifting is pervasive and error-prone
- Weakening the context requires reindexing all free variables
- Terms are harder to read and debug
- Under-binder operations require careful index arithmetic

De Bruijn indices are widely used in proof assistants (Coq's kernel uses them) and in formalized metatheory.

### 1.3 De Bruijn Levels

De Bruijn levels index variables from the *bottom* of the context rather than from the *top*. A variable bound by the outermost binder has level 0, the next has level 1, and so on.

**Example:** In a context of depth `d`:
```
λ. λ. 1 0    (indices)
λ. λ. 0 1    (levels, assuming outer context has depth 0)
```

**Key property:** Weakening the context (adding new bindings at the end) does *not* require reindexing existing variables. This is the dual of de Bruijn indices, where *substitution* of closed terms does not require reindexing.

**Conversion:** Given context depth `d`, index `i` corresponds to level `d - i - 1`.

**Advantages:**
- No shifting needed when weakening contexts
- Values/closures can share terms across contexts of different depths
- Simpler in NbE implementations where values persist across context extensions

**Disadvantages:**
- Substitution of bound variables requires adjustment
- Less standard in the literature than indices

De Bruijn levels are particularly favored in NbE-based implementations (as in Kovacs's elaboration-zoo) because values in the semantic domain naturally use levels, while syntactic terms use indices.

### 1.4 Locally Nameless Representation

The locally nameless approach (systematized by Chargueraud, 2012, building on earlier work by Leroy and others) uses a hybrid: de Bruijn indices for *bound* variables and names for *free* variables.

**Syntax:**
```
e ::= bvar n | fvar x | λ. e | e₁ e₂
```

**Opening:** `e^x` replaces `bvar 0` in `e` with `fvar x`, decrementing other bound indices:
```
(bvar 0)^x = fvar x
(bvar n)^x = bvar (n-1)   if n > 0
(fvar y)^x = fvar y
(λ. e)^x   = λ. e^x       (with index adjustment)
```

**Closing:** `\x. e` replaces `fvar x` in `e` with `bvar 0`, incrementing bound indices.

**Local closure:** A term is locally closed if it contains no dangling bound variable indices. This condition replaces the notion of well-scopedness.

**Advantages:**
- Alpha-equivalent terms have unique representations
- Free variable substitution is simple (no capture possible)
- Works well with cofinite quantification in proof formalization
- Avoids both the overhead of full de Bruijn shifting and the ambiguity of named variables

**Disadvantages:**
- Two kinds of variables complicate the representation
- Opening/closing operations add complexity
- Need to maintain local closure invariants

This approach is popular in Coq formalizations of programming language metatheory (e.g., the POPLmark challenge solutions).

**Key reference:** Arthur Chargueraud. "The Locally Nameless Representation." *Journal of Automated Reasoning*, 49(3):363-408, 2012.

### 1.5 Higher-Order Abstract Syntax (HOAS)

HOAS represents object-language binders using metalanguage (host language) binders. A lambda abstraction `λx. e` is represented as a metalanguage function.

**In Haskell:**
```haskell
data Exp = Lam (Exp -> Exp) | App Exp Exp
```

**In Coq/F*:**
```
Inductive term : Type :=
  | Lam : (term -> term) -> term
  | App : term -> term -> term.
```

**Advantages:**
- Substitution is metalanguage function application (free!)
- Alpha-equivalence is automatic
- No variable management at all

**Disadvantages:**
- **Exotic terms problem:** The function space `term -> term` contains functions that inspect their argument's structure (e.g., by pattern matching), producing terms with no object-language counterpart
- Cannot define recursive functions over HOAS terms in many type theories (negative occurrence in inductive type)
- Difficult to serialize or compare terms
- Cannot enumerate subterms

### 1.6 Parametric Higher-Order Abstract Syntax (PHOAS)

PHOAS (Chlipala, 2008, building on Washburn and Weirich) parameterizes the term type over the representation of variables, then universally quantifies:

```haskell
data Term (v :: * -> *) (a :: *) where
  Var :: v a -> Term v a
  Lam :: (v a -> Term v b) -> Term v (a -> b)
  App :: Term v (a -> b) -> Term v a -> Term v b

type ClosedTerm a = forall v. Term v a
```

**In F*:**
```fstar
type term0 (v: typ -> Type) : typ -> Type =
  | Var : #t:typ -> v t -> term0 v t
  | Lam : #t1:typ -> #t2:typ -> (v t1 -> term0 v t2) -> term0 v (Arrow t1 t2)

let term (t:typ) = v:(typ -> Type) -> term0 v t
```

**How it solves exotic terms:** By parametricity, a function of type `forall v. Term v a` cannot inspect the structure of variables (since `v` is abstract). This eliminates exotic terms while retaining the convenience of host-language binding.

**Advantages:**
- No exotic terms (by parametricity)
- Substitution via function application
- Can define recursive functions by choosing appropriate `v`
- Different instantiations of `v` enable different analyses (e.g., `v = Const String` for pretty-printing, `v = Const Int` for counting)

**Disadvantages:**
- Universal quantification adds complexity
- Some operations (e.g., equality checking) still require instantiating `v`
- Less intuitive than direct HOAS

**Key reference:** Adam Chlipala. "Parametric Higher-Order Abstract Syntax for Mechanized Semantics." *ICFP 2008*.

### 1.7 Comparison of Approaches

| Approach | Alpha-equiv | Substitution | Under binders | Formalization | Debugging |
|---|---|---|---|---|---|
| Named | Non-trivial | Capture-avoiding needed | Natural | Hard | Easy |
| De Bruijn indices | Free | Requires shifting | Shifting needed | Good | Hard |
| De Bruijn levels | Free | Different shifting | No shift on weakening | Good | Hard |
| Locally nameless | Free | Simple for free vars | Opening/closing | Very good | Medium |
| HOAS | Free | Free (meta-app) | Free | Problematic | Hard |
| PHOAS | Free | Free (meta-app) | Free | Good | Medium |

**In practice:**
- **Proof assistants' kernels** tend to use de Bruijn indices (Coq) or a mix of indices and levels (Lean, Agda)
- **NbE-based elaborators** tend to use indices for syntax, levels for values (Kovacs's approach)
- **Formal metatheory** often uses locally nameless (Chargueraud) or intrinsically-typed de Bruijn (PLFA/Agda)
- **Embedded DSLs** favor PHOAS

---

## 2. Substitution

### 2.1 Capture-Avoiding Substitution

The classical formulation of substitution `e[x := s]` must avoid capturing free variables of `s` when passing through binders. With named variables:

```
x[x := s]          = s
y[x := s]          = y                  (y ≠ x)
(e₁ e₂)[x := s]   = e₁[x := s] e₂[x := s]
(λy. e)[x := s]    = λy. e[x := s]     (y ∉ FV(s), y ≠ x)
(λx. e)[x := s]    = λx. e             (x is shadowed)
```

When `y ∈ FV(s)`, alpha-renaming is needed before substitution. This is the source of most complexity with named representations.

### 2.2 Explicit Substitutions

Explicit substitutions (Abadi, Cardelli, Curien, and Levy, 1991) internalize substitution as part of the term language rather than performing it as a meta-operation. The canonical system is the λσ-calculus:

**Syntax extension:**
```
e ::= ... | e[σ]
σ ::= id | ↑ | e · σ | σ ∘ σ
```

where `σ` is a substitution (a sequence of terms to substitute for indices).

**Key rules:**
```
(λ. e)[σ]      →  λ. e[0 · (σ ∘ ↑)]
(e₁ e₂)[σ]    →  e₁[σ] e₂[σ]
0[e · σ]       →  e
(n+1)[e · σ]   →  n[σ]
n[id]          →  n
n[↑]           →  n+1
e[σ][τ]       →  e[σ ∘ τ]
```

**Motivation:** In naive substitution, applying a substitution to a term can cause size explosion. Explicit substitutions allow lazy, shared, and incremental application of substitutions. They serve as a bridge between the theoretical lambda calculus and efficient implementations.

**Variants:** Many calculi of explicit substitutions exist, including λσ, λσ_w (with weakening), λs, λse, λx, λυ (which preserves strong normalization, unlike the original λσ), and others.

**Key reference:** Martin Abadi, Luca Cardelli, Pierre-Louis Curien, and Jean-Jacques Levy. "Explicit Substitutions." *Journal of Functional Programming*, 1(4):375-416, 1991.

### 2.3 Simultaneous Substitution

Rather than substituting one variable at a time, simultaneous substitution applies a mapping from all variables to terms at once. This is the natural formulation with de Bruijn indices:

```
σ : ℕ → Term    (a substitution maps indices to terms)

e[σ] applies σ to all free variables of e simultaneously
```

Simultaneous substitution avoids the need for iterated single substitutions and is compositional: `(σ ∘ τ)(n) = σ(n)[τ]`.

In intrinsically-typed settings (as in PLFA), a substitution is a function from variables in one context to terms in another:

```agda
subst : ∀ {Γ Δ}
  → (∀ {A} → Γ ∋ A → Δ ⊢ A)
  → (∀ {A} → Γ ⊢ A → Δ ⊢ A)
```

### 2.4 Hereditary Substitution

Hereditary substitution computes the *canonical* (normal) form of the result of substituting one canonical form into another, performing beta-reductions as they are created. It is defined by structural recursion on types, ensuring termination.

**Key idea:** When substituting a canonical form `s` for variable `x` in a canonical form `e`:
- If substitution creates a beta-redex (a lambda applied to an argument), immediately reduce it
- The reduction produces a substitution at a *smaller type*, so the recursion terminates

**Termination argument:** The recursion is well-founded because:
1. The type of the substituted variable decreases at each beta-reduction
2. At a base type, no beta-reductions can occur

Hereditary substitution was made explicit by Watkins et al. and Adams, and has been formalized in Agda by Keller and Altenkirch (2010). It is used in systems like Twelf for normalization of LF terms.

**Key reference:** Kevin Watkins, Iliano Cervesato, Frank Pfenning, and David Walker. "A concurrent logical framework: The propositional fragment." In *Types for Proofs and Programs*, 2003.

---

## 3. Type Checking and Inference

### 3.1 Bidirectional Type Checking

Bidirectional type checking (surveyed comprehensively by Dunfield and Krishnaswami, 2021) splits the typing judgment into two modes:

**Checking mode** `Γ ⊢ e ⇐ A`: Given a term `e` and a type `A`, verify that `e` has type `A`.

**Synthesis (inference) mode** `Γ ⊢ e ⇒ A`: Given a term `e`, compute its type `A`.

**Core rules for STLC:**

```
           Γ(x) = A
Var:    ─────────────────
         Γ ⊢ x ⇒ A

         Γ ⊢ e₁ ⇒ A → B    Γ ⊢ e₂ ⇐ A
App:    ──────────────────────────────────
                 Γ ⊢ e₁ e₂ ⇒ B

            Γ, x:A ⊢ e ⇐ B
Lam:    ─────────────────────────
           Γ ⊢ λx. e ⇐ A → B

             Γ ⊢ e ⇒ A
Sub:    ─────────────────────     (A ≡ B or A <: B)
             Γ ⊢ e ⇐ B

           Γ ⊢ e ⇐ A
Anno:   ─────────────────
         Γ ⊢ (e : A) ⇒ A
```

**Design principle:** Introduction forms (constructors like `λ`, pairs, `zero`) are *checked*; elimination forms (applications, projections, recursion) *synthesize*. The annotation form `(e : A)` bridges the two modes by allowing a checkable expression to be used where synthesis is needed.

**Advantages:**
- Supports features where full inference is undecidable (e.g., dependent types, higher-rank polymorphism)
- Reduces annotation burden compared to fully explicit typing
- Improves error locality (errors are reported closer to their source)
- Naturally compositional and syntax-directed

**For dependent types:** Bidirectional checking is essential because type inference for dependent type theories is undecidable in general. The checking mode propagates known type information inward, while synthesis mode pushes inferred type information outward.

**Key references:**
- Joshua Dunfield and Neel Krishnaswami. "Bidirectional Typing." *ACM Computing Surveys*, 54(5), 2021.
- Benjamin Pierce and David Turner. "Local Type Inference." *ACM TOPLAS*, 22(1):1-44, 2000.
- Dunfield and Krishnaswami. "Complete and Easy Bidirectional Typechecking for Higher-Rank Polymorphism." *ICFP 2013*.

### 3.2 Algorithm W and Hindley-Milner Inference

For the Hindley-Milner type system (simple types with let-polymorphism), complete type inference is decidable. Algorithm W (Milner, 1978; building on Hindley, 1969) computes principal types.

**Type language:**
```
τ ::= α | τ₁ → τ₂ | T τ₁ ... τₙ     (monotypes)
σ ::= τ | ∀α. σ                        (type schemes / polytypes)
```

**Key operations:**

1. **Instantiation:** Replace universally quantified variables with fresh type variables:
   `∀α₁...αₙ. τ  ↦  τ[α₁ := β₁, ..., αₙ := βₙ]` where `βᵢ` are fresh.

2. **Generalization:** Close over free type variables not in the environment:
   `Gen(Γ, τ) = ∀α₁...αₙ. τ` where `{α₁,...,αₙ} = FTV(τ) \ FTV(Γ)`.

3. **Unification:** Find most general unifier (MGU) for two monotypes:
   - `unify(α, τ) = [α ↦ τ]` if `α ∉ FTV(τ)` (occurs check)
   - `unify(T τ₁...τₙ, T σ₁...σₙ) = unify(τ₁,σ₁) ∘ ... ∘ unify(τₙ,σₙ)`
   - Otherwise fail

**Algorithm W core:**
```
W(Γ, x)       = let ∀ᾱ.τ = Γ(x) in (Id, τ[ᾱ := fresh])
W(Γ, λx.e)    = let (S, τ) = W(Γ ∪ {x:β}, e) in (S, Sβ → τ)     (β fresh)
W(Γ, e₁ e₂)   = let (S₁, τ₁) = W(Γ, e₁)
                     (S₂, τ₂) = W(S₁Γ, e₂)
                     S₃ = unify(S₂τ₁, τ₂ → β)                     (β fresh)
                 in (S₃ ∘ S₂ ∘ S₁, S₃β)
W(Γ, let x=e₁ in e₂) = let (S₁, τ₁) = W(Γ, e₁)
                             (S₂, τ₂) = W(S₁Γ ∪ {x:Gen(S₁Γ,τ₁)}, e₂)
                         in (S₂ ∘ S₁, τ₂)
```

**Complexity:** Theoretically exponential (DEXPTIME-complete for HM), but near-linear in practice.

**Key references:**
- Robin Milner. "A Theory of Type Polymorphism in Programming." *JCSS*, 17(3):348-375, 1978.
- Luis Damas and Robin Milner. "Principal type-schemes for functional programs." *POPL 1982*.
- Roger Hindley. "The Principal Type-Scheme of an Object in Combinatory Logic." *Trans. AMS*, 146:29-60, 1969.

### 3.3 Unification

#### First-Order Unification
Robinson's unification algorithm (1965) finds the most general unifier of two first-order terms. It runs in near-linear time with union-find (Martelli and Montanari, 1982; Paterson and Wegman, 1978).

#### Higher-Order Unification
Unification modulo βη-equality is undecidable in general (Huet, 1973). Huet's semi-decision procedure uses a search procedure that alternates between simplification (decomposing rigid-rigid pairs) and guessing (projections and imitations for flex-rigid pairs).

#### Miller's Pattern Fragment
Dale Miller (1991) identified a decidable fragment of higher-order unification where metavariables are applied only to *distinct bound variables*. In this fragment:
- Solutions are unique (most general)
- The algorithm is a straightforward extension of first-order unification

**Pattern condition:** A flex term `?X y₁ y₂ ... yₙ` is a pattern if `y₁, ..., yₙ` are distinct bound variables.

**Solving:** Given `?X y₁ ... yₙ = t` where all free variables of `t` are among `y₁, ..., yₙ`:
```
?X := λy₁ ... yₙ. t
```

**Practical importance:** Pattern unification is sufficient for almost all programs in practice. Systems like λProlog, Twelf, Agda, and Lean use pattern unification as the primary solving mechanism, deferring non-pattern problems until further substitutions bring them into the pattern fragment.

**Extensions:** Abel and Pientka (2011) extended pattern unification to handle dependent types, Sigma types, and "twin variables" for heterogeneous equality.

**Key references:**
- Dale Miller. "A Logic Programming Language with Lambda-Abstraction, Function Variables, and Simple Unification." *Journal of Logic and Computation*, 1(4):497-536, 1991.
- Brigitte Pientka. "Extensions to Miller's Pattern Unification for Dependent Types." Unpublished manuscript.
- Adam Gundry and Conor McBride. "A Tutorial Implementation of Dynamic Pattern Unification." 2012.

### 3.4 Constraint-Based Approaches

Rather than threading substitutions eagerly (as in Algorithm W), constraint-based approaches separate constraint generation from solving:

1. **Generate:** Traverse the term, emitting type equality constraints `τ₁ ≐ τ₂`
2. **Solve:** Find a substitution satisfying all constraints simultaneously

This separation improves modularity and error reporting. The HM(X) framework (Odersky, Sulzmann, Wehr, 1999) parameterizes HM inference over an arbitrary constraint domain X.

**OutsideIn(X)** (Vytiniotis, Peyton Jones, Schrijvers, Sulzmann, 2011) extends this to handle GADTs, type families, and local assumptions, as used in GHC.

### 3.5 Elaboration

Elaboration translates a user-facing *surface language* (with syntactic sugar, implicit arguments, overloading, type class constraints, etc.) into a fully explicit *core language* that the type checker/kernel can verify.

**Key tasks of an elaborator:**
- Insert implicit arguments
- Resolve overloading and type class instances
- Desugar pattern matching into eliminators/case trees
- Infer universe levels
- Solve metavariables via unification
- Insert coercions
- Elaborate do-notation, where-clauses, etc.

**Design pattern (Coquand's algorithm / "semantic elaboration"):**
1. Elaborate surface syntax into core syntax with metavariables (holes)
2. Use NbE to evaluate terms into a semantic domain
3. Check definitional equality by comparing semantic values
4. Solve metavariables via pattern unification
5. Read back the final elaborated term

This is the approach used in Kovacs's elaboration-zoo and smalltt, and is described as the "de facto standard design for dependently typed elaboration."

**Key references:**
- Leonardo de Moura, Jeremy Avigad, Soonho Kong, and Cody Roux. "Elaboration in Dependent Type Theory." 2015. (Describes Lean's elaborator.)
- Thierry Coquand. "An Algorithm for Type-Checking Dependent Types." *Science of Computer Programming*, 26(1-3):167-177, 1996.
- Andras Kovacs. elaboration-zoo. https://github.com/AndrasKovacs/elaboration-zoo

---

## 4. Normalization

### 4.1 Normalization by Evaluation (NbE)

NbE is a technique for computing normal forms by interpreting terms into a *semantic domain* and then *reifying* (reading back) the semantic values into syntax. It was first described for the simply-typed lambda calculus and has since been extended to Martin-Lof type theory and beyond.

**Two-phase process:**
1. **Evaluation (`eval`):** Interpret a syntactic term in an environment to produce a semantic value
2. **Reification (`reify` / `readback`):** Convert a semantic value back into a syntactic normal form

**Semantic domain (for STLC):**

```
Values:
  v ::= closure(ρ, x, e)    -- function values
      | neutral(ne)          -- stuck computations

Neutrals:
  ne ::= var(x)              -- free variable
       | app(ne, v)          -- neutral applied to value
```

**Evaluation:**
```
eval(ρ, x)       = lookup(ρ, x)
eval(ρ, λx. e)   = closure(ρ, x, e)
eval(ρ, e₁ e₂)   = apply(eval(ρ, e₁), eval(ρ, e₂))

apply(closure(ρ, x, e), v) = eval(ρ[x ↦ v], e)
apply(neutral(ne), v)       = neutral(app(ne, v))
```

**Reification (with fresh name supply `k`):**
```
reify(k, closure(ρ, x, e)) = let v = neutral(var(xₖ))
                               in λxₖ. reify(k+1, eval(ρ[x ↦ v], e))
reify(k, neutral(ne))       = reifyNe(k, ne)

reifyNe(k, var(x))       = x
reifyNe(k, app(ne, v))   = reifyNe(k, ne) reify(k, v)
```

**Four design variants** (Bowman):
1. *Intensional readback*: Neutral values contain raw values; separate readback phase. Produces β-normal forms.
2. *Intensional reify*: Reification happens eagerly in application. Produces β-normal forms.
3. *Extensional meta-circular*: Uses metalanguage functions as semantic functions; `reflect`/`reify` are type-indexed. Produces βη-normal forms.
4. *Extensional residualizing*: Explicit closures with type-indexed reification. Produces βη-normal forms.

**For dependent types:** NbE is essential because definitional equality checking requires normalization, and types themselves contain terms that must be evaluated. The approach extends naturally: the semantic domain includes dependent function types (closures), dependent pair types, universe values, and neutral terms.

**Key references:**
- Ulrich Berger and Helmut Schwichtenberg. "An Inverse of the Evaluation Functional for Typed Lambda-Calculus." *LICS 1991*.
- David Christiansen. "Checking Dependent Types with Normalization by Evaluation: A Tutorial." https://davidchristiansen.dk/tutorials/nbe/
- Andreas Abel. "Normalization by Evaluation: Dependent Types and Impredicativity." Habilitation thesis, LMU Munich, 2013.
- Thierry Coquand. "An Algorithm for Type-Checking Dependent Types." 1996.

### 4.2 Reduction-Based Normalization

The classical approach: repeatedly apply reduction rules until a normal form is reached.

**Reduction strategies:**
- **Full β-reduction:** Reduce any redex anywhere (non-deterministic)
- **Normal order:** Reduce the leftmost-outermost redex first (finds normal form if one exists)
- **Applicative order:** Reduce the leftmost-innermost redex first (call-by-value)
- **Call-by-name:** Reduce the outermost redex first, never under lambdas
- **Call-by-need:** Like call-by-name with memoization (sharing)

**Weak vs strong normalization:**
- **Weak:** Do not reduce under binders (lambdas). Used for program execution.
- **Strong / full:** Reduce everywhere, including under binders. Needed for type checking in dependent type theories.

### 4.3 Weak Head Normal Form (WHNF)

A term is in *weak head normal form* if it is:
- A lambda abstraction `λx. e` (regardless of whether `e` is normalized)
- A variable `x`
- A neutral term (variable applied to arguments)
- A constructor applied to arguments

WHNF computation is the most common operation in type checkers for dependent types: definitional equality is checked by reducing both sides to WHNF and comparing heads, then recursively checking subterms.

### 4.4 Full Normalization Strategies

For dependent type checking, full normalization (under binders) is sometimes needed:
- **Iterated WHNF + structural descent:** Reduce to WHNF, then recursively normalize subterms
- **NbE:** The standard modern approach (see section 4.1)
- **Strong reduction machines:** Extend abstract machines to reduce under binders (e.g., the KN machine, a full-reducing variant of the Krivine machine)

---

## 5. Abstract Machines

Abstract machines provide operational semantics as state transition systems, bridging the gap between high-level lambda calculus and low-level execution.

### 5.1 SECD Machine

The SECD machine (Landin, 1964) was the first abstract machine for the lambda calculus. It has four components:

- **S (Stack):** Holds intermediate results and arguments
- **E (Environment):** Maps variables to values (closures)
- **C (Control):** The expression being evaluated (or instruction sequence)
- **D (Dump):** A stack of saved (S, E, C) triples (i.e., a call stack)

**Transition rules (simplified):**
```
(S, E, x.C, D)           → (lookup(E,x).S, E, C, D)           -- variable
(S, E, (λx.e).C, D)      → (closure(E,x,e).S, E, C, D)       -- abstraction
(S, E, (e₁ e₂).C, D)    → (S, E, e₂.e₁.@.C, D)              -- application
(closure(E',x,e).v.S, E, @.C, D)
                          → ([], E'[x↦v], e, (S,E,C).D)       -- apply
(v.S, E, [], (S',E',C').D)
                          → (v.S', E', C', D)                  -- return
```

The SECD machine implements call-by-value evaluation with a flat environment representation.

### 5.2 Krivine Machine

The Krivine machine (Krivine, 2007, describing work from the 1980s) implements *call-by-name* reduction to head normal form. It has three components:

- **Term (t):** The expression being evaluated
- **Environment (e):** Maps de Bruijn indices to closures
- **Stack (π):** Holds pending arguments

**Transition rules:**
```
⟨λ.t, e, (t', e') · π⟩  →  ⟨t, (t', e') · e, π⟩       -- beta
⟨t₁ t₂, e, π⟩           →  ⟨t₁, e, (t₂, e) · π⟩       -- push argument
⟨0, (t, e') · e, π⟩     →  ⟨t, e', π⟩                   -- variable lookup
⟨n+1, c · e, π⟩         →  ⟨n, e, π⟩                     -- skip binding
```

The machine uses closures `(t, e)` pairing a term with its environment, avoiding substitution entirely. It naturally implements call-by-name because arguments are pushed onto the stack as unevaluated closures.

**Variants:**
- The **KN machine** extends the Krivine machine to perform full (strong) normalization by reducing under binders
- Adding **update markers** to the stack yields a call-by-need machine

### 5.3 CEK Machine

The CEK machine (Felleisen and Friedman, 1986) implements *call-by-value* evaluation:

- **C (Control):** The current expression
- **E (Environment):** Maps variables to values
- **K (Continuation):** Represents the evaluation context (what to do next)

**Continuations:**
```
κ ::= mt                          -- done
    | ar(e, E, κ)                -- evaluating function, argument waiting
    | fn(closure(E, x, e), κ)    -- function ready, evaluating argument
```

**Transition rules:**
```
⟨x, E, κ⟩                      → ⟨E(x), κ⟩                        -- lookup
⟨λx.e, E, κ⟩                   → ⟨closure(E, x, e), κ⟩            -- value
⟨e₁ e₂, E, κ⟩                 → ⟨e₁, E, ar(e₂, E, κ)⟩           -- eval fun
⟨v, ar(e, E, κ)⟩               → ⟨e, E, fn(v, κ)⟩                 -- eval arg
⟨v, fn(closure(E, x, e), κ)⟩   → ⟨e, E[x↦v], κ⟩                  -- apply
```

The CEK machine is essentially the SECD machine with the dump replaced by a first-class continuation. It is more modular and easier to extend.

### 5.4 Zinc Abstract Machine (ZAM)

The ZAM (Leroy, 1990) underlies the OCaml bytecode interpreter. It is a refinement of the Krivine machine optimized for call-by-value:

**Key innovations:**
- **Curried function optimization:** Multiple arguments to a curried function are passed efficiently without building intermediate closures
- **Compiled representation:** Terms are compiled to instruction sequences rather than interpreted directly
- **Efficient environment representation:** Uses arrays rather than linked lists for O(1) variable access
- **Tail call optimization:** Built into the machine

**Instruction set includes:**
- `GRAB` (begin a function body, taking an argument from the stack)
- `PUSH` (push a value)
- `ACC n` (access the nth environment slot)
- `APPLY` / `APPTERM` (function application / tail application)
- `CLOSURE` / `CLOSUREREC` (build closures)
- `RETURN` (return from function)

The ZAM design influenced all subsequent Caml implementations and remains the basis for OCaml's bytecode compiler.

**Key reference:** Xavier Leroy. "The ZINC Experiment: An Economical Implementation of the ML Language." Technical Report 117, INRIA, 1990.

### 5.5 Interaction Nets

Interaction nets (Lafont, 1990) are a graphical model of computation based on graph rewriting. They provide a natural framework for *optimal reduction* of lambda calculus terms (in the sense of Levy).

**Key properties:**
- The number of rewrites to normalize a net is independent of reduction order
- Beta-reduction optimality: abstractions are duplicated incrementally, avoiding redundant work
- Natural support for massive parallelism
- Based on linear logic's proof nets

**Relationship to lambda calculus:** Gonthier, Abadi, and Levy (1992) showed how to implement Lamping's optimal reduction algorithm using interaction nets. This gives an implementation that never duplicates work, achieving Levy's theoretical optimum.

**Modern implementations:** The HVM (Higher-order Virtual Machine) / Bend project uses interaction nets for massively parallel lambda calculus evaluation.

**Key references:**
- Yves Lafont. "Interaction Nets." *POPL 1990*.
- Georges Gonthier, Martin Abadi, and Jean-Jacques Levy. "The Geometry of Optimal Lambda Reduction." *POPL 1992*.
- John Lamping. "An Algorithm for Optimal Lambda Calculus Reduction." *POPL 1990*.

---

## 6. Efficient Implementation Techniques

### 6.1 Hash-Consing for Terms

Hash-consing ensures that structurally equal terms share the same memory representation. When constructing a term node, the system checks a global hash table; if an identical node exists, it returns a pointer to the existing node.

**Benefits:**
- Constant-time equality checking via pointer comparison
- Reduced memory usage through sharing
- Enables memoization of operations on terms (since identical inputs have identical addresses)

**Implementation:** Typically uses a hash table with weak references, allowing garbage collection of unused terms. Each node stores a precomputed hash code for O(1) lookup.

**Used in:** ACL2 (the HONS system), some configurations of Coq, and various SMT solvers.

### 6.2 Caching and Memoization

- **Type inference caching:** Cache the inferred type of subterms to avoid redundant type inference
- **Reduction caching:** Cache weak head normal forms of terms to avoid re-reduction
- **Conversion caching:** Cache the results of definitional equality checks
- **Hash-consing synergy:** With hash-consed terms, memoization tables can use pointer identity as keys

Lean 4's MetaM monad provides built-in caching mechanisms for type inference and reduction results.

### 6.3 Incremental Type Checking

When source code changes, re-checking the entire program is wasteful. Incremental approaches include:
- **Dependency tracking:** Only re-check definitions that transitively depend on changed definitions
- **Salting/fingerprinting:** Use content hashing to detect unchanged definitions
- **Separate compilation:** Check modules independently with explicit interfaces

Lean 4 and Agda both support incremental checking at the module/file level.

### 6.4 Compilation vs Interpretation

- **Tree-walking interpretation:** Directly traverse the AST. Simple but slow.
- **Bytecode compilation:** Compile to instructions for an abstract machine (e.g., ZAM for OCaml, Lean 4's VM). 10-100x faster than tree-walking.
- **Native code compilation:** Compile to machine code via LLVM or C. Fastest execution but slower compilation. Lean 4 supports this path.
- **JIT compilation:** Compile hot paths during execution. Used in some research systems.

For type checkers, the key operation is evaluating terms during type checking (for conversion checking). Lean 4 uses a register-based VM for this purpose, achieving high performance.

---

## 7. Notable Implementations and Their Design Choices

### 7.1 Coq

**Type theory:** Polymorphic Cumulative Calculus of Inductive Constructions (PCUIC).

**Kernel architecture:**
- Small trusted kernel written in OCaml
- Uses de Bruijn indices for bound variables
- Reduction machine for conversion checking (a variant of the Krivine machine with local definitions and caching)
- Separate certified kernel (MetaCoq/Coq Coq Correct) verified in Coq itself
- Universe polymorphism with universe constraint checking
- Guard condition checker for recursive definitions (syntactic)

**Elaboration:** The tactic engine (Ltac, Ltac2) and SSReflect provide powerful elaboration from proof scripts to kernel terms. Unification uses evarconv, a sophisticated higher-order unification procedure.

**Key facts:**
- Approximately one critical kernel bug found per year historically
- MetaCoq project provides a verified type checker for a large fragment of CIC
- The kernel does *not* include the module system or template polymorphism in the trusted base of the verified checker

**Key reference:** Matthieu Sozeau et al. "Coq Coq Correct! Verification of Type Checking and Erasure for Coq, in Coq." *POPL 2020*.

### 7.2 Agda

**Type theory:** Intensional Martin-Lof Type Theory with induction-recursion, universe polymorphism, sized types, and cubical type theory (optional).

**Implementation architecture (Haskell):**
- Three syntax levels: Concrete (surface) → Abstract (desugared) → Internal (type-checked core)
- Internal syntax uses a Haskell ADT with variants for Var, Lam, Lit, Def, Con, Pi, Sort, Level, MetaVar, and DontCare
- Bidirectional type checker for internal syntax
- Pattern unification with postponement for non-pattern problems
- "Treeless" intermediate syntax for compiler backends

**Variable representation:** Uses de Bruijn indices in the internal syntax.

**Compilation:** GHC backend translates treeless syntax to Haskell; JavaScript backend also available.

**Special features:**
- Instance arguments (type-class-like mechanism)
- Sized types for termination checking
- Reflection (elaborator reflection for metaprogramming)

### 7.3 Lean 4

**Type theory:** Calculus of Inductive Constructions with:
- Quotient types
- Definitional proof irrelevance (Prop)
- Explicit universe levels with universe polymorphism

**Kernel architecture:**
- Small trusted kernel written in C++
- Uses de Bruijn indices (bound variables represented as `bvar n`)
- Does *not* perform bidirectional type checking; uses forward type inference via `inferType`
- Does *not* do unification in the kernel (done by the elaborator)
- No syntactic termination checker in kernel; all recursion elaborated to primitive recursors

**Elaboration architecture:**
- Metaprogramming framework based on the `MetaM` monad
- Elaborate surface syntax → fully explicit kernel terms
- Implicit argument inference via unification
- Type class synthesis
- Universe level inference
- Overloading and notation resolution through macro expansion

**Execution:**
- Register-based VM for bytecode execution
- LLVM backend for native code compilation
- Interpreter for compile-time evaluation

**Verified kernel:** Lean4Lean (Carneiro, 2024) provides a type checker for Lean verified in Lean itself.

**Key references:**
- Leonardo de Moura et al. "The Lean 4 Theorem Prover and Programming Language."
- Mario Carneiro. "Lean4Lean: Verifying a Typechecker for Lean, in Lean." 2024.
- https://ammkrn.github.io/type_checking_in_lean4/

### 7.4 Mini-TT

A minimal dependently-typed language implemented in about 400 lines of Haskell (Coquand, Kinoshita, Nordstrom, Takeyama, 2009). Includes:
- Dependent function types (Pi)
- Dependent pair types (Sigma)
- Sum types, Unit, Void
- NbE-based type checking

Does not include propositional equality, indexed datatypes, or termination checking. Serves as a pedagogical reference implementation.

**Key reference:** Thierry Coquand, Yoshiki Kinoshita, Bengt Nordstrom, and Makoto Takeyama. "A Simple Type-Theoretic Language: Mini-TT." In *From Semantics to Computer Science: Essays in Honour of Gilles Kahn*, 2009.

### 7.5 pi-forall

Stephanie Weirich's tutorial implementation of dependent types in Haskell, used at OPLSS 2022 and other venues. Progressive development covering:
- Basic dependent type checking with NbE
- Definitional equality and its algorithmic implementation
- Relevance tracking and erasure
- Datatypes and dependent pattern matching

**Key reference:** Stephanie Weirich. "Implementing Dependent Types in pi-forall." Lecture notes, 2022. arXiv:2207.02129.

### 7.6 Andras Kovacs's elaboration-zoo

A series of progressively more complex Haskell implementations demonstrating best-practice elaboration techniques:

1. **01-eval:** Three variants showing evaluation with different variable representations (HOAS+names, closures+de Bruijn, closures+names)
2. **02-typecheck:** Type checking with the same three variants
3. **03-holes:** Holes and pattern unification
4. **04-implicit-args:** Implicit argument insertion
5. **05-pruning:** Pruning of metavariable dependencies
6. **06-first-class-poly:** First-class polymorphism with impredicativity

**Design:** Uses de Bruijn indices for syntax, de Bruijn levels for values in the NbE domain. Based on Coquand's algorithm.

**Related project:** `smalltt` demonstrates that this approach scales to high-performance type checking.

**URL:** https://github.com/AndrasKovacs/elaboration-zoo

---

## 8. Key References

### Variable Representation
- Nicolaas G. de Bruijn. "Lambda Calculus Notation with Nameless Dummies." *Indagationes Mathematicae*, 34:381-392, 1972.
- Arthur Chargueraud. "The Locally Nameless Representation." *Journal of Automated Reasoning*, 49(3):363-408, 2012.
- Adam Chlipala. "Parametric Higher-Order Abstract Syntax for Mechanized Semantics." *ICFP 2008*.
- Geoffrey Washburn and Stephanie Weirich. "Boxes Go Bananas: Encoding Higher-Order Abstract Syntax with Parametric Polymorphism." *ICFP 2003*.
- Frank Pfenning and Conal Elliott. "Higher-Order Abstract Syntax." *PLDI 1988*.

### Substitution
- Martin Abadi, Luca Cardelli, Pierre-Louis Curien, and Jean-Jacques Levy. "Explicit Substitutions." *Journal of Functional Programming*, 1(4):375-416, 1991.
- Kevin Watkins, Iliano Cervesato, Frank Pfenning, and David Walker. "A Concurrent Logical Framework: The Propositional Fragment." In *Types for Proofs and Programs*, 2003. (Hereditary substitution.)
- Conor McBride. "Type-Preserving Renaming and Substitution." Unpublished note, 2005.

### Type Checking and Inference
- Joshua Dunfield and Neel Krishnaswami. "Bidirectional Typing." *ACM Computing Surveys*, 54(5), 2021.
- Robin Milner. "A Theory of Type Polymorphism in Programming." *JCSS*, 17(3):348-375, 1978.
- Luis Damas and Robin Milner. "Principal Type-Schemes for Functional Programs." *POPL 1982*.
- Benjamin Pierce and David Turner. "Local Type Inference." *ACM TOPLAS*, 22(1):1-44, 2000.
- Thierry Coquand. "An Algorithm for Type-Checking Dependent Types." *Science of Computer Programming*, 26(1-3):167-177, 1996.
- Leonardo de Moura, Jeremy Avigad, Soonho Kong, and Cody Roux. "Elaboration in Dependent Type Theory." 2015.

### Unification
- Dale Miller. "A Logic Programming Language with Lambda-Abstraction, Function Variables, and Simple Unification." *Journal of Logic and Computation*, 1(4):497-536, 1991.
- Gerard Huet. "The Undecidability of Unification in Third Order Logic." *Information and Control*, 22(3):257-267, 1973.
- Gerard Huet. "A Unification Algorithm for Typed Lambda-Calculus." *Theoretical Computer Science*, 1(1):27-57, 1975.
- J. A. Robinson. "A Machine-Oriented Logic Based on the Resolution Principle." *JACM*, 12(1):23-41, 1965.
- Adam Gundry and Conor McBride. "A Tutorial Implementation of Dynamic Pattern Unification." 2012.
- Andreas Abel and Brigitte Pientka. "Higher-Order Dynamic Pattern Unification for Dependent Types and Records." *TLCA 2011*.

### Normalization
- Ulrich Berger and Helmut Schwichtenberg. "An Inverse of the Evaluation Functional for Typed Lambda-Calculus." *LICS 1991*.
- Andreas Abel. "Normalization by Evaluation: Dependent Types and Impredicativity." Habilitation thesis, LMU Munich, 2013.
- David Christiansen. "Checking Dependent Types with Normalization by Evaluation: A Tutorial." https://davidchristiansen.dk/tutorials/nbe/
- Chantal Keller and Thorsten Altenkirch. "Hereditary Substitutions for Simple Types, Formalized." *MSFP 2010*.

### Abstract Machines
- Peter Landin. "The Mechanical Evaluation of Expressions." *Computer Journal*, 6(4):308-320, 1964.
- Jean-Louis Krivine. "A Call-by-Name Lambda-Calculus Machine." *Higher-Order and Symbolic Computation*, 20(3):199-207, 2007.
- Matthias Felleisen and Daniel P. Friedman. "Control Operators, the SECD-Machine, and the Lambda-Calculus." In *Formal Description of Programming Concepts III*, 1986.
- Xavier Leroy. "The ZINC Experiment: An Economical Implementation of the ML Language." Technical Report 117, INRIA, 1990.
- Yves Lafont. "Interaction Nets." *POPL 1990*.
- John Lamping. "An Algorithm for Optimal Lambda Calculus Reduction." *POPL 1990*.

### Implementations
- The Coq Development Team. "The Coq Proof Assistant." https://coq.inria.fr/
- The Agda Development Team. "The Agda Programming Language." https://agda.readthedocs.io/
- Leonardo de Moura and Sebastian Ullrich. "The Lean 4 Theorem Prover and Programming Language." *CADE 2021*.
- Mario Carneiro. "Lean4Lean: Verifying a Typechecker for Lean, in Lean." 2024. arXiv:2403.14064.
- Matthieu Sozeau et al. "Coq Coq Correct! Verification of Type Checking and Erasure for Coq, in Coq." *POPL 2020*.
- Andras Kovacs. elaboration-zoo. https://github.com/AndrasKovacs/elaboration-zoo
- Stephanie Weirich. "Implementing Dependent Types in pi-forall." 2022. arXiv:2207.02129.
- Thierry Coquand et al. "A Simple Type-Theoretic Language: Mini-TT." 2009.
- Andrej Bauer. "How to Implement Dependent Type Theory." Blog posts, 2012. https://math.andrej.com/2012/11/08/how-to-implement-dependent-type-theory-i/

### Tutorials and Surveys
- Andres Loh, Conor McBride, and Wouter Swierstra. "A Tutorial Implementation of a Dependently Typed Lambda Calculus." *Fundamenta Informaticae*, 102(2):177-207, 2010.
- William J. Bowman. "Normalization by Evaluation Four Ways." https://williamjbowman.com/tmp/nbe-four-ways/
- Oleg Kiselyov. "Elementary Tutorial on Normalization-by-Evaluation." https://okmij.org/ftp/tagless-final/NBE.html
