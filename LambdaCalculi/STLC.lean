import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst
import LambdaCalculi.Typing
import LambdaCalculi.Reduction

/-! ## Simply Typed Lambda Calculus

Type aliases and examples for the STLC, which is the lambda cube system
with `p = Empty` (no polymorphism, no type variables). -/

namespace LambdaCalculi.STLC

-- Type aliases
abbrev Ty := LambdaCalculi.Ty Empty
abbrev Term := LambdaCalculi.Term Empty
abbrev Context := LambdaCalculi.Context Empty

-- Convenient base types
def Bool : Ty := .base 0
def Nat : Ty := .base 1

-- ============================================================
-- Examples
-- ============================================================

/-- The identity function: λ(x : Bool). x -/
def id_bool : Term := .lam Bool (.var 0)

/-- The constant function: λ(x : Bool). λ(y : Nat). x -/
def const_bool_nat : Term := .lam Bool (.lam Nat (.var 1))

-- ============================================================
-- Example typing derivations
-- ============================================================

/-- The identity function has type Bool → Bool -/
example : HasType [] id_bool (.arr Bool Bool) :=
  .lam (.var (by decide))

/-- The constant function has type Bool → Nat → Bool -/
example : HasType [] const_bool_nat (.arr Bool (.arr Nat Bool)) :=
  .lam (.lam (.var (by decide)))

/-- In context [Bool], applying the identity to var 0 has type Bool -/
example : HasType [Bool] (.app id_bool (.var 0)) Bool :=
  .app (.lam (.var (by decide))) (.var (by decide))

-- ============================================================
-- Example reductions
-- ============================================================

/-- Beta reduction fires on the identity applied to a value -/
example : Step (.app id_bool (.lam Bool (.var 0)))
              (Term.subst 0 (.lam Bool (.var 0)) (.var 0) : Term) :=
  .beta .lam

/-- The substitution computes to the expected result -/
example : Term.subst 0 (.lam Bool (.var 0)) (.var 0 : Term) = .lam Bool (.var 0) := by
  simp [Term.subst]

end LambdaCalculi.STLC
