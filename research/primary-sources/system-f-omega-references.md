# System Fω: Primary Sources and References

## Seminal Papers

1. **Girard, Jean-Yves.** "Interprétation fonctionnelle et élimination des coupures de l'arithmétique d'ordre supérieur." Thèse d'État, Université Paris VII, 1972.
   - URL: https://www.cs.cmu.edu/~kw/scans/girard72thesis.pdf
   - First introduction of System F (polymorphic lambda calculus), from which Fω is a natural extension.

2. **Reynolds, John C.** "Towards a theory of type structure." In Colloque sur la Programmation, Lecture Notes in Computer Science, vol. 19, pp. 408–425. Springer, 1974.
   - Independent discovery of System F.

3. **Barendregt, Henk.** "Lambda calculi with types." In Handbook of Logic in Computer Science, vol. 2, pp. 117–309. Oxford University Press, 1992.
   - Definitive treatment of the lambda cube, including System Fω. Introduces the systematic framework relating λ→, λ2 (System F), λω, λω (Fω), λP, λP2, λPω, and λC.

4. **Pierce, Benjamin C.** Types and Programming Languages. MIT Press, 2002.
   - Chapter 29: Type Operators and Kinding (λω)
   - Chapter 30: Higher-Order Polymorphism (System Fω)

5. **Rossberg, Andreas, Claudio V. Russo, and Derek Dreyer.** "F-ing modules." Journal of Functional Programming 24(5): 529–607, 2014.
   - Shows ML modules are a particular mode of use of System Fω.
   - URL: https://people.mpi-sws.org/~dreyer/courses/modules/f-ing.pdf

6. **Brown, Matt and Jens Palsberg.** "Breaking through the normalization barrier: a self-interpreter for F-omega." POPL 2016.
   - Constructs a self-interpreter for Fω despite strong normalization.
   - URL: http://compilers.cs.ucla.edu/popl16/popl16-full.pdf

7. **Harper, Robert, John C. Mitchell, and Eugenio Moggi.** "Higher-order modules and the phase distinction." 17th Symposium on the Principles of Programming Languages, pp. 341–354, 1990.

8. **Harper, Robert and Mark Lillibridge.** "A type-theoretic approach to higher-order modules with sharing." 21st Symposium on the Principles of Programming Languages, pp. 123–137, 1994.

## Lecture Notes and Course Materials

9. **Leroy, Xavier.** "Polymorphism all the way up! From System F to the Calculus of Constructions." Collège de France, 2018–2019.
   - URL: https://xavierleroy.org/CdF/2018-2019/2.pdf

10. **Rémy, Didier.** "Type systems for programming languages." MPRI course notes, 2020–2021.
    - URL: http://gallium.inria.fr/~remy/mpri/cours-fomega.pdf

11. **Northeastern University.** "Higher-Order Polymorphism" (Fω notes).
    - URL: http://www.ccs.neu.edu/home/amal/course/7480-s12/fomega-notes.pdf

12. **Northwestern University.** "The higher-order lambda calculus λ-ω."
    - URL: https://users.cs.northwestern.edu/~jesse/course/type-systems-wi18/type-notes/sec_fomega.html

## Formalizations

13. **Kovács, András.** "System F-omega normalization by hereditary substitution in Agda."
    - URL: https://github.com/AndrasKovacs/system-f-omega

14. **Liu, Yiyun.** "Strong normalization and parametricity for System Fω in Coq."
    - URL: https://github.com/yiyunliu/system-f-omega

15. **Chapman, James and Roman Kireev.** "System F in Agda, for Fun and Profit." MPC 2019.
    - URL: https://homepages.inf.ed.ac.uk/wadler/papers/mpc-2019/system-f-in-agda.pdf

## Related Works

16. **Dreyer, Derek.** "Understanding and Evolving the ML Module System." PhD thesis, Carnegie Mellon University, 2005.

17. **Sulzmann, Martin, Manuel M. T. Chakravarty, Simon Peyton Jones, and Kevin Donnelly.** "System F with Type Equality Coercions." Microsoft Research, 2007.
    - GHC's Core language (System FC), based on Fω.

18. **Cai, Yufei, Paolo G. Giarrusso, Tillmann Rendel, and Klaus Ostermann.** "System F-omega with Equirecursive Types for Datatype-Generic Programming." POPL 2016.
