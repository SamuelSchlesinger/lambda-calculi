import LambdaCalculi.Ty
import LambdaCalculi.Term
import LambdaCalculi.Subst
import LambdaCalculi.Typing
import LambdaCalculi.Reduction
import LambdaCalculi.Kinding

/-! ## System T (Gödel's System T)

Type aliases and examples for System T, which extends STLC with natural numbers
and primitive recursion. In the lambda square framework, this is
`p = Empty, q = Empty` with the nat/zero/succ/natrec constructors.

System T is notable for being strongly normalizing and capable of expressing
all primitive recursive functions (and more, e.g., the Ackermann function). -/

namespace LambdaCalculi.SystemT

abbrev Ty := LambdaCalculi.Ty Empty Empty
abbrev Term := LambdaCalculi.Term Empty Empty
abbrev Context := LambdaCalculi.Context Empty Empty

-- ============================================================
-- Numerals
-- ============================================================

def zero : Term := .zero
def one : Term := .succ .zero
def two : Term := .succ (.succ .zero)
def three : Term := .succ (.succ (.succ .zero))

example : HasType [] [] zero .nat := .zero
example : HasType [] [] one .nat := .succ .zero
example : HasType [] [] two .nat := .succ (.succ .zero)
example : HasType [] [] three .nat := .succ (.succ (.succ .zero))

example : Value zero := .zero
example : Value one := .succ .zero
example : Value two := .succ (.succ .zero)

-- ============================================================
-- Arithmetic functions
-- ============================================================

/-- add = λm. λn. natrec Nat n (λ_. λacc. succ acc) m -/
def add : Term :=
  .lam .nat (.lam .nat
    (.natrec .nat (.var 0) (.lam .nat (.lam .nat (.succ (.var 0)))) (.var 1)))

/-- pred = λn. natrec Nat zero (λk. λ_. k) n -/
def pred : Term :=
  .lam .nat (.natrec .nat .zero (.lam .nat (.lam .nat (.var 1))) (.var 0))

/-- iszero = λn. natrec Nat (succ zero) (λ_. λ_. zero) n
    Returns 1 if n = 0, 0 otherwise. -/
def iszero : Term :=
  .lam .nat (.natrec .nat (.succ .zero) (.lam .nat (.lam .nat .zero)) (.var 0))

/-- mul = λm. λn. natrec Nat zero (λ_. λacc. add n acc) m -/
def mul : Term :=
  .lam .nat (.lam .nat
    (.natrec .nat .zero (.lam .nat (.lam .nat (.app (.app add (.var 3)) (.var 0)))) (.var 1)))

/-- double = λn. natrec Nat zero (λ_. λacc. succ (succ acc)) n -/
def double : Term :=
  .lam .nat (.natrec .nat .zero (.lam .nat (.lam .nat (.succ (.succ (.var 0))))) (.var 0))

/-- fact = λn. natrec Nat (succ zero) (λk. λacc. mul (succ k) acc) n -/
def fact : Term :=
  .lam .nat (.natrec .nat (.succ .zero)
    (.lam .nat (.lam .nat (.app (.app mul (.succ (.var 1))) (.var 0)))) (.var 0))

/-- exp = λbase. λe. natrec Nat (succ zero) (λ_. λacc. mul base acc) e -/
def exp : Term :=
  .lam .nat (.lam .nat
    (.natrec .nat (.succ .zero) (.lam .nat (.lam .nat (.app (.app mul (.var 3)) (.var 0)))) (.var 0)))

/-- const_zero = λ_. zero -/
def const_zero : Term := .lam .nat .zero

/-- apply_twice = λf. λx. f (f x) -/
def apply_twice : Term :=
  .lam (.arr .nat .nat) (.lam .nat (.app (.var 1) (.app (.var 1) (.var 0))))

-- ============================================================
-- Typing derivations
-- ============================================================

example : HasType [] [] add (.arr .nat (.arr .nat .nat)) :=
  .lam .nat (.lam .nat
    (.natrec .nat (.var (by decide) .nat)
      (.lam .nat (.lam .nat (.succ (.var (by decide) .nat))))
      (.var (by decide) .nat)))

example : HasType [] [] pred (.arr .nat .nat) :=
  .lam .nat (.natrec .nat .zero
    (.lam .nat (.lam .nat (.var (by decide) .nat)))
    (.var (by decide) .nat))

example : HasType [] [] iszero (.arr .nat .nat) :=
  .lam .nat (.natrec .nat (.succ .zero)
    (.lam .nat (.lam .nat .zero))
    (.var (by decide) .nat))

example : HasType [] [] double (.arr .nat .nat) :=
  .lam .nat (.natrec .nat .zero
    (.lam .nat (.lam .nat (.succ (.succ (.var (by decide) .nat)))))
    (.var (by decide) .nat))

example : HasType [] [] const_zero (.arr .nat .nat) :=
  .lam .nat .zero

example : HasType [] [] apply_twice (.arr (.arr .nat .nat) (.arr .nat .nat)) :=
  .lam (.arr .nat .nat) (.lam .nat
    (.app (.var (by decide) (.arr .nat .nat))
      (.app (.var (by decide) (.arr .nat .nat)) (.var (by decide) .nat))))

-- ============================================================
-- Reduction examples
-- ============================================================

/-- natrec on zero returns the base case -/
example : Step (.natrec .nat (.succ .zero) (.lam .nat (.lam .nat (.succ (.var 0)))) .zero)
              (.succ .zero : Term) :=
  .recZero

/-- natrec on (succ zero) unfolds one step -/
example : Step (.natrec .nat (.succ .zero) (.lam .nat (.lam .nat (.succ (.var 0)))) (.succ .zero))
              (.app (.app (.lam .nat (.lam .nat (.succ (.var 0)))) .zero)
                    (.natrec .nat (.succ .zero) (.lam .nat (.lam .nat (.succ (.var 0)))) .zero) : Term) :=
  .recSucc .zero

/-- pred zero ⟶β (natrec ...) -/
example : Step (.app pred zero)
              (Term.subst 0 .zero (.natrec .nat .zero (.lam .nat (.lam .nat (.var 1))) (.var 0)) : Term) :=
  .beta .zero

/-- After beta, the natrec fires on zero -/
example : Step (Term.subst 0 .zero (.natrec .nat .zero (.lam .nat (.lam .nat (.var 1))) (.var 0)) : Term)
              (.zero : Term) := by
  simp [Term.subst]
  exact .recZero

/-- succ reduces its argument -/
example : Step (.succ (.app (.lam .nat (.var 0)) .zero))
              (.succ (Term.subst 0 .zero (.var 0)) : Term) :=
  .succArg (.beta .zero)

-- ============================================================
-- iszero examples
-- ============================================================

/-- iszero 0 eventually evaluates to 1 -/
example : Step (.app iszero zero)
              (Term.subst 0 .zero (.natrec .nat (.succ .zero) (.lam .nat (.lam .nat .zero)) (.var 0)) : Term) :=
  .beta .zero

example : Step (Term.subst 0 (.zero : Term) (.natrec .nat (.succ .zero) (.lam .nat (.lam .nat .zero)) (.var 0)) : Term)
              (.succ .zero : Term) := by
  simp [Term.subst]
  exact .recZero

end LambdaCalculi.SystemT
