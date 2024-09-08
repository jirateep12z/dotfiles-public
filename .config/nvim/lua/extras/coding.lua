return {
	{
		"Exafunction/codeium.vim",
		enabled = true,
		config = function()
			local keymap = vim.keymap
			keymap.set("i", "<c-a>", function()
				return vim.fn["codeium#Accept"]()
			end, { silent = true, expr = true, desc = "Codeium accept" })
			keymap.set("i", "]]", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { silent = true, expr = true, desc = "Codeium cycle completions" })
			keymap.set("i", "[[", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { silent = true, expr = true, desc = "Codeium cycle completions" })
			vim.g.codeium_filetypes = {
				["*"] = true,
			}
		end,
	},
	{
		"danymat/neogen",
		enabled = true,
		keys = {
			{
				";cn",
				function()
					local neogen = require("neogen")
					neogen.generate()
				end,
				desc = "Neogen generate",
			},
		},
	},
}
