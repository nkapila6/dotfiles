import { tool } from "@opencode-ai/plugin"
import { execSync } from "child_process"

export default tool({
  description: "Get git blame context for a specific file and line number. Returns who changed it, when, the commit hash, and the commit message. Faster than running git blame + git show separately.",
  args: {
    file: tool.schema.string().describe("File path (relative to project root)"),
    line: tool.schema.number().describe("Line number to blame"),
    context: tool.schema.number().optional().describe("Lines of context around the blamed line to show (default 3)"),
  },
  async execute(args, ctx) {
    try {
      const ctxLines = args.context ?? 3
      const blame = execSync(
        `git blame -L ${args.line},${args.line} --porcelain "${args.file}"`,
        { encoding: "utf-8", cwd: ctx.directory, timeout: 10000 },
      )
      const hash = blame.split("\n")[0].split(" ")[0]
      const author = blame.match(/^author (.+)$/m)?.[1] || "unknown"
      const date = blame.match(/^author-time (.+)$/m)?.[1]
      const dateStr = date ? new Date(parseInt(date) * 1000).toISOString().split("T")[0] : "unknown"

      const commitMsg = execSync(`git log -1 --format=%s ${hash}`, {
        encoding: "utf-8",
        cwd: ctx.directory,
        timeout: 10000,
      }).trim()

      const start = Math.max(1, args.line - ctxLines)
      const end = args.line + ctxLines
      const code = execSync(
        `git blame -L ${start},${end} -- "${args.file}"`,
        { encoding: "utf-8", cwd: ctx.directory, timeout: 10000 },
      )

      return `Commit: ${hash}\nAuthor: ${author}\nDate: ${dateStr}\nMessage: ${commitMsg}\n\nCode (${start}-${end}):\n${code}`
    } catch (e: any) {
      return `git-blame-context failed: ${e.message || e}`
    }
  },
})