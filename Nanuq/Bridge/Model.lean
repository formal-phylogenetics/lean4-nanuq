module

public import Nanuq.Defs
public import Nanuq.Algorithm.Theorem36
public import Phylogenetics.NMSC.Inheritance

/-!
# The Challenge's definitions are the library's

The Challenge states its theorems on the definitions of `Nanuq.Defs` (namespace `Nanuq.Model`),
written in Mathlib's vocabulary. The library states them on those of `Phylogenetics`, `PhyloNetwork`,
`Tinnik` and of this library. This module proves that the two agree: most are equal by definition,
once a network of the Challenge is read as one of the library (`Network.toRooted`), its parameters as
the library's (`Params.toMetric`), and a class of the Challenge as the library's
(`QuartetClass.toLib`).

* `Network.isPhylogenetic_iff`, `Network.isBinary_iff`, `Network.isMetric_iff`,
  `Network.isLevelOne_iff`: the networks and their parameters; the blobs, by
  `Digraph.sameBlob_iff`.
* `Network.isGenericNull_iff`: null sets of parameters.
* `Network.geneTreeDist_eq`, `Network.nmscCF_eq`: the network multispecies coalescent with
  independent inheritance (`geneTreeDist … 0`) and its concordance factors.
* `Network.threeTwoTreelike_iff`, `noCentroidCF_iff`: the hypotheses of Theorem 36.
* `Network.networkClass_eq`, `Network.networkDistance_eq`: the network's classes and distance.
* `classify_eq`, `nanuqDistance_eq`, `isMaxCountSelection_iff`, `isMinCountSelection_iff`,
  `iidProb_eq`, `quartetCount_eq`: Steps 2 and 3 of the algorithm, and its samples.
-/

@[expose] public noncomputable section

open Finset Phylogenetics Phylogenetics.RootedNetwork
open scoped Classical

namespace Nanuq.Model

variable {V E X : Type*}

/-- A graph of the Challenge as a graph of the library. -/
def Digraph.toDM (G : Digraph V E) : DirectedMultigraph V E := ⟨G.source, G.target⟩

/-- A network of the Challenge as a network of the library. -/
def Network.toRooted (N : Network V E X) : RootedNetwork V E X := ⟨N.graph.toDM, N.root, N.leaf⟩

/-- Parameters of the Challenge as parameters of the library. -/
def Params.toMetric (θ : Params E) : MetricData E := ⟨θ.length, θ.inheritance⟩

/-- Parameters of the library as parameters of the Challenge. -/
def ofMetric (θ : MetricData E) : Params E := ⟨θ.length, θ.inheritance⟩

@[simp] theorem toMetric_ofMetric (θ : MetricData E) : (ofMetric θ).toMetric = θ := rfl

@[simp] theorem ofMetric_toMetric (θ : Params E) : ofMetric θ.toMetric = θ := rfl

/-! ### Blobs -/

namespace Digraph

variable (G : Digraph V E)

/-- Cut edges are the library's bridges. -/
theorem isCutArc_iff (e : E) : G.IsCutArc e ↔ G.toDM.underlying.IsBridge e :=
  (G.toDM.isBridge_iff_not_walks_delete e).symm

/-- Blobs are the library's: the classes of `DirectedMultigraph.blobSetoid`. -/
theorem sameBlob_iff (u v : V) : G.SameBlob u v ↔ G.toDM.blobSetoid u v := by
  have hset : {e | ¬ G.IsCutArc e} = {e | ¬ G.toDM.underlying.IsBridge e} := by
    ext e
    simp only [Set.mem_ofPred_eq, isCutArc_iff]
  unfold SameBlob
  rw [hset]
  rfl

theorem sameBlob_eq : G.SameBlob = fun u v => G.toDM.blobSetoid u v :=
  funext fun u => funext fun v => propext (G.sameBlob_iff u v)

end Digraph

/-! ### Networks -/

namespace Network

variable (N : Network V E X)

/-- Rooted phylogenetic networks are the library's. -/
theorem isPhylogenetic_iff : N.IsPhylogenetic ↔ N.toRooted.IsPhylogenetic := by
  constructor
  · rintro ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩
    exact ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩
  · rintro ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩
    exact ⟨h1, h2, h3, h4, h5, h6, h7, h8, h9, h10⟩

/-- Binary networks are the library's. -/
theorem isBinary_iff : N.IsBinary ↔ N.toRooted.IsBinary := Iff.rfl

/-- Valid parameters are the library's. -/
theorem isMetric_iff [Fintype E] (θ : Params E) : N.IsMetric θ ↔ N.toRooted.IsMetric θ.toMetric :=
  Iff.rfl

/-- Level-1 networks are the library's. -/
theorem isLevelOne_iff [Fintype V] [Fintype E] : N.IsLevelOne ↔ N.toRooted.IsLevelOne := by
  unfold IsLevelOne RootedNetwork.IsLevelOne
  simp only [Digraph.sameBlob_eq]
  rfl

/-- Null sets of parameters are the library's, through `Params.toMetric`. -/
theorem isGenericNull_iff [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
    (A : Set (MetricData E)) :
    N.IsGenericNull (Params.toMetric ⁻¹' A) ↔ N.toRooted.IsGenericNull A := by
  have hset : ∀ d : V → E,
      {x : (E → ℝ) × (E → ℝ) | ∃ θ ∈ Params.toMetric ⁻¹' A, N.IsMetric θ ∧ θ.length = x.1 ∧
        ∀ e, N.IsHybridArc e → e ≠ d (N.graph.target e) → θ.inheritance e = x.2 e} =
      {x | ∃ θ ∈ A, N.toRooted.IsMetric θ ∧ θ.length = x.1 ∧
        ∀ e, N.toRooted.IsHybridArc e → e ≠ d (N.toRooted.graph.target e) →
          θ.inheritance e = x.2 e} := by
    intro d
    ext x
    constructor
    · rintro ⟨θ, hA, hθ, hl, hi⟩
      exact ⟨θ.toMetric, hA, hθ, hl, hi⟩
    · rintro ⟨θ, hA, hθ, hl, hi⟩
      exact ⟨ofMetric θ, hA, hθ, hl, hi⟩
  unfold IsGenericNull RootedNetwork.IsGenericNull
  simp only [hset]
  rfl

/-- Walks outside a blob are the library's. -/
theorem blockWalk_iff (v a b : V) : N.BlockWalk v a b ↔ PhyloNetwork.Level1.BlockWalk N.toRooted v a b := by
  have h : N.BlockStep v = PhyloNetwork.Level1.BlockStep N.toRooted v := by
    funext a b
    unfold BlockStep PhyloNetwork.Level1.BlockStep
    simp only [Digraph.sameBlob_eq]
    rfl
  unfold BlockWalk PhyloNetwork.Level1.BlockWalk
  rw [h]

variable [Fintype X] [DecidableEq X]

omit [Fintype X] [DecidableEq X] in
/-- `3₂`-cycles are the library's. -/
theorem hasThreeTwoCycle_iff (q : Finset X) : N.HasThreeTwoCycle q ↔ Nanuq.HasThreeTwoCycle N.toRooted q := by
  unfold HasThreeTwoCycle Nanuq.HasThreeTwoCycle
  simp only [blockWalk_iff]
  rfl

/-- The hypothesis of Theorem 36 is the library's. -/
theorem threeTwoTreelike_iff (p : QuartetTree X → ℝ) :
    N.ThreeTwoTreelike p ↔ Nanuq.ThreeTwoTreelike N.toRooted p := by
  unfold ThreeTwoTreelike Nanuq.ThreeTwoTreelike
  simp only [hasThreeTwoCycle_iff]
  rfl

omit [Fintype X] in
/-- Cut-edge splits of the induced networks are the library's. -/
theorem inducedCutSplit_iff (s : QuartetTree X) : N.InducedCutSplit s ↔ Phylogenetics.InducedCutSplit N.toRooted s :=
  Iff.rfl

omit [Fintype X] in
/-- The trees of the grove are the library's. -/
theorem groveDisplays_iff (s : QuartetTree X) : N.GroveDisplays s ↔ Nanuq.GroveDisplays N.toRooted s := by
  constructor
  · rintro ⟨D, ⟨h1, h2⟩, h3, h4⟩
    exact ⟨D, ⟨h1, h2⟩, h3, h4⟩
  · rintro ⟨D, ⟨h1, h2⟩, h3, h4⟩
    exact ⟨D, ⟨h1, h2⟩, h3, h4⟩

end Network

/-! ### The classes and the distance -/

section Classes

variable [Fintype X] [DecidableEq X]

/-- A class of the Challenge as a class of the library. -/
def QuartetClass.toLib : QuartetClass X → Nanuq.QuartetClass X
  | .star => .star
  | .tree s => .tree s
  | .cycle s => .cycle s

omit [Fintype X] in
theorem QuartetClass.toLib_injective : Function.Injective (QuartetClass.toLib (X := X)) := by
  intro a b h
  cases a <;> cases b <;> simp only [QuartetClass.toLib, reduceCtorEq] at h
  · rfl
  · injection h with h
    rw [h]
  · injection h with h
    rw [h]

omit [Fintype X] in
theorem rho_eq (C : QuartetClass X) (x y : X) : rho C x y = Nanuq.rho C.toLib x y := by
  cases C <;> rfl

/-- The network quartet distance is the library's. -/
theorem nanuqDistance_eq (cl : Finset X → QuartetClass X) :
    nanuqDistance cl = Nanuq.nanuqDistance (QuartetClass.toLib ∘ cl) := by
  funext x y
  unfold nanuqDistance Nanuq.nanuqDistance
  simp only [rho_eq, Function.comp_apply]

/-- Step 2 is the library's. -/
theorem classify_eq (mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X) (α β : ℝ)
    (c : QuartetTree X → ℝ) (q : Finset X) :
    (classify mlT mlC α β c q).toLib = Nanuq.classify mlT mlC α β c q := by
  have hs : starPValue c q = Phylogenetics.starPValue .lrt c q := rfl
  have ht : t3PValue c (mlT c q) = Phylogenetics.t3PValue c (mlT c q) := rfl
  unfold classify Nanuq.classify
  rw [hs, ht]
  split_ifs <;> rfl

/-- Selections of the topology of largest count are the library's. -/
theorem isMaxCountSelection_iff (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) :
    IsMaxCountSelection ml ↔ Nanuq.IsMaxCountSelection ml := Iff.rfl

/-- Selections of the topology of least count are the library's. -/
theorem isMinCountSelection_iff (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) :
    IsMinCountSelection ml ↔ Nanuq.IsMinCountSelection ml := Iff.rfl

/-- Concordance factors off the centroid are TINNiK's. -/
theorem noCentroidCF_iff (p : QuartetTree X → ℝ) : NoCentroidCF p ↔ Tinnik.NoCentroidCF p := Iff.rfl

/-- Independent samples are the library's. -/
theorem iidProb_eq {Γ : Type*} [Fintype Γ] (dist : Γ → ℝ) (n : ℕ) (Ev : (Fin n → Γ) → Prop) :
    iidProb dist n Ev = Phylogenetics.iidProb dist n Ev := rfl

omit [Fintype X] in
/-- Counts of quartet trees are the library's. -/
theorem quartetCount_eq {Γ : Type*} [Fintype Γ] {n : ℕ} (sides : Γ → Finset (Finset X))
    (ω : Fin n → Γ) : quartetCount sides ω = Phylogenetics.quartetCount sides ω := rfl

namespace Network

variable (N : Network V E X)

/-- The network's class of a set of four taxa is the library's. -/
theorem networkClass_eq (q : Finset X) : (N.networkClass q).toLib = Nanuq.networkClass N.toRooted q := by
  have hg : N.GroveDisplays = Nanuq.GroveDisplays N.toRooted :=
    funext fun s => propext (N.groveDisplays_iff s)
  unfold networkClass Nanuq.networkClass
  simp only [hg]
  by_cases h1 : ∃ s ∈ Phylogenetics.treesOn q, Phylogenetics.InducedCutSplit N.toRooted s
  · have h1' : ∃ s ∈ treesOn q, N.InducedCutSplit s := h1
    rw [dite_eq_left h1, dite_eq_left h1']
    rfl
  have h1' : ¬ ∃ s ∈ treesOn q, N.InducedCutSplit s := h1
  rw [dite_eq_right h1, dite_eq_right h1']
  by_cases h2 : ∃ s ∈ Phylogenetics.treesOn q, ¬ Nanuq.GroveDisplays N.toRooted s ∧
      ∃ r ∈ s.alternatives, Nanuq.GroveDisplays N.toRooted r
  · have h2' : ∃ s ∈ treesOn q, ¬ Nanuq.GroveDisplays N.toRooted s ∧
        ∃ r ∈ QuartetTree.alternatives s, Nanuq.GroveDisplays N.toRooted r := h2
    rw [dite_eq_left h2, dite_eq_left h2']
    rfl
  have h2' : ¬ ∃ s ∈ treesOn q, ¬ Nanuq.GroveDisplays N.toRooted s ∧
      ∃ r ∈ QuartetTree.alternatives s, Nanuq.GroveDisplays N.toRooted r := h2
  rw [dite_eq_right h2, dite_eq_right h2']
  rfl

/-- The theoretical quartet distance is the library's. -/
theorem networkDistance_eq : N.networkDistance = Nanuq.networkDistance N.toRooted := by
  unfold networkDistance Nanuq.networkDistance
  rw [nanuqDistance_eq]
  congr 1
  funext q
  exact N.networkClass_eq q

end Network

end Classes

/-! ### The coalescent -/

namespace Network

variable (N : Network V E X) [Fintype V] [Fintype E] [Fintype X] [DecidableEq X] (θ : Params E)

omit [Fintype V] in
theorem arrivingForest_eq (top : E → Finset (Finset X)) (v : V) :
    N.arrivingForest top v = Phylogenetics.arrivingForest N.toRooted top v := rfl

omit [Fintype V] in
/-- The Challenge's allocation `∏ r, γ (a r)` is the library's `allocationWeight 0`. -/
theorem allocationFactor_eq (F : Finset (Finset X)) (v : V) (bot : E → Finset (Finset X)) :
    N.allocationFactor θ F v bot =
      Phylogenetics.allocationFactor N.toRooted θ.toMetric 0 F v bot := by
  unfold allocationFactor Phylogenetics.allocationFactor
  refine Finset.sum_congr rfl fun a _ => ?_
  exact ite_congr rfl (fun _ => (allocationWeight_rho_zero (γ := fun e :
    {e // N.toRooted.graph.target e = v} => θ.toMetric.inheritance e.val) a).symm) fun _ => rfl

theorem historyWeight_eq (bot top : E → Finset (Finset X)) :
    N.historyWeight θ bot top = Phylogenetics.historyWeight N.toRooted θ.toMetric 0 bot top := by
  unfold historyWeight Phylogenetics.historyWeight
  simp only [allocationFactor_eq, arrivingForest_eq]
  rfl

/-- **The network multispecies coalescent** of the Challenge is the library's, with independent
inheritance. -/
theorem geneTreeDist_eq (G : Finset (Finset X)) :
    N.geneTreeDist θ G = Phylogenetics.geneTreeDist N.toRooted θ.toMetric 0 G := by
  unfold geneTreeDist Phylogenetics.geneTreeDist
  simp only [historyWeight_eq, arrivingForest_eq]
  rfl

/-- The concordance factors of the Challenge are the library's. -/
theorem nmscCF_eq : N.nmscCF θ = Phylogenetics.nmscCF N.toRooted θ.toMetric 0 := by
  funext s
  unfold nmscCF Phylogenetics.nmscCF
  simp only [geneTreeDist_eq]
  rfl

end Network

end Nanuq.Model
