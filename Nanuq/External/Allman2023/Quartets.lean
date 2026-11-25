module

public import Allman2023.Networks.Concordance
public import Allman2023.Networks.Definitions

/-!
# Allman, Baños, Mitchell, Rhodes 2023: quartet trees and the LSA network

Facts of Allman et al. 2023 that the proofs of NANUQ's results use on the objects that the two
papers share: the three quartet trees on four taxa (their Definition 14), and the edges of the LSA
network `𝒩⊕` (their Definition 5), from which NANUQ builds `N⁻`.

Each result is stated in the source's terms, those of lean4-allman2023 and of the libraries, and
proved from the theorem of lean4-allman2023 named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork Finset
open Allman2023 (IsBinaryNetwork lsaNode)
open scoped Classical

namespace External.Allman2023

variable {V E X : Type*} [DecidableEq X]

/-- The taxa of `ab|cd` are those of `ac|bd`. lean4-allman2023 proves it as
`Allman2023.card_acbd`. -/
theorem card_acbd {a b c d : X} (h : ({a, b, c, d} : Finset X).card = 4) :
    ({a, c, b, d} : Finset X).card = 4 :=
  _root_.Allman2023.card_acbd h

/-- The taxa of `ab|cd` are those of `ad|bc`. lean4-allman2023 proves it as
`Allman2023.card_adbc`. -/
theorem card_adbc {a b c d : X} (h : ({a, b, c, d} : Finset X).card = 4) :
    ({a, d, b, c} : Finset X).card = 4 :=
  _root_.Allman2023.card_adbc h

/-- The quartet trees `ab|cd` and `ac|bd` differ. lean4-allman2023 proves it as
`Allman2023.quartetTree_ne_acbd`. -/
theorem quartetTree_ne_acbd {a b c d : X} (h : ({a, b, c, d} : Finset X).card = 4) :
    quartetTree a b c d h ≠ quartetTree a c b d (card_acbd h) :=
  _root_.Allman2023.quartetTree_ne_acbd h

/-- The quartet trees `ab|cd` and `ad|bc` differ. lean4-allman2023 proves it as
`Allman2023.quartetTree_ne_adbc`. -/
theorem quartetTree_ne_adbc {a b c d : X} (h : ({a, b, c, d} : Finset X).card = 4) :
    quartetTree a b c d h ≠ quartetTree a d b c (card_adbc h) :=
  _root_.Allman2023.quartetTree_ne_adbc h

omit [DecidableEq X] in
/-- An edge is kept in the LSA network `𝒩⊕` of Definition 5 exactly when it is not above the LSA.
lean4-allman2023 proves it as `Allman2023.mem_belowArcs_univ_iff`. -/
theorem mem_belowArcs_univ_iff {N : RootedNetwork V E X} (hN : IsBinaryNetwork N) (hX : Nontrivial X)
    (e : E) :
    e ∈ N.belowArcs (lsaNode hN hX) Set.univ ↔ ¬ N.graph.Reaches (N.graph.target e) (lsaNode hN hX) :=
  _root_.Allman2023.mem_belowArcs_univ_iff hN hX e

end External.Allman2023
