# ExecPlan: Show Stack Traces In `leetcode-init` Runtime Errors

## Checklist

- [x] Inspect the generated LeetCode harness and identify how runtime exceptions are currently surfaced.
- [x] Add targeted tests that define the expected traceback output, including line-number-bearing stack frames.
- [x] Update the generated harness to preserve and print traceback details for runtime failures.
- [x] Update the skill instructions to mention traceback output.
- [x] Run focused verification, refresh installed config, and review the final diff.

## Assumptions

- The requested behavior applies to the generated local example runner from `leetcode-init`, not to unrelated skills.
- A full Python traceback with `Traceback (most recent call last):` and `line N` frame output is more useful than the current collapsed `<exception: ...>` placeholder.
- The scaffold should still keep `NotImplementedError` handling separate so an unimplemented stub stays readable.

## Review Notes

- Added traceback capture to the generated `run_case()` path so example mode keeps printing diffs while also surfacing the full Python traceback.
- Updated generated unittest failures to include the traceback text instead of only the collapsed exception label.
- Added focused regression coverage for both direct example execution and `--test` mode so line-number-bearing frames remain covered.
- Fixed the generated scaffold imports to include `sys` for the existing `unittest.main(argv=[sys.argv[0]])` path.
- Verified the tracked skill source, tests, and installed `~/.agents` copy after rerunning `refresh-config`.
