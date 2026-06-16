return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'rose-pine/neovim' },

    config = function()
        local colors = {
            base    = '#191724', -- rose-pine base
            surface = '#1f1d2e',
            overlay = '#26233a',
            muted   = '#6e6a86',
            subtle  = '#908caa',
            text    = '#e0def4',
            love    = '#eb6f92',
            gold    = '#f6c177',
            rose    = '#ebbcba',
            pine    = '#31748f',
            foam    = '#9ccfd8',
            iris    = '#c4a7e7',
        }

        local bubbles_theme = {
            normal = {
                a = { fg = colors.base, bg = colors.foam },
                b = { fg = colors.text, bg = colors.surface },
                c = { fg = colors.text },
            },
            insert = {
                a = { fg = colors.base, bg = colors.pine },
                b = { fg = colors.text },
                c = { fg = colors.text },
            },
            visual = {
                a = { fg = colors.base, bg = colors.iris },
                b = { fg = colors.text },
                c = { fg = colors.text },
            },
            replace = {
                a = { fg = colors.base, bg = colors.love },
                b = { fg = colors.text },
                c = { fg = colors.text },
            },
            command = {
                a = { fg = colors.base, bg = colors.gold },
                b = { fg = colors.text },
                c = { fg = colors.text },
            },
            inactive = {
                a = { fg = colors.muted },
                b = { fg = colors.muted },
                c = { fg = colors.muted },
            },
        }

        require('lualine').setup {
            options = {
                theme = bubbles_theme,
                component_separators = '',
                section_separators = { left = '', right = '' },
            },
            sections = {
                lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
                lualine_b = { 'filename', 'branch' },
                lualine_c = {
                    '%=', --[[ add your center components here in place of this comment ]]
                },
                lualine_x = {},
                lualine_y = { 'filetype', 'progress' },
                lualine_z = {
                    { 'location', separator = { right = '' }, left_padding = 2 }, },
            },
            inactive_sections = {
                lualine_a = { 'filename' },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = { 'location' },
            },
            tabline = {},
            extensions = {},
        }
        vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
    end,
}
