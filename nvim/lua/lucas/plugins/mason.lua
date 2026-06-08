return {
    {
      "mason-org/mason-lspconfig.nvim",
      dependencies = { 
        {
            "mason-org/mason.nvim",
            opts = {}
        },
        "neovim/nvim-lspconfig"
      },
      opts = {
          ensure_installed = {
            "gopls",
            "lua_ls"
          },
      },
    },
}
