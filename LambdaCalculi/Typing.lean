import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst
import LambdaCalculi.Kinding
import LambdaCalculi.TyReduction

namespace LambdaCalculi

/-- A typing context is a list of types. De Bruijn index `n` has the type at
    position `n` (0 = head = most recently bound variable). -/
abbrev Context (p : Type) (q : Type) := List (Ty p q)

/-- The typing judgment `Δ; Γ ⊢ t : τ`.

    `Δ` is the kinding context (maps type variable indices to kinds).
    `Γ` is the typing context (maps term variable indices to types).

    For STLC (`p = Empty, q = Empty`), only `var`, `lam`, `app` rules are usable,
    and `Δ` is always `[]`.
    For System F (`p` inhabited, `q = Empty`), `tyAbs` and `tyApp` become available.
    For System F-omega (`p, q` inhabited), the `conv` rule becomes essential. -/
inductive HasType {p : Type} {q : Type} : KindContext → Context p q → Term p q → Ty p q → Prop where
  /-- Variable: look up in context; the type must be well-kinded -/
  | var :
    ctx[n]? = some ty →
    HasKind Δ ty .star →
    HasType Δ ctx (.var n) ty
  /-- Lambda abstraction: the argument type must be well-kinded -/
  | lam :
    HasKind Δ argTy .star →
    HasType Δ (argTy :: ctx) body retTy →
    HasType Δ ctx (.lam argTy body) (.arr argTy retTy)
  /-- Application -/
  | app :
    HasType Δ ctx fn (.arr argTy retTy) →
    HasType Δ ctx arg argTy →
    HasType Δ ctx (.app fn arg) retTy
  /-- Type abstraction (System F / F-omega): Λα:k. t has type ∀α:k. τ.
      The context is shifted because a new type variable is introduced. -/
  | tyAbs :
    (hp : p) →
    HasType (k :: Δ) (ctx.map (Ty.shift 1 0)) body ty →
    HasType Δ ctx (.tyAbs hp k body) (.all hp k ty)
  /-- Type application (System F / F-omega): t [σ] has type τ[0 := σ].
      The type argument must have the correct kind. -/
  | tyApp :
    (hp : p) →
    HasType Δ ctx t (.all hp k bodyTy) →
    HasKind Δ argTy k →
    HasType Δ ctx (.tyApp hp t argTy) (Ty.subst 0 argTy bodyTy)
  /-- Type conversion: if t has type τ and τ ≡ τ', then t has type τ'.
      The target type must be well-kinded.
      Essential for System F-omega where types can compute. -/
  | conv :
    HasType Δ ctx t ty →
    TyEquiv ty ty' →
    HasKind Δ ty' .star →
    HasType Δ ctx t ty'

/-- Every type assigned by HasType is well-kinded at kind ★.
    This follows from the kinding premises on `var`, `lam`, and `conv`. -/
theorem HasType.well_kinded (ht : HasType Δ ctx t ty) : HasKind Δ ty .star := by
  induction ht with
  | var _ hk => exact hk
  | lam hk _ ih => exact .arr hk ih
  | app _ _ ihfn _ =>
    -- ihfn : HasKind Δ (.arr argTy retTy) .star
    match ihfn with
    | .arr _ hret => exact hret
  | tyAbs _ _ ih => exact .all ih
  | tyApp _ _ hk ih =>
    -- ih : HasKind Δ (.all hp k bodyTy) .star
    match ih with
    | .all hbody => exact hbody.subst_preserves hk
  | conv _ _ hk => exact hk

end LambdaCalculi
