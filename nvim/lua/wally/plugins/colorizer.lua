return {
	'norcalli/nvim-colorizer.lua',
	ft = {"html", "javascript", "javascriptreact", "css"},
	config = function()
		local colorizer = require("colorizer")
		colorizer.setup{
			javascript = {

    		mode = 'background',
			RGB      = true,
			RRGGBB   = true,
			names    = true,
			RRGGBBAA = true,
			rgb_fn   = true,
			hsl_fn   = true,
			css      = true,
			css_fn   = true,
			},
			sass = {

    		mode = 'background',
			RGB      = true,
			RRGGBB   = true,
			names    = true,
			RRGGBBAA = true,
			rgb_fn   = true,
			hsl_fn   = true,
			css      = true,
			css_fn   = true,
			},
			scss = {

    		mode = 'background',
			RGB      = true,
			RRGGBB   = true,
			names    = true,
			RRGGBBAA = true,
			rgb_fn   = true,
			hsl_fn   = true,
			css      = true,
			css_fn   = true,
			},
			css={

    		mode = 'background',
			RGB      = true,
			RRGGBB   = true,
			names    = true,
			RRGGBBAA = true,
			rgb_fn   = true,
			hsl_fn   = true,
			css      = true,
			css_fn   = true,
			},
  			html = {
    		mode = 'background',
			RGB      = true,
			RRGGBB   = true,
			names    = true,
			RRGGBBAA = true,
			rgb_fn   = true,
			hsl_fn   = true,
			css      = true,
			css_fn   = true,
 		 },
	}

	end
}

-- it is orderd !!!!!!!!!!!!!!!
-- #RGB hex codes
-- #RRGGBB hex codes
-- "Name" codes like Blue
-- #RRGGBBAA hex codes
-- CSS rgb() and rgba() functions
-- CSS hsl() and hsla() functions
-- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
