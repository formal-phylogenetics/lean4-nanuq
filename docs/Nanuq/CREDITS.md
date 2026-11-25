# Credits

NANUQ (Allman, Baños, Rhodes 2019), in Lean.

- **Maintainer:** The-Anh Vu-Le, who chose the paper and decided the layout. **No person has reviewed the proofs.**
- **Formalization:** Claude (Opus 5.5) in Claude Code, with sub-agents, following the
  [formalize-math-paper](https://github.com/vltanh/formalize-math-paper) procedure. NANUQ was formalized in
  [lean4-tob](https://github.com/vltanh/lean4-tob) from 2026-10-31 to 2026-11-04, as a source that ECToBlob's
  Remark 8.3 cites, with the papers on the tree of blobs. The rounds, the agents and models, and the time and effort of
  each are in lean4-tob's
  [`docs/CREDITS.md`](https://github.com/vltanh/lean4-tob/blob/6e7bc494d26f3d7096a17adffbfde1cf559f0ae9/docs/CREDITS.md),
  at the last commit before the split; they are not separated by paper.
- **Moved to this repository** on 2026-11-21, by Claude (Opus 5.5) in Claude Code, when lean4-tob became the hub of
  its papers, with every declaration's name and type kept, checked against lean4-tob at commit `6e7bc49`.
- **Arranged in the layout of the collection** on 2026-11-25, by Claude (Opus 5.5) in Claude Code: the library by the
  paper's sections in the namespace [`Nanuq`](../../Nanuq), general mathematics in [`Nanuq/Basic/`](../../Nanuq/Basic), the results of Allman et al. 2023
  and TINNiK in [`Nanuq/External/`](../../Nanuq/External), proved from their repositories, and a Challenge that states Theorem 36 on definitions
  in Mathlib's vocabulary, with the bridges to the library's. The statements of the library keep their meaning; the
  declarations are renamed from the namespace `External.AllmanBanosRhodes2019` to [`Nanuq`](../../Nanuq). The time of this round was
  not measured.
