import { tool } from "@opencode-ai/plugin"
import { execSync } from "child_process"

function appleEscape(s: string): string {
  return s.replace(/\\/g, "\\\\").replace(/"/g, '\\"')
}

export default tool({
  description: "Schedule persistent reminders via macOS Reminders.app. Fires native OS notifications at the scheduled time, survives restarts, no background process. Reminders appear in the Reminders app under an 'opencode' list. Boss only.",
  args: {
    action: tool.schema.enum(["add", "list", "clear"]).describe("'add' to create a reminder, 'list' to see opencode reminders, 'clear' to delete the list"),
    message: tool.schema.string().optional().describe("The reminder text (for 'add')"),
    inMinutes: tool.schema.number().optional().describe("Minutes from now to fire (for 'add'). Simpler than absolute time."),
    fireAt: tool.schema.string().optional().describe("Absolute time, ISO 8601 like '2026-07-13T09:00:00'. Alternative to inMinutes."),
    list: tool.schema.string().optional().describe("Reminders.app list name (default: 'opencode')"),
  },
  async execute(args) {
    try {
      if (args.action === "add") {
        if (!args.message) return "Need a message."
        if (!args.inMinutes && !args.fireAt) return "Need either inMinutes or fireAt."

        let minutesFromNow: number
        if (args.inMinutes) {
          minutesFromNow = args.inMinutes
        } else {
          const date = new Date(args.fireAt!)
          if (isNaN(date.getTime())) return `Could not parse date: ${args.fireAt}`
          minutesFromNow = Math.round((date.getTime() - Date.now()) / 60000)
          if (minutesFromNow < 0) return "That time is in the past."
        }

        const seconds = Math.round(minutesFromNow * 60)
        const listName = appleEscape(args.list || "opencode")
        const msg = appleEscape(args.message)

        const script = `
set fireDate to current date
set time of fireDate to (time of fireDate) + ${seconds}
tell application "Reminders"
    if not (exists list "${listName}") then
        make new list with properties {name:"${listName}"}
    end if
    tell list "${listName}"
        make new reminder with properties {name:"${msg}", due date:fireDate, remind me date:fireDate}
    end tell
end tell`

        execSync(`osascript -e '${script.replace(/'/g, "'\\''")}'`, { encoding: "utf-8", timeout: 10000 })
        const fireTime = new Date(Date.now() + seconds * 1000).toLocaleString()
        return `Reminder added to Reminders.app list "${listName}", fires at ${fireTime}.`
      }

      if (args.action === "list") {
        const listName = appleEscape(args.list || "opencode")
        const script = `
tell application "Reminders"
    if not (exists list "${listName}") then
        return "No opencode reminders yet."
    end if
    set output to ""
    tell list "${listName}"
        set rs to (every reminder whose completed is false)
        repeat with r in rs
            set output to output & (name of r) & " | due: " & (due date of r) & linefeed
        end repeat
    end tell
    return output
end tell`
        const result = execSync(`osascript -e '${script.replace(/'/g, "'\\''")}'`, { encoding: "utf-8", timeout: 10000 }).trim()
        return result || "No pending reminders."
      }

      if (args.action === "clear") {
        const listName = appleEscape(args.list || "opencode")
        const script = `
tell application "Reminders"
    if (exists list "${listName}") then
        delete list "${listName}"
        return "Cleared."
    end if
    return "Nothing to clear."
end tell`
        const result = execSync(`osascript -e '${script.replace(/'/g, "'\\''")}'`, { encoding: "utf-8", timeout: 10000 }).trim()
        return result
      }

      return "Unknown action."
    } catch (e: any) {
      return `reminder failed: ${e.message || e}`
    }
  },
})