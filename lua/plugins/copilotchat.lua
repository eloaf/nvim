-- https://github.com/jellydn/CopilotChat.nvim?tab=readme-ov-file#lazynvim
return {
    {
        "jellydn/CopilotChat.nvim",
        opts = {
            mode = "split", -- newbuffer or split  , default: newbuffer
        },
        build = function()
            vim.defer_fn(function()
                vim.cmd("UpdateRemotePlugins")
                vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
            end, 3000)
        end,
        event = "VeryLazy",
        keys = {
            { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
            { "<leader>cct", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat - Generate tests (with pytest)" },
        },
        -- config = function()
        -- TODO why doesnt this work
        -- local utils = require('CopilotChat.utils')
        -- utils.create_cmd('CopilotChatPytest', function()
        --     vim.cmd('CopilotChat ' ..
        --         'Briefly explain how the selected code works then generate unit tests using pytest.')
        -- end, { nargs = '*', range = true })
        -- end
    },
}
