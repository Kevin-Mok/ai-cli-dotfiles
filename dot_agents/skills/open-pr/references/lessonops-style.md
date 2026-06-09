# LessonOps PR Style

Use this reference only when working in `/home/kevin/coding/lesson-ops`, a
repository whose remote is `admintriwayeducation/lessonops`, or a request that
mentions LessonOps, DD/Dongdong, Cindy, local backend review, Gauss/CEMC,
approved worksheets, Google student progress, or LessonOps `docs/pr/` handoff
docs.

## Required LessonOps Conventions

- Create or update a PR doc under `docs/pr/` unless the user explicitly says
  not to.
- Keep the `docs/pr/` body in sync with the GitHub PR body.
- For DD review, include a focused `Reviewer Focus / What To Look For` section.
- For Cindy-facing work, describe the product walkthrough in plain language.
  Do not make raw JSON, code, or terminal output the main demo.
- If the flow requires the local backend, say so clearly. If Cindy is expected
  to review and there is no live backend, say she needs DD or Kevin to show the
  flow locally because she reviews live Vercel sites and does not run code.
- Preserve known test gaps, fixture failures, backend limitations, local-only
  auth/demo status, and content accuracy caveats. Do not smooth them out.
- If the user asks to send work "to DD" or "to dd", prepare the PR against
  `admintriwayeducation/lessonops:main` from Kevin's fork branch when that is
  the active LessonOps workflow, sync the PR body into `docs/pr/`, and use
  `gh pr create` or `gh pr view` when available.

## Recent PR Style Signals

- PR #13, "Recover local Google student progress smoke path": strong recovery
  narrative, command evidence, known broader-suite failures, local Google smoke
  notes, and rollback.
  Source: <https://github.com/admintriwayeducation/lessonops/pull/13>
- PR #12, "Add student demo Google progress flow": why the branch is separate,
  what changed, validation, demo credentials, manual smoke, and Firebase/DD
  follow-up.
  Source: <https://github.com/admintriwayeducation/lessonops/pull/12>
- PR #9, "Connect approved worksheets FE/BE": product-flow narrative, FE/BE
  boundary review focus, Docker Compose smoke, Cindy-local-demo guidance, and
  rollback.
  Source: <https://github.com/admintriwayeducation/lessonops/pull/9>
- PR #8, "Add static Gauss 7/8 worksheet bundle": live site, content caveat,
  scope note, verification, manual UI checks, and rollback.
  Source: <https://github.com/admintriwayeducation/lessonops/pull/8>
- PR #6, "Add CEMC Gauss 8 scraper and tracked source JSON": concise summary,
  concrete scrape output numbers, next steps, verification commands, and
  quick-glance JSON review.
  Source: <https://github.com/admintriwayeducation/lessonops/pull/6>

## LessonOps Drafting Bias

- Lead with why the branch exists and who can evaluate it.
- Include exact smoke commands and URLs when known.
- State whether Docker Compose, Firebase, local auth, Google demo accounts, or
  local backend services are required.
- Keep DD/Cindy handoff notes practical and visible.
- Put product review questions before low-level implementation detail when the
  reviewer is not expected to run code.
