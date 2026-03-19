# ExecPlan: Link README License Notice

## Checklist

- [x] Inspect the current repo status, active branch, upstream, and README diff scope.
- [x] Confirm the repository has a root `LICENSE` file for the README to reference.
- [x] Update the README footer so the MIT notice links directly to `LICENSE`.
- [x] Verify the README footer placement and record review notes.

## Assumptions

- This task is limited to documentation and does not require any runtime or code changes.
- The top-level `LICENSE` file is the canonical repository-wide license target for the README.
- Existing file- or subdirectory-specific license notices should remain authoritative for their own material.

## Review Notes

- Added a `README.md` license sentence that links directly to the top-level `LICENSE` file.
- Kept the plain-language summary of MIT reuse terms and the caveat for files or subdirectories that carry their own license notice.
- Verified the change with:
  - `sed -n '1,12p' LICENSE`
  - `nl -ba README.md | tail -n 8`
  - `git diff --check -- README.md plans/readme-license-link.md`
