return {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                python = { "black", "isort" },
                -- Use a sub-list to run only the first available formatter
                -- javascript = { { "prettierd", "prettier" } },
                yaml = { "yamlfmt" },
            },
        })
        conform.setup({
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 2000,
                lsp_fallback = true,
            },
        })
    end
}
