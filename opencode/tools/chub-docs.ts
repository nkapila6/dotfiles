import { tool } from "@opencode-ai/plugin"
import { execSync } from "child_process"

export default tool({
  description: "Fetch curated API documentation from Context Hub (chub). Use when you need accurate, current docs for a library or API instead of guessing. Search with a query, or get a specific doc by ID with an optional language.",
  args: {
    action: tool.schema.enum(["search", "get"]).describe("'search' to find docs, 'get' to fetch a specific doc by ID"),
    query: tool.schema.string().describe("Search query (for search) or doc ID like 'openai/chat' (for get)"),
    lang: tool.schema.string().optional().describe("Language variant: 'py' or 'js'. Only for 'get'."),
    file: tool.schema.string().optional().describe("Specific reference file within the doc. Only for 'get'."),
  },
  async execute(args) {
    try {
      let cmd: string
      if (args.action === "search") {
        cmd = `chub search "${args.query.replace(/"/g, '\\"')}"`
      } else {
        cmd = `chub get "${args.query.replace(/"/g, '\\"')}"`
        if (args.lang) cmd += ` --lang ${args.lang}`
        if (args.file) cmd += ` --file "${args.file.replace(/"/g, '\\"')}"`
      }
      const result = execSync(cmd, { encoding: "utf-8", timeout: 30000, maxBuffer: 1024 * 1024 })
      return result.slice(0, 8000)
    } catch (e: any) {
      return `chub failed: ${e.message || e}`
    }
  },
})