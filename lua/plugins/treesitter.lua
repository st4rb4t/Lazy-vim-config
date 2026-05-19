return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    priority = 500,
    build = ":TSUpdate",
    main = "nvim-treesitter.config",  -- tells lazy exactly where the module is
    opts = {
      ensure_installed = {
        "lua",
        "norg",
        "markdown",
        "markdown_inline",
        "python",
        "bash",
        "vim",
        "vimdoc",
        "org",
      },
      sync_install = false,
      auto_install = true,
      highlight = { enable = true },      
      indent = { enable = true }, 
    },
  },
}
