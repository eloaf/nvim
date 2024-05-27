return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require('copilot').setup({
            panel = {
                enabled = true,
                auto_refresh = false,
                keymap = {
                    jump_prev = "[[",
                    jump_next = "]]",
                    accept = "<CR>",
                    refresh = "gr",
                    open = "<M-CR>"
                },
                layout = {
                    position = "bottom", -- | top | left | right
                    ratio = 0.4
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    -- accept = "<M-l>",
                    accept = "<C-CR>",
                    accept_word = false,
                    accept_line = false,
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                yaml = false,
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
            copilot_node_command = 'node', -- Node.js version must be > 18.x
            server_opts_overrides = {},
        })
    end,
}

-- return {}

-- return {
--     'github/copilot.vim',
--     -- config = false,
--     init = function()
--         vim.keymap.set('i', '<C-j>', 'copilot#Accept("<CR>")', {
--             noremap = true,
--             silent = true,
--             expr = true,
--             replace_keycodes = false
--         })
--
--         vim.g.copilot_no_tab_map = true
--         vim.g.copilot_assume_mapped = true
--     end,
--     config = function()
--         vim.g.copilot_assume_mapped = true
--     end
-- }
