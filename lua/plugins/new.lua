return {
    {
        'nvim-pack/nvim-spectre',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('spectre').setup()
            vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
                desc = "Toggle Spectre"
            })
            vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
                desc = "Search current word"
            })
            vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
                desc = "Search current word"
            })
            vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
                desc = "Search on current file"
            })
        end
    },
    {
        "RRethy/vim-illuminate",
        config = function()
        end
    },
    {
        "danymat/neogen",
        config = function()
            require('neogen').setup({})
            vim.keymap.set('n', '<leader>a', ":lua require('neogen').generate()<CR>")
        end
        -- Uncomment next line if you want to follow only stable versions
        -- version = "*"
    },
    {
        'kevinhwang91/nvim-bqf',
        config = function()
            require('bqf').setup({})
        end
    },
    {
        'Wansmer/treesj',
        keys = { '<space>m', '<space>j', '<space>s' },
        dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
        config = function()
            require('treesj').setup({
                use_default_keymaps = false,
            })
            -- :lua require('treesj').toggle()
            -- :lua require('treesj').split()
            -- :lua require('treesj').join()
            vim.keymap.set('n', '<space>jj', ':lua require("treesj").toggle()<CR>', {
                desc = "Toggle Treesitter"
            })
            -- vim.keymap.set('n', '<space>jj', ':lua require("treesj").join()<CR>', {
            --     desc = "Join Treesitter"
            -- })
            -- vim.keymap.set('n', '<space>js', ':lua require("treesj").split()<CR>', {
            --     desc = "Split Treesitter"
            -- })
        end,
    },
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    --     ---@type Flash.Config
    --     opts = {},
    --     -- stylua: ignore
    --     keys = {
    --         { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    --         { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    --         { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    --         { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    --         { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    --     },
    -- }
}
