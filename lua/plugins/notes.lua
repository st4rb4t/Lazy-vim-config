return {
  { "nvim-neorg/neorg",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},
          ["core.norg.dirman"] = { config = { workspaces = { notes = "~/neorg" } } },
          ["core.norg.concealer"] = {},
          ["core.norg.completion"] = { engine = "nvim-cmp" },
        }
      })
    end,
  },
  { "epwalsh/obsidian.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("obsidian").setup({
        dir = "~/vault",
        completion = { nvim_cmp = true },
      })
    end,
  },
}
