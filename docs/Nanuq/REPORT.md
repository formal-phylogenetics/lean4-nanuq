# Audit of NANUQ and its formalization

E. S. Allman, H. Baños, J. A. Rhodes, *NANUQ: a method for inferring species networks from gene trees under the
coalescent model*, Algorithms Mol. Biol. 14 (2019), 24, <https://doi.org/10.1186/s13015-019-0159-2>, read in arXiv v1
(<https://arxiv.org/abs/1905.07050>) and in the published text (Europe PMC, PMC6896299). "Line N" is line N of the plain
text of arXiv v1. The paper's TeX source was not read.

The formalization is in progress: it covers the paper's hypothesis tests and distance (Steps 2 and 3 of the algorithm),
its consistency theorem down to the distance, its Proposition 9, and the definitions these need. Section 9 lists the
rest.

## 1. Summary

- **Statements of record.** The Challenge, [`palomar/Nanuq/Challenge.lean`](../../palomar/Nanuq/Challenge.lean), states Theorem 36 on definitions written in
  Mathlib's vocabulary: [`NanuqChallenge.theorem36`](../../palomar/Nanuq/Challenge.lean#L589), with the correction of its hypothesis (E1), and
  [`NanuqChallenge.theorem36_generic`](../../palomar/Nanuq/Challenge.lean#L609), with the hypothesis as printed, for generic parameters. Both conclude at the
  distance of Step 3, which is what the paper's proof shows. The Solution proves them from the library.
- **Proved.** Proposition 9, all three parts, on binary level-1 networks, at any inheritance correlation `0 ≤ ρ ≤ 1`
  ([`Nanuq.proposition9`](../../Nanuq/ConcordanceFactors/Proposition9.lean#L1500), [`Nanuq.proposition9_part2`](../../Nanuq/ConcordanceFactors/Proposition9Part2.lean#L725)), and in the paper's own terms ([`Nanuq.Quartet.proposition9_source`](../../Nanuq/QuartetDistance/Class.lean#L563));
  Theorem 36, corrected ([`Nanuq.theorem36`](../../Nanuq/Algorithm/Theorem36.lean#L53)), for generic parameters ([`Nanuq.theorem36_generic`](../../Nanuq/Algorithm/Theorem36.lean#L81)), with the steps after the
  distance as a hypothesis ([`Nanuq.theorem36_output`](../../Nanuq/Algorithm/Theorem36.lean#L69)), and with gene trees on subsets of the taxa
  ([`Nanuq.theorem36_missing`](../../Nanuq/Algorithm/MissingTaxa.lean#L196)); Definitions 4, 5, 20 and 22, with the bridges between the paper's reading on quartet
  networks and the library's on whole networks; the network quartet distance on a tree, the paper's Theorem 17
  ([`Nanuq.nanuqDistance_treeClass`](../../Nanuq/Algorithm/Consistency.lean#L821)); the running time `O(n⁴ m)`, with Steps 4 and 5 as costs ([`Nanuq.nanuqOperations_le`](../../Nanuq/Algorithm/Counts.lean#L35)).
- **Assumed.** Nothing: no result of the literature is assumed, and there is no `sorry` or `axiom` outside the
  Challenge's statements. [`Nanuq.theorem36_output`](../../Nanuq/Algorithm/Theorem36.lean#L69) has as a hypothesis what Steps 4 and 5, which are not formalized,
  must give on the theoretical distance; it is not a cited result.
- **Findings.** Theorem 36 is false as printed (E1); its proof chooses the wrong level (E2), uses an undetermined
  quantity as a level (E3), and passes over a step (E4); a definition has a misprint (E84). Section 3.
- **No person has reviewed the proofs.**

## 2. Results from prior work and how the paper uses them

| Source | What the paper uses | Where it is proved |
| --- | --- | --- |
| Baños 2019; Solís-Lemus, Ané 2016 (references [1, 3]) | Proposition 9, which the paper states with no proof, "from [1, 3]" | Not used: Proposition 9 is proved here by an argument of its own (Section 7). The two papers were not read |
| Mitchell, Allman, Rhodes 2019 | the T3 test of Step 2, and its asymptotic law | lean4-phylo-network, `PhyloNetwork/External/MitchellAllmanRhodes2019/`: the test ([`Phylogenetics.t3PValue`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/MitchellAllmanRhodes2019/T3Test.lean#L82)) and the bounds of its p-value that the proof of Theorem 36 needs |
| Rhodes 2020, Theorem 2 | the quartet distance on a tree is its tree metric, which Theorem 17 restates | lean4-phylo-network, [`External.Rhodes2020.theorem2`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/Rhodes2020/Theorem2.lean#L777) |
| Huber et al. 2025, Theorem 5.1 | not cited by the paper; the proof of Proposition 9 here uses its forward direction | lean4-phylo-network, [`External.HuberEtAl2025.theorem5_1_forward`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/HuberEtAl2025/Theorem51.lean#L25) |
| Allman et al. 2023 | not cited by the paper, which is earlier; the formalization reads `N⁻`, `Q̃` and the literal topologies in its language | lean4-allman2023, through the statements of [`Nanuq/External/Allman2023/`](../../Nanuq/External/Allman2023) |
| TINNiK | not cited by the paper, which is earlier; the proof of Theorem 36 repeats the argument of TINNiK's Theorem 4 for the same tests | lean4-tinnik, through the statements of [`Nanuq/External/Tinnik/`](../../Nanuq/External/Tinnik) |
| NeighborNet, the Circular Network algorithm (references [6, 7]) | Steps 4 and 5 of the algorithm | Not formalized (Section 9) |

The statements of Allman et al. 2023 and TINNiK in [`Nanuq/External/`](../../Nanuq/External) are proved from the theorems of their repositories,
which [`Nanuq/External/README.md`](../../Nanuq/External/README.md) and the READMEs of the two directories name.

## 3. Errors and gaps in the paper

**E1. Theorem 36 is false as printed.** Its hypothesis, "all induced quartet networks with `3₂`-cycles are tree-like",
allows the centroid `CF = (1/3, 1/3, 1/3)`, which Definition 8 calls tree-like; the proof says "Since the network is
binary, the true multinomial parameter values are `CF = (p₁, p₂, p₃)` with `p_i ≠ 1/3` or `0`" (line 2023). A binary
level-1 network with a `3₂`-cycle has the centroid as concordance factor at positive branch lengths
([`Nanuq.ThreeTwo.centroid_N₃`](../../Nanuq/ConcordanceFactors/ThreeTwoCycle.lean#L1024), from the definition of the coalescent, [`Nanuq.ThreeTwo.nmscCF_N₃_abcd`](../../Nanuq/ConcordanceFactors/ThreeTwoCycle.lean#L693), which gives the
paper's formula of Figure 5). There the star test rejects with probability tending to `β` only, and for no levels does
the distance agree with the theoretical one with probability tending to one ([`Nanuq.not_tendsto_of_centroid`](../../Nanuq/Algorithm/Consistency.lean#L1120),
[`Nanuq.ThreeTwo.not_theorem36AsPrinted_N₃`](../../Nanuq/ConcordanceFactors/ThreeTwoCycle.lean#L1089), on the statement [`Nanuq.Theorem36AsPrinted`](../../Nanuq/Algorithm/Consistency.lean#L1454), which has the printed hypothesis
and quantifiers and concludes at the distance). The theorem holds with no centroid concordance factor ([`Nanuq.theorem36`](../../Nanuq/Algorithm/Theorem36.lean#L53)),
which holds off a null set of parameters ([`Nanuq.theorem36_generic`](../../Nanuq/Algorithm/Theorem36.lean#L81)) and under the condition of Proposition 10
([`Nanuq.figure5_lt`](../../Nanuq/Algorithm/Consistency.lean#L1094), on the printed formula; [`Nanuq.ThreeTwo.theorem36_N₃`](../../Nanuq/ConcordanceFactors/ThreeTwoCycle.lean#L1128), on the network `N₃`).

**E2. The level of the T3 test.** "We choose `α_m` to be the minimum of the `α'_m`" (line 2207). A test rejects when the
p-value is below the level, so the level must be at least each `α'_m`: the maximum. At the minimum the test need not
reject ([`Nanuq.not_rejects_at_minimum`](../../Nanuq/Algorithm/Consistency.lean#L1049)). The theorem is not affected ([`Nanuq.exists_levels`](../../Nanuq/Algorithm/Consistency.lean#L660)).

**E3. The quantity `α'_m`.** `α'_m = P(W_m > md/2)` is not a number, since the law of `W_m` depends on an estimate from
the data. The proof here takes the bound `P(χ²₂ > md/2)` ([`Nanuq.tendsto_t3PValue_lt_level`](../../Nanuq/Algorithm/Consistency.lean#L642)).

**E4. A step left out.** The proof uses, without saying so, that the maximum likelihood topologies are the true ones with
probability tending to one ([`Nanuq.tendsto_maxCount_t3`](../../Nanuq/Algorithm/Consistency.lean#L518), [`Nanuq.tendsto_minCount`](../../Nanuq/Algorithm/Consistency.lean#L540)).

**E84. Definition 11 (a misprint).** "For appropriately chosen `1 ≤ p < q < n`" must allow `p = q`, since a circular split
can have a single taxon on one side. It affects no result, and the definition is not in the Lean.

E1 to E4 are numbered in this report; E84 is the number of the finding in the collection's audit of the papers that cite
NANUQ.

## 4. Missing hypotheses

Theorem 36 needs that no set of four taxa has the centroid as concordance factor (E1). The Challenge's
[`NanuqChallenge.theorem36`](../../palomar/Nanuq/Challenge.lean#L589) has it as [`Nanuq.Model.NoCentroidCF`](../../palomar/Nanuq/Challenge.lean#L474), and [`NanuqChallenge.theorem36_generic`](../../palomar/Nanuq/Challenge.lean#L609) excludes a null
set of parameters instead.

## 5. Redundant hypotheses

[`Nanuq.theorem36_of_proposition9`](../../Nanuq/Algorithm/Consistency.lean#L1361) does not use that the network is binary, which enters only through Proposition 9; the
Challenge keeps the hypothesis.

## 6. How the formalization reads the paper

- **The conclusion of Theorem 36.** The paper concludes that NANUQ infers "the binary unrooted phylogenetic network
  associated to `N⁺` by Theorem 34". Its proof shows that the distance of Step 3 agrees with the theoretical distance
  `d_{Q,N⁻}` with probability tending to one (line 2009), and the rest is Steps 4 and 5. The formal theorems conclude at
  the distance; [`Nanuq.theorem36_output`](../../Nanuq/Algorithm/Theorem36.lean#L69) gives any function of the distance, for the steps after it.
- **Proposition 9 on whole networks.** The paper states Proposition 9 on a quartet network `N⁺`, with conditions on
  `N⁻` and `N_c⁻`. [`Nanuq.proposition9`](../../Nanuq/ConcordanceFactors/Proposition9.lean#L1500) states it on a set of four taxa of a whole network, the concordance factor being
  the marginal of the gene tree on all the taxa, with conditions by blocks, cut edges and the grove. The two agree on a
  binary level-1 network ([`Nanuq.Quartet.hasThreeTwoCycle_iff`](../../Nanuq/Networks/QuartetNetwork.lean#L764), [`Nanuq.Quartet.hasCycleType_four_one_iff`](../../Nanuq/QuartetDistance/Class.lean#L472),
  [`Nanuq.Quartet.networkClass_eq_tree_iff`](../../Nanuq/QuartetDistance/Class.lean#L180), [`Nanuq.Quartet.networkClass_eq_cycle_iff`](../../Nanuq/QuartetDistance/Class.lean#L215)), and
  [`Nanuq.Quartet.proposition9_source`](../../Nanuq/QuartetDistance/Class.lean#L563) states the proposition in the paper's terms.
- **`N⁻`.** Definition 4 suppresses `LSA(X)`; the library keeps it, a vertex of degree two that Definition 5 suppresses.
  [`Nanuq/Networks/Semidirected.lean`](../../Nanuq/Networks/Semidirected.lean) reads Definition 5 on the semidirected network of Allman et al. 2023, which carries
  the suppression out, and proves that the two readings keep the same edges with the same degrees.
- **The star tree in `Q̃`.** The paper extends `ρ_xy` to star trees (lines 1964-1968); the network's class of a set of four
  taxa ([`Nanuq.networkClass`](../../Nanuq/Algorithm/Consistency.lean#L1221)) has a star case, which does not occur on a binary level-1 network.
- **Gene trees on subsets of the taxa.** The paper's input allows them, and states no model. Here gene trees are
  independent draws from the coalescent, each with a set of taxa fixed in advance, and each set of four taxa is on more
  and more of them ([`Tinnik.Covers`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/Consistency/MissingTaxa.lean#L97)).
- **Running time.** A count of operations, with NeighborNet and the Circular Network algorithm as costs, not a machine
  model.

## 7. Departures from the paper's proofs

| Result | The paper | Lean | Why |
| --- | --- | --- | --- |
| Proposition 9 | No proof: "from [1, 3]" | An argument of its own: lineages placed at vertices and moved up by the Markov property, with no formula in the branch lengths ([`Nanuq.proposition9`](../../Nanuq/ConcordanceFactors/Proposition9.lean#L1500), [`Nanuq/ConcordanceFactors/Placement.lean`](../../Nanuq/ConcordanceFactors/Placement.lean)); part 2 by the probability that two lineages take one parent at a reticulation ([`Nanuq.proposition9_part2`](../../Nanuq/ConcordanceFactors/Proposition9Part2.lean#L725)) | No printed argument to follow; the references were not read |
| Theorem 36 | Levels `α'_m = P(W_m > md/2)`, and their minimum | The bound `P(χ²₂ > md/2)`, and the maximum | E2, E3 |

The routes of the paper's proofs are not recorded yet: [`docs/Nanuq/paper_routes.tsv`](paper_routes.tsv) marks every result as not proved by
the paper, so that the route check compares none, and [`docs/Nanuq/route_differences.tsv`](route_differences.tsv) records no difference.

## 8. What each result depends on

From the audit, [`scripts/Audit.lean`](../../scripts/Audit.lean): every declaration of the library, and of the libraries it requires, depends only on
[`propext`](https://leanprover-community.github.io/mathlib4_docs/Init/Core.html#propext), [`Classical.choice`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Classical.choice) and [`Quot.sound`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Quot.sound).

| Result | Lean | Results from prior work used |
| --- | --- | --- |
| Proposition 9, parts 1 and 3 | [`Nanuq.proposition9`](../../Nanuq/ConcordanceFactors/Proposition9.lean#L1500) | [`External.HuberEtAl2025.theorem5_1_forward`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/HuberEtAl2025/Theorem51.lean#L25) |
| Proposition 9, part 2 | [`Nanuq.proposition9_part2`](../../Nanuq/ConcordanceFactors/Proposition9Part2.lean#L725) | [`External.Tinnik.displaysOne_nmsc`](../../Nanuq/External/Tinnik/Consistency.lean#L32) |
| Proposition 9, in the paper's terms | [`Nanuq.Quartet.proposition9_source`](../../Nanuq/QuartetDistance/Class.lean#L563) | the statements of [`Nanuq/External/Allman2023/`](../../Nanuq/External/Allman2023), [`External.Allman2023.inducedCutSplit_unique`](https://github.com/formal-phylogenetics/lean4-tinnik/blob/de514e1f14522531f16dcdfa12244fe72fe05944/Tinnik/External/Allman2023/Rule.lean#L69), [`External.Tinnik.displaysOne_nmsc`](../../Nanuq/External/Tinnik/Consistency.lean#L32), [`External.HuberEtAl2025.theorem5_1_forward`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/HuberEtAl2025/Theorem51.lean#L25) |
| Theorem 36, corrected | [`Nanuq.theorem36`](../../Nanuq/Algorithm/Theorem36.lean#L53) | [`External.Tinnik.displaysOne_nmsc`](../../Nanuq/External/Tinnik/Consistency.lean#L32), [`External.Tinnik.tendsto_chiSqTwoTail_mul`](../../Nanuq/External/Tinnik/Consistency.lean#L49), [`External.HuberEtAl2025.theorem5_1_forward`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/HuberEtAl2025/Theorem51.lean#L25) |
| Theorem 36 for generic parameters | [`Nanuq.theorem36_generic`](../../Nanuq/Algorithm/Theorem36.lean#L81) | the same, and [`External.Tinnik.isGenericNull_centroid`](../../Nanuq/External/Tinnik/Consistency.lean#L41) |
| Theorem 36, gene trees on subsets of the taxa | [`Nanuq.theorem36_missing`](../../Nanuq/Algorithm/MissingTaxa.lean#L196), [`Nanuq.theorem36_generic_missing`](../../Nanuq/Algorithm/MissingTaxa.lean#L211) | [`External.Tinnik.displaysOne_nmsc`](../../Nanuq/External/Tinnik/Consistency.lean#L32), [`External.Tinnik.tendsto_chiSqTwoTail_comp`](../../Nanuq/External/Tinnik/Consistency.lean#L56), [`External.HuberEtAl2025.theorem5_1_forward`](https://github.com/formal-phylogenetics/lean4-phylo-network/blob/4ed2bb0f7085acbf1326f43e2a5c582ba4566125/PhyloNetwork/External/HuberEtAl2025/Theorem51.lean#L25), and for generic parameters [`External.Tinnik.isGenericNull_centroid`](../../Nanuq/External/Tinnik/Consistency.lean#L41) |
| The running time | [`Nanuq.nanuqOperations_le`](../../Nanuq/Algorithm/Counts.lean#L35) | – |

## 9. Not formalized

- Steps 4 and 5 of the algorithm, NeighborNet and the Circular Network algorithm, and the reading of the output's splits
  graph: Theorem 34 and the part of Theorem 36 after the distance.
- Split systems and splits graphs: Theorems 15 and 23, Corollaries 16, 24, 31 and 35, Lemmas 19, 21, 25-28, 32 and 33,
  Proposition 30, Definitions 11 to 14, 18 and 29.
- Proposition 10 for all level-1 networks: it is checked on the printed formula ([`Nanuq.figure5_lt`](../../Nanuq/Algorithm/Consistency.lean#L1094)) and on one network
  ([`Nanuq.ThreeTwo.isT1Strict_N₃`](../../Nanuq/ConcordanceFactors/ThreeTwoCycle.lean#L1098)).
- The examples, the data analyses and the measured running times.

## 10. The paper in the literature

The paper builds on Baños 2019, on the identifiability of level-1 networks from gene tree quartets, and on the hypothesis
tests of Mitchell, Allman, Rhodes 2019. Allman et al. 2023 cite it among the level-1 methods, and TINNiK (2024) takes
over its hypothesis tests, its T3 option being NANUQ's second test. NANUQ⁺ (Allman, Baños, Rhodes, Wicke 2025) resolves
the multifurcations of a tree of blobs to level-1 structure, and ECToBlob's Remark 8.3 strengthens Theorem 36 with
explicit levels, which lean4-ectoblob proves from the results here. MSCquartets 3.3 implements NANUQ⁺ with TINNiK and
ECToBlob. These come from the collection's literature search of 2026-10-31, made for the papers on the tree of blobs; no
search was made for NANUQ alone. No other formalization of NANUQ was found, and no erratum.

## 11. What's next

- Steps 4 and 5: NeighborNet and the Circular Network algorithm, and the splits graph of a circular split system
  (Theorems 15, 23, 34), which would carry Theorem 36 from the distance to the network inferred.
- Proposition 10 for all level-1 networks, and Proposition 9 by the arguments of its references, Baños 2019 and
  Solís-Lemus, Ané 2016.
- Rates: Theorem 36 is asymptotic, with no rate; a bound per test would give one, away from the centroid.
