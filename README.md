# NANUQ: inferring species networks from gene trees, in Lean

[![CI](https://github.com/vltanh/lean4-nanuq/actions/workflows/lean_action_ci.yml/badge.svg)](https://github.com/vltanh/lean4-nanuq/actions/workflows/lean_action_ci.yml)

A Lean 4 formalization, in progress, of E. S. Allman, H. Baños, J. A. Rhodes, *NANUQ: a method for inferring
species networks from gene trees under the coalescent model*, [Algorithms Mol. Biol. 14 (2019),
24](https://doi.org/10.1186/s13015-019-0159-2).

It is a paper of the hub [lean4-phylo-network](https://github.com/vltanh/lean4-phylo-network), on phylogenetic
network estimation, in the collection rooted at [lean4-phylogenetics](https://github.com/vltanh/lean4-phylogenetics).

## What is proved

NANUQ was first formalized as a source that the papers on the tree of blobs cite, in
[lean4-tob](https://github.com/vltanh/lean4-tob), and that formalization starts this repository. It is
unconditional except for the hypotheses that [`Nanuq/README.md`](Nanuq/README.md) lists:

- Steps 2 and 3 of the algorithm: the star test and the T3 test, and the network quartet distance of Definition 22;
- Theorem 36, the consistency of the method, down to the distance, with a correction (the hypothesis
  `TINNiK.NoCentroidCF`), and with gene trees on subsets of the taxa;
- Proposition 9, all three parts, on binary level-1 networks, which the paper takes from its references;
- the paper's definitions of the types of cycles and of `Q̃`, and the running time `O(n⁴ m)`.

[`Nanuq/README.md`](Nanuq/README.md) has the details, the corrections and the declarations. The rest of the paper is
still to formalize, with the formalize-math-paper procedure; this repository is where that happens.

No statement or proof changed in the move: every declaration keeps its name and its type, compared with lean4-tob at
commit `6e7bc49`. The declarations are still in the namespace `External.AllmanBanosRhodes2019`, as they were when
NANUQ was a cited source; [ECToBlob](https://github.com/vltanh/lean4-ectoblob) uses them under these names.

## What it requires

The formalization is written in the language of Allman et al. 2023 and uses TINNiK's T3 test, so it requires their
repositories, [lean4-allman2023](https://github.com/vltanh/lean4-allman2023) and
[lean4-tinnik](https://github.com/vltanh/lean4-tinnik), with the hubs [lean4-tob](https://github.com/vltanh/lean4-tob)
(the facts on blobs of level-1 networks, Theorem 5.1 of Huber et al. 2025, Rhodes 2020) and
[lean4-phylo-network](https://github.com/vltanh/lean4-phylo-network), and the root library
[lean4-phylogenetics](https://github.com/vltanh/lean4-phylogenetics), all by commit
([`lakefile.toml`](lakefile.toml)).

## Building

```sh
lake exe cache get
lake build
lake build Phylogenetics PhyloNetwork TreeOfBlobs AllmanEtAl2023 TINNiK           # the libraries that the audit reads
python3 scripts/gen_audit.py                                                       # after adding a module
lake env lean -DautoImplicit=false -DmaxSynthPendingDepth=3 scripts/Audit.lean     # axioms and routes
python3 scripts/route_check.py check docs/paper_routes.tsv --accept docs/route_differences.tsv
```

Lean and Mathlib `v4.36.0-rc1` ([`lean-toolchain`](lean-toolchain), [`lake-manifest.json`](lake-manifest.json)).

## Credits

- **Maintainer:** The-Anh Vu-Le. **No person has reviewed the proofs.**
- **Formalization:** Claude (Opus 5.5) in Claude Code, following the
  [formalize-math-paper](https://github.com/vltanh/formalize-math-paper) procedure, in lean4-tob from 2026-10-31 to
  2026-11-04 ([its credits](https://github.com/vltanh/lean4-tob/blob/6e7bc494d26f3d7096a17adffbfde1cf559f0ae9/docs/CREDITS.md));
  moved here on 2026-11-21.

License: Apache-2.0 ([LICENSE](LICENSE)).
