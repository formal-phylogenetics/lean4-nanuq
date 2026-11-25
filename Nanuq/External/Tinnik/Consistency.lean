module

public import Tinnik.Consistency.Theorem4
public import Tinnik.Consistency.T3
public import Tinnik.Consistency.MissingTaxa

/-!
# TINNiK (Allman, Baños, Mitchell, Rhodes 2024): steps of the proof of its Theorem 4

The proof of NANUQ's Theorem 36 runs the star test and the T3 test on every set of four taxa, as
TINNiK's Theorem 4 and its T3 option do, and uses these steps of TINNiK's proof: gene trees under
the network multispecies coalescent display one quartet tree on each set of four taxa, the centroid
`CF = (1/3, 1/3, 1/3)` is excluded for generic parameters, and the tails `P(χ²₂ > m d)` tend to zero.

Each result is stated in the source's terms, those of lean4-tinnik and of the libraries, and proved
from the theorem of lean4-tinnik named in its docstring.
-/

@[expose] public noncomputable section

open Phylogenetics Phylogenetics.RootedNetwork Filter Topology
open scoped Classical

namespace External.Tinnik

variable {V E X : Type*} [Fintype X] [DecidableEq X]

/-- Gene trees under the network multispecies coalescent are binary, so they display one quartet
tree on each set of four taxa: the step of the proof of TINNiK's Theorem 4 that reads the
concordance factors on the counts of displayed quartet trees. lean4-tinnik proves it as
`Tinnik.displaysOne_nmsc`. -/
theorem displaysOne_nmsc [Fintype V] [Fintype E] [Nonempty X] {N : RootedNetwork V E X}
    (hN : N.IsPhylogenetic) {θ : MetricData E} {ρ : ℝ} :
    QuartetTests.DisplaysOne (geneTreeDist N θ ρ) (unroot (L := X)) :=
  _root_.Tinnik.displaysOne_nmsc hN

/-- **The centroid is excluded for generic parameters**, the step before TINNiK's Theorem 4: for a
rooted binary phylogenetic network, the parameters at which some set of four taxa has
`CF = (1/3, 1/3, 1/3)` under the network multispecies coalescent with independent inheritance form
a null set. lean4-tinnik proves it as `Tinnik.isGenericNull_centroid`. -/
theorem isGenericNull_centroid [Fintype V] [Fintype E] {N : RootedNetwork V E X}
    (hN : N.IsPhylogenetic) (hBin : N.IsBinary) :
    IsGenericNull N {θ | N.IsMetric θ ∧ ¬ _root_.Tinnik.NoCentroidCF (nmscCF N θ 0)} :=
  _root_.Tinnik.isGenericNull_centroid hN hBin

/-- `P(χ²₂ > m d) = exp(-m d / 2)` tends to zero, for `d > 0`: the step of the T3 option of
TINNiK's Theorem 4 that makes the T3 test reject off its null. lean4-tinnik proves it as
`Tinnik.tendsto_chiSqTwoTail_mul`. -/
theorem tendsto_chiSqTwoTail_mul {d : ℝ} (hd : 0 < d) :
    Tendsto (fun m : ℕ => chiSqTwoTail (m * d)) atTop (𝓝 0) :=
  _root_.Tinnik.tendsto_chiSqTwoTail_mul hd

/-- `P(χ²₂ > k_m d)` tends to zero when `k_m → ∞`, for `d > 0`: the same step with gene trees on
subsets of the taxa, a set of four taxa being on `k_m` of the `m` gene trees. lean4-tinnik proves it
as `Tinnik.tendsto_chiSqTwoTail_comp`. -/
theorem tendsto_chiSqTwoTail_comp {k : ℕ → ℕ} (hk : Tendsto k atTop atTop) {d : ℝ} (hd : 0 < d) :
    Tendsto (fun m => chiSqTwoTail (k m * d)) atTop (𝓝 0) :=
  _root_.Tinnik.tendsto_chiSqTwoTail_comp hk hd

end External.Tinnik
