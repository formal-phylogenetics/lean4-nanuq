module

public meta import Lean.Elab.Command
public meta import Lean.DocString
-- One `import all` line per module of the libraries, so that proofs are visible to the dependency
-- traversal (the module system hides them from a plain `import`): every module of `Nanuq/`
-- (`Basic/`, `External/` and the paper's library), the paper's Solution in `palomar/`, and every
-- module of the libraries `Phylogenetics`, `PhyloNetwork`, `TreeOfBlobs`, `Allman2023` and `Tinnik`
-- that this repository requires, directly or through the others, but no Challenge, which holds a copy
-- of the paper's definitions. Generate the lines with
--   { find Nanuq -name '*.lean'; cd palomar && find . -name Solution.lean; } |
--     sed 's#^\./##; s/\.lean$//; s#/#.#g; s/^/import all /' | sort
-- and the same `find` in `.lake/packages/Phylogenetics`, `.lake/packages/PhyloNetwork`,
-- `.lake/packages/TreeOfBlobs`, `.lake/packages/Allman2023` and `.lake/packages/Tinnik`.
import all Nanuq.Algorithm.Consistency
import all Nanuq.Algorithm.Counts
import all Nanuq.Algorithm.MissingTaxa
import all Nanuq.Algorithm.Theorem36
import all Nanuq.Basic.Data.List.Basic
import all Nanuq.Bridge.Model
import all Nanuq.Bridge.Statements
import all Nanuq.ConcordanceFactors.Placement
import all Nanuq.ConcordanceFactors.Proposition9
import all Nanuq.ConcordanceFactors.Proposition9Part2
import all Nanuq.ConcordanceFactors.ThreeTwoCycle
import all Nanuq.Defs
import all Nanuq.External.Allman2023.Quartets
import all Nanuq.External.Allman2023.TreeSuppression
import all Nanuq.External.Tinnik.Consistency
import all Nanuq.Networks.QuartetNetwork
import all Nanuq.Networks.Semidirected
import all Nanuq.QuartetDistance.Class
import all Nanuq.QuartetDistance.Contract
import all Nanuq.QuartetDistance.Cycle
import all Nanuq.QuartetDistance.Form
import all Nanuq.Solution
import all Phylogenetics.Coalescent.Absorption
import all Phylogenetics.Coalescent.BinaryForest
import all Phylogenetics.Coalescent.Defs
import all Phylogenetics.Coalescent.Factorization
import all Phylogenetics.Coalescent.Forest
import all Phylogenetics.Coalescent.Lump
import all Phylogenetics.Coalescent.Outcome
import all Phylogenetics.Coalescent.PMF
import all Phylogenetics.Coalescent.Relabel
import all Phylogenetics.Coalescent.Tavare
import all Phylogenetics.Coalescent.Trace
import all Phylogenetics.Computation.Caterpillar5
import all Phylogenetics.Computation.Codes
import all Phylogenetics.Computation.Engine
import all Phylogenetics.Computation.FiveTaxa
import all Phylogenetics.Computation.FourTaxa
import all Phylogenetics.Computation.ThreeTaxa
import all Phylogenetics.Computation.Toolkit
import all Phylogenetics.ForMathlib.Analysis.AnalyticZeroSet
import all Phylogenetics.ForMathlib.Analysis.MatrixExponential
import all Phylogenetics.ForMathlib.MeasureTheory.HaarPreimage
import all Phylogenetics.Graph.Basic
import all Phylogenetics.Graph.Blobs
import all Phylogenetics.Graph.BridgeCutLaminar
import all Phylogenetics.Graph.Connectivity
import all Phylogenetics.Graph.CutUniqueness
import all Phylogenetics.Graph.Defs
import all Phylogenetics.Graph.Degree
import all Phylogenetics.Graph.Tree
import all Phylogenetics.Hierarchy.Basic
import all Phylogenetics.Hierarchy.Counts
import all Phylogenetics.Hierarchy.Defs
import all Phylogenetics.Hierarchy.Quartets
import all Phylogenetics.Hierarchy.RootLocation
import all Phylogenetics.Hierarchy.SpeciesTree
import all Phylogenetics.MSC.Basic
import all Phylogenetics.MSC.Classify
import all Phylogenetics.MSC.Contract
import all Phylogenetics.MSC.Defs
import all Phylogenetics.MSC.History
import all Phylogenetics.MSC.Marginal
import all Phylogenetics.MSC.MultiSample
import all Phylogenetics.MSC.Relabel
import all Phylogenetics.MSC.Shapes
import all Phylogenetics.MSC.Small
import all Phylogenetics.NMSC.Analytic
import all Phylogenetics.NMSC.Basic
import all Phylogenetics.NMSC.ChoiceMetric
import all Phylogenetics.NMSC.Defs
import all Phylogenetics.NMSC.DisplayedTreeModel
import all Phylogenetics.NMSC.Exchangeability
import all Phylogenetics.NMSC.Factor
import all Phylogenetics.NMSC.Generic
import all Phylogenetics.NMSC.Glue
import all Phylogenetics.NMSC.History
import all Phylogenetics.NMSC.Induced
import all Phylogenetics.NMSC.InducedAbove
import all Phylogenetics.NMSC.InducedParams
import all Phylogenetics.NMSC.InducedRestrict
import all Phylogenetics.NMSC.InducedSuppress
import all Phylogenetics.NMSC.Inheritance
import all Phylogenetics.NMSC.Level1.Arms
import all Phylogenetics.NMSC.Level1.Basic
import all Phylogenetics.NMSC.Level1.Consistency
import all Phylogenetics.NMSC.Level1.Context
import all Phylogenetics.NMSC.Level1.Cycle
import all Phylogenetics.NMSC.Level1.Defs
import all Phylogenetics.NMSC.Level1.Displays
import all Phylogenetics.NMSC.Level1.GeneTrees
import all Phylogenetics.NMSC.Level1.General
import all Phylogenetics.NMSC.Level1.MetricCycle.Basic
import all Phylogenetics.NMSC.Level1.MetricCycle.Instance
import all Phylogenetics.NMSC.Level1.MetricCycle.RationalLengths
import all Phylogenetics.NMSC.Level1.MetricCycle.Realization
import all Phylogenetics.NMSC.Level1.MetricCycle.Reflection
import all Phylogenetics.NMSC.Level1.Process
import all Phylogenetics.NMSC.Level1.Sampling
import all Phylogenetics.NMSC.Level1.Symmetry
import all Phylogenetics.NMSC.Marginal
import all Phylogenetics.NMSC.SpeciesTree
import all Phylogenetics.NMSC.Symmetry
import all Phylogenetics.NMSC.TreeCF
import all Phylogenetics.NMSC.Witness
import all Phylogenetics.Network.AncestralRestriction
import all Phylogenetics.Network.Basic
import all Phylogenetics.Network.CutHierarchy
import all Phylogenetics.Network.Cuts
import all Phylogenetics.Network.Defs
import all Phylogenetics.Network.DeletedArcs
import all Phylogenetics.Network.Induced
import all Phylogenetics.Network.InducedMetric
import all Phylogenetics.Network.Level1.CyclicOrder
import all Phylogenetics.Network.Level1.Defs
import all Phylogenetics.Network.Level1.Digraph.Basic
import all Phylogenetics.Network.Level1.Digraph.Complete
import all Phylogenetics.Network.Level1.Digraph.CompleteCycle
import all Phylogenetics.Network.Level1.Digraph.CompleteDesc
import all Phylogenetics.Network.Level1.Digraph.CompleteEmbed
import all Phylogenetics.Network.Level1.Digraph.Correspondence
import all Phylogenetics.Network.Level1.Digraph.CycleHybrid
import all Phylogenetics.Network.Level1.Digraph.Defs
import all Phylogenetics.Network.Level1.Digraph.Invariance
import all Phylogenetics.Network.Level1.Digraph.Invariant
import all Phylogenetics.Network.Level1.Digraph.InvariantCycle
import all Phylogenetics.Network.Level1.Digraph.InvariantSide
import all Phylogenetics.Network.Level1.Digraph.InvariantTree
import all Phylogenetics.Network.Level1.Digraph.OfNet
import all Phylogenetics.Network.Level1.Digraph.Sound
import all Phylogenetics.Network.Level1.LevelOne
import all Phylogenetics.Network.Level1.ToRootedNetwork
import all Phylogenetics.Network.OfHierarchy
import all Phylogenetics.Network.PendantCuts
import all Phylogenetics.Network.Quartets
import all Phylogenetics.Network.Semidirected
import all Phylogenetics.Network.TreeOfBlobs
import all Phylogenetics.Tree.AstralDP
import all Phylogenetics.Tree.Defs
import all Phylogenetics.Tree.Detach
import all Phylogenetics.Tree.FourPoint
import all Phylogenetics.Tree.GeneTree.AnchorNode
import all Phylogenetics.Tree.GeneTree.Annotate
import all Phylogenetics.Tree.GeneTree.Basic
import all Phylogenetics.Tree.Metric
import all Phylogenetics.Tree.NeighborJoining
import all Phylogenetics.Tree.Splice
import all Phylogenetics.Tree.Splits
import all Phylogenetics.Tree.SplitsEquivalence
import all Phylogenetics.Tree.XTree
import all PhyloNetwork.External.HuberEtAl2025.Theorem51
import all PhyloNetwork.External.MitchellAllmanRhodes2019.CutModel
import all PhyloNetwork.External.MitchellAllmanRhodes2019.T1Limit
import all PhyloNetwork.External.MitchellAllmanRhodes2019.T3Density
import all PhyloNetwork.External.MitchellAllmanRhodes2019.T3Limit
import all PhyloNetwork.External.MitchellAllmanRhodes2019.T3Test
import all PhyloNetwork.External.Rhodes2020.Theorem2
import all PhyloNetwork.ForMathlib.Analysis.SpecialFunctions.EntropyExcess
import all PhyloNetwork.ForMathlib.Analysis.SpecialFunctions.Erf
import all PhyloNetwork.ForMathlib.Probability.GaussianPlane
import all PhyloNetwork.ForMathlib.Probability.GaussianStrip
import all PhyloNetwork.ForMathlib.Probability.GaussianTail
import all PhyloNetwork.ForMathlib.Probability.Transfer
import all PhyloNetwork.InducedSplits
import all PhyloNetwork.Level1Blobs
import all PhyloNetwork.Level1Blocks
import all PhyloNetwork.Level1CF
import all PhyloNetwork.NMSCChain
import all PhyloNetwork.Testing.Combining
import all PhyloNetwork.Testing.Defs
import all PhyloNetwork.Testing.IID
import all PhyloNetwork.Testing.Limits
import all PhyloNetwork.Testing.MissingTaxa
import all PhyloNetwork.Testing.Tails
import all PhyloNetwork.Testing.Trinomial.Bridge
import all PhyloNetwork.Testing.Trinomial.CLT
import all PhyloNetwork.Testing.Trinomial.Gaussian
import all PhyloNetwork.Testing.Trinomial.Statistics
import all PhyloNetwork.Testing.Trinomial.Tests
import all PhyloNetwork.Testing.Trinomial.Whiten
import all PhyloNetwork.Wedge
import all TreeOfBlobs.BridgeDFS
import all TreeOfBlobs.Defs
import all TreeOfBlobs.External.HuberEtAl2025.Theorem51
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.CutModel
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.T1Limit
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.T3Density
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.T3Limit
import all TreeOfBlobs.External.MitchellAllmanRhodes2019.T3Test
import all TreeOfBlobs.External.Rhodes2020.Theorem2
import all TreeOfBlobs.FinNetwork
import all TreeOfBlobs.ForMathlib.Analysis.AnalyticZeroSet
import all TreeOfBlobs.ForMathlib.Analysis.FiniteOptimization
import all TreeOfBlobs.ForMathlib.Analysis.SpecialFunctions.EntropyExcess
import all TreeOfBlobs.ForMathlib.Analysis.SpecialFunctions.Erf
import all TreeOfBlobs.ForMathlib.Analysis.SpecialFunctions.GibbsInequality
import all TreeOfBlobs.ForMathlib.Probability.GaussianPlane
import all TreeOfBlobs.ForMathlib.Probability.GaussianStrip
import all TreeOfBlobs.ForMathlib.Probability.GaussianTail
import all TreeOfBlobs.ForMathlib.Probability.Transfer
import all TreeOfBlobs.General
import all TreeOfBlobs.InducedSplits
import all TreeOfBlobs.LCA
import all TreeOfBlobs.Level1Blobs
import all TreeOfBlobs.Level1Blocks
import all TreeOfBlobs.Level1CF
import all TreeOfBlobs.LocalObjective
import all TreeOfBlobs.NMSCChain
import all TreeOfBlobs.RhoOne
import all TreeOfBlobs.Testing.Combining
import all TreeOfBlobs.Testing.Defs
import all TreeOfBlobs.Testing.IID
import all TreeOfBlobs.Testing.Limits
import all TreeOfBlobs.Testing.MissingTaxa
import all TreeOfBlobs.Testing.Tails
import all TreeOfBlobs.Testing.Trinomial.Bridge
import all TreeOfBlobs.Testing.Trinomial.CLT
import all TreeOfBlobs.Testing.Trinomial.Gaussian
import all TreeOfBlobs.Testing.Trinomial.Statistics
import all TreeOfBlobs.Testing.Trinomial.Tests
import all TreeOfBlobs.Testing.Trinomial.Whiten
import all TreeOfBlobs.TreeCounts
import all TreeOfBlobs.UnitMetric
import all TreeOfBlobs.Wedge
import all Allman2023.Basic.Algebra.BigOperators.Intervals
import all Allman2023.Basic.Algebra.BigOperators.Pi
import all Allman2023.Basic.Analysis.Convex.Segment
import all Allman2023.Basic.Analysis.SpecialFunctions.Exp
import all Allman2023.Basic.Data.Finset.Card
import all Allman2023.Basic.Data.Finset.Iterate
import all Allman2023.Basic.Data.Set.Subtype
import all Allman2023.Bridge.Model
import all Allman2023.Bridge.Statements
import all Allman2023.Defs
import all Allman2023.External.SempleSteel2005.Quartets
import all Allman2023.Figures.Check
import all Allman2023.Figures.Examples
import all Allman2023.Figures.Figure1
import all Allman2023.Figures.Figure2
import all Allman2023.FourTaxa.CFDetectable
import all Allman2023.FourTaxa.CFGeometry
import all Allman2023.FourTaxa.ClaimsTheorem1
import all Allman2023.FourTaxa.ContractBlob
import all Allman2023.FourTaxa.Corollary1
import all Allman2023.FourTaxa.DeletedNetwork
import all Allman2023.FourTaxa.FourCycle
import all Allman2023.FourTaxa.GenericCF
import all Allman2023.FourTaxa.GenericDense
import all Allman2023.FourTaxa.GenericParams
import all Allman2023.FourTaxa.KernelBounds
import all Allman2023.FourTaxa.Lemma1
import all Allman2023.FourTaxa.NetworkNk
import all Allman2023.FourTaxa.NetworkNkCF
import all Allman2023.FourTaxa.NetworkNkExact
import all Allman2023.FourTaxa.NetworkNkGraph
import all Allman2023.FourTaxa.NetworkNkMixture
import all Allman2023.FourTaxa.NetworkNkSpecies
import all Allman2023.FourTaxa.NetworkOne
import all Allman2023.FourTaxa.Proposition1
import all Allman2023.FourTaxa.Theorem1
import all Allman2023.FourTaxa.Theorem1a
import all Allman2023.FourTaxa.Theorem1b
import all Allman2023.FourTaxa.TwoBlobs
import all Allman2023.LargeNetworks.Claims
import all Allman2023.LargeNetworks.Corollary2
import all Allman2023.LargeNetworks.CutOrder
import all Allman2023.LargeNetworks.CycleLemma
import all Allman2023.LargeNetworks.Lemma2
import all Allman2023.LargeNetworks.Lemma2Counterexample
import all Allman2023.LargeNetworks.Lemma3
import all Allman2023.LargeNetworks.Reduction
import all Allman2023.LargeNetworks.Rule
import all Allman2023.LargeNetworks.SubgraphBlobs
import all Allman2023.LargeNetworks.Theorem2
import all Allman2023.LargeNetworks.Theorem3
import all Allman2023.MainResult.Algorithm
import all Allman2023.MainResult.BlobDistance
import all Allman2023.MainResult.Theorem4
import all Allman2023.MainResult.TrivialEdges
import all Allman2023.Networks.BlobDefinitions
import all Allman2023.Networks.BlobStructure
import all Allman2023.Networks.BlobsPass
import all Allman2023.Networks.Bridges
import all Allman2023.Networks.Concordance
import all Allman2023.Networks.CycleFamily
import all Allman2023.Networks.Definitions
import all Allman2023.Networks.InPassing
import all Allman2023.Networks.InducedCF
import all Allman2023.Networks.InducedNetwork
import all Allman2023.Networks.InducedTransfer
import all Allman2023.Networks.LSABlob
import all Allman2023.Networks.SuppressStem
import all Allman2023.Networks.TrdFour
import all Allman2023.Networks.TrdTree
import all Allman2023.Networks.TreeBlobs
import all Allman2023.Networks.TreeIso
import all Allman2023.Networks.TreeSuppression
import all Tinnik.Algorithms.Counts
import all Tinnik.Algorithms.LexIndex
import all Tinnik.AppendixC.Definitions
import all Tinnik.AppendixC.LikelihoodRatio
import all Tinnik.AppendixC.OpenCutModel
import all Tinnik.AppendixC.Proposition6
import all Tinnik.Basic.Algebra.Order.Field.Basic
import all Tinnik.Basic.Analysis.SpecialFunctions.Trigonometric.Basic
import all Tinnik.Basic.Data.Finset.Powerset
import all Tinnik.Basic.Data.List.Basic
import all Tinnik.Basic.Data.Nat.Choose.Basic
import all Tinnik.Bridge.Model
import all Tinnik.Bridge.Statements
import all Tinnik.Consistency.AllmanOutline
import all Tinnik.Consistency.MissingTaxa
import all Tinnik.Consistency.NJ
import all Tinnik.Consistency.T3
import all Tinnik.Consistency.Theorem4
import all Tinnik.Defs
import all Tinnik.External.Allman2023.Algorithm
import all Tinnik.External.Allman2023.CFDetectable
import all Tinnik.External.Allman2023.Rule
import all Tinnik.External.StudierKeppler1988.Lemma

/-!
# Axiom and dependency audit

Run with `lake env lean -Dlinter.deprecated.module=false scripts/Audit.lean` after `lake build` and
`lake build Phylogenetics PhyloNetwork TreeOfBlobs Allman2023 Tinnik`.

For every numbered result of the paper, this prints the axioms it depends on and the results from
prior work that it uses (`External/`, and the cited results that the libraries prove). It then
checks every declaration of the library, those of the libraries `Phylogenetics`, `PhyloNetwork`,
`TreeOfBlobs`, `Allman2023` and `Tinnik` included, and the theorems that Palomar's comparator checks.
The run fails if any of them depends on an axiom other than Lean's standard `propext`,
`Classical.choice` and `Quot.sound` (a `sorry` shows up as the axiom `sorryAx`). Its table of
results is the source of the report's dependency table.

It also writes the *route* of every numbered result to `.lake/route_deps.tsv`: the other
numbered results that its proof uses, found by following the proof through the library's helper
lemmas and stopping at numbered results, together with the TeX label that the result's docstring
names in backticks. `route_check.py` compares these routes with the results that the paper's proofs
cite.

The library's modules are imported with `import all`, which makes the proofs of their theorems
available: the module system does not export them otherwise. The traversal tests membership in a
precomputed set of the library's constants; looking up each constant's module instead
(`Environment.getModuleIdxFor?`) makes the interpreted script take minutes.

Keep one `import all` line per module of the libraries, each on its own line: a module that is
missing is still imported through the others, but without its proofs, and the audit then misses the
axioms and the routes inside them. The CI template checks the list.
-/

open Lean Elab Command

namespace Audit

/-- The results from prior work, with a short label: the theorems stated in `External/`, proved from
lean4-allman2023 and lean4-tinnik, and those that the libraries this repository requires prove. The
traversal stops at them. -/
meta def externalResults : List (String × Name) :=
  [("Allman et al. 2023, the taxa of ac|bd", `External.Allman2023.card_acbd),
   ("Allman et al. 2023, the taxa of ad|bc", `External.Allman2023.card_adbc),
   ("Allman et al. 2023, ab|cd is not ac|bd", `External.Allman2023.quartetTree_ne_acbd),
   ("Allman et al. 2023, ab|cd is not ad|bc", `External.Allman2023.quartetTree_ne_adbc),
   ("Allman et al. 2023, the edges of the LSA network", `External.Allman2023.mem_belowArcs_univ_iff),
   ("Allman et al. 2023, a tree has one more node than edges", `External.Allman2023.card_arcs_add_one),
   ("Allman et al. 2023, the sum of the degrees", `External.Allman2023.sum_nodeDegree),
   ("Allman et al. 2023, an edge crosses its sides", `External.Allman2023.isSideOf_crosses),
   ("Allman et al. 2023, chains through nodes of degree 2 are symmetric", `External.Allman2023.chainLink_symm),
   ("Allman et al. 2023, suppressing nodes of degree 2 keeps a tree", `External.Allman2023.isTree_suppressDegreeTwo),
   ("Allman et al. 2023, suppressing nodes of degree 2 keeps the degrees", `External.Allman2023.ncard_neighborSet_suppressDegreeTwo),
   ("Allman et al. 2023, suppressing nodes of degree 2 keeps the sides", `External.Allman2023.hasSide_iff),
   ("Allman et al. 2023, the literal topologies on four taxa", `External.Allman2023.hasStar_or_hasQuartet),
   ("Allman et al. 2023, the sides of a literal quartet tree", `External.Allman2023.pair_mem_splits_of_hasQuartetTopology),
   ("Allman et al. 2023, the sides of a literal star tree", `External.Allman2023.card_of_mem_splits_of_hasStarTopology),
   ("Allman et al. 2023, one induced cut-edge split per set of four taxa (lean4-tinnik)", `External.Allman2023.inducedCutSplit_unique),
   ("TINNiK, gene trees display one quartet tree per set of four taxa", `External.Tinnik.displaysOne_nmsc),
   ("TINNiK, the centroid is excluded for generic parameters", `External.Tinnik.isGenericNull_centroid),
   ("TINNiK, P(χ²₂ > m d) → 0", `External.Tinnik.tendsto_chiSqTwoTail_mul),
   ("TINNiK, P(χ²₂ > k_m d) → 0", `External.Tinnik.tendsto_chiSqTwoTail_comp),
   ("Huber et al. 2025, Theorem 5.1, forward", `External.HuberEtAl2025.theorem5_1_forward),
   ("Mitchell et al. 2019, Theorem 3.1, for the cut model", `External.MitchellAllmanRhodes2019.cutModel_theorem31),
   ("Mitchell et al. 2019, Proposition 4.1, for the trinomial", `External.MitchellAllmanRhodes2019.proposition4_1),
   ("Mitchell et al. 2019, Proposition 4.2", `External.MitchellAllmanRhodes2019.proposition4_2),
   ("Mitchell et al. 2019, Proposition 5.1, for the trinomial", `External.MitchellAllmanRhodes2019.proposition5_1),
   ("Mitchell et al. 2019, Proposition 5.2", `External.MitchellAllmanRhodes2019.proposition5_2),
   ("Rhodes 2020, Theorem 2", `External.Rhodes2020.theorem2),
   ("Rhodes 2020, internal edge weights", `External.Rhodes2020.quartetWeight_ge_two)]

/-- The numbered results of NANUQ, its definitions that the routes name, and what it says in
passing, in the order of the paper. -/
meta def paperResults : List (String × Name) :=
  [("Definition 4", `Nanuq.Quartet.IsMinusArc),
   ("Definition 5, the arcs of the treks (trekArcs)", `Nanuq.Quartet.trekArcs),
   ("Definition 5, on N⁻ of Allman et al. 2023 (sTrekEdges)", `Nanuq.Quartet.sTrekEdges),
   ("Proposition 9, parts 1 and 3", `Nanuq.proposition9),
   ("Proposition 9, part 2", `Nanuq.proposition9_part2),
   ("Proposition 9, in the source's terms", `Nanuq.Quartet.proposition9_source),
   ("Definition 20 (qTilde)", `Nanuq.Quartet.qTilde),
   ("Definition 20 (rhoTilde)", `Nanuq.Quartet.rhoTilde),
   ("Definition 22", `Nanuq.Quartet.sourceDistance),
   ("Thus the total time for NANUQ is O(n⁴ m)", `Nanuq.nanuqOperations_le),
   ("Theorem 36, corrected", `Nanuq.theorem36),
   ("Theorem 36, the steps after the distance", `Nanuq.theorem36_output),
   ("Theorem 36 for generic parameters", `Nanuq.theorem36_generic),
   ("Theorem 36 with gene trees on subsets of the taxa, given Proposition 9", `Nanuq.theorem36_missing_of_proposition9),
   ("Theorem 36 with gene trees on subsets of the taxa", `Nanuq.theorem36_missing),
   ("Theorem 36 for generic parameters, with gene trees on subsets of the taxa", `Nanuq.theorem36_generic_missing)]

/-- The theorems that Palomar's comparator checks (`theorem_names` of
`palomar/Nanuq/comparator.json`), as the Solution restates them. -/
meta def solutionResults : List Name :=
  [`NanuqChallenge.theorem36, `NanuqChallenge.theorem36_generic]

/-- Lean's standard axioms. -/
meta def standardAxioms : List Name := [``propext, ``Classical.choice, ``Quot.sound]

/-- Whether `m` is a module of the libraries: under the root `Nanuq` (`Basic/`, `External/`, the
paper's library and the Solution), but not the Challenge, or of the libraries `Phylogenetics`,
`PhyloNetwork`, `TreeOfBlobs`, `Allman2023` and `Tinnik`, which the audit reads too (but not their
Challenges). -/
meta def isLibraryModule (m : Name) : Bool :=
  ((`Nanuq).isPrefixOf m && m != `Nanuq.Challenge) ||
    ((`Allman2023).isPrefixOf m && m != `Allman2023.Challenge) ||
    ((`Tinnik).isPrefixOf m && m != `Tinnik.Challenge) ||
    (`Phylogenetics).isPrefixOf m || (`PhyloNetwork).isPrefixOf m || (`TreeOfBlobs).isPrefixOf m

/-- The constants declared in the library. -/
meta def libraryConstants (env : Environment) : NameSet := Id.run do
  let mut s : NameSet := {}
  for m in env.header.moduleNames, d in env.header.moduleData do
    if isLibraryModule m then
      for c in d.constNames do
        s := s.insert c
  return s

/-- The constants used by the type and the value of `c`. -/
meta def usedConstants (env : Environment) (c : Name) : Array Name :=
  match env.find? c with
  | some (.thmInfo t) => t.type.getUsedConstants ++ t.value.getUsedConstants
  | some (.defnInfo d) => d.type.getUsedConstants ++ d.value.getUsedConstants
  | some (.opaqueInfo o) => o.type.getUsedConstants ++ o.value.getUsedConstants
  | some (.inductInfo i) => i.type.getUsedConstants ++ i.ctors.toArray
  | some ci => ci.type.getUsedConstants
  | none => #[]

/-- The external results reached from `root` through constants of the library, without looking
inside the proofs of the external results themselves. `deps` caches the constants of the library
that each constant uses, across calls. -/
meta def externalUses (env : Environment) (library : NameSet) (deps : NameMap (Array Name))
    (root : Name) :
    List Name × NameMap (Array Name) := Id.run do
  let externals := externalResults.map (·.2)
  let mut deps := deps
  let mut visited : NameSet := {}
  let mut stack : List Name := [root]
  let mut found : NameSet := {}
  while true do
    match stack with
    | [] => break
    | c :: rest =>
      stack := rest
      if visited.contains c then continue
      visited := visited.insert c
      if c != root && externals.contains c then
        found := found.insert c
        continue
      let ds := match deps.find? c with
        | some ds => ds
        | none => (usedConstants env c).filter library.contains
      deps := deps.insert c ds
      for d in ds do
        if !visited.contains d then stack := d :: stack
  return (externalResults.filterMap fun (_, n) => if found.contains n then some n else none, deps)

/-- Where `#audit` writes the routes, relative to the project root (`.lake/` is not committed). -/
meta def routeFile : System.FilePath := ".lake/route_deps.tsv"

/-- The numbered results that the proof of `root` uses: those reached from it through constants
of the library, without looking inside the proofs of numbered results themselves. -/
meta def resultUses (env : Environment) (library results : NameSet) (root : Name) :
    Array Name := Id.run do
  let mut visited : NameSet := {}
  let mut stack : List Name := (usedConstants env root).toList
  let mut found : Array Name := #[]
  while true do
    match stack with
    | [] => break
    | c :: rest =>
      stack := rest
      if visited.contains c || c == root then continue
      visited := visited.insert c
      if results.contains c then
        found := found.push c
        continue
      if !library.contains c then continue
      for d in usedConstants env c do
        if !visited.contains d then stack := d :: stack
  return found

/-- The code spans of the docstring of `c` that contain no space or comma: the candidates for its
TeX label. -/
meta def docLabels (env : Environment) (c : Name) : IO (Array String) := do
  let some doc ← findDocString? env c | return #[]
  let mut out : Array String := #[]
  let mut inside := false
  for part in doc.splitOn "`" do
    if inside && !part.isEmpty && !part.any (fun ch => ch.isWhitespace || ch == ',') then
      out := out.push part
    inside := !inside
  return out

elab "#audit" : command => do
  let env ← getEnv
  let mut bad : Array Name := #[]
  let library := libraryConstants env
  let mut deps : NameMap (Array Name) := {}
  let mut rows : Array String := #["| Result | Lean | Results from prior work used | Axioms |",
    "| --- | --- | --- | --- |"]
  for (label, n) in paperResults do
    let axs ← liftCoreM <| collectAxioms n
    if axs.any (!standardAxioms.contains ·) then bad := bad.push n
    let (uses, deps') := externalUses env library deps n
    deps := deps'
    let usesStr := if uses.isEmpty then "–" else ", ".intercalate (uses.map fun u => s!"`{u}`")
    let axStr := ", ".intercalate (axs.toList.map toString)
    rows := rows.push s!"| {label} | `{n}` | {usesStr} | {axStr} |"
  for n in solutionResults ++ externalResults.map (·.2) do
    let axs ← liftCoreM <| collectAxioms n
    if axs.any (!standardAxioms.contains ·) then bad := bad.push n
  -- Every declaration of the library, including private and auxiliary ones.
  for c in library do
    let axs ← liftCoreM <| collectAxioms c
    if axs.any (!standardAxioms.contains ·) then bad := bad.push c
  -- The routes: for each numbered result, its docstring's labels and the results it uses.
  let results : NameSet := paperResults.foldl (fun s p => s.insert p.2) {}
  let mut routes : Array String := #[]
  for (label, n) in paperResults do
    let labels ← docLabels env n
    let uses := resultUses env library results n
    routes := routes.push (s!"{label}\t{n}\t{",".intercalate labels.toList}\t" ++
      ",".intercalate (uses.map toString).toList)
  IO.FS.createDirAll ".lake"
  IO.FS.writeFile routeFile ("\n".intercalate routes.toList ++ "\n")
  logInfo ("\n".intercalate rows.toList ++
    s!"\n\nChecked {library.size} declarations of the library: " ++
    (if bad.isEmpty then "all use only the standard axioms." else "see the error."))
  unless bad.isEmpty do
    throwError m!"non-standard axioms used by: {bad}"

end Audit

#audit
