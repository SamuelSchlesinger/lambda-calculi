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
inductive HasType {p : Type} {q : Type} : (bmap : Nat → Type) → KindContext → Context p q → Term bmap p q → Ty p q → Prop where
  /-- Variable: look up in context; the type must be well-kinded -/
  | var :
    ctx[n]? = some ty →
    HasKind Δ ty .star →
    HasType bmap Δ ctx (.var n) ty
  /-- Lambda abstraction: the argument type must be well-kinded -/
  | lam :
    HasKind Δ argTy .star →
    HasType bmap Δ (argTy :: ctx) body retTy →
    HasType bmap Δ ctx (.lam argTy body) (.arr argTy retTy)
  /-- Application -/
  | app :
    HasType bmap Δ ctx fn (.arr argTy retTy) →
    HasType bmap Δ ctx arg argTy →
    HasType bmap Δ ctx (.app fn arg) retTy
  /-- Type abstraction (System F / F-omega): Λα:k. t has type ∀α:k. τ.
      The context is shifted because a new type variable is introduced. -/
  | tyAbs :
    (hp : p) →
    HasType bmap (k :: Δ) (ctx.map (Ty.shift 1 0)) body ty →
    HasType bmap Δ ctx (.tyAbs hp k body) (.all hp k ty)
  /-- Type application (System F / F-omega): t [σ] has type τ[0 := σ].
      The type argument must have the correct kind. -/
  | tyApp :
    (hp : p) →
    HasType bmap Δ ctx t (.all hp k bodyTy) →
    HasKind Δ argTy k →
    HasType bmap Δ ctx (.tyApp hp t argTy) (Ty.subst 0 argTy bodyTy)
  /-- Constant at base type n -/
  | const :
    (c : bmap i) →
    HasType bmap Δ ctx (.const i c) (.base i)
  /-- Zero has type Nat -/
  | zero :
    HasType bmap Δ ctx .zero .nat
  /-- Successor: if t : Nat then succ t : Nat -/
  | succ :
    HasType bmap Δ ctx t .nat →
    HasType bmap Δ ctx (.succ t) .nat
  /-- Primitive recursion (natrec):
      C is the result type, base : C, step : Nat → C → C, n : Nat ⊢ natrec C base step n : C -/
  | natrec :
    HasKind Δ C .star →
    HasType bmap Δ ctx base C →
    HasType bmap Δ ctx step (.arr .nat (.arr C C)) →
    HasType bmap Δ ctx n .nat →
    HasType bmap Δ ctx (.natrec C base step n) C
  /-- Type conversion: if t has type τ and τ ≡ τ', then t has type τ'.
      The target type must be well-kinded.
      Essential for System F-omega where types can compute. -/
  | conv :
    HasType bmap Δ ctx t ty →
    TyEquiv ty ty' →
    HasKind Δ ty' .star →
    HasType bmap Δ ctx t ty'

/-- Every type assigned by HasType is well-kinded at kind ★.
    This follows from the kinding premises on `var`, `lam`, and `conv`. -/
theorem HasType.well_kinded (ht : HasType bmap Δ ctx t ty) : HasKind Δ ty .star := by
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
  | const => exact .base
  | zero => exact .nat
  | succ _ _ => exact .nat
  | natrec hk _ _ _ _ => exact hk
  | conv _ _ hk => exact hk

end LambdaCalculi
