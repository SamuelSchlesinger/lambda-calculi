import LambdaCalculi.Kind
import LambdaCalculi.Ty
import LambdaCalculi.Subst
import LambdaCalculi.TySubstLemmas
import LambdaCalculi.TyReduction

namespace LambdaCalculi

/-! ## Kinding judgment and metatheory -/

abbrev KindContext := List Kind

/-- Kinding judgment: Δ ⊢ τ : κ -/
inductive HasKind : KindContext → Ty p q → Kind → Prop where
  | base : HasKind Δ (.base n) .star
  | arr : HasKind Δ a .star → HasKind Δ b .star → HasKind Δ (.arr a b) .star
  | tvar : Δ[n]? = some k → HasKind Δ (.tvar hpq n) k
  | all : HasKind (k :: Δ) body .star → HasKind Δ (.all hp k body) .star
  | tyLam : HasKind (k₁ :: Δ) body k₂ → HasKind Δ (.tyLam hq k₁ body) (.arr k₁ k₂)
  | tyAppTy : HasKind Δ f (.arr k₁ k₂) → HasKind Δ a k₁ →
              HasKind Δ (.tyAppTy hq f a) k₂

-- ============================================================
-- Kinding weakening
-- ============================================================

/-- Kinding with a renaming of type variables -/
theorem HasKind.rename {Δ Δ' : KindContext} {ty : Ty p q} {k : Kind}
    (hk : HasKind Δ ty k) (d c : Nat)
    (hctx : ∀ n k', Δ[n]? = some k' → Δ'[if n ≥ c then n + d else n]? = some k') :
    HasKind Δ' (Ty.shift d c ty) k := by
  induction hk generalizing c Δ' with
  | base => exact .base
  | arr ha hb iha ihb => exact .arr (iha c hctx) (ihb c hctx)
  | tvar hget =>
    simp only [Ty.shift]
    exact .tvar (hctx _ _ hget)
  | all hbody ih =>
    exact .all (ih (c + 1) (fun n k' hget' => by
      cases n with
      | zero =>
        simp only [List.getElem?_cons_zero] at hget' ⊢
        rw [if_neg (by omega), List.getElem?_cons_zero]; exact hget'
      | succ n =>
        simp only [List.getElem?_cons_succ] at hget'
        have h := hctx n k' hget'
        by_cases hn : n ≥ c
        · rw [if_pos hn] at h; rw [if_pos (by omega), show n + 1 + d = n + d + 1 from by omega,
            List.getElem?_cons_succ]; exact h
        · rw [if_neg hn] at h; rw [if_neg (by omega), List.getElem?_cons_succ]; exact h))
  | tyLam hbody ih =>
    exact .tyLam (ih (c + 1) (fun n k' hget' => by
      cases n with
      | zero =>
        simp only [List.getElem?_cons_zero] at hget' ⊢
        rw [if_neg (by omega), List.getElem?_cons_zero]; exact hget'
      | succ n =>
        simp only [List.getElem?_cons_succ] at hget'
        have h := hctx n k' hget'
        by_cases hn : n ≥ c
        · rw [if_pos hn] at h; rw [if_pos (by omega), show n + 1 + d = n + d + 1 from by omega,
            List.getElem?_cons_succ]; exact h
        · rw [if_neg hn] at h; rw [if_neg (by omega), List.getElem?_cons_succ]; exact h))
  | tyAppTy hf ha ihf iha => exact .tyAppTy (ihf c hctx) (iha c hctx)

/-- Kinding weakening: adding a kind to the front -/
theorem HasKind.weaken_cons (hk : HasKind Δ ty k) (extra : Kind) :
    HasKind (extra :: Δ) (Ty.shift 1 0 ty) k :=
  hk.rename 1 0 (fun n k' hget => by simp [List.getElem?_cons_succ, hget])

-- ============================================================
-- Kinding substitution
-- ============================================================

/-- Generalized kinding substitution at position j -/
theorem HasKind.subst_gen (j : Nat)
    {Δ : KindContext} {body : Ty p q} {k₂ k₁ : Kind}
    (hbody : HasKind Δ body k₂)
    (hctx : Δ[j]? = some k₁)
    (harg : HasKind (Δ.eraseIdx j) arg k₁) :
    HasKind (Δ.eraseIdx j) (Ty.subst j arg body) k₂ := by
  induction hbody generalizing j arg k₁ with
  | base => simp [Ty.subst]; exact .base
  | arr ha hb iha ihb => simp [Ty.subst]; exact .arr (iha j hctx harg) (ihb j hctx harg)
  | tvar hget =>
    rename_i n _k _hpq
    simp only [Ty.subst]
    split
    · rename_i heq; subst heq; rw [hget] at hctx; cases hctx; exact harg
    · rename_i hne
      split
      · rename_i hjn
        apply HasKind.tvar
        rw [List.getElem?_eraseIdx]
        have hge : ¬ (n - 1 < j) := by omega
        rw [if_neg hge]
        have heq : n - 1 + 1 = n := by omega
        rw [heq]
        exact hget
      · rename_i hnjk
        apply HasKind.tvar
        rw [List.getElem?_eraseIdx, if_pos (by omega)]
        exact hget
  | all hbod ih =>
    simp only [Ty.subst]; constructor
    have heq : ∀ (a : Kind) (c : KindContext), (a :: c).eraseIdx (j + 1) = a :: c.eraseIdx j := by
      intro a c; simp [List.eraseIdx_cons_succ]
    rw [← heq]
    apply @ih (Ty.shift 1 0 arg) (j + 1) k₁
    · simp only [List.getElem?_cons_succ]; exact hctx
    · rw [heq]; exact harg.weaken_cons _
  | tyLam hbod ih =>
    simp only [Ty.subst]; constructor
    have heq : ∀ (a : Kind) (c : KindContext), (a :: c).eraseIdx (j + 1) = a :: c.eraseIdx j := by
      intro a c; simp [List.eraseIdx_cons_succ]
    rw [← heq]
    apply @ih (Ty.shift 1 0 arg) (j + 1) k₁
    · simp only [List.getElem?_cons_succ]; exact hctx
    · rw [heq]; exact harg.weaken_cons _
  | tyAppTy hf ha ihf iha =>
    simp only [Ty.subst]; exact .tyAppTy (ihf j hctx harg) (iha j hctx harg)

/-- Kinding substitution: substituting a well-kinded type preserves kinding -/
theorem HasKind.subst_preserves
    (hbody : HasKind (k₁ :: Δ) body k₂) (harg : HasKind Δ arg k₁) :
    HasKind Δ (Ty.subst 0 arg body) k₂ := by
  have h := HasKind.subst_gen 0 hbody (by simp) harg
  simpa using h

-- ============================================================
-- Kinding preservation under type reduction
-- ============================================================

/-- A single type reduction step preserves kinding -/
theorem HasKind.step_preserves (hk : HasKind Δ ty k) (hs : TyStep ty ty') :
    HasKind Δ ty' k := by
  induction hk generalizing ty' with
  | base => cases hs
  | arr ha hb iha ihb =>
    cases hs with
    | arrLeft hs' => exact .arr (iha hs') hb
    | arrRight hs' => exact .arr ha (ihb hs')
  | tvar _ => cases hs
  | all hbody ih =>
    cases hs with
    | allBody hs' => exact .all (ih hs')
  | tyLam hbody ih =>
    cases hs with
    | tyLamBody hs' => exact .tyLam (ih hs')
  | tyAppTy hf ha ihf iha =>
    cases hs with
    | beta =>
      -- (λα:k₁. body) arg →β body[0 := arg]
      -- hf : HasKind Δ (.tyLam _ k₁ body) (.arr k₁ k), so HasKind (k₁ :: Δ) body k
      -- ha : HasKind Δ arg k₁
      cases hf with
      | tyLam hbody => exact hbody.subst_preserves ha
    | tyAppTyFn hs' => exact .tyAppTy (ihf hs') ha
    | tyAppTyArg hs' => exact .tyAppTy hf (iha hs')

/-- Multi-step type reduction preserves kinding -/
theorem HasKind.reduces_preserves (hk : HasKind Δ ty k) (hr : TyReduces ty ty') :
    HasKind Δ ty' k := by
  induction hr with
  | refl => exact hk
  | step hs _ ih => exact ih (hk.step_preserves hs)


end LambdaCalculi
