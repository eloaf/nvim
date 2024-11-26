return {
    {
        "bluz71/vim-nightfly-colors"
    },
    {
        "rebelot/kanagawa.nvim"
    },
    { "navarasu/onedark.nvim" },
    { 'dasupradyumna/midnight.nvim', lazy = false, priority = 1000 },
    {
        "xero/miasma.nvim",
        lazy = false,
        priority = 1000,
        -- config = function()
        --     vim.cmd("colorscheme miasma")
        -- end,
    }
    -- {
    --     'sainnhe/everforest',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         -- Optionally configure and load the colorscheme
    --         -- directly inside the plugin declaration.
    --         vim.g.everforest_enable_italic = true
    --         vim.cmd.colorscheme('everforest')
    --     end
    -- },
    -- {
    --     "zaldih/themery.nvim",
    --     lazy = false,
    --     config = function()
    --         require("themery").setup({
    --             themes = { "gruvbox", "ayu", "kanagawa", "everforest", "onedark", "midnight" }, -- Your list of installed colorschemes.
    --             livePreview = true,                                                             -- Apply theme while picking. Default to true.
    --         })
    --     end
    -- }
}
