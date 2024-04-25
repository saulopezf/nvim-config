-- none-ls.nvim
-- This is a fork from null-ls (deprecated)
-- Here we initialize linters and formatters as ESLint, Stylua, etc.
-- none-ls (null-ls) wrap command line tools (like ESLint, Prettier) to the LSP. Thanks to
-- this nvim has access to all the fromat and linting this cli tools have.
--
-- IMPORTANT - Linters and formatters used by none-ls.nvim need to be installed via Mason
-- :Mason
--
-- Init linters:
-- null_ls.builtins.diagnostics.xxxx
--
-- Init formatters:
-- null_ls.builtins.formatting.xxxx
return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		-- Init linters and formatters
		null_ls.setup({
			sources = {
				-- Lua
				null_ls.builtins.formatting.stylua,

				-- JS/TS
				null_ls.builtins.formatting.prettier,
				require("none-ls.diagnostics.eslint_d"), -- requires none-ls-extras.nvim
			},
		})

		-- Keybinds
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
