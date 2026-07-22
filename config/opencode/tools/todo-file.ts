import { tool } from "@opencode-ai/plugin"
import { readFileSync, writeFileSync, existsSync } from "fs"
import { join } from "path"

export default tool({
  description: "Read or write a .todo file in the project root to persist task state across the session. Survives compaction. Use to track multi-step task progress so context isn't lost.",
  args: {
    action: tool.schema.enum(["read", "write", "append", "clear"]).describe("'read' to get current todos, 'write' to replace all, 'append' to add a line, 'clear' to empty"),
    content: tool.schema.string().optional().describe("The todo content (for write or append). Format: '- [ ] task' or '- [x] done'"),
  },
  async execute(args, context) {
    const todoPath = join(context.directory, ".todo")
    try {
      if (args.action === "read") {
        if (!existsSync(todoPath)) return "No .todo file yet."
        return readFileSync(todoPath, "utf-8")
      }
      if (args.action === "clear") {
        writeFileSync(todoPath, "")
        return "Cleared."
      }
      if (args.action === "write") {
        writeFileSync(todoPath, args.content || "")
        return "Written."
      }
      if (args.action === "append") {
        const existing = existsSync(todoPath) ? readFileSync(todoPath, "utf-8") : ""
        writeFileSync(todoPath, existing + (existing && !existing.endsWith("\n") ? "\n" : "") + (args.content || ""))
        return "Appended."
      }
      return "Unknown action."
    } catch (e: any) {
      return `todo-file failed: ${e.message || e}`
    }
  },
})