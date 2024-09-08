return {
	{
		"rcarriga/nvim-notify",
		enabled = true,
		opts = {
			render = "wrapped-compact",
		},
	},
	{
		"akinsho/bufferline.nvim",
		enabled = true,
		keys = {
			{
				"<tab>",
				function()
					local bufferline = require("bufferline")
					return bufferline.move_to(1)
				end,
				silent = true,
				desc = "Next tab",
			},
			{
				"<s-tab>",
				function()
					local bufferline = require("bufferline")
					return bufferline.move_to(-1)
				end,
				desc = "Previous tab",
			},
		},
		opts = {
			options = {
				mode = "tabs",
			},
		},
	},
	{
		"folke/noice.nvim",
		enabled = true,
		opts = function(_, opts)
			local focused = true
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = {
					skip = true,
				},
			})
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = {
					stop = false,
				},
			})
		end,
	},
}
