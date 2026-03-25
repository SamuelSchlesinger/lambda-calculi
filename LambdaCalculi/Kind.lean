namespace LambdaCalculi

/-- Kinds classify types in System F-omega:
    - `star` is the kind of proper types (★)
    - `arr k₁ k₂` is the kind of type operators from `k₁` to `k₂` (k₁ ⇒ k₂) -/
inductive Kind where
  /-- The kind of proper types (★) -/
  | star : Kind
  /-- Arrow kind: type operators (k₁ ⇒ k₂) -/
  | arr : Kind → Kind → Kind
  deriving DecidableEq, Repr

end LambdaCalculi
