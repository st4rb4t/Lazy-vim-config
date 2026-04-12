return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      require("mason").setup()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "powershell_es",
          "pyright",
          "bashls",
          "gopls",
          "terraformls",
          "ansiblels",
          "yamlls",
          "lua_ls",
        },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        "powershell_es",
        "pyright",
        "bashls",
        "gopls",
        "terraformls",
        "ansiblels",
        "yamlls",
        "lua_ls",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
        vim.lsp.enable(server)
      end
    end,
  },
}
