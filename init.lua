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

-- INFO: Colorscheme
-- vim.cmd("colorscheme nightfly")
-- { 'dasupradyumna/midnight.nvim', lazy = false, priority = 1000 }
-- vim.cmd("colorscheme midnight")
require('onedark').setup {
    style = 'deep',
    transparent = true
}
require('onedark').load()

-- Read the lines of a file/buffer instead?
--  IDEA: Keep a file, that contains mappings of {file: run configuration}, which is loaded in memory on startup,
--  then there's a menu to edit this configuration (written back to file as well) and a shortcut (like leader-r)
--  that opens a terminal and runs the file with the configuration from the file
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

vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })

-- No arrows in normal mode to force using hjkl
vim.keymap.set('n', '<Up>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<Down>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<Left>', '<Nop>', { noremap = true })
vim.keymap.set('n', '<Right>', '<Nop>', { noremap = true })

-- make the cursor blink
vim.opt.guicursor = 'a:blinkon100'

-- Toggle highlighting
vim.api.nvim_set_keymap('n', ',', ':set hlsearch!<CR>', { noremap = true, silent = true })

-- Replace <Tab> with >> in normal mode and > in visual mode to emulate the more common behavior of the Tab key
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

vim.api.nvim_set_keymap('n', 'dd', ':lua Delete_line_without_yanking()<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Open file at the last position it was edited earlier',
    group = nil,
    pattern = '*',
    command = 'silent! normal! g`"zv'
})

-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#3c3836" })

-- NOTE: Ideas!

vim.api.nvim_set_keymap("v", "<leader>cp", '"*y', { noremap = true, silent = true })

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

------------------------------
local curl = require("plenary.curl")
local ts_utils = require("nvim-treesitter.ts_utils")

local function parse_code_from_output(lang, text)
    local code_block_pattern = string.format("```%s(.-)```", lang)
    local code = text:match(code_block_pattern)
    if code then
        -- Trim leading and trailing whitespace
        code = code:gsub("^%s*(.-)%s*$", "%1")
    end
    return code
end

function _G.inline_prompt()
    local instruction = vim.api.nvim_get_current_line()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_node = ts_utils.get_node_at_cursor()
    local function_node = cursor_node

    while function_node and function_node:type() ~= "function_declaration" do
        local parent = function_node:parent()
        if not parent then
            break
        end
        function_node = parent
    end

    if not function_node then
        print("No function definition found.")
        return
    end

    local start_row, _, end_row, _ = function_node:range()
    local context_lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
    local context = table.concat(context_lines, "\n")

    -- local prompt = string.format([[
    --     Instruction: %s
    --     Context: %s
    --     Please provide the necessary line of code to replace the instruction in the context.
    -- ]], instruction, context)

    -- get current programming language
    local lang = vim.api.nvim_buf_get_option(0, "ft")

    local prompt = string.format(
        [[Your job is to write one or a few lines of code. The instruction is given below, along with the context in which it appears. Please provide the necessary line of code to replace the instruction in the context.

Instruction: %s
Context:
```%s
%s
```
Output format:
```%s
[Your code here]
```
]], instruction, lang, context, lang)

    local url = "http://127.0.0.1:1234/v1/chat/completions"
    local data = {
        model = "llama-3.2-3b-instruct",
        messages = {
            { role = "system", content = "You are a helpful assistant." },
            { role = "user",   content = prompt }
        },
        temperature = 0.7,
        max_tokens = 100
    }

    -- print("Prompting the model...")
    -- print(prompt)

    local response = curl.post(url, {
        body = vim.fn.json_encode(data),
        headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if response.status == 200 then
        local response_json = vim.fn.json_decode(response.body)
        if response_json and response_json.choices and response_json.choices[1] and response_json.choices[1].message then
            local content = response_json.choices[1].message.content
            content = parse_code_from_output(lang, content)
            local lines = vim.split(content, "\n")

            vim.api.nvim_set_current_line(lines[1])
            if #lines > 1 then
                vim.api.nvim_buf_set_lines(bufnr, vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[1],
                    false, vim.list_slice(lines, 2))
            end
            vim.cmd("normal! ==")
        else
            print("Unexpected response format.")
        end
    else
        print("Error: " .. response.status)
    end
end

-- Create a shortcut to call the inline_prompt function in normal mode
vim.api.nvim_set_keymap('n', '<C-x>', ':lua inline_prompt()<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('i', '<C-x>', '<Esc>:lua inline_prompt()<CR>', { noremap = true, silent = true })
-- Create a shortcut to call the inline_prompt function in insert mode
