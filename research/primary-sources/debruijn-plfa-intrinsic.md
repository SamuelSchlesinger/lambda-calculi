# Intrinsically-Typed de Bruijn Representation
# Source: Programming Language Foundations in Agda (PLFA)
# URL: https://plfa.github.io/DeBruijn/

## Variable Representation

Variables represented as natural numbers (de Bruijn indices) counting enclosing binding terms.
- `# 0` refers to the innermost lambda binding
- `# 1` refers to the next outer lambda binding

## Context and Lookup (Agda)

```agda
data Context : Set where
  ∅   : Context
  _,_ : Context → Type → Context

data _∋_ : Context → Type → Set where
  Z   : ∀ {Γ A} → Γ , A ∋ A
  S_  : ∀ {Γ A B} → Γ ∋ A → Γ , B ∋ A
```

## Intrinsically-Typed Terms

```agda
data _⊢_ : Context → Type → Set where
  `_    : ∀ {Γ A} → Γ ∋ A → Γ ⊢ A
  ƛ_    : ∀ {Γ A B} → Γ , A ⊢ B → Γ ⊢ A ⇒ B
  _·_   : ∀ {Γ A B} → Γ ⊢ A ⇒ B → Γ ⊢ A → Γ ⊢ B
```

## Renaming

```agda
ext : ∀ {Γ Δ}
  → (∀ {A} → Γ ∋ A → Δ ∋ A)
  → (∀ {A B} → Γ , B ∋ A → Δ , B ∋ A)
ext ρ Z      = Z
ext ρ (S x)  = S (ρ x)
```

## Substitution

```agda
exts : ∀ {Γ Δ}
  → (∀ {A} → Γ ∋ A → Δ ⊢ A)
  → (∀ {A B} → Γ , B ∋ A → Δ , B ⊢ A)
exts σ Z      = ` Z
exts σ (S x)  = rename S_ (σ x)
```

## Key Advantage

Each term has a unique representation rather than being represented by an
equivalence class under alpha renaming.
