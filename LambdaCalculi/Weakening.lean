import LambdaCalculi.Typing

namespace LambdaCalculi

/-! ## Weakening

We prove weakening using a context-mapping formulation: if every variable
lookup in `ctx` corresponds to a lookup in `ctx'` (with shifted indices),
then typing in `ctx` implies typing in `ctx'` (with shifted term). -/

/-- General renaming/weakening: if every variable in `ctx` maps to the
    corresponding type in `ctx'` (via shifting), then typing is preserved. -/
theorem weakening_map (pos : Nat)
    {ctx ctx' : Context p} {t : Term p} {ty : Ty p}
    (hctx : ∀ n ty, ctx[n]? = some ty →
      ctx'[if n ≥ pos then n + 1 else n]? = some ty)
    (ht : HasType ctx t ty) :
    HasType ctx' (t.shift 1 pos) ty := by
  induction ht generalizing pos ctx' with
  | var hget =>
    exact .var (hctx _ _ hget)
  | lam hbody ih =>
    exact .lam (ih (pos + 1) (fun n ty' hget' => by
      cases n with
      | zero =>
        simp only [List.getElem?_cons_zero] at hget'
        have : ¬ (0 ≥ pos + 1) := by omega
        rw [if_neg this, List.getElem?_cons_zero]
        exact hget'
      | succ n =>
        simp only [List.getElem?_cons_succ] at hget'
        have h := hctx n ty' hget'
        by_cases hn : n ≥ pos
        · rw [if_pos hn] at h
          have h1 : n + 1 ≥ pos + 1 := by omega
          rw [if_pos h1]
          rw [show n + 1 + 1 = (n + 1) + 1 from rfl]
          rw [List.getElem?_cons_succ]
          exact h
        · rw [if_neg hn] at h
          have h1 : ¬ (n + 1 ≥ pos + 1) := by omega
          rw [if_neg h1]
          rw [List.getElem?_cons_succ]
          exact h))
  | app hfn harg ihfn iharg =>
    exact .app (ihfn pos hctx) (iharg pos hctx)
  | tyAbs hp hbody ih =>
    apply HasType.tyAbs hp
    apply ih (pos := pos)
    intro n ty' hget'
    simp only [List.getElem?_map] at hget' ⊢
    -- hget' : Option.map (Ty.shift 1 0) (ctx.map (Ty.shift 1 0))[n]? = some ty'
    -- Actually, the IH's "ctx" is `ctx.map (Ty.shift 1 0)`.
    -- The mapped ctx' is `ctx'.map (Ty.shift 1 0)`.
    -- We need: Option.map (Ty.shift 1 0) ctx'[if n ≥ pos then n+1 else n]? = some ty'
    -- From hget': Option.map (Ty.shift 1 0) ctx[n]? = some ty'
    -- From hctx applied to the underlying value: ctx'[if n ≥ pos then n+1 else n]? = some (underlying value)
    -- After simp [List.getElem?_map]:
    -- hget' : Option.map (Ty.shift 1 0) ctx✝[n]? = some ty'
    -- goal : Option.map (Ty.shift 1 0) ctx'[if n ≥ pos then n+1 else n]? = some ty'
    -- where ctx✝ is the original context from the tyAbs rule.
    -- We rewrite List.getElem?_map in reverse to turn
    --   Option.map f l[i]? into (l.map f)[i]?
    -- Actually let's just work with the Option.map form directly.
    -- hget' says ctx✝[n]?.map (Ty.shift 1 0) = some ty'
    -- This means ∃ v, ctx✝[n]? = some v ∧ Ty.shift 1 0 v = ty'
    obtain ⟨v, hv, hvty⟩ := Option.map_eq_some_iff.mp hget'
    have h := hctx n v hv
    rw [h]
    simp [hvty]
  | tyApp hp ht ih =>
    exact .tyApp hp (ih pos hctx)

/-- Weakening at the front: adding a type to the context preserves typing. -/
theorem weakening_cons {ctx : Context p} {t : Term p} {ty : Ty p}
    (ht : HasType ctx t ty) (extra : Ty p) :
    HasType (extra :: ctx) (t.shift 1 0) ty := by
  apply weakening_map 0 _ ht
  intro n ty' hget
  simp only [Nat.zero_le, ↓reduceIte, List.getElem?_cons_succ]
  exact hget

end LambdaCalculi
