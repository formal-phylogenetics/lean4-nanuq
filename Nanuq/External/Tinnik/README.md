# TINNiK (Allman, Baños, Mitchell, Rhodes 2024)

Source: E. S. Allman, H. Baños, J. D. Mitchell, J. A. Rhodes, *TINNiK: inference of the tree of blobs of a
species network under the coalescent model*, Algorithms Mol. Biol. 19 (2024), 23,
<https://doi.org/10.1186/s13015-024-00266-2>. It is a paper of the hub lean4-tob, formalized in its own
repository, [lean4-tinnik](https://github.com/vltanh/lean4-tinnik), which this repository requires; its
[report](https://github.com/vltanh/lean4-tinnik/blob/main/docs/Tinnik/REPORT.md) is the audit of the
source.

NANUQ appeared before TINNiK, and does not cite it. The two algorithms share Step 2's hypothesis tests on
quartet counts, and TINNiK's T3 option is NANUQ's second test: the proof of NANUQ's Theorem 36 here runs
the argument of TINNiK's Theorem 4 for these tests, and uses its steps below. The hypothesis of the
correction of Theorem 36, [`Tinnik.NoCentroidCF`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L334), the condition [`Tinnik.T3Detectable`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L101) of the T3 option, and
the condition [`Tinnik.Covers`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/MissingTaxa.lean#L97) of gene trees on subsets of the taxa are lean4-tinnik's definitions.

Each result that the proofs here use is stated in this directory, in the namespace `External.Tinnik`, in
the source's terms (the definitions of lean4-tinnik and of the libraries), and proved from the theorem of
lean4-tinnik named below; the paper's library uses these statements. None of them has a row in
lean4-tinnik's routes file: they are steps of the proof of TINNiK's Theorem 4, which the source states
without a label.

| Statement | Where the paper's library uses it | Proved from |
| --- | --- | --- |
| [`External.Tinnik.displaysOne_nmsc`](Consistency.lean#L32) ([`Consistency.lean`](Consistency.lean)): gene trees under the network multispecies coalescent display one quartet tree on each set of four taxa | Theorem 36: the concordance factors are read on the counts of displayed quartet trees | [`Tinnik.displaysOne_nmsc`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L244) |
| [`External.Tinnik.isGenericNull_centroid`](Consistency.lean#L41) ([`Consistency.lean`](Consistency.lean)): the centroid `(1/3, 1/3, 1/3)` is excluded for generic parameters | Theorem 36 for generic parameters, with the hypothesis as printed | [`Tinnik.isGenericNull_centroid`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L399) |
| [`External.Tinnik.tendsto_chiSqTwoTail_mul`](Consistency.lean#L49), [`External.Tinnik.tendsto_chiSqTwoTail_comp`](Consistency.lean#L56) ([`Consistency.lean`](Consistency.lean)): `P(χ²₂ > m d) → 0`, and `P(χ²₂ > k_m d) → 0` when `k_m → ∞` | Theorem 36: the levels of the T3 test, with all gene trees and with gene trees on subsets of the taxa | [`Tinnik.tendsto_chiSqTwoTail_mul`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/T3.lean#L403), [`Tinnik.tendsto_chiSqTwoTail_comp`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/MissingTaxa.lean#L311) |
