-- https://github.com/jellydn/CopilotChat.nvim?tab=readme-ov-file#lazynvim
-- return {
--     {
--         "jellydn/CopilotChat.nvim",
--         opts = {
--             mode = "split", -- newbuffer or split  , default: newbuffer
--         },
--         build = function()
--             vim.defer_fn(function()
--                 vim.cmd("UpdateRemotePlugins")
--                 vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
--             end, 3000)
--         end,
--         event = "VeryLazy",
--         keys = {
--             { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
--             { "<leader>cct", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat - Generate tests (with pytest)" },
--         },
--         -- config = function()
--         -- TODO why doesnt this work
--         -- local utils = require('CopilotChat.utils')
--         -- utils.create_cmd('CopilotChatPytest', function()
--         --     vim.cmd('CopilotChat ' ..
--         --         'Briefly explain how the selected code works then generate unit tests using pytest.')
--         -- end, { nargs = '*', range = true })
--         -- end
--     },
-- }


return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" },  -- for curl, log wrapper
        },
        opts = {
            debug = true, -- Enable debugging
            -- See Configuration section for rest
        },
        -- See Commands section for default commands if you want to lazy load on them
        config = function()
            require("CopilotChat").setup {}
        end,
        -- default window options
        window = {
            layout = 'vertical',    -- 'vertical', 'horizontal', 'float'
            -- Options below only apply to floating windows
            relative = 'editor',    -- 'editor', 'win', 'cursor', 'mouse'
            border = 'single',      -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
            width = 0.8,            -- fractional width of parent
            height = 0.6,           -- fractional height of parent
            row = nil,              -- row position of the window, default is centered
            col = nil,              -- column position of the window, default is centered
            title = 'Copilot Chat', -- title of chat window
            footer = nil,           -- footer of chat window
            zindex = 1,             -- determines if window is on top or below other floating windows
        },
    },
}
