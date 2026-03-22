# Scott Encodings and Recursive Types

## Origin

Scott encoding originates from unpublished lecture notes by Dana Scott, first cited in
Curry et al., "Combinatorial Logic, Volume II" (1972). Torben Mogensen later extended
the encoding for lambda terms as data (hence "Mogensen-Scott encoding").

## Key Idea

Scott encoding represents algebraic data types in the lambda calculus by following their
syntactic definition directly, unlike Church encoding which treats recursive data types
specially by representing them with right folds.

### Comparison with Church Encoding

| Property          | Church Encoding    | Scott Encoding          |
|-------------------|--------------------|-------------------------|
| Case distinction  | Derived            | Primitive               |
| Iteration         | Built-in (fold)    | Not built-in            |
| Predecessor       | O(n)               | O(1)                    |
| Typing            | System F           | Requires recursive types|

## Scott Numerals

    0 = lambda s z. z
    1 = lambda s z. s 0
    n+1 = lambda s z. s n

Predecessor is constant time: pred n = n (lambda x. x) 0

## Typing Scott Encodings

To type Scott numerals, we need: nat = A -> (nat -> A) -> A

This requires recursive types (mu-types). In System F (lambda-2) alone, we cannot
type Scott encodings. Extending System F with positive recursive types (lambda-2-mu)
makes Scott encodings typeable.

## References

- Dana Scott. Unpublished lecture notes (c. 1968-1970).
- H.B. Curry, J.R. Hindley, J.P. Seldin. "Combinatorial Logic, Volume II." North-Holland, 1972.
- Torben Mogensen. "Efficient Self-Interpretation in Lambda Calculus." JFP, 2(3), 1992.
- Herman Geuvers. "The Church-Scott representation of inductive and coinductive data." 2014.
  http://www.cs.ru.nl/~herman/PUBS/ChurchScottDataTypes.pdf
