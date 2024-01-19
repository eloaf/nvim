vim.opt.encoding = "utf8"
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- show line numbers in a pretty way
vim.cmd [[
  set number
  set numberwidth=1
]]
vim.opt.number = true
-- vim.opt.relativenumber = true


-- Etc
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- vim.opt.smartindent = true
vim.opt.smartindent = false

-- vim.opt.wrap = false
vim.opt.wrap = true

-- To get long undo history??
vim.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
-- incremental search
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- vim.cmd.colorscheme("wildcharm")

-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- TODO: https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim
-- shortcut for this!

function Delete_blank_lines_in_visual_selection()
    vim.cmd('\'<,\'>g/^$/d')
end

vim.api.nvim_set_keymap('v', '<leader>dl', '<Cmd>lua Delete_blank_lines_in_visual_selection()<CR>',
    { noremap = true, silent = true })
