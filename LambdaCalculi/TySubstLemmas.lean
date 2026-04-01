import LambdaCalculi.Subst

namespace LambdaCalculi

/-! ## Auxiliary lemmas about Ty.shift and Ty.subst

These lemmas establish the key properties of de Bruijn shifting and substitution
for types, needed for the type substitution preservation theorem in System F / F-omega. -/

-- ============================================================
-- Ty.shift lemmas
-- ============================================================

/-- Shifting by 0 is the identity. -/
theorem Ty.shift_zero (c : Nat) (ty : Ty p q) : Ty.shift 0 c ty = ty := by
  induction ty generalizing c with
  | base n => simp [Ty.shift]
  | arr a b iha ihb => simp [Ty.shift, iha, ihb]
  | tvar hpq k => simp only [Ty.shift]; split <;> simp
  | all hp ki body ih => simp [Ty.shift, ih]
  | tyLam hq ki body ih => simp [Ty.shift, ih]
  | tyAppTy hq f a ihf iha => simp [Ty.shift, ihf, iha]
  | nat => simp [Ty.shift]

/-- Two shifts at compatible cutoffs commute (with adjusted cutoffs). -/
theorem Ty.shift_shift_comm (d1 d2 c1 c2 : Nat) (ty : Ty p q) (h : c2 ≤ c1) :
    Ty.shift d2 c2 (Ty.shift d1 c1 ty) = Ty.shift d1 (c1 + d2) (Ty.shift d2 c2 ty) := by
  induction ty generalizing c1 c2 with
  | base n => simp [Ty.shift]
  | arr a b iha ihb =>
    simp only [Ty.shift]
    exact congr (congrArg Ty.arr (iha c1 c2 h)) (ihb c1 c2 h)
  | tvar hpq k =>
    simp only [Ty.shift]
    split <;> split <;> (try split) <;> (try split) <;>
      (first | omega | rfl | (congr 1; omega))
  | all hp ki body ih =>
    simp only [Ty.shift]; congr 1
    rw [show c1 + d2 + 1 = c1 + 1 + d2 from by omega]
    exact ih (c1 + 1) (c2 + 1) (by omega)
  | tyLam hq ki body ih =>
    simp only [Ty.shift]; congr 1
    rw [show c1 + d2 + 1 = c1 + 1 + d2 from by omega]
    exact ih (c1 + 1) (c2 + 1) (by omega)
  | tyAppTy hq f a ihf iha =>
    simp only [Ty.shift]
    exact congr (congrArg (Ty.tyAppTy hq) (ihf c1 c2 h)) (iha c1 c2 h)
  | nat => simp [Ty.shift]

-- ============================================================
-- Shift-subst interaction lemmas
-- ============================================================

/-- Substituting after shifting by 1 at the same cutoff cancels out. -/
theorem Ty.subst_shift_cancel (j : Nat) (s : Ty p q) (ty : Ty p q) :
    Ty.subst j s (Ty.shift 1 j ty) = ty := by
  induction ty generalizing j s with
  | base n => simp [Ty.shift, Ty.subst]
  | arr a b iha ihb => simp [Ty.shift, Ty.subst, iha, ihb]
  | tvar hpq k =>
    simp only [Ty.shift, Ty.subst]
    split <;> split <;> (try split) <;> first | omega | rfl | (congr 1; omega)
  | all hp ki body ih =>
    simp only [Ty.shift, Ty.subst]; congr 1
    exact ih (j + 1) (s.shift 1 0)
  | tyLam hq ki body ih =>
    simp only [Ty.shift, Ty.subst]; congr 1
    exact ih (j + 1) (s.shift 1 0)
  | tyAppTy hq f a ihf iha => simp [Ty.shift, Ty.subst, ihf, iha]
  | nat => simp [Ty.shift, Ty.subst]

/-- Shifting by 1 commutes with substitution (with adjusted indices). -/
theorem Ty.shift_subst_comm (c j : Nat) (s ty : Ty p q) (h : c ≤ j) :
    Ty.shift 1 c (Ty.subst j s ty) = Ty.subst (j + 1) (s.shift 1 c) (Ty.shift 1 c ty) := by
  induction ty generalizing c j s with
  | base n => simp [Ty.shift, Ty.subst]
  | arr a b iha ihb =>
    simp only [Ty.shift, Ty.subst]
    exact congr (congrArg Ty.arr (iha c j s h)) (ihb c j s h)
  | tvar hpq k =>
    by_cases hkj : k = j
    · subst hkj
      simp only [Ty.subst, ite_true, Ty.shift, if_pos (show k ≥ c by omega), ite_true]
    · by_cases hjk : j < k
      · simp only [Ty.subst, if_neg hkj, if_pos hjk,
                   Ty.shift, if_pos (show k - 1 ≥ c from by omega),
                   if_pos (show k ≥ c from by omega)]
        rw [if_neg (show ¬(k + 1 = j + 1) from by omega),
            if_pos (show j + 1 < k + 1 from by omega)]
        congr 1; omega
      · by_cases hkc : k ≥ c
        · simp only [Ty.subst, if_neg hkj, if_neg hjk, Ty.shift, if_pos hkc]
          rw [if_neg (show ¬(k + 1 = j + 1) from by omega),
              if_neg (show ¬(j + 1 < k + 1) from by omega)]
        · simp only [Ty.subst, if_neg hkj, if_neg hjk, Ty.shift, if_neg hkc]
          rw [if_neg (show ¬(k = j + 1) from by omega),
              if_neg (show ¬(j + 1 < k) from by omega)]
  | all hp ki body ih =>
    simp only [Ty.shift, Ty.subst]; congr 1
    rw [show (s.shift 1 c).shift 1 0 = (s.shift 1 0).shift 1 (c + 1) from
      Ty.shift_shift_comm 1 1 c 0 s (Nat.zero_le c)]
    exact ih (c + 1) (j + 1) (s.shift 1 0) (by omega)
  | tyLam hq ki body ih =>
    simp only [Ty.shift, Ty.subst]; congr 1
    rw [show (s.shift 1 c).shift 1 0 = (s.shift 1 0).shift 1 (c + 1) from
      Ty.shift_shift_comm 1 1 c 0 s (Nat.zero_le c)]
    exact ih (c + 1) (j + 1) (s.shift 1 0) (by omega)
  | tyAppTy hq f a ihf iha =>
    simp only [Ty.shift, Ty.subst]
    exact congr (congrArg (Ty.tyAppTy hq) (ihf c j s h)) (iha c j s h)
  | nat => simp [Ty.shift, Ty.subst]

-- ============================================================
-- Subst-subst commutation
-- ============================================================

/-- Two substitutions at compatible indices commute.
    This is the key lemma for the tyApp case of type substitution preservation. -/
theorem Ty.subst_subst_comm (i j : Nat) (s a : Ty p q) (b : Ty p q) :
    Ty.subst i (Ty.subst (i + j) s a) (Ty.subst (i + j + 1) (s.shift 1 i) b) =
    Ty.subst (i + j) s (Ty.subst i a b) := by
  induction b generalizing i j s a with
  | base n => simp [Ty.subst]
  | arr b1 b2 ih1 ih2 =>
    simp only [Ty.subst]
    exact congr (congrArg Ty.arr (ih1 i j s a)) (ih2 i j s a)
  | tvar hpq k =>
    simp only [Ty.subst]
    by_cases hk1 : k = i + j + 1
    · subst hk1
      simp only [ite_true]
      rw [Ty.subst_shift_cancel i (Ty.subst (i + j) s a) s]
      rw [if_neg (show ¬(i + j + 1 = i) from by omega),
          if_pos (show i < i + j + 1 from by omega)]
      have : i + j + 1 - 1 = i + j := by omega
      rw [this, Ty.subst, if_pos rfl]
    · by_cases hk2 : i + j + 1 < k
      · simp only [if_neg hk1, if_pos hk2, Ty.subst,
                   if_neg (show ¬(k - 1 = i) from by omega),
                   if_pos (show i < k - 1 from by omega),
                   if_neg (show ¬(k = i) from by omega),
                   if_pos (show i < k from by omega),
                   if_neg (show ¬(k - 1 = i + j) from by omega),
                   if_pos (show i + j < k - 1 from by omega)]
      · simp only [if_neg hk1, if_neg hk2]
        by_cases hk3 : k = i
        · subst hk3
          simp only [Ty.subst, ite_true]
        · by_cases hk4 : i < k
          · simp only [Ty.subst, if_neg hk3, if_pos hk4,
                       if_neg (show ¬(k - 1 = i + j) from by omega),
                       if_neg (show ¬(i + j < k - 1) from by omega)]
          · simp only [Ty.subst, if_neg hk3, if_neg hk4,
                       if_neg (show ¬(k = i + j) from by omega),
                       if_neg (show ¬(i + j < k) from by omega)]
  | all hp ki body ih =>
    simp only [Ty.subst]; congr 1
    rw [Ty.shift_subst_comm 0 (i + j) s a (Nat.zero_le _)]
    rw [Ty.shift_shift_comm 1 1 i 0 s (Nat.zero_le _)]
    rw [Nat.add_right_comm i j 1]
    exact ih (i + 1) j (s.shift 1 0) (a.shift 1 0)
  | tyLam hq ki body ih =>
    simp only [Ty.subst]; congr 1
    rw [Ty.shift_subst_comm 0 (i + j) s a (Nat.zero_le _)]
    rw [Ty.shift_shift_comm 1 1 i 0 s (Nat.zero_le _)]
    rw [Nat.add_right_comm i j 1]
    exact ih (i + 1) j (s.shift 1 0) (a.shift 1 0)
  | tyAppTy hq f a' ihf iha =>
    simp only [Ty.subst]
    exact congr (congrArg (Ty.tyAppTy hq) (ihf i j s a)) (iha i j s a)
  | nat => simp [Ty.subst]

/-- Shifting commutes with substitution when the substitution index is below the shift cutoff.
    Specifically: shift d c (subst j s ty) = subst j (shift d c s) (shift d (c+1) ty) when j ≤ c. -/
theorem Ty.shift_subst_comm_gen (d c j : Nat) (s ty : Ty p q) (h : j ≤ c) :
    Ty.shift d c (Ty.subst j s ty) = Ty.subst j (Ty.shift d c s) (Ty.shift d (c + 1) ty) := by
  induction ty generalizing c j s with
  | base n => simp [Ty.shift, Ty.subst]
  | arr a b iha ihb =>
    simp only [Ty.shift, Ty.subst]
    exact congr (congrArg Ty.arr (iha c j s h)) (ihb c j s h)
  | tvar hpq k =>
    simp only [Ty.subst]
    by_cases hkj : k = j
    · subst hkj
      simp only [ite_true, Ty.shift, if_neg (show ¬(k ≥ c + 1) from by omega), Ty.subst, ite_true]
    · by_cases hjk : j < k
      · simp only [if_neg hkj, if_pos hjk, Ty.shift]
        by_cases hkc : k - 1 ≥ c
        · simp only [if_pos hkc, if_pos (show k ≥ c + 1 from by omega), Ty.subst,
                     if_neg (show ¬(k + d = j) from by omega),
                     if_pos (show j < k + d from by omega)]
          congr 1; omega
        · simp only [if_neg hkc, if_neg (show ¬(k ≥ c + 1) from by omega), Ty.subst,
                     if_neg (show ¬(k = j) from by omega),
                     if_pos (show j < k from by omega)]
      · simp only [Ty.shift, if_neg (show ¬(k ≥ c) from by omega),
                   if_neg (show ¬(k ≥ c + 1) from by omega),
                   Ty.subst, if_neg hkj, if_neg hjk]
  | all hp ki body ih =>
    simp only [Ty.shift, Ty.subst]; congr 1
    rw [show (Ty.shift d c s).shift 1 0 = Ty.shift d (c + 1) (s.shift 1 0) from
      Ty.shift_shift_comm d 1 c 0 s (Nat.zero_le c)]
    exact ih (c + 1) (j + 1) (s.shift 1 0) (by omega)
  | tyLam hq ki body ih =>
    simp only [Ty.shift, Ty.subst]; congr 1
    rw [show (Ty.shift d c s).shift 1 0 = Ty.shift d (c + 1) (s.shift 1 0) from
      Ty.shift_shift_comm d 1 c 0 s (Nat.zero_le c)]
    exact ih (c + 1) (j + 1) (s.shift 1 0) (by omega)
  | tyAppTy hq f a ihf iha =>
    simp only [Ty.shift, Ty.subst]
    exact congr (congrArg (Ty.tyAppTy hq) (ihf c j s h)) (iha c j s h)
  | nat => simp [Ty.shift, Ty.subst]

end LambdaCalculi
