import type { Plugin } from "@opencode-ai/plugin"

export default (async ({ client }) => {
  return {
    "experimental.session.compacting": async (input, output) => {
      output.context.push(`Keep: current task description, files being modified, blockers, key decisions. Drop: exploration logs, completed subtask chatter, verbose tool output, intermediate reasoning.`)
    },
  }
}) satisfies Plugin