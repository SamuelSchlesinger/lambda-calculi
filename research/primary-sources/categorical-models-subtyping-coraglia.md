# Categorical Models of Subtyping

Source: Coraglia and Emmenegger (2023), arXiv:2312.14600
Published in: LIPIcs Vol. 303, TYPES 2023

## Abstract

The authors extend traditional categorical models of dependent types by moving from discrete
to general (non-discrete) Grothendieck fibrations. This framework allows contexts to have not
just sets but entire categories of types, introducing a novel notion of subtyping.

## Key Ideas

- A type A' is a subtype of A if there is a unique coercion from A' to A.
- This treats subtyping as an abbreviation mechanism: whenever a term of type A is needed,
  one can substitute a term of type A' instead.
- Rather than discrete Grothendieck fibrations (traditional foundation for categories with
  families, display map categories, natural models), they employ non-discrete fibrations.
- Provides formal rules, coherence conditions, and explicit categorical models.
- Closely related to Luo's coercive subtyping.
- Addresses interactions between subtyping and type constructors.
