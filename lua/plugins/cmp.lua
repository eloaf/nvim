return {
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            -- {' hrsh7th/cmp-path'},
            { 'FelipeLema/cmp-async-path' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-cmdline' },
            { 'hrsh7th/cmp-nvim-lsp' },
            --       name = 'nvim_lsp',
            { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'hrsh7th/nvim-cmp' },
            { 'neovim/nvim-lspconfig' },
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
        }
    },
}
