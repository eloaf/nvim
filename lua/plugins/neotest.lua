return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/nvim-nio"
        },
    },
    {
        "nvim-neotest/neotest-python",
    },
    {
        'andythigpen/nvim-coverage',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-neotest/nvim-nio' }
        },
        -- config = function()
        --     require('nvim-coverage').setup()
        -- end
    }
}
