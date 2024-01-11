return {
	'akinsho/toggleterm.nvim',
	cmd = 'ToggleTerm',

	config = function() 
		require("toggleterm").setup()
		local keymap = vim.keymap
		keymap.set("n", "td", "<cmd>ToggleTerm<CR>")
		keymap.set("n", "tf", "<cmd>ToggleTerm direction=float<CR>")
	end


}
