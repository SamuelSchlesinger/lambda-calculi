import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst

namespace LambdaCalculi

/-- A term is a value (cannot be reduced further).
    For STLC: only lambdas are values.
    For System F / F-omega: type abstractions are also values. -/
inductive Value : Term bmap p q → Prop where
  | lam : Value (.lam ty body)
  | tyAbs : Value (.tyAbs hp ki body)
  | const : Value (.const i c)
  | zero : Value (.zero)
  | succ : Value t → Value (.succ t)

/-- Small-step call-by-value operational semantics.

    For STLC (`p = Empty, q = Empty`), only `beta`, `appFn`, `appArg` are usable.
    For System F / F-omega (`p` inhabited), `tyBeta` and `tyAppFn` become available. -/
inductive Step : Term bmap p q → Term bmap p q → Prop where
  /-- Beta reduction: (λτ. body) v ⟶ body[0 := v] -/
  | beta :
    Value v →
    Step (.app (.lam ty body) v) (Term.subst 0 v body)
  /-- Reduce the function position -/
  | appFn :
    Step t t' →
    Step (.app t s) (.app t' s)
  /-- Reduce the argument position (function must be a value) -/
  | appArg :
    Value v →
    Step s s' →
    Step (.app v s) (.app v s')
  /-- Type beta: (Λα:k. body) [σ] ⟶ body with type var 0 replaced by σ -/
  | tyBeta :
    Step (.tyApp hp (.tyAbs hp' ki body) argTy) (Term.tySubst 0 argTy body)
  /-- Reduce under type application -/
  | tyAppFn :
    Step t t' →
    Step (.tyApp hp t argTy) (.tyApp hp t' argTy)
  /-- Reduce under successor -/
  | succArg :
    Step t t' →
    Step (.succ t) (.succ t')
  /-- Recursor on zero: natrec C base step zero ⟶ base -/
  | recZero :
    Step (.natrec C base step .zero) base
  /-- Recursor on successor: natrec C base step (succ v) ⟶ step v (natrec C base step v) -/
  | recSucc :
    Value v →
    Step (.natrec C base step (.succ v)) (.app (.app step v) (.natrec C base step v))
  /-- Reduce the scrutinee of natrec -/
  | recArg :
    Step n n' →
    Step (.natrec C base step n) (.natrec C base step n')

/-- Reflexive transitive closure of Step -/
inductive Steps : Term bmap p q → Term bmap p q → Prop where
  | refl : Steps t t
  | step : Step t t' → Steps t' t'' → Steps t t''

end LambdaCalculi
