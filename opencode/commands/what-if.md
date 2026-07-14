---
description: Predict the blast radius of a proposed change. What breaks, what's affected, what to watch out for.
agent: socratic
---
Proposed change: $ARGUMENTS

Before I make this change, help me understand the blast radius:
1. Find every file and function that touches the code I want to change
2. List what would break if I made this change naively
3. List what tests would need updating
4. Identify any hidden coupling (shared state, implicit contracts, timing dependencies)
5. Rate the risk: low / medium / high, and why

Don't make any changes. This is analysis only. End with: "Given this blast radius, how would you sequence the change to minimize risk?"