# Terminal Coalgebras for an Endofunctor - nLab

Source: https://ncatlab.org/nlab/show/terminal+coalgebra+for+an+endofunctor

## Formal Definition

A terminal coalgebra (also called final coalgebra) for an endofunctor F on a category C is
a terminal object in the category of coalgebras of F.

Given two coalgebras (x, eta: x -> Fx) and (y, theta: y -> Fy), a coalgebra map f: x -> y satisfies:
  theta . f = F(f) . eta

## Lambek's Lemma (Fixed Point Property)

Theorem: If (x, theta: x -> Fx) is terminal in the F-coalgebra category, then theta is an
isomorphism, meaning Fx = x.

Proof sketch: Construct a coalgebra structure on Fx via F(theta): Fx -> FFx. By terminality,
a unique coalgebra map f: Fx -> x exists. Then f . theta = 1_x and theta . f = 1_{Fx},
establishing theta as an isomorphism.

## Relationship to Greatest Fixed Points

Terminal coalgebras represent the "largest fixed point" of F. Being terminal means there
exists a unique map from any other coalgebra (including fixed points) to the terminal coalgebra.
For Set, this map is injective.

## Duality with Initial Algebras

Terminal coalgebras support coinduction and corecursion, dual to the induction and recursion
enabled by initial algebras of endofunctors.

## Adamek's Theorem

If C has terminal object 1 and the limit L of the diagram:
  ... F^3(1) -> F^2(1) -> F(1) -> 1
exists, and F preserves this limit, then L carries a terminal coalgebra structure.

## Key Examples

| Endofunctor       | Terminal Coalgebra                |
|-------------------|-----------------------------------|
| X |-> 1 + X       | Conatural numbers N^inf           |
| X |-> A x X       | Stream A (A^N)                    |
| X |-> 1 + A x X   | Potentially infinite lists (Colist A) |
| X |-> 1 + A x X^2 | Potentially infinite binary trees  |
