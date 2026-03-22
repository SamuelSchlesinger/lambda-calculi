namespace LambdaCalculi

/-- Types in a lambda cube system, parameterized by `p`:
    - When `p = Empty`: only `base` and `arr` are constructible (STLC)
    - When `p` is inhabited (e.g., `Unit`): `tvar` and `all` become available (System F)

    The trick: constructors `tvar` and `all` require a value of type `p`.
    When `p = Empty`, no such value exists, so these constructors are dead. -/
inductive Ty (p : Type) where
  /-- Base type, identified by index -/
  | base : Nat → Ty p
  /-- Arrow (function) type -/
  | arr : Ty p → Ty p → Ty p
  /-- Type variable (de Bruijn index), gated by `p` -/
  | tvar : p → Nat → Ty p
  /-- Universal quantification (∀. τ), binds type variable 0 in body, gated by `p` -/
  | all : p → Ty p → Ty p
  deriving DecidableEq, Repr

end LambdaCalculi
