module

public import Nanuq.Bridge.Model

/-!
# The main results on the Challenge's definitions

Theorem 36, as the Challenge states it on the definitions of `Nanuq.Defs`, with the correction of
its hypothesis and for generic parameters, proved from the paper's library (`Nanuq.theorem36`,
`Nanuq.theorem36_generic`) through the bridges of `Nanuq.Bridge.Model`.
-/

@[expose] public noncomputable section

open Filter Topology Phylogenetics Phylogenetics.RootedNetwork

namespace Nanuq.Model

variable {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]

omit [Fintype V] [Fintype E] in
/-- The event of Theorem 36 on the Challenge's definitions is the library's. -/
theorem event_iff (N : Network V E X) (mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X)
    (α β : ℝ) (c : QuartetTree X → ℝ) :
    ((∀ q : Finset X, q.card = 4 → classify mlT mlC α β c q = N.networkClass q) ∧
        nanuqDistance (classify mlT mlC α β c) = N.networkDistance) ↔
      ((∀ q : Finset X, q.card = 4 → Nanuq.classify mlT mlC α β c q = Nanuq.networkClass N.toRooted q) ∧
        Nanuq.nanuqDistance (Nanuq.classify mlT mlC α β c) = Nanuq.networkDistance N.toRooted) := by
  have hcl : QuartetClass.toLib ∘ classify mlT mlC α β c = Nanuq.classify mlT mlC α β c :=
    funext fun q => classify_eq mlT mlC α β c q
  have hq : ∀ q, classify mlT mlC α β c q = N.networkClass q ↔
      Nanuq.classify mlT mlC α β c q = Nanuq.networkClass N.toRooted q := fun q => by
    rw [← classify_eq, ← N.networkClass_eq]
    exact QuartetClass.toLib_injective.eq_iff.symm
  rw [nanuqDistance_eq, hcl, N.networkDistance_eq]
  simp only [hq]

/-- **Theorem 36**, on the Challenge's definitions, with the correction `NoCentroidCF`. -/
theorem theorem36 [Nonempty X] {N : Network V E X} (hN : N.IsPhylogenetic) (hBin : N.IsBinary)
    (hLevel : N.IsLevelOne) {θ : Params E} (hθ : N.IsMetric θ)
    (h32 : N.ThreeTwoTreelike (N.nmscCF θ)) (hcen : NoCentroidCF (N.nmscCF θ)) :
    ∃ α : ℕ → ℝ, (∀ m, 0 < α m) ∧ (∀ m, 1 ≤ m → α m < 1) ∧ Tendsto α atTop (𝓝 0) ∧
      ∀ β : ℝ, 0 < β → β < 1 → ∀ mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X,
        IsMaxCountSelection mlT → IsMinCountSelection mlC →
        Tendsto (fun m => iidProb (N.geneTreeDist θ) m fun ω =>
          (∀ q : Finset X, q.card = 4 →
            classify mlT mlC (α m) β (quartetCount unroot ω) q = N.networkClass q) ∧
            nanuqDistance (classify mlT mlC (α m) β (quartetCount unroot ω)) = N.networkDistance)
          atTop (𝓝 1) := by
  rw [N.nmscCF_eq θ] at h32 hcen
  obtain ⟨α, hαpos, hαlt, hα₀, h⟩ :=
    Nanuq.theorem36 ((N.isPhylogenetic_iff).mp hN) ((N.isBinary_iff).mp hBin)
      ((N.isLevelOne_iff).mp hLevel) ((N.isMetric_iff θ).mp hθ) ((N.threeTwoTreelike_iff _).mp h32)
      ((noCentroidCF_iff _).mp hcen)
  refine ⟨α, hαpos, hαlt, hα₀, fun β hβ hβ₁ mlT mlC hmlT hmlC => ?_⟩
  have hdist : N.geneTreeDist θ = Phylogenetics.geneTreeDist N.toRooted θ.toMetric 0 :=
    funext (N.geneTreeDist_eq θ)
  refine (h β hβ hβ₁ mlT mlC ((isMaxCountSelection_iff mlT).mp hmlT)
    ((isMinCountSelection_iff mlC).mp hmlC)).congr fun m => ?_
  rw [hdist, iidProb_eq]
  exact congrArg _ (funext fun ω => propext (event_iff N mlT mlC _ β _).symm)

/-- **Theorem 36 for generic parameters**, on the Challenge's definitions, with the hypothesis as
printed. -/
theorem theorem36_generic [Nonempty X] {N : Network V E X} (hN : N.IsPhylogenetic)
    (hBin : N.IsBinary) (hLevel : N.IsLevelOne) :
    ∃ A : Set (Params E), N.IsGenericNull A ∧
      ∀ θ, N.IsMetric θ → θ ∉ A → N.ThreeTwoTreelike (N.nmscCF θ) →
      ∃ α : ℕ → ℝ, (∀ m, 0 < α m) ∧ (∀ m, 1 ≤ m → α m < 1) ∧ Tendsto α atTop (𝓝 0) ∧
        ∀ β : ℝ, 0 < β → β < 1 → ∀ mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X,
          IsMaxCountSelection mlT → IsMinCountSelection mlC →
          Tendsto (fun m => iidProb (N.geneTreeDist θ) m fun ω =>
            nanuqDistance (classify mlT mlC (α m) β (quartetCount unroot ω)) = N.networkDistance)
            atTop (𝓝 1) := by
  obtain ⟨A, hA, h⟩ := Nanuq.theorem36_generic (X := X) ((N.isPhylogenetic_iff).mp hN)
    ((N.isBinary_iff).mp hBin) ((N.isLevelOne_iff).mp hLevel)
  refine ⟨Params.toMetric ⁻¹' A, (N.isGenericNull_iff A).mpr hA, fun θ hθ hθA h32 => ?_⟩
  rw [N.nmscCF_eq θ] at h32
  obtain ⟨α, hαpos, hαlt, hα₀, h'⟩ :=
    h θ.toMetric ((N.isMetric_iff θ).mp hθ) hθA ((N.threeTwoTreelike_iff _).mp h32)
  refine ⟨α, hαpos, hαlt, hα₀, fun β hβ hβ₁ mlT mlC hmlT hmlC => ?_⟩
  have hdist : N.geneTreeDist θ = Phylogenetics.geneTreeDist N.toRooted θ.toMetric 0 :=
    funext (N.geneTreeDist_eq θ)
  refine (h' β hβ hβ₁ mlT mlC ((isMaxCountSelection_iff mlT).mp hmlT)
    ((isMinCountSelection_iff mlC).mp hmlC)).congr fun m => ?_
  rw [hdist, iidProb_eq]
  refine congrArg _ (funext fun ω => ?_)
  have hcl : QuartetClass.toLib ∘ classify mlT mlC (α m) β (quartetCount unroot ω) =
      Nanuq.classify mlT mlC (α m) β (Phylogenetics.quartetCount Phylogenetics.unroot ω) :=
    funext fun q => classify_eq mlT mlC (α m) β _ q
  rw [nanuqDistance_eq, hcl, N.networkDistance_eq]

end Nanuq.Model
