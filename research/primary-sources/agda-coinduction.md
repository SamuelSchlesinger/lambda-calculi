# Coinduction in Agda

Source: https://agda.readthedocs.io/en/latest/language/coinduction.html

## Coinductive Records

Coinductive records define infinite data types using the `coinductive` keyword:

```agda
record Stream (A : Set) : Set where
  coinductive
  field
    hd : A
    tl : Stream A
```

## Copatterns for Construction

```agda
repeat : {A : Set} (a : A) -> Stream A
hd (repeat a) = a
tl (repeat a) = repeat a
```

## Bisimulation as Coinductive Record

```agda
record _~_ {A} (xs : Stream A) (ys : Stream A) : Set where
  coinductive
  field
    hd-= : hd xs = hd ys
    tl-~ : tl xs ~ tl ys
```

## Old Coinduction (Musical Notation)

Uses delay operator with sharp/flat:

```agda
data CoN : Set where
   zero : CoN
   suc  : inf CoN -> CoN
```

## Key Restrictions

- eta-equality is prohibited in coinductive records (can make type checker loop)
- Pattern-matching on explicit constructors of coinductive records is disallowed
- The guardedness check is integrated with size-change termination analysis

## Sized Types Integration

The number of eliminations can be tracked by sized types, reducing productivity
and termination checking to type checking.
