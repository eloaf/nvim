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

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })


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

-- function Foo()
--     local current_node = vim.treesitter.get_node({}) -- get the node at the cursor position in the current buffer
--     if current_node == nil then
--         print("No node found")
--         return
--     end
--     print(current_node:type())   -- call the type method on the node
--     print(current_node:range())  -- call the range method on the node
--     print(current_node:parent()) -- get the parent node
-- end

-- function MatchFunction()
--     local current_node = vim.treesitter.get_node({}) -- get the node at the cursor position in the current buffer
--     if current_node == nil then
--         print("!!! No node found !!!")
--         return nil
--     end

--     if current_node:type() == "identifier" then
--         print("Found identifier")

--         -- check that current node's parent is a call
--         local parent = current_node:parent()
--         if parent == nil then
--             print("No parent found")
--             return nil
--         end
--         print("parent: " .. parent:type())

--         if not parent or parent:type() ~= "call" then
--             print("Not a call")
--             return nil
--         end

--         -- if parent is a call, then check if its children have
--         -- an identifier and a function
--         local children = {}
--         for child in parent:iter_children() do
--             children[child:type()] = child
--             print(child:type())
--         end

--         if children["identifier"] and children["argument_list"] then
--             print("Found identifier and function")
--             print("identifier: " .. children["identifier"]:range())
--             print("function: " .. children["argument_list"]:range())
--         else
--             print("No identifier or function found")
--             return
--         end

--         local arguments = children["argument_list"]
--         if arguments == nil then
--             print("No arguments found")
--             return nil
--         end
--         for i = 0, arguments:named_child_count() - 1 do
--             local argument = arguments:named_child(i)
--             print(argument:type())
--         end

--         -- Store all the arguments's text in a table
--         local args = {}
--         for i = 0, arguments:named_child_count() - 1 do
--             local argument = arguments:named_child(i)
--             local start_row, start_col, end_row, end_col = argument:range()
--             local text = vim.api.nvim_buf_get_text(
--                 0,
--                 start_row,
--                 start_col,
--                 end_row,
--                 end_col,
--                 {}
--             )
--             for _, line in ipairs(text) do
--                 print(line)
--                 table.insert(args, line)
--             end
--         end

--         -- Get the function name
--         local start_row, start_col, end_row, end_col = children["identifier"]:range()
--         local function_name = vim.api.nvim_buf_get_text(
--             0,
--             start_row,
--             start_col,
--             end_row,
--             end_col,
--             {}
--         )
--         print("function_name: " .. function_name[1])

--         -- Delete the text of the function call, and replace it with:
--         -- function_name(
--         --   args[1],
--         --   args[2],
--         --   etc,
--         -- )
--         -- in order t ocall the function with the same arguments
--         -- with one argument per line
--         local new_text = function_name[1] .. "(\n"
--         for i, arg in ipairs(args) do
--             new_text = new_text .. "  " .. arg
--             if i < #args then
--                 new_text = new_text .. ",\n"
--             else
--                 new_text = new_text .. "\n"
--             end
--         end
--         new_text = new_text .. ")\n"
--         print(new_text)

--         -- replace the with the new text
--         -- Split the new_text into a list of lines
--         local lines = {}
--         for s in new_text:gmatch("[^\r\n]+") do
--             table.insert(lines, s)
--         end

--         -- replace the with the new lines
--         vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, lines)
--     end
-- end

-- vim.keymap.set(
--     "n",
--     "<leader>L",
--     "<cmd>lua MatchFunction()<CR>",
--     { noremap = true, silent = true }
-- )
