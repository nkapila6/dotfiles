-- folke/sidekick.nvim: Copilot NES + AI CLI integration
-- Copilot LSP is already configured via LazyVim's ai.copilot extra.
-- opencode is detected automatically from $PATH.
return {
  {
    "folke/sidekick.nvim",
    opts = {},
    keys = {
      {
        "<tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<C-.>",
        function() require("sidekick.cli").focus() end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        desc = "Select CLI",
      },
      {
        "<leader>ao",
        function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
        desc = "Sidekick Toggle opencode",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },
}