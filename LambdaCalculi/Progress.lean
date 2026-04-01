import LambdaCalculi.Typing
import LambdaCalculi.Reduction
import LambdaCalculi.TyConfluence

namespace LambdaCalculi

/-! ## Progress Theorem

A well-typed closed term is either a value or can take a step.
We prove this for all lambda square instantiations simultaneously. -/

/-- Canonical forms for arrow types, generalized for type equivalence.
    A closed value whose type is equivalent to an arrow must be a lambda. -/
theorem canonical_arr_gen {t : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (hctx : ctx = []) (hv : Value t)
    (heq : TyEquiv ty (.arr argTy retTy)) :
    ∃ ty' body, t = .lam ty' body := by
  induction ht generalizing argTy retTy with
  | var hget _ => subst hctx; simp at hget
  | lam _ _ => exact ⟨_, _, rfl⟩
  | app _ _ => cases hv
  | tyAbs hp _ =>
    exact absurd (heq.symm) TyEquiv.arr_ne_all
  | tyApp _ _ _ => cases hv
  | const => exact absurd heq TyEquiv.base_ne_arr
  | zero => exact absurd heq TyEquiv.nat_ne_arr
  | succ _ _ => exact absurd heq TyEquiv.nat_ne_arr
  | natrec _ _ _ _ _ => cases hv
  | conv _ heq' _ ih =>
    exact ih hctx hv (heq'.trans heq)

/-- Canonical forms: a closed value of arrow type must be a lambda -/
theorem canonical_arr {t : Term p q}
    (ht : HasType Δ [] t (.arr argTy retTy)) (hv : Value t) :
    ∃ ty body, t = .lam ty body :=
  canonical_arr_gen ht rfl hv TyEquiv.refl

/-- Canonical forms for universal types, generalized for type equivalence -/
theorem canonical_all_gen {t : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (hctx : ctx = []) (hv : Value t)
    (heq : TyEquiv ty (.all hp ki bodyTy)) :
    ∃ hp' ki' body, t = .tyAbs hp' ki' body := by
  induction ht generalizing hp ki bodyTy with
  | var hget _ => subst hctx; simp at hget
  | lam _ _ =>
    exact absurd heq TyEquiv.arr_ne_all
  | app _ _ => cases hv
  | tyAbs hp' _ => exact ⟨_, _, _, rfl⟩
  | tyApp _ _ _ => cases hv
  | const => exact absurd heq TyEquiv.base_ne_all
  | zero => exact absurd heq TyEquiv.nat_ne_all
  | succ _ _ => exact absurd heq TyEquiv.nat_ne_all
  | natrec _ _ _ _ _ => cases hv
  | conv _ heq' _ ih =>
    exact ih hctx hv (heq'.trans heq)

/-- Canonical forms: a closed value of ∀ type must be a type abstraction -/
theorem canonical_all {t : Term p q}
    (ht : HasType Δ [] t (.all hp ki ty)) (hv : Value t) :
    ∃ hp' ki' body, t = .tyAbs hp' ki' body :=
  canonical_all_gen ht rfl hv TyEquiv.refl

/-- Canonical forms for nat types, generalized for type equivalence.
    A closed value whose type is equivalent to nat must be zero or succ v. -/
theorem canonical_nat_gen {t : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (hctx : ctx = []) (hv : Value t)
    (heq : TyEquiv ty .nat) :
    t = .zero ∨ ∃ v, t = .succ v ∧ Value v := by
  induction ht with
  | var hget _ => subst hctx; simp at hget
  | lam _ _ => exact absurd heq.symm TyEquiv.nat_ne_arr
  | app _ _ => cases hv
  | tyAbs hp _ => exact absurd heq.symm TyEquiv.nat_ne_all
  | tyApp _ _ _ => cases hv
  | const => exact absurd heq.symm TyEquiv.nat_ne_base
  | zero => exact Or.inl rfl
  | succ _ _ => cases hv with | succ hv' => exact Or.inr ⟨_, rfl, hv'⟩
  | natrec _ _ _ _ _ => cases hv
  | conv _ heq' _ ih => exact ih hctx hv (heq'.trans heq)

/-- Canonical forms: a closed value of nat type must be zero or succ v -/
theorem canonical_nat {t : Term p q}
    (ht : HasType Δ [] t .nat) (hv : Value t) :
    t = .zero ∨ ∃ v, t = .succ v ∧ Value v :=
  canonical_nat_gen ht rfl hv TyEquiv.refl

/-- Progress: a well-typed closed term is either a value or can step. -/
theorem progress {t : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (hclosed : ctx = []) :
    Value t ∨ ∃ t', Step t t' := by
  induction ht with
  | var hget _ =>
    subst hclosed; simp at hget
  | lam _ _ =>
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
  | const =>
    exact Or.inl .const
  | zero =>
    exact Or.inl .zero
  | succ _ ih =>
    rcases ih hclosed with hv | ⟨t', hs⟩
    · exact Or.inl (.succ hv)
    · exact Or.inr ⟨_, .succArg hs⟩
  | natrec hk hbase hstep hn _ _ ihn =>
    right
    rcases ihn hclosed with hv | ⟨n', hs⟩
    · subst hclosed
      rcases canonical_nat hn hv with rfl | ⟨v, rfl, hv'⟩
      · exact ⟨_, .recZero⟩
      · exact ⟨_, .recSucc hv'⟩
    · exact ⟨_, .recArg hs⟩
  | tyApp hp ht' hk ih =>
    right
    rcases ih hclosed with hv | ⟨t', hs⟩
    · subst hclosed
      obtain ⟨hp', ki', body, rfl⟩ := canonical_all ht' hv
      exact ⟨_, .tyBeta⟩
    · exact ⟨_, .tyAppFn hs⟩
  | conv _ _ _ ih =>
    exact ih hclosed

/-- Convenience: progress for closed terms -/
theorem progress' {t : Term p q} {ty : Ty p q} (ht : HasType Δ [] t ty) :
    Value t ∨ ∃ t', Step t t' :=
  progress ht rfl

end LambdaCalculi
