# The Untyped Lambda Calculus: A Comprehensive Reference

## 1. Overview

The untyped lambda calculus is a formal system for expressing computation based on
function abstraction and application. Introduced by Alonzo Church in the 1930s, it
provides a universal model of computation equivalent in power to Turing machines.
Despite its extreme syntactic simplicity -- consisting only of variables, abstraction,
and application -- it can encode all computable functions, arbitrary data structures,
and control flow.

The lambda calculus serves as:
- A foundation for the theory of computation (Church-Turing thesis)
- The theoretical basis for functional programming languages
- A metalanguage for studying programming language semantics
- A test bed for ideas in type theory, proof theory, and category theory

---

## 2. Historical Context

### 2.1 Church's Original Program (1928--1935)

Alonzo Church began developing a formal system around 1928--29 at Princeton,
intending it as a foundation for all of mathematics. He published two versions:

- **Church (1932)**: "A Set of Postulates for the Foundation of Logic,"
  *Annals of Mathematics* 33, 346--366.
- **Church (1933)**: "A Set of Postulates for the Foundation of Logic (Second Paper),"
  *Annals of Mathematics* 34, 839--864.

Both systems included lambda-abstraction alongside logical axioms.

### 2.2 The Kleene-Rosser Paradox (1935)

Church's students **Stephen Cole Kleene** and **J. Barkley Rosser** proved in 1935
that both of Church's systems were inconsistent. Using Godel's arithmetization
technique, they constructed a diagonal/self-referential argument showing that
the systems could derive a contradiction (distinct from Richard's paradox,
though similarly exploiting self-reference).

- Kleene, S.C. and Rosser, J.B. (1935). "The Inconsistency of Certain Formal Logics."
  *Annals of Mathematics* 36(3), 630--636.

### 2.3 The Pure Lambda Calculus (1935--1936)

In response, Church isolated the purely functional fragment of his system -- the
**pure lambda calculus** -- discarding the logical axioms. He and Rosser proved its
consistency via the Church-Rosser theorem:

- Church, A. and Rosser, J.B. (1936). "Some Properties of Conversion."
  *Transactions of the AMS* 39(3), 472--482.

### 2.4 Church's Thesis and the Entscheidungsproblem (1936)

Church published two landmark papers in 1936:

1. **"An Unsolvable Problem of Elementary Number Theory"** (*American Journal of
   Mathematics* 58, 345--363): Formulated Church's thesis identifying effective
   calculability with lambda-definability (equivalently, recursive functions), and
   proved the undecidability of lambda-term equivalence.

2. **"A Note on the Entscheidungsproblem"** (*Journal of Symbolic Logic* 1, 40--41):
   Gave a negative solution to Hilbert's decision problem.

### 2.5 Turing's Independent Work (1936)

Alan Turing independently arrived at the same undecidability results using his
machine model:

- Turing, A.M. (1936). "On Computable Numbers, with an Application to the
  Entscheidungsproblem." *Proceedings of the London Mathematical Society* 42, 230--265.

Turing proved that lambda-definability and Turing-computability define the same
class of functions, establishing what is now called the **Church-Turing thesis**.

### 2.6 Key Contributors

| Contributor | Contribution |
|---|---|
| Alonzo Church | Invented lambda calculus (1932--36), Church's thesis |
| Stephen Kleene | Lambda-definability = recursiveness (1936), Kleene-Rosser paradox |
| J. Barkley Rosser | Church-Rosser theorem, Kleene-Rosser paradox |
| Alan Turing | Turing machines, equivalence with lambda calculus |
| Haskell Curry | Combinatory logic, fixed-point (Y) combinator, Curry-Howard |
| Moses Schonfinkel | Combinatory logic (1924), predecessor to lambda calculus |
| Dana Scott | Denotational semantics, domain theory, D-infinity models (1969--72) |
| Corrado Bohm | Bohm's theorem (separability), Bohm trees |
| Nicolaas de Bruijn | De Bruijn indices for nameless representation (1972) |

---

## 3. Syntax

### 3.1 Terms

Given a countably infinite set of variables V = {x, y, z, x_1, x_2, ...}, the set
of **lambda terms** (denoted Lambda) is defined inductively by:

```
M, N ::= x           (variable)
        | (M N)       (application)
        | (lambda x. M)  (abstraction)
```

where x ranges over V and M, N range over Lambda.

- **Variables** represent placeholders or parameters.
- **Application** (M N) represents applying function M to argument N.
- **Abstraction** (lambda x. M) represents an anonymous function with parameter x
  and body M.

### 3.2 Notational Conventions

1. **Outermost parentheses are dropped**: `M N` instead of `(M N)`.

2. **Application is left-associative**: `M N P` means `((M N) P)`, not `(M (N P))`.

3. **Abstraction extends as far right as possible** (right-associative):
   `lambda x. M N` means `lambda x. (M N)`, not `(lambda x. M) N`.

4. **Multiple abstractions are condensed**:
   `lambda x y z. M` abbreviates `lambda x. lambda y. lambda z. M`.

5. **Application binds tighter than abstraction**:
   `lambda x. x y` means `lambda x. (x y)`.

### 3.3 Free and Bound Variables

In `lambda x. M`, the variable x is **bound** in M. Variables not bound by any
enclosing lambda are **free**.

The set of free variables is defined inductively:

```
FV(x)            = {x}
FV(M N)          = FV(M) union FV(N)
FV(lambda x. M)  = FV(M) \ {x}
```

A term with no free variables is called a **combinator** or **closed term**.

### 3.4 Subterms and Contexts

A **context** C[ ] is a term with a "hole" [ ]. If C[ ] is a context and M a term,
then C[M] is the term obtained by placing M in the hole. Contexts are central to
defining compatible (congruence) relations on terms.

---

## 4. Alpha-Equivalence

### 4.1 Definition

Two terms are **alpha-equivalent** (written M =_alpha N) if they differ only in
the names of their bound variables. Alpha-equivalence is defined as the least
congruence satisfying:

```
lambda x. M  =_alpha  lambda y. M[x := y]
```

provided y is not free in M (to avoid capture).

Examples:
- `lambda x. x` =_alpha `lambda y. y`
- `lambda x. lambda y. x y` =_alpha `lambda a. lambda b. a b`
- `lambda x. y` =_alpha `lambda z. y`  (y is free, not captured)

### 4.2 Convention

Following Barendregt's **variable convention**, we identify alpha-equivalent terms
and always choose bound variable names to avoid clashes with free variables.
Formally, we work with equivalence classes of terms modulo alpha-equivalence.

### 4.3 De Bruijn Indices (Alternative Representation)

Nicolaas de Bruijn (1972) introduced a nameless representation that eliminates
alpha-equivalence issues entirely. Each bound variable is replaced by a natural
number indicating the number of enclosing lambdas between the variable and its
binder.

**Definition**: Lambda terms with de Bruijn indices:

```
M ::= n            (index, n >= 0)
     | (M N)       (application)
     | (lambda. M)  (abstraction, no variable name)
```

**Examples** (named vs. de Bruijn):

| Named             | De Bruijn       |
|---|---|
| `lambda x. x`    | `lambda. 0`     |
| `lambda x. lambda y. x` | `lambda. lambda. 1` |
| `lambda x. lambda y. x y` | `lambda. lambda. 1 0` |
| `lambda x. (lambda y. y) x` | `lambda. (lambda. 0) 0` |

**Advantages**:
- Alpha-equivalent terms have identical de Bruijn representations.
- Checking alpha-equivalence becomes syntactic equality.
- No need for capture-avoiding substitution; instead, **shifting** (incrementing
  free indices when going under a binder) handles scope correctly.

**Substitution with de Bruijn indices** requires a **shift** operation:

```
shift(d, c, n) = n          if n < c
               = n + d      if n >= c
```

where d is the shift amount and c is the cutoff (depth of binders traversed).

---

## 5. Substitution

### 5.1 Capture-Avoiding Substitution

The substitution `M[x := N]` replaces all free occurrences of x in M with N,
while avoiding variable capture:

```
x[x := N]            = N
y[x := N]            = y                          (if x /= y)
(P Q)[x := N]        = (P[x := N]) (Q[x := N])
(lambda x. P)[x := N] = lambda x. P                (x is bound, no substitution)
(lambda y. P)[x := N] = lambda y. P[x := N]        (if y /= x and y not in FV(N))
(lambda y. P)[x := N] = lambda z. (P[y := z])[x := N]
                                                    (if y in FV(N); fresh z)
```

The last case performs **alpha-renaming** of the bound variable y to a fresh z
before substituting, preventing the free variables of N from being accidentally
captured by the binder.

### 5.2 The Substitution Lemma

A crucial property for metatheory:

**Lemma**: If x /= y and x is not free in L, then:

```
M[x := N][y := L] = M[y := L][x := N[y := L]]
```

---

## 6. Reduction

### 6.1 Beta-Reduction

Beta-reduction is the fundamental computational rule of the lambda calculus. A
**beta-redex** is a term of the form `(lambda x. M) N`. The **contractum** is
`M[x := N]`.

**One-step beta-reduction** (->_beta) is the least compatible relation (closed
under all contexts) satisfying:

```
(lambda x. M) N  ->_beta  M[x := N]
```

Compatibility means:
- If M ->_beta M', then (M N) ->_beta (M' N)
- If N ->_beta N', then (M N) ->_beta (M N')
- If M ->_beta M', then (lambda x. M) ->_beta (lambda x. M')

**Multi-step beta-reduction** (->>_beta) is the reflexive-transitive closure
of ->_beta.

**Beta-equivalence** (=_beta) is the reflexive-symmetric-transitive closure
(equivalence closure) of ->_beta.

### 6.2 Eta-Reduction

Eta-reduction captures the principle of **extensionality**: two functions are
equal if they produce the same result on all inputs.

```
lambda x. M x  ->_eta  M       (provided x is not free in M)
```

The reverse direction (eta-expansion) is sometimes also considered:

```
M  ->_eta-exp  lambda x. M x   (provided x is not free in M)
```

Beta-eta-equivalence (=_beta-eta) is the equivalence closure of both beta and
eta reduction combined. It is important for Bohm's theorem (Section 13).

### 6.3 Delta-Reduction

In extensions of the pure lambda calculus, **delta-reduction** handles built-in
constants and their computation rules. For example, if we add natural number
constants and an addition operator:

```
add 2 3  ->_delta  5
```

Delta-rules are not part of the pure lambda calculus but appear in applied lambda
calculi used in programming language theory.

---

## 7. Reduction Strategies

A **reduction strategy** determines which redex to contract when a term contains
multiple redexes. The choice of strategy affects whether reduction terminates and
the efficiency of evaluation.

### 7.1 Normal Order Reduction

**Leftmost-outermost** reduction: always reduce the leftmost redex that is not
contained inside any other redex.

- Corresponds to **call-by-name** evaluation.
- **Normalizing**: if a term has a normal form, normal-order reduction will find it
  (this is the Standardization Theorem -- see Section 9).
- May evaluate arguments that are never used (wasteful only in the sense that
  it substitutes unevaluated arguments, which may then be duplicated).

### 7.2 Applicative Order Reduction

**Leftmost-innermost** reduction: always reduce the leftmost redex that contains
no other redex (i.e., reduce arguments before function application).

- Corresponds to **call-by-value** evaluation.
- More efficient when arguments are used multiple times (avoids re-evaluation
  of the same expression).
- **Not normalizing**: may diverge even when a normal form exists.

**Example**: Consider `(lambda x. lambda y. y) ((lambda z. z z)(lambda z. z z))`.
- Normal order: reduces the outer redex first, discarding the divergent argument.
  Result: `lambda y. y`.
- Applicative order: tries to evaluate the argument `(lambda z. z z)(lambda z. z z)`
  first, which diverges.

### 7.3 Call-by-Name

Like normal order, but does **not** reduce under lambda abstractions. Evaluation
stops at **weak head normal form** (WHNF). Used in languages like (historical)
Algol 60.

### 7.4 Call-by-Value

Like applicative order, but does **not** reduce under lambda abstractions.
Arguments are evaluated to values (WHNF or abstractions) before substitution.
Used in most programming languages (ML, Scheme, Python, Java).

### 7.5 Call-by-Need (Lazy Evaluation)

A refinement of call-by-name that **memoizes** (shares) the result of evaluating
an argument the first time it is demanded, avoiding re-evaluation. Used in Haskell.
Operationally equivalent to call-by-name but more efficient.

### 7.6 Summary Table

| Strategy | Order | Under lambdas? | Normalizing? | Corresponds to |
|---|---|---|---|---|
| Normal order | Leftmost-outermost | Yes | Yes | -- |
| Applicative order | Leftmost-innermost | Yes | No | -- |
| Call-by-name | Leftmost-outermost | No | Yes* | Algol 60 |
| Call-by-value | Leftmost-innermost | No | No | ML, Scheme |
| Call-by-need | Leftmost-outermost | No | Yes* | Haskell |

(*) Normalizing to WHNF when a WHNF exists.

---

## 8. The Church-Rosser Theorem (Confluence)

### 8.1 Statement

**Theorem** (Church and Rosser, 1936): Beta-reduction is **confluent**. That is,
if M ->>_beta M_1 and M ->>_beta M_2, then there exists a term M_3 such that
M_1 ->>_beta M_3 and M_2 ->>_beta M_3.

```
        M
       / \
      /   \
     v     v
    M_1   M_2
     \   /
      \ /
       v
      M_3
```

### 8.2 Corollaries

**Corollary 1** (Uniqueness of normal forms): If M has a normal form, it is unique
(up to alpha-equivalence).

*Proof*: If M ->>_beta N_1 and M ->>_beta N_2 where N_1, N_2 are in normal form,
then by confluence there exists N_3 with N_1 ->>_beta N_3 and N_2 ->>_beta N_3.
But normal forms cannot be reduced further, so N_1 = N_3 = N_2.

**Corollary 2** (Consistency of beta-equality): Not all terms are beta-equal.
In particular, `true` (= lambda x y. x) and `false` (= lambda x y. y) are not
beta-equivalent, since they are distinct normal forms.

### 8.3 Proof Sketch (Tait-Martin-Lof Method)

The standard modern proof proceeds via **parallel reduction** (==>):

1. **Define parallel reduction** (==>): informally, M ==> N if N is obtained from
   M by simultaneously reducing zero or more redexes in M.

   Formally:
   - x ==> x
   - If M ==> M' and N ==> N', then M N ==> M' N'
   - If M ==> M', then lambda x. M ==> lambda x. M'
   - If M ==> M' and N ==> N', then (lambda x. M) N ==> M'[x := N']

2. **Show ==> satisfies the diamond property**: If M ==> M_1 and M ==> M_2,
   then there exists M_3 such that M_1 ==> M_3 and M_2 ==> M_3.

   This is done via **Takahashi's complete development**: define M* as the result
   of reducing *all* redexes in M simultaneously. Then M ==> M* for any M, and
   if M ==> N then N ==> M*. The diamond property follows.

3. **Observe**: The reflexive-transitive closure of ==> equals ->>_beta.
   Since ==> has the diamond property, its reflexive-transitive closure
   (= ->>_beta) is confluent.

### 8.4 Extension to Beta-Eta

The Church-Rosser theorem also holds for beta-eta-reduction: if
M ->>_{beta-eta} M_1 and M ->>_{beta-eta} M_2, then there exists M_3 with
M_1 ->>_{beta-eta} M_3 and M_2 ->>_{beta-eta} M_3.

---

## 9. The Standardization Theorem

### 9.1 Statement

**Theorem** (Curry and Feys, 1958; refined by many authors): If M ->>_beta N,
then there is a **standard reduction sequence** from M to N, in which redexes
are contracted in a left-to-right order (the leftmost redex is always reduced first,
and a redex created by contracting another redex is only contracted after all
redexes to its left).

### 9.2 Consequences

**Corollary** (Normalization by leftmost reduction): If a term M has a beta-normal
form N, then the **leftmost (normal-order) reduction** sequence starting from M
terminates at N.

This is a stronger result than the Church-Rosser theorem: not only is the normal
form unique, but a specific canonical strategy is guaranteed to find it.

### 9.3 Intuition

If a function ignores its argument, then reducing the outermost redex first can
"discard" the argument entirely (even if the argument diverges). In contrast,
reducing the argument first may lead to non-termination for no benefit.

---

## 10. Normal Forms

### 10.1 Beta-Normal Form (NF)

A term is in **beta-normal form** if it contains no beta-redexes, i.e., no subterm
of the form `(lambda x. M) N`.

Normal forms have the shape:

```
lambda x_1 ... x_m. y M_1 M_2 ... M_n
```

where y is a variable (possibly one of the x_i) and each M_i is itself in normal form,
and m, n >= 0.

### 10.2 Head Normal Form (HNF)

A term is in **head normal form** if it has the shape:

```
lambda x_1 ... x_m. y M_1 M_2 ... M_n
```

where the M_i need **not** themselves be in normal form. Equivalently, a term is
in HNF if there is no beta-redex in **head position** (the position of the leftmost
"applied" function).

The **head redex** of a term is defined as follows: if a term has the form
`lambda x_1 ... x_m. (lambda y. P) Q M_2 ... M_n`, then `(lambda y. P) Q` is
the head redex.

**Head reduction** contracts only head redexes.

### 10.3 Weak Head Normal Form (WHNF)

A term is in **weak head normal form** if it is either:
- A lambda abstraction `lambda x. M` (regardless of whether M contains redexes), or
- A variable applied to zero or more arguments: `x M_1 ... M_n`

WHNF does not reduce under lambda abstractions. It is the evaluation target for
call-by-name and call-by-need strategies.

### 10.4 Relationships

```
Normal Form  subset  Head Normal Form  subset  Weak Head Normal Form
```

Every NF is an HNF; every HNF is a WHNF. The converses do not hold.

### 10.5 Solvability

A closed term M is **solvable** if there exist terms N_1, ..., N_k such that
`M N_1 ... N_k =_beta I` (where I = lambda x. x is the identity).

**Theorem** (Wadsworth): A term is solvable if and only if it has a head normal form.

Unsolvable terms are those that, intuitively, are "completely undefined" -- they
cannot interact meaningfully with any context. The paradigmatic unsolvable term
is Omega = `(lambda x. x x)(lambda x. x x)`.

---

## 11. Fixed-Point Combinators

### 11.1 Definition

A **fixed-point combinator** is a closed term Y such that for all terms F:

```
Y F =_beta F (Y F)
```

That is, `Y F` is a fixed point of F: applying F to it yields (something
beta-equivalent to) itself.

### 11.2 Curry's Y Combinator

The most well-known fixed-point combinator, discovered by Haskell Curry:

```
Y = lambda f. (lambda x. f (x x)) (lambda x. f (x x))
```

**Verification**:

```
Y F  =  (lambda f. (lambda x. f (x x)) (lambda x. f (x x))) F
     ->_beta  (lambda x. F (x x)) (lambda x. F (x x))
     ->_beta  F ((lambda x. F (x x)) (lambda x. F (x x)))
     =  F (Y F)
```

Note: `Y F` does not reduce *to* `F (Y F)` in one step; rather, both `Y F` and
`F (Y F)` reduce to a common reduct. The Y combinator is not a fixed-point
combinator in the stronger sense of `Y F ->>_beta F (Y F)` (one direction only),
though this is often stated informally.

### 11.3 Turing's Fixed-Point Combinator (Theta)

Discovered by Alan Turing, this combinator **does** satisfy `Theta F ->>_beta F (Theta F)`:

```
A = lambda x. lambda y. y (x x y)
Theta = A A = (lambda x. lambda y. y (x x y)) (lambda x. lambda y. y (x x y))
```

**Verification**:

```
Theta F  =  A A F
         ->_beta  (lambda y. y (A A y)) F
         ->_beta  F (A A F)
         =  F (Theta F)
```

### 11.4 Call-by-Value Fixed-Point Combinator (Z)

In a call-by-value setting, the Y combinator diverges because the self-application
`x x` is evaluated eagerly. The **Z combinator** wraps the self-application in an
eta-expansion:

```
Z = lambda f. (lambda x. f (lambda v. x x v)) (lambda x. f (lambda v. x x v))
```

This delays the self-application until an argument is supplied.

### 11.5 The Fixed-Point Theorem

**Theorem**: In the untyped lambda calculus, every term has a fixed point.

*Proof*: Given any term F, define W = lambda x. F (x x). Then:

```
W W  =  (lambda x. F (x x)) W  ->_beta  F (W W)
```

So `W W` is a fixed point of F.

This is not just an existence result -- it is **constructive**. There are in fact
infinitely many distinct fixed-point combinators.

### 11.6 Significance

Fixed-point combinators enable the definition of **recursive functions** in the
lambda calculus, which has no primitive recursion mechanism. To define a recursive
function, one writes a "generator" G that takes the recursive function as a
parameter, and then `Y G` is the desired recursive function.

For example, the factorial function:

```
G = lambda f. lambda n. (iszero n) 1 (mult n (f (pred n)))
fact = Y G
```

This mechanism is directly responsible for the Turing-completeness of the lambda calculus.

---

## 12. Church Encodings

Since the pure lambda calculus has no built-in data types, all data must be encoded
as lambda terms. The standard encodings are called **Church encodings**.

### 12.1 Church Booleans

```
true   = lambda x. lambda y. x
false  = lambda x. lambda y. y
```

A boolean is a function that selects one of two arguments.

**Boolean operations**:

```
and  = lambda p. lambda q. p q p
or   = lambda p. lambda q. p p q
not  = lambda p. lambda x. lambda y. p y x
if   = lambda p. lambda t. lambda f. p t f    (equivalently, just application: p t f)
xor  = lambda p. lambda q. p (q false true) q
```

Note that `if` is essentially the identity on booleans, since `true t f ->_beta t`
and `false t f ->_beta f`.

### 12.2 Church Numerals

The Church numeral **n** represents the natural number n as the n-fold composition
of a function:

```
0 = lambda f. lambda x. x
1 = lambda f. lambda x. f x
2 = lambda f. lambda x. f (f x)
3 = lambda f. lambda x. f (f (f x))
n = lambda f. lambda x. f^n x
```

**Arithmetic operations**:

```
succ  = lambda n. lambda f. lambda x. f (n f x)
plus  = lambda m. lambda n. lambda f. lambda x. m f (n f x)
mult  = lambda m. lambda n. lambda f. m (n f)
      -- equivalently: lambda m. lambda n. lambda f. lambda x. m (n f) x
exp   = lambda m. lambda n. n m
      -- m^n; applies n copies of m
iszero = lambda n. n (lambda x. false) true
```

**Predecessor** (the most intricate basic operation):

```
pred = lambda n. lambda f. lambda x.
         n (lambda g. lambda h. h (g f))
           (lambda u. x)
           (lambda u. u)
```

This uses a pairing trick: it builds up pairs (0,0), (0,1), (1,2), ..., (n-1,n)
and extracts the first component.

**Subtraction** (truncated, or "monus"):

```
minus = lambda m. lambda n. n pred m
```

### 12.3 Church Pairs

```
pair   = lambda a. lambda b. lambda f. f a b
first  = lambda p. p (lambda a. lambda b. a)     -- equivalently: p true
second = lambda p. p (lambda a. lambda b. b)     -- equivalently: p false
```

A pair stores two values and applies a selector function to retrieve one of them.

### 12.4 Church-Encoded Lists

Lists can be encoded as right-folds (like Church numerals generalized):

```
nil   = lambda c. lambda n. n
cons  = lambda h. lambda t. lambda c. lambda n. c h (t c n)
```

Where `c` is the "cons" case handler and `n` is the "nil" case handler.

Alternatively, using pairs:

```
nil    = lambda on_cons. lambda on_nil. on_nil
cons   = lambda h. lambda t. lambda on_cons. lambda on_nil. on_cons h t
head   = lambda l. l (lambda h. lambda t. h) error
tail   = lambda l. l (lambda h. lambda t. t) error
isnil  = lambda l. l (lambda h. lambda t. false) true
```

### 12.5 Encoding Completeness

The Church-Turing thesis can be demonstrated through lambda encodings: any
computable function on natural numbers can be represented as a lambda term
operating on Church numerals.

---

## 13. Lambda-Definability and Representability

### 13.1 Definition

A partial function f : N^k -> N is **lambda-definable** if there exists a closed
lambda term **F** such that for all m_1, ..., m_k, n in N:

```
f(m_1, ..., m_k) = n  implies  F [m_1] ... [m_k] =_beta [n]
```

where [n] denotes the Church numeral for n, and if f(m_1, ..., m_k) is undefined,
then `F [m_1] ... [m_k]` has no normal form.

### 13.2 Kleene's Theorem (1936)

**Theorem** (Kleene, 1936): A partial function f : N^k -> N is lambda-definable
if and only if it is partial recursive (equivalently, Turing-computable).

This is one of the key results establishing the Church-Turing thesis. The proof
proceeds by:

1. Showing that all primitive recursive functions are lambda-definable (by encoding
   the initial functions and showing closure under composition, primitive recursion).

2. Showing that the minimization (mu) operator is lambda-definable using fixed-point
   combinators.

3. Conversely, showing that beta-reduction can be simulated by recursive functions.

---

## 14. The Scott-Curry Theorem

### 14.1 Statement

**Theorem** (Scott, 1963; Curry, 1969): Let A and B be non-empty sets of lambda
terms, each closed under beta-convertibility (i.e., if M is in A and M =_beta N,
then N is in A; similarly for B). If A and B are disjoint, then they are
**recursively inseparable**: there is no recursive (decidable) set S such that
A is a subset of S and B is disjoint from S.

### 14.2 Consequences

**Corollary**: It is undecidable whether two lambda terms are beta-equivalent.

**Corollary**: Any non-trivial property of lambda terms that is preserved under
beta-equivalence is undecidable. (This is the lambda-calculus analogue of Rice's
theorem for Turing machines.)

### 14.3 Reference

- Scott, D.S. (1975). "Lambda calculus: Some models, some philosophy."
  In *The Kleene Symposium*, North-Holland, 223--265.
- Curry, H.B. (1969). "The undecidability of lambda-K-conversion."
  *Journal of Symbolic Logic* 34, 594--597.

---

## 15. Bohm's Theorem

### 15.1 Statement

**Theorem** (Bohm, 1968): If M and N are distinct closed beta-eta-normal forms,
then they are **separable**: there exist terms P_1, ..., P_k such that

```
M P_1 ... P_k =_beta true
N P_1 ... P_k =_beta false
```

(where `true` and `false` can be any two chosen distinct normal forms).

### 15.2 Interpretation

Bohm's theorem says that the lambda calculus can internally distinguish any two
closed terms that are not beta-eta-equivalent. In other words, beta-eta-equivalence
is the **maximum consistent equational theory** of the lambda calculus that identifies
terms only when they are observationally indistinguishable.

Equivalently: if we add any equation M = N between distinct beta-eta-normal forms
to the theory, the theory becomes inconsistent (all terms become equal).

### 15.3 Bohm Trees

A **Bohm tree** BT(M) is an infinitary normal form that captures the computational
content of a term M:

- If M is unsolvable, BT(M) = "bottom" (undefined).
- If M has a head normal form `lambda x_1 ... x_m. y M_1 ... M_n`,
  then BT(M) has root labeled `lambda x_1 ... x_m. y` with children
  BT(M_1), ..., BT(M_n).

Bohm trees provide a canonical representation of the "observable behavior" of
lambda terms, forming the basis of the theory of **sensible** lambda models.

### 15.4 Reference

- Bohm, C. (1968). "Alcune proprieta delle forme beta-eta-normali nel
  lambda-K-calcolo." Pubblicazioni dell'Istituto per le Applicazioni del
  Calcolo 696.
- Huet, G. "An Analysis of Bohm's Theorem." Available at:
  http://gallium.inria.fr/~huet/PUBLIC/Bohm.pdf

---

## 16. Denotational Semantics: Scott Domains and the D-infinity Model

### 16.1 The Problem

A model of the untyped lambda calculus requires a mathematical structure D with
a function `eval : D -> (D -> D)` and `apply : (D -> D) -> D` forming a
retraction. Naively, D must be isomorphic to its own function space D -> D.
For cardinality reasons, this is impossible in naive set theory when D has
more than one element (|D^D| > |D| by Cantor's theorem).

### 16.2 Scott's Insight (1969)

Dana Scott's breakthrough was to restrict attention to **continuous functions**
rather than all functions. Working with a suitable topological structure
(continuous lattices / domains), the space of continuous functions [D -> D]
can have the same cardinality and structure as D.

### 16.3 Key Definitions

**Complete Partial Order (CPO)**: A partially ordered set (D, <=) with:
- A least element (bottom, written _|_), representing "undefined"
- Suprema (least upper bounds) of all directed subsets

**Continuous Function**: A function f : D -> E between CPOs is continuous if
it is monotone (x <= y implies f(x) <= f(y)) and preserves directed suprema
(f(sup S) = sup f(S) for all directed S).

**Scott Topology**: On a CPO D, the open sets are those that are:
- Upward closed: if x is in U and x <= y, then y is in U
- Inaccessible by directed suprema: if sup S is in U, then some element of S
  is in U

**Scott Domain**: An algebraic CPO with a countable basis of compact
(finite) elements.

### 16.4 The D-infinity Construction

Starting from any Scott domain D_0 (e.g., a one-point domain or a flat domain),
define:

```
D_{n+1} = [D_n -> D_n]    (continuous function space)
```

with embedding-projection pairs (e_n, p_n) where:

```
e_n : D_n -> D_{n+1}     (embedding: injective, continuous)
p_n : D_{n+1} -> D_n     (projection: surjective, continuous)
p_n . e_n = id
```

The **inverse limit**:

```
D_infinity = { (d_0, d_1, d_2, ...) | d_i in D_i and p_i(d_{i+1}) = d_i for all i }
```

**Theorem** (Scott, 1969): D_infinity is isomorphic to [D_infinity -> D_infinity].

This provides a mathematical model of the untyped lambda calculus where:
- Lambda terms denote elements of D_infinity
- Application corresponds to function application in D_infinity
- Abstraction corresponds to the continuous function determined by the body
- Self-application (M M) is well-defined because elements of D_infinity
  are simultaneously "values" and "functions"

### 16.5 Other Models

| Model | Reference | Description |
|---|---|---|
| D_infinity | Scott 1969 | Inverse-limit construction |
| P(omega) | Scott 1976 | Graph model based on subsets of natural numbers |
| B(A) | Engeler 1981 | Graph model / Engeler algebra |
| Filter models | Coppo, Dezani et al. | Based on intersection types |
| Categorical models | Various | Abstract characterization via cartesian closed categories |

### 16.6 Adequacy and Full Abstraction

A denotational semantics is:
- **Adequate** if denotational equality implies observational equivalence.
- **Fully abstract** if denotational equality coincides with observational equivalence.

Scott's D_infinity model is adequate but not fully abstract for the lambda calculus.
The search for fully abstract models motivated significant further research.

---

## 17. Connections to Combinatory Logic

### 17.1 SKI Combinators

**Combinatory logic**, developed by Moses Schonfinkel (1924) and Haskell Curry
(1930), is an equivalent formalism that eliminates bound variables entirely.
The three basic combinators are:

```
I = lambda x. x                     (identity)
K = lambda x. lambda y. x           (constant / first projection)
S = lambda x. lambda y. lambda z. x z (y z)   (distribution / substitution)
```

Their reduction rules:

```
I x      -> x
K x y    -> x
S x y z  -> x z (y z)
```

**Theorem**: S and K form a **complete basis** -- I is derivable as S K K, and
every lambda term can be translated into an equivalent combinator expression
using only S and K.

### 17.2 Abstraction Elimination (Bracket Abstraction)

The translation from lambda calculus to combinatory logic proceeds by
**bracket abstraction** [x] M, which eliminates the abstraction `lambda x. M`:

```
[x] x       = I
[x] M       = K M          (if x not free in M)
[x] (M N)   = S ([x] M) ([x] N)
```

This is a recursive algorithm that transforms any lambda term into an
equivalent SK-combinator expression.

**Example**: `lambda x. lambda y. x y`
- [y](x y) = S ([y] x) ([y] y) = S (K x) I
- [x](S (K x) I) = S ([x](S (K x))) ([x] I) = S (S ([x] S) ([x](K x))) (K I)
  = S (S (K S) ([x](K x))) (K I) = S (S (K S) (S ([x] K) ([x] x))) (K I)
  = S (S (K S) (S (K K) I)) (K I)

In practice, optimized translation algorithms reduce the size of the output.

### 17.3 Historical Note

Schonfinkel's work (1924) and Curry's work (1930) both predate Church's lambda
calculus (1932). Combinatory logic was developed as a way to eliminate variables
from logic, independently of (and prior to) the lambda calculus. The equivalence
between the two systems was recognized early on and formalized precisely.

### 17.4 Advantages and Disadvantages

| | Lambda Calculus | Combinatory Logic |
|---|---|---|
| **Pros** | More readable; direct variable binding | No variables; no substitution/capture issues |
| **Cons** | Alpha-equivalence; capture-avoiding substitution | Combinatorial explosion of term size; less readable |

---

## 18. Key References

### Primary Sources

1. Church, A. (1932). "A Set of Postulates for the Foundation of Logic."
   *Annals of Mathematics* 33, 346--366.

2. Church, A. (1933). "A Set of Postulates for the Foundation of Logic (Second Paper)."
   *Annals of Mathematics* 34, 839--864.

3. Kleene, S.C. and Rosser, J.B. (1935). "The Inconsistency of Certain Formal Logics."
   *Annals of Mathematics* 36(3), 630--636.

4. Church, A. (1936). "An Unsolvable Problem of Elementary Number Theory."
   *American Journal of Mathematics* 58, 345--363.

5. Church, A. and Rosser, J.B. (1936). "Some Properties of Conversion."
   *Transactions of the AMS* 39(3), 472--482.

6. Turing, A.M. (1936). "On Computable Numbers, with an Application to the
   Entscheidungsproblem." *Proceedings of the London Mathematical Society* 42, 230--265.

7. Kleene, S.C. (1936). "Lambda-Definability and Recursiveness."
   *Duke Mathematical Journal* 2, 340--353.

8. Church, A. (1940). "A Formulation of the Simple Theory of Types."
   *Journal of Symbolic Logic* 5, 56--68.

9. Curry, H.B. and Feys, R. (1958). *Combinatory Logic, Volume I*.
   North-Holland.

10. Bohm, C. (1968). "Alcune proprieta delle forme beta-eta-normali nel
    lambda-K-calcolo." Pubblicazioni dell'Istituto per le Applicazioni del
    Calcolo 696.

### Monographs and Textbooks

11. Barendregt, H.P. (1984). *The Lambda Calculus: Its Syntax and Semantics*.
    Revised edition. Studies in Logic, Vol. 103. North-Holland/Elsevier.
    ISBN: 0-444-87508-5. [The definitive reference on the untyped lambda calculus.]

12. Hindley, J.R. and Seldin, J.P. (2008). *Lambda-Calculus and Combinators:
    An Introduction*. 2nd edition. Cambridge University Press.

13. Sorensen, M.H. and Urzyczyn, P. (2006). *Lectures on the Curry-Howard
    Isomorphism*. Studies in Logic, Vol. 149. Elsevier.

### Domain Theory and Semantics

14. Scott, D.S. (1970). "Outline of a Mathematical Theory of Computation."
    4th Annual Princeton Conference on Information Sciences and Systems, 169--176.

15. Scott, D.S. (1972). "Continuous Lattices." In *Toposes, Algebraic Geometry
    and Logic*, Lecture Notes in Mathematics, Vol. 274, Springer, 97--136.

16. Scott, D.S. (1976). "Data Types as Lattices." *SIAM Journal on Computing*
    5(3), 522--587.

### Survey Articles

17. Cardone, F. and Hindley, J.R. (2006). "History of Lambda-Calculus and
    Combinatory Logic." In *Handbook of the History of Logic*, Vol. 5, Elsevier.

18. Selinger, P. (2008). "Lecture Notes on the Lambda Calculus."
    arXiv:0804.3434.

### Online Resources

19. Stanford Encyclopedia of Philosophy: "Alonzo Church."
    https://plato.stanford.edu/entries/church/

20. Internet Encyclopedia of Philosophy: "Lambda Calculi."
    https://iep.utm.edu/lambda-calculi/

21. Programming Language Foundations in Agda (PLFA): "Confluence" and
    "Denotational Semantics" chapters.
    https://plfa.inf.ed.ac.uk/

---

## Cross-References

- **Doc 02 (Simply Typed Lambda Calculus):** Church introduced the STLC (1940) to
  restore consistency after the Kleene-Rosser paradox. The STLC adds a type discipline
  that guarantees termination (strong normalization) at the cost of Turing-completeness.

- **Doc 09 (Implementation / Abstract Machines):** Abstract machines such as the
  SECD machine, Krivine machine, and CEK machine provide concrete implementation
  strategies for the reduction strategies described in Section 7. These machines
  formalize environment-based evaluation, avoiding the overhead of capture-avoiding
  substitution.
