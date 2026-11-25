module

public import Nanuq.Bridge.Statements
public import Nanuq.Algorithm.Counts
public import Nanuq.Algorithm.MissingTaxa
public import Nanuq.QuartetDistance.Class
public import Nanuq.ConcordanceFactors.ThreeTwoCycle
public import Nanuq.Networks.Semidirected

/-! # NANUQ (Allman, Baños, Rhodes 2019): the proof of the statements of record

Restates the theorems of `Nanuq.Challenge` word for word, in the namespace `NanuqChallenge`, and
proves them from the library, through the bridges of `Nanuq.Bridge` between the Challenge's
definitions and the library's. It is the entry point of the library. -/

public section

namespace NanuqChallenge

open Nanuq.Model Filter Topology

/-- **Theorem 36**, with the correction `NoCentroidCF`. On a binary level-1 rooted phylogenetic
network, at valid parameters at which every induced quartet network with a `3₂`-cycle is tree-like
and no set of four taxa has the centroid as concordance factor, there is a sequence of levels
`0 < α_m < 1`, `α_m → 0`, of the T3 test, such that for any level `0 < β < 1` of the star test and
any selections of maximum likelihood topologies, Steps 2 and 3 of NANUQ on `m` independent gene trees
give the network's class of every set of four taxa and the theoretical quartet distance, with
probability tending to one as `m` grows. -/
theorem theorem36 {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X] [Nonempty X]
    {N : Network V E X} (hN : N.IsPhylogenetic) (hBin : N.IsBinary) (hLevel : N.IsLevelOne)
    {θ : Params E} (hθ : N.IsMetric θ) (h32 : N.ThreeTwoTreelike (N.nmscCF θ))
    (hcen : NoCentroidCF (N.nmscCF θ)) :
    ∃ α : ℕ → ℝ, (∀ m, 0 < α m) ∧ (∀ m, 1 ≤ m → α m < 1) ∧ Tendsto α atTop (𝓝 0) ∧
      ∀ β : ℝ, 0 < β → β < 1 → ∀ mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X,
        IsMaxCountSelection mlT → IsMinCountSelection mlC →
        Tendsto (fun m => iidProb (N.geneTreeDist θ) m fun ω =>
          (∀ q : Finset X, q.card = 4 →
            classify mlT mlC (α m) β (quartetCount unroot ω) q = N.networkClass q) ∧
            nanuqDistance (classify mlT mlC (α m) β (quartetCount unroot ω)) = N.networkDistance)
          atTop (𝓝 1) := by
  exact Nanuq.Model.theorem36 hN hBin hLevel hθ h32 hcen

/-- **Theorem 36 for generic parameters**, with the hypothesis as printed. On a binary level-1 rooted
phylogenetic network, off a null set of parameters, at valid parameters at which every induced
quartet network with a `3₂`-cycle is tree-like, there is a sequence of levels `0 < α_m < 1`,
`α_m → 0`, such that for any level `0 < β < 1` and any selections of maximum likelihood topologies,
the distance of Step 3 on `m` independent gene trees is the theoretical quartet distance, with
probability tending to one. -/
theorem theorem36_generic {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
    [Nonempty X] {N : Network V E X} (hN : N.IsPhylogenetic) (hBin : N.IsBinary)
    (hLevel : N.IsLevelOne) :
    ∃ A : Set (Params E), N.IsGenericNull A ∧
      ∀ θ, N.IsMetric θ → θ ∉ A → N.ThreeTwoTreelike (N.nmscCF θ) →
      ∃ α : ℕ → ℝ, (∀ m, 0 < α m) ∧ (∀ m, 1 ≤ m → α m < 1) ∧ Tendsto α atTop (𝓝 0) ∧
        ∀ β : ℝ, 0 < β → β < 1 → ∀ mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X,
          IsMaxCountSelection mlT → IsMinCountSelection mlC →
          Tendsto (fun m => iidProb (N.geneTreeDist θ) m fun ω =>
            nanuqDistance (classify mlT mlC (α m) β (quartetCount unroot ω)) = N.networkDistance)
            atTop (𝓝 1) := by
  exact Nanuq.Model.theorem36_generic hN hBin hLevel

end NanuqChallenge

end
