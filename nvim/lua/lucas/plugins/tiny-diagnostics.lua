return {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    config = function()
        require("tiny-inline-diagnostic").setup({
            options = {
                show_all_diags_on_cursorline = true,   -- show diagnostics for entire line
                show_diags_only_under_cursor = false,  -- allow display even if cursor not on exact column
                multilines = {
                  enabled = true,
                  always_show = true,                  -- show multiline diagnostics even when not on line
                },
              },
        })
        vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
    end,
}
