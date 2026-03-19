# ExecPlan: Add Standard Attribution-Friendly License

## Checklist

- [x] Inspect the current repo-level licensing state and README structure.
- [x] Add a top-level standard `LICENSE` file that allows unrestricted use with preserved attribution notice.
- [x] Add a matching license section to `README.md`.
- [x] Verify the new license text and README placement, then record review notes.

## Assumptions

- The requested license should cover the repository as a whole except where a file or subdirectory already has its own license notice.
- MIT is the closest standard software license to the request to allow broad reuse while preserving attribution through the retained copyright and license notice.
- The README should reference the top-level `LICENSE` file and summarize the MIT notice-retention requirement in plain language.

## Review Notes

- Replaced the custom license wording with the standard MIT license text so the
  repository now uses a widely recognized, machine-detectable license.
- Added a short `README.md` license section that points readers to the
  top-level license file and summarizes the MIT notice-retention requirement in
  plain language.
- Verified the new files and edits with:
  - `sed -n '1,220p' LICENSE`
  - `rg -n "^## License|This repository is licensed under the \\[MIT License\\]|copies or substantial portions" README.md`
  - `sed -n '240,290p' README.md`
  - `git diff --check -- README.md LICENSE plans/add-attribution-license.md`
