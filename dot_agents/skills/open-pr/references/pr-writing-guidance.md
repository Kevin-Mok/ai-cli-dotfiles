# PR Writing Guidance

Use this reference to ground `open-pr` output in broadly accepted PR-writing
guidance. Keep the final PR specific to the branch evidence; do not cite these
sources inside a PR body unless the user asks for citations.

## Source Guidance To Encode

- GitHub Docs: PRs are the collaboration surface for proposing, discussing,
  reviewing, checking, and merging changes. Treat the PR body as the central
  context hub for reviewers, and remember that GitHub compares head against the
  merge base of head and base.
  Source: <https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests>
- Google Engineering Practices: prefer small, self-contained CLs; include
  related tests; put everything the reviewer needs in the CL, description,
  existing codebase, or prior reviewed CLs; call out rollback and merge
  complexity for large changes.
  Source: <https://google.github.io/eng-practices/review/developer/small-cls.html>
- Minware: use compact, predictable PR sections for context, summary, test
  evidence, screenshots when relevant, risk, rollback, and repo-specific areas
  such as security, performance, migrations, flags, and docs.
  Source: <https://www.minware.com/blog/effective-pr-template>
- The Pragmatic Engineer: make titles clear enough for reviewer triage, explain
  the "why", and include visual support for web or mobile changes.
  Source: <https://blog.pragmaticengineer.com/pull-request-or-diff-best-practices/>
- DeployHQ: give AI `git log`, `git diff --stat`, and selected/full diffs as
  needed; then trim verbosity, remove inflated claims, and add environment
  facts AI cannot know, especially test steps and business context.
  Source: <https://www.deployhq.com/git/writing-pull-request-descriptions-with-ai>
- "The Value of Effective Pull Request Description" (arXiv:2602.14611):
  developers value purpose and code explanations for rationale/history, and
  stating the desired feedback type is associated with acceptance and reviewer
  engagement.
  Source: <https://arxiv.org/abs/2602.14611>

## Practical Rules

- Anchor the PR in purpose, code-change explanation, verification evidence,
  reviewer focus, and rollback/risk.
- Prefer stable core sections over bespoke structure unless the repository has
  its own template.
- Ask whether an oversized or mixed-scope branch should be split when the diff
  suggests reviewers will struggle to reason about it.
- For UI, docs rendering, demos, and deploy review, include screenshots, live
  links, or a truthful "not captured" note.
- Do not let AI polish hide uncertainty. Honest gaps are useful review context.
