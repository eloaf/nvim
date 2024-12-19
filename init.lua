require("lazy-setup")
require("general")

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- Indent blank line and other such plugins will set conceal levels,
-- which in turn hide the `` type content.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "help",
    command = "setlocal conceallevel=0"
})

-- setup with some options
require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 50,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
})

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
-- { 'dasupradyumna/midnight.nvim', lazy = false, priority = 1000 }
require('onedark').setup {
    style = 'darker',
    transparent = true
}
require('onedark').load()

-- Jump to last edit position on opening file
-- https://www.reddit.com/r/neovim/comments/1abd2cq/comment/kjnmjca/?utm_source=share&utm_medium=web2x&context=3
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

function RunPythonCurrentFile()
    local current_file = vim.fn.expand('%')
    vim.cmd('split | terminal python ' .. current_file)
end

function RunPytestCurrentFile()
    local current_file = vim.fn.expand('%')
    -- % pytest --cov=df_api --cov-report term-missing libs/df-api/tests
    vim.cmd('split | terminal pytest -s --cov=df_api --cov-report term-missing ' .. current_file)
end

vim.api.nvim_create_user_command('RunPythonFile', RunPythonCurrentFile, {})
vim.api.nvim_set_keymap('n', '<leader>rp', ':RunPythonFile<CR>', { noremap = true, silent = true })


vim.api.nvim_create_user_command('RunPytestFile', RunPytestCurrentFile, {})
vim.api.nvim_set_keymap('n', '<leader>rt', ':RunPytestFile<CR>', { noremap = true, silent = true })


--  IDEA: Keep a file, that contains mappings of {file: run configuration}, which is loaded in memory on startup,
--  then there's a menu to edit this configuration (written back to file as well) and a shortcut (like leader-r)
--  that opens a terminal and runs the file with the configuration from the file

vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })

-- No arrows in normal mode to force using hjkl
vim.keymap.set('n', '<Up>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<Down>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<Left>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<Right>', '<Nop>', { noremap = true })

-- make the cursor blink
-- :set guicursor=a:blinkon100
vim.opt.guicursor = 'a:blinkon100'

vim.api.nvim_set_keymap('n', ',', ':set hlsearch!<CR>', { noremap = true, silent = true })

-- Replace <Tab> with >> in normal mode and > in visual mode
vim.api.nvim_set_keymap('n', '<Tab>', '>>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Tab>', '>gv', { noremap = true, silent = true })
-- Replace <S-Tab> with << in normal mode and < in visual mode
vim.api.nvim_set_keymap('n', '<S-Tab>', '<<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Tab>', '<gv', { noremap = true, silent = true })

-- Function to delete a line without yanking if it's empty or contains only spaces
function Delete_line_without_yanking()
    local line = vim.api.nvim_get_current_line()
    if line:match("^%s*$") then
        vim.api.nvim_command('normal! "_dd')
    else
        vim.api.nvim_command('normal! dd')
    end
end

-- Map the 'dd' key to the custom function
vim.api.nvim_set_keymap('n', 'dd', ':lua Delete_line_without_yanking()<CR>', { noremap = true, silent = true })

-- check if ~/.config/nvim/snippets/ exists
-- if not, create it

-- Define the source and target directories
-- local source_dir = '~/.local/share/nvim/lazy/friendly-snippets/snippets/'
-- local target_dir = '~/.config/nvim/snippets/'
--
-- if vim.fn.isdirectory(vim.fn.expand(target_dir)) == 0 then
--     vim.fn.mkdir(vim.fn.expand(target_dir), 'p')
-- end
--
-- -- Function to copy files from source to target directory
-- local function copy_files(source, target)
--     -- Iterate over files in the source directory
--     for _, file in ipairs(vim.fn.glob(source .. '/*', true, true)) do
--         -- Get the filename
--         local filename = vim.fn.fnamemodify(file, ':t')
--         -- Check if the file exists in the target directory
--         if vim.fn.filereadable(target .. filename) == 0 then
--             -- If not, copy the file
--             os.execute('cp ' .. file .. ' ' .. target .. filename)
--         end
--     end
-- end

-- -- Iterate over directories in the source directory
-- for _, path in ipairs(vim.fn.glob(source_dir .. '*', true, true)) do
--     if vim.fn.isdirectory(path) == 1 then
--         if vim.fn.isdirectory(target_dir .. path) == 0 then
--             vim.fn.mkdir(target_dir .. path, 'p')
--         end
--
--         -- get the base name
--         local basename = vim.fn.fnamemodify(path, ':t')
--
--         -- iterate over files in the subdir
--         for _, file in ipairs(vim.fn.glob(path .. '/*', true, true)) do
--             -- Get the filename
--             local filename = vim.fn.fnamemodify(file, ':t')
--             -- Check if the file exists in the target directory
--             if vim.fn.filereadable(target_dir .. basename .. "/" .. filename) == 0 then
--                 -- If not, copy the file
--                 os.execute('cp ' .. file .. ' ' .. target_dir .. basename .. "/" .. filename)
--             end
--         end
--     else
--         -- check if the file exists in the target directory
--         local filename = vim.fn.fnamemodify(path, ':t')
--         if vim.fn.filereadable(target_dir .. filename) == 0 then
--             -- If not, copy the file
--             os.execute('cp ' .. path .. ' ' .. target_dir .. filename)
--         end
--     end
-- end

vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Open file at the last position it was edited earlier',
    group = misc_augroup,
    pattern = '*',
    command = 'silent! normal! g`"zv'
})

-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#3c3836" })

------------------------------------------------------------------

---Prints the message if debug is true
---@param msg string
---@param debug boolean
local function maybe_print(msg, debug)
    if debug then
        print(msg)
    end
end

-- WARNING: The query is not the same between languages it seems!
-- We'll need to create a query for each language we want to support...

-- NOTE: in lua
-- (function_call ; [565, 0] - [565, 15]
--   name: (identifier) ; [565, 0] - [565, 6]
--   arguments: (arguments ; [565, 6] - [565, 15]
--     (number) ; [565, 7] - [565, 8]
--     (number) ; [565, 10] - [565, 11]
--     (number))) ; [565, 13] - [565, 14]
-- Foobar(1, 2, 3)

-- NOTE: in python
-- (call ; [51, 0] - [51, 21]
--   function: (identifier) ; [51, 0] - [51, 12]
--   arguments: (argument_list ; [51, 12] - [51, 21]
--     (integer) ; [51, 13] - [51, 14]
--     (integer) ; [51, 16] - [51, 17]
--     (integer)))) ; [51, 19] - [51, 20]
-- fn_with_args(1, 2, 3)


-- NOTE: According to ChatGPT: https://chatgpt.com/share/670be543-bf70-800a-a3e4-1e4b7611d074
-- (
--   (call
--     function: [
--       (identifier) @function
--       (attribute
--         object: (_)* @object
--         attribute: (identifier) @method
--       )
--     ]
--     arguments: (argument_list) @arguments
--   )
-- )


local QueryStrings = {
    -- python = [[
    --     (call
    --       function: (identifier) @function
    --       arguments: (argument_list) @arguments
    --     )
    -- ]],
    -- (
    --   (call
    --     function: [
    --       (identifier) @function
    --       (attribute
    --         object: (_)* @object
    --         attribute: (identifier) @method
    --       )
    --         ]
    --     arguments: (argument_list) @arguments
    --   ) @call
    -- )
    python = [[
        (
          (call
            function: [
              (identifier)
              (attribute
                object: (_)*
                attribute: (identifier)
              )
                ]
            arguments: (argument_list)
          ) @call
        )
    ]],
    lua = [[
        (function_call
          name: (identifier) @function
          arguments: (arguments) @arguments
        )
    ]]
}

local parsers = require('nvim-treesitter.parsers')

---Returns the treesitter query for the current language.
---@return vim.treesitter.Query
local function get_query()
    local ts = vim.treesitter
    local parser = parsers.get_parser()
    local lang = parser:lang()
    local query_string = QueryStrings[lang]

    if query_string == nil then
        error("Query string not found for language " .. lang)
    end

    local query = ts.query.parse(lang, query_string)

    return query
end

---Does BFS on the tree under `node` to find the first node of type `target_type`
---@param node TSNode
---@param target_type string
---@return TSNode
local function find_first_node_of_type_bfs(node, target_type)
    local queue = { node }

    while #queue > 0 do
        local current_node = table.remove(queue, 1) -- Dequeue the first element

        if current_node:type() == target_type then
            return current_node
        end

        for child in current_node:iter_children() do
            table.insert(queue, child) -- Enqueue child nodes
        end
    end

    error("Node not found")
end


---@param mode string
---@return table<integer, TSNode>
local function match_argument_nodes(mode)
    local parser = parsers.get_parser()
    local tree = parser:parse()[1]
    local query = get_query()

    local start_line, end_line

    if mode == 'v' then
        -- Visual mode
        start_line = vim.fn.line("'<") - 1
        end_line = vim.fn.line("'>")
    elseif mode == 'n' then
        -- Normal mode
        start_line = vim.fn.line('.') - 1
        end_line = start_line + 1
    else
        error("Invalid mode")
    end

    local results = {}

    for _, node, _, _ in query:iter_captures(tree:root(), 0, start_line, end_line) do
        local arguments_node = find_first_node_of_type_bfs(node, "argument_list")
        results[#results + 1] = arguments_node
    end

    return results
end


---@param arguments_node TSNode
---@return table
local function get_params_from_arguments_node(arguments_node)
    -- Extract the position from arguments_node
    local start_row, start_col = arguments_node:start()
    -- Create params using the position
    local params = {
        textDocument = vim.lsp.util.make_text_document_params(),
        position = { line = start_row, character = start_col }
    }
    return params
end


--- TODO: comment, rename this function? it returns the arguments list...
--- @param arguments_node TSNode
local function get_function_info(arguments_node)
    local params = get_params_from_arguments_node(arguments_node)

    -- WARNING: Not sure I understand this...
    params.position.character = params.position.character + 1
    -- params.position.line = params.position.line + 1

    local result = vim.lsp.buf_request_sync(0, "textDocument/signatureHelp", params, 10000)

    if result == nil then
        error("No result returned!")
    end

    -- TODO: May want to reformat the results...
    local key = next(result)

    local arguments = {}

    if result and result[key] and result[key].result and result[key].result.signatures then
        local signature = result[key].result.signatures[1]
        local label = signature.label
        local parameters = signature.parameters

        for _, param in ipairs(parameters) do
            local start_idx = param.label[1] + 1
            local end_idx = param.label[2]
            local arg_name = label:sub(start_idx, end_idx)
            -- split by `:` and get the first part
            arg_name = arg_name:match("([^:]+)")
            -- print("arg name=" .. arg_name)
            arguments[#arguments + 1] = arg_name
        end
    else
        error("No signature help available!")
    end

    return arguments
end

--- Returns the LSP client if it supports signature help, otherwise returns nil.
---@param debug boolean: Whether to print debug information
---@return vim.lsp.Client?
local function lsp_supports_signature_help(debug)
    -- Ensure the LSP client is attached
    local clients = vim.lsp.get_clients()

    local clients_with_signature_help = {}
    for _, client in ipairs(clients) do
        if client.server_capabilities.signatureHelpProvider then
            clients_with_signature_help[#clients_with_signature_help + 1] = client
        end
    end

    print("Clients", #clients, "Clients with signatureHelp", #clients_with_signature_help)

    if #clients_with_signature_help == 0 then
        maybe_print("No LSP client attached", debug)
        return nil
    end

    maybe_print("LSP server supports signatureHelp", debug)
    return clients_with_signature_help[1]
end

--- @param arguments_node TSNode
--- @return table<number, string>
local function get_argument_values(arguments_node)
    local argument_values = {}
    for i = 0, arguments_node:named_child_count() - 1 do
        local arg = arguments_node:named_child(i)
        if arg == nil then
            error("Argument is nil")
        end
        local arg_value = vim.treesitter.get_node_text(arg, 0)
        argument_values[#argument_values + 1] = arg_value
    end
    return argument_values
end

---@param str string
---@return boolean
local function contains_equal_outside_of_parentheses(str)
    for i = 1, #str do
        local char = str:sub(i, i)
        if char == "=" then
            return true
        elseif char == "(" then
            return false
        end
    end
    return false
end

--- Returns a table of arguments using their keyword version.
---@param argument_values table<number, string>
---@param function_info table<number, string>
---@return table<number, string>
local function get_args(argument_values, function_info)
    -- NOTE: in python you can't have non-keyword arguments after keyword arguments
    -- Therefore, we can just append the rest of the arguments as they are as soon
    -- as we encounter a keyword argument.

    local args = {}

    for i = 1, #argument_values do
        local arg_name = function_info[i]
        local arg_value = argument_values[i]

        if contains_equal_outside_of_parentheses(arg_value) then
            -- This is a keyword argument, we can just append the rest of the arguments
            break
        else
            args[#args + 1] = arg_name .. "=" .. arg_value
        end
    end

    for i = #args + 1, #argument_values do
        local arg_value = argument_values[i]
        args[#args + 1] = arg_value
    end

    return args
end


_G.expand_keywords = function(mode)
    local debug = true

    local client = lsp_supports_signature_help(debug)

    if client == nil then
        return
    end

    local argument_nodes = match_argument_nodes(mode)

    -- local argument_nodes
    -- vim.schedule(function()
    --     argument_nodes = match_argument_nodes()
    -- end)
    -- vim.defer_fn(function()
    --     print(argument_nodes)
    -- end, 0)

    for i = #argument_nodes, 1, -1 do
        --- arguments_node: TSNode
        local arguments_node = argument_nodes[i]
        local function_info = get_function_info(arguments_node)
        local argument_values = get_argument_values(arguments_node)
        local args = get_args(argument_values, function_info)
        print(vim.inspect(function_info))
        print(vim.inspect(argument_values))
        print(vim.inspect(args))
        local repl = "(" .. table.concat(args, ", ") .. ")"
        local row_start, col_start, row_end, col_end = arguments_node:range()

        -- print(repl)
        -- local start = arguments_node:start()
        -- local end_ = arguments_node:end_()
        -- print('start ' .. start .. ', end ' .. end_)

        vim.api.nvim_buf_set_text(
            0,
            row_start,
            col_start,
            row_end,
            col_end,
            { repl }
        )
    end
end


vim.api.nvim_set_keymap(
    'n',
    '<leader>mf',
    ':lua expand_keywords("n")<CR>',
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    'v',
    '<leader>mf',
    ':lua expand_keywords("v")<CR>',
    { noremap = true, silent = true }
)



-- _G.browse_symbols = function()
--     -- require("telescope.builtin").lsp_workspace_symbols()
--     local telescope = require("telescope")
-- end

-- Use the Python LSP to retrieve potential imports
-- local function get_imports()
--     -- This is a placeholder. Replace with LSP requests or static tools like `pylance` or `jedi`.
--     return {
--         "os",
--         "sys",
--         "math",
--         "numpy as np",
--         "pandas as pd",
--         "from collections import defaultdict",
--     }
-- end
-- function _G.insert_import()
--     local imports = get_imports()
--     require('telescope.pickers').new({}, {
--         prompt_title = "Select Import",
--         finder = require('telescope.finders').new_table {
--             results = imports,
--             entry_maker = function(entry)
--                 return {
--                     value = entry,
--                     display = entry,
--                     ordinal = entry
--                 }
--             end,
--         },
--         sorter = require('telescope.config').values.generic_sorter({}),
--         attach_mappings = function(_, map)
--             map('i', '<CR>', function(prompt_bufnr)
--                 local selection = require('telescope.actions.state').get_selected_entry()
--                 require('telescope.actions').close(prompt_bufnr)
--                 -- Insert the import at the top of the file
--                 local import_statement = selection.value
--                 vim.api.nvim_buf_set_lines(0, 0, 0, false, { import_statement })
--             end)
--             return true
--         end,
--     }):find()
-- end

local M = {}

-- Function to fetch workspace symbols
local function fetch_workspace_symbols(query, callback)
    local params = { query = query or "" }

    -- local result = vim.lsp.buf_request_sync(0, "textDocument/signatureHelp", params, 10000)
    -- vim.lsp.buf_request(0, "workspace/symbol", params, function(err, result, ctx, _)
    -- vim.lsp.buf_request(0, "workspace/symbol", params, function(err, result, ctx, _)
    --     if err then
    --         vim.notify("LSP Error: " .. err.message, vim.log.levels.ERROR)
    --         return
    --     end
    --     callback(result or {})
    -- end)
    local result = vim.lsp.buf_request_sync(0, "workspace/symbol", params, 5000)
    print(vim.inspect(result))
end

-- Create a Telescope picker to display the symbols
function _G.show_importable_symbols()
    fetch_workspace_symbols("", function(symbols)
        -- Format the symbols for Telescope
        local entries = {}
        for _, symbol in ipairs(symbols) do
            table.insert(entries, {
                display = string.format("%s [%s]", symbol.name, symbol.kind),
                ordinal = symbol.name,
                value = symbol,
            })
        end

        -- print(vim.inspect(entries))
        print("Symbols found: " .. #entries)

        -- Show the results in Telescope
        require("telescope.pickers").new({}, {
            prompt_title = "Workspace Symbols",
            finder = require("telescope.finders").new_table {
                results = entries,
                entry_maker = function(entry)
                    return {
                        value = entry.value,
                        display = entry.display,
                        ordinal = entry.ordinal,
                    }
                end,
            },
            sorter = require("telescope.config").values.generic_sorter({}),
            attach_mappings = function(_, map)
                map("i", "<CR>", function(prompt_bufnr)
                    local selection = require("telescope.actions.state").get_selected_entry()
                    require("telescope.actions").close(prompt_bufnr)

                    -- Insert the selected symbol as an import at the top of the file
                    local import_name = selection.value.name
                    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "import " .. import_name })
                end)
                return true
            end,
        }):find()
    end)
end

vim.api.nvim_set_keymap(
    'n',
    '<leader>i',
    -- ':lua browse_symbols()<CR>',
    -- ":Telescope lsp_workspace_symbols<CR>",
    -- ":lua insert_import()<CR>",
    ":lua show_importable_symbols()<CR>",
    { noremap = true, silent = true }
)


-- NOTE: Ideas for argument expansion
-- Automatically add default kwargs into the call (verbose)
-- Sentinels and *args type arguments don't work.
-- Reorder kwargs into the same order as the function definition
-- Make sure it works in relevant languages
-- Manage python sentinel?
-- Un-expansion (remove the function argument)
-- Deal with newlines


-- NOTE: Ideas!
-- 1. keymap that will find the declared variables on a line, then create a print statement
-- or logging statement for them.
-- 2. Line drag feature (moving lines up or down)
-- 3. When triggering completion within a function call (especially argument values), we should favor literals & variables ?
-- 4. oil-like buffer that switches automatically on main windows?

vim.api.nvim_set_keymap("v", "<leader>cp", '"*y', { noremap = true, silent = true })

-- vim.api.nvim_set_keymap("n", "<leader>db", "<CR>breakpoint()<ESC>", { noremap = true, silent = true })

function set_visual_line_selection(start_line, end_line)
    -- Save the current cursor position
    local current_pos = vim.api.nvim_win_get_cursor(0)

    -- Move to the start line and enter visual line mode
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    vim.cmd('normal! V')

    -- Move to the end line
    vim.api.nvim_win_set_cursor(0, { end_line, 0 })

    -- Restore the original cursor position
    vim.api.nvim_win_set_cursor(0, current_pos)
end

-- Move selection while keeping the cursor in the same position
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { silent = true })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { silent = true })

-- function to return the current filename
function _G.get_current_filename()
    return vim.fn.expand("%:t")
end

-- function copy to the current filename to the * register
function _G.copy_current_filename()
    local filename = get_current_filename()
    vim.fn.setreg("*", filename)
end

vim.api.nvim_set_keymap("n", "<leader>cf", ":lua copy_current_filename()<CR>", { noremap = true, silent = true })
