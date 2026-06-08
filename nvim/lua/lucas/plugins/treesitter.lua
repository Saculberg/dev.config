return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        local treesitter=require('nvim-treesitter')

        treesitter.setup {
          -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)

            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            autotag = {
                enable = true,
            },
            install_dir = vim.fn.stdpath('data') .. '/site',
            ensure_installed = {
                'rust', 'lua', 'javascript', 'c', 'go', 'c_sharp'
            }
        }
    end,
}

