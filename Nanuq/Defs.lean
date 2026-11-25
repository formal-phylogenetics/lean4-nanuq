module

public import Mathlib.Analysis.Complex.Trigonometric
public import Mathlib.Analysis.Normed.Algebra.MatrixExponential
public import Mathlib.Analysis.SpecialFunctions.Log.Basic
public import Mathlib.Analysis.SpecialFunctions.Sqrt
public import Mathlib.Analysis.SpecialFunctions.Trigonometric.Arctan
public import Mathlib.Basic.Real.Sign
public import Mathlib.Data.Fintype.Powerset
public import Mathlib.Data.Set.Card
public import Mathlib.MeasureTheory.Constructions.Pi
public import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
public import Mathlib.MeasureTheory.Measure.Prod
public import Mathlib.Probability.Distributions.Gaussian.Real
public import Mathlib.Topology.Instances.Matrix

/-! # The definitions of the Challenge

The definitions that the Challenge states its theorems with, between the markers of
`scripts/sync_challenge_defs.py`, which copies them word for word into the Challenge,
`palomar/Nanuq/Challenge.lean` (formalize-math-paper, `references/palomar.md`, Section 2).

This module imports exactly what the Challenge imports: Lean, Mathlib, and nothing from this
repository or from any other repository of the collection. The definitions are those of the paper,
written in Mathlib's vocabulary. They follow the definitions of `Phylogenetics`, `PhyloNetwork`,
`Tinnik` and of this library that the library uses, so that `Nanuq.Bridge.Model` proves that the two
agree. -/

-- BEGIN SHARED DEFINITIONS

/-! ## Networks

A rooted network is a directed multigraph with named arcs (two arcs may join the same two vertices),
a root and a labelling of the taxa by vertices. Its numerical parameters are a length for every arc,
in coalescent units, and an inheritance probability for every arc. -/

@[expose] public noncomputable section

open Finset MeasureTheory ProbabilityTheory
open scoped Classical

namespace Nanuq.Model

/-- A directed multigraph: each arc `e` goes from `source e` to `target e`. -/
structure Digraph (V E : Type*) where
  source : E → V
  target : E → V

namespace Digraph

variable {V E : Type*} (G : Digraph V E)

/-- An arc leads from `u` to `v`. -/
def Adj (u v : V) : Prop := ∃ e, G.source e = u ∧ G.target e = v

/-- A directed path, possibly empty, leads from `u` to `v`. -/
def Reaches : V → V → Prop := Relation.ReflTransGen G.Adj

/-- No nonempty directed path from a vertex to itself. -/
def IsAcyclic : Prop := ∀ v, ¬ Relation.TransGen G.Adj v v

/-- The number of arcs entering `v`. -/
def indegree (v : V) : ℕ := {e | G.target e = v}.ncard

/-- The number of arcs leaving `v`. -/
def outdegree (v : V) : ℕ := {e | G.source e = v}.ncard

/-- The arc `e` crosses the bipartition `S | Sᶜ` of the vertices, in either direction. -/
def Crosses (e : E) (S : Set V) : Prop :=
  (G.source e ∈ S ∧ G.target e ∉ S) ∨ (G.target e ∈ S ∧ G.source e ∉ S)

/-- An arc of `F` joins `u` and `v`, in either direction. -/
def AdjOn (F : Set E) (u v : V) : Prop :=
  ∃ e ∈ F, (G.source e = u ∧ G.target e = v) ∨ (G.source e = v ∧ G.target e = u)

/-- `e` is a *cut edge*: its ends are not joined by an undirected walk avoiding it. -/
def IsCutArc (e : E) : Prop := ¬ Relation.ReflTransGen (G.AdjOn {e}ᶜ) (G.source e) (G.target e)

/-- `u` and `v` are in the same *blob*: an undirected walk through arcs that are not cut edges joins
them. -/
def SameBlob (u v : V) : Prop := Relation.ReflTransGen (G.AdjOn {e | ¬ G.IsCutArc e}) u v

end Digraph

/-- A rooted network on the taxa `X`: a directed multigraph, its root, and the vertex of each
taxon. -/
structure Network (V E X : Type*) where
  graph : Digraph V E
  root : V
  leaf : X → V

/-- The numerical parameters of a network: arc lengths, in coalescent units, and inheritance
probabilities. -/
structure Params (E : Type*) where
  length : E → ℝ
  inheritance : E → ℝ

namespace Network

variable {V E X : Type*} (N : Network V E X)

/-- A *rooted phylogenetic network* (Definition 1): a finite directed acyclic graph in which the root,
of in-degree zero, reaches every vertex; the vertices of out-degree zero are exactly the vertices of
the taxa, bijectively, each of in-degree one. -/
structure IsPhylogenetic : Prop where
  finite_vertices : Finite V
  finite_arcs : Finite E
  finite_taxa : Finite X
  acyclic : N.graph.IsAcyclic
  root_reaches : ∀ v, N.graph.Reaches N.root v
  root_indegree : N.graph.indegree N.root = 0
  nonroot_indegree : ∀ v, v ≠ N.root → 1 ≤ N.graph.indegree v
  leaf_injective : Function.Injective N.leaf
  leaf_indegree : ∀ x, N.graph.indegree (N.leaf x) = 1
  leaves : ∀ v, N.graph.outdegree v = 0 ↔ ∃ x, N.leaf x = v

/-- A *tree arc* enters a vertex with one entering arc. -/
def IsTreeArc (e : E) : Prop := N.graph.indegree (N.graph.target e) = 1

/-- A *hybrid arc* enters a vertex with at least two entering arcs. -/
def IsHybridArc (e : E) : Prop := 2 ≤ N.graph.indegree (N.graph.target e)

/-- The network is *binary*: the root has out-degree two, and every other vertex that is not a leaf
has in-degree and out-degree summing to three. -/
def IsBinary : Prop :=
  N.graph.outdegree N.root = 2 ∧
    ∀ v, v ≠ N.root → N.graph.outdegree v ≠ 0 →
      N.graph.indegree v + N.graph.outdegree v = 3

/-- *Valid numerical parameters*: tree arcs have positive length and inheritance probability one,
hybrid arcs non-negative length and positive inheritance probability, and the inheritance
probabilities of the arcs entering a vertex with several entering arcs sum to one. -/
def IsMetric [Fintype E] (m : Params E) : Prop :=
  (∀ e, N.IsTreeArc e → 0 < m.length e) ∧
  (∀ e, N.IsHybridArc e → 0 ≤ m.length e) ∧
  (∀ e, N.IsTreeArc e → m.inheritance e = 1) ∧
  (∀ e, N.IsHybridArc e → 0 < m.inheritance e) ∧
  ∀ v, 2 ≤ N.graph.indegree v →
    ∑ e, (if N.graph.target e = v then m.inheritance e else 0) = 1

/-- The network is *level-1* (Definition 2): in each blob, the number of hybrid arcs exceeds the number
of vertices with several entering arcs by at most one. -/
def IsLevelOne [Fintype V] [Fintype E] : Prop :=
  ∀ v : V,
    ((univ.filter fun e => N.IsHybridArc e ∧ N.graph.SameBlob v (N.graph.source e) ∧
        N.graph.SameBlob v (N.graph.target e)).card : ℤ) -
      ((univ.filter fun u => 2 ≤ N.graph.indegree u ∧ N.graph.SameBlob v u).card : ℤ) ≤ 1

/-- The vertices ancestral to a taxon of `Y`. -/
def ancestralVertices (Y : Set X) : Set V := {v | ∃ x ∈ Y, N.graph.Reaches v (N.leaf x)}

/-- The arcs ancestral to a taxon of `Y`: those of the network induced on `Y`. -/
def ancestralArcs (Y : Set X) : Set E := {e | N.graph.target e ∈ N.ancestralVertices Y}

/-- `A ∩ Y | Y \ A` is a cut-edge split of the network induced on `Y`: some arc of the induced
subgraph is the only arc of that subgraph crossing a vertex set meeting `Y` exactly in `A`. -/
def HasCutSplitOn (Y A : Set X) : Prop :=
  ∃ e ∈ N.ancestralArcs Y, ∃ S : Set V,
    (∀ f ∈ N.ancestralArcs Y, N.graph.Crosses f S ↔ f = e) ∧ ∀ x ∈ Y, N.leaf x ∈ S ↔ x ∈ A

/-- One step of an undirected walk outside the blob of `v`. -/
def BlockStep (v a b : V) : Prop :=
  ¬ N.graph.SameBlob v a ∧ ¬ N.graph.SameBlob v b ∧
    ∃ e, (N.graph.source e = a ∧ N.graph.target e = b) ∨ (N.graph.source e = b ∧ N.graph.target e = a)

/-- An undirected walk outside the blob of `v`, possibly empty: its ends are in one block at that
blob. -/
def BlockWalk (v : V) : V → V → Prop := Relation.ReflTransGen (N.BlockStep v)

/-! ### Deleting hybrid arcs -/

variable (D : Set E)

/-- `u` reaches `v` along arcs outside `D`. -/
def ReachesOff : V → V → Prop :=
  Relation.ReflTransGen fun a b => ∃ f, f ∉ D ∧ N.graph.source f = a ∧ N.graph.target f = b

/-- With the arcs `D` deleted, every directed path from the root to the taxon `x` uses the arc `e`. -/
def DominatesOff (e : E) (x : X) : Prop := ¬ N.ReachesOff (insert e D) N.root (N.leaf x)

/-- With the arcs `D` deleted, the taxon `x` is below the arc `e`. -/
def IsBelowOff (e : E) (x : X) : Prop := e ∉ D ∧ N.ReachesOff D (N.graph.target e) (N.leaf x)

/-- With the arcs `D` deleted, the arc `e` dominates all taxa of `P`, and no taxon of `Q` is below
it. -/
def SeparatesOff (e : E) (P Q : Set X) : Prop :=
  (∀ x ∈ P, N.DominatesOff D e x) ∧ ∀ x ∈ Q, ¬ N.IsBelowOff D e x

/-- `D` deletes only hybrid arcs, and leaves every vertex other than the root an entering arc. -/
def IsDeletion : Prop :=
  (∀ e ∈ D, N.IsHybridArc e) ∧ ∀ v, v ≠ N.root → ∃ f, f ∉ D ∧ N.graph.target f = v

end Network

/-! ## Trees and quartet trees

A rooted tree on a set is given by its clusters, and an unrooted tree on the taxa by the sides of its
splits. A resolved quartet tree `ab|cd` is the pair of its cherries. -/

section Trees

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- The unrooted tree of a rooted tree `G`, given by its clusters: the sides of the splits of its
non-root clusters. -/
def unroot {L : Type*} [Fintype L] [DecidableEq L] (G : Finset (Finset L)) : Finset (Finset L) :=
  G.erase univ ∪ (G.erase univ).image compl

/-- A resolved quartet tree `ab|cd`: the pair of its two disjoint cherries `{a, b}`, `{c, d}`. -/
def IsQuartetTree (s : Finset (Finset X)) : Prop :=
  s.card = 2 ∧ (∀ B ∈ s, B.card = 2) ∧ ∀ B ∈ s, ∀ C ∈ s, B ≠ C → Disjoint B C

/-- The resolved quartet trees on `X`. -/
abbrev QuartetTree (X : Type*) [DecidableEq X] := {s : Finset (Finset X) // IsQuartetTree s}

instance : Fintype (QuartetTree X) := Fintype.ofFinite _

omit [Fintype X] in
/-- The four taxa of a quartet tree. -/
def QuartetTree.taxa (s : QuartetTree X) : Finset X := s.val.sup id

/-- The two quartet trees on the taxa of `s` other than `s`. -/
def QuartetTree.alternatives (s : QuartetTree X) : Finset (QuartetTree X) :=
  univ.filter fun r => r.taxa = s.taxa ∧ r ≠ s

/-- The three quartet trees on the four taxa `q`. -/
def treesOn (q : Finset X) : Finset (QuartetTree X) := univ.filter fun r => r.taxa = q

/-- The tree `T`, given by the sides of its splits, *displays* the quartet tree `s`: some split
restricts to `s` on its four taxa. -/
def Displays (T : Finset (Finset X)) (s : QuartetTree X) : Prop := ∃ A ∈ T, A ∩ s.taxa ∈ s.val

/-- The taxa `a`, `e` are *separated* in the quartet tree `s`: they are in different cherries. -/
def Separated (s : QuartetTree X) (a e : X) : Prop :=
  a ∈ s.taxa ∧ e ∈ s.taxa ∧ ∀ B ∈ s.val, ¬ (a ∈ B ∧ e ∈ B)

end Trees

/-! ## The network multispecies coalescent

A forest of gene lineages on the leaves `L` is the set of its clusters, and its roots are its maximal
clusters. Along an arc of length `t` the lineages coalesce by Kingman's coalescent, each pair of
roots merging at rate `1`; above the root, for an infinite time. At a vertex with several entering
arcs, each lineage independently takes each arc with its inheritance probability. -/

section Coalescent

variable {L : Type*} [Fintype L] [DecidableEq L]

/-- The roots of a forest: its maximal clusters. -/
def roots (F : Finset (Finset L)) : Finset (Finset L) := F.filter fun A => ∀ B ∈ F, A ⊆ B → B = A

/-- The generator of Kingman's coalescent on forests: each pair of distinct roots `A, B` merges at
rate `1`, adding the cluster `A ∪ B`. -/
def kingmanGenerator : Matrix (Finset (Finset L)) (Finset (Finset L)) ℝ :=
  fun F G =>
    if G = F then -((#(roots F)).choose 2 : ℝ)
    else if ∃ A ∈ roots F, ∃ B ∈ roots F, A ≠ B ∧ G = insert (A ∪ B) F then 1 else 0

/-- Kingman's coalescent over a time `t`: `exp (t • Q)`. -/
def kingmanTransition (t : ℝ) : Matrix (Finset (Finset L)) (Finset (Finset L)) ℝ :=
  NormedSpace.exp (t • kingmanGenerator)

/-- Kingman's coalescent over an infinite time: the limits as `t → ∞`. -/
def kingmanAbsorption : Matrix (Finset (Finset L)) (Finset (Finset L)) ℝ :=
  fun F G => Filter.limUnder Filter.atTop fun t : ℝ => kingmanTransition t F G

/-- The part of the forest `F` below its roots in `A`. -/
def forestBelow (F A : Finset (Finset L)) : Finset (Finset L) := F.filter fun B => ∃ C ∈ A, B ⊆ C

end Coalescent

namespace Network

variable {V E X : Type*} [Fintype V] [Fintype E] [Fintype X] [DecidableEq X]
variable (N : Network V E X) (θ : Params E)

/-- The forest arriving at `v` from below: its taxon's lineage, if any, and the forests at the top of
the arcs leaving `v`. -/
def arrivingForest (top : E → Finset (Finset X)) (v : V) : Finset (Finset X) :=
  ((univ.filter fun x => N.leaf x = v).image fun x => ({x} : Finset X)) ∪
    (univ.filter fun e => N.graph.source e = v).biUnion top

/-- The probability that the roots of the forest `F` arriving at `v` choose the arcs entering `v`
that put the forests `bot e` at their bottoms: each root independently takes the arc `e` with the
inheritance probability of `e`. -/
def allocationFactor (F : Finset (Finset X)) (v : V) (bot : E → Finset (Finset X)) : ℝ :=
  ∑ a : {A // A ∈ roots F} → {e // N.graph.target e = v},
    if ∀ e : {e // N.graph.target e = v},
        bot e.val = forestBelow F ((univ.filter fun r => a r = e).image Subtype.val) then
      ∏ r, θ.inheritance (a r).val
    else 0

/-- The probability of a history: the forests `bot e` at the bottom and `top e` at the top of each
arc. -/
def historyWeight (bot top : E → Finset (Finset X)) : ℝ :=
  (∏ v ∈ univ.erase N.root, N.allocationFactor θ (N.arrivingForest top v) v bot) *
    ∏ e, kingmanTransition (θ.length e) (bot e) (top e)

/-- **The network multispecies coalescent**, with independent inheritance: the probability of the
rooted gene tree `G` (its clusters), with one lineage per taxon. -/
def geneTreeDist (G : Finset (Finset X)) : ℝ :=
  ∑ bot : E → Finset (Finset X), ∑ top : E → Finset (Finset X),
    N.historyWeight θ bot top * kingmanAbsorption (N.arrivingForest top N.root) G

/-- The *quartet concordance factor* of the quartet tree `s` (Definition 7): the probability that a
gene tree displays `s`. -/
def nmscCF (s : QuartetTree X) : ℝ :=
  ∑ G : Finset (Finset X), if Displays (unroot G) s then N.geneTreeDist θ G else 0

/-- A set of parameters is *null*: Lebesgue-null in the coordinates given by all arc lengths and, at
each vertex with several entering arcs, the inheritance probabilities of all of them but one, for
every choice of the arc left out. The coordinates of the other arcs are dummies. -/
def IsGenericNull (A : Set (Params E)) : Prop :=
  ∀ d : V → E, (∀ v, 2 ≤ N.graph.indegree v → N.graph.target (d v) = v) →
    ((Measure.pi fun _ : E => (volume : Measure ℝ)).prod (Measure.pi fun _ : E => (volume : Measure ℝ)))
      {x | ∃ θ ∈ A, N.IsMetric θ ∧ θ.length = x.1 ∧
        ∀ e, N.IsHybridArc e → e ≠ d (N.graph.target e) → θ.inheritance e = x.2 e} = 0

end Network

/-! ## Samples of gene trees -/

section Sampling

variable {Γ : Type*} [Fintype Γ]

/-- The probability that `n` independent draws from the distribution `dist` on the finite set `Γ` lie
in the event `Ev`. -/
def iidProb (dist : Γ → ℝ) (n : ℕ) (Ev : (Fin n → Γ) → Prop) : ℝ :=
  ∑ ω : Fin n → Γ, if Ev ω then ∏ i, dist (ω i) else 0

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- The number of the gene trees `ω`, each given by the sides of its splits through `sides`, that
display the quartet tree `s`. -/
def quartetCount {n : ℕ} (sides : Γ → Finset (Finset X)) (ω : Fin n → Γ) (s : QuartetTree X) : ℝ :=
  ((univ.filter fun i => Displays (sides (ω i)) s).card : ℝ)

end Sampling

/-! ## The hypothesis tests

The tests of Step 2 on the counts `c` of the three quartet trees on a set of four taxa: the star
test, and the test of model T3 of Mitchell, Allman, Rhodes (2019). -/

section Tests

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- The likelihood ratio statistic for the line `p_{s'} = p_{s''}` of the quartet tree `s`, where `s'`,
`s''` are the alternatives of `s`: twice the difference of the maximal trinomial log-likelihoods,
unconstrained and on the line. `x log x` vanishes at `x = 0`. -/
def lineStat (c : QuartetTree X → ℝ) (s : QuartetTree X) : ℝ :=
  2 * (∑ r ∈ s.alternatives, c r * Real.log (c r) -
    (∑ r ∈ s.alternatives, c r) * Real.log (∑ r ∈ s.alternatives, c r) +
    (∑ r ∈ s.alternatives, c r) * Real.log 2)

/-- The likelihood ratio statistic of the star test on the taxa `q`: twice the difference of the
maximal trinomial log-likelihoods, unconstrained and at `(1/3, 1/3, 1/3)`. -/
def starStat (c : QuartetTree X → ℝ) (q : Finset X) : ℝ :=
  2 * (∑ r ∈ treesOn q, c r * Real.log (c r) -
    (∑ r ∈ treesOn q, c r) * Real.log ((∑ r ∈ treesOn q, c r) / 3))

/-- The upper tail at `t` of the `χ²` distribution with 2 degrees of freedom. -/
def chiSqTwoTail (t : ℝ) : ℝ := Real.exp (-t / 2)

/-- The p-value of the star test on the taxa `q`, by the likelihood ratio, against the `χ²₂`
distribution. -/
def starPValue (c : QuartetTree X → ℝ) (q : Finset X) : ℝ := chiSqTwoTail (starStat c q)

/-- The concordance factor `p` is on the null of model T1 for the quartet tree `s`, a closed half-line:
`p_s ≥ p_{s'} = p_{s''}`. -/
def IsT1Null (p : QuartetTree X → ℝ) (s : QuartetTree X) : Prop :=
  (∀ r ∈ s.alternatives, p r ≤ p s) ∧ ∀ r ∈ s.alternatives, ∀ r' ∈ s.alternatives, p r = p r'

/-- The concordance factor `p` is on the null of model T3 on the taxa `q`, the union of the three T1
nulls: it is *tree-like* (Definition 8), the centroid included. -/
def IsT3Null (p : QuartetTree X → ℝ) (q : Finset X) : Prop := ∃ s ∈ treesOn q, IsT1Null p s

/-- The likelihood ratio statistic of model T1 for `s`: on the line of `s` when `c s` is at least the
mean of the alternatives, otherwise at the centroid. -/
def t1Stat (c : QuartetTree X → ℝ) (s : QuartetTree X) : ℝ :=
  if (∑ r ∈ s.alternatives, c r) / 2 ≤ c s then lineStat c s else starStat c s.taxa

/-- The likelihood ratio statistic of model T3 on the taxa `q`: the least of the three T1
statistics. -/
def t3Stat (c : QuartetTree X → ℝ) (q : Finset X) : ℝ := ⨅ s : {s // s ∈ treesOn q}, t1Stat c s.val

/-- The parameter `μ₀ = √(2n) (1 - φ) / √(φ (3 - 2φ))` of the test distribution, for the point
`(1 - 2φ/3, φ/3, φ/3)` and the sample size `n`. -/
def muZero (φ n : ℝ) : ℝ := Real.sqrt (2 * n) * (1 - φ) / Real.sqrt (φ * (3 - 2 * φ))

/-- The angle `α₀ = arctan (1 / √(3 (3 - 2φ)))` of the test distribution. -/
def alphaZero (φ : ℝ) : ℝ := Real.arctan (1 / Real.sqrt (3 * (3 - 2 * φ)))

/-- The maximum likelihood estimate of `φ` on the T1 null of `s`. -/
def t1Phi (c : QuartetTree X → ℝ) (s : QuartetTree X) : ℝ :=
  min 1 (3 * (∑ r ∈ s.alternatives, c r) / (2 * (c s + ∑ r ∈ s.alternatives, c r)))

/-- The variable of the limit law of the T3 statistic at `(Z, Z̄)`:
`min (Z² + ½ (1 - sgn Z̄) Z̄², sin² α₀ (Z + cot α₀ sgn(Z) Z̄)²)`. -/
def t3Var (φ : ℝ) (z : ℝ × ℝ) : ℝ :=
  min (z.1 ^ 2 + if z.2 < 0 then z.2 ^ 2 else 0)
    (Real.sin (alphaZero φ) ^ 2 * (z.1 + Real.cot (alphaZero φ) * Real.sign z.1 * z.2) ^ 2)

/-- The upper tail at `t` of the T3 test distribution: the law of `t3Var φ (Z, Z̄)` for independent
`Z ~ N(0, 1)` and `Z̄ ~ N(μ₀, 1)`, for the parameter `φ` and the sample size `n`. -/
def t3Tail (φ n t : ℝ) : ℝ :=
  ((gaussianReal 0 1).prod (gaussianReal (muZero φ n) 1)).real {z | t < t3Var φ z}

/-- The p-value of the T3 test on the taxa of `s`, the fitted topology, with `φ` estimated on its
half-line. -/
def t3PValue (c : QuartetTree X → ℝ) (s : QuartetTree X) : ℝ :=
  t3Tail (t1Phi c s) (c s + ∑ r ∈ s.alternatives, c r) (t3Stat c s.taxa)

/-- The concordance factors are off the centroid `(1/3, 1/3, 1/3)` on each set of four taxa. -/
def NoCentroidCF (p : QuartetTree X → ℝ) : Prop :=
  ∀ q : Finset X, q.card = 4 → ¬ ∀ r ∈ treesOn q, p r = 1 / 3

end Tests

/-! ## The algorithm: Steps 2 and 3 -/

section Algorithm

variable {X : Type*} [Fintype X] [DecidableEq X]

/-- What Step 2 says of a set of four taxa: a star tree, the resolved quartet tree `s`, or the 4-cycle
whose concordance factor has its least entry at `s`, so that the cherries of `s` are the pairs of
taxa opposite on the cycle. -/
inductive QuartetClass (X : Type*) [DecidableEq X] where
  | star : QuartetClass X
  | tree (s : QuartetTree X) : QuartetClass X
  | cycle (s : QuartetTree X) : QuartetClass X

/-- A selection of the maximum likelihood topology of a tree: on each set of four taxa, a quartet tree
of largest count. -/
def IsMaxCountSelection (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) : Prop :=
  ∀ c q, q.card = 4 → ml c q ∈ treesOn q ∧ ∀ r ∈ treesOn q, c r ≤ c (ml c q)

/-- A selection of the maximum likelihood topology of a 4-cycle: on each set of four taxa, a quartet
tree of least count. -/
def IsMinCountSelection (ml : (QuartetTree X → ℝ) → Finset X → QuartetTree X) : Prop :=
  ∀ c q, q.card = 4 → ml c q ∈ treesOn q ∧ ∀ r ∈ treesOn q, c (ml c q) ≤ c r

/-- **Step 2**, on the counts `c` of the quartet trees: the star test at level `β`, and the T3 test at
level `α`, at the topology of largest count; a 4-cycle is reported at the topology of least count. -/
def classify (mlT mlC : (QuartetTree X → ℝ) → Finset X → QuartetTree X) (α β : ℝ)
    (c : QuartetTree X → ℝ) (q : Finset X) : QuartetClass X :=
  if β ≤ starPValue c q then .star
  else if α ≤ t3PValue c (mlT c q) then .tree (mlT c q)
  else .cycle (mlC c q)

/-- `ρ_xy` of Definition 20, extended to a star tree: `0` on a quartet tree `xy|zw`, `1/2` on a
4-cycle with `x, y` adjacent, and `1` otherwise. -/
def rho (C : QuartetClass X) (x y : X) : ℝ :=
  match C with
  | .star => 1
  | .tree s => if Separated s x y then 1 else 0
  | .cycle s => if Separated s x y then 1 / 2 else 1

/-- **Step 3, the network quartet distance** of Definition 22: for `x ≠ y`, `2 ∑ ρ_xy(Q_xyzw) + 2n - 4`,
the sum over the sets of four taxa containing `x` and `y`. -/
def nanuqDistance (cl : Finset X → QuartetClass X) (x y : X) : ℝ :=
  if x = y then 0 else
    2 * ∑ q ∈ univ.filter (fun q : Finset X => q.card = 4 ∧ x ∈ q ∧ y ∈ q), rho (cl q) x y +
      2 * (Fintype.card X : ℝ) - 4

end Algorithm

/-! ## The network's classes of sets of four taxa -/

namespace Network

variable {V E X : Type*} [Fintype X] [DecidableEq X] (N : Network V E X)

/-- The quartet tree `s` is a cut-edge split of the network induced on its four taxa. -/
def InducedCutSplit (s : QuartetTree X) : Prop :=
  ∃ B ∈ s.val, N.HasCutSplitOn (s.taxa : Set X) (B : Set X)

/-- The quartet tree `s` is displayed by a tree of the network's grove: with one entering arc kept at
every vertex, the arcs kept form a spanning tree of the network, and an arc of it induces the split
of `s`. -/
def GroveDisplays (s : QuartetTree X) : Prop :=
  ∃ D : Set E, N.IsDeletion D ∧ (∀ f g, f ∉ D → g ∉ D → N.graph.target f = N.graph.target g → f = g) ∧
    ∃ e, ∃ P ∈ s.val, N.SeparatesOff D e (P : Set X) ((s.taxa \ P : Finset X) : Set X)

/-- The network induced on the taxa `q` has a `3₂`-cycle: a vertex with several entering arcs has
exactly two taxa of `q` below it, and the other two are in different blocks at its blob. -/
def HasThreeTwoCycle (q : Finset X) : Prop :=
  ∃ h : V, 2 ≤ N.graph.indegree h ∧ (q.filter fun x => N.graph.Reaches h (N.leaf x)).card = 2 ∧
    ∀ x ∈ q, ∀ y ∈ q, x ≠ y → ¬ N.graph.Reaches h (N.leaf x) → ¬ N.graph.Reaches h (N.leaf y) →
      ¬ N.BlockWalk h (N.leaf x) (N.leaf y)

/-- The hypothesis of Theorem 36: "all induced quartet networks with `3₂`-cycles are tree-like". -/
def ThreeTwoTreelike (p : QuartetTree X → ℝ) : Prop :=
  ∀ q : Finset X, q.card = 4 → N.HasThreeTwoCycle q → IsT3Null p q

/-- **The class of a set of four taxa on the network**, `Q̃` of Definition 20: the quartet tree of a
cut-edge split of the induced network; otherwise the 4-cycle, given by a quartet tree that the grove
does not display with an alternative that it does; otherwise the star tree. -/
def networkClass (q : Finset X) : QuartetClass X :=
  if h : ∃ s ∈ treesOn q, N.InducedCutSplit s then .tree h.choose
  else if h' : ∃ s ∈ treesOn q, ¬ N.GroveDisplays s ∧ ∃ r ∈ s.alternatives, N.GroveDisplays r then
    .cycle h'.choose
  else .star

/-- The theoretical quartet distance `d_{Q,N⁻}` of Definition 22. -/
def networkDistance : X → X → ℝ := nanuqDistance N.networkClass

end Network

end Nanuq.Model

end

-- END SHARED DEFINITIONS
