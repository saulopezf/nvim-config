-- LSP (Lenguage server protocol)
-- To stablish the connection to LSP we will need some plugins
--      mason.nvim - manage the connection to LSP/DAP servers, linters and formatters
--      mason-lspconfig.nvim - bridges mason.nvim with the lspconfig plugin
--      nvim-lspconfig - Help => :help lspconfig
return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
        --  config = function()
        --	    require("mason-lspconfig").setup({
        --		    ensure_installed = { "lua_ls", "tsserver" },
        --	    })
        --  end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")
            lspconfig.tsserver.setup({
                capabilities = capabilities,
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })

            -- Keybinds
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
            vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
