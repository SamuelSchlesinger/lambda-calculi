import LambdaCalculi.Typing
import LambdaCalculi.Reduction
import LambdaCalculi.Subst
import LambdaCalculi.Weakening
import LambdaCalculi.TySubstLemmas

namespace LambdaCalculi

/-! ## Preservation Theorem

If a well-typed term takes a step, the result is well-typed at the same type.
Requires weakening and the substitution lemma as key ingredients. -/

-- ============================================================
-- Weakening
-- ============================================================

-- weakening_cons is imported from LambdaCalculi.Weakening

-- ============================================================
-- Type shifting preserves typing (needed for substitution under Λ)
-- ============================================================

/-- Type shifting preserves typing: if Γ ⊢ t : τ, then
    Γ.map (Ty.shift d c) ⊢ t.tyShift d c : Ty.shift d c τ.
    This is needed when substituting a term under a type binder (Λ),
    because the type annotations in the substitutee must be shifted
    to match the shifted context. -/
theorem ty_shift_preserves_typing {ctx : Context p} {t : Term p} {ty : Ty p}
    (ht : HasType ctx t ty) (d c : Nat) :
    HasType (ctx.map (Ty.shift d c)) (t.tyShift d c) (Ty.shift d c ty) := by
  induction ht generalizing d c with
  | var hget =>
    simp only [Term.tyShift]; constructor
    simp only [List.getElem?_map]; rw [hget]; rfl
  | lam hbody ih =>
    simp only [Term.tyShift, Ty.shift]; constructor; exact ih d c
  | app hfn harg ihfn iharg =>
    simp only [Term.tyShift]
    have h1 := ihfn d c; simp only [Ty.shift] at h1
    exact .app h1 (iharg d c)
  | tyAbs hp hbody ih =>
    simp only [Term.tyShift, Ty.shift]
    apply HasType.tyAbs hp
    have hmap : ∀ (ctx : Context p), (ctx.map (Ty.shift d c)).map (Ty.shift 1 0) =
        (ctx.map (Ty.shift 1 0)).map (Ty.shift d (c + 1)) := by
      intro ctx; simp only [List.map_map, Function.comp_def]
      congr 1; funext ty'; exact Ty.shift_shift_comm d 1 c 0 ty' (Nat.zero_le c)
    rw [hmap]; exact ih d (c + 1)
  | tyApp hp ht ih =>
    simp only [Term.tyShift]
    have ih_result := ih d c; simp only [Ty.shift] at ih_result
    rw [show Ty.shift d c (Ty.subst 0 _ _) = Ty.subst 0 (Ty.shift d c _) (Ty.shift d (c + 1) _) from
      Ty.shift_subst_comm_gen d c 0 _ _ (Nat.zero_le c)]
    exact HasType.tyApp (argTy := Ty.shift d c _) hp ih_result

-- ============================================================
-- Substitution lemma
-- ============================================================

/-- Generalized substitution at position j -/
theorem substitution_gen (j : Nat)
    {ctx : Context p} {body : Term p} {bodyTy sTy : Ty p} {s : Term p}
    (hbody : HasType ctx body bodyTy)
    (hctx : ctx[j]? = some sTy)
    (hs : HasType (ctx.eraseIdx j) s sTy) :
    HasType (ctx.eraseIdx j) (Term.subst j s body) bodyTy := by
  induction hbody generalizing j s sTy with
  | var hget =>
    simp only [Term.subst]
    split
    · -- k = j
      rename_i h; subst h
      rw [hget] at hctx; cases hctx; exact hs
    · split
      · -- j < k
        rename_i hne hjk
        constructor
        rw [List.getElem?_eraseIdx]
        rename_i n _
        have h1 : ¬ (n - 1 < j) := by omega
        rw [if_neg h1]
        have h2 : n - 1 + 1 = n := by omega
        rw [h2]; exact hget
      · -- k < j
        rename_i hne hnjk
        constructor
        rw [List.getElem?_eraseIdx]
        rename_i n _
        have h1 : n < j := by omega
        rw [if_pos h1]; exact hget
  | lam _ ih =>
    simp only [Term.subst]
    constructor
    have heq : ∀ (a : Ty p) (c : Context p),
        (a :: c).eraseIdx (j + 1) = a :: c.eraseIdx j := by
      intro a c; simp [List.eraseIdx_cons_succ]
    rename_i argTy ctx' _ _
    rw [← heq]
    apply ih (j + 1)
    · simp only [List.getElem?_cons_succ]; exact hctx
    · rw [heq]; exact weakening_cons hs _
  | app _ _ ihfn iharg =>
    simp only [Term.subst]
    exact .app (ihfn j hctx hs) (iharg j hctx hs)
  | tyAbs hp hbody ih =>
    -- hbody : HasType (ctx'.map (Ty.shift 1 0)) body' ty'  (for some ctx')
    -- hctx : ctx'[j]? = some sTy
    -- hs : HasType (ctx'.eraseIdx j) s sTy
    -- Goal: HasType (ctx'.eraseIdx j) (.tyAbs hp (Term.subst j (s.tyShift 1 0) body')) (.all hp ty')
    simp only [Term.subst]
    apply HasType.tyAbs hp
    -- Apply IH to the body (typed in ctx'.map (Ty.shift 1 0)) with:
    -- - shifted context lookup: (ctx'.map (Ty.shift 1 0))[j]? = some (Ty.shift 1 0 sTy)
    -- - shifted substitute: HasType ((ctx'.eraseIdx j).map (Ty.shift 1 0)) (s.tyShift 1 0) (Ty.shift 1 0 sTy)
    have map_eraseIdx : ∀ (f : Ty p → Ty p) (l : List (Ty p)) (k : Nat),
        (l.map f).eraseIdx k = (l.eraseIdx k).map f := by
      intro f l k; induction l generalizing k with
      | nil => simp [List.eraseIdx]
      | cons a l ih => cases k with
        | zero => simp [List.eraseIdx]
        | succ k => simp [List.eraseIdx, ih]
    rw [← map_eraseIdx]
    apply ih j
    · simp only [List.getElem?_map]; rw [hctx]; rfl
    · rw [map_eraseIdx]
      exact ty_shift_preserves_typing hs 1 0
  | tyApp hp _ ih =>
    simp only [Term.subst]
    exact .tyApp hp (ih j hctx hs)

/-- Substitution lemma: if (S :: Γ) ⊢ t : T and Γ ⊢ s : S, then Γ ⊢ t[0:=s] : T -/
theorem substitution {ctx : Context p} {body s : Term p} {bodyTy sTy : Ty p}
    (hbody : HasType (sTy :: ctx) body bodyTy)
    (hs : HasType ctx s sTy) :
    HasType ctx (Term.subst 0 s body) bodyTy := by
  have h := substitution_gen 0 hbody (by simp) hs
  simpa using h

-- ============================================================
-- Type substitution (System F)
-- ============================================================

/-- Generalized type substitution preserves typing: if Γ ⊢ t : τ and
    every type in Γ maps to its type-substituted version in Γ', then
    Γ' ⊢ t.tySubst j tyArg : τ.subst j tyArg. -/
theorem ty_substitution_gen (j : Nat) (tyArg : Ty p)
    {ctx ctx' : Context p} {t : Term p} {ty : Ty p}
    (ht : HasType ctx t ty)
    (hctx : ∀ (n : Nat) (ty : Ty p), ctx[n]? = some ty → ctx'[n]? = some (Ty.subst j tyArg ty)) :
    HasType ctx' (Term.tySubst j tyArg t) (Ty.subst j tyArg ty) := by
  induction ht generalizing j tyArg ctx' with
  | var hget =>
    simp only [Term.tySubst]
    exact .var (hctx _ _ hget)
  | lam hbody ih =>
    simp only [Term.tySubst, Ty.subst]
    exact .lam (ih j tyArg (fun n ty' hget' => by
      cases n with
      | zero =>
        simp only [List.getElem?_cons_zero] at hget' ⊢
        cases hget'; rfl
      | succ n =>
        simp only [List.getElem?_cons_succ] at hget' ⊢
        exact hctx n ty' hget'))
  | app hfn harg ihfn iharg =>
    simp only [Term.tySubst]
    have h1 := ihfn j tyArg hctx
    simp only [Ty.subst] at h1
    exact .app h1 (iharg j tyArg hctx)
  | tyAbs hp hbody ih =>
    simp only [Term.tySubst, Ty.subst]
    apply HasType.tyAbs hp
    apply ih (j + 1) (tyArg.shift 1 0)
    intro n ty' hget'
    simp only [List.getElem?_map] at hget' ⊢
    obtain ⟨v, hv, hvty⟩ := Option.map_eq_some_iff.mp hget'
    have h := hctx n v hv
    rw [h]; simp only [Option.map]
    congr 1; subst hvty
    exact Ty.shift_subst_comm 0 j tyArg v (Nat.zero_le j)
  | tyApp hp ht ih =>
    simp only [Term.tySubst]
    have ih_result := ih j tyArg hctx
    simp only [Ty.subst] at ih_result
    have h2 : ∀ a b, Ty.subst 0 (Ty.subst (0 + j) tyArg a) (Ty.subst (0 + j + 1) (Ty.shift 1 0 tyArg) b) =
              Ty.subst (0 + j) tyArg (Ty.subst 0 a b) := fun a b => Ty.subst_subst_comm 0 j tyArg a b
    simp only [Nat.zero_add] at h2
    exact h2 _ _ ▸ @HasType.tyApp p ctx' _ _ (Ty.subst j tyArg _) hp ih_result

/-- Type substitution preserves typing: instantiating a type variable
    in a term typed under a shifted context. -/
theorem ty_substitution {ctx : Context p} {t : Term p} {ty argTy : Ty p}
    (ht : HasType (ctx.map (Ty.shift 1 0)) t ty) :
    HasType ctx (Term.tySubst 0 argTy t) (Ty.subst 0 argTy ty) := by
  apply ty_substitution_gen 0 argTy ht
  intro n ty' hget'
  simp only [List.getElem?_map] at hget'
  obtain ⟨v, hv, hvty⟩ := Option.map_eq_some_iff.mp hget'
  subst hvty
  rw [hv, Ty.subst_shift_cancel]

-- ============================================================
-- Preservation
-- ============================================================

/-- Preservation: if Γ ⊢ t : T and t ⟶ t', then Γ ⊢ t' : T -/
theorem preservation {ctx : Context p} {t t' : Term p} {ty : Ty p}
    (ht : HasType ctx t ty) (hs : Step t t') :
    HasType ctx t' ty := by
  induction ht generalizing t' with
  | var hget =>
    -- Variables can't step
    cases hs
  | lam _ =>
    -- Lambdas are values, can't step
    cases hs
  | app hfn harg ihfn iharg =>
    cases hs with
    | beta hv =>
      -- (λτ. body) v ⟶ body[0 := v]
      -- hfn : HasType ctx (lam τ body) (arr argTy retTy)
      cases hfn with
      | lam hbody =>
        -- hbody : HasType (argTy :: ctx) body retTy
        -- harg  : HasType ctx v argTy
        exact substitution hbody harg
    | appFn hs' =>
      exact .app (ihfn hs') harg
    | appArg hv hs' =>
      exact .app hfn (iharg hs')
  | tyAbs hp _ =>
    -- Type abstractions are values, can't step
    cases hs
  | tyApp hp ht' ih =>
    cases hs with
    | tyBeta =>
      -- (Λ. body) [σ] ⟶ body.tySubst 0 σ
      cases ht' with
      | tyAbs hp' hbody =>
        exact ty_substitution hbody
    | tyAppFn hs' =>
      exact .tyApp hp (ih hs')

end LambdaCalculi
