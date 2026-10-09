---
name: fix-tests
description: Run the project's test suite, fix failures, and report what was wrong and what you changed.
user-invocable: true
disable-model-invocation: true
---

Run the project's tests, fix failures, and report.

## Steps

1. Detect the test command. Try in this order until one produces output:
   - `npm test`
   - `cargo test`
   - `go test ./...`
   - `uv run pytest`
   - `pytest`
   - check `package.json` / `Makefile` for a `test` target
2. Run it and capture the failures.
3. Read the failing tests to understand expected behavior. If the expected behavior is unclear, **stop and ask the human** what should be tested and what the expected behavior is. Don't guess.
4. Fix the failing tests (or the code under test if the test is right).
5. Re-run the tests to verify green.
6. Report what was wrong and what you changed. Cite file:line.

## Hard rules

- Before writing new tests, ask the human what they want tested. Don't auto-generate test suites.
- Don't refactor files outside the failing test scope.
- Don't touch CI/CD configs.
- If you can't fix a test after 2 attempts, stop and report the blocker.