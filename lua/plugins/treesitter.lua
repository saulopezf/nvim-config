-- Treesitter
-- Parser, highlighting, indent, etc.
-- On Windows needs C compiler (https://winlibs.com)
return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local tree_config = require("nvim-treesitter.configs")
		tree_config.setup({
			-- ensure_installed = { "lua", "javascript" },
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
