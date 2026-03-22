import LambdaCalculi.Ty

namespace LambdaCalculi

/-- Terms in a lambda cube system, parameterized by `p`:
    - When `p = Empty`: only `var`, `app`, `lam` are constructible (STLC)
    - When `p` is inhabited: `tyAbs` and `tyApp` become available (System F) -/
inductive Term (p : Type) where
  /-- Variable (de Bruijn index) -/
  | var : Nat → Term p
  /-- Application -/
  | app : Term p → Term p → Term p
  /-- Lambda abstraction with type annotation, binds variable 0 in body -/
  | lam : Ty p → Term p → Term p
  /-- Type abstraction (Λ. t), binds type variable 0 in body, gated by `p` -/
  | tyAbs : p → Term p → Term p
  /-- Type application (t [τ]), gated by `p` -/
  | tyApp : p → Term p → Ty p → Term p
  deriving Repr

end LambdaCalculi
