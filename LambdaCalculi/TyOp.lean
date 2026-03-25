import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst
import LambdaCalculi.Typing
import LambdaCalculi.Kinding

/-! ## Type Operators without Polymorphism (λω_)

Type aliases and examples for the lambda square system with
`p = Empty, q = Unit` — type-level lambdas and application are available,
but there is no polymorphism (no ∀, no Λ at the term level).

This is sometimes called λω_ (lambda-omega-underbar) in the lambda cube. -/

namespace LambdaCalculi.TyOp

-- Type aliases: p = Empty (no polymorphism), q = Unit (type operators enabled)
abbrev Ty := LambdaCalculi.Ty Empty Unit
abbrev Term := LambdaCalculi.Term Empty Unit
abbrev Context := LambdaCalculi.Context Empty Unit

-- ============================================================
-- Type helpers
-- ============================================================

/-- Type variable (de Bruijn index) — available via q = Unit -/
def tvar (n : Nat) : Ty := .tvar (.inr ()) n

/-- Type-level lambda: λα:k. τ -/
def tyLam (k : Kind) (body : Ty) : Ty := .tyLam () k body

/-- Type-level application: τ₁ τ₂ -/
def tyApp (f arg : Ty) : Ty := .tyAppTy () f arg

-- ============================================================
-- Example type operators
-- ============================================================

/-- The identity type operator: λα:★. α -/
def IdOp : Ty := tyLam .star (tvar 0)

/-- The constant type operator: λα:★. λβ:★. α -/
def ConstOp : Ty := tyLam .star (tyLam .star (tvar 1))

/-- Pair type constructor (as a type operator): λα:★. λβ:★. α → β → α
    (simplified — a real encoding would use ∀, but we don't have it here) -/
def SimplePair : Ty := tyLam .star (tyLam .star (.arr (tvar 1) (.arr (tvar 0) (tvar 1))))

-- ============================================================
-- Kinding derivations
-- ============================================================

/-- The identity type operator has kind ★ ⇒ ★ -/
example : HasKind [] IdOp (.arr .star .star) :=
  .tyLam (.tvar (by decide))

/-- The constant type operator has kind ★ ⇒ ★ ⇒ ★ -/
example : HasKind [] ConstOp (.arr .star (.arr .star .star)) :=
  .tyLam (.tyLam (.tvar (by decide)))

/-- Applying IdOp to a base type gives kind ★ -/
example : HasKind [] (tyApp IdOp (.base 0)) .star :=
  .tyAppTy (.tyLam (.tvar (by decide))) .base

end LambdaCalculi.TyOp
