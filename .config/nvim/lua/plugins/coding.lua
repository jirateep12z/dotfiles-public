return {
	{
		"hrsh7th/nvim-cmp",
		enabled = true,
		dependencies = {
			"hrsh7th/cmp-emoji",
		},
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.mapping = cmp.mapping.preset.insert({
				["<c-space>"] = cmp.mapping.complete(),
				["<tab>"] = cmp.mapping.confirm(),
			})
			table.insert(opts.sources, { name = "emoji" })
		end,
	},
}
