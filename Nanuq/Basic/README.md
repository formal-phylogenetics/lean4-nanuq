# General mathematics

Lemmas that say nothing about phylogenetics, filed by field as Mathlib files them and named as
Mathlib would name them, in Mathlib's namespaces, so that they can be contributed to Mathlib. They
import only Mathlib.

| File | Contents | Where it could go |
| --- | --- | --- |
| [`Data/List/Basic.lean`](Data/List/Basic.lean) | two or three distinct members of a list, given as values of a function, come in some order, and the list splits around them ([`List.exists_sort_two`](Data/List/Basic.lean#L19), [`List.exists_sort_three`](Data/List/Basic.lean#L38)); a pair in order is a sublist ([`List.pair_sublist`](Data/List/Basic.lean#L67)). The proof that `Q̃` on a set of four taxa with no cut-edge split is the 4-cycle orders the attachments of the four taxa around the cycle with them | `Mathlib/Data/List/Basic.lean`, `Mathlib/Data/List/Infix.lean` |

Some general facts stay where they are used, because they rest on the paper's objects: the
walks and directed paths of a network in [`Nanuq/QuartetDistance/Form.lean`](../QuartetDistance/Form.lean), and the limit
`log β / n → 0` of a constant level ([`Nanuq.tendsto_log_const_div`](../Algorithm/Consistency.lean#L489)), a special case of Mathlib's
`tendsto_const_div_atTop_nhds_zero_nat` that lean4-ectoblob uses under its name.

Before adding a lemma, search Mathlib and lean4-phylogenetics (`Phylogenetics/ForMathlib/`): a
lemma that a second repository of the collection needs moves up the tree, to the lowest node above
both (lean4-phylogenetics, docs/CONVENTIONS.md, Section 4).
