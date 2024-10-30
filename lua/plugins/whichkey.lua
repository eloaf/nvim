return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix",
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        -- layout = {
        --     width = { min = 50, max = 100 }
        -- }
        win = {
            width = 100
        }
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
