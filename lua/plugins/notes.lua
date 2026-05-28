return {
  -- Luarocks (required by Neorg)
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    lazy = false,
    config = true,
  },

  -- Obsidian
  {
    "epwalsh/obsidian.nvim",
    lazy = false,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },

    config = function()
      require("obsidian").setup({
        workspaces = {
          { name = "main", path = "~/vault" },
          { name = "apprenticeship", path = "~/vault/apprenticeship/" },
          { name = "personal", path = "~/vault/personal" },
          { name = "wiki", path = "~/vault/wiki" },
          { name = "learning", path = "~/vault/wiki/Learning"},
        },
        completion = {
          nvim_cmp = true,
        },

         follow_url_func = function(url)
          vim.fn.jobstart({ "xdg-open", url }, {
            detach = true,
          })
        end,


        note_id_func = function(title)
          if title ~= nil then
            return title
              :gsub(" ", "-")
              :gsub("[^A-Za-z0-9-]", "")
              :lower()
          else
            return tostring(os.time())
          end
        end,

        note_frontmatter_func = function(note)
          local out = {
            id = note.title,
            aliases = note.aliases,
            tags = note.tags,
          }

          return out
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.conceallevel = 2
          vim.opt_local.concealcursor = "nc"

        -- Enable Spell Check 
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_gb"
        end,
      })
       -- Open URL 
      -- Obsidian Key Mapping 
      vim.keymap.set("n", "<leader>of", "<cmd>ObsidianFollowLink<CR>")
      vim.keymap.set("n", "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>")
      vim.keymap.set("n", "<leader>ob", "<cmd>ObsidianBacklinks<CR>")
      vim.keymap.set("n", "<leader>on", "<cmd>ObsidianNew<CR>")
      vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<CR>")
      vim.keymap.set("n", "<leader>ow", "<cmd>ObsidianWorkspace<CR>")

      vim.keymap.set("n", "<leader>oh", function()
        local workspace = require("obsidian").get_client().dir.filename
      vim.cmd("edit " .. workspace .. "/index.md")
end)
    end,
  },
}
