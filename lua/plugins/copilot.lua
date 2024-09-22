return {
    {
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
    },
    {
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
                -- print("CopilotChat config")
                require("CopilotChat").setup(
                    {
                        window = {
                            layout = 'float',
                            relative = 'cursor',
                            width = 1,
                            height = 0.4,
                            row = 1
                        }
                    }
                )
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
}
