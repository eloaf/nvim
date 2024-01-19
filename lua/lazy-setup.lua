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

---------------
-- LSP setup --
---------------
local lsp_zero = require('lsp-zero')

-- TODO I dont understand this
lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- https://github.com/folke/neodev.nvim
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
-- add any options here, or leave empty to use the default settings
require("neodev").setup({})

-- -- then setup your lsp server as usual
local lspconfig = require('lspconfig')

-- example to setup lua_ls and enable call snippets
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
})

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
lspconfig.pyright.setup({})



-- TODO: Other LSPs? Yaml? Json?

-- https://www.reddit.com/r/neovim/comments/u3c3kw/how_do_you_sorting_cmp_completions_items/
local cmp = require('cmp')
local compare = cmp.config.compare
cmp.setup({
    sources = {
        { name = "copilot",  group_index = 2 },
        { name = "nvim_lsp", group_index = 2 },
        { name = "luasnip",  group_index = 2 },
        { name = "path",     group_index = 2 },
    },
    mapping = cmp.mapping.preset.insert({
        -- ["<CR>"] = cmp.mapping.confirm({
        --     behavior = cmp.ConfirmBehavior.Replace,
        --     select = false,
        -- }),
        ['<C-m>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    sorting = {
        priority_weight = 1,
        comparators = {
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        }
    },
    formatting = {
        format = require("lspkind").cmp_format({
            mode = 'symbol', -- show only symbol annotations
            maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
            ellipsis_char = '...',    -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            show_labelDetails = true, -- show labelDetails in menu. Disabled by default
            symbol_map = { Copilot = "" },

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            -- before = function (entry, vim_item)
            --     ...
            --     return vim_item
            -- end
        })
    }
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

-----------------
-- Refactoring --
-----------------
-- vim.keymap.set("x", "<leader>re", ":Refactor extract ")
-- vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
--
-- vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
--
-- vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
--
-- vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")
--
-- vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
-- vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
vim.keymap.set("x", "<leader>re", function() require('refactoring').refactor('Extract Function') end)
vim.keymap.set("x", "<leader>rf", function() require('refactoring').refactor('Extract Function To File') end)
-- Extract function supports only visual mode
vim.keymap.set("x", "<leader>rv", function() require('refactoring').refactor('Extract Variable') end)
-- Extract variable supports only visual mode
vim.keymap.set("n", "<leader>rI", function() require('refactoring').refactor('Inline Function') end)
-- Inline func supports only normal
vim.keymap.set({ "n", "x" }, "<leader>ri", function() require('refactoring').refactor('Inline Variable') end)
-- Inline var supports both normal and visual mode

vim.keymap.set("n", "<leader>rb", function() require('refactoring').refactor('Extract Block') end)
vim.keymap.set("n", "<leader>rbf", function() require('refactoring').refactor('Extract Block To File') end)
-- Extract block supports only normal mode

-- load refactoring Telescope extension
require("telescope").load_extension("refactoring")

vim.keymap.set(
    { "n", "x" },
    "<leader>rr",
    function() require('telescope').extensions.refactoring.refactors() end
)



-- cmp.setup {
--   formatting = {
--     format = lspkind.cmp_format({
--       mode = 'symbol', -- show only symbol annotations
--       maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
--                      -- can also be a function to dynamically calculate max width such as
--                      -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
--       ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
--       show_labelDetails = true, -- show labelDetails in menu. Disabled by default
--
--       -- The function below will be called before any actual modifications from lspkind
--       -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
--       before = function (entry, vim_item)
--         ...
--         return vim_item
--       end
--     })
--   }
-- }

-- sources = {
--   -- Copilot Source
--   { name = "copilot", group_index = 2 },
--   -- Other Sources
--   { name = "nvim_lsp", group_index = 2 },
--   { name = "path", group_index = 2 },
--   { name = "luasnip", group_index = 2 },
-- },

-- local cmp_action = require('lsp-zero').cmp_action()

-- print("CMP")
-- cmp.setup({
--     mapping = cmp.mapping.preset.insert({
--         -- `Enter` key to confirm completion
--         ['<CR>'] = cmp.mapping.confirm({select = false}),
--
--         -- Ctrl+Space to trigger completion menu
--         ['<C-Space>'] = cmp.mapping.complete(),
--
--         -- Navigate between snippet placeholder
--         ['<C-f>'] = cmp_action.luasnip_jump_forward(),
--         ['<C-b>'] = cmp_action.luasnip_jump_backward(),
--
--         -- Scroll up and down in the completion documentation
--         ['<C-u>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-d>'] = cmp.mapping.scroll_docs(4),
--     })
-- })
