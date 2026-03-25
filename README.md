# lambda-calculi

A Lean 4 formalization of a **lambda square**: four type systems (STLC, System F, type operators, System F-omega) with complete type safety proofs, unified by a parametric encoding.

## Key idea

Types and terms are parameterized by two types `p` and `q` that gate constructors via inhabitation:

- `p` gates **polymorphism** (universal types, type abstraction/application at the term level)
- `q` gates **type operators** (type-level lambdas and application)
- `p ⊕ q` gates **type variables** (needed by both axes)

This gives a lambda square with four vertices:

```
         p (polymorphism)
         |
  Sys F  |  Sys F-omega
  (1,0)  |  (1,1)
  -------+-------> q (type operators)
  STLC   |  lambda-omega_
  (0,0)  |  (0,1)
```

| (p, q)             | System             | Features                                      |
|---------------------|--------------------|-----------------------------------------------|
| `(Empty, Empty)`    | STLC               | Base types, arrow types                       |
| `(Unit, Empty)`     | System F           | + type variables, universal types, term-level type abstraction/application |
| `(Empty, Unit)`     | Type operators (lambda-omega_) | + type variables, type-level lambdas, type-level application |
| `(Unit, Unit)`      | System F-omega     | All of the above                              |

A single set of definitions and proofs covers all four systems.

## Metatheory

There is one proof of progress and one proof of preservation — and each proof works for all four systems at once. The theorems are universally quantified over `p` and `q`:

```lean
theorem progress {t : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (hclosed : ctx = []) :
    Value t ∨ ∃ t', Step t t'

theorem preservation {Δ : KindContext} {ctx : Context p q}
    {t t' : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (hs : Step t t') :
    HasType Δ ctx t' ty
```

Instantiate `p` and `q` and you get type safety for whichever system you want — no case splits on which vertex of the square you're in. The gating mechanism makes inapplicable constructors vacuously true: when `p = Empty`, polymorphic cases can never arise; when `q = Empty`, type-level reduction is empty and the conversion rule degenerates to identity.

Also proved generically:

- **Church-Rosser**: type-level beta reduction is confluent (via Tait-Martin-Lof parallel reduction)
- **Well-kindedness**: every type assigned by the typing judgment has kind `*`

No `sorry`, `axiom`, or escape hatches anywhere. No external dependencies (no Mathlib).

## File structure

### Core definitions
| File | Contents |
|------|----------|
| `Kind.lean` | Kind type (`*`, `K1 => K2`) |
| `Ty.lean` | Type syntax with parametric gating |
| `Term.lean` | Term syntax with parametric gating |
| `Subst.lean` | De Bruijn shifting and substitution for types and terms |

### Type-level metatheory
| File | Contents |
|------|----------|
| `TySubstLemmas.lean` | Commutation lemmas for type shifting/substitution |
| `TyReduction.lean` | Type-level beta reduction, multi-step reduction, type equivalence, head preservation |
| `TyConfluence.lean` | Parallel reduction, complete developments, Church-Rosser theorem |

### Kinding and typing
| File | Contents |
|------|----------|
| `Kinding.lean` | Kinding judgment with weakening, substitution, and reduction preservation |
| `Typing.lean` | Typing judgment with conversion rule, well-kindedness theorem |

### Term-level metatheory
| File | Contents |
|------|----------|
| `Reduction.lean` | Values and small-step call-by-value semantics |
| `Weakening.lean` | Weakening lemma |
| `Progress.lean` | Progress theorem with canonical forms (handling type conversion) |
| `Preservation.lean` | Generation lemmas, substitution lemma, type substitution, preservation theorem |

### System instantiations
| File | Contents |
|------|----------|
| `STLC.lean` | Simply typed lambda calculus (`p = Empty, q = Empty`) |
| `SystemF.lean` | System F (`p = Unit, q = Empty`) |
| `TyOp.lean` | Type operators without polymorphism (`p = Empty, q = Unit`) |
| `SystemFOmega.lean` | System F-omega (`p = Unit, q = Unit`) |

## Building

Requires [Lean 4](https://lean-lang.org/) (v4.28.0). No external dependencies (no Mathlib).

```
lake build
```
