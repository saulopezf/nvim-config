--  Plugins needed for sweet completions.
--
-- 1.   nvim-cmp: Completion engine for nvim. Show the completion list but still
--      require third party plugins to get the sources.
--
-- 2.   LuaSnip: Snippet engine. Source of snippets for nvim-cmp.
--
-- 3.   cmp-luasnip: LuaSnip completion source.
--
-- 4.   rafamadriz/friendly-snippets: Collection of VSCode snippets.
--
-- 5.   cmp-nvim-lsp: Completions from LSP sources.
--
return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            -- Init nvim-cmp
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                -- Expand window config
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body) -- Init luasnip
                    end,
                },

                -- How the expand window looks
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                -- Keybinds for the expand window navigation
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),

                -- Sources
                sources = cmp.config.sources({
                    { name = "nvim_lsp" }, -- LSP Sources
                    { name = "luasnip" }, -- For luasnip users
                }, {
                    { name = "buffer" },
                }),
            })
        end,
    },
}
