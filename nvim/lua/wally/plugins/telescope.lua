return {
    'nvim-telescope/telescope.nvim', tag = '0.1.4',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
	local keymap = vim.keymap
	keymap.set("n", "<F3>", "<cmd>Telescope find_files<CR>")
	keymap.set("n", "<F4>", "<cmd>Telescope help_tags<CR>")
	keymap.set("n", "<F5>", "<cmd>Telescope git_commits<CR>")
	keymap.set("n", "<F6>", "<cmd>Telescope git_status<CR>")
	end,
    }

--------------------------------------------
--SOME KEYS in telescope
--ctrl + x ---> split file horizontally
--ctrl + v ---> split file vertically
--ctrl + u , ctrl + d---> move up and down in previewed window
--ctrl + w + w ---> jump between splited windows
--ctrl + t ---> to open it as a tab and :q return to your file
--enter ---> go to file
--------------------------------------------
