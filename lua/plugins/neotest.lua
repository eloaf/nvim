return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter"
        },
    },
    {
        "nvim-neotest/neotest-python",
    },
    {
        'andythigpen/nvim-coverage',
        dependencies = {
            { 'nvim-lua/plenary.nvim' }
        },
        -- config = function()
        --     require('nvim-coverage').setup()
        -- end
    }
}
