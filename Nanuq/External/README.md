# The results the paper cites

One directory per source, `Nanuq/External/<Source>/`, with modules `Nanuq.External.<Source>.…`,
declarations in the namespace `External.<Source>`, and a [`README.md`](README.md) giving the source, the
statement, how the paper uses it, whether the source was read, and the argument that proves it.
Each result is stated in its source's terms and proved; none is assumed. These modules import
Mathlib, [`Nanuq/Basic/`](../Basic) and the libraries this repository requires, never the paper's library.

A source that another repository of the collection already formalizes (lean4-phylogenetics, the
hub lean4-phylo-network, or the repository of a paper) is not formalized again
(lean4-phylogenetics, docs/CONVENTIONS.md, Sections 4 and 6).

| Source | Where | What the paper's proofs use |
| --- | --- | --- |
| Allman, Baños, Mitchell, Rhodes 2023 | [`Allman2023/`](Allman2023), proved from lean4-allman2023 | the three quartet trees on four taxa, the LSA network `𝒩⊕` from which `N⁻` is built, and suppressing the nodes of degree 2 of a tree, by which `Q̃` of Definition 20 is read as a quartet tree or a 4-cycle |
| TINNiK (Allman, Baños, Mitchell, Rhodes 2024) | [`Tinnik/`](Tinnik), proved from lean4-tinnik | steps of the proof of its Theorem 4 that the proof of Theorem 36 repeats: gene trees display one quartet tree on each set of four taxa, the centroid is excluded for generic parameters, and the tails of `χ²₂` |
| Mitchell, Allman, Rhodes 2019 | lean4-phylo-network, `PhyloNetwork/External/MitchellAllmanRhodes2019/`, in the namespace `External.MitchellAllmanRhodes2019` | the T3 test of Step 2 ([`Phylogenetics.t3PValue`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Test.lean#L82)), and the bounds of its p-value by the tails of `χ²₁` and `χ²₂` ([`Phylogenetics.QuartetTests.t3PValue_le_chiSqTwoTail`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Test.lean#L724), [`Phylogenetics.QuartetTests.half_chiSqOneTail_le_t3PValue`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Test.lean#L730)), which give its behaviour on and off the null ([`Phylogenetics.QuartetTests.t3Test_null`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Test.lean#L914), [`Phylogenetics.QuartetTests.t3Test_rejects`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Test.lean#L1215)) |
| Rhodes 2020 | lean4-phylo-network, `PhyloNetwork/External/Rhodes2020/`, in the namespace `External.Rhodes2020` | the quartet distance on a tree is its tree metric ([`External.Rhodes2020.theorem2`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/Rhodes2020/Theorem2.lean#L777)), which the source's Theorem 17 restates ([`Nanuq.nanuqDistance_treeClass`](../Algorithm/Consistency.lean#L821)) |
| Huber et al. 2025 | lean4-phylo-network, `PhyloNetwork/External/HuberEtAl2025/`, in the namespace `External.HuberEtAl2025` | Theorem 5.1, forward: the split of a cut edge induces a cut-edge split on each set of four taxa with two on each side ([`External.HuberEtAl2025.theorem5_1_forward`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/HuberEtAl2025/Theorem51.lean#L25)), in the proof of Proposition 9 here |
| Baños 2019, Solís-Lemus, Ané 2016 (the paper's references [1, 3]) | not used | the source of Proposition 9, which the paper states with no proof. The formalization states Proposition 9 in the paper's terms and proves it by its own argument ([`Nanuq.proposition9`](../ConcordanceFactors/Proposition9.lean#L1500), [`Nanuq.proposition9_part2`](../ConcordanceFactors/Proposition9Part2.lean#L725)); no statement of these two papers is used. Baños 2019 is a paper of the hub lean4-phylo-network, whose repository, lean4-banos2019, is in progress |

The libraries' results are used through their statements; the papers formalized in their own
repositories, Allman et al. 2023 and TINNiK, through the statements in [`Allman2023/`](Allman2023) and [`Tinnik/`](Tinnik),
each proved from that repository's theorem (lean4-phylogenetics, docs/CONVENTIONS.md, Section 6).

## What the sources share with the paper's library

The cited results are stated on the definitions of lean4-phylogenetics, of the hub and of the
required repositories (networks, quartet trees, the network multispecies coalescent, the LSA
network and the semidirected network of Allman et al. 2023, labelled graphs, the hypothesis tests
of lean4-phylo-network), so the sources need no definition of the paper. No module here imports the
paper's library.
