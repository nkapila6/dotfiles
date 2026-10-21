-- luxtron.net header for the dashboard-nvim extra
return {
  "nvimdev/dashboard-nvim",
  opts = function(_, opts)
    local logo = [[
██╗     ██╗   ██╗██╗  ██╗████████╗██████╗  ██████╗ ███╗   ██╗
██║     ██║   ██║╚██╗██╔╝╚══██╔══╝██╔══██╗██╔═══██╗████╗  ██║
██║     ██║   ██║ ╚███╔╝    ██║   ██████╔╝██║   ██║██╔██╗ ██║
██║     ██║   ██║ ██╔██╗    ██║   ██╔══██╗██║   ██║██║╚██╗██║
███████╗╚██████╔╝██╔╝ ██╗   ██║   ██║  ██║╚██████╔╝██║ ╚████║
╚══════╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                         .net

          ── from components to intelligence ──              ]]

    opts.config.header = vim.split(string.rep("\n", 8) .. logo .. "\n\n", "\n")
  end,
}
