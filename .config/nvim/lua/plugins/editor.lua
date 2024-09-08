return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
	},
	{
		"MagicDuck/grug-far.nvim",
		enabled = false,
	},
	{
		"folke/flash.nvim",
		enabled = false,
	},
	{
		"lewis6991/gitsigns.nvim",
		enabled = true,
		opts = {
			on_attach = function(buffer)
				local keymap = vim.keymap
				local gitsigns = package.loaded.gitsigns
				keymap.set("n", "gj", gitsigns.next_hunk, { silent = true, buffer = buffer, desc = "Git next hunk" })
				keymap.set(
					"n",
					"gk",
					gitsigns.prev_hunk,
					{ silent = true, buffer = buffer, desc = "Git previous hunk" }
				)
				keymap.set("n", "gd", gitsigns.diffthis, { silent = true, buffer = buffer, desc = "Git diff" })
			end,
		},
	},
	{
		"folke/todo-comments.nvim",
		enabled = true,
		keys = {
			{
				"tj",
				function()
					local todo_comments = require("todo-comments")
					return todo_comments.jump_next()
				end,
				silent = true,
				desc = "Next todo comment",
			},
			{
				"tk",
				function()
					local todo_comments = require("todo-comments")
					return todo_comments.jump_prev()
				end,
				silent = true,
				desc = "Previous todo comment",
			},
			{
				"td",
				function()
					local todo_comments = require("todo-comments")
					return todo_comments.jump_next({ "FIX", "FIXME", "BUG", "WARN" })
				end,
				silent = true,
				desc = "Next todo comment (FIX, FIXME, BUG, WARN)",
			},
		},
	},
	{
		"kdheepak/lazygit.nvim",
		enabled = true,
		keys = {
			{
				";lg",
				function()
					local lazygit = require("lazygit")
					return lazygit.lazygit()
				end,
				silent = true,
				desc = "Lazygit",
			},
		},
	},
	{
		"mg979/vim-visual-multi",
		enabled = true,
		init = function()
			vim.g.VM_default_mappings = 0
			vim.g.VM_maps = {
				["Switch Mode"] = "<tab>",
				["Find Under"] = "<c-n>",
				["Find Subword Under"] = "<c-n>",
				["Select All"] = "<c-f>",
				["Add Cursor Down"] = "<c-down>",
				["Add Cursor Up"] = "<c-up>",
			}
		end,
	},
}
