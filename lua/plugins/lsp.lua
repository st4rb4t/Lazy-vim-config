return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },

    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({ ensure_installed = { "powershell_es", "pyright", "bashls", "gopls", "terraformls", "ansiblels", "yamlls", "lua_ls" } })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = vim.lsp.config

      lspconfig.powershell_es.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.terraformls.setup({ capabilities = capabilities })
      lspconfig.ansiblels.setup({ capabilities = capabilities })
      lspconfig.yamlls.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({ capabilities = capabilities })
    end,
  },
}
