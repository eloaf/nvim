----------
-- Lazy --
----------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>L", "<cmd>Lazy<CR>", { noremap = true, silent = true }) -- Open Lazy
require("lazy").setup("plugins")                                                     -- Setup plugins (in lua.plugins)

-- https://www.reddit.com/r/neovim/comments/u3c3kw/how_do_you_sorting_cmp_completions_items/
-- NOTE: 7. Insert mode completion				*ins-completion*, :help ins-completion or help completion

-- TODO: Fix this
pcall(function()
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
end
)
-- vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

-- TODO: Show them in telescope
vim.api.nvim_create_user_command(
    "SnipList",
    function()
        local ft_list = require("luasnip").available()[vim.o.filetype]
        local ft_snips = {}
        for _, item in pairs(ft_list) do
            ft_snips[item.trigger] = item.name
        end
        print(vim.inspect(ft_snips))
        local telescope = require("telescope")
        -- Show the list of snippets in telescope
        -- ```lua
        -- local telescope: {
        --     extensions: table,
        --     load_extension: function,
        --     register_extension: function,
        --     setup: function,
        --     __format_setup_keys: function,
        -- }
        -- ```
    end,
    {}
)

-- Neotest
require("neotest").setup({
    adapters = {
        require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = { justMyCode = false },
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { "--log-level", "DEBUG" },
            -- Runner to use. Will use pytest if available by default.
            -- Can be a function to return dynamic value.
            runner = "pytest",
            -- Custom python path for the runner.
            -- Can be a string or a list of strings.
            -- Can also be a function to return dynamic value.
            -- If not provided, the path will be inferred by checking for
            -- virtual envs in the local directory and for Pipenev/Poetry configs
            python = ".venv/bin/python",
            -- Returns if a given file path is a test file.
            -- NB: This function is called a lot so don't perform any heavy tasks within it.
            -- is_test_file = function(file_path)
            --     ...
            -- end,
            -- !!EXPERIMENTAL!! Enable shelling out to `pytest` to discover test
            -- instances for files containing a parametrize mark (default: false)
            pytest_discover_instances = true,
        })
    }
})

require("coverage").setup({
    highlights = {
        covered = { fg = "#1B4F72" },
        uncovered = { fg = "#F1C40F" },
    }
})


-----------------------------------------------

-- default configuration
require('illuminate').configure({})

-----------------------------------------------
