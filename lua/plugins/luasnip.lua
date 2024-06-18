return {
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        config = function()
            local ls = require("luasnip")

            -- require("luasnip.loaders.from_vscode").lazy_load()

            vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

            vim.keymap.set({ "i", "s" }, "<C-E>", function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end, { silent = true })
        end,
        dependencies = {
            { 'saadparwaiz1/cmp_luasnip' }
        }
    },
    {
        "benfowler/telescope-luasnip.nvim",
        config = function()
            require("telescope").load_extension("luasnip")
            vim.keymap.set("n", "<leader>ss", function() require("telescope").extensions.luasnip() end)
        end,
        dependencies = {
            { "nvim-telescope/telescope.nvim" },
            { "L3MON4D3/LuaSnip" }
        }
    },
    {
        "chrisgrieser/nvim-scissors",
        dependencies = { "nvim-telescope/telescope.nvim", "L3MON4D3/LuaSnip" },
        opts = {
            -- snippetDir = "path/to/your/snippetFolder",
            snippetDir = "~/.local/share/nvim/lazy/friendly-snippets/snippets/"
        },
        config = function()
            require("scissors").setup()
            -- vim.keymap.set("n", "<leader>se", function() require("scissors").editSnippet() end)
            -- -- When used in visual mode prefills the selection as body.
            -- vim.keymap.set({ "n", "x" }, "<leader>sa", function() require("scissors").addNewSnippet() end)
            local function editSnippet()
                require("scissors").editSnippet()
            end

            local function addNewSnippet()
                require("scissors").addNewSnippet()
            end

            vim.keymap.set("n", "<leader>se", editSnippet)
            vim.keymap.set({ "n", "x" }, "<leader>sa", addNewSnippet)
        end
    },
}
