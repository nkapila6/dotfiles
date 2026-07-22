---
description: Trace a feature's full call chain from entry point to database/UI. Great for understanding how pieces connect.
agent: socratic
---
Trace the feature: $ARGUMENTS

Walk me through the complete call chain, entry point to final output. At each step:
1. Show the relevant code (file:line)
2. Ask me what I think happens next before showing me
3. Note any branches, edge cases, or side effects

Start with the entry point. Follow every call. Don't skip layers. If the chain splits into multiple paths, trace each one.

End with: "Now you've seen the full chain. What part surprised you?"