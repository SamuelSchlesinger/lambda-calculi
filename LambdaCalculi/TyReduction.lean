import LambdaCalculi.Subst

namespace LambdaCalculi

/-! ## Type-level reduction

In System F-omega, types can compute: `(λα:k. τ₁) τ₂ →β τ₁[α := τ₂]`.
We define single-step and multi-step reduction, and type equivalence as joinability. -/

/-- Single-step type-level beta reduction with congruence rules -/
inductive TyStep : Ty p q → Ty p q → Prop where
  /-- Type-level beta: (λα:k. body) arg ⟶ body[0 := arg] -/
  | beta : TyStep (.tyAppTy hq (.tyLam hq' ki body) arg) (Ty.subst 0 arg body)
  /-- Congruence under left of arrow -/
  | arrLeft : TyStep a a' → TyStep (.arr a b) (.arr a' b)
  /-- Congruence under right of arrow -/
  | arrRight : TyStep b b' → TyStep (.arr a b) (.arr a b')
  /-- Congruence under ∀ body -/
  | allBody : TyStep body body' → TyStep (.all hp ki body) (.all hp ki body')
  /-- Congruence under type-lambda body -/
  | tyLamBody : TyStep body body' → TyStep (.tyLam hq ki body) (.tyLam hq ki body')
  /-- Congruence under type application function -/
  | tyAppTyFn : TyStep f f' → TyStep (.tyAppTy hq f a) (.tyAppTy hq f' a)
  /-- Congruence under type application argument -/
  | tyAppTyArg : TyStep a a' → TyStep (.tyAppTy hq f a) (.tyAppTy hq f a')

/-- Multi-step type reduction (reflexive-transitive closure of TyStep) -/
inductive TyReduces : Ty p q → Ty p q → Prop where
  | refl : TyReduces t t
  | step : TyStep t t' → TyReduces t' t'' → TyReduces t t''

/-- Type equivalence via joinability: two types are equivalent if they reduce to a common type -/
def TyEquiv (t₁ t₂ : Ty p q) : Prop :=
  ∃ t, TyReduces t₁ t ∧ TyReduces t₂ t

-- ============================================================
-- Basic properties of TyReduces
-- ============================================================

theorem TyReduces.single (h : TyStep t t') : TyReduces t t' :=
  .step h .refl

theorem TyReduces.trans (h1 : TyReduces t t') (h2 : TyReduces t' t'') : TyReduces t t'' := by
  induction h1 with
  | refl => exact h2
  | step hs _ ih => exact .step hs (ih h2)

-- ============================================================
-- Congruence lemmas for TyReduces
-- ============================================================

theorem TyReduces.arr_left (h : TyReduces a a') : TyReduces (.arr a b) (.arr a' b) := by
  induction h with
  | refl => exact .refl
  | step hs _ ih => exact .step (.arrLeft hs) ih

theorem TyReduces.arr_right (h : TyReduces b b') : TyReduces (.arr a b) (.arr a b') := by
  induction h with
  | refl => exact .refl
  | step hs _ ih => exact .step (.arrRight hs) ih

theorem TyReduces.arr (h1 : TyReduces a a') (h2 : TyReduces b b') :
    TyReduces (.arr a b) (.arr a' b') :=
  (TyReduces.arr_left h1).trans (TyReduces.arr_right h2)

theorem TyReduces.allBody (h : TyReduces body body') :
    TyReduces (.all hp ki body) (.all hp ki body') := by
  induction h with
  | refl => exact .refl
  | step hs _ ih => exact .step (.allBody hs) ih

theorem TyReduces.tyLamBody (h : TyReduces body body') :
    TyReduces (.tyLam hq ki body) (.tyLam hq ki body') := by
  induction h with
  | refl => exact .refl
  | step hs _ ih => exact .step (.tyLamBody hs) ih

theorem TyReduces.tyAppTyFn (h : TyReduces f f') :
    TyReduces (.tyAppTy hq f a) (.tyAppTy hq f' a) := by
  induction h with
  | refl => exact .refl
  | step hs _ ih => exact .step (.tyAppTyFn hs) ih

theorem TyReduces.tyAppTyArg (h : TyReduces a a') :
    TyReduces (.tyAppTy hq f a) (.tyAppTy hq f a') := by
  induction h with
  | refl => exact .refl
  | step hs _ ih => exact .step (.tyAppTyArg hs) ih

theorem TyReduces.tyAppTy (h1 : TyReduces f f') (h2 : TyReduces a a') :
    TyReduces (.tyAppTy hq f a) (.tyAppTy hq f' a') :=
  (TyReduces.tyAppTyFn h1).trans (TyReduces.tyAppTyArg h2)

-- ============================================================
-- Basic properties of TyEquiv
-- ============================================================

theorem TyEquiv.refl : TyEquiv t t :=
  ⟨t, .refl, .refl⟩

theorem TyEquiv.symm (h : TyEquiv t₁ t₂) : TyEquiv t₂ t₁ :=
  let ⟨t, h1, h2⟩ := h; ⟨t, h2, h1⟩

theorem TyEquiv.from_reduces (h : TyReduces t₁ t₂) : TyEquiv t₁ t₂ :=
  ⟨t₂, h, .refl⟩

theorem TyEquiv.from_step (h : TyStep t₁ t₂) : TyEquiv t₁ t₂ :=
  TyEquiv.from_reduces (TyReduces.single h)

-- ============================================================
-- Head form preservation under reduction
-- ============================================================

/-- Tags for the outermost constructor of a type -/
inductive TyHead where
  | base | arr | tvar | all | tyLam | tyAppTy | nat
  deriving DecidableEq

/-- Extract the head constructor tag of a type -/
def Ty.head : Ty p q → TyHead
  | .base _ => .base
  | .arr _ _ => .arr
  | .tvar _ _ => .tvar
  | .all _ _ _ => .all
  | .tyLam _ _ _ => .tyLam
  | .tyAppTy _ _ _ => .tyAppTy
  | .nat => .nat

/-- A single step preserves the head constructor for non-stuck types.
    The only rule that changes the head is `beta`, which fires on `tyAppTy`. -/
theorem TyStep.head_preserved (hs : TyStep t t') (h : t.head ≠ .tyAppTy) :
    t'.head = t.head := by
  cases hs with
  | beta => exact absurd rfl h
  | arrLeft _ => rfl
  | arrRight _ => rfl
  | allBody _ => rfl
  | tyLamBody _ => rfl
  | tyAppTyFn _ => exact absurd rfl h
  | tyAppTyArg _ => exact absurd rfl h

/-- Multi-step reduction preserves the head for non-stuck types. -/
theorem TyReduces.head_preserved (hr : TyReduces t t') (h : t.head ≠ .tyAppTy) :
    t'.head = t.head := by
  induction hr with
  | refl => rfl
  | step hs _ ih =>
    have heq := hs.head_preserved h
    rw [heq] at ih
    exact ih h

-- ============================================================
-- Head form incompatibilities (for canonical forms)
-- ============================================================

/-- Arrow and universal types can never be equivalent -/
theorem TyEquiv.arr_ne_all :
    ¬ TyEquiv (.arr a b : Ty p q) (.all hp ki body) := by
  intro ⟨t, hr1, hr2⟩
  have h1 := hr1.head_preserved (show Ty.head (.arr a b) ≠ .tyAppTy from nofun)
  have h2 := hr2.head_preserved (show Ty.head (.all hp ki body) ≠ .tyAppTy from nofun)
  simp only [Ty.head] at h1 h2; rw [h1] at h2; exact absurd h2 nofun

/-- Arrow and type-lambda types can never be equivalent -/
theorem TyEquiv.arr_ne_tyLam :
    ¬ TyEquiv (.arr a b : Ty p q) (.tyLam hq ki body) := by
  intro ⟨t, hr1, hr2⟩
  have h1 := hr1.head_preserved (show Ty.head (.arr a b) ≠ .tyAppTy from nofun)
  have h2 := hr2.head_preserved (show Ty.head (.tyLam hq ki body) ≠ .tyAppTy from nofun)
  simp only [Ty.head] at h1 h2; rw [h1] at h2; exact absurd h2 nofun

/-- Universal and type-lambda types can never be equivalent -/
theorem TyEquiv.all_ne_tyLam :
    ¬ TyEquiv (.all hp ki body : Ty p q) (.tyLam hq ki' body') := by
  intro ⟨t, hr1, hr2⟩
  have h1 := hr1.head_preserved (show Ty.head (.all hp ki body) ≠ .tyAppTy from nofun)
  have h2 := hr2.head_preserved (show Ty.head (.tyLam hq ki' body') ≠ .tyAppTy from nofun)
  simp only [Ty.head] at h1 h2; rw [h1] at h2; exact absurd h2 nofun

end LambdaCalculi
