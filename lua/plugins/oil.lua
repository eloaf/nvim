return {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require('oil').setup({
            -- See :help oil-columns
            columns = {
                "icon",
                -- "permissions",
                "size",
                -- "mtime",
            },
            view_options = {
                show_hidden = true,
                -- natural_order = true,
            }
        })
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        vim.keymap.set("n", "<leader>o", function()
            vim.cmd("vsplit | wincmd l")
            require("oil").open()
        end)
    end,
}
