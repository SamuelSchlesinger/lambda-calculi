import LambdaCalculi.TyReduction
import LambdaCalculi.TySubstLemmas

namespace LambdaCalculi

/-! ## Church-Rosser theorem for type-level reduction

We prove confluence of type-level beta reduction using the Tait-Martin-Löf
method: define parallel reduction, prove it has the diamond property
via complete developments, then lift to multi-step reduction. -/

-- ============================================================
-- Parallel reduction
-- ============================================================

/-- Parallel reduction: reduce zero or more redexes simultaneously -/
inductive TyPar : Ty p q → Ty p q → Prop where
  | base : TyPar (.base n) (.base n)
  | nat : TyPar .nat .nat
  | arr : TyPar a a' → TyPar b b' → TyPar (.arr a b) (.arr a' b')
  | tvar : TyPar (.tvar hpq n) (.tvar hpq n)
  | all : TyPar body body' → TyPar (.all hp ki body) (.all hp ki body')
  | tyLam : TyPar body body' → TyPar (.tyLam hq ki body) (.tyLam hq ki body')
  | tyAppTy : TyPar f f' → TyPar a a' →
              TyPar (.tyAppTy hq f a) (.tyAppTy hq f' a')
  | beta : TyPar body body' → TyPar arg arg' →
           TyPar (.tyAppTy hq (.tyLam hq' ki body) arg) (Ty.subst 0 arg' body')

theorem TyPar.refl : TyPar (t : Ty p q) t := by
  induction t with
  | base n => exact .base
  | nat => exact .nat
  | arr a b iha ihb => exact .arr iha ihb
  | tvar hpq n => exact .tvar
  | all hp ki body ih => exact .all ih
  | tyLam hq ki body ih => exact .tyLam ih
  | tyAppTy hq f a ihf iha => exact .tyAppTy ihf iha

-- ============================================================
-- Parallel reduction preserves shifting
-- ============================================================

theorem TyPar.shift (h : TyPar t t') (d c : Nat) :
    TyPar (Ty.shift d c t) (Ty.shift d c t') := by
  induction h generalizing c with
  | base => exact .base
  | nat => exact .nat
  | arr ha hb iha ihb => exact .arr (iha c) (ihb c)
  | tvar => simp [Ty.shift]; exact .tvar
  | all _ ih => exact .all (ih (c + 1))
  | tyLam _ ih => exact .tyLam (ih (c + 1))
  | tyAppTy hf ha ihf iha => exact .tyAppTy (ihf c) (iha c)
  | beta hbody harg ihbody iharg =>
    simp only [Ty.shift]
    rw [Ty.shift_subst_comm_gen d c 0 _ _ (Nat.zero_le c)]
    exact .beta (ihbody (c + 1)) (iharg c)

-- ============================================================
-- Parallel reduction preserves substitution
-- ============================================================

theorem TyPar.subst (hbod : TyPar body body') (harg : TyPar arg arg') (j : Nat) :
    TyPar (Ty.subst j arg body) (Ty.subst j arg' body') := by
  induction hbod generalizing j arg arg' with
  | base => simp [Ty.subst]; exact .base
  | nat => simp [Ty.subst]; exact .nat
  | arr ha hb iha ihb =>
    simp [Ty.subst]; exact .arr (iha harg j) (ihb harg j)
  | tvar =>
    simp only [Ty.subst]
    split
    · exact harg
    · split <;> exact .tvar
  | all _ ih =>
    simp [Ty.subst]; exact .all (ih (harg.shift 1 0) (j + 1))
  | tyLam _ ih =>
    simp [Ty.subst]; exact .tyLam (ih (harg.shift 1 0) (j + 1))
  | tyAppTy hf ha ihf iha =>
    simp [Ty.subst]; exact .tyAppTy (ihf harg j) (iha harg j)
  | @beta bod bod' barg barg' _ _ _ _ _ ihbod ihbarg =>
    simp only [Ty.subst]
    have key := Ty.subst_subst_comm 0 j arg' barg' bod'
    simp only [Nat.zero_add] at key
    rw [← key]
    exact .beta (ihbod (harg.shift 1 0) (j + 1)) (ihbarg harg j)

-- ============================================================
-- Complete development
-- ============================================================

/-- The complete development: reduce ALL outermost redexes simultaneously.
    For `tyAppTy` where the function is a `tyLam`, perform beta reduction.
    Otherwise, recurse into subterms. -/
def Ty.complete : Ty p q → Ty p q
  | .base n => .base n
  | .nat => .nat
  | .arr a b => .arr a.complete b.complete
  | .tvar hpq n => .tvar hpq n
  | .all hp ki body => .all hp ki body.complete
  | .tyLam hq ki body => .tyLam hq ki body.complete
  | .tyAppTy _ (.tyLam _ _ body) arg => Ty.subst 0 arg.complete body.complete
  | .tyAppTy hq f arg => .tyAppTy hq f.complete arg.complete

-- ============================================================
-- Triangle property: TyPar t t' → TyPar t' t.complete
-- ============================================================

theorem TyPar.to_complete (h : TyPar t t') : TyPar t' (Ty.complete t) := by
  induction h with
  | base => exact .base
  | nat => exact .nat
  | arr _ _ iha ihb => exact .arr iha ihb
  | tvar => exact .tvar
  | all _ ih => exact .all ih
  | tyLam _ ih => exact .tyLam ih
  | tyAppTy hf ha ihf iha =>
    -- Case-split on hf to determine whether f is a tyLam (which triggers beta in complete)
    cases hf with
    | base => exact .tyAppTy ihf iha
    | nat => exact .tyAppTy ihf iha
    | arr _ _ => exact .tyAppTy ihf iha
    | tvar => exact .tyAppTy ihf iha
    | all _ => exact .tyAppTy ihf iha
    | tyAppTy _ _ => exact .tyAppTy ihf iha
    | beta _ _ => exact .tyAppTy ihf iha
    | tyLam hbody =>
      -- f = .tyLam, so Ty.complete (.tyAppTy .. (.tyLam ..) ..) = Ty.subst 0 a.complete body.complete
      -- ihf : TyPar (.tyLam .. body') (.tyLam .. body.complete)
      cases ihf with
      | tyLam ihbody => exact .beta ihbody iha
  | beta _ _ ihbody iharg =>
    exact TyPar.subst ihbody iharg 0

-- ============================================================
-- Diamond property and Church-Rosser
-- ============================================================

/-- Parallel reduction has the diamond property -/
theorem TyPar.diamond (h1 : TyPar t t₁) (h2 : TyPar t t₂) :
    ∃ u, TyPar t₁ u ∧ TyPar t₂ u :=
  ⟨t.complete, h1.to_complete, h2.to_complete⟩

/-- Multi-step parallel reduction -/
inductive TyParStar : Ty p q → Ty p q → Prop where
  | refl : TyParStar t t
  | step : TyPar t t' → TyParStar t' t'' → TyParStar t t''

theorem TyParStar.single (h : TyPar t t') : TyParStar t t' :=
  .step h .refl

theorem TyParStar.trans (h1 : TyParStar t t') (h2 : TyParStar t' t'') : TyParStar t t'' := by
  induction h1 with
  | refl => exact h2
  | step hs _ ih => exact .step hs (ih h2)

/-- TyStep implies TyPar -/
theorem TyStep.to_par (h : TyStep t t') : TyPar t t' := by
  induction h with
  | beta => exact .beta .refl .refl
  | arrLeft _ ih => exact .arr ih .refl
  | arrRight _ ih => exact .arr .refl ih
  | allBody _ ih => exact .all ih
  | tyLamBody _ ih => exact .tyLam ih
  | tyAppTyFn _ ih => exact .tyAppTy ih .refl
  | tyAppTyArg _ ih => exact .tyAppTy .refl ih

/-- TyPar implies TyReduces -/
theorem TyPar.to_reduces (h : TyPar t t') : TyReduces t t' := by
  induction h with
  | base => exact .refl
  | nat => exact .refl
  | arr _ _ iha ihb => exact TyReduces.arr iha ihb
  | tvar => exact .refl
  | all _ ih => exact TyReduces.allBody ih
  | tyLam _ ih => exact TyReduces.tyLamBody ih
  | tyAppTy _ _ ihf iha => exact TyReduces.tyAppTy ihf iha
  | beta _ _ ihbody iharg =>
    exact (TyReduces.tyAppTy (TyReduces.tyLamBody ihbody) iharg).trans
      (.step .beta .refl)

/-- TyReduces implies TyParStar -/
theorem TyReduces.to_parStar (h : TyReduces t t') : TyParStar t t' := by
  induction h with
  | refl => exact .refl
  | step hs _ ih => exact .step (hs.to_par) ih

/-- TyParStar implies TyReduces -/
theorem TyParStar.to_reduces (h : TyParStar t t') : TyReduces t t' := by
  induction h with
  | refl => exact .refl
  | step hs _ ih => exact hs.to_reduces.trans ih

/-- Strip lemma: TyPar followed by TyParStar has a common reduct -/
theorem strip_lemma (h1 : TyPar t t₁) (h2 : TyParStar t t₂) :
    ∃ u, TyParStar t₁ u ∧ TyPar t₂ u := by
  induction h2 generalizing t₁ with
  | refl =>
    obtain ⟨u, hu1, hu2⟩ := TyPar.diamond h1 TyPar.refl
    exact ⟨u, .single hu1, hu2⟩
  | step hs _ ih =>
    obtain ⟨u₁, hu₁₁, hu₁₂⟩ := TyPar.diamond h1 hs
    obtain ⟨u₂, hu₂₁, hu₂₂⟩ := ih hu₁₂
    exact ⟨u₂, .step hu₁₁ hu₂₁, hu₂₂⟩

/-- Church-Rosser for TyParStar -/
theorem church_rosser_par (h1 : TyParStar t t₁) (h2 : TyParStar t t₂) :
    ∃ u, TyParStar t₁ u ∧ TyParStar t₂ u := by
  induction h1 generalizing t₂ with
  | refl => exact ⟨t₂, h2, .refl⟩
  | step hs _ ih =>
    obtain ⟨u₁, hu₁₁, hu₁₂⟩ := strip_lemma hs h2
    obtain ⟨u₂, hu₂₁, hu₂₂⟩ := ih hu₁₁
    exact ⟨u₂, hu₂₁, (TyParStar.single hu₁₂).trans hu₂₂⟩

/-- Church-Rosser: if t →* t₁ and t →* t₂, then there exists u with t₁ →* u and t₂ →* u -/
theorem church_rosser (h1 : TyReduces t t₁) (h2 : TyReduces t t₂) :
    ∃ u, TyReduces t₁ u ∧ TyReduces t₂ u := by
  obtain ⟨u, hu1, hu2⟩ := church_rosser_par h1.to_parStar h2.to_parStar
  exact ⟨u, hu1.to_reduces, hu2.to_reduces⟩

-- ============================================================
-- Transitivity of TyEquiv (via Church-Rosser)
-- ============================================================

theorem TyEquiv.trans (h1 : TyEquiv t₁ t₂) (h2 : TyEquiv t₂ t₃) : TyEquiv t₁ t₃ := by
  obtain ⟨u₁, hr₁₁, hr₁₂⟩ := h1
  obtain ⟨u₂, hr₂₁, hr₂₂⟩ := h2
  obtain ⟨u, hu₁, hu₂⟩ := church_rosser hr₁₂ hr₂₁
  exact ⟨u, hr₁₁.trans hu₁, hr₂₂.trans hu₂⟩

/-- Base types and arrow types can never be equivalent -/
theorem TyEquiv.base_ne_arr :
    ¬ TyEquiv (.base n : Ty p q) (.arr a b) := by
  intro ⟨t, hr1, hr2⟩
  have h1 := hr1.head_preserved (show Ty.head (.base n) ≠ .tyAppTy from nofun)
  have h2 := hr2.head_preserved (show Ty.head (.arr a b) ≠ .tyAppTy from nofun)
  simp only [Ty.head] at h1 h2; rw [h1] at h2; exact absurd h2 nofun

/-- Base types and universal types can never be equivalent -/
theorem TyEquiv.base_ne_all :
    ¬ TyEquiv (.base n : Ty p q) (.all hp ki body) := by
  intro ⟨t, hr1, hr2⟩
  have h1 := hr1.head_preserved (show Ty.head (.base n) ≠ .tyAppTy from nofun)
  have h2 := hr2.head_preserved (show Ty.head (.all hp ki body) ≠ .tyAppTy from nofun)
  simp only [Ty.head] at h1 h2; rw [h1] at h2; exact absurd h2 nofun

/-- Nat and arrow types can never be equivalent -/
theorem TyEquiv.nat_ne_arr :
    ¬ TyEquiv (.nat : Ty p q) (.arr a b) := by
  intro ⟨t, hr1, hr2⟩
  have h1 := hr1.head_preserved (show Ty.head (.nat : Ty p q) ≠ .tyAppTy from nofun)
  have h2 := hr2.head_preserved (show Ty.head (.arr a b) ≠ .tyAppTy from nofun)
  simp only [Ty.head] at h1 h2; rw [h1] at h2; exact absurd h2 nofun

/-- Nat and universal types can never be equivalent -/
theorem TyEquiv.nat_ne_all :
    ¬ TyEquiv (.nat : Ty p q) (.all hp ki body) := by
  intro ⟨t, hr1, hr2⟩
  have h1 := hr1.head_preserved (show Ty.head (.nat : Ty p q) ≠ .tyAppTy from nofun)
  have h2 := hr2.head_preserved (show Ty.head (.all hp ki body) ≠ .tyAppTy from nofun)
  simp only [Ty.head] at h1 h2; rw [h1] at h2; exact absurd h2 nofun

/-- Nat and base types can never be equivalent -/
theorem TyEquiv.nat_ne_base :
    ¬ TyEquiv (.nat : Ty p q) (.base n) := by
  intro ⟨t, hr1, hr2⟩
  have h1 := hr1.head_preserved (show Ty.head (.nat : Ty p q) ≠ .tyAppTy from nofun)
  have h2 := hr2.head_preserved (show Ty.head (.base n : Ty p q) ≠ .tyAppTy from nofun)
  simp only [Ty.head] at h1 h2; rw [h1] at h2; exact absurd h2 nofun

end LambdaCalculi
