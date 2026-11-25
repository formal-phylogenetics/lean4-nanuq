# NANUQ: inferring species networks from gene trees, in Lean

[![CI](https://github.com/formal-phylogenetics/lean4-nanuq/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/formal-phylogenetics/lean4-nanuq/actions/workflows/lean_action_ci.yml)

A Lean 4 formalization, in progress, of Elizabeth S. Allman, Hector Baños and John A. Rhodes (2019), "NANUQ: a method for inferring species networks from gene trees under the coalescent model", [Algorithms Mol. Biol. 14 (2019), 24](https://doi.org/10.1186/s13015-019-0159-2), read in arXiv v1 and the published text. NANUQ infers a level-1 species network from the gene trees of a sample. On each set of four taxa, two hypothesis tests on the counts of the three quartet trees decide between a star tree, a resolved quartet tree and a 4-cycle; a quartet distance built from these answers, NeighborNet and the Circular Network algorithm then give a splits graph, from which the network is read. The main result, Theorem 36, says that under the network multispecies coalescent on a binary level-1 network there are levels for the tests for which the algorithm recovers the network with probability tending to one as the number of gene trees grows.

Formalized: Steps 2 and 3 of the algorithm, the tests and the distance; Theorem 36, down to the distance, which is what its proof shows; Proposition 9, which the paper takes from its references; and the definitions they need. Theorem 36 is false as printed (E1 of [the report](docs/Nanuq/REPORT.md#3-errors-and-gaps-in-the-paper)): it holds with no set of four taxa at the centroid concordance factor, and for generic parameters with the printed hypothesis. No result of the literature is assumed, and there is no `sorry` or `axiom` outside the Challenge's statements. Steps 4 and 5 and the paper's results on split systems and splits graphs are not formalized. No person has reviewed the proofs.

This paper belongs to the hub [lean4-phylo-network](https://github.com/formal-phylogenetics/lean4-phylo-network), on phylogenetic network estimation, in the collection rooted at [lean4-phylogenetics](https://github.com/formal-phylogenetics/lean4-phylogenetics). It builds on Baños 2019, whose repository [lean4-banos2019](https://github.com/formal-phylogenetics/lean4-banos2019) is in progress, and its formalization uses the language of Allman et al. 2023 and the tests of TINNiK, formalized in [lean4-allman2023](https://github.com/formal-phylogenetics/lean4-allman2023) and [lean4-tinnik](https://github.com/formal-phylogenetics/lean4-tinnik). NANUQ⁺ and ECToBlob build on it.

## Status

| Part of the paper | Status |
| --- | --- |
| Phylogenetic networks: Definitions 4 and 5, the types of cycle | stated as printed, with bridges to the library's reading on whole networks |
| The NMSC and quartet concordance factors: Proposition 9 | proved, all three parts, on binary level-1 networks, by an argument of its own (the paper prints no proof) |
| The `3₂`-cycles: Proposition 10 | checked on the printed formula and on one network, which shows the centroid concordance factor |
| Network split systems and splits graphs: Theorems 15, 23, 34, Corollaries 16, 24, 31, 35, Lemmas 19, 21, 25-28, 32, 33, Proposition 30 | not formalized |
| Quartet distance for level-1 networks: Theorem 17, Definitions 20 and 22 | proved; `Q̃` is a quartet tree or a 4-cycle |
| The algorithm: Steps 2 and 3, the running time | proved; the running time as a count of operations |
| The algorithm: Steps 4 and 5 | not formalized |
| Statistical consistency: Theorem 36 | proved down to the distance, with the correction E1; for generic parameters with the printed hypothesis; with gene trees on subsets of the taxa |
| Examples and data analyses | not formalized |

[Section 9 of the report](docs/Nanuq/REPORT.md#9-not-formalized) lists what is not formalized.

## Main results

The statements of record are the theorems of the Challenge, [`palomar/Nanuq/Challenge.lean`](palomar/Nanuq/Challenge.lean), in the namespace `NanuqChallenge`. The Challenge imports only Mathlib, and its definitions are those of [`Nanuq/Defs.lean`](Nanuq/Defs.lean), copied by [`scripts/sync_challenge_defs.py`](scripts/sync_challenge_defs.py): rooted phylogenetic, binary and level-1 networks, valid and generic parameters, the network multispecies coalescent with independent inheritance and its concordance factors, the star test and the T3 test, Steps 2 and 3 of NANUQ, and the network's classes of the sets of four taxa with its theoretical distance. [`palomar/Nanuq/Solution.lean`](palomar/Nanuq/Solution.lean) proves them, under the same names, from the library, through the bridges of [`Nanuq/Bridge/`](Nanuq/Bridge). They keep the paper's hypotheses.

| Paper | Lean | Statement |
| --- | --- | --- |
| Theorem 36, corrected | [`NanuqChallenge.theorem36`](palomar/Nanuq/Challenge.lean#L589) | on a binary level-1 network, at valid parameters at which the induced quartet networks with `3₂`-cycles are tree-like and no set of four taxa has the centroid concordance factor, there are levels `0 < α_m < 1`, `α_m → 0`, such that for any `0 < β < 1` and any selections of maximum likelihood topologies, Steps 2 and 3 on `m` independent gene trees give the network's class of every set of four taxa and the theoretical distance, with probability tending to one |
| Theorem 36 for generic parameters | [`NanuqChallenge.theorem36_generic`](palomar/Nanuq/Challenge.lean#L609) | the same with the hypothesis as printed, off a null set of parameters, for the distance |

### Also proved in the library

| Paper | Lean | Statement |
| --- | --- | --- |
| Theorem 36, the steps after the distance | [`Nanuq.theorem36_output`](Nanuq/Algorithm/Theorem36.lean#L69) | any function of the distance, such as Steps 4 and 5, that gives the wanted object on the theoretical distance gives it with probability tending to one |
| Theorem 36 with gene trees on subsets of the taxa | [`Nanuq.theorem36_missing`](Nanuq/Algorithm/MissingTaxa.lean#L196), [`Nanuq.theorem36_generic_missing`](Nanuq/Algorithm/MissingTaxa.lean#L211) | when each set of four taxa is on more and more gene trees |
| Theorem 36 as printed | [`Nanuq.ThreeTwo.not_theorem36AsPrinted_N₃`](Nanuq/ConcordanceFactors/ThreeTwoCycle.lean#L1089) | fails on a binary level-1 network with a `3₂`-cycle, at the centroid (E1) |
| Proposition 9 | [`Nanuq.proposition9`](Nanuq/ConcordanceFactors/Proposition9.lean#L1500), [`Nanuq.proposition9_part2`](Nanuq/ConcordanceFactors/Proposition9Part2.lean#L725), [`Nanuq.Quartet.proposition9_source`](Nanuq/QuartetDistance/Class.lean#L563) | the concordance factors of a set of four taxa of a binary level-1 network, at any `0 ≤ ρ ≤ 1`: parts 1 and 3, part 2 with the bound `CF_AB\|CD ≥ 1/6`, and the three parts in the paper's terms |
| Definitions 20 and 22 | [`Nanuq.Quartet.qTilde`](Nanuq/QuartetDistance/Contract.lean#L423), [`Nanuq.Quartet.sourceDistance`](Nanuq/QuartetDistance/Class.lean#L46), [`Nanuq.Quartet.networkDistance_eq_sourceDistance`](Nanuq/QuartetDistance/Class.lean#L459) | `Q̃` and the theoretical distance, as printed, and that they are the library's |
| Theorem 17 | [`Nanuq.nanuqDistance_treeClass`](Nanuq/Algorithm/Consistency.lean#L821) | on a tree, the distance is the tree metric of Rhodes 2020 |
| The running time | [`Nanuq.nanuqOperations_le`](Nanuq/Algorithm/Counts.lean#L35) | the algorithm takes `O(n⁴ m)` operations, with Steps 4 and 5 as costs bounded as the paper says |

### The sources

| Source | Lean | Statement |
| --- | --- | --- |
| Allman et al. 2023, on quartet trees, the LSA network and trees with nodes of degree 2 suppressed | [`Nanuq/External/Allman2023/`](Nanuq/External/Allman2023) | the facts that the reading of `N⁻` and `Q̃` uses; proved from lean4-allman2023 |
| TINNiK, steps of the proof of Theorem 4 | [`Nanuq/External/Tinnik/`](Nanuq/External/Tinnik) | gene trees display one quartet tree per set of four taxa, the centroid excluded for generic parameters, tails of `χ²₂`; proved from lean4-tinnik |
| Mitchell et al. 2019, the T3 test; Rhodes 2020, Theorem 2; Huber et al. 2025, Theorem 5.1 | lean4-phylo-network | proved there |

## What the audit found

| Finding | Where |
| --- | --- |
| Theorem 36 is false as printed: its hypothesis allows the centroid concordance factor, which a `3₂`-cycle reaches; it holds with no centroid, and for generic parameters | E1 |
| The proof of Theorem 36 takes the minimum of the levels `α'_m`, where the maximum is needed | E2 |
| The levels `α'_m` are not numbers, since their law depends on an estimate | E3 |
| The proof passes over the convergence of the maximum likelihood topologies | E4 |
| Definition 11 must allow `p = q` | E84 |

[Section 3 of the report](docs/Nanuq/REPORT.md#3-errors-and-gaps-in-the-paper) gives each finding with the paper's sentence and the repair. The proofs follow the paper's arguments, except the departures in [Section 7 of the report](docs/Nanuq/REPORT.md#7-departures-from-the-papers-proofs): Proposition 9 has no printed proof, and is proved by an argument of its own; Theorem 36 takes other levels (E2, E3).

## Trust

- `lake build` passes; the only warnings are the `sorry`s of the Challenge's statements. There is no `sorry`, `axiom`, `native_decide` or `implemented_by` in [`Nanuq/`](Nanuq) or in the Solution.
- [`scripts/Audit.lean`](scripts/Audit.lean) checks every declaration of this repository and of the libraries it requires, `Phylogenetics`, `PhyloNetwork`, `TreeOfBlobs`, `Allman2023` and `Tinnik`, including private and generated ones, against [`propext`](https://leanprover-community.github.io/mathlib4_docs/Init/Core.html#propext), [`Classical.choice`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Classical.choice) and [`Quot.sound`](https://leanprover-community.github.io/mathlib4_docs/Init/Prelude.html#Quot.sound), and writes the routes of the proofs.
- [`scripts/route_check.py`](scripts/route_check.py) compares those routes with the paper's, in [`docs/Nanuq/paper_routes.tsv`](docs/Nanuq/paper_routes.tsv). The citations of the paper's own proofs are not recorded there yet, so it compares none.
- Comparator checks that the Solution proves exactly the Challenge's statements, under Lean's kernel and NanoDa; [`scripts/check_kernels.sh`](scripts/check_kernels.sh) runs it, and con-ron on an export of the same theorems.
- No person has reviewed the proofs.

## Dependencies

- [Mathlib](https://github.com/leanprover-community/mathlib4), at `v4.37.0-rc1`.
- [lean4-phylogenetics](https://github.com/formal-phylogenetics/lean4-phylogenetics), the library of the collection, pinned by commit in [`lakefile.toml`](lakefile.toml): networks, trees and quartets, the network multispecies coalescent, generic parameters.
- [lean4-phylo-network](https://github.com/formal-phylogenetics/lean4-phylo-network), the library of this paper's hub, pinned by commit: the hypothesis tests and their limit laws, independent samples, blobs, blocks and wedge paths of level-1 networks, and the sources Mitchell et al. 2019, Rhodes 2020 and Huber et al. 2025.
- [lean4-allman2023](https://github.com/formal-phylogenetics/lean4-allman2023) and [lean4-tinnik](https://github.com/formal-phylogenetics/lean4-tinnik), pinned by commit, whose results the proofs use through the statements of [`Nanuq/External/`](Nanuq/External). They require [lean4-phylo-tree-of-blobs](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs), which this repository does not use directly.

## Palomar

No submission to Palomar is planned. [`palomar/Nanuq/`](palomar/Nanuq) has the files of an entry: the Challenge, which imports only Mathlib, the Solution, [`comparator.json`](palomar/Nanuq/comparator.json), which names them and the theorems, and [`formalization.yaml`](palomar/Nanuq/formalization.yaml), the entry's metadata. From the repository root, after `lake build`, run [`scripts/check_kernels.sh`](scripts/check_kernels.sh). CI checks that the Challenge's copy of the definitions is the block of [`Nanuq/Defs.lean`](Nanuq/Defs.lean) (`python3 scripts/sync_challenge_defs.py --check`).

## Building

From the root of the repository:

```sh
lake exe cache get
lake build
lake build Phylogenetics PhyloNetwork TreeOfBlobs Allman2023 Tinnik   # the libraries that the audit reads
lake env lean -Dlinter.deprecated.module=false scripts/Audit.lean     # axioms and dependencies
python3 scripts/route_check.py check docs/Nanuq/paper_routes.tsv --accept docs/Nanuq/route_differences.tsv
scripts/check_kernels.sh                                              # Comparator: Lean's kernel, NanoDa; con-ron
python3 scripts/linkify_docs.py                                       # the documents' links to the code
```

- Toolchain: Lean and Mathlib `v4.37.0-rc1` ([`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json)).
- `lake comparator`, `leanexport` and `con-ron` come from the toolchain, under `lake env`. The kernels' replays need much memory.

## Layout

| Folder | Content |
| --- | --- |
| [`Nanuq/`](Nanuq) | The Lean code; [its README](Nanuq/README.md) lists the modules by section of the paper, the paper's definitions and the corrections |
| [`Nanuq/Basic/`](Nanuq/Basic) | General mathematics, in Mathlib's namespaces; [its README](Nanuq/Basic/README.md) says where it could go |
| [`Nanuq/External/`](Nanuq/External) | The results of other works that the proofs use, in the namespaces `External.<Source>`: Allman et al. 2023 and TINNiK, proved from their repositories; [its README](Nanuq/External/README.md) lists them, with those proved in the libraries |
| [`Nanuq/Defs.lean`](Nanuq/Defs.lean), [`Nanuq/Bridge/`](Nanuq/Bridge) | The definitions of the Challenge, and the proof that they are the library's |
| [`Nanuq/Networks/`](Nanuq/Networks), [`Nanuq/ConcordanceFactors/`](Nanuq/ConcordanceFactors), [`Nanuq/QuartetDistance/`](Nanuq/QuartetDistance), [`Nanuq/Algorithm/`](Nanuq/Algorithm) | The paper's library, by its sections on networks, on quartet concordance factors, on the quartet distance and on the algorithm, in the namespace [`Nanuq`](Nanuq) |
| [`palomar/Nanuq/`](palomar/Nanuq) | The Challenge, the Solution, the Comparator configuration and the metadata |
| [`docs/Nanuq/`](docs/Nanuq) | [The report](docs/Nanuq/REPORT.md), [the credits](docs/Nanuq/CREDITS.md) and the routes of the proofs |
| [`scripts/`](scripts) | The audit, the route check, the copy of the definitions into the Challenge, the kernels, the links and the tables |

lean4-ectoblob uses some declarations under their names in the namespace `External.AllmanBanosRhodes2019`, which the modules that declare them give, as deprecated aliases of the theorems and exports of the definitions.

## Related work

From [Section 10 of the report](docs/Nanuq/REPORT.md#10-the-paper-in-the-literature).

- No other formalization of NANUQ was found.
- Before: Baños 2019 on the identifiability of level-1 networks from gene tree quartets, and the hypothesis tests of Mitchell, Allman, Rhodes 2019.
- Since: TINNiK takes over NANUQ's tests for the tree of blobs; NANUQ⁺ resolves the multifurcations of a tree of blobs to level-1 structure; ECToBlob's Remark 8.3 strengthens Theorem 36 with explicit levels, proved in lean4-ectoblob from the results here.

## What's next

Steps 4 and 5, NeighborNet and the Circular Network algorithm with the splits graphs of circular split systems, would carry Theorem 36 from the distance to the network inferred; Proposition 10 is checked only on one network. [Section 11 of the report](docs/Nanuq/REPORT.md#11-whats-next) has these.

## Credits

- Maintainer: The-Anh Vu-Le, who requested and supervised the formalization, chose the paper and decided the layout.
- Formalization: Claude (Opus 5.5) in Claude Code, with sub-agents, wrote the statements, proofs, audit and documents, following the [formalize-math-paper](https://github.com/vltanh/formalize-math-paper) procedure, in lean4-phylo-tree-of-blobs from 2026-10-31 to 2026-11-04 with the papers on the tree of blobs. [`docs/Nanuq/CREDITS.md`](docs/Nanuq/CREDITS.md) and lean4-phylo-tree-of-blobs's [`docs/CREDITS.md`](https://github.com/formal-phylogenetics/lean4-phylo-tree-of-blobs/blob/6e7bc494d26f3d7096a17adffbfde1cf559f0ae9/docs/CREDITS.md) have the details.
- Review: no person has reviewed the proofs; Lean's kernel checks them.

## License

Apache-2.0: [LICENSE](LICENSE).
