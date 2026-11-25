# Allman, Baños, Rhodes 2019: NANUQ

Source: E. S. Allman, H. Baños, J. A. Rhodes, *NANUQ: a method for inferring species networks from gene trees under the
coalescent model*, Algorithms Mol. Biol. 14 (2019), 24, <https://doi.org/10.1186/s13015-019-0159-2> (read in arXiv
v1, <https://arxiv.org/abs/1905.07050>, and in the published text, Europe PMC PMC6896299; the passages quoted agree).
"Line N" in the docstrings is line N of the plain text of arXiv v1.

The paper's library is in the namespace `Nanuq`, by the paper's sections; the general lemmas of [`Basic/`](Basic) are in
Mathlib's namespaces, the cited results of [`External/`](External) in `External.<Source>`, and the definitions of the Challenge, in
[`Defs.lean`](Defs.lean), in `Nanuq.Model`. The statements of record are those of the Challenge, [`palomar/Nanuq/Challenge.lean`](../palomar/Nanuq/Challenge.lean);
[`Bridge/Model.lean`](Bridge/Model.lean) proves that its definitions are the library's, and [`Bridge/Statements.lean`](Bridge/Statements.lean) proves its theorems
from [`Nanuq.theorem36`](Algorithm/Theorem36.lean#L53) and [`Nanuq.theorem36_generic`](Algorithm/Theorem36.lean#L81).

ECToBlob's Remark 8.3 says that the argument of its Theorem 8.2 strengthens the source's consistency result.
`lean4-ectoblob/ECToBlob/Remark83.lean` proves that, from the results here.

## Modules

| Directory | Modules | Content |
| --- | --- | --- |
| [`Networks/`](Networks) (Phylogenetic networks) | [`QuartetNetwork`](Networks/QuartetNetwork.lean), [`Semidirected`](Networks/Semidirected.lean) | Definitions 4 and 5, the types of cycle `m_k`, on `N⁺` and on `N⁻` of Allman et al. 2023, and the `3₂`-cycles by blocks |
| [`ConcordanceFactors/`](ConcordanceFactors) (The NMSC and quartet concordance factors) | [`Placement`](ConcordanceFactors/Placement.lean), [`Proposition9`](ConcordanceFactors/Proposition9.lean), [`Proposition9Part2`](ConcordanceFactors/Proposition9Part2.lean), [`ThreeTwoCycle`](ConcordanceFactors/ThreeTwoCycle.lean) | Proposition 9 on binary level-1 networks; the concordance factors of a network with a `3₂`-cycle (Proposition 10, Figure 5) |
| [`QuartetDistance/`](QuartetDistance) (Quartet distance for level-1 networks) | [`Contract`](QuartetDistance/Contract.lean), [`Cycle`](QuartetDistance/Cycle.lean), [`Form`](QuartetDistance/Form.lean), [`Class`](QuartetDistance/Class.lean) | `Q̃` of Definition 20, a quartet tree or a 4-cycle; `ρ_xy` and the distance of Definition 22 in the source's terms, and the bridges to the library's |
| [`Algorithm/`](Algorithm) (The NANUQ algorithm) | [`Consistency`](Algorithm/Consistency.lean), [`Theorem36`](Algorithm/Theorem36.lean), [`MissingTaxa`](Algorithm/MissingTaxa.lean), [`Counts`](Algorithm/Counts.lean) | Steps 2 and 3, Theorem 36 and its errors, gene trees on subsets of the taxa, the running time |
| [`Basic/`](Basic), [`External/`](External) | | General lemmas on lists; the results of Allman et al. 2023 and TINNiK that the proofs use, proved from their repositories |
| [`Defs.lean`](Defs.lean), [`Bridge/`](Bridge) | [`Defs`](Defs.lean), [`Model`](Bridge/Model.lean), [`Statements`](Bridge/Statements.lean) | The definitions of the Challenge, and the proof that they are the library's |

## What is formalized (`Algorithm/Consistency.lean`)

* Step 2 of the algorithm: [`classify`](Algorithm/Consistency.lean#L95), with the star test and the T3 test at levels `β`, `α`. Its printed statistics are
  [`starStat`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/Testing/Defs.lean#L52) and [`t3Stat`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Test.lean#L60) ([`starStat_eq_printed`](Algorithm/Consistency.lean#L309), [`t3Stat_eq_printed`](Algorithm/Consistency.lean#L343)).
* Step 3, the network quartet distance of Definition 22 with the source's extension to star trees: `rho`,
  [`nanuqDistance`](Algorithm/Consistency.lean#L113). It is not TINNiK's distance: they differ at `x ≠ y` by the number of 4-cycles with `x, y` adjacent
  ([`quartetDistance_sub_nanuqDistance`](Algorithm/Consistency.lean#L746)), and agree without 4-cycles ([`nanuqDistance_eq_quartetDistance`](Algorithm/Consistency.lean#L800)). On a tree it is
  the tree metric of Rhodes 2020 ([`nanuqDistance_treeClass`](Algorithm/Consistency.lean#L821), the source's Theorem 17).
* Theorem 36, down to the distance, which is what its proof shows: [`theorem36_of_proposition9`](Algorithm/Consistency.lean#L1361), with
  [`theorem36_output_of_proposition9`](Algorithm/Consistency.lean#L1379) for the steps after it, and [`theorem36_generic_of_proposition9`](Algorithm/Consistency.lean#L1396). The proof is the
  source's: the star test by linear growth of the statistic, the second test by non-collapse under the null, and by linear
  growth off it, with a level per set of four taxa.

## What is formalized (`ConcordanceFactors/`, `Algorithm/Theorem36.lean`)

* Proposition 9, parts 1 and 3, on binary level-1 networks, at any `0 ≤ ρ ≤ 1`: [`proposition9`](ConcordanceFactors/Proposition9.lean#L1500). The source takes it from
  its references and prints no proof, so the proof is new. It uses the facts on blobs of level-1 networks in
  lean4-phylo-network ([`PhyloNetwork.Level1Blobs`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/Level1Blobs.lean), [`PhyloNetwork.Wedge`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/Wedge.lean), [`PhyloNetwork.Level1Blocks`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/Level1Blocks.lean)), and Theorem 5.1 of
  Huber et al. 2025. It places lineages at vertices (`Placement.placeInj`) and moves them up by the Markov property; it
  has no formula in the branch lengths. [`ConcordanceFactors/Proposition9.lean`](ConcordanceFactors/Proposition9.lean) has the argument.
* Proposition 9, part 2: [`proposition9_part2`](ConcordanceFactors/Proposition9Part2.lean#L725), in [`ConcordanceFactors/Proposition9Part2.lean`](ConcordanceFactors/Proposition9Part2.lean), with the bound
  `CF_AB|CD ≥ 1/6`. Two lineages at a reticulation take one parent with probability at least `1/2`, and from there the
  masses are tree-like. "May or may not be tree-like": [`ThreeTwo.isT1Strict_N₃`](ConcordanceFactors/ThreeTwoCycle.lean#L1098), [`ThreeTwo.exists_not_isT3Null_N₃`](ConcordanceFactors/ThreeTwoCycle.lean#L1173).
* The structure of a `4₁`-cycle: [`exists_cycle_of_not_isTreelike`](ConcordanceFactors/Proposition9.lean#L764), [`not_isTreelike_iff`](ConcordanceFactors/Proposition9.lean#L847), and [`exists_two_displayed`](ConcordanceFactors/Proposition9.lean#L1374) for the
  two quartet trees the grove displays.
* Theorem 36 with Proposition 9 proved: [`Nanuq.theorem36`](Algorithm/Theorem36.lean#L53), [`theorem36_output`](Algorithm/Theorem36.lean#L69), [`Nanuq.theorem36_generic`](Algorithm/Theorem36.lean#L81), in
  [`Algorithm/Theorem36.lean`](Algorithm/Theorem36.lean). Also [`t3Detectable`](Algorithm/Theorem36.lean#L26).

## What is formalized (`Algorithm/MissingTaxa.lean`, `Algorithm/Counts.lean`)

* Gene trees on subsets of the taxa, as the source's input says: the counts of Step 1 are [`Phylogenetics.quartetCountOn`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/Testing/MissingTaxa.lean#L46),
  and [`theorem36_missing`](Algorithm/MissingTaxa.lean#L196), [`theorem36_generic_missing`](Algorithm/MissingTaxa.lean#L211) are the theorem when each set of four taxa is on more and more
  gene trees ([`Tinnik.Covers`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/MissingTaxa.lean#L97)). The source does not state this.
* The running time: [`nanuqOperations_le`](Algorithm/Counts.lean#L35), `O(n⁴ m)`, with Steps 4 and 5 as costs bounded as the source says.

## What is a hypothesis

[`Nanuq.theorem36`](Algorithm/Theorem36.lean#L53) has two: [`ThreeTwoTreelike`](Algorithm/Consistency.lean#L1186), the hypothesis as printed, and [`Tinnik.NoCentroidCF`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L334), the correction below.
[`Nanuq.theorem36_generic`](Algorithm/Theorem36.lean#L81) has only the first.

[`theorem36_output`](Algorithm/Theorem36.lean#L69) also has the hypothesis that the steps after the distance return the wanted object on the theoretical
distance. That is what the source's Theorem 34, Corollary 24 and its references [6, 7] say.

## The source's definitions (`Networks/`, `QuartetDistance/`)

The source reads the types of cycle and `Q̃` on `N⁻` and `N_c⁻`. These are defined as printed, on a binary level-1 network:

* Definition 5: [`Quartet.trekArcs`](Networks/QuartetNetwork.lean#L86), the edges in simple treks of `N⁻`. [`Quartet.trekArcs_eq_wedgeArcs`](Networks/QuartetNetwork.lean#L293): these are the
  arcs of TOB-QMC's subnetwork, [`RootedNetwork.wedgeArcs`](https://github.com/vltanh/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/Wedge.lean#L87), for every network, since a simple semidirected trek is a
  directed one.
* `m_k`-cycles (line 399): [`Quartet.HasCycleType`](Networks/QuartetNetwork.lean#L108), with [`Quartet.cycleSize`](Networks/QuartetNetwork.lean#L100) the number of vertices of the cycle of degree
  other than two in the graph of the kept edges.
* `Q̃` (Definition 20): [`Quartet.tildeGraph`](QuartetDistance/Contract.lean#L65), the contraction of the 2- and 3-cycles, and [`Quartet.qTilde`](QuartetDistance/Contract.lean#L423), with
  [`Allman2023.suppressDegreeTwo`](https://github.com/vltanh/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/Networks/BlobDefinitions.lean#L396). [`Allman2023.LabelledGraph.HasQuartetTopology`](https://github.com/vltanh/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/Networks/BlobDefinitions.lean#L437) and [`Quartet.HasFourCycleTopology`](QuartetDistance/Form.lean#L110) are
  the literal tree and the literal 4-cycle.
* `ρ_xy` (Definition 20), `d_{Q,N⁻}` (Definition 22): [`Quartet.rhoTilde`](QuartetDistance/Class.lean#L38), [`Quartet.sourceDistance`](QuartetDistance/Class.lean#L46).

The bridges, all proved: [`Quartet.hasThreeTwoCycle_iff`](Networks/QuartetNetwork.lean#L764); [`Quartet.hasCycleType_four_one_iff`](QuartetDistance/Class.lean#L472);
[`Quartet.networkClass_eq_tree_iff`](QuartetDistance/Class.lean#L180), [`Quartet.networkClass_eq_cycle_iff`](QuartetDistance/Class.lean#L215); [`Quartet.qTilde_tree_or_cycle`](QuartetDistance/Class.lean#L336);
[`Quartet.rho_networkClass_eq`](QuartetDistance/Class.lean#L355); [`Quartet.networkDistance_eq_sourceDistance`](QuartetDistance/Class.lean#L459). No difference was found.
[`Quartet.proposition9_source`](QuartetDistance/Class.lean#L563) states Proposition 9 in these terms.

The representation: [`Networks/QuartetNetwork.lean`](Networks/QuartetNetwork.lean) keeps `LSA(X)`, which Definition 4 suppresses. It is a vertex of
degree two, which Definition 5 suppresses ([`Quartet.keptDegree_lsa_le`](Networks/QuartetNetwork.lean#L317)). [`Networks/Semidirected.lean`](Networks/Semidirected.lean) reads Definition 5
on [`Allman2023.semidirected`](https://github.com/vltanh/lean4-allman2023/blob/46efa61d0988df12649089689ae77bc100be034f/Allman2023/Networks/Definitions.lean#L432), which carries the suppression out, and proves that the readings agree: an edge is kept
exactly when its arc is ([`Quartet.mem_sTrekEdges_iff`](Networks/Semidirected.lean#L534)), the edge merging the two arcs at `LSA(X)` is kept exactly when
the arc it replaces is ([`Quartet.mem_sTrekEdges_merged_iff`](Networks/Semidirected.lean#L574)), the kept edges are the kept arcs other than that one
([`Quartet.image_sTrekEdges`](Networks/Semidirected.lean#L618)), and each vertex of `N⁻` has the same degree in both graphs of kept edges
([`Quartet.sKeptDegree_eq`](Networks/Semidirected.lean#L645)). [`Quartet.cycleSize`](Networks/QuartetNetwork.lean#L100), [`Quartet.qTilde`](QuartetDistance/Contract.lean#L423) and what follows them are built from the kept arcs of
`N`, and are not defined a second time on `N⁻`. Cycles are the blobs of the kept cycles, as the source says of a level-1
network (line 1381), and the contracted graph is proved to be a tree or a graph with one cycle, so that no other cycle
is left.

## What is left out

NeighborNet and the Circular Network algorithm (Steps 4, 5), which are not characterized here. Splits graphs, and all
the source's results about them and about split systems: Theorems 15, 23, 34, Corollaries 16, 24, 31, 35, Lemmas 19, 21,
25-28, 32, 33, Proposition 30. Proposition 10 is checked on the printed formula ([`figure5_lt`](Algorithm/Consistency.lean#L1094)) and on one network
([`ThreeTwo.isT1Strict_N₃`](ConcordanceFactors/ThreeTwoCycle.lean#L1098)), and is not stated for all level-1 networks. The data analyses. The running time is counted
in [`Algorithm/Counts.lean`](Algorithm/Counts.lean), with NeighborNet and the Circular Network algorithm as parameters, not on a machine.

## Two errors in the proof of Theorem 36

1. "we choose `α_m` to be the minimum of the `α'_m`". A level rejects when the p-value is below it, so the level must be
   at least each `α'_m`: the maximum. At the minimum the test need not reject: [`not_rejects_at_minimum`](Algorithm/Consistency.lean#L1049), for two sets of
   four taxa whose limits of the statistic have `40 d₁ < d₂`. The theorem is not affected: [`Nanuq.exists_levels`](Algorithm/Consistency.lean#L660).
2. "Since the network is binary, the true multinomial parameter values are `CF = (p₁, p₂, p₃)` with `p_i ≠ 1/3` or `0`".
   The hypothesis of the theorem, that induced `3₂`-cycles are tree-like, allows the centroid, which Definition 8 calls
   tree-like, and a binary network reaches it. [`ConcordanceFactors/ThreeTwoCycle.lean`](ConcordanceFactors/ThreeTwoCycle.lean) computes the concordance factors
   of a binary level-1 network with a `3₂`-cycle from the definition of the NMSC ([`ThreeTwo.nmscCF_N₃_abcd`](ConcordanceFactors/ThreeTwoCycle.lean#L693)), which
   gives the source's formula, and they are `(1/3, 1/3, 1/3)` at positive branch lengths ([`ThreeTwo.centroid_N₃`](ConcordanceFactors/ThreeTwoCycle.lean#L1024)).
   There the star test rejects with probability tending to `β` only, and the distance does not agree with the
   theoretical one with probability tending to one, for any levels: [`ThreeTwo.not_theorem36AsPrinted_N₃`](ConcordanceFactors/ThreeTwoCycle.lean#L1089). The theorem
   needs [`Tinnik.NoCentroidCF`](https://github.com/vltanh/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/Theorem4.lean#L334), which holds off a null set of parameters ([`External.Tinnik.isGenericNull_centroid`](External/Tinnik/Consistency.lean#L41)), and
   under the condition of the source's Proposition 10 ([`figure5_lt`](Algorithm/Consistency.lean#L1094) on the printed formula; [`ThreeTwo.theorem36_N₃`](ConcordanceFactors/ThreeTwoCycle.lean#L1128) on
   this network).

The proof also uses, without saying so, that the maximum likelihood topologies are the true ones with probability tending
to one: [`tendsto_maxCount_t3`](Algorithm/Consistency.lean#L518), [`tendsto_minCount`](Algorithm/Consistency.lean#L540). The source's `α'_m = P(W_m > md/2)` is not a number, since the law `W_m`
depends on an estimate from the data; the proof here takes the bound `P(χ²₂ > md/2)` ([`tendsto_t3PValue_lt_level`](Algorithm/Consistency.lean#L642)).
