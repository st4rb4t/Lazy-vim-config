return {
  -- Luarocks (required by Neorg)
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    lazy = false,
    config = true,
  },

  -- Neorg
  {
    "nvim-neorg/neorg",
    dependencies = {
      "vhyrro/luarocks.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    version = "*",
    config = function()
      require("neorg").setup({
        load = {
          ["core.defaults"] = {},

          ["core.concealer"] = {
            config = {
              icon_preset = "diamond",
              icons = {
                heading = {
                  icons = { "◈", "◇", "◆", "⋄", "❖", "⟡" },
                },
                -- bullet removed, format changed in neorg 9.x
                todo = {
                  done      = { icon = "✓" },
                  pending   = { icon = "◐" },
                  undone    = { icon = "○" },
                  uncertain = { icon = "?" },
                  on_hold   = { icon = "⏸" },
                  cancelled = { icon = "✗" },
                  recurring = { icon = "↺" },
                  urgent    = { icon = "⚠" },
                },
              },
            },
          }, -- ← closes core.concealer

          ["core.dirman"] = {
            config = {
              workspaces = {
                notes    = "~/notes",
                work     = "~/notes/work",
                personal = "~/notes/personal",
              },
              default_workspace = "notes",
              index = "index.norg",
            },
          },

          ["core.qol.toc"] = {},

          ["core.qol.todo_items"] = {},

          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },

          ["core.integrations.treesitter"] = {},

          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
              neorg_leader = "<LocalLeader>",
              hook = function(keybinds)
                keybinds.unmap("norg", "n", "<C-d>")
                keybinds.unmap("norg", "n", "gO")
              end,
            },
          },
        }, -- ← closes load
      }) -- ← closes neorg.setup

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "norg",
        callback = function()
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"
          vim.opt_local.wrap      = true
          vim.opt_local.linebreak = true
          vim.opt_local.spell     = true
        end,
      })
    end,
  }, -- ← closes neorg plugin

  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    lazy = false,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("obsidian").setup({
        workspaces = {
          { name = "vault", path = "~/vault" },
        },
        completion = { nvim_cmp = true },
      })
    end,
  },
}
