# LessonOps Knowledge Base Design

Date: 2026-05-09
Status: Draft v0.1

## 1. Decision

LessonOps should use an Obsidian-style Knowledge Base.

The Knowledge Base source of truth should be readable Markdown notes with properties and internal links, not database rows and not a hidden vector database.

This Knowledge Vault is the heart of LessonOps. It is the school's approved teaching brain: visible to teachers, editable over time, portable across tools, and directly usable by AI.

```text
Source Library
-> extraction and LLM/graphify analysis
-> Knowledge Vault Markdown notes
-> teacher/reviewer approval
-> generation from approved KB slices
-> source-linked practice and assessments
```

PostgreSQL is still required for relational application data, but it should not be the primary storage format for KB content.

PostgreSQL owns:

- tenants
- users and roles
- permissions
- workflow state
- assignments
- assessments
- attempts
- marks
- audit logs
- indexes/caches that can be rebuilt from the vault

The Knowledge Vault owns:

- concept notes
- topic notes
- curriculum notes
- skill notes
- common mistake notes
- teaching strategy notes
- internal links and backlinks
- source anchors
- teacher-approved learning structure

If a KB index table is lost, it should be rebuildable from the Markdown vault.

## 2. Why Obsidian Style Fits LessonOps

Teachers think in notes, topics, lessons, skills, and relationships.

LLMs also work well with clean Markdown, headings, frontmatter, links, and source citations.

An Obsidian-style KB gives us:

- human-readable knowledge
- AI-readable context
- portable content
- visible links between concepts
- graph view and backlinks
- property-based filtering
- easier teacher review
- no dependency on opaque embedding indexes for core knowledge

The goal is not to clone Obsidian. The goal is to use the best ideas:

- notes
- properties
- internal links
- backlinks
- graph view
- database-like filtered views

## 3. Storage Model

Use a per-tenant Knowledge Vault.

Canonical KB content should be stored as versioned Markdown files, likely in Cloud Storage first.

Example object layout:

```text
gs://lessonops-kb/{tenant_id}/vault/
  math/grade-07/ratio-and-proportion/unit-rate.md
  math/grade-07/ratio-and-proportion/equivalent-ratios.md
  math/grade-07/fractions/equivalent-fractions.md
  english/grade-08/reading/inference.md
  .lessonops/manifest.json
```

Later, we can add Git sync or export/import so a school can keep a portable Markdown copy.

The file is the KB source of truth. Database rows may index files for speed, permissions, and workflow, but they should not become the only copy of the KB note.

## 4. Knowledge Note Format

Use Markdown with YAML frontmatter.

Example:

```markdown
---
id: kb_math_g7_unit_rate
type: concept
status: approved
subject: math
grade_levels: [7]
programs: [triway_contest_math, triway_school_math]
topic: ratio_and_proportion
difficulty_range: [D2, D4]
prerequisites:
  - "[[Ratio]]"
  - "[[Division]]"
related:
  - "[[Equivalent Ratios]]"
  - "[[Proportional Reasoning]]"
common_mistakes:
  - confuse total ratio with unit amount
  - divide in the wrong direction
source_anchors:
  - source_id: src_...
    anchor_id: anchor_...
    rights_category: teacher_owned
  - source_id: src_...
    anchor_id: anchor_...
    rights_category: public_domain
approved_by: teacher_id
approved_at: 2026-05-09
---

# Unit Rate

A unit rate compares a quantity to one unit of another quantity.

## Student-Friendly Explanation

If 4 notebooks cost 12 dollars, the unit rate is 3 dollars per notebook.

## Teaching Notes

Students should identify which quantity should become 1.

## Generation Guidance

- Use real-world rate contexts.
- Include both direct unit-rate questions and comparison questions.
- Avoid revealing the answer in preview images.

## Good Question Patterns

- Find cost per item.
- Compare two shopping options.
- Convert a ratio into a rate.

## Related Concepts

- [[Ratio]]
- [[Equivalent Ratios]]
- [[Proportional Reasoning]]
```

## 5. Link Types

Internal links can be simple Markdown/Obsidian-style links in note content.

For structured graph behavior, also use frontmatter relationship fields.

Recommended relationship types:

- prerequisite_of
- related_to
- part_of
- example_of
- assessed_by
- common_error_for
- easier_than
- harder_than
- supports_curriculum_expectation

Example:

```yaml
relationships:
  - type: prerequisite_of
    target: "[[Proportional Reasoning]]"
  - type: assessed_by
    target: "[[Ratio Word Problems]]"
  - type: common_error_for
    target: "[[Dividing In Wrong Direction]]"
```

## 6. KB Build Workflow

```text
source files uploaded or source URLs imported
-> text/chunks/anchors extracted
-> LLM suggests concepts, properties, links, and source anchors
-> graphify optionally discovers graph nodes and relationships
-> draft KnowledgeNotes are created
-> teacher/reviewer approves or edits notes
-> approved notes become available for generation
```

LLM can help with:

- concept extraction
- duplicate concept merging
- prerequisite suggestions
- common mistake extraction
- source anchor mapping
- topic hierarchy drafting
- generation guidance drafting

LLM output is a draft. Teacher/reviewer approval is required before a KB note is trusted for production generation.

## 7. Generation From KB

Teachers should generate from a KB slice, not only one source file.

Example:

```text
Knowledge Base: Triway Grade 7 Math
Slice: Ratio and Proportion > Unit Rate
Sources: approved teacher-owned + public-domain + licensed internal sources
Question mix: 4 multiple choice, 4 short answer, 2 open response
Difficulty: D2-D4
Output: practice set or assessment candidate pool
```

Generation context bundle:

- selected KnowledgeNotes
- linked prerequisite notes
- common mistake notes
- approved source anchors
- generation profile
- difficulty model
- rights filters
- teacher instruction

Generated questions must still store source lineage:

- KB note IDs
- source IDs
- source anchor IDs
- generation profile ID/version
- rights category
- teacher approval status

## 8. Search And Retrieval

Do not use vector DB or embeddings as part of the planned core KB mechanism.

Core KB search and context assembly should use explicit, teacher-readable structure:

- note path
- properties
- internal links
- backlinks
- graph traversal
- source anchors
- full-text search
- teacher-approved views

AI should work from a context bundle assembled from the Markdown vault:

- selected KnowledgeNotes
- linked prerequisite and related notes
- source anchors
- source-rights filters
- common mistakes
- generation guidance
- teacher instructions

This is the AI-native path for LessonOps: the model reads curated Markdown knowledge, not an opaque semantic index.

If the team later believes semantic search is needed, it must be handled as separate future research with a fresh design review. It must not replace the Markdown vault as the source of truth.

## 9. Views

Like Obsidian Bases, LessonOps should provide filtered views over KB notes.

Useful views:

- subject / grade / topic table
- concept graph
- prerequisite map
- common mistakes by topic
- source coverage by topic
- question coverage by topic
- assessment coverage by curriculum expectation
- notes needing review
- orphan concepts with no source anchors

These views can be backed by database indexes, but the note content remains in the vault.

## 10. Relationship With Source Library

Source Library and Knowledge Base are different.

Source Library:

- original files
- source rights
- source trust level
- extracted chunks
- anchors into original source
- raw evidence

Knowledge Base:

- teacher-approved learning structure
- concepts and relationships
- source-linked explanations
- teaching guidance
- generation guidance
- common mistakes

The Source Library keeps evidence. The Knowledge Base organizes knowledge.

## 11. Relationship With Graphify

Use graphify as an offline discovery/import tool.

```text
source folder
-> graphify graph/report
-> import candidate nodes and relationships
-> generate draft KnowledgeNotes
-> teacher/reviewer approval
-> store approved notes in the Knowledge Vault
```

Graphify should not be the production KB, source-rights system, student data system, or runtime question bank.

## 12. Current Decision

Use:

```text
Knowledge Vault Markdown files as KB source of truth
PostgreSQL for relational app data and rebuildable indexes
Cloud Storage for tenant KB vault storage
LLM + graphify for draft KB creation
Teacher/reviewer approval for trusted KB notes
No vector DB or embedding dependency in the current KB design
```

## 13. References

- Obsidian internal links: https://help.obsidian.md/Linking%20notes%20and%20files/Internal%20links
- Obsidian graph view: https://help.obsidian.md/plugins/graph
- Obsidian Bases: https://help.obsidian.md/bases
- Obsidian properties: https://help.obsidian.md/plugins/properties
