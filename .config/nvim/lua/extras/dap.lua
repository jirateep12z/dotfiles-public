return {
	{
		"mfussenegger/nvim-dap",
		enabled = true,
		keys = {
			{
				";;d",
				"",
				silent = true,
				desc = "+Dep",
			},
			{
				";;db",
				function()
					local dap = require("dap")
					return dap.toggle_breakpoint()
				end,
				silent = true,
				desc = "Dep toggle breakpoint",
			},
			{
				";;dc",
				function()
					local dap = require("dap")
					return dap.continue()
				end,
				silent = true,
				desc = "Dep continue",
			},
			{
				";;di",
				function()
					local dap = require("dap")
					return dap.step_into()
				end,
				silent = true,
				desc = "Dep step into",
			},
			{
				";;dj",
				function()
					local dap = require("dap")
					return dap.down()
				end,
				silent = true,
				desc = "Dep down",
			},
			{
				";;dk",
				function()
					local dap = require("dap")
					return dap.up()
				end,
				silent = true,
				desc = "Dep up",
			},
			{
				";;do",
				function()
					local dap = require("dap")
					return dap.step_out()
				end,
				silent = true,
				desc = "Dep step out",
			},
			{
				";;dO",
				function()
					local dap = require("dap")
					return dap.step_over()
				end,
				silent = true,
				desc = "Dep step over",
			},
			{
				";;dt",
				function()
					local dap = require("dap")
					return dap.terminate()
				end,
				silent = true,
				desc = "Dep terminate",
			},
			{
				";;dw",
				function()
					local widgets = require("dap.ui.widgets")
					return widgets.hover()
				end,
				silent = true,
				desc = "Dep widgets",
			},
		},
	},
}
