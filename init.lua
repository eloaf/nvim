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
-- Function that will detect the different function calls on the current line,
-- then use the lsp definition and treesitter to use keyword arguments
-- on all the arguments of the function. For now only works with python.
-- For example, if the line is:
-- my_function(1, 2, 3)
-- and the definition of my_function is:
-- def my_function(a, b, c):
--    return a + b + c
-- Then the line will be transformed to:
-- my_function(a=1, b=2, c=3)

-- Function that adds 3 numbers
-- @param a number: The first number
-- @param b number: The second number
-- @param c number: The third number
-- @return number: The sum of the three numbers
function Foobar(a, b, c)
    return a + b + c
end

Foobar(1, 2, 3)


-- function Use_keyword_arguments()
--     -- Get the current line
--     local line = vim.api.nvim_get_current_line()
--     -- Get the current buffer
--     local buf = vim.api.nvim_get_current_buf()
--     -- Get the current cursor position
--     local cursor = vim.api.nvim_win_get_cursor(0)
--     -- Get the current line number
--     local line_number = cursor[1]
--     -- Get the current column number
--     local col = cursor[2]
--     -- Get the current buffer name
--     local bufname = vim.api.nvim_buf_get_name(buf)
--     -- Get the current filetype
--     local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')

--     print("line: ", line)
--     print("line_number: ", line_number)
--     print("col: ", col)
--     print("bufname: ", bufname)
--     print("filetype: ", filetype)

--     local node = vim.treesitter.get_node({})

--     if node == nil then
--         error("node is nil")
--     end


--     print("node: ", node)
--     local node_type = node:type()
--     print("node: ", node_type)

--     -- Get the lsp definition of the function

--     -- local response = vim.lsp.buf_request(0, "Foobar", {})


--     -- local params = vim.lsp.buf_request(0, 'textDocument/definition', {
--     --     textDocument = vim.lsp.util.make_text_document_params()
--     -- }, function(err, _, result)
--     --     if err then
--     --         print("Error: ", err)
--     --         return
--     --     end
--     --     if not result or vim.tbl_isempty(result) then
--     --         print("No definition found")
--     --         return
--     --     end
--     --     print("Result: ", result)
--     -- end)

--     -- print("Params=", vim.inspect(params))

--     -- local definition_handler = vim.lsp.handlers["textDocument/definition"]
--     -- local response = vim.lsp.buf_request(0, "Foobar", {}, definition_handler)
--     -- print("response: ", vim.inspect(response))

--     -- local util = require('vim.lsp.util')
--     -- local ms = require('vim.lsp.protocol').Methods

--     -- local params = util.make_range_params()
--     -- print("params: ", vim.inspect(params))

--     -- local definition = vim.lsp.buf.definition({ loclist = true })

--     -- -- use treesitter to get the function name and arguments at the cursor position
--     -- local parser = require('nvim-treesitter.parsers').get_parser(buf)
--     -- local query_str = [[
--     --     (call_expression
--     --         function: (identifier) @function
--     --         arguments: (argument_list) @arguments
--     --     )
--     -- ]]
--     -- local tree = vim.treesitter.get_parser(buf):parse()[1]
--     -- print("tree: ", tree)


--     -- local query = vim.treesitter.parse_query(parser:lang(), query_str)
--     -- for id, node in query:iter_captures(tree:root(), buf, 0, -1) do
--     --     if node:child_for_field_id('function'):range() == cursor then
--     --         local function_name = node:child_for_field_id('function'):child(0):utf8()
--     --         print("function_name: ", function_name)
--     --         local arguments = node:child_for_field_id('arguments')
--     --         print("arguments: ", arguments)
--     --         for i = 0, arguments:named_child_count() - 1 do
--     --             local arg = arguments:named_child(i)
--     --             print("arg: ", arg)
--     --         end
--     --     end
--     -- end

--     -- Get the query results
--     -- print("results: ", results)
-- end

-- vim.api.nvim_set_keymap('n', '<leader>uk', ':lua Use_keyword_arguments()<CR>', { noremap = true, silent = true })



-- Check the logs at `:lua vim.lsp.log.get_filename()`.
vim.lsp.set_log_level("debug")


_G.match_function_calls = function()
    local ts = vim.treesitter
    local parsers = require('nvim-treesitter.parsers')

    local print_node = function(node)
        print(ts.get_node_text(node, 0))
    end

    local parser = parsers.get_parser()
    local lang = parser:lang()
    -- print("lang", lang)
    local tree = parser:parse()[1]
    local root = tree:root()
    -- print_node(root)

    local query_string = [[
        (call
          function: (identifier) @function
          arguments: (argument_list) @arguments
        )
    ]]

    local query = ts.query.parse(lang, query_string)

    -- Get the current line number
    local current_line = vim.fn.line('.')

    -- Run iter_matches only on the current line
    for _, matches, _ in query:iter_matches(root, 0, current_line - 1, current_line, { all = true }) do
        for id, match in ipairs(matches) do
            local name = query.captures[id] -- name of the capture in the query
            for _, node in ipairs(match) do
                print(name)
                print_node(node)
                print()
            end
        end
    end
end

vim.api.nvim_set_keymap(
    'n',
    '<leader>mf',
    ':lua match_function_calls()<CR>',
    { noremap = true, silent = true }
)


_G.get_function_arguments = function()
    -- Create the params for the LSP request
    local params = vim.lsp.util.make_position_params()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- Debugging information
    print("Cursor position: row =", row, "col =", col)
    print("Initial params: ", vim.inspect(params))

    -- TODO: I will have to adjust the position to be inside of the function?

    -- Adjust the position if the cursor is at the beginning of the line
    if col == 0 then
        params.position.character = 1
    end

    -- Debugging information
    print("Adjusted params: ", vim.inspect(params))

    -- -- Ensure the LSP client is attached
    local clients = vim.lsp.get_clients()
    if next(clients) == nil then
        print("No LSP client attached")
        return
    else
        print("LSP client attached")
    end

    -- -- Check if the client supports signatureHelp
    local client = clients[1]
    if not client.server_capabilities.signatureHelpProvider then
        print("LSP server does not support signatureHelp")
        return
    else
        print("LSP server supports signatureHelp")
    end

    -- Send the LSP request
    -- It's because the handler is called asynchronously, so the prints are not in the same context
    -- as the function call. The prints will be in the logs.
    local result = vim.lsp.buf_request_sync(0, "textDocument/signatureHelp", params, 10000)

    -- local function test_func()
    --     print("Test function")
    -- end

    -- vim.lsp.buf_request_all(0, "textDocument/signatureHelp", params, test_func)

    if result == nil then
        error("No result returned")
    end

    -- vim.lsp.buf.hover()
    -- vim.lsp.buf.hover()
    -- local content = capture_hover_content()
    -- print("Content: ", content)

    -- @*return* `result` — Map of client_id:request_result.
    print("Result: ", vim.inspect(result))

    -- Get the key of the result
    local key = next(result)
    print("Key: ", key)
    print("Value: ", vim.inspect(result[key]))

    if result and result[key] and result[key].result and result[key].result.signatures then
        local signature = result[key].result.signatures[1]
        local label = signature.label
        local parameters = signature.parameters

        print("Function arguments:")
        for _, param in ipairs(parameters) do
            local start_idx = param.label[1] + 1
            local end_idx = param.label[2]
            local arg_name = label:sub(start_idx, end_idx)
            print(arg_name)
        end
    else
        print("No signature help available")
    end
end

Foobar(1, 2, 3)

-- Bind the function to a command or keymap for easy testing
vim.api.nvim_set_keymap('n', '<leader>fa', ':lua get_function_arguments()<CR>', { noremap = true, silent = true })


-- NOTE: Ideas!
-- 1. keymap that will find the declared variables on a line, then create a print statement
-- or logging statement for them.
-- 2. Line drag feature (moving lines up or down)
