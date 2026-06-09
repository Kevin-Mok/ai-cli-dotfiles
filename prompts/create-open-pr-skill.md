# Prompt: Create Or Refresh An `open-pr` Codex Skill

Use this prompt to create or refresh a Codex skill named `open-pr` that
drafts strong pull request titles and descriptions from the current branch
diff into a requested base branch.

The skill should combine Kevin's LessonOps PR style with current PR-writing
guidance from GitHub, Google Engineering Practices, Minware, The Pragmatic
Engineer, DeployHQ, and the arXiv paper "The Value of Effective Pull Request
Description."

## Context Files To Include

Paste these into the prompt context before asking for the skill update:

### Required

- the existing `open-pr/` skill folder if it already exists
- one or two representative local `SKILL.md` files that match your preferred
  level of structure and tone
- local skill-creation guidance, if your repo has one
- the current branch name and desired base branch
- fresh command output:
  - `git status --short`
  - `git branch --show-current`
  - `git merge-base HEAD <base>`
  - `git log --oneline <merge-base>..HEAD`
  - `git diff --stat <merge-base>..HEAD`

### LessonOps Style References

Include these PRs or local `docs/pr/` equivalents when the skill should learn
Kevin's LessonOps PR style:

- [PR #13: Recover local Google student progress smoke path](https://github.com/admintriwayeducation/lessonops/pull/13)
- [PR #12: Add student demo Google progress flow](https://github.com/admintriwayeducation/lessonops/pull/12)
- [PR #9: Connect approved worksheets FE/BE](https://github.com/admintriwayeducation/lessonops/pull/9)
- [PR #8: Add static Gauss 7/8 worksheet bundle](https://github.com/admintriwayeducation/lessonops/pull/8)
- [PR #6: Add CEMC Gauss 8 scraper and tracked source JSON](https://github.com/admintriwayeducation/lessonops/pull/6)

### External PR-Writing Guidance

Use and cite these sources inside the skill or its references:

- [GitHub Docs: About pull requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests)
- [Google Engineering Practices: Small CLs](https://google.github.io/eng-practices/review/developer/small-cls.html)
- [Minware: 10 Pull Request Template Sections That Speed Up Code Reviews](https://www.minware.com/blog/effective-pr-template)
- [The Pragmatic Engineer: Pull request best practices](https://blog.pragmaticengineer.com/pull-request-or-diff-best-practices/)
- [DeployHQ: Writing Pull Request Descriptions with AI](https://www.deployhq.com/git/writing-pull-request-descriptions-with-ai)
- [arXiv: The Value of Effective Pull Request Description](https://arxiv.org/abs/2602.14611)

### Optional But Useful

- relevant `docs/pr/` files from the current repository
- active `plans/` documents for the branch
- `docs/smoke-tests.md`
- README sections touched by the branch
- recent test output, CI output, local smoke-test notes, screenshots, or live
  links
- issue, ticket, spec, or handoff notes that explain the business context

### Do Not Include Unless Needed

- full repository trees
- unrelated AGENTS files or skills
- broad test logs unrelated to the changed surface
- stale verification output that was not produced for the current branch

## Prompt

```md
You are an expert Codex skill designer and maintainer.

Task:
Create or refresh a Codex skill named `open-pr`.

Primary goal:
Make the skill reliably inspect the current branch against a requested base
branch, then draft a high-quality pull request title and body. For LessonOps
work, the output should match Kevin's recent PR style and be ready for
`docs/pr/`, GitHub, DD review, and Cindy handoff when applicable.

The skill name must be exactly `open-pr`.

Core behavior to implement:
1. Inspect the current branch against the desired base branch, not only the
   latest commit message.
2. Generate a concise, specific PR title that starts with an action verb when
   that matches the repo's convention.
3. Generate a PR body with enough context for a reviewer to understand why the
   branch exists, what changed, how to verify it, what risks remain, and what
   kind of review is most useful.
4. When the repository uses PR docs, write or update a matching Markdown file
   under `docs/pr/` and keep it in sync with the GitHub PR body.
5. If the user explicitly asks to open or update a GitHub PR and `gh` is
   available, use the generated title/body with `gh pr create` or `gh pr edit`
   after confirming the base/head context. If the user only asks for a draft,
   do not create or edit the GitHub PR.
6. Never invent tests, smoke results, screenshots, links, or CI status. If
   something was not run or was not captured, say that clearly.

Skill design requirements:
- Create or update a standard Codex skill folder named `open-pr/`.
- The required `SKILL.md` frontmatter must use `name: open-pr`.
- Make the frontmatter description broad enough to trigger when the user asks
  to draft, write, open, update, or prepare a PR title/body from branch changes.
- Keep `SKILL.md` lean and procedural. Use `references/` for longer LessonOps
  style notes, PR template guidance, or examples if needed.
- Do not create auxiliary docs such as README, INSTALLATION, QUICK_REFERENCE,
  or CHANGELOG files.
- If the local skill system uses `agents/openai.yaml`, create or refresh it so
  it matches the final `SKILL.md`.
- Prefer simple shell/git inspection over brittle parsing. Add scripts only if
  the workflow truly needs deterministic reuse.

Required inspection workflow for the skill:
1. Determine the desired base branch from the user request.
   - If no base is provided, infer `main` only when repo context makes that
     obvious.
   - If multiple bases are plausible, ask one concise question before drafting.
2. Capture worktree state:
   - `git status --short`
   - current branch name with `git branch --show-current`
   - remote/base context when needed with `git remote -v` and branch tracking
     info
3. Compute the branch comparison:
   - `git merge-base HEAD <base>`
   - `git log --oneline <merge-base>..HEAD`
   - `git diff --stat <merge-base>..HEAD`
   - `git diff --name-only <merge-base>..HEAD`
4. Inspect the meaningful changed files and supporting context:
   - relevant source diffs
   - relevant docs under `docs/pr/`, `docs/smoke-tests.md`, README, or active
     `plans/`
   - test files and test output
   - screenshots, live URLs, CI links, issue links, or handoff notes if present
5. Synthesize the PR from evidence. Keep a small notes list of what was
   directly observed versus what is inferred.

Required PR body sections:
- `## Summary / Why This Matters`
- `## What Changed`
- `## How To Smoke Test`
- `## Tests Written / Verification Run`
- `## Follow-Up / Next Steps`
- `## Reviewer Focus / What To Look For`
- `## Risks, Caveats, Known Failures, And Rollback`
- `## UI Screenshots / Live Links` when UI, docs rendering, demo, or deploy
  review is relevant
- LessonOps-specific DD/Cindy/local-backend notes when relevant

Section rules:
- If a section is not applicable, include `Not applicable` with a short reason
  rather than deleting required context.
- In `Tests Written / Verification Run`, separate:
  - automated tests written or updated
  - commands actually run
  - commands not run
  - known failing suites or unrelated failures
- In `How To Smoke Test`, use exact local commands and URLs when known. If a
  reviewer needs a local backend, say so explicitly.
- In `Reviewer Focus / What To Look For`, ask for the feedback type that would
  help most: product fit, FE/BE contract, security, smoke reproducibility,
  content quality, UI behavior, data shape, or rollback safety.
- In `Risks, Caveats, Known Failures, And Rollback`, include real caveats even
  if they make the PR look less polished. Honest gaps are better than false
  confidence.
- In `UI Screenshots / Live Links`, include screenshots, before/after notes,
  Vercel links, local URLs, or "not captured" truthfully.

LessonOps conventions to encode:
- When working in `/home/kevin/coding/lesson-ops` or
  `admintriwayeducation/lessonops`, create or update a PR doc under `docs/pr/`
  unless the user explicitly says not to.
- Mirror the recent LessonOps style from:
  - PR #13: strong recovery narrative, command evidence, known broader-suite
    failures, local Google smoke notes, and rollback.
  - PR #12: why the branch is separate, what changed, validation, demo
    credentials, manual smoke, and Firebase/DD follow-up.
  - PR #9: product-flow narrative, FE/BE boundary review focus, Docker Compose
    smoke, Cindy-local-demo guidance, and rollback.
  - PR #8: live site, content caveat, scope note, verification, manual UI
    checks, and rollback.
  - PR #6: concise summary, concrete scrape output numbers, next steps,
    verification commands, and quick-glance JSON review.
- For DD review, include a focused `Reviewer Focus / What To Look For` section.
- For Cindy-facing work, describe the product walkthrough in plain language and
  avoid making raw JSON, code, or local terminal output the main demo.
- For branches that require the local backend, state that clearly. If Cindy is
  expected to review and there is no live backend, say she needs DD or Kevin to
  show the flow locally because she reviews live Vercel sites and does not run
  code.
- Preserve known test gaps, fixture failures, backend limitations, local-only
  auth/demo status, and content accuracy caveats instead of smoothing them out.
- If the user asks to send work "to DD" or "to dd", prepare the PR against
  `admintriwayeducation/lessonops:main` from Kevin's fork branch when that is
  the active LessonOps workflow, sync the PR body into `docs/pr/`, and use
  `gh pr create` or `gh pr view` when available.

External guidance to encode:
- GitHub Docs frames PRs as the collaboration surface for proposing, reviewing,
  discussing, checking, and merging changes. The skill should treat the PR body
  as the reviewer's central context hub, not as decorative copy.
- Google Engineering Practices recommends small, focused CLs that include
  related tests and enough context for reviewers to understand the change. The
  skill should call out large scope, unrelated churn, missing tests, or rollback
  complexity when the diff suggests those risks.
- Minware recommends compact, predictable template sections covering context,
  summary, test evidence, screenshots when relevant, risk, rollback, and
  optional repo-specific risk areas. The skill should use a stable core template
  and mark non-applicable sections honestly.
- The Pragmatic Engineer emphasizes clear titles, the "why" behind the change,
  and visual support for client-side work. The skill should produce titles that
  help reviewers triage and should request screenshots or live links for UI
  changes when they are absent.
- DeployHQ recommends giving AI the branch log, diff stat, and full diff when
  needed, then editing out verbosity and adding the environment-specific facts
  AI cannot know. The skill should inspect `git log`, `git diff --stat`, and
  selected diffs, then keep the final PR specific rather than inflated.
- The arXiv paper "The Value of Effective Pull Request Description" reports
  that developers value purpose and code explanations, and that stating the
  desired feedback type is associated with acceptance and reviewer engagement.
  The skill should always include purpose, code-change explanation, and reviewer
  focus.

Output behavior when the skill is used:
1. Show the final PR title.
2. Show the final PR body in Markdown.
3. If a `docs/pr/` file was created or updated, show the path.
4. If a GitHub PR was created or edited, show the PR URL.
5. List the exact evidence inspected: base branch, merge base, commit range,
   changed-file summary, docs reviewed, and verification output reviewed.
6. Explicitly list anything important that was not run, not checked, or not
   available.

Implementation expectations:
- Inspect any existing `open-pr` skill before rewriting it.
- Preserve good existing content, but remove vague or duplicative guidance.
- Prefer concise, imperative instructions another Codex instance can follow
  without guessing.
- Keep LessonOps-specific details conditional so the skill remains reusable in
  other repositories.
- Validate with the local skill-validation flow if one exists.
- At minimum, verify:
  - the exact skill name `open-pr` appears in frontmatter
  - the skill requires branch-vs-base inspection with `git merge-base`
  - the skill requires `git log` and `git diff --stat` for the merge-base range
  - the skill includes `docs/pr/`, DD/Cindy, backend-required, smoke-test, and
    known-test-gap guidance for LessonOps
  - the skill prohibits invented tests, screenshots, smoke results, and CI
    status
  - the skill cites the six external guidance links above

Output requirements for this skill-creation task:
1. Update or create the full `open-pr` skill contents.
2. Show the final files created or changed.
3. Summarize the final trigger description and PR drafting workflow.
4. Summarize how LessonOps conventions are encoded.
5. Show the exact validation commands that were run.
6. Mention any assumptions made, especially if you had to infer the local skill
   install path or metadata format.
7. Suggest a concise Conventional Commit message.
```
