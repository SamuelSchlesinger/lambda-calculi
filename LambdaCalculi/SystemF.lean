import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst
import LambdaCalculi.Typing
import LambdaCalculi.Reduction

/-! ## System F (Polymorphic Lambda Calculus)

Type aliases and examples for System F, which is the lambda cube system
with `p = Unit` (polymorphism enabled: type variables, ∀ types,
type abstraction Λ, and type application). -/

namespace LambdaCalculi.SystemF

-- Type aliases: p = Unit enables all constructors
abbrev Ty := LambdaCalculi.Ty Unit
abbrev Term := LambdaCalculi.Term Unit
abbrev Context := LambdaCalculi.Context Unit

-- ============================================================
-- Type and term helpers
-- ============================================================

/-- Type variable (de Bruijn index) -/
def tvar (n : Nat) : Ty := .tvar () n

/-- Universal type: ∀. τ (binds type var 0 in τ) -/
def all (body : Ty) : Ty := .all () body

/-- Type abstraction: Λ. t (binds type var 0 in t) -/
def tyAbs (body : Term) : Term := .tyAbs () body

/-- Type application: t [τ] -/
def tyApp (t : Term) (ty : Ty) : Term := .tyApp () t ty

-- ============================================================
-- Standard System F types
-- ============================================================

/-- ∀α. α → α (type of the polymorphic identity) -/
def IdTy : Ty := all (.arr (tvar 0) (tvar 0))

/-- ∀α. ∀β. α → β → α (type of the polymorphic constant function) -/
def ConstTy : Ty := all (all (.arr (tvar 1) (.arr (tvar 0) (tvar 1))))

/-- Church booleans: ∀α. α → α → α -/
def BoolTy : Ty := all (.arr (tvar 0) (.arr (tvar 0) (tvar 0)))

/-- Church naturals: ∀α. (α → α) → α → α -/
def NatTy : Ty := all (.arr (.arr (tvar 0) (tvar 0)) (.arr (tvar 0) (tvar 0)))

-- ============================================================
-- Standard System F terms
-- ============================================================

/-- Polymorphic identity: Λα. λ(x:α). x -/
def id_ : Term := tyAbs (.lam (tvar 0) (.var 0))

/-- Polymorphic constant: Λα. Λβ. λ(x:α). λ(y:β). x -/
def const_ : Term := tyAbs (tyAbs (.lam (tvar 1) (.lam (tvar 0) (.var 1))))

/-- Church true: Λα. λ(x:α). λ(y:α). x -/
def true_ : Term := tyAbs (.lam (tvar 0) (.lam (tvar 0) (.var 1)))

/-- Church false: Λα. λ(x:α). λ(y:α). y -/
def false_ : Term := tyAbs (.lam (tvar 0) (.lam (tvar 0) (.var 0)))

/-- Church zero: Λα. λ(f:α→α). λ(x:α). x -/
def zero_ : Term := tyAbs (.lam (.arr (tvar 0) (tvar 0)) (.lam (tvar 0) (.var 0)))

/-- Church successor: λ(n:Nat). Λα. λ(f:α→α). λ(x:α). f (n [α] f x) -/
def succ_ : Term :=
  .lam NatTy
    (tyAbs
      (.lam (.arr (tvar 0) (tvar 0))
        (.lam (tvar 0)
          (.app (.var 1)
            (.app (.app (tyApp (.var 3) (tvar 0)) (.var 1)) (.var 0))))))

-- ============================================================
-- Typing derivations
-- ============================================================

/-- The polymorphic identity has type ∀α. α → α -/
example : HasType [] id_ IdTy :=
  .tyAbs () (.lam (.var (by decide)))

/-- Church true has type ∀α. α → α → α (= BoolTy) -/
example : HasType [] true_ BoolTy :=
  .tyAbs () (.lam (.lam (.var (by decide))))

/-- Church false has type BoolTy -/
example : HasType [] false_ BoolTy :=
  .tyAbs () (.lam (.lam (.var (by decide))))

/-- Church zero has type NatTy -/
example : HasType [] zero_ NatTy :=
  .tyAbs () (.lam (.lam (.var (by decide))))

-- ============================================================
-- Type application examples
-- ============================================================

/-- Instantiating the identity at BoolTy -/
example : HasType [] (tyApp id_ BoolTy)
              (Ty.subst 0 BoolTy (.arr (tvar 0) (tvar 0))) :=
  .tyApp () (.tyAbs () (.lam (.var (by decide))))

-- ============================================================
-- Reduction examples
-- ============================================================

/-- Type beta: (Λα. λ(x:α). x) [BoolTy] ⟶ λ(x:BoolTy). x -/
example : Step (tyApp id_ BoolTy)
              (Term.tySubst 0 BoolTy (.lam (tvar 0) (.var 0))) :=
  .tyBeta

end LambdaCalculi.SystemF
