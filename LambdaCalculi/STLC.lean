import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst
import LambdaCalculi.Typing
import LambdaCalculi.Reduction

/-! ## Simply Typed Lambda Calculus

Type aliases and examples for the STLC, which is the lambda square system
with `p = Empty, q = Empty` (no polymorphism, no type operators). -/

namespace LambdaCalculi.STLC

abbrev Ty := LambdaCalculi.Ty Empty Empty
abbrev Term := LambdaCalculi.Term Empty Empty
abbrev Context := LambdaCalculi.Context Empty Empty

def Bool : Ty := .base 0
def Nat : Ty := .base 1

-- ============================================================
-- Examples
-- ============================================================

def id_bool : Term := .lam Bool (.var 0)
def const_bool_nat : Term := .lam Bool (.lam Nat (.var 1))

-- ============================================================
-- Typing derivations
-- ============================================================

example : HasType [] [] id_bool (.arr Bool Bool) :=
  .lam .base (.var (by decide) .base)

example : HasType [] [] const_bool_nat (.arr Bool (.arr Nat Bool)) :=
  .lam .base (.lam .base (.var (by decide) .base))

example : HasType [] [Bool] (.app id_bool (.var 0)) Bool :=
  .app (.lam .base (.var (by decide) .base)) (.var (by decide) .base)

-- ============================================================
-- Reductions
-- ============================================================

example : Step (.app id_bool (.lam Bool (.var 0)))
              (Term.subst 0 (.lam Bool (.var 0)) (.var 0) : Term) :=
  .beta .lam

example : Term.subst 0 (.lam Bool (.var 0)) (.var 0 : Term) = .lam Bool (.var 0) := by
  simp [Term.subst]

end LambdaCalculi.STLC
