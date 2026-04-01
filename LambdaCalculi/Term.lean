import LambdaCalculi.Ty

namespace LambdaCalculi

/-- Terms in a lambda square system, parameterized by `p` and `q`:
    - `p` gates polymorphism at the term level (Λ type abstraction, t[τ] type application)
    - `q` is threaded through via `Ty p q` in type annotations
    - When both are `Empty`: only `var`, `app`, `lam` are constructible (STLC)
    - When `p` is inhabited: `tyAbs` and `tyApp` become available (System F / F-omega) -/
inductive Term (p : Type) (q : Type) where
  /-- Variable (de Bruijn index) -/
  | var : Nat → Term p q
  /-- Application -/
  | app : Term p q → Term p q → Term p q
  /-- Lambda abstraction with type annotation, binds variable 0 in body -/
  | lam : Ty p q → Term p q → Term p q
  /-- Type abstraction (Λα:k. t), binds type variable 0 in body, gated by `p` -/
  | tyAbs : p → Kind → Term p q → Term p q
  /-- Type application (t [τ]), gated by `p` -/
  | tyApp : p → Term p q → Ty p q → Term p q
  /-- Constant at base type n -/
  | const : Nat → Term p q
  /-- Zero (natural number) -/
  | zero : Term p q
  /-- Successor -/
  | succ : Term p q → Term p q
  /-- Primitive recursion: natrec C base step n
      C is the result type, base : C, step : Nat → C → C, n : Nat -/
  | natrec : Ty p q → Term p q → Term p q → Term p q → Term p q
  deriving Repr

end LambdaCalculi
