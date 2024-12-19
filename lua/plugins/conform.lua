return {
    "stevearc/conform.nvim",
    opts = {},
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format", "ruff_organize_imports" },
                yaml = { "yamlfmt" },
                sh = { "shellcheck" },
            },
        })
        conform.setup({
            format_on_save = {
                -- These options will be passed to conform.format()
                timeout_ms = 1000,
                lsp_fallback = true,
            },
        })
    end
}
