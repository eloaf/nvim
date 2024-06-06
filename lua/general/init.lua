vim.opt.encoding = "utf8"
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- show line numbers in a pretty way
vim.cmd [[
  set number
  set numberwidth=1
]]
vim.opt.number = true
-- vim.opt.relativenumber = true


-- Etc
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- vim.opt.smartindent = true
vim.opt.smartindent = false

-- vim.opt.wrap = false
vim.opt.wrap = true

-- To get long undo history??
vim.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
-- incremental search
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- vim.cmd.colorscheme("wildcharm")

-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- TODO: https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim
-- shortcut for this!

function Delete_blank_lines_in_visual_selection()
    vim.cmd('\'<,\'>g/^$/d')
end

vim.api.nvim_set_keymap('v', '<leader>dl', '<Cmd>lua Delete_blank_lines_in_visual_selection()<CR>',
    { noremap = true, silent = true })

-- vim.api.nvim_set_keymap('n', '<C-j>', '<C-L><zz>', { noremap = true })
-- vim.api.nvim_set_keymap('n', '<C-k>', '<C-H><zz>', { noremap = true })

local function count_space_prefix(current_line_text)
    local count = 0
    for i = 1, #current_line_text do
        if current_line_text:sub(i, i) == " " then
            count = count + 1
        else
            break
        end
    end
    return count
end


--- @param current_line integer
--- @param n_lines integer
--- @param count integer
--- @return integer, integer
function FindNextLineDifferentSpaceCount(current_line, n_lines, count)
    local next_line_space_count = count
    local next_line = current_line
    for i = current_line, n_lines do
        local line_text = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]
        if line_text == nil then
            break
        end
        local c = count_space_prefix(line_text)
        if c ~= count and (c == 0 and count ~= 0) then
            next_line_space_count = c
            next_line = i + 1
            break
        end
    end
    return next_line, next_line_space_count
end

--- @param current_line integer
--- @param count integer
--- @return integer, integer
function FindPreviousLineDifferentSpaceCount(current_line, count)
    local previous_line_space_count = count
    local previous_line = current_line
    for i = current_line - 1, 1, -1 do
        local line_text = vim.api.nvim_buf_get_lines(0, i, i + 1, false)[1]
        local c = count_space_prefix(line_text)
        if c ~= count and (c == 0 and count ~= 0) then
            previous_line_space_count = c
            previous_line = i
            break
        end
    end
    return previous_line, previous_line_space_count
end

--- @param forward boolean
--- @return integer
local function find_diff_leading_spaces(forward)
    local current_line_num = vim.api.nvim_win_get_cursor(0)[1]
    local buf_line_count = vim.api.nvim_buf_line_count(0)

    local current_line = vim.api.nvim_buf_get_lines(0, current_line_num - 1, current_line_num, false)[1]
    local current_spaces = #string.match(current_line, "^%s*")

    --- @param start integer
    --- @param step integer
    --- @return integer or nil
    local function find_line(start, step)
        local line_num = start
        local find_same = false
        while line_num >= 1 and line_num <= buf_line_count do
            local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
            local line_spaces = #string.match(line, "^%s*")

            if current_spaces ~= 0 and line_spaces == 0 then
                -- change the criteria to find the next line with the same indentation level
                find_same = true
            end

            if find_same and line_spaces == current_spaces then
                return line_num
            end

            if not find_same and current_spaces == 0 ~= line_spaces then
                return line_num
            end

            line_num = line_num + step
        end
        -- while line_num >= 1 and line_num <= buf_line_count do
        --     local line = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
        --     local line_spaces = #string.match(line, "^%s*")
        --
        --     if line_spaces ~= current_spaces or string.match(line, "^%s*$") then
        --         return line_num
        --     end
        --
        --     line_num = line_num + step
        -- end
        error("No line found")
    end

    local next_line_num = find_line(current_line_num + 1, 1)
    local prev_line_num = find_line(current_line_num - 1, -1)

    if forward then
        return next_line_num
    end
    return prev_line_num
end

function IndentMove(forward)
    local win = vim.api.nvim_get_current_win()
    local current_line = vim.api.nvim_win_get_cursor(win)[1]
    local buf = vim.api.nvim_win_get_buf(win)
    -- local n_lines = vim.api.nvim_buf_line_count(buf)

    local line_text = vim.api.nvim_buf_get_lines(buf, current_line - 1, current_line, true)[1]
    local current_position_space_count = count_space_prefix(line_text)

    local direction = -1
    if forward then
        direction = 1
    end

    local find_diff_leading_spaces = true
    local next_line_num = nil

    while true do
        local line = current_line + direction
        local line_text = vim.api.nvim_buf_get_lines(buf, line, line + 1, true)[1]
        if line_text == nil then
            break
        end
        local count = count_space_prefix(line_text)
        if find_diff_leading_spaces then
            if count ~= current_position_space_count then
                return line
            end
        else
            if count == current_position_space_count then
                return line
            end
        end
    end

    vim.api.nvim_win_set_cursor(win, { next_line_num, 0 })
end

vim.api.nvim_set_keymap('n', '[]', '<Cmd>lua IndentMove(true)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '][', '<Cmd>lua IndentMove(false)<CR>', { noremap = true, silent = true })

-- function MoveToNextIndentLevel(forward)
--     local win = vim.api.nvim_get_current_win()
--     local current_line = vim.api.nvim_win_get_cursor(win)[1]
--     local buf = vim.api.nvim_win_get_buf(win)
--     local n_lines = vim.api.nvim_buf_line_count(buf)
--
--     local next_line_num, prev_line_num = find_diff_leading_spaces()
--     print('next_line_num = ' .. next_line_num)
--     print('prev_line_num = ' .. prev_line_num)
-- -- find the next line with a different indentation level
-- local current_line_text = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
-- local count = count_space_prefix(current_line_text)
-- print(count)
--
-- -- if we hop through some empty lines, we will take the next line with the same indentation level
--
-- local next_line, next_line_space_count = FindNextLineDifferentSpaceCount(current_line, n_lines, count)
-- local previous_line, previous_line_space_count = FindPreviousLineDifferentSpaceCount(current_line, count)
--
-- print('next_line = ' .. next_line)
-- print('prevous_line = ' .. previous_line)
-- print('next_line_indentation_count = ' .. next_line_space_count)
-- print('previous_line_space_count = ' .. previous_line_space_count)
--
-- if next_line_space_count == previous_line_space_count then
--     print('No next line with different indentation level!')
--     if forward then
--         print('Moving to next line' .. next_line .. ' with indentation count ' .. next_line_space_count)
--         vim.api.nvim_win_set_cursor(win, { next_line, next_line_space_count })
--     else
--         print('Moving to previous line' ..
--             previous_line .. ' with indentation count ' .. previous_line_space_count)
--         vim.api.nvim_win_set_cursor(win, { previous_line, previous_line_space_count })
--     end
--     return
-- end
--
-- if forward then
--     vim.api.nvim_win_set_cursor(win, { next_line, next_line_space_count })
-- else
--     vim.api.nvim_win_set_cursor(win, { previous_line, previous_line_space_count })
-- end
-- end

-- vim.api.nvim_set_keymap('n', ']]', '<Cmd>lua MoveToSameIndentLevel(true)<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '[[', '<Cmd>lua MoveToNextIndentLevel(false)<CR>', { noremap = true, silent = true })
