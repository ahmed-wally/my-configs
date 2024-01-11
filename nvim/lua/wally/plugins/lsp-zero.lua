return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      	'L3MON4D3/LuaSnip',
	  	"saadparwaiz1/cmp_luasnip", 
    	"onsails/lspkind.nvim",
		"rafamadriz/friendly-snippets", 
		"hrsh7th/cmp-buffer", 
    	"hrsh7th/cmp-path", 

    },
    config = function()
      local cmp = require('cmp')
	  local luasnip = require("luasnip")
	  local lspkind = require("lspkind")
    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()
      local lsp_zero = require('lsp-zero')
	  lsp_zero.extend_cmp()
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
		  ['<Tab>'] = cmp.mapping.confirm({select = false}),
          ['<C-Space>'] = cmp.mapping.complete(),
		  ["<C-b>"] = cmp.mapping.scroll_docs(-4),
		  ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ['<C-Up>'] = cmp_action.luasnip_jump_forward(),
          ['<C-Down>'] = cmp_action.luasnip_jump_backward(),
        }),

		sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
      }),
      
	completion = {
        completeopt = "menu,menuone,preview,noselect",
      },

	  snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

  })end},

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      -- This is where all the LSP shenanigans will live
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({buffer = bufnr})
      end)
-------------------------------------------------
-- TYPE HERE AFTER SEARCH ON :MASON
	require('mason-lspconfig').setup({
        ensure_installed = {
			'tsserver',
			'rust_analyzer',
			'html',
			'tailwindcss',
			'cssls',
			'pylsp',

		},
-------------------------------------------------
		handlers = {
			lsp_zero.default_setup,
		},
  })


    end
  }
}



