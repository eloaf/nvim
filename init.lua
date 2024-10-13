require("lazy-setup")
require("general")

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- setup with some options
require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 40,
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

local QueryStrings = {
    python = [[
        (call
          function: (identifier) @function
          arguments: (argument_list) @arguments
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

---comment
---@return table<number, table<string, TSNode>>
local function match_function_calls()
    local parser = parsers.get_parser()
    local tree = parser:parse()[1]
    local root = tree:root()

    local query = get_query()

    local current_line = vim.fn.line('.')

    local result = {}
    local iterator = 0

    -- vim.treesitter.Query:iter_matches(
    --     node: TSNode,
    --     source: string|integer,
    --     start?: integer,
    --     stop?: integer,
    --     opts?: table
    -- )
    for _, matches, _ in query:iter_matches(root, 0, current_line - 1, current_line, { all = true }) do
        iterator = iterator + 1
        local item = {}
        for id, match in ipairs(matches) do
            local name = query.captures[id] -- name of the capture in the query
            for _, node in ipairs(match) do
                if item[name] ~= nil then
                    error("Item " .. name .. " already exists")
                end
                item[name] = node
            end
        end
        result[iterator] = item
    end

    if vim.tbl_isempty(result) then
        error("No function calls found")
    end

    return result
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

---Checks if the current LSP client supports signature help
---@param debug boolean: Whether to print debug information
---@return boolean
local function lsp_supports_signature_help(debug)
    -- Ensure the LSP client is attached
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        maybe_print("No LSP client attached", debug)
        return false
    end
    maybe_print("LSP client attached", debug)

    -- Check if the client supports signatureHelp
    local client = clients[1]
    if not client.server_capabilities.signatureHelpProvider then
        maybe_print("LSP server does not support signatureHelp", debug)
        return false
    else
        maybe_print("LSP server supports signatureHelp", debug)
    end

    return true
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

local function get_args(argument_values, function_info)
    if #function_info ~= #argument_values then
        error("Number of arguments do not match")
    end

    local args = {}

    for i = 1, #function_info do
        local arg_name = function_info[i]
        --- @type string
        local arg_value = argument_values[i]
        if arg_value:sub(1, #arg_name + 1) == arg_name .. "=" then
            args[#args + 1] = arg_value
        else
            args[#args + 1] = arg_name .. "=" .. arg_value
        end
    end

    return args
end


_G.expand_keywords = function()
    local debug = false

    if not lsp_supports_signature_help(debug) then
        return
    end

    local function_calls = match_function_calls()

    for i = #function_calls, 1, -1 do
        local function_call = function_calls[i]
        local arguments_node = function_call["arguments"]
        local function_info = get_function_info(arguments_node)
        local argument_values = get_argument_values(arguments_node)
        local args = get_args(argument_values, function_info)
        local repl = "(" .. table.concat(args, ", ") .. ")"
        local row_start, col_start, row_end, col_end = arguments_node:range()

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
    ':lua expand_keywords()<CR>',
    { noremap = true, silent = true }
)


-- NOTE: Ideas!
-- 1. keymap that will find the declared variables on a line, then create a print statement
-- or logging statement for them.
-- 2. Line drag feature (moving lines up or down)
