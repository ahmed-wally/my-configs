return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	config = function() 
		require('nvim-treesitter.configs').setup{
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = true
			},
			rainbow = {
				enable=true,
				extended_mode=true
			},
		}
	end
}

-- install language you want highlighting with :TSInstall lang
