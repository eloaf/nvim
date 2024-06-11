--- Uncomment the two plugins below if you want to manage the language servers from neovim
-- {'williamboman/mason.nvim'},
-- {'williamboman/mason-lspconfig.nvim'},
return {
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
        },
    },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/nvim-cmp' },
            -- { 'L3MON4D3/LuaSnip' }
        },
        config = function()
            local lsp_zero = require('lsp-zero')

            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
            end)
            -- K    : Displays hover information about the symbol under the cursor in a floating window. See :help vim.lsp.buf.hover().
            -- gd   : Jumps to the definition of the symbol under the cursor. See :help vim.lsp.buf.definition().
            -- gD   : Jumps to the declaration of the symbol under the cursor. Some servers don't implement this feature. See :help vim.lsp.buf.declaration().
            -- gi   : Lists all the implementations for the symbol under the cursor in the quickfix window. See :help vim.lsp.buf.implementation().
            -- go   : Jumps to the definition of the type of the symbol under the cursor. See :help vim.lsp.buf.type_definition().
            -- gr   : Lists all the references to the symbol under the cursor in the quickfix window. See :help vim.lsp.buf.references().
            -- gs   : Displays signature information about the symbol under the cursor in a floating window.
            --     See :help vim.lsp.buf.signature_help(). If a mapping already exists for this key this function is not bound.
            -- <F2> : Renames all references to the symbol under the cursor. See :help vim.lsp.buf.rename().
            -- <F3> : Format code in current buffer. See :help vim.lsp.buf.format().
            -- <F4> : Selects a code action available at the current cursor position. See :help vim.lsp.buf.code_action().
            -- gl   : Show diagnostics in a floating window. See :help vim.diagnostic.open_float().
            -- [d   : Move to the previous diagnostic in the current buffer. See :help vim.diagnostic.goto_prev().
            -- ]d   : Move to the next diagnostic. See :help vim.diagnostic.goto_next().
            -- -- here you can setup the language servers

            -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
            require("neodev").setup({
                -- add any options here, or leave empty to use the default settings
            })

            -- then setup your lsp server as usual
            local lspconfig = require('lspconfig')

            -- Set up lspconfig.
            -- TODO: Other LSPs? Yaml? Json?
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            lspconfig['pyright'].setup({
                capabilities = capabilities
            })
            -- configure for rust (clippy)
            -- lspconfig['rust_analyzer'].setup({
            --     capabilities = capabilities,
            --     settings = {
            --         ["rust-analyzer"] = {
            --             checkOnSave = {
            --                 command = "clippy"
            --             }
            --         }
            --     }
            -- })
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

            -- Start the lsp only when we open sh?
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'sh',
                callback = function()
                    vim.lsp.start({
                        name = 'bash-language-server',
                        cmd = { 'bash-language-server', 'start' },
                    })
                end,
            })

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
            -- lspconfig.pyright.setup({})
            -- example to setup lua_ls and enable call snippets
        end
    },
}
