local opt = vim.opt
local keymap = vim.keymap
--------------------------------------
--basics
opt.relativenumber = true
opt.number = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.cursorline = true
opt.termguicolors = true
opt.clipboard:append("unnamedplus")
opt.iskeyword:append("-")
--------------------------------------
--automation

vim.api.nvim_command([[
	autocmd bufwritepost [^_]*.sass,[^_]*.scss  silent exec "!sass %:p %:r.css"
]])

vim.api.nvim_command([[
	autocmd bufwritepost *.scss  silent exec "!sass styles/style.scss styles/style.css"
]])

vim.api.nvim_command([[
	autocmd bufwritepost *.sass  silent exec "!sass styles/style.sass styles/style.css"
]])

--------------------------------------
--eseentail keymap ( for nvim tree to load )
keymap.set("n", "<F2>", "<cmd>NvimTreeToggle<CR>")
keymap.set("n", "td", "<cmd>ToggleTerm<CR>")
	 	  
