-- Debugging in nvim
-- Every language has his own debugger, so DAP (Debug Adapter Protocol) wrap
-- nvim text editor with the specific debugger.
-- :help dap.txt for more info
--
-- For debug with an UI we have nvim-dap-ui

-- Directory separator variable to know if we are in Windows
local is_windows_hell = package.config:sub(1, 1) == "\\"

-- Keywords for TS/JS languages
local js_languages = {
	"typescript",
	"javascript",
	"typescriptreact",
	"javascriptreact",
	"vue",
}

return {
	"mfussenegger/nvim-dap",
	config = function()
		local dap = require("dap")
		dap.set_log_level("DEBUG")

		if vim.fn.filereadable(".vscode/launch.json") then
			local dap_vscode = require("dap.ext.vscode")
			dap_vscode.load_launchjs(nil, {
                ["node"] = js_languages,
				["pwa-node"] = js_languages,
				["chrome"] = js_languages,
				["pwa-chrome"] = js_languages,
			})
		end

		-- for _, language in ipairs(js_languages) do
		-- 	dap.configurations[language] = {
		-- 		-- Debug single nodejs files
		-- 		{
		-- 			type = "pwa-node",
		-- 			request = "launch",
		-- 			name = "Launch file",
		-- 			program = "${file}",
		-- 			cwd = vim.fn.getcwd(),
		-- 			sourceMaps = true,
		-- 		},
		-- 		-- Debug nodejs processes (make sure to add --inspect when you run the process)
		-- 		{
		-- 			type = "pwa-node",
		-- 			request = "attach",
		-- 			name = "Attach",
		-- 			processId = require("dap.utils").pick_process,
		-- 			cwd = vim.fn.getcwd(),
		-- 			sourceMaps = true,
		-- 		},
		-- 		-- Debug web applications (client side)
		-- 		{
		-- 			type = "pwa-chrome",
		-- 			request = "launch",
		-- 			name = "Launch & Debug Chrome",
		-- 			url = function()
		-- 				local co = coroutine.running()
		-- 				return coroutine.create(function()
		-- 					vim.ui.input({
		-- 						prompt = "Enter URL: ",
		-- 						default = "http://localhost:3000",
		-- 					}, function(url)
		-- 						if url == nil or url == "" then
		-- 							return
		-- 						else
		-- 							coroutine.resume(co, url)
		-- 						end
		-- 					end)
		-- 				end)
		-- 			end,
		-- 			webRoot = vim.fn.getcwd(),
		-- 			protocol = "inspector",
		-- 			sourceMaps = true,
		-- 			userDataDir = false,
		-- 		},
		-- 		-- Divider for the launch.json derived configs
		-- 		{
		-- 			name = "----- ↓ launch.json configs ↓ -----",
		-- 			type = "",
		-- 			request = "launch",
		-- 		},
		-- 	}
		-- end

		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<leader>dc", dap.continue, {})
	end,
	dependencies = {
		-- Install nvim-dap-ui with his mandatory dependencies
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "nvim-neotest/nvim-nio" },
			config = function()
				local dap = require("dap")
				local dapui = require("dapui")

				require("dapui").setup()

				dap.listeners.before.attach.dapui_config = function()
					dapui.open()
				end
				dap.listeners.before.launch.dapui_config = function()
					dapui.open()
				end
				dap.listeners.before.event_terminated.dapui_config = function()
					dapui.close()
				end
				dap.listeners.before.event_exited.dapui_config = function()
					dapui.close()
				end
			end,
		},

		-- GOLANG --------------------------------------------------------------------------------------------------
		{
			"leoluz/nvim-dap-go",
			config = function()
				require("dap-go").setup()
			end,
		},
		-- GOLANG --------------------------------------------------------------------------------------------------

		-- TS/JS ---------------------------------------------------------------------------------------------------
		-- Install the vscode-js-debug adapter
		{
			"microsoft/vscode-js-debug",
			-- After install, build it and rename the dist directory to out
			-- If in Windows need to change the build command
			build = is_windows_hell
					and "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && (if exist out rmdir out /s /q) && mkdir out && xcopy dist out /s /e /h /y"
				or "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
			version = "1.*",
		},

		-- Install nvim-dap-vscode-js wrapping dap to TS/JS debugger
		{
			"mxsdev/nvim-dap-vscode-js",
			config = function()
				require("dap-vscode-js").setup({
					-- Path of node executable. Defaults to $NODE_PATH, and then "node"
					-- node_path = "node",

					-- Path to vscode-js-debug installation.
					debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

					-- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
					-- debugger_cmd = { "js-debug-adapter" },

					-- which adapters to register in nvim-dap
					adapters = {
						"chrome",
						"pwa-node",
						"pwa-chrome",
						"pwa-msedge",
						"pwa-extensionHost",
						"node-terminal",
					},

					-- Path for file logging
					-- log_file_path = "(stdpath cache)/dap_vscode_js.log",

					-- Logging level for output to file. Set to false to disable logging.
					-- log_file_level = false,

					-- Logging level for output to console. Set to false to disable console output.
					-- log_console_level = vim.log.levels.ERROR,
				})
			end,
		},
		-- TS/JS ---------------------------------------------------------------------------------------------------
		{
			"Joakker/lua-json5",
			build = is_windows_hell and "powershell ./install.ps1" or "./install.sh",
		},
	},
}
