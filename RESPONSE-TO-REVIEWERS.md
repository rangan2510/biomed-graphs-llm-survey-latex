# Response to Reviewers

**Manuscript ID:** AISE-2026-0024
**Title:** Biomedical Knowledge Graphs and Large Language Models: A Critical Engineering Survey
**Journal:** Artificial Intelligence Science and Engineering
**Date:** 22 August 2026

---

## To the Editor

Dear Prof. Wen,

Thank you for handling our manuscript and for the opportunity to revise it. We
are grateful to both reviewers, who read a long manuscript closely and raised
nine points specific enough to act on directly. Every point led to a change in
the paper.

As requested, changes are highlighted in coloured text. We supply four files:

| File | Contents |
|---|---|
| `main.pdf` | Revised manuscript, clean |
| `main-revised-marked.pdf` | Revised manuscript, all changes in blue |
| `supplementary.pdf` | Revised supplement, clean |
| `supplementary-revised-marked.pdf` | Revised supplement, changes in blue |

The marked and clean files are compiled from a single source, so they cannot
differ in anything but colour.

Three notes on the revision as a whole.

First, for Reviewer 1's request for a search procedure, we chose to re-run the
searches and report measured counts rather than describe the process
qualitatively or reconstruct a protocol after the fact. The numbers in the new
Table S1 came from queries a reader can re-issue, and we state plainly which
parts of a systematic-review procedure we did not perform.

Second, building the comparison table Reviewer 2 requested produced a finding we
have reported rather than worked around: none of the twelve representative
systems reports the language model and version behind its headline result. We
kept the column, marked it *not reported* throughout, and discuss what that
means, because it is the same reporting failure the paper asks of deployed
systems elsewhere.

Third, we cut duplicated material from Sections VII and X–XIII in response to
Reviewer 1's fourth point, which partly paid for the additions requested
elsewhere. The main paper grows from 33 to 35 pages and the supplement from 6 to
7.

We disagree with one sub-point, on repetition of the graph-coverage discussion,
and we explain our reasoning under R1.4 rather than declining it silently.

Yours sincerely,
The Authors

---

# Reviewer 1

## Complete comments as received

> This paper provides a systematic engineering-oriented review of the integration of biomedical knowledge graphs (KGs) and large language models (LLMs). Rather than being limited to the conventional KG→LLM / LLM→KG classification, it develops a unified analytical framework covering knowledge-flow direction, lifecycle stage, coupling depth, knowledge object, and evidence maturity, and further discusses GraphRAG, graph reasoning, agents, temporal knowledge, evaluation, clinical translation, and safety governance. Overall, the manuscript is well structured, covers recent literature, and provides valuable discussion of the limitations of KG-based grounding, faithfulness, and clinical safety. The overall quality of the manuscript is high.
>
> 1. The paper adopts representative systems rather than exhaustive literature coverage, which is consistent with its positioning as a critical engineering survey. However, the literature selection process remains relatively qualitative. A brief structured search and screening procedure, including the databases, search terms, time range, and numbers of initially identified and finally included studies, would improve the transparency and reproducibility of the review.
>
> 2. The proposed coupling depth (C0–C5), evaluation layers (L1–L7), and evidence maturity (E0–E6) constitute important analytical frameworks in this paper, but they are currently based mainly on conceptual categorisation. The criteria or boundaries between the different levels should be clarified further, and it should be made explicit that these frameworks are primarily intended as an engineering taxonomy.
>
> 3. The paper covers a substantial amount of recent work from 2025–2026, some of which provides key evidence but remains in preprint form or at an early stage of validation. Peer-reviewed evidence should be more clearly distinguished from preprint or early-stage evidence in the synthesis, and the strength of broader trend-level conclusions derived from such studies should be appropriately moderated.
>
> 4. The latter part of the manuscript contains some repetition regarding matched baselines, graph coverage, temporal leakage, provenance, and circular self-validation. Some overlapping discussion across Sections VII and X–XIII could be condensed, with cross-references to earlier sections or tables used where appropriate to improve conciseness and distinction between sections.

---

## R1.0 — General assessment

> *Overall, the manuscript is well structured, covers recent literature, and provides valuable discussion of the limitations of KG-based grounding, faithfulness, and clinical safety. The overall quality of the manuscript is high.*

**Response.** We thank the reviewer for this assessment, and for recognising the
analytical framework as the contribution we intended. The four points below were
the most useful feedback we received on that apparatus, and we have acted on all
of them.

---

## R1.1 — Structured search and screening procedure

> *The paper adopts representative systems rather than exhaustive literature coverage, which is consistent with its positioning as a critical engineering survey. However, the literature selection process remains relatively qualitative. A brief structured search and screening procedure, including the databases, search terms, time range, and numbers of initially identified and finally included studies, would improve the transparency and reproducibility of the review.*

**Response.** We accept this criticism. Section II-C stated inclusion and
exclusion criteria but named no database, no query, no date range, and no counts,
so a reader had no way to judge the frame those criteria were applied to.

Rather than reconstruct a protocol from memory, we re-ran the searches and report
what they returned.

**Added:** a new Section 1 and Table S1 in the supplement, with a short pointer
paragraph in Section II-C of the main paper.

Five conjunctive queries were issued against **arXiv, PubMed, OpenAlex, and
DBLP** on 22 August 2026, each requiring a knowledge-graph term and a
language-model term to co-occur in a biomedical context, with PubMed and OpenAlex
filtered to 2023 onward at the query level. The yield:

| | Records |
|---|---:|
| Retrieved across the four interfaces | 1879 |
| Duplicates removed | 732 |
| **Distinct works** | **1147** |
| Cited in the review | 105 |

Deduplication was on DOI where available, then arXiv identifier, then normalised
title, resolving 823, 263, and 61 records respectively, with three left without a
usable identifier. Per-query and per-interface counts and the full query strings
are in Table S1 and the accompanying replication log.

We have also been explicit about what we did **not** do, preferring to state a
limitation over implying a rigour we cannot evidence. Screening was performed by
the authors without independent duplicate assessment; titles and abstracts were
read in a single pass; and we therefore report the sampling frame and the
criteria rather than a stage-by-stage exclusion count. We state that we make no
claim of conformance to systematic-review reporting standards such as PRISMA,
because exhaustive capture is deliberately not the goal of a critical engineering
survey, for the reason already argued in Section II-C.

**Additionally,** the new supplement section records a verification step
performed during preparation but never described: every retained reference was
checked against a canonical record through the Crossref, arXiv, OpenAlex, DBLP,
Semantic Scholar, bioRxiv, and PubMed interfaces together with the ACL Anthology
and PMLR, and the publication status of every preprint was re-checked. That is
what makes the distinction requested in R1.3 reliable rather than approximate.

---

## R1.2 — Boundaries between levels, and the status of the frameworks

> *The proposed coupling depth (C0–C5), evaluation layers (L1–L7), and evidence maturity (E0–E6) constitute important analytical frameworks in this paper, but they are currently based mainly on conceptual categorisation. The criteria or boundaries between the different levels should be clarified further, and it should be made explicit that these frameworks are primarily intended as an engineering taxonomy.*

**Response.** We are grateful for both halves of this point, particularly the
second, which we had left implicit in a section title rather than stating.

**On the status of the frameworks.** Section IV now opens by saying directly that
the five axes are engineering constructs proposed here to organise evidence and
enable comparison, that they carry no psychometric claim, and that a system's
position describes its architecture and its evidence rather than scoring it. We
also state the convention for straddling cases, which a reader previously had to
infer from the ranges in Table II: where a system satisfies more than one level,
the deeper level is recorded only if that mechanism is load-bearing for the
reported result.

**On boundary criteria for C0–C5.** We added questions that separate the levels
and can be answered from a system description without judgment:

1. Does structured graph content reach the model at inference, or a graph query
   leave it? If not, C0.
2. Does the model issue more than one graph call within a single answer,
   conditioned on what earlier calls returned? If so, C2 rather than C1.
3. Are graph-derived vectors, tokens, or adapter modules combined with language
   representations? That is C3.
4. Were weights changed using graph-derived supervision, examples, or
   constraints? That is C4, and it is the only level that cannot be reversed by
   editing the graph.
5. Does the graph gate what may be emitted, or does output feed back into the
   graph? That is C5.

**On L1–L7 and E0–E6.** The evaluation layers already name concrete measures per
layer in Table VII, together with the one ordinal rule that applies to them: the
first five layers should appear in any offline system paper, and layers 6 and 7
become mandatory once claims move to translational or clinical utility. The
evidence-maturity gates are specified in the supplement as five explicit
transition criteria; Gate A, for instance, requires the configuration to be
frozen before testing and compared against closed-book, long-context,
vector-retrieval, symbolic, and oracle-evidence arms. We have kept that detail in
the supplement to hold the main paper's length, and the cross-references from
Section XI are now explicit so a reader knows the criteria exist and where to
find them.

---

## R1.3 — Peer-reviewed versus preprint evidence

> *The paper covers a substantial amount of recent work from 2025–2026, some of which provides key evidence but remains in preprint form or at an early stage of validation. Peer-reviewed evidence should be more clearly distinguished from preprint or early-stage evidence in the synthesis, and the strength of broader trend-level conclusions derived from such studies should be appropriately moderated.*

**Response.** The reviewer has identified a gap between a policy we stated and a
practice we did not follow. Section II-C promised that preprints "are labeled as
preprints at the point of use", and in the submitted version that happened in
only two places. We made three changes.

**1. Table IX now carries an evidence-status column.** This table assembles what
its caption calls the survey's central empirical claim, and it previously
presented preprint and peer-reviewed evidence in identical form. Section X
already argued that evidence tables should keep peer-review status in a separate
column, so the table now follows the paper's own recommendation.

Checking every row against the publication record was itself informative: of the
twelve conditions, **eleven rest on peer-reviewed work and one rests on a
preprint**. That row is now labelled, and its interpretation cell states that the
magnitudes are indicative and come from a single study.

**2. The introduction's frontier paragraph separates results by status.** Three of
the four results characterising the 2026 frontier are peer-reviewed, and we now
say so. The fourth, ChronoMedKG, is identified as a preprint; we state that we
treat its magnitudes as indicative while noting its direction is consistent with
the peer-reviewed results alongside it. The trend-level conclusion drawn from the
paragraph now rests on the peer-reviewed evidence, with the preprint as
corroboration rather than as a premise.

**3. One overstated verb has been weakened.** Section VIII previously said
KG-LLM-Bench "established" that textualisation is an experimental factor. That
work is a workshop preprint; the sentence now says "reported", identifies it as a
preprint, and contrasts it with the peer-reviewed MHGraphBench result alongside
it.

---

## R1.4 — Repetition across Sections VII and X–XIII

> *The latter part of the manuscript contains some repetition regarding matched baselines, graph coverage, temporal leakage, provenance, and circular self-validation. Some overlapping discussion across Sections VII and X–XIII could be condensed, with cross-references to earlier sections or tables used where appropriate to improve conciseness and distinction between sections.*

**Response.** We reviewed every instance of all five themes across Sections VII
and X–XIII. The reviewer is right on four of them, and one instance was
substantial enough that we are grateful it was caught.

**Circular self-validation, condensed.** The subsection in Section XII duplicated
the treatment in Section VII closely, presenting the same mechanism and the same
quarantine-and-promotion controls, and closing with a sentence on
least-privilege tool access that appeared near-verbatim in both places. Section
XII now carries a single cross-reference to Section VII and retains only the
corresponding row of Table XI, which supplies the verification evidence, a
lineage query, a simulated circularity test, and a reversible update drill, that
neither prose passage provided.

**Matched baselines, condensed.** The restatement at the end of Section XI added
no application-specific content and is now a cross-reference to Tables IX and
VIII. In Section XIII, the matched-comparisons priority re-enumerated the
comparator ladder and the topology-shuffle ablation already specified in Table
VIII; it now points to that table and retains only its distinct contribution, the
call for a decision rule predicting which query types benefit from a graph.

**Temporal leakage and provenance.** These are now cross-referenced rather than
restated where the restatement added nothing, notably in the Section XIII
priorities, which defer to the treatments in Sections VIII and IX.

**Graph coverage, respectfully retained.** This is the one sub-point where we
have not made a cut, and we would rather explain than decline silently. Examining
the places where coverage appears, each does distinct work: Section X
operationalises it as task-specific coverage rather than an unknowable global
quantity; Section X later uses it as a gating variable in the evidence table;
Section X also raises it as a subgroup-fairness concern; Section IX uses it as a
design-time check before committing to a graph; and Section VIII discusses source
coverage of the graph itself. Removing any instance would leave its section
incomplete. Our reading is that the repetition noticed here is of the phrase
rather than of the argument. We are of course willing to condense further if the
reviewer still finds it redundant on re-reading.

---

# Reviewer 2

## Complete comments as received

> This survey provides a comprehensive and well-organized overview of the integration between biomedical knowledge graphs (KGs) and large language models (LLMs). The proposed multidimensional taxonomy, engineering-oriented lifecycle analysis, and evidence-centric discussion distinguish this review from existing surveys. Overall, the manuscript is technically sound, clearly written, and suitable for publication after revisions.
>
> 1. The proposed engineering taxonomy is one of the major contributions of this survey. However, the practical implications of the taxonomy could be further clarified. Specifically, the authors are encouraged to discuss when different coupling depths or lifecycle stages are most appropriate for different biomedical applications, making the framework more actionable for practitioners.
>
> 2. The manuscript would benefit from a concise comparison table summarizing representative KG–LLM systems, including the knowledge graph type, LLM backbone, coupling strategy, target application, advantages, and limitations. Such a summary would significantly improve readability.
>
> 3. Although the survey is generally up to date, the discussion of the latest biomedical foundation models and recent GraphRAG developments could be further strengthened to better reflect the rapidly evolving landscape.
>
> 4. The conclusion could be expanded by providing a more forward-looking discussion on future research directions, such as continual knowledge updating, multimodal biomedical AI, trustworthy deployment, and standardized evaluation protocols.
>
> 5. The manuscript is generally well written. Nevertheless, several sections are relatively information-dense, and adding a few brief transitional or summary paragraphs between major sections would improve the overall readability.

---

## R2.0 — General assessment

> *Overall, the manuscript is technically sound, clearly written, and suitable for publication after revisions.*

**Response.** We thank the reviewer for this assessment. The five points below
were oriented toward making the paper more useful to a practitioner, which is the
audience we were writing for, and they improved it in exactly that direction.

---

## R2.1 — Practical implications of the taxonomy

> *The proposed engineering taxonomy is one of the major contributions of this survey. However, the practical implications of the taxonomy could be further clarified. Specifically, the authors are encouraged to discuss when different coupling depths or lifecycle stages are most appropriate for different biomedical applications, making the framework more actionable for practitioners.*

**Response.** This diagnosis was accurate and, on re-reading, somewhat
embarrassing. Section IX already contained a design path written in imperative
mood for exactly this purpose, but it was organised by retrieval mechanism and
never named a single coupling level. The taxonomy in Section IV and the practical
guidance in Section IX were disconnected, so the taxonomy read as description
rather than as a tool. We have joined them in three places.

**Section IV now states when each depth is appropriate, and why.** Shallow
coupling, C1 and C2, where a clinician must audit each claim or where the
underlying knowledge changes faster than a training cycle, because these keep the
evidence inspectable and the graph correctable in place. Deeper coupling, C3 and
C4, where throughput or latency dominates and attribution is not required at the
point of use, as in high-volume triage or molecular property prediction.
Constrained coupling, C5 with a deterministic verifier, where the output must
satisfy a rule that can be written down, such as an eligibility or interaction
constraint, since that is more auditable and more stable across model versions
than asking a generator to be careful.

**Table X now carries a coupling-depth column,** giving the crosswalk the
reviewer asked for from biomedical application area to recommended depth. Trial
matching is C5 with a deterministic verifier; patient communication is C1 with
bounded scope; diagnosis and prognosis is C1–C2 where the output is audited and
C3 where throughput dominates.

**The design path in Section IX is annotated with C-levels,** so a reader
following it can see which part of the taxonomy each recommendation instantiates.

---

## R2.2 — Comparison table of representative systems

> *The manuscript would benefit from a concise comparison table summarizing representative KG–LLM systems, including the knowledge graph type, LLM backbone, coupling strategy, target application, advantages, and limitations. Such a summary would significantly improve readability.*

**Response.** Added as **Table VI** in Section IX, covering twelve representative
systems with the six columns requested. We agree it improves readability, and it
did more than that: assembling it surfaced two patterns that were invisible while
the same information was distributed across four tables and the prose.

**The backbone column is empty, and we have reported that rather than hiding
it.** Of the twelve systems, **none reports the language model and version behind
its headline result** in a form that would let a reader reproduce it. The only
named models anywhere in the set are the GPT-4 baselines the trial-matching study
measured against. The column therefore reads *n.r.* throughout.

We considered omitting the column and decided that would be the wrong choice. The
absence is a property of the literature, not of this survey, and it is the same
reporting failure Section XII demands deployed systems avoid: our own
configuration tuple requires the model and version, and the supplement's
reporting package asks for an exact identifier and revision. A graph-augmented
result stated without its backbone cannot be reproduced, because the same graph in
front of a stronger model is a different experiment, and the shrinking-gain
effect discussed in Section III makes that difference decisive rather than
incidental. We now say so in the text accompanying the table.

**Coupling depth clusters at C1 and C2.** Eleven of the twelve systems keep the
graph outside the weights, preserving auditability and in-place correction. The
single system reaching C5 is also the only one of the twelve with prospective
clinician-facing evaluation. We note that twelve cases cannot settle whether that
association is causal or an artifact of who builds deployable systems, but it is
the clearest signal in the table.

Every cell was taken from what the source paper reports, with nothing inferred;
where a fact is not reported, the cell says so.

---

## R2.3 — Latest biomedical foundation models and recent GraphRAG developments

> *Although the survey is generally up to date, the discussion of the latest biomedical foundation models and recent GraphRAG developments could be further strengthened to better reflect the rapidly evolving landscape.*

**Response.** Both gaps were real. We had cited the original GraphRAG work only as
a pattern precedent and discussed no subsequent variant, and we had omitted
generative biomedical models entirely.

**GraphRAG engineering variants, added to Section V.** We now discuss LightRAG,
which replaces global community summarisation with a dual-level keyword index and
incremental insertion so a graph can be updated without a full rebuild, and
HippoRAG, which uses a schema-less open-extraction graph with personalised
PageRank for single-step associative multi-hop retrieval. We make the biomedical
point rather than merely listing them: both target the indexing cost and
staleness problems that matter most here, neither has been evaluated on a curated
biomedical graph with typed relations, and the transfer is not automatic.
LightRAG's incremental index assumes edges are additive rather than retracted,
which a terminology release violates, and HippoRAG's extracted graph carries none
of the qualifier or provenance structure that Section IX identifies as the source
of biomedical value. Adapting these efficiency gains to versioned, typed,
provenance-bearing graphs is an open and tractable problem.

**Generative biomedical models, added to Section III.** We now discuss Med-PaLM,
MEDITRON-70B, and BioMistral. We note that our scope statement excluded
encoder-only biomedical models, which is defensible, but that the exclusion did
not cover generative ones, so their absence was an oversight rather than a
scoping decision.

The substantive point is that these models sharpen rather than soften the
survey's argument. Domain pretraining improves terminology, calibration on
in-domain phrasing, and instruction following, and it leaves the knowledge
undated, unattributable, and updatable only by retraining. A stronger biomedical
backbone raises the closed-book baseline any graph-augmented system must beat,
which makes the matched comparison of Section X more demanding rather than less
necessary. The reviewed evidence that graph gains shrink as backbones strengthen
is exactly this effect.

---

## R2.4 — Forward-looking discussion

> *The conclusion could be expanded by providing a more forward-looking discussion on future research directions, such as continual knowledge updating, multimodal biomedical AI, trustworthy deployment, and standardized evaluation protocols.*

**Response.** Checking the four topics against Section XIII, two were already
present and two were genuinely missing. We have added the two that were absent
and, rather than padding the section, note here where the other two already sit.

**Already present.** *Continual knowledge updating* is the priority on update
metrics for graph-maintaining agents, which argues that such agents are evaluated
on question-answering accuracy when what is needed is candidate-edge precision by
relation type, conflict-resolution accuracy, time from published correction to
graph correction, propagation radius of a bad edge, and demonstrated rollback.
*Standardised evaluation protocols* run through the matched-comparisons and
claim-level-evaluation priorities and the closing proposal for a shared versioned
evidence record.

**Added: multimodal biomedical AI.** The gap we identify is not multimodal graph
construction, which is now routine, but modality-level attribution. No reviewed
system can state which modality carried a given conclusion. We argue that a
multimodal system should be able to say a prediction rested on the structure
rather than the text, and should be ablated one modality at a time, because a
fused embedding hides exactly the attribution a clinician needs. Aligned
representations also inherit the coverage and provenance problems of every
contributing source at once, so the data card has to be completed per modality
rather than per graph.

**Added: trustworthy deployment.** Previously folded into the security priority,
this is now a priority in its own right, covering privacy, human oversight,
change control under regulatory constraint, and post-deployment monitoring. The
point is that these are treated as requirements in Section XII and the
supplement, yet almost no reviewed system reports evidence against them, so the
binding constraint on clinical deployment is the gap between controls that are
specifiable and controls that are demonstrated, which is an evaluation problem
rather than a modelling one.

---

## R2.5 — Transitions and readability

> *The manuscript is generally well written. Nevertheless, several sections are relatively information-dense, and adding a few brief transitional or summary paragraphs between major sections would improve the overall readability.*

**Response.** Thank you for this. Investigating it, we found a concrete and
slightly embarrassing cause rather than a diffuse density problem: three
sections, **II Review Scope and Method, III Foundations, and IV A
Multidimensional Engineering Taxonomy**, had a section heading immediately
followed by a subsection heading with no prose between them. A reader arriving
there was given two headings and then technical detail, with nothing saying what
the section was for. We suspect this accounts for much of the density the
reviewer experienced.

Each of the three now opens with a short orienting paragraph that links back to
the preceding argument and states what the section establishes, following the
pattern already used at the start of Section IX, which reads "Section VIII
described the graphs as data. This section asks the question an engineer actually
starts with...". Section III, for example, now explains that the rest of the
survey turns on properties a triple store does not automatically have, namely
qualifiers, provenance, time, and a release process, and that the section
establishes these for graphs and models separately because the failure modes
analysed later are usually a mismatch between the two rather than a defect in
either.

---

# Summary of changes

| Location | Change | Comment |
|---|---|---|
| Suppl. Sec. 1, Table S1 | New search and screening procedure with measured counts | R1.1 |
| Sec. II-C | Pointer to the sampling frame, counts, and verification step | R1.1 |
| Sec. III | Section label; orienting paragraph; generative biomedical models | R2.5, R2.3 |
| Sec. IV | Orienting paragraph; taxonomy-status statement; C0–C5 boundary tests; when-to-use guidance | R2.5, R1.2, R2.1 |
| Sec. V | GraphRAG engineering variants and their transfer to biomedicine | R2.3 |
| Sec. VII | Section label added for cross-referencing | R1.4 |
| Sec. VIII | Preprint status attached to the KG-LLM-Bench claim | R1.3 |
| Sec. IX | New Table VI comparing twelve systems; C-levels in the design path | R2.2, R2.1 |
| Sec. X, Table IX | Evidence-status column added | R1.3 |
| Sec. XI, Table X | Coupling-depth column added; matched-baseline restatement condensed | R2.1, R1.4 |
| Sec. XII | Circular self-validation condensed to a cross-reference | R1.4 |
| Sec. XIII | Comparator ladder condensed; multimodal and trustworthy-deployment priorities added | R1.4, R2.4 |
| Sec. I | Peer-reviewed and preprint evidence separated in the frontier paragraph | R1.3 |
| `references.bib` | Four verified additions: LightRAG, HippoRAG, BioMistral, MEDITRON-70B | R2.3 |

**Length.** Main paper 33 → 35 pages; supplement 6 → 7 pages. The condensations
under R1.4 recovered approximately one page, partly offsetting the new table and
the added discussion.

**Verification.** Both documents compile with no errors and no undefined
references or citations. All new references were checked against the arXiv API
before being added.
