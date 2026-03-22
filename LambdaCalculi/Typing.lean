import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst

namespace LambdaCalculi

/-- A typing context is a list of types. De Bruijn index `n` has the type at
    position `n` (0 = head = most recently bound variable). -/
abbrev Context (p : Type) := List (Ty p)

/-- The typing judgment `Γ ⊢ t : τ`.

    For STLC (`p = Empty`), only `var`, `lam`, `app` rules are usable.
    For System F (`p` inhabited), `tyAbs` and `tyApp` become available. -/
inductive HasType : Context p → Term p → Ty p → Prop where
  /-- Variable: look up in context -/
  | var :
    ctx[n]? = some ty →
    HasType ctx (.var n) ty
  /-- Lambda abstraction -/
  | lam :
    HasType (argTy :: ctx) body retTy →
    HasType ctx (.lam argTy body) (.arr argTy retTy)
  /-- Application -/
  | app :
    HasType ctx fn (.arr argTy retTy) →
    HasType ctx arg argTy →
    HasType ctx (.app fn arg) retTy
  /-- Type abstraction (System F): Λ. t has type ∀. τ.
      The context is shifted because a new type variable is introduced. -/
  | tyAbs :
    (hp : p) →
    HasType (ctx.map (Ty.shift 1 0)) body ty →
    HasType ctx (.tyAbs hp body) (.all hp ty)
  /-- Type application (System F): t [σ] has type τ[0 := σ].
      Instantiates the bound type variable with the given type argument. -/
  | tyApp :
    (hp : p) →
    HasType ctx t (.all hp bodyTy) →
    HasType ctx (.tyApp hp t argTy) (Ty.subst 0 argTy bodyTy)

end LambdaCalculi
