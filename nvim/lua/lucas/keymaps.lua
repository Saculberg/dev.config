vim.g.mapleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("v", "<leader>d", "\"_d")
vim.keymap.set("n", "<leader>d", "\"_d")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")
vim.keymap.set("v", "<leader>y", "\"+y")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Pane splitting (tmux-style)
vim.keymap.set("n", "<leader>%", "<cmd>vsplit<CR>")
vim.keymap.set("n", '<leader>"', "<cmd>split<CR>")

-- Pane closing (tmux-style)
vim.keymap.set("n", "<leader>x", "<cmd>close<CR>")

-- Pane navigation (tmux-style)
vim.keymap.set("n", "<leader><Left>", "<C-w>h")
vim.keymap.set("n", "<leader><Down>", "<C-w>j")
vim.keymap.set("n", "<leader><Up>", "<C-w>k")
vim.keymap.set("n", "<leader><Right>", "<C-w>l")

-- Tab/window management (tmux-style)
vim.keymap.set("n", "<leader>c", "<cmd>tabnew<CR>")
vim.keymap.set("n", "<leader>n", "<cmd>tabnext<CR>")
vim.keymap.set("n", "<leader>&", "<cmd>tabclose<CR>")
for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, i .. "gt")
end

-- Pane resizing (tmux-style)
vim.keymap.set("n", "<leader><M-Left>", "<C-w>2<")
vim.keymap.set("n", "<leader><M-Down>", "<C-w>2-")
vim.keymap.set("n", "<leader><M-Up>", "<C-w>2+")
vim.keymap.set("n", "<leader><M-Right>", "<C-w>2>")


vim.keymap.set('n', '<leader>f', function()
  vim.lsp.buf.format({ async = true })
end, { desc = 'Format buffer (LSP)' })

