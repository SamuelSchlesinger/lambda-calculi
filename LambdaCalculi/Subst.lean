import LambdaCalculi.Ty
import LambdaCalculi.Term

namespace LambdaCalculi

/-! ## Shifting and substitution with de Bruijn indices

We define operations for both type-level variables (in `Ty`) and term-level variables (in `Term`).
For STLC (`p = Empty`), the type-level operations are trivially the identity since
`tvar` and `all` constructors are dead.

### Conventions

- `shift d c t`: increase all free variable indices ≥ `c` (cutoff) by `d`
- `subst j s t`: replace variable `j` with `s` in `t`, simultaneously decrementing
  all variables > `j` by 1 (accounting for the removed binder)

With this "combined" substitution, beta reduction is simply:
  `(λ. body) v ⟶ body.subst 0 v`
-/

-- ============================================================
-- Type-level shifting and substitution (for type variables)
-- ============================================================

namespace Ty

/-- Shift type variable indices: add `d` to all type variable indices ≥ `c` -/
def shift (d c : Nat) : Ty p → Ty p
  | .base n => .base n
  | .arr a b => .arr (a.shift d c) (b.shift d c)
  | .tvar hp k => .tvar hp (if k ≥ c then k + d else k)
  | .all hp body => .all hp (body.shift d (c + 1))

/-- Substitute type `s` for type variable `j`, decrementing variables above `j` -/
def subst (j : Nat) (s : Ty p) (t : Ty p) : Ty p :=
  match t with
  | .base n => .base n
  | .arr a b => .arr (Ty.subst j s a) (Ty.subst j s b)
  | .tvar hp k =>
    if k = j then s
    else if j < k then .tvar hp (k - 1)
    else .tvar hp k
  | .all hp body => .all hp (Ty.subst (j + 1) (s.shift 1 0) body)
termination_by t

end Ty

-- ============================================================
-- Term-level shifting and substitution (for term variables)
-- ============================================================

namespace Term

/-- Shift term variable indices: add `d` to all term variable indices ≥ `c`.
    Type annotations and type arguments are left unchanged (they don't contain
    term variables in STLC or System F). -/
def shift (d c : Nat) : Term p → Term p
  | .var k => .var (if k ≥ c then k + d else k)
  | .app t₁ t₂ => .app (t₁.shift d c) (t₂.shift d c)
  | .lam ty body => .lam ty (body.shift d (c + 1))
  | .tyAbs hp body => .tyAbs hp (body.shift d c)
  | .tyApp hp t ty => .tyApp hp (t.shift d c) ty

/-- Substitute term `s` for term variable `j`, decrementing variables above `j`.
    This is the "combined" substitution: it replaces AND adjusts indices in one pass. -/
def subst (j : Nat) (s : Term p) (t : Term p) : Term p :=
  match t with
  | .var k =>
    if k = j then s
    else if j < k then .var (k - 1)
    else .var k
  | .app t₁ t₂ => .app (Term.subst j s t₁) (Term.subst j s t₂)
  | .lam ty body => .lam ty (Term.subst (j + 1) (s.shift 1 0) body)
  | .tyAbs hp body => .tyAbs hp (Term.subst j s body)
  | .tyApp hp t ty => .tyApp hp (Term.subst j s t) ty
termination_by t

/-- Substitute type `s` for type variable `j` inside a term.
    This modifies type annotations and type arguments but not term variable indices.
    Needed for System F type-level beta reduction. -/
def tySubst (j : Nat) (s : Ty p) (t : Term p) : Term p :=
  match t with
  | .var k => .var k
  | .app t₁ t₂ => .app (Term.tySubst j s t₁) (Term.tySubst j s t₂)
  | .lam ty body => .lam (ty.subst j s) (Term.tySubst j s body)
  | .tyAbs hp body => .tyAbs hp (Term.tySubst (j + 1) (s.shift 1 0) body)
  | .tyApp hp t ty => .tyApp hp (Term.tySubst j s t) (ty.subst j s)
termination_by t

end Term

end LambdaCalculi
