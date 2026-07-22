import { tool } from "@opencode-ai/plugin"
import { execSync } from "child_process"
import { mkdirSync, cpSync, existsSync, rmSync } from "fs"
import { join, basename } from "path"

export default tool({
  description: "Save or restore a snapshot of current file state before making risky edits. Save copies files to a temp dir. Restore brings them back. Useful before a worker starts editing - if it messes up, one call restores.",
  args: {
    action: tool.schema.enum(["save", "restore", "list", "clear"]).describe("'save' to snapshot files, 'restore' to bring them back, 'list' to see snapshots, 'clear' to delete all snapshots"),
    files: tool.schema.array(tool.schema.string()).optional().describe("Files to snapshot (for 'save'). If omitted, snapshots all tracked git files."),
    label: tool.schema.string().optional().describe("Label for the snapshot (default: timestamp)"),
  },
  async execute(args, ctx) {
    const snapDir = join(ctx.directory, ".opencode-snapshots")
    try {
      if (args.action === "clear") {
        if (existsSync(snapDir)) rmSync(snapDir, { recursive: true })
        return "All snapshots cleared."
      }

      if (args.action === "list") {
        if (!existsSync(snapDir)) return "No snapshots."
        const dirs = execSync(`ls -1 "${snapDir}"`, { encoding: "utf-8" }).trim()
        return dirs || "No snapshots."
      }

      if (args.action === "save") {
        const label = args.label || new Date().toISOString().replace(/[:.]/g, "-")
        const dest = join(snapDir, label)
        mkdirSync(dest, { recursive: true })

        let filesToSave: string[]
        if (args.files && args.files.length > 0) {
          filesToSave = args.files
        } else {
          filesToSave = execSync("git ls-files", { encoding: "utf-8", cwd: ctx.directory }).trim().split("\n").filter(Boolean)
        }

        for (const f of filesToSave) {
          const src = join(ctx.directory, f)
          if (existsSync(src)) {
            const fileDest = join(dest, f)
            mkdirSync(join(fileDest, ".."), { recursive: true })
            cpSync(src, fileDest)
          }
        }
        return `Saved snapshot '${label}' with ${filesToSave.length} files.`
      }

      if (args.action === "restore") {
        if (!args.label) return "Must specify a label to restore."
        const src = join(snapDir, args.label)
        if (!existsSync(src)) return `Snapshot '${args.label}' not found.`

        execSync(`cp -r "${src}/." "${ctx.directory}/"`, { encoding: "utf-8" })
        return `Restored snapshot '${args.label}'.`
      }

      return "Unknown action."
    } catch (e: any) {
      return `snapshot failed: ${e.message || e}`
    }
  },
})