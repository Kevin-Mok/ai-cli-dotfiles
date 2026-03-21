# ExecPlan: Refactor README For Brevity And Recruiter Impact

## Checklist

- [x] Capture the pre-existing worktree state before editing repo-tracked files.
- [x] Review the current `README.md`, README contract, and existing README-related guidance before rewriting.
- [x] Replace the long table-of-contents-heavy structure with a shorter root README built around install, usage, command reference, stack rationale, standout positioning, a short repo tour, and license.
- [x] Remove repeated sections that re-explained the same AI workflow story in different words.
- [x] Keep the strongest recruiter and freelance-client value signals while trimming repo-tour detail.
- [x] Correct the initial over-compression by restoring medium-detail proof points and moving the recruiter/client selling angle ahead of the install docs.
- [x] Keep the command reference truthful by re-checking the documented CLI flags against local help.
- [x] Remove the duplicate `License` heading and reduce link clutter to representative repo evidence.
- [x] Verify line count, section structure, duplicate-heading removal, and changed-file scope.

## Assumptions

- The existing hero image still helps the README communicate the workflow quickly and should stay.
- A balanced recruiter/client pitch is preferred over a purely technical or purely sales-driven README.
- The README should lead with selling value for recruiters and clients before dropping into setup mechanics.
- The root README should keep a short non-AI repo tour, but detailed subsystem inventory belongs outside the main story.
- Inline relative links are acceptable for GitHub readability and are shorter than the previous footnote-heavy style.

## Review Notes

- Reframed the README around the repo's public operating surface instead of a long internal component tour.
- Collapsed overlapping sections such as workflow explanation, Graphiti detail, reproducibility, and recruiter positioning into a single stronger "Why This Repo Stands Out" section.
- Kept the required README contract coverage: bootstrap, day-to-day use, documented command flags, repo-grounded tech stack, and explicit recruiter-facing value.
- Reduced the repo tour to three high-signal categories so the broader dotfiles surface still reads as substantial without dominating the document.
- Removed the table of contents and duplicate license section because the shorter README no longer needs them.
- Switched from a long footnote block to inline relative links for cleaner scanning and lower maintenance.
- After user feedback that the first rewrite cut too much, restored a stronger selling-first section with medium-detail proof around the operating layer, skill categories, and four-Codex workflow.
- Added concrete install pointers for `chezmoi` and Codex CLI, and clarified that Graphiti is an optional repo-specific setup with additional prerequisites rather than part of the base bootstrap path.

## Verification

- `chezmoi diff --help`
- `chezmoi apply --help`
- `codex --help`
- `codex mcp list --help`
- `wc -l README.md`
- `rg -n '^## ' README.md`
- `rg -n '^## License$' README.md`
- `rg -n 'Table of Contents' README.md`
- `git diff -- README.md plans/readme-brevity-refactor.md`
- `git status --short README.md plans/readme-brevity-refactor.md`
