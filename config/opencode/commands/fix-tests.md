---
description: Run tests, fix failures, show what was wrong
agent: senior-dev
subtask: true
---
Here are the current test results:
!`npm test 2>&1 || true`

If that produced no output, try:
!`cargo test 2>&1 || true`
!`go test ./... 2>&1 || true`
!`uv run pytest 2>&1 || true`

Fix the failing tests. Show me what was wrong and what you changed. Run the tests again after fixing to verify.