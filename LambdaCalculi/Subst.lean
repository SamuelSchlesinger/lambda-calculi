import LambdaCalculi.Ty
import LambdaCalculi.Term

namespace LambdaCalculi

/-! ## Shifting and substitution with de Bruijn indices

We define operations for both type-level variables (in `Ty`) and term-level variables (in `Term`).
For STLC (`p = Empty, q = Empty`), the type-level operations are trivially the identity since
`tvar`, `all`, `tyLam`, and `tyAppTy` constructors are dead.

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
def shift (d c : Nat) : Ty p q → Ty p q
  | .base n => .base n
  | .arr a b => .arr (a.shift d c) (b.shift d c)
  | .tvar hpq k => .tvar hpq (if k ≥ c then k + d else k)
  | .all hp ki body => .all hp ki (body.shift d (c + 1))
  | .tyLam hq ki body => .tyLam hq ki (body.shift d (c + 1))
  | .tyAppTy hq f a => .tyAppTy hq (f.shift d c) (a.shift d c)

/-- Substitute type `s` for type variable `j`, decrementing variables above `j` -/
def subst (j : Nat) (s : Ty p q) (t : Ty p q) : Ty p q :=
  match t with
  | .base n => .base n
  | .arr a b => .arr (Ty.subst j s a) (Ty.subst j s b)
  | .tvar hpq k =>
    if k = j then s
    else if j < k then .tvar hpq (k - 1)
    else .tvar hpq k
  | .all hp ki body => .all hp ki (Ty.subst (j + 1) (s.shift 1 0) body)
  | .tyLam hq ki body => .tyLam hq ki (Ty.subst (j + 1) (s.shift 1 0) body)
  | .tyAppTy hq f a => .tyAppTy hq (Ty.subst j s f) (Ty.subst j s a)
termination_by t

end Ty

-- ============================================================
-- Term-level shifting and substitution (for term variables)
-- ============================================================

namespace Term

/-- Shift term variable indices: add `d` to all term variable indices ≥ `c`.
    Type annotations and type arguments are left unchanged (they don't contain
    term variables in STLC or System F). -/
def shift (d c : Nat) : Term p q → Term p q
  | .var k => .var (if k ≥ c then k + d else k)
  | .app t₁ t₂ => .app (t₁.shift d c) (t₂.shift d c)
  | .lam ty body => .lam ty (body.shift d (c + 1))
  | .tyAbs hp ki body => .tyAbs hp ki (body.shift d c)
  | .tyApp hp t ty => .tyApp hp (t.shift d c) ty

/-- Shift type variable indices inside a term's type annotations and type arguments.
    Needed for correct substitution under type binders (Λ) in System F / F-omega. -/
def tyShift (d c : Nat) : Term p q → Term p q
  | .var k => .var k
  | .app t₁ t₂ => .app (t₁.tyShift d c) (t₂.tyShift d c)
  | .lam ty body => .lam (ty.shift d c) (body.tyShift d c)
  | .tyAbs hp ki body => .tyAbs hp ki (body.tyShift d (c + 1))
  | .tyApp hp t ty => .tyApp hp (t.tyShift d c) (ty.shift d c)

/-- Substitute term `s` for term variable `j`, decrementing variables above `j`.
    This is the "combined" substitution: it replaces AND adjusts indices in one pass.
    When passing under a type binder (Λ), the type annotations in `s` are shifted
    to account for the new type variable scope. -/
def subst (j : Nat) (s : Term p q) (t : Term p q) : Term p q :=
  match t with
  | .var k =>
    if k = j then s
    else if j < k then .var (k - 1)
    else .var k
  | .app t₁ t₂ => .app (Term.subst j s t₁) (Term.subst j s t₂)
  | .lam ty body => .lam ty (Term.subst (j + 1) (s.shift 1 0) body)
  | .tyAbs hp ki body => .tyAbs hp ki (Term.subst j (s.tyShift 1 0) body)
  | .tyApp hp t ty => .tyApp hp (Term.subst j s t) ty
termination_by t

/-- Substitute type `s` for type variable `j` inside a term.
    This modifies type annotations and type arguments but not term variable indices.
    Needed for System F / F-omega type-level beta reduction. -/
def tySubst (j : Nat) (s : Ty p q) (t : Term p q) : Term p q :=
  match t with
  | .var k => .var k
  | .app t₁ t₂ => .app (Term.tySubst j s t₁) (Term.tySubst j s t₂)
  | .lam ty body => .lam (Ty.subst j s ty) (Term.tySubst j s body)
  | .tyAbs hp ki body => .tyAbs hp ki (Term.tySubst (j + 1) (s.shift 1 0) body)
  | .tyApp hp t ty => .tyApp hp (Term.tySubst j s t) (Ty.subst j s ty)
termination_by t

end Term

end LambdaCalculi
