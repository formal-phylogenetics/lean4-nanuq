module

public import Allman2023.Networks.TrdFour
public import Allman2023.Networks.TrdTree

/-!
# Allman, Baños, Mitchell, Rhodes 2023: suppressing the nodes of degree 2 of a tree

Allman et al. 2023 obtain `T_rd(𝒩⁻)` from the tree of blobs by "suppressing all nodes of degree 2"
(their Definition 11), and read the literal topologies of a labelled tree on four taxa (the proof of
their Lemma 1). NANUQ obtains `Q̃` of its Definition 20 from the quartet network in the same way, and
the proofs here that `Q̃` is a quartet tree or a 4-cycle use these facts on trees: the count of
degrees, suppression keeps a tree and the degrees and sides of its nodes, and the sides of the
literal topologies.

Each result is stated in the source's terms, those of lean4-allman2023, and proved from the theorem
of lean4-allman2023 named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics
open Allman2023 (LabelledGraph nodeDegree suppressDegreeTwo ChainLink)
open Allman2023.TreeSuppression (IsSideOf)
open scoped Classical

namespace External.Allman2023

section Trees

variable {W F X : Type*} {G : DirectedMultigraph W F}

/-- A finite tree has one more node than edges. lean4-allman2023 proves it as
`Allman2023.TreeSuppression.card_arcs_add_one`. -/
theorem card_arcs_add_one [Fintype W] [Fintype F] [Nonempty W] (hG : G.IsTree) :
    Fintype.card F + 1 = Fintype.card W :=
  _root_.Allman2023.TreeSuppression.card_arcs_add_one hG

/-- The sum of the degrees is twice the number of edges. lean4-allman2023 proves it as
`Allman2023.TreeSuppression.sum_nodeDegree`. -/
theorem sum_nodeDegree [Fintype W] [Fintype F] : ∑ w, nodeDegree G w = 2 * Fintype.card F :=
  _root_.Allman2023.TreeSuppression.sum_nodeDegree

/-- An edge crosses each of its sides. lean4-allman2023 proves it as
`Allman2023.TreeSuppression.IsSideOf.crosses`. -/
theorem isSideOf_crosses {e : F} {T : Set W} (hT : IsSideOf G e T) : G.Crosses e T :=
  hT.crosses

/-- Two nodes joined through nodes of degree 2 are so both ways. lean4-allman2023 proves it as
`Allman2023.TreeSuppression.ChainLink.symm`. -/
theorem chainLink_symm {u v : W} (h : ChainLink G u v) : ChainLink G v u :=
  _root_.Allman2023.TreeSuppression.ChainLink.symm h

/-- **Suppressing the nodes of degree 2 of a tree gives a tree.** lean4-allman2023 proves it as
`Allman2023.TreeSuppression.isTree_suppressDegreeTwo`. -/
theorem isTree_suppressDegreeTwo [Finite W] [Finite F] [Nonempty {w // nodeDegree G w ≠ 2}]
    (hG : G.IsTree) : (suppressDegreeTwo G).IsTree :=
  _root_.Allman2023.TreeSuppression.isTree_suppressDegreeTwo hG

/-- **A node keeps its degree in the suppressed graph of a tree**: "a blob with `m` incident cut
edges produces an `m`-multifurcation". lean4-allman2023 proves it as
`Allman2023.TreeSuppression.ncard_neighborSet_suppressDegreeTwo`. -/
theorem ncard_neighborSet_suppressDegreeTwo [Finite W] [Finite F] (hG : G.IsTree)
    (v : {w // nodeDegree G w ≠ 2}) :
    ((suppressDegreeTwo G).neighborSet v).ncard = nodeDegree G v.1 :=
  _root_.Allman2023.TreeSuppression.ncard_neighborSet_suppressDegreeTwo hG v

/-- **Suppressing the nodes of degree 2 keeps the sides of the edges of a tree**, on labelled nodes
of degree other than 2. lean4-allman2023 proves it as `Allman2023.TreeSuppression.hasSide_iff`. -/
theorem hasSide_iff [Finite W] [Finite F] (hG : G.IsTree) (ℓ : X → {w // nodeDegree G w ≠ 2})
    (A : Set X) :
    (LabelledGraph.mk (suppressDegreeTwo G) ℓ).HasSide A ↔
      ∃ e T, IsSideOf G e T ∧ (fun x => (ℓ x).1) ⁻¹' T = A :=
  _root_.Allman2023.TreeSuppression.hasSide_iff hG ℓ A

end Trees

section Topologies

variable {W X : Type*}

/-- **The degree count on a tree with four labelled leaves**, in the proof of Lemma 1: a labelled
tree on exactly four taxa, whose labelled nodes have degree 1 and whose other nodes have degree at
least 3, has one of the literal topologies. lean4-allman2023 proves it as
`Allman2023.LabelledGraph.hasStar_or_hasQuartet`. -/
theorem hasStar_or_hasQuartet [Finite W] [Fintype X] [DecidableEq X] (T : LabelledGraph W X)
    (hT : T.graph.IsTree) (hinj : Function.Injective T.leaf) (hcard : Fintype.card X = 4)
    (hl : ∀ x, (T.graph.neighborSet (T.leaf x)).ncard = 1)
    (hint : ∀ v, (∀ x, T.leaf x ≠ v) → 3 ≤ (T.graph.neighborSet v).ncard)
    {a b c d : X} (h : ({a, b, c, d} : Finset X).card = 4) :
    T.HasStarTopology a b c d ∨ T.HasQuartetTopology a b c d ∨ T.HasQuartetTopology a c b d ∨
      T.HasQuartetTopology a d b c :=
  _root_.Allman2023.LabelledGraph.hasStar_or_hasQuartet T hT hinj hcard hl hint h

/-- **The tree with the literal topology `ab|cd` has `{a, b}` as a side**, on four taxa.
lean4-allman2023 proves it as `Allman2023.LabelledGraph.HasQuartetTopology.pair_mem_splits`. -/
theorem pair_mem_splits_of_hasQuartetTopology [Fintype X] [DecidableEq X] {T : LabelledGraph W X}
    {a b c d : X} (h : T.HasQuartetTopology a b c d) (huniv : ∀ x : X, x = a ∨ x = b ∨ x = c ∨ x = d) :
    ({a, b} : Finset X) ∈ T.splits :=
  h.pair_mem_splits huniv

/-- **The tree with the literal unresolved topology has no side with two taxa on each side**: every
side, or its complement, is one taxon. lean4-allman2023 proves it as
`Allman2023.LabelledGraph.HasStarTopology.card_of_mem_splits`. -/
theorem card_of_mem_splits_of_hasStarTopology [Fintype X] [DecidableEq X] {T : LabelledGraph W X}
    {a b c d : X} (h : T.HasStarTopology a b c d) (huniv : ∀ x : X, x = a ∨ x = b ∨ x = c ∨ x = d)
    {A : Finset X} (hA : A ∈ T.splits) : A.card = 1 ∨ Aᶜ.card = 1 :=
  h.card_of_mem_splits huniv hA

end Topologies

end External.Allman2023
