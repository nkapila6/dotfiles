---
description: "No AI attribution in commits"
condition:
  - "[Cc]o-[Aa]uthored-[Bb]y:"
  - "Generated with \\[?(Claude|omp|opencode)"
---
No Co-authored-by or "Generated with" lines in commits or PRs. Commit messages are a single conventional-commit subject line, lowercase, imperative, no body.
