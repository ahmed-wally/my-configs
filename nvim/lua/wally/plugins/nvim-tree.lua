return {
	-- 'DaikyXendo/nvim-tree.lua',
	'nvim-tree/nvim-tree.lua',
	cmd = 'NvimTreeToggle',
	dependencies = {
		'nvim-tree/nvim-web-devicons',
		-- 'DaikyXendo/nvim-material-icon'
	},
	config = function()
		local nvimtree = require("nvim-tree")
		nvimtree.setup({
			view = {
				width = 30,
				relativenumber = true,
			},
			renderer = {
				root_folder_label = false,
			}
		}
	)
	local keymap = vim.keymap
	keymap.set("n", "<F2>", "<cmd>NvimTreeToggle<CR>")
	end,
}
