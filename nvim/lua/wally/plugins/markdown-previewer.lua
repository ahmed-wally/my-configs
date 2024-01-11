return { 
	"iamcco/markdown-preview.nvim",
	build = "cd app && yarn install",
	event = function() vim.g.mkdp_filetypes = { "markdown" } end,
	ft = { "markdown" },
	config = function() 
	local keymap = vim.keymap
	keymap.set("n", "<F7>", "<cmd>MarkdownPreview<CR>")
	end
}


