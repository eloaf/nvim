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
            print("CopilotChat config")
            require("CopilotChat").setup {}
            -- local chat = require("CopilotChat")
            --
            -- -- Open chat window
            -- chat.open()
            --
            -- -- Open chat window with custom options
            -- chat.open({
            --     window = {
            --         layout = 'float',
            --         title = 'My Title',
            --     },
            -- })
            --
            -- -- Close chat window
            -- chat.close()
            --
            -- -- Toggle chat window
            -- chat.toggle()
            --
            -- -- Toggle chat window with custom options
            -- chat.toggle({
            --     window = {
            --         layout = 'float',
            --         title = 'My Title',
            --     },
            -- })
            --
            -- -- Reset chat window
            -- chat.reset()
            --
            -- -- Ask a question
            -- chat.ask("Explain how it works.")
            --
            -- -- Ask a question with custom options
            -- chat.ask("Explain how it works.", {
            --     selection = require("CopilotChat.select").buffer,
            -- })
            --
            -- -- Ask a question and do something with the response
            -- chat.ask("Show me something interesting", {
            --     callback = function(response)
            --         print("Response:", response)
            --     end,
            -- })
            --
            -- -- Get all available prompts (can be used for integrations like fzf/telescope)
            -- local prompts = chat.prompts()
            --
            -- -- Get last copilot response (also can be used for integrations and custom keymaps)
            -- local response = chat.response()
            --
            -- -- Pick a prompt using vim.ui.select
            -- local actions = require("CopilotChat.actions")
            --
            -- -- Pick help actions
            -- actions.pick(actions.help_actions())
            --
            -- -- Pick prompt actions
            -- actions.pick(actions.prompt_actions({
            --     selection = require("CopilotChat.select").visual,
            -- }))

            -- <leader>cc to toggle chat window
            vim.api.nvim_set_keymap('n', '<leader>cc', '<cmd>lua require("CopilotChat").toggle()<cr>',
                { noremap = true, silent = true })


            -- create a dummy function
            function _G.dummy()
                -- Get LSP diagnostics from the current file and store in a string variable
                local diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
                local diagnostics_string = "```\n"
                for i, diagnostic in pairs(diagnostics) do
                    print(i)
                    -- print(diagnostic.message)
                    diagnostics_string = diagnostics_string .. diagnostic.message .. "\n"
                end
                diagnostics_string = diagnostics_string .. "```"

                -- get the current line contents
                local current_line = vim.api.nvim_get_current_line()

                -- assemble prompt
                local prompt = "The following line of code:\n```\n" ..
                    current_line ..
                    "\n```\nhas the following diagnostics:\n" ..
                    diagnostics_string .. "\n\nPlease explain the diagnostics and suggest a fix."

                require("CopilotChat").ask(prompt)
            end

            function _G.dummy_2()
                -- Get the LSP diagnostics from the current visual selection

                -- get current buffer
                local bufnr = vim.api.nvim_get_current_buf()

                -- Define a table to store diagnostics
                local line_start = vim.fn.line("'<") - 1
                local line_end = vim.fn.line("'>") - 1

                local diagnostics_string = "```\n"

                -- Iterate through the line numbers
                for line_nr = line_start, line_end do
                    -- Get the diagnostics for the current line
                    local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line_nr)

                    for _, diagnostic in pairs(line_diagnostics) do
                        diagnostics_string = diagnostics_string .. line_nr .. ": " .. diagnostic.message .. "\n"
                    end
                end

                local lines = vim.fn.getline(line_start + 1, line_end + 1)
                local lines_string = ""
                if type(lines) == "string" then
                    lines_string = lines
                else
                    lines_string = table.concat(lines, "\n")
                end

                local prompt = "The following lines of code:\n```\n" ..
                    lines_string ..
                    "\n```\nhas the following diagnostics:\n" ..
                    diagnostics_string .. "```\n\nPlease explain the diagnostics and suggest a fix."

                require("CopilotChat").ask(prompt)
            end

            -- call dummy when pressing <leader>ce in visual mode
            vim.api.nvim_set_keymap("n", "<leader>ce", ':lua _G.dummy()<CR>', {})
            vim.api.nvim_set_keymap("v", "<leader>ce", ':lua _G.dummy_2()<CR>', {})
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
