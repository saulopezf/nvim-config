-- Telescope
-- Search utility (find files, live grep, etc.)
-- If "rg" not found (:checkhealth telescope) => https://github.com/BurntSushi/ripgrep
--      telescope-ui-select - draw a telescope window for plugins popups (eg.: lsp_code_action)
return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local telescope_builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", telescope_builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, {})
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			-- This is your opts table
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
