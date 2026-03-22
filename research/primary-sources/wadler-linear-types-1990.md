# Wadler, P. (1990). Linear Types Can Change the World!

## Publication
Programming Concepts and Methods, IFIP Working Conference, Sea of Galilee, Israel, April 1990.

## Summary

Proposes a type system for functional languages based on Girard's linear logic.
Values of linear type must be used exactly once: they cannot be duplicated or destroyed.

## Key Ideas

- Linear types eliminate need for reference counting or garbage collection
- Safely admit destructive array update
- Extend Schmidt's single-threading notion
- Provide alternative to Hudak and Bloss's update analysis
- Complement Lafont and Holmstrom's linear languages

## Lasting Impact

The ideas in this paper directly influenced the design of Rust's ownership system
and the borrow checker, demonstrating lasting impact on systems programming.

## Source
- https://homepages.inf.ed.ac.uk/wadler/papers/linear/linear.ps
- Semantic Scholar: https://www.semanticscholar.org/paper/Linear-Types-can-Change-the-World!-Wadler/24c850390fba27fc6f3241cb34ce7bc6f3765627
