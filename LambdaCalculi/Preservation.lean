import LambdaCalculi.Typing
import LambdaCalculi.Reduction
import LambdaCalculi.Subst
import LambdaCalculi.Weakening
import LambdaCalculi.TySubstLemmas
import LambdaCalculi.TyReduction
import LambdaCalculi.TyConfluence
import LambdaCalculi.Kinding

namespace LambdaCalculi

/-! ## Preservation Theorem

If a well-typed term takes a step, the result is well-typed at the same type.
Requires weakening, the substitution lemma, and generation lemmas (type inversion
through possible chains of `conv`) as key ingredients. -/

-- ============================================================
-- TyStep/TyReduces inversion for arr and all
-- ============================================================

theorem TyStep.arr_inv {a b : Ty p q} {t : Ty p q} (hs : TyStep (.arr a b) t) :
    (∃ a', t = .arr a' b ∧ TyStep a a') ∨ (∃ b', t = .arr a b' ∧ TyStep b b') := by
  cases hs with
  | arrLeft h => exact Or.inl ⟨_, rfl, h⟩
  | arrRight h => exact Or.inr ⟨_, rfl, h⟩

theorem TyReduces.arr_inv {a b : Ty p q} {t : Ty p q} (hr : TyReduces (.arr a b) t) :
    ∃ a' b', t = .arr a' b' ∧ TyReduces a a' ∧ TyReduces b b' := by
  generalize heq : Ty.arr a b = src at hr
  induction hr generalizing a b with
  | refl => subst heq; exact ⟨a, b, rfl, .refl, .refl⟩
  | step hs _ ih =>
    subst heq
    rcases hs.arr_inv with ⟨a', rfl, ha⟩ | ⟨b', rfl, hb⟩
    · obtain ⟨a'', b'', rfl, ha', hb'⟩ := ih rfl
      exact ⟨a'', b'', rfl, .step ha ha', hb'⟩
    · obtain ⟨a'', b'', rfl, ha', hb'⟩ := ih rfl
      exact ⟨a'', b'', rfl, ha', .step hb hb'⟩

theorem TyEquiv.arr_inj {a b a' b' : Ty p q}
    (he : TyEquiv (.arr a b) (.arr a' b')) :
    TyEquiv a a' ∧ TyEquiv b b' := by
  obtain ⟨u, hr1, hr2⟩ := he
  obtain ⟨a₁, b₁, rfl, ha₁, hb₁⟩ := hr1.arr_inv
  obtain ⟨a₂, b₂, heq, ha₂, hb₂⟩ := hr2.arr_inv
  cases heq
  exact ⟨⟨a₁, ha₁, ha₂⟩, ⟨b₁, hb₁, hb₂⟩⟩

theorem TyStep.all_inv {hp : p} {k : Kind} {body : Ty p q} {t : Ty p q}
    (hs : TyStep (.all hp k body) t) :
    ∃ body', t = .all hp k body' ∧ TyStep body body' := by
  cases hs with
  | allBody h => exact ⟨_, rfl, h⟩

theorem TyReduces.all_inv {hp : p} {k : Kind} {body : Ty p q} {t : Ty p q}
    (hr : TyReduces (.all hp k body) t) :
    ∃ body', t = .all hp k body' ∧ TyReduces body body' := by
  generalize heq : Ty.all hp k body = src at hr
  induction hr generalizing body with
  | refl => subst heq; exact ⟨body, rfl, .refl⟩
  | step hs _ ih =>
    subst heq
    obtain ⟨body', rfl, hb⟩ := hs.all_inv
    obtain ⟨body'', rfl, hb'⟩ := ih rfl
    exact ⟨body'', rfl, .step hb hb'⟩

theorem TyEquiv.all_inj {hp : p} {k : Kind} {body : Ty p q}
    {hp' : p} {k' : Kind} {body' : Ty p q}
    (he : TyEquiv (.all hp k body) (.all hp' k' body')) :
    hp = hp' ∧ k = k' ∧ TyEquiv body body' := by
  obtain ⟨u, hr1, hr2⟩ := he
  obtain ⟨b1, rfl, hb1⟩ := hr1.all_inv
  obtain ⟨b2, heq, hb2⟩ := hr2.all_inv
  cases heq
  exact ⟨rfl, rfl, ⟨b1, hb1, hb2⟩⟩

-- ============================================================
-- TyStep/TyReduces/TyEquiv preservation under Ty.shift and Ty.subst
-- ============================================================

theorem tyStep_shift {s₁ s₂ : Ty p q} (hs : TyStep s₁ s₂) (d c : Nat) :
    TyStep (Ty.shift d c s₁) (Ty.shift d c s₂) := by
  induction hs generalizing c with
  | beta =>
    simp only [Ty.shift]
    rw [Ty.shift_subst_comm_gen d c 0 _ _ (Nat.zero_le c)]
    exact .beta
  | arrLeft _ ih => exact .arrLeft (ih c)
  | arrRight _ ih => exact .arrRight (ih c)
  | allBody _ ih => exact .allBody (ih (c + 1))
  | tyLamBody _ ih => exact .tyLamBody (ih (c + 1))
  | tyAppTyFn _ ih => exact .tyAppTyFn (ih c)
  | tyAppTyArg _ ih => exact .tyAppTyArg (ih c)

theorem tyReduces_shift {s₁ s₂ : Ty p q} (hr : TyReduces s₁ s₂) (d c : Nat) :
    TyReduces (Ty.shift d c s₁) (Ty.shift d c s₂) := by
  induction hr generalizing d c with
  | refl => exact .refl
  | step hs _ ih => exact .step (tyStep_shift hs d c) (ih d c)

theorem tyEquiv_shift {s₁ s₂ : Ty p q} (he : TyEquiv s₁ s₂) (d c : Nat) :
    TyEquiv (Ty.shift d c s₁) (Ty.shift d c s₂) := by
  obtain ⟨u, hr1, hr2⟩ := he
  exact ⟨Ty.shift d c u, tyReduces_shift hr1 d c, tyReduces_shift hr2 d c⟩

private theorem tyStep_subst {s₁ s₂ : Ty p q} (hs : TyStep s₁ s₂) (j : Nat) (σ : Ty p q) :
    TyStep (Ty.subst j σ s₁) (Ty.subst j σ s₂) := by
  induction hs generalizing j σ with
  | beta =>
    rename_i hq hq' ki body arg
    simp only [Ty.subst]
    rw [show Ty.subst j σ (Ty.subst 0 arg body) =
      Ty.subst 0 (Ty.subst j σ arg) (Ty.subst (j + 1) (σ.shift 1 0) body) from by
        have key := Ty.subst_subst_comm 0 j σ arg body
        simp only [Nat.zero_add] at key; exact key.symm]
    exact .beta
  | arrLeft _ ih => simp only [Ty.subst]; exact .arrLeft (ih j σ)
  | arrRight _ ih => simp only [Ty.subst]; exact .arrRight (ih j σ)
  | allBody _ ih => simp only [Ty.subst]; exact .allBody (ih (j + 1) (σ.shift 1 0))
  | tyLamBody _ ih => simp only [Ty.subst]; exact .tyLamBody (ih (j + 1) (σ.shift 1 0))
  | tyAppTyFn _ ih => simp only [Ty.subst]; exact .tyAppTyFn (ih j σ)
  | tyAppTyArg _ ih => simp only [Ty.subst]; exact .tyAppTyArg (ih j σ)

private theorem tyReduces_subst {s₁ s₂ : Ty p q} (hr : TyReduces s₁ s₂) (j : Nat) (σ : Ty p q) :
    TyReduces (Ty.subst j σ s₁) (Ty.subst j σ s₂) := by
  induction hr generalizing j σ with
  | refl => exact .refl
  | step hs _ ih => exact .step (tyStep_subst hs j σ) (ih j σ)

private theorem tyEquiv_subst {s₁ s₂ : Ty p q} (he : TyEquiv s₁ s₂) (j : Nat) (σ : Ty p q) :
    TyEquiv (Ty.subst j σ s₁) (Ty.subst j σ s₂) := by
  obtain ⟨u, hr1, hr2⟩ := he
  exact ⟨Ty.subst j σ u, tyReduces_subst hr1 j σ, tyReduces_subst hr2 j σ⟩

-- ============================================================
-- Generation (inversion) lemmas
-- ============================================================

/-- Lam generation: if a lambda has type T, then T is equivalent to an arrow type
    with the annotation as domain, the annotation is well-kinded, and the body
    is well-typed. -/
theorem HasType.lam_gen {Δ : KindContext} {ctx : Context p q}
    {ty : Ty p q} {body : Term p q} {T : Ty p q}
    (ht : HasType Δ ctx (.lam ty body) T) :
    ∃ retTy, TyEquiv T (.arr ty retTy) ∧ HasKind Δ ty .star ∧
      HasType Δ (ty :: ctx) body retTy := by
  generalize htm : Term.lam ty body = m at ht
  induction ht generalizing ty body with
  | var _ _ => cases htm
  | lam hk hbody => cases htm; exact ⟨_, TyEquiv.refl, hk, hbody⟩
  | app _ _ => cases htm
  | tyAbs _ _ => cases htm
  | tyApp _ _ _ => cases htm
  | const => cases htm
  | zero => cases htm
  | succ _ _ => cases htm
  | natrec _ _ _ _ _ => cases htm
  | conv _ heq _ ih =>
    obtain ⟨retTy, heq', hk, hbody⟩ := ih htm
    exact ⟨retTy, heq.symm.trans heq', hk, hbody⟩

/-- TyAbs generation: if a type abstraction has type T, then T is equivalent to a
    universal type, and the body is well-typed under an extended kind context. -/
theorem HasType.tyAbs_gen {Δ : KindContext} {ctx : Context p q}
    {hp : p} {k : Kind} {body : Term p q} {T : Ty p q}
    (ht : HasType Δ ctx (.tyAbs hp k body) T) :
    ∃ bodyTy, TyEquiv T (.all hp k bodyTy) ∧
      HasType (k :: Δ) (ctx.map (Ty.shift 1 0)) body bodyTy := by
  generalize htm : Term.tyAbs hp k body = m at ht
  induction ht generalizing hp k body with
  | var _ _ => cases htm
  | lam _ _ => cases htm
  | app _ _ => cases htm
  | tyAbs hp' hbody => cases htm; exact ⟨_, TyEquiv.refl, hbody⟩
  | tyApp _ _ _ => cases htm
  | const => cases htm
  | zero => cases htm
  | succ _ _ => cases htm
  | natrec _ _ _ _ _ => cases htm
  | conv _ heq _ ih =>
    obtain ⟨bodyTy, heq', hbody⟩ := ih htm
    exact ⟨bodyTy, heq.symm.trans heq', hbody⟩

/-- Succ generation: if a successor has type T, then T is equivalent to nat
    and the argument has type nat. -/
theorem HasType.succ_gen {Δ : KindContext} {ctx : Context p q}
    {t : Term p q} {T : Ty p q}
    (ht : HasType Δ ctx (.succ t) T) :
    TyEquiv T .nat ∧ HasType Δ ctx t .nat := by
  generalize htm : Term.succ t = m at ht
  induction ht generalizing t with
  | var _ _ => cases htm
  | lam _ _ => cases htm
  | app _ _ => cases htm
  | tyAbs _ _ => cases htm
  | tyApp _ _ _ => cases htm
  | const => cases htm
  | zero => cases htm
  | succ ht' => cases htm; exact ⟨TyEquiv.refl, ht'⟩
  | natrec _ _ _ _ _ => cases htm
  | conv _ heq _ ih =>
    obtain ⟨heq', ht'⟩ := ih htm
    exact ⟨heq.symm.trans heq', ht'⟩

-- ============================================================
-- Type shifting preserves typing
-- ============================================================

theorem ty_shift_preserves_typing {Δ : KindContext} {ctx : Context p q}
    {t : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (d c : Nat) (Δ' : KindContext)
    (hkind : ∀ n k, Δ[n]? = some k → Δ'[if n ≥ c then n + d else n]? = some k) :
    HasType Δ' (ctx.map (Ty.shift d c)) (t.tyShift d c) (Ty.shift d c ty) := by
  induction ht generalizing d c Δ' with
  | var hget hk =>
    simp only [Term.tyShift]; exact .var (by simp only [List.getElem?_map]; rw [hget]; rfl)
      (hk.rename d c hkind)
  | lam hk hbody ih =>
    simp only [Term.tyShift, Ty.shift]; exact .lam (hk.rename d c hkind) (ih d c Δ' hkind)
  | app hfn harg ihfn iharg =>
    simp only [Term.tyShift]
    have h1 := ihfn d c Δ' hkind; simp only [Ty.shift] at h1
    exact .app h1 (iharg d c Δ' hkind)
  | tyAbs hp hbody ih =>
    simp only [Term.tyShift, Ty.shift]
    apply HasType.tyAbs hp
    have hmap : ∀ (ctx : Context p q), (ctx.map (Ty.shift d c)).map (Ty.shift 1 0) =
        (ctx.map (Ty.shift 1 0)).map (Ty.shift d (c + 1)) := by
      intro ctx; simp only [List.map_map, Function.comp_def]
      congr 1; funext ty'; exact Ty.shift_shift_comm d 1 c 0 ty' (Nat.zero_le c)
    rw [hmap]; exact ih d (c + 1) _ (fun n k' hget' => by
      cases n with
      | zero =>
        simp only [List.getElem?_cons_zero] at hget' ⊢
        rw [if_neg (by omega), List.getElem?_cons_zero]; exact hget'
      | succ n =>
        simp only [List.getElem?_cons_succ] at hget'
        have h := hkind n k' hget'
        by_cases hn : n ≥ c
        · rw [if_pos hn] at h; rw [if_pos (by omega),
            show n + 1 + d = n + d + 1 from by omega,
            List.getElem?_cons_succ]; exact h
        · rw [if_neg hn] at h; rw [if_neg (by omega), List.getElem?_cons_succ]; exact h)
  | tyApp hp ht hk ih =>
    simp only [Term.tyShift]
    have ih_result := ih d c Δ' hkind; simp only [Ty.shift] at ih_result
    rw [show Ty.shift d c (Ty.subst 0 _ _) = Ty.subst 0 (Ty.shift d c _) (Ty.shift d (c + 1) _) from
      Ty.shift_subst_comm_gen d c 0 _ _ (Nat.zero_le c)]
    exact HasType.tyApp (argTy := Ty.shift d c _) hp ih_result (hk.rename d c hkind)
  | const => simp only [Term.tyShift, Ty.shift]; exact .const
  | zero => simp only [Term.tyShift]; exact .zero
  | succ _ ih => simp only [Term.tyShift]; exact .succ (ih d c Δ' hkind)
  | natrec hk _ _ _ ihbase ihstep ihn =>
    simp only [Term.tyShift]
    exact .natrec (hk.rename d c hkind) (ihbase d c Δ' hkind)
      (by have h := ihstep d c Δ' hkind; simp only [Ty.shift] at h; exact h)
      (by have h := ihn d c Δ' hkind; simp only [Ty.shift] at h; exact h)
  | conv ht heq hk ih =>
    exact .conv (ih d c Δ' hkind) (tyEquiv_shift heq d c) (hk.rename d c hkind)

theorem ty_shift_preserves_typing_weaken {Δ : KindContext} {ctx : Context p q}
    {t : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (extra : Kind) :
    HasType (extra :: Δ) (ctx.map (Ty.shift 1 0)) (t.tyShift 1 0) (Ty.shift 1 0 ty) :=
  ty_shift_preserves_typing ht 1 0 (extra :: Δ) (fun n k' hget => by
    simp [List.getElem?_cons_succ, hget])

-- ============================================================
-- Substitution lemma
-- ============================================================

theorem substitution_gen (j : Nat)
    {Δ : KindContext} {ctx : Context p q} {body : Term p q} {bodyTy sTy : Ty p q} {s : Term p q}
    (hbody : HasType Δ ctx body bodyTy)
    (hctx : ctx[j]? = some sTy)
    (hs : HasType Δ (ctx.eraseIdx j) s sTy) :
    HasType Δ (ctx.eraseIdx j) (Term.subst j s body) bodyTy := by
  induction hbody generalizing j s sTy with
  | var hget hk =>
    simp only [Term.subst]
    split
    · rename_i heq; subst heq; rw [hget] at hctx; cases hctx; exact hs
    · split
      · rename_i hne hjn
        exact .var (by rw [List.getElem?_eraseIdx, if_neg (by omega)]
                       exact hget ▸ congrArg _ (by omega)) hk
      · rename_i hne hnjlt
        exact .var (by rw [List.getElem?_eraseIdx, if_pos (by omega)]; exact hget) hk
  | lam hk hbody ih =>
    simp only [Term.subst]; exact .lam hk (by
      show HasType _ (((_ :: _) : Context p q).eraseIdx (j + 1)) _ _
      apply ih (j + 1)
      · simp only [List.getElem?_cons_succ]; exact hctx
      · simp only [List.eraseIdx_cons_succ]; exact weakening_cons hs _)
  | app _ _ ihfn iharg =>
    simp only [Term.subst]
    exact .app (ihfn j hctx hs) (iharg j hctx hs)
  | tyAbs hp hbody ih =>
    simp only [Term.subst]
    apply HasType.tyAbs hp
    have map_eraseIdx : ∀ (f : Ty p q → Ty p q) (l : List (Ty p q)) (k : Nat),
        (l.map f).eraseIdx k = (l.eraseIdx k).map f := by
      intro f l k; induction l generalizing k with
      | nil => simp [List.eraseIdx]
      | cons a l ih => cases k with
        | zero => simp [List.eraseIdx]
        | succ k => simp [List.eraseIdx, ih]
    rw [← map_eraseIdx]
    apply ih j
    · simp only [List.getElem?_map]; rw [hctx]; rfl
    · rw [map_eraseIdx]; exact ty_shift_preserves_typing_weaken hs _
  | tyApp hp _ hk ih =>
    simp only [Term.subst]
    exact .tyApp hp (ih j hctx hs) hk
  | const => simp only [Term.subst]; exact .const
  | zero => simp only [Term.subst]; exact .zero
  | succ _ ih => simp only [Term.subst]; exact .succ (ih j hctx hs)
  | natrec hk _ _ _ ihbase ihstep ihn =>
    simp only [Term.subst]; exact .natrec hk (ihbase j hctx hs) (ihstep j hctx hs) (ihn j hctx hs)
  | conv _ heq hk ih =>
    exact .conv (ih j hctx hs) heq hk

theorem substitution {Δ : KindContext} {ctx : Context p q} {body s : Term p q} {bodyTy sTy : Ty p q}
    (hbody : HasType Δ (sTy :: ctx) body bodyTy)
    (hs : HasType Δ ctx s sTy) :
    HasType Δ ctx (Term.subst 0 s body) bodyTy := by
  have h := substitution_gen 0 hbody (by simp) hs
  simpa using h

-- ============================================================
-- Type substitution (System F / F-omega)
-- ============================================================

theorem ty_substitution_gen (j : Nat) (tyArg : Ty p q) (k₀ : Kind)
    {Δ : KindContext} {ctx ctx' : Context p q} {t : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty)
    (hΔj : Δ[j]? = some k₀)
    (hkarg : HasKind (Δ.eraseIdx j) tyArg k₀)
    (hctx : ∀ (n : Nat) (ty : Ty p q), ctx[n]? = some ty →
      ctx'[n]? = some (Ty.subst j tyArg ty)) :
    HasType (Δ.eraseIdx j) ctx' (Term.tySubst j tyArg t) (Ty.subst j tyArg ty) := by
  induction ht generalizing j tyArg ctx' k₀ with
  | var hget hk =>
    simp only [Term.tySubst]
    exact .var (hctx _ _ hget) (hk.subst_gen j hΔj hkarg)
  | lam hk hbody ih =>
    simp only [Term.tySubst, Ty.subst]
    exact .lam (hk.subst_gen j hΔj hkarg) (ih j tyArg k₀ hΔj hkarg (fun n ty' hget' => by
      cases n with
      | zero =>
        simp only [List.getElem?_cons_zero] at hget' ⊢
        cases hget'; rfl
      | succ n =>
        simp only [List.getElem?_cons_succ] at hget' ⊢
        exact hctx n ty' hget'))
  | app hfn harg ihfn iharg =>
    simp only [Term.tySubst]
    have h1 := ihfn j tyArg k₀ hΔj hkarg hctx
    simp only [Ty.subst] at h1
    exact .app h1 (iharg j tyArg k₀ hΔj hkarg hctx)
  | tyAbs hp hbody ih =>
    simp only [Term.tySubst, Ty.subst]
    apply HasType.tyAbs hp
    have eraseIdx_succ : ∀ (a : Kind) (l : KindContext),
        (a :: l).eraseIdx (j + 1) = a :: l.eraseIdx j := by
      intro a l; simp [List.eraseIdx_cons_succ]
    rw [← eraseIdx_succ]
    apply ih (j + 1) (tyArg.shift 1 0) k₀
      (by simp only [List.getElem?_cons_succ]; exact hΔj)
      (by rw [eraseIdx_succ]; exact hkarg.weaken_cons _)
    intro n ty' hget'
    simp only [List.getElem?_map] at hget' ⊢
    obtain ⟨v, hv, hvty⟩ := Option.map_eq_some_iff.mp hget'
    have h := hctx n v hv
    rw [h]; simp only [Option.map]
    congr 1; subst hvty
    exact Ty.shift_subst_comm 0 j tyArg v (Nat.zero_le j)
  | tyApp hp ht hk ih =>
    simp only [Term.tySubst]
    have ih_result := ih j tyArg k₀ hΔj hkarg hctx
    simp only [Ty.subst] at ih_result
    have h2 : ∀ (a b : Ty p q), Ty.subst 0 (Ty.subst (0 + j) tyArg a)
        (Ty.subst (0 + j + 1) (Ty.shift 1 0 tyArg) b) =
        Ty.subst (0 + j) tyArg (Ty.subst 0 a b) :=
      fun a b => Ty.subst_subst_comm 0 j tyArg a b
    simp only [Nat.zero_add] at h2
    exact h2 _ _ ▸ HasType.tyApp hp ih_result (hk.subst_gen j hΔj hkarg)
  | const => simp only [Term.tySubst, Ty.subst]; exact .const
  | zero => simp only [Term.tySubst, Ty.subst]; exact .zero
  | succ _ ih =>
    simp only [Term.tySubst, Ty.subst]
    exact .succ (by have h := ih j tyArg k₀ hΔj hkarg hctx; simp only [Ty.subst] at h; exact h)
  | natrec hk _ _ _ ihbase ihstep ihn =>
    simp only [Term.tySubst]
    exact .natrec (hk.subst_gen j hΔj hkarg) (ihbase j tyArg k₀ hΔj hkarg hctx)
      (by have h := ihstep j tyArg k₀ hΔj hkarg hctx; simp only [Ty.subst] at h; exact h)
      (by have h := ihn j tyArg k₀ hΔj hkarg hctx; simp only [Ty.subst] at h; exact h)
  | conv ht heq hk ih =>
    exact .conv (ih j tyArg k₀ hΔj hkarg hctx) (tyEquiv_subst heq j tyArg) (hk.subst_gen j hΔj hkarg)

theorem ty_substitution {Δ : KindContext} {ctx : Context p q}
    {t : Term p q} {ty : Ty p q} {k : Kind} {argTy : Ty p q}
    (ht : HasType (k :: Δ) (ctx.map (Ty.shift 1 0)) t ty)
    (hkarg : HasKind Δ argTy k) :
    HasType Δ ctx (Term.tySubst 0 argTy t) (Ty.subst 0 argTy ty) := by
  have h := ty_substitution_gen 0 argTy k ht (by simp) (by simpa using hkarg)
    (fun n ty' hget' => by
      simp only [List.getElem?_map] at hget'
      obtain ⟨v, hv, hvty⟩ := Option.map_eq_some_iff.mp hget'
      subst hvty
      rw [hv, Ty.subst_shift_cancel])
  simpa using h

-- ============================================================
-- Preservation
-- ============================================================

/-- Preservation: if Δ; Γ ⊢ t : T and t ⟶ t', then Δ; Γ ⊢ t' : T -/
theorem preservation {Δ : KindContext} {ctx : Context p q} {t t' : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (hs : Step t t') :
    HasType Δ ctx t' ty := by
  induction ht generalizing t' with
  | var hget _ =>
    cases hs
  | lam _ _ =>
    cases hs
  | app hfn harg ihfn iharg =>
    cases hs with
    | beta hv =>
      -- fn = .lam annotTy body, so use lam generation on hfn
      obtain ⟨retTy, heq_arr, hk_annot, hbody⟩ := hfn.lam_gen
      obtain ⟨heq_arg, heq_ret⟩ := heq_arr.arr_inj
      -- Convert argument type: argTy → annotTy (kinding from lam_gen)
      have harg' := HasType.conv harg heq_arg hk_annot
      -- Substitute to get body[0:=v] : retTy
      have hsub := substitution hbody harg'
      -- Convert return type: retTy → retTy₀ (kinding from well_kinded of the app)
      have hk_ret := (HasType.app hfn harg).well_kinded
      exact HasType.conv hsub heq_ret.symm hk_ret
    | appFn hs' =>
      exact .app (ihfn hs') harg
    | appArg hv hs' =>
      exact .app hfn (iharg hs')
  | tyAbs hp _ =>
    cases hs
  | const =>
    cases hs
  | zero =>
    cases hs
  | succ _ ih =>
    cases hs with
    | succArg hs' => exact .succ (ih hs')
  | natrec hk hbase hstep hn ihbase ihstep ihn =>
    cases hs with
    | recZero => exact hbase
    | recSucc hv =>
      obtain ⟨_, hv_nat⟩ := hn.succ_gen
      exact .app (.app hstep hv_nat) (.natrec hk hbase hstep hv_nat)
    | recArg hs' => exact .natrec hk hbase hstep (ihn hs')
  | tyApp hp ht' hk ih =>
    cases hs with
    | tyBeta =>
      obtain ⟨bodyTy', heq_all, hbody⟩ := ht'.tyAbs_gen
      obtain ⟨_, hk_eq, heq_body⟩ := heq_all.all_inj
      subst hk_eq
      have hsub := ty_substitution hbody hk
      -- Convert from bodyTy' to bodyTy (kinding from well_kinded of the tyApp)
      have hk_result := (HasType.tyApp hp ht' hk).well_kinded
      exact HasType.conv hsub (tyEquiv_subst heq_body.symm 0 _) hk_result
    | tyAppFn hs' =>
      exact .tyApp hp (ih hs') hk
  | conv ht' heq hk ih =>
    exact .conv (ih hs) heq hk

end LambdaCalculi
