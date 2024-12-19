return {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "mfussenegger/nvim-dap-python" },
    config = function()
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        -- vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
        -- vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
        -- vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
        -- vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
        -- vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
        -- vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
        -- vim.keymap.set('n', '<Leader>lp',
        --     function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
        -- vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
        -- vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
        -- vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
        --     require('dap.ui.widgets').hover()
        -- end)
        -- vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
        --     require('dap.ui.widgets').preview()
        -- end)
        -- vim.keymap.set('n', '<Leader>df', function()
        --     local widgets = require('dap.ui.widgets')
        --     widgets.centered_float(widgets.frames)
        -- end)
        -- vim.keymap.set('n', '<Leader>ds', function()
        --     local widgets = require('dap.ui.widgets')
        --     widgets.centered_float(widgets.scopes)
        -- end)

        vim.keymap.set('n', '<F5>', ':lua require("dap").continue()<CR>')
        vim.keymap.set('n', '<F10>', ':lua require("dap").step_over()<CR>')
        vim.keymap.set('n', '<F11>', ':lua require("dap").step_into()<CR>')
        vim.keymap.set('n', '<F12>', ':lua require("dap").step_out()<CR>')
        vim.keymap.set('n', '<Leader>b', ':lua require("dap").toggle_breakpoint()<CR>')
        vim.keymap.set('n', '<Leader>B', ':lua require("dap").set_breakpoint()<CR>')
        vim.keymap.set('n', '<Leader>lp',
            ':lua require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>')
        vim.keymap.set('n', '<Leader>dr', ':lua require("dap").repl.open()<CR>')
        vim.keymap.set('n', '<Leader>dl', ':lua require("dap").run_last()<CR>')
        vim.keymap.set({ 'n', 'v' }, '<Leader>dh', ':lua require("dap.ui.widgets").hover()<CR>')
        vim.keymap.set({ 'n', 'v' }, '<Leader>dp', ':lua require("dap.ui.widgets").preview()<CR>')
        vim.keymap.set('n', '<Leader>df',
            ':lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames)<CR>')
        vim.keymap.set('n', '<Leader>ds',
            ':lua require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)<CR>')

        -- echo $(pyenv shell 3.11.10; pyenv which python)
        -- require("dap-python").setup("/path/to/venv/bin/python")
        require("dap-python").setup("/Users/eric/.pyenv/versions/3.11.10/bin/python")

        -- If using the above, then `/path/to/venv/bin/python -m debugpy --version`
        -- must work in the shell

        -- Use telescope to browse files in ./run_configs/
        -- local telescope = require("telescope")
        -- vim.api.nvim_set_keymap(
        --     'n',
        --     '<leader>rr',
        --     [[<cmd>lua require('telescope.builtin').find_files({ prompt_title = "Run Scripts", cwd = "./run_scripts" })<CR>]],
        --     { noremap = true, silent = true }
        -- )

        local run_script = function(selection)
            local command = "term " .. selection.cwd .. "/" .. selection.value
            vim.cmd(command)
        end

        vim.api.nvim_set_keymap(
            'n',
            '<leader>rr',
            [[<cmd>lua require('telescope.builtin').find_files({
        prompt_title = "Run Scripts",
        cwd = "./run_scripts",
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local command = "term " .. selection.cwd .. "/" .. selection.value
                vim.cmd(command)
            end)
            return true
        end
    })<CR>]],
            { noremap = true, silent = true }
        )
    end
}
