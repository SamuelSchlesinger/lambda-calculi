import LambdaCalculi.Typing

namespace LambdaCalculi

/-! ## Weakening

We prove weakening using a context-mapping formulation: if every variable
lookup in `ctx` corresponds to a lookup in `ctx'` (with shifted indices),
then typing in `ctx` implies typing in `ctx'` (with shifted term). -/

/-- General renaming/weakening: if every variable in `ctx` maps to the
    corresponding type in `ctx'` (via shifting), then typing is preserved. -/
theorem weakening_map (pos : Nat)
    {Δ : KindContext} {ctx ctx' : Context p q} {t : Term p q} {ty : Ty p q}
    (hctx : ∀ n ty, ctx[n]? = some ty →
      ctx'[if n ≥ pos then n + 1 else n]? = some ty)
    (ht : HasType Δ ctx t ty) :
    HasType Δ ctx' (t.shift 1 pos) ty := by
  induction ht generalizing pos ctx' with
  | var hget hk =>
    exact .var (hctx _ _ hget) hk
  | lam hk hbody ih =>
    exact .lam hk (ih (pos + 1) (fun n ty' hget' => by
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
    obtain ⟨v, hv, hvty⟩ := Option.map_eq_some_iff.mp hget'
    have h := hctx n v hv
    rw [h]
    simp [hvty]
  | tyApp hp ht hk ih =>
    exact .tyApp hp (ih pos hctx) hk
  | const => exact .const
  | zero => exact .zero
  | succ _ ih => exact .succ (ih pos hctx)
  | natrec hk _ _ _ ihbase ihstep ihn =>
    exact .natrec hk (ihbase pos hctx) (ihstep pos hctx) (ihn pos hctx)
  | conv ht heq hk ih =>
    exact .conv (ih pos hctx) heq hk

/-- Weakening at the front: adding a type to the context preserves typing. -/
theorem weakening_cons {Δ : KindContext} {ctx : Context p q} {t : Term p q} {ty : Ty p q}
    (ht : HasType Δ ctx t ty) (extra : Ty p q) :
    HasType Δ (extra :: ctx) (t.shift 1 0) ty := by
  apply weakening_map 0 _ ht
  intro n ty' hget
  simp only [Nat.zero_le, ↓reduceIte, List.getElem?_cons_succ]
  exact hget

end LambdaCalculi
