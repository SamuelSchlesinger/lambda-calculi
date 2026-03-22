import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst

namespace LambdaCalculi

/-- A term is a value (cannot be reduced further).
    For STLC: only lambdas are values.
    For System F: type abstractions are also values. -/
inductive Value : Term p → Prop where
  | lam : Value (.lam ty body)
  | tyAbs : Value (.tyAbs hp body)

/-- Small-step call-by-value operational semantics.

    For STLC (`p = Empty`), only `beta`, `appFn`, `appArg` are usable.
    For System F (`p` inhabited), `tyBeta` and `tyAppFn` become available. -/
inductive Step : Term p → Term p → Prop where
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
  /-- Type beta: (Λ. body) [σ] ⟶ body with type var 0 replaced by σ -/
  | tyBeta :
    Step (.tyApp hp (.tyAbs hp' body) argTy) (Term.tySubst 0 argTy body)
  /-- Reduce under type application -/
  | tyAppFn :
    Step t t' →
    Step (.tyApp hp t argTy) (.tyApp hp t' argTy)

/-- Reflexive transitive closure of Step -/
inductive Steps : Term p → Term p → Prop where
  | refl : Steps t t
  | step : Step t t' → Steps t' t'' → Steps t t''

end LambdaCalculi
