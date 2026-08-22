# Response to Reviewers

**Manuscript ID** AISE-2026-0024
**Title** Biomedical Knowledge Graphs and Large Language Models: A Critical Engineering Survey

We thank both reviewers for the care taken with a long manuscript. Every point
led to a change. Added and reworded text is shown in blue in the marked copy
(`main-revised-marked.pdf`, `supplementary-revised-marked.pdf`); the clean
files are `main.pdf` and `supplementary.pdf`.

Two changes are worth flagging before the point-by-point replies, because they
affect how the rest reads. First, we ran the literature searches again and
report measured counts rather than describing the process qualitatively.
Second, we cut duplicated material from Sections VII and X--XIII, which paid
for the additions the reviewers requested; the main paper grows from 33 to 35
pages and the supplement from 6 to 7.

---

## Reviewer 1

### 1.1 Search and screening procedure

> *The literature selection process remains relatively qualitative. A brief structured search and screening procedure, including the databases, search terms, time range, and numbers of initially identified and finally included studies, would improve the transparency and reproducibility of the review.*

We have added a search and screening section to the supplement, with Table S1,
and a short pointer in Section II-C of the main paper.

Rather than reconstruct a protocol after the fact, we re-ran the searches and
report what they returned. Five conjunctive queries were issued against arXiv,
PubMed, OpenAlex, and DBLP on 22 August 2026, each requiring a knowledge-graph
term and a language-model term to co-occur in a biomedical context. This
returned 1879 records; deduplication on DOI, then arXiv identifier, then
normalised title left 1147 distinct works, of which 105 are cited. The full
query strings and per-interface yields are in the supplement.

We have been explicit about the limits of this. Screening was performed by the
authors without independent duplicate assessment, and titles and abstracts were
read in one pass, so we report the sampling frame and the criteria rather than a
stage-by-stage exclusion count that we cannot substantiate. We also state that
we make no claim of conformance to PRISMA, since exhaustive capture is not the
goal of a critical engineering survey; the reason was already argued in
Section II-C and is now made explicit.

The supplement additionally records a verification step that was performed but
not previously described: every retained reference was checked against a
canonical record through the Crossref, arXiv, OpenAlex, DBLP, Semantic Scholar,
bioRxiv, and PubMed interfaces together with the ACL Anthology and PMLR, and
the publication status of every preprint was re-checked. This is what allows
the distinction requested in comment 1.3 to be made reliably.

### 1.2 Boundaries between levels, and the status of the frameworks

> *The criteria or boundaries between the different levels should be clarified further, and it should be made explicit that these frameworks are primarily intended as an engineering taxonomy.*

Both parts are now addressed at the head of Section IV. We state that the axes
are engineering constructs proposed to organise evidence and enable comparison,
that they carry no psychometric claim, and that a system's position describes
its architecture and its evidence rather than scoring it.

For coupling depth we have added four yes/no questions that separate the levels
and can be answered from a system description without judgment: whether
structured graph content reaches the model at inference, whether more than one
graph call is made conditioned on earlier returns, whether graph-derived vectors
or adapters are fused with language representations, whether weights were
changed using graph-derived supervision, and whether the graph gates output or
receives it. We also state the convention for straddling cases, which
previously had to be inferred from the ranges in Table II: the deeper level is
recorded only when that mechanism carries the reported result.

The evaluation layers already name concrete measures per layer, and the
evidence-maturity gates are specified in the supplement with checkable
requirements. We have kept those where they are to hold the main paper's length,
and the cross-references are now explicit.

### 1.3 Peer-reviewed versus preprint evidence

> *Peer-reviewed evidence should be more clearly distinguished from preprint or early-stage evidence in the synthesis, and the strength of broader trend-level conclusions derived from such studies should be appropriately moderated.*

We agree that the policy stated in Section II-C was not carried through the
synthesis, and have made three changes.

Table VIII, which assembles the survey's central empirical claim, now carries an
evidence-status column. Checking each row against the publication record was
informative: eleven of the twelve conditions rest on peer-reviewed work, and one
rests on a preprint, which is now labelled and its magnitudes marked as
indicative from a single study. Section X already argued that evidence tables
should separate peer-review status into its own column, so the table now follows
the paper's own recommendation.

In the introduction, the four results characterising the 2026 frontier are now
separated by status. Three of them are peer-reviewed, and we say so; the fourth,
ChronoMedKG, is identified as a preprint whose direction is consistent with the
peer-reviewed results but whose magnitudes we treat as indicative.

We have also weakened one verb: KG-LLM-Bench, a workshop preprint, is now
described as having *reported* rather than *established* that textualisation is
an experimental factor, with the contrast against peer-reviewed MHGraphBench
made explicit.

### 1.4 Repetition across Sections VII and X--XIII

> *Some overlapping discussion across Sections VII and X--XIII could be condensed, with cross-references to earlier sections or tables used where appropriate.*

The reviewer is right, and one instance was substantial: the treatment of
circular self-validation in Section XII duplicated Section VII closely, down to
an identical closing sentence about least-privilege tool access. Section XII now
carries a single cross-reference and retains only the hazard-table row, which
adds the verification evidence that neither prose passage supplied.

We also condensed the matched-baseline restatement in Section XI to a
cross-reference to Tables VIII and VII, and replaced the agenda's
re-enumeration of the comparator ladder and the topology-shuffle ablation with a
pointer to Table VII, keeping only the new content in that priority.

On graph coverage we have made no cut. Reviewing each instance, the discussions
in Sections VIII, IX, and X serve distinct purposes: task-specific coverage as a
measurable quantity, a design-time check before committing to a graph, and
coverage as a gating variable in the evidence table. We think the repetition the
reviewer noticed there is of the phrase rather than the argument, and cutting
any instance would remove something the surrounding section needs. We are happy
to reconsider if the reviewer disagrees.

---

## Reviewer 2

### 2.1 Practical implications of the taxonomy

> *The authors are encouraged to discuss when different coupling depths or lifecycle stages are most appropriate for different biomedical applications, making the framework more actionable for practitioners.*

Section IX already contained a design path, but it was organised by retrieval
mechanism and never named a coupling level, so the taxonomy did not visibly pay
off. We have connected the two.

Section IV now states which coupling depths suit which situation and why:
shallow coupling where a clinician must audit each claim or where knowledge
changes faster than a training cycle, deeper coupling where throughput dominates
and attribution is not required at the point of use, and constrained coupling
with a deterministic verifier where the output must satisfy a writable rule.
Table IX, the application table, now carries a coupling-depth column, so the
crosswalk from application area to recommended depth is explicit. The design
path in Section IX is annotated with the corresponding C-levels.

### 2.2 Comparison table of representative systems

> *A concise comparison table summarizing representative KG–LLM systems, including the knowledge graph type, LLM backbone, coupling strategy, target application, advantages, and limitations.*

Added as Table VI in Section IX, covering twelve representative systems with the
six requested columns.

Building it produced a finding we have reported rather than concealed: **none of
the twelve systems reports the language model and version behind its headline
result** in a form a reader could reproduce. The only named models in the whole
set are the GPT-4 baselines that the trial-matching study measured against. The
backbone column therefore reads *n.r.* throughout, and we discuss why that
matters: the same graph in front of a stronger model is a different experiment,
and the shrinking-gain effect makes the difference decisive. This is the same
reporting failure the paper demands of deployed systems in Section XII, so we
treat it as a property of the literature rather than an inconvenience.

A second pattern is visible once systems are placed side by side: coupling
clusters at C1 and C2, eleven of twelve keep the graph outside the weights, and
the single system reaching C5 is also the only one with prospective
clinician-facing evaluation.

### 2.3 Latest foundation models and recent GraphRAG developments

> *The discussion of the latest biomedical foundation models and recent GraphRAG developments could be further strengthened.*

Both gaps were real and are now addressed.

Section V has a new paragraph on general-purpose GraphRAG engineering, covering
LightRAG's dual-level index with incremental insertion and HippoRAG's
schema-less graph with personalised PageRank retrieval. We note that both target
the cost and staleness problems that matter most in biomedicine, that neither
has been evaluated on a curated biomedical graph, and why the transfer is not
automatic: LightRAG's incremental index assumes edges are additive rather than
retracted, which a terminology release violates, and HippoRAG's extracted graph
carries none of the qualifier or provenance structure that Section IX identifies
as the source of biomedical value.

Section III now discusses domain-pretrained generative models, Med-PaLM,
MEDITRON-70B, and BioMistral, and their relation to the survey's argument. Our
scope statement excluded encoder-only biomedical models, but that exclusion did
not cover generative ones, so the omission was an oversight. The point we draw
is that a stronger biomedical backbone raises the closed-book baseline any
graph-augmented system must beat, which makes matched comparison more demanding
rather than less necessary.

### 2.4 Forward-looking discussion

> *The conclusion could be expanded by providing a more forward-looking discussion on future research directions, such as continual knowledge updating, multimodal biomedical AI, trustworthy deployment, and standardized evaluation protocols.*

Two of the four topics were already agenda priorities: continual knowledge
updating as update metrics for graph-maintaining agents, and standardised
evaluation protocols across the matched-comparison and claim-level-evaluation
priorities and the closing proposal for shared evidence infrastructure.

Two were genuinely missing and have been added. Multimodal biomedical AI now
appears as a priority: the gap we identify is not multimodal graph construction,
which is routine, but modality-level attribution, since no reviewed system can
state which modality carried a conclusion, and a fused embedding hides exactly
the attribution a clinician needs. Trustworthy deployment is now a priority in
its own right rather than being folded into security, covering privacy, human
oversight, regulatory change control, and post-deployment monitoring, and naming
the gap between controls that are specifiable and controls that are
demonstrated.

### 2.5 Transitions and readability

> *Several sections are relatively information-dense, and adding a few brief transitional or summary paragraphs between major sections would improve the overall readability.*

Three sections, II, III, and IV, had a section heading immediately followed by a
subsection heading with no prose between them, which we suspect is much of what
the reviewer experienced. Each now opens with a short orienting paragraph that
links back to the preceding argument and says what the section establishes,
following the pattern already used at the start of Section IX.

---

## Summary of changes

| Location | Change |
|---|---|
| Suppl. Sec. 1, Table S1 | New search and screening procedure with measured counts |
| Sec. II-C | Pointer to the frame, the counts, and the verification step |
| Sec. III | Label, orienting paragraph, domain-pretrained generative models |
| Sec. IV | Orienting paragraph, taxonomy-status statement, C-level boundary tests, when-to-use guidance |
| Sec. V | GraphRAG engineering variants and their transfer to biomedicine |
| Sec. VIII | Preprint status attached to the KG-LLM-Bench claim |
| Sec. IX | New Table VI comparing twelve systems; C-levels in the design path |
| Sec. X, Table VIII | Evidence-status column |
| Sec. XI, Table IX | Coupling-depth column; matched-baseline restatement condensed |
| Sec. XII | Circular self-validation condensed to a cross-reference |
| Sec. XIII | Comparator ladder condensed; multimodal and trustworthy-deployment priorities added |
| Sec. I | Peer-reviewed and preprint evidence separated in the frontier paragraph |
| `references.bib` | Four verified additions: LightRAG, HippoRAG, BioMistral, MEDITRON-70B |
