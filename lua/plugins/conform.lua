return {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform will run multiple formatters sequentially
                -- python = { "black", "isort" },
                python = { "ruff_format" },
                -- Use a sub-list to run only the first available formatter
                -- javascript = { { "prettierd", "prettier" } },
                yaml = { "yamlfmt" },
                -- https://github.com/koalaman/shellcheck
                sh = { "shellcheck" },
            },
        })
        conform.setup({
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 5000,
                lsp_fallback = true,
            },
        })
    end
}
