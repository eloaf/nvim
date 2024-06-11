require("lazy-setup")
require("general")

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- setup with some options
require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 40,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})

-- Telescope insert mode bug
-- TODO actually you're supposed to quit with ctrl + something...
-- https://github.com/nvim-telescope/telescope.nvim/issues/2027
vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
        end
    end,
})

-- vim.cmd("colorscheme nightfly")
-- { 'dasupradyumna/midnight.nvim', lazy = false, priority = 1000 }
require('onedark').setup {
    style = 'darker',
    transparent = true
}
require('onedark').load()

-- Jump to last edit position on opening file
-- https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjnmjca/?utm_source=share&utm_medium=web2x&context=3
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

function RunPythonCurrentFile()
    local current_file = vim.fn.expand('%')
    vim.cmd('split | terminal python ' .. current_file)
end

function RunPytestCurrentFile()
    local current_file = vim.fn.expand('%')
    -- % pytest --cov=df_api --cov-report term-missing libs/df-api/tests
    vim.cmd('split | terminal pytest -s --cov=df_api --cov-report term-missing ' .. current_file)
end

vim.api.nvim_create_user_command('RunPythonFile', RunPythonCurrentFile, {})
vim.api.nvim_set_keymap('n', '<leader>rp', ':RunPythonFile<CR>', { noremap = true, silent = true })


vim.api.nvim_create_user_command('RunPytestFile', RunPytestCurrentFile, {})
vim.api.nvim_set_keymap('n', '<leader>rt', ':RunPytestFile<CR>', { noremap = true, silent = true })


--  IDEA: Keep a file, that contains mappings of {file: run configuration}, which is loaded in memory on startup,
--  then there's a menu to edit this configuration (written back to file as well) and a shortcut (like leader-r)
--  that opens a terminal and runs the file with the configuration from the file

vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })

-- No arrows in normal mode to force using hjkl
vim.keymap.set('n', '<Up>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<Down>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<Left>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<Right>', '<Nop>', { noremap = true })

-- make the cursor blink
-- :set guicursor=a:blinkon100
vim.opt.guicursor = 'a:blinkon100'

vim.api.nvim_set_keymap('n', ',', ':set hlsearch!<CR>', { noremap = true, silent = true })

-- check if ~/.config/nvim/snippets/ exists
-- if not, create it

-- Define the source and target directories
-- local source_dir = '~/.local/share/nvim/lazy/friendly-snippets/snippets/'
-- local target_dir = '~/.config/nvim/snippets/'
--
-- if vim.fn.isdirectory(vim.fn.expand(target_dir)) == 0 then
--     vim.fn.mkdir(vim.fn.expand(target_dir), 'p')
-- end
--
-- -- Function to copy files from source to target directory
-- local function copy_files(source, target)
--     -- Iterate over files in the source directory
--     for _, file in ipairs(vim.fn.glob(source .. '/*', true, true)) do
--         -- Get the filename
--         local filename = vim.fn.fnamemodify(file, ':t')
--         -- Check if the file exists in the target directory
--         if vim.fn.filereadable(target .. filename) == 0 then
--             -- If not, copy the file
--             os.execute('cp ' .. file .. ' ' .. target .. filename)
--         end
--     end
-- end

-- -- Iterate over directories in the source directory
-- for _, path in ipairs(vim.fn.glob(source_dir .. '*', true, true)) do
--     if vim.fn.isdirectory(path) == 1 then
--         if vim.fn.isdirectory(target_dir .. path) == 0 then
--             vim.fn.mkdir(target_dir .. path, 'p')
--         end
--
--         -- get the base name
--         local basename = vim.fn.fnamemodify(path, ':t')
--
--         -- iterate over files in the subdir
--         for _, file in ipairs(vim.fn.glob(path .. '/*', true, true)) do
--             -- Get the filename
--             local filename = vim.fn.fnamemodify(file, ':t')
--             -- Check if the file exists in the target directory
--             if vim.fn.filereadable(target_dir .. basename .. "/" .. filename) == 0 then
--                 -- If not, copy the file
--                 os.execute('cp ' .. file .. ' ' .. target_dir .. basename .. "/" .. filename)
--             end
--         end
--     else
--         -- check if the file exists in the target directory
--         local filename = vim.fn.fnamemodify(path, ':t')
--         if vim.fn.filereadable(target_dir .. filename) == 0 then
--             -- If not, copy the file
--             os.execute('cp ' .. path .. ' ' .. target_dir .. filename)
--         end
--     end
-- end

vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Open file at the last position it was edited earlier',
    group = misc_augroup,
    pattern = '*',
    command = 'silent! normal! g`"zv'
})
