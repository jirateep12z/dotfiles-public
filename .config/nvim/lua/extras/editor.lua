return {
	{
		"smjonas/inc-rename.nvim",
		enabled = true,
		keys = {
			{
				";rn",
				function()
					return ":IncRename "
				end,
				silent = true,
				desc = "Rename",
			},
		},
	},
	{
		"ThePrimeagen/refactoring.nvim",
		enabled = true,
		keys = {
			{
				";rf",
				function()
					local telescope = require("telescope")
					return telescope.load_extension("refactoring").refactors()
				end,
				silent = true,
				desc = "Refactor",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		enabled = true,
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				";f",
				function()
					local builtin = require("telescope.builtin")
					return builtin.find_files()
				end,
				silent = true,
				desc = "Telescope find files",
			},
			{
				";l",
				function()
					local builtin = require("telescope.builtin")
					return builtin.live_grep()
				end,
				silent = true,
				desc = "Telescope live grep",
			},
			{
				"\\\\",
				function()
					local builtin = require("telescope.builtin")
					return builtin.buffers()
				end,
				silent = true,
				desc = "Telescope buffers",
			},
			{
				";h",
				function()
					local builtin = require("telescope.builtin")
					return builtin.help_tags()
				end,
				silent = true,
				desc = "Telescope help tags",
			},
			{
				";d",
				function()
					local builtin = require("telescope.builtin")
					return builtin.diagnostics()
				end,
				silent = true,
				desc = "Telescope diagnostics",
			},
			{
				";t",
				function()
					local telescope = require("telescope")
					return telescope.load_extension("todo-comments").todo()
				end,
				silent = true,
				desc = "Telescope todo comments",
			},
			{
				"sf",
				function()
					local telescope = require("telescope")
					return telescope.load_extension("file_browser").file_browser()
				end,
				silent = true,
				desc = "Telescope file browser",
			},
		},
		opts = function(_, opts)
			local telescope = require("telescope")
			local file_browser_actions = telescope.load_extension("file_browser").actions
			opts.defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				sorting_strategy = "ascending",
				initial_mode = "normal",
			}
			opts.extensions = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = { "--hidden" },
				},
				file_browser = {
					path = "%:p:h",
					cwd = vim.fn.expand("%:p:h"),
					grouped = true,
					hidden = true,
					previewer = true,
					mappings = {
						["n"] = {
							["n"] = file_browser_actions.create,
							["d"] = file_browser_actions.remove,
							["r"] = file_browser_actions.rename,
							["c"] = file_browser_actions.copy,
						},
					},
				},
			}
		end,
	},
}
