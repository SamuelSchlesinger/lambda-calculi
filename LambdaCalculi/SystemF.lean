import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst
import LambdaCalculi.Typing
import LambdaCalculi.Reduction
import LambdaCalculi.Kinding

/-! ## System F (Polymorphic Lambda Calculus)

Type aliases and examples for System F, which is the lambda square system
with `p = Unit, q = Empty` (polymorphism enabled, no type operators). -/

namespace LambdaCalculi.SystemF

def bmap : Nat → Type := fun _ => Empty
abbrev Ty := LambdaCalculi.Ty Unit Empty
abbrev Term := LambdaCalculi.Term bmap Unit Empty
abbrev Context := LambdaCalculi.Context Unit Empty

def tvar (n : Nat) : Ty := .tvar (.inl ()) n
def all (body : Ty) : Ty := .all () .star body
def tyAbs (body : Term) : Term := .tyAbs () .star body
def tyApp (t : Term) (ty : Ty) : Term := .tyApp () t ty

-- ============================================================
-- Standard System F types
-- ============================================================

def IdTy : Ty := all (.arr (tvar 0) (tvar 0))
def BoolTy : Ty := all (.arr (tvar 0) (.arr (tvar 0) (tvar 0)))
def NatTy : Ty := all (.arr (.arr (tvar 0) (tvar 0)) (.arr (tvar 0) (tvar 0)))

-- ============================================================
-- Standard System F terms
-- ============================================================

def id_ : Term := tyAbs (.lam (tvar 0) (.var 0))
def true_ : Term := tyAbs (.lam (tvar 0) (.lam (tvar 0) (.var 1)))
def false_ : Term := tyAbs (.lam (tvar 0) (.lam (tvar 0) (.var 0)))
def zero_ : Term := tyAbs (.lam (.arr (tvar 0) (tvar 0)) (.lam (tvar 0) (.var 0)))

-- ============================================================
-- Kinding helper for type variables
-- ============================================================

private def tvar_kind (n : Nat) (Δ : KindContext) (h : Δ[n]? = some .star) :
    HasKind Δ (tvar n) .star := .tvar h

-- ============================================================
-- Typing derivations
-- ============================================================

example : HasType bmap [] [] id_ IdTy :=
  .tyAbs () (.lam (.tvar (by decide)) (.var (by decide) (.tvar (by decide))))

example : HasType bmap [] [] true_ BoolTy :=
  .tyAbs () (.lam (.tvar (by decide))
    (.lam (.tvar (by decide)) (.var (by decide) (.tvar (by decide)))))

example : HasType bmap [] [] false_ BoolTy :=
  .tyAbs () (.lam (.tvar (by decide))
    (.lam (.tvar (by decide)) (.var (by decide) (.tvar (by decide)))))

example : HasType bmap [] [] zero_ NatTy :=
  .tyAbs () (.lam (.arr (.tvar (by decide)) (.tvar (by decide)))
    (.lam (.tvar (by decide)) (.var (by decide) (.tvar (by decide)))))

-- ============================================================
-- Reduction examples
-- ============================================================

example : Step (tyApp id_ (.base 0))
              (Term.tySubst 0 (.base 0) (.lam (tvar 0) (.var 0))) :=
  .tyBeta

end LambdaCalculi.SystemF
