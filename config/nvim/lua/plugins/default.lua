return {
  -- install catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    flavour = "mocha",
    optional = true,
    opts = {
      transparent_background = true,
      transparent = true,
      no_italic = true,
      integrations = {
        aerial = true,
        alpha = true,
        blink_cmp = true,
        cmp = true,
        dashboard = true,
        flash = true,
        fzf = true,
        gitsigns = true,
        grug_far = true,
        headlines = true,
        harpoon = true,
        illuminate = true,
        indent_blankline = { enabled = false },
        leap = true,
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        semantic_tokens = true,
        snacks = true,
        symbols_outline = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      transparent = true,
      transparent_background = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
    },
  },

  {
    "rose-pine/neovim",
    name = "rose-pine",
    opts = {
      variant = "moon",
      styles = {
        transparency = true,
        italic = false,
      },
    },
  },

  -- Configure LazyVim to load the preferred theme
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "tokyonight",
      -- colorscheme = "catppuccin",
      colorscheme = "rose-pine",
    },
  },
}
