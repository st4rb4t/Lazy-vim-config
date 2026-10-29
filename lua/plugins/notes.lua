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
          { name = "homelab-kb", path = "~/git/homelab-kb" },
        },
        completion = {
          nvim_cmp = true,
        },
        templates = {
          subdir = "templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
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
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_gb"
        end,
      })

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

      -- ===== Homelab KB =====

      local KB_ROOT = vim.fn.expand("~/git/homelab-kb")

      local function in_kb_workspace()
        local ws = require("obsidian").get_client().current_workspace.name
        return ws == "homelab-kb"
      end

      local function slugify(s)
        return s:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
      end

      local function next_kb_id(prefix, subdir)
        local dir = KB_ROOT .. "/" .. subdir
        local scan = vim.fn.systemlist(
          ("rg -o '%s-[0-9]+' %s --no-filename 2>/dev/null"):format(prefix, dir)
        )
        local max = 0
        for _, line in ipairs(scan) do
          local n = tonumber(line:match("%d+"))
          if n and n > max then max = n end
        end
        return string.format("%s-%04d", prefix, max + 1)
      end

      -- ID-based: TroubleshootingNew, RunbookNew, IncidentNew
      -- usage: :RunbookNew traefik 502 after deploy
      local function kb_new_id(prefix, subdir, template)
        return function(opts)
          if not in_kb_workspace() then
            vim.notify("Not in homelab-kb workspace — aborting (:ObsidianWorkspace homelab-kb)", vim.log.levels.WARN)
            return
          end
          if opts.args == "" then
            vim.notify("Usage: :" .. template:gsub("^%l", string.upper) .. "New <short description>", vim.log.levels.WARN)
            return
          end
          local id = next_kb_id(prefix, subdir)
          local slug = slugify(opts.args)
          local fname = subdir .. "/" .. id .. "-" .. slug
          vim.cmd("ObsidianNew " .. fname)
          vim.cmd("ObsidianTemplate " .. template)
        end
      end

      vim.api.nvim_create_user_command("TroubleshootingNew", kb_new_id("TS", "troubleshooting", "troubleshooting"), { nargs = "+" })
      vim.api.nvim_create_user_command("RunbookNew", kb_new_id("RB", "runbooks", "runbook"), { nargs = "+" })
      vim.api.nvim_create_user_command("IncidentNew", kb_new_id("INC", "incidents", "incident"), { nargs = "+" })

      -- Name-based: ServiceNew, InfraNew, ReferenceNew, CheatsheetNew
      -- usage: :ServiceNew traefik
      local function kb_new_named(subdir, template)
        return function(opts)
          if not in_kb_workspace() then
            vim.notify("Not in homelab-kb workspace — aborting (:ObsidianWorkspace homelab-kb)", vim.log.levels.WARN)
            return
          end
          if opts.args == "" then
            vim.notify("Usage: :" .. template:gsub("^%l", string.upper) .. "New <name>", vim.log.levels.WARN)
            return
          end
          local slug = slugify(opts.args)
          vim.cmd("ObsidianNew " .. subdir .. "/" .. slug)
          vim.cmd("ObsidianTemplate " .. template)
        end
      end

      vim.api.nvim_create_user_command("ServiceNew", kb_new_named("services", "service"), { nargs = 1 })
      vim.api.nvim_create_user_command("InfraNew", kb_new_named("infrastructure", "infrastructure"), { nargs = 1 })
      vim.api.nvim_create_user_command("ReferenceNew", kb_new_named("references", "reference"), { nargs = 1 })
      vim.api.nvim_create_user_command("CheatsheetNew", kb_new_named("cheatsheets", "cheatsheet"), { nargs = 1 })
      vim.api.nvim_create_user_command("PlanningNew", kb_new_named("planning", "planning"), { nargs = 1 })
      vim.api.nvim_create_user_command("DecisionNew", kb_new_named("decisions", "decision"), { nargs = 1 })

      -- Promote a troubleshooting entry to a confirmed runbook
      vim.api.nvim_create_user_command("PromoteToRunbook", function()
        if not in_kb_workspace() then
          vim.notify("Not in homelab-kb workspace — aborting", vim.log.levels.WARN)
          return
        end
        local src = vim.api.nvim_buf_get_name(0)
        local fname = vim.fn.fnamemodify(src, ":t:r") -- TS-0014-traefik-502-after-deploy
        local slug = fname:gsub("^TS%-%d+%-", "")
        local rb_id = next_kb_id("RB", "runbooks")
        local dest = KB_ROOT .. "/runbooks/" .. rb_id .. "-" .. slug .. ".md"

        vim.fn.system({ "cp", src, dest })
        vim.fn.system({
          "sed", "-i",
          "-e", "s/^status:.*/status: promoted/",
          "-e", "s/^promoted_to:.*/promoted_to: " .. rb_id .. "/",
          src,
        })
        vim.cmd("edit " .. dest)
        vim.notify("Promoted to " .. rb_id .. " — update id/title in frontmatter", vim.log.levels.INFO)
      end, {})
    end,
  },
}
