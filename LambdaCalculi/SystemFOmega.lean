import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst
import LambdaCalculi.Typing
import LambdaCalculi.Reduction
import LambdaCalculi.Kinding
import LambdaCalculi.TyReduction

/-! ## System F-omega (λω)

Type aliases and examples for System F-omega, which is the lambda square system
with `p = Unit, q = Unit` — both polymorphism and type operators are enabled. -/

namespace LambdaCalculi.SystemFOmega

abbrev Ty := LambdaCalculi.Ty Unit Unit
abbrev Term := LambdaCalculi.Term Unit Unit
abbrev Context := LambdaCalculi.Context Unit Unit

def tvar (n : Nat) : Ty := .tvar (.inl ()) n
def all (k : Kind) (body : Ty) : Ty := .all () k body
def tyLam (k : Kind) (body : Ty) : Ty := .tyLam () k body
def tyAppTy (f arg : Ty) : Ty := .tyAppTy () f arg
def tyAbs (k : Kind) (body : Term) : Term := .tyAbs () k body
def tyApp (t : Term) (ty : Ty) : Term := .tyApp () t ty

-- ============================================================
-- Type operators
-- ============================================================

def IdOp : Ty := tyLam .star (tvar 0)
def ConstOp : Ty := tyLam .star (tyLam .star (tvar 1))

def Compose : Ty :=
  tyLam (.arr .star .star) (tyLam (.arr .star .star) (tyLam .star
    (tyAppTy (tvar 2) (tyAppTy (tvar 1) (tvar 0)))))

-- ============================================================
-- Types using type operators
-- ============================================================

def PolyIdTy : Ty := all .star (.arr (tvar 0) (tvar 0))

def HigherKindedId : Ty :=
  all (.arr .star .star) (all .star
    (.arr (tyAppTy (tvar 1) (tvar 0)) (tyAppTy (tvar 1) (tvar 0))))

-- ============================================================
-- Kinding derivations
-- ============================================================

example : HasKind [] IdOp (.arr .star .star) :=
  .tyLam (.tvar (by decide))

example : HasKind [] ConstOp (.arr .star (.arr .star .star)) :=
  .tyLam (.tyLam (.tvar (by decide)))

example : HasKind [] Compose (.arr (.arr .star .star) (.arr (.arr .star .star) (.arr .star .star))) :=
  .tyLam (.tyLam (.tyLam
    (.tyAppTy (k₁ := .star) (.tvar (by decide))
      (.tyAppTy (k₁ := .star) (.tvar (by decide))
        (.tvar (by decide))))))

-- ============================================================
-- Terms and typing
-- ============================================================

def polyId : Term := tyAbs .star (.lam (tvar 0) (.var 0))

example : HasType [] [] polyId PolyIdTy :=
  .tyAbs () (.lam (.tvar (by decide)) (.var (by decide) (.tvar (by decide))))

def hkId : Term :=
  tyAbs (.arr .star .star) (tyAbs .star (.lam (tyAppTy (tvar 1) (tvar 0)) (.var 0)))

example : HasType [] [] hkId HigherKindedId :=
  .tyAbs () (.tyAbs ()
    (.lam (.tyAppTy (k₁ := .star) (.tvar (by decide)) (.tvar (by decide)))
      (.var (by decide) (.tyAppTy (k₁ := .star) (.tvar (by decide)) (.tvar (by decide))))))

-- ============================================================
-- Type-level reduction
-- ============================================================

example : TyStep (tyAppTy IdOp (.base 0)) (Ty.subst 0 (.base 0) (tvar 0)) :=
  .beta

example : Ty.subst 0 (.base 0) (tvar 0 : Ty) = .base 0 := by
  simp [tvar, Ty.subst]

end LambdaCalculi.SystemFOmega
