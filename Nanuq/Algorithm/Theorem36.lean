module

public import Nanuq.ConcordanceFactors.Proposition9

/-!
# Theorem 36: the statistical consistency of NANUQ

The source's consistency theorem, with Proposition 9 proved on binary level-1 networks
(`proposition9`): `theorem36`, `theorem36_output`, `theorem36_generic`, and `t3Detectable` for the T3
option. The argument is `theorem36_of_proposition9`, in `Nanuq/Algorithm/Consistency.lean`, which
has the source's proof and its two corrections.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork Phylogenetics.NMSC Finset Filter Topology
open PhyloNetwork PhyloNetwork.Level1
open scoped Classical

namespace Nanuq

variable {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
variable {N : RootedNetwork V E X} {θ : MetricData E} {ρ : ℝ}

/-- The hypotheses of Theorem 36 give what the T3 test needs, in lean4-tinnik's `Tinnik/Consistency/T3.lean`, on a binary level-1 network. -/
theorem t3Detectable [Nonempty X] (hN : N.IsPhylogenetic) (hBin : N.IsBinary) (hLevel : IsLevelOne N)
    (hθ : N.IsMetric θ) (hρ : 0 ≤ ρ ∧ ρ ≤ 1) (h32 : ThreeTwoTreelike N (nmscCF N θ ρ))
    (hcen : Tinnik.NoCentroidCF (nmscCF N θ ρ)) :
    Tinnik.T3Detectable N (nmscCF N θ ρ) :=
  t3Detectable_of_proposition9 hN hLevel hθ hρ (proposition9 hN hBin hLevel hθ hρ) h32 hcen

/-- **Theorem 36** (`nanuq:theorem36`), the part that is mathematics. "Under the NMSC model on a binary level-1 metric
phylogenetic network `N⁺`, for numerical parameters in which all induced quartet networks with `3₂`-cycles are
tree-like, there exists a sequence `α₁, α₂, …`, with `0 < α_m < 1` and `α_m → 0` such that for any `0 < β < 1` the
NANUQ algorithm with significance levels `α_m` and `β` on a data set of `m` gene trees will, with probability
approaching 1 as `m → ∞`, infer the binary unrooted phylogenetic network associated to `N⁺` by Theorem 34."

The conclusion here is what the source's proof shows: the distance of Step 3 exactly agrees with the theoretical
quartet distance (line 2009). `theorem36_output` gives the steps after it. The hypotheses are as follows.

* `h32`, the hypothesis of the theorem as printed.
* `hcen`, not in the source. **Correction of the statement**: tree-like in the sense of Definition 8 includes the
  centroid, which a `3₂`-cycle reaches (`figure5_centroid`). There the theorem as printed fails, at the level of the
  distance (`not_theorem36AsPrinted`). For generic parameters it holds (`theorem36_generic`).

Proposition 9 is proved (`proposition9`), for binary level-1 networks. The level-1 hypothesis is used also in
`isT1Strict_of_inducedCutSplit`.

The proof follows the source. The star test (`tendsto_starPValue_lt`) and the second test on a tree-like concordance
factor (`tendsto_maxCount_t3`) are as printed; off the null the statistic grows like `m d` (`tendsto_half_lt_t3Stat`).
Departure from the paper: `α'_m` and `α_m` of the source are changed as `tendsto_t3PValue_lt_level` and
`exists_levels` say, the second since the printed choice of a minimum does not work (`not_rejects_at_minimum`). -/
theorem theorem36 [Nonempty X] (hN : N.IsPhylogenetic) (hBin : N.IsBinary) (hLevel : IsLevelOne N) (hθ : N.IsMetric θ)
    (h32 : ThreeTwoTreelike N (nmscCF N θ 0)) (hcen : Tinnik.NoCentroidCF (nmscCF N θ 0)) :
    ∃ α : ℕ → ℝ, (∀ m, 0 < α m) ∧ (∀ m, 1 ≤ m → α m < 1) ∧ Tendsto α atTop (𝓝 0) ∧
      ∀ β : ℝ, 0 < β → β < 1 → ∀ mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X,
        IsMaxCountSelection mlT → IsMinCountSelection mlC →
        Tendsto (fun m => iidProb (geneTreeDist N θ 0) m fun ω =>
          (∀ q : Finset X, q.card = 4 → classify mlT mlC (α m) β (quartetCount unroot ω) q = networkClass N q) ∧
            nanuqDistance (classify mlT mlC (α m) β (quartetCount unroot ω)) = networkDistance N)
          atTop (𝓝 1) :=
  theorem36_of_proposition9 hN hLevel hθ (proposition9 hN hBin hLevel hθ ⟨le_rfl, zero_le_one⟩) h32 hcen

/-- **The steps after the distance.** NeighborNet and the Circular Network algorithm (Steps 4, 5), with the reading of
the splits graph by Theorem 34, are not formalized. Whatever they are, they compute a function `A` of the distance, so
that if they give the wanted object `y` on the theoretical distance, as the source's Corollary 24 and Theorem 34 and
the references [6, 7] say, they give it with probability tending to one on the sample. The hypothesis `hA` is that
statement. -/
theorem theorem36_output [Nonempty X] (hN : N.IsPhylogenetic) (hBin : N.IsBinary) (hLevel : IsLevelOne N)
    (hθ : N.IsMetric θ) (h32 : ThreeTwoTreelike N (nmscCF N θ 0)) (hcen : Tinnik.NoCentroidCF (nmscCF N θ 0)) :
    ∃ α : ℕ → ℝ, (∀ m, 0 < α m) ∧ (∀ m, 1 ≤ m → α m < 1) ∧ Tendsto α atTop (𝓝 0) ∧
      ∀ β : ℝ, 0 < β → β < 1 → ∀ mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X,
        IsMaxCountSelection mlT → IsMinCountSelection mlC →
        ∀ {Y : Type*} (A : (X → X → ℝ) → Y) (y : Y), A (networkDistance N) = y →
        Tendsto (fun m => iidProb (geneTreeDist N θ 0) m fun ω =>
          A (nanuqDistance (classify mlT mlC (α m) β (quartetCount unroot ω))) = y) atTop (𝓝 1) :=
  theorem36_output_of_proposition9 hN hLevel hθ (proposition9 hN hBin hLevel hθ ⟨le_rfl, zero_le_one⟩) h32 hcen

/-- **Theorem 36 for generic parameters**, with the hypothesis as printed. The centroid is excluded on a null set of
parameters of a binary network (`External.Tinnik.isGenericNull_centroid`). -/
theorem theorem36_generic [Nonempty X] (hN : N.IsPhylogenetic) (hBin : N.IsBinary) (hLevel : IsLevelOne N) :
    ∃ A : Set (MetricData E), IsGenericNull N A ∧
      ∀ θ, N.IsMetric θ → θ ∉ A → ThreeTwoTreelike N (nmscCF N θ 0) →
      ∃ α : ℕ → ℝ, (∀ m, 0 < α m) ∧ (∀ m, 1 ≤ m → α m < 1) ∧ Tendsto α atTop (𝓝 0) ∧
        ∀ β : ℝ, 0 < β → β < 1 → ∀ mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X,
          IsMaxCountSelection mlT → IsMinCountSelection mlC →
          Tendsto (fun m => iidProb (geneTreeDist N θ 0) m fun ω =>
            nanuqDistance (classify mlT mlC (α m) β (quartetCount unroot ω)) = networkDistance N)
            atTop (𝓝 1) := by
  obtain ⟨A, hA, h⟩ := theorem36_generic_of_proposition9 (X := X) hN hBin hLevel
  exact ⟨A, hA, fun θ hθ hθA h32 => h θ hθ hθA (proposition9 hN hBin hLevel hθ ⟨le_rfl, zero_le_one⟩) h32⟩

end Nanuq

/-! ### Former names

The names under which lean4-ectoblob uses these declarations, in the namespace
`External.AllmanBanosRhodes2019`: the definitions exported into it, and deprecated aliases of the
theorems. -/

@[deprecated (since := "2026-11-25")] alias External.AllmanBanosRhodes2019.theorem36 := Nanuq.theorem36
