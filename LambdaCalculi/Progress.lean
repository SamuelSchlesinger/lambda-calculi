import LambdaCalculi.Typing
import LambdaCalculi.Reduction

namespace LambdaCalculi

/-! ## Progress Theorem

A well-typed closed term is either a value or can take a step.
We prove this for all lambda cube instantiations simultaneously. -/

/-- Canonical forms: a closed value of arrow type must be a lambda -/
theorem canonical_arr {v : Term p} :
    HasType [] v (.arr argTy retTy) → Value v → ∃ ty body, v = .lam ty body := by
  intro ht hv
  cases hv with
  | lam => exact ⟨_, _, rfl⟩
  | tyAbs => cases ht

/-- Canonical forms: a closed value of ∀ type must be a type abstraction -/
theorem canonical_all {v : Term p} :
    HasType [] v (.all hp ty) → Value v → ∃ hp' body, v = .tyAbs hp' body := by
  intro ht hv
  cases hv with
  | lam => cases ht
  | tyAbs => exact ⟨_, _, rfl⟩

/-- Progress: a well-typed closed term is either a value or can step.
    We generalize over the context and pass the closedness proof separately
    so that `induction` can work on the typing derivation. -/
theorem progress {t : Term p} {ty : Ty p}
    (ht : HasType ctx t ty) (hclosed : ctx = []) :
    Value t ∨ ∃ t', Step t t' := by
  induction ht with
  | var hget =>
    subst hclosed; simp at hget
  | lam _ =>
    exact Or.inl .lam
  | app hfn harg ihfn iharg =>
    right
    rcases ihfn hclosed with hv | ⟨t', hs⟩
    · rcases iharg hclosed with hv' | ⟨s', hs'⟩
      · subst hclosed
        obtain ⟨ty, body, rfl⟩ := canonical_arr hfn hv
        exact ⟨_, .beta hv'⟩
      · exact ⟨_, .appArg hv hs'⟩
    · exact ⟨_, .appFn hs⟩
  | tyAbs hp _ =>
    exact Or.inl .tyAbs
  | tyApp hp ht' ih =>
    right
    rcases ih hclosed with hv | ⟨t', hs⟩
    · subst hclosed
      obtain ⟨hp', body, rfl⟩ := canonical_all ht' hv
      exact ⟨_, .tyBeta⟩
    · exact ⟨_, .tyAppFn hs⟩

/-- Convenience: progress for closed terms -/
theorem progress' {t : Term p} {ty : Ty p} (ht : HasType [] t ty) :
    Value t ∨ ∃ t', Step t t' :=
  progress ht rfl

end LambdaCalculi
