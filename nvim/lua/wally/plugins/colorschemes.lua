return {
	"navarasu/onedark.nvim",


	  lazy = false,
	  performance = {
		  cache = {
			enabled = true,
		  },
	  },
	  priority = 1000,
	  opts = {},
	 config = function()
		 require("onedark").setup {
			 style = "deep"
		 }
	 	  vim.cmd([[hi! link EndOfBuffer Ignore]])
	 	  vim.cmd([[colorscheme onedark]])
	  end,
}
