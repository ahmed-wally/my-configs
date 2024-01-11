return {
	'danielvolchek/tailiscope.nvim',
	keys = {
		{"tw", "<cmd>Telescope tailiscope<CR>", desc="tailiscope init"},
	},
	-- ft = {"html", "javascript", "javascriptreact", "css"},
	dependencies = {'nvim-telescope/telescope.nvim'},
	config = function() 
	require('telescope').load_extension('tailiscope')
	local keymap = vim.keymap
	keymap.set("n", "tw", "<cmd>Telescope tailiscope<CR>")
	end
}

--go to ~/.local/nvim/lazy/tailiscope.nvim/lua/tailiscope/docs
--OR go to ~/.local/share/nvim/lazy/tailiscope.nvim/lua/tailiscope/docs
--mv Layout.lua layout.lua
--mv Backgrounds.lua backgrounds.lua
--mv Tables.lua tables.lua
--mv Spacing.lua spacing.lua
--mv Breakpoints.lua breakpoints.lua
