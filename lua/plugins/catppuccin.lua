-- Catppuccin
-- Color scheme plugin
return {
	"catppuccin/nvim",
	lazy = false,
	name = "catppuccin",
	priority = 1000,
	config = function()
		-- Init Catppuccin (Color scheme)
		-- require("catppuccin").setup() not needed
		vim.cmd.colorscheme("catppuccin")
	end,
}
