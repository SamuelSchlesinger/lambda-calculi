import LambdaCalculi.Typing
import LambdaCalculi.Reduction
import LambdaCalculi.Subst
import LambdaCalculi.Weakening

namespace LambdaCalculi

/-! ## Preservation Theorem

If a well-typed term takes a step, the result is well-typed at the same type.
Requires weakening and the substitution lemma as key ingredients. -/

-- ============================================================
-- Weakening
-- ============================================================

-- weakening_cons is imported from LambdaCalculi.Weakening

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
  | tyAbs hp _ ih =>
    sorry
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

/-- Type substitution preserves typing -/
theorem ty_substitution {ctx : Context p} {t : Term p} {ty argTy : Ty p}
    (ht : HasType (ctx.map (Ty.shift 1 0)) t ty) :
    HasType ctx (Term.tySubst 0 argTy t) (Ty.subst 0 argTy ty) := by
  sorry

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
