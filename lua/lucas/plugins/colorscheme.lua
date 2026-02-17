return { 
    "rose-pine/neovim", 
    name = "rose-pine",
    config = function()
        color = color or "rose-pine"
        vim.cmd.colorscheme(color)

        vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })
    end,
}
