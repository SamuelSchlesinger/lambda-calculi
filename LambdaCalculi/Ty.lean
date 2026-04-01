import LambdaCalculi.Kind

namespace LambdaCalculi

/-- Types in a lambda square system, parameterized by `p` and `q`:
    - `p` gates polymorphism (∀ types)
    - `q` gates type operators (type-level λ and application)
    - `p ⊕ q` gates type variables (needed by both axes)

    Instantiations:
    - `p = Empty, q = Empty`: STLC (λ→)
    - `p = Unit, q = Empty`: System F (λ2)
    - `p = Empty, q = Unit`: type operators without polymorphism (λω_)
    - `p = Unit, q = Unit`: System F-omega (λω) -/
inductive Ty (p : Type) (q : Type) where
  /-- Base type, identified by index -/
  | base : Nat → Ty p q
  /-- Arrow (function) type -/
  | arr : Ty p q → Ty p q → Ty p q
  /-- Type variable (de Bruijn index), gated by `p ⊕ q` -/
  | tvar : (p ⊕ q) → Nat → Ty p q
  /-- Universal quantification (∀α:k. τ), binds type variable 0 in body, gated by `p` -/
  | all : p → Kind → Ty p q → Ty p q
  /-- Type-level lambda (λα:k. τ), binds type variable 0 in body, gated by `q` -/
  | tyLam : q → Kind → Ty p q → Ty p q
  /-- Type-level application (τ₁ τ₂), gated by `q` -/
  | tyAppTy : q → Ty p q → Ty p q → Ty p q
  /-- Natural number type -/
  | nat : Ty p q
  deriving DecidableEq, Repr

end LambdaCalculi
