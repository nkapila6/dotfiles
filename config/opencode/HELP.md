# Custom Commands

### Code
- /trace <feature> - Trace a feature's full call chain, entry point to output
- /whiteboard [area] - Generate a text-based architecture diagram
- /what-if <change> - Predict the blast radius of a proposed change
- /fix-tests - Run tests, fix failures, show what was wrong
- /commit - Stage and commit with conventional commits, no AI attribution

### Review
- /review-changes - Review last 10 git commits for bugs, security, style
- /review-pr <ref> - Review a specific git diff (e.g. HEAD~1 or branch name)

### Workflow
- /yolo <task> - Run a task through yolo-orchestrator with all permissions bypassed
- /btw <question> - Side-note that runs in a subagent, doesn't pollute main context

## Agents (Tab to switch)
- orchestrator - boss-worker delegation (default)
- socratic - guided learning through questions, read-only
- yolo - plain agent, all permissions bypassed
- yolo-orchestrator - boss-worker + all permissions bypassed
- plan - read-only planning (built-in)