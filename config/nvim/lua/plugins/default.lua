return {
  -- install catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    flavour = "mocha",
    optional = true,
    opts = {
      transparent_background = false,
      transparent = false,
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
      transparent = false,
      transparent_background = false,
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
        transparency = false,
        italic = false,
      },
    },
  },

  -- monokai family, all ship snacks highlights
  {
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    opts = {
      dark_style_background = "default",
      hl_styles = {
        comments = { italic = false },
        keywords = { italic = false },
      },
      -- default #4b4b4b line numbers vanish behind kitty's opacity/blur
      on_highlights = function(hl)
        hl.LineNr = { fg = "#767676" }
        hl.LineNrAbove = { fg = "#767676" }
        hl.LineNrBelow = { fg = "#767676" }
      end,
    },
  },

  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    opts = {
      filter = "pro", -- classic | octagon | machine | ristretto | spectrum
      styles = {
        comment = { italic = false },
        keyword = { italic = false },
      },
    },
  },

  {
    "sainnhe/sonokai",
    lazy = false,
    init = function()
      vim.g.sonokai_style = "default" -- atlantis | andromeda | shusia | maia | espresso
      vim.g.sonokai_disable_italic_comment = 1
      vim.g.sonokai_better_performance = 1
    end,
  },

  {
    url = "https://codeberg.org/navahas/sanzo.nvim",
    name = "sanzo",
    lazy = false,
    priority = 1000,
  },

  -- Configure LazyVim to load the preferred theme
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "tokyonight",
      -- colorscheme = "catppuccin",
      -- colorscheme = "rose-pine",
      colorscheme = "sanzo",
    },
  },
}
