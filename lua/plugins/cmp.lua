return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { "rafamadriz/friendly-snippets" },
            { 'hrsh7th/cmp-path' },
            { 'FelipeLema/cmp-async-path' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/nvim-cmp' },
            { 'neovim/nvim-lspconfig' },
        },
        config = function()
            -- TODO Seems like lua lsp is not used??
            local cmp = require('cmp')

            require('luasnip.loaders.from_vscode').lazy_load()
            -- https://www.reddit.com/r/neovim/comments/160vhde/is_there_a_method_to_prevent_nvimcmp_from/


            cmp.setup({
                -- TODO
                -- enabled = function()
                --     -- disable completion if the cursor is `Comment` syntax group.
                --     cmp = require('cmp')
                --     print()
                --     return not cmp.config.context.in_syntax_group('Comment')
                -- end,
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                sources = {
                    -- { name = "copilot",  group_index = 2 },
                    { name = "nvim_lsp",   group_index = 1 },
                    { name = "luasnip",    group_index = 1 },
                    { name = "nvim_lua",   group_index = 1 },
                    { name = 'async_path', group_index = 1 },
                    -- { name = 'nvim_lsp_signature_help', group_index = 1 },
                    {
                        -- All buffers
                        name = 'buffer',
                        group_index = 2,
                        option = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end
                        }
                    },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

                    -- ["<CR>"] = cmp.mapping.confirm({
                    --     behavior = cmp.ConfirmBehavior.Replace,
                    --     select = false,
                    -- }),
                    -- ['<C-n>'] = cmp.complete(),
                    ['<C-m>'] = cmp.mapping.select_prev_item(),
                    ['<C-k>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-j>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

                    -- ['<C-f>'] = cmp_action.luasnip_jump_forward(),
                    -- ['<C-b>'] = cmp_action.luasnip_jump_backward(),
                }),
                window = {
                    max_height = 40,
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                view = {
                    -- https://github.com/hrsh7th/nvim-cmp/issues/910
                    -- entries = { name = 'custom', selection_order = 'bottom_up' }
                    entries = { name = 'custom', selection_order = 'near_cursor' }
                },
                sorting = {
                    priority_weight = 1,
                    comparators = {
                        -- TODO improve
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        -- cmp.config.compare.kind, -- Sorts by the type (function, variable, etc.)
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },

                },
                formatting = {

                    -- format = function(entry, vim_item)
                    --     -- Kind icons
                    --     vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                    --     -- Source
                    --     vim_item.menu = ({
                    --         buffer = "[Buffer]",
                    --         nvim_lsp = "[LSP]",
                    --         luasnip = "[LuaSnip]",
                    --         nvim_lua = "[Lua]",
                    --         latex_symbols = "[LaTeX]",
                    --     })[entry.source.name]
                    --     return vim_item
                    -- end

                    format = require("lspkind").cmp_format({
                        mode = 'text_symbol', -- show only symbol annotations
                        maxwidth = 30,        -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
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

            -- `/` cmdline setup.
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- `:` cmdline setup.
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
                })
            })
            -- cmp.setup {
            --     enabled = function()
            --         -- disable completion if the cursor is `Comment` syntax group.
            --         return not cmp.config.context.in_syntax_group('Comment')
            --     end
            -- }
        end
    }
}
