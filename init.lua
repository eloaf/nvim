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
