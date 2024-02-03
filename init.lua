require("lazy-setup")
require("general")

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
require('onedark').setup {
    style = 'darker'
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

vim.api.nvim_create_user_command('RunPythonFile', RunPythonCurrentFile, {})

vim.api.nvim_set_keymap('n', '<leader>rp', ':RunPythonFile<CR>', { noremap = true, silent = true })


--  IDEA: Keep a file, that contains mappings of {file: run configuration}, which is loaded in memory on startup,
--  then there's a menu to edit this configuration (written back to file as well) and a shortcut (like leader-r)
--  that opens a terminal and runs the file with the configuration from the file


vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })
