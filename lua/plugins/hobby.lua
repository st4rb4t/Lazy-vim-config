return {
  -- C/C++ / MicroPython for electronics / embedded
  { "neovim/nvim-lspconfig" }, -- already included in lsp.lua
  { "mfussenegger/nvim-dap", 
  config = function() 
	  require("dap").setup() 
  end 
  }, -- optional debugger
}
