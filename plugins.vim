" Automatic installation of vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugin install at once but activate conditionally
function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin()

Plug 'kiyoon/vim-tmuxpaste'
Plug 'fisadev/vim-isort'
let g:vim_isort_map = '<C-i>'
Plug 'tpope/vim-surround'
"Plug 'tpope/vim-fugitive'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'		" vil, val to select line
Plug 'kana/vim-textobj-entire'	    " vie, vae to select entire buffer (file)
Plug 'kana/vim-textobj-fold'		" viz, vaz to select fold
Plug 'kana/vim-textobj-indent'		" vii, vai, viI, vaI to select indent

"Plug 'vim-python/python-syntax'
"let g:python_highlight_all = 1

Plug 'chaoren/vim-wordmotion'
let g:wordmotion_prefix = ','

" use normal easymotion when in VIM mode
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
" use VSCode easymotion when in VSCode mode
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })
" Use uppercase target labels and type as a lower case
"let g:EasyMotion_use_upper = 1
 " type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1

" \f{char} to move to {char}
" within line
map  <Leader>f <Plug>(easymotion-bd-fl)
map  <Leader>t <Plug>(easymotion-bd-tl)
map  <Leader>w <Plug>(easymotion-bd-wl)
map  <Leader>e <Plug>(easymotion-bd-el)
"nmap <Leader>f <Plug>(easymotion-overwin-f)

" \s{char}{char} to move to {char}{char}
" anywhere, even across windows
map  <Leader>s <Plug>(easymotion-bd-f2)
nmap <Leader>s <Plug>(easymotion-overwin-f2)

if !exists('g:vscode')
	Plug 'tpope/vim-commentary'

	"Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'neoclide/coc.nvim', {'tag': 'v0.0.81'}
	" (Default binding) Use <C-e> and <C-y> to cancel and confirm completion
	" I personally use <C-n> <C-p> to confirm completion without closing the popup.
	"
	" Toggle CoC diagnostics
	"nnoremap <silent> <F6> :call CocActionAsync('diagnosticToggle')<CR>
	" Show CoC diagnostics window
	nnoremap <silent> <F6> :CocDiagnostics<CR>
	" navigate diagnostics
	nmap <silent> <C-j> <Plug>(coc-diagnostic-next)
	nmap <silent> <C-k> <Plug>(coc-diagnostic-prev)
	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif
	" Remap keys for gotos
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	

	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'

	Plug 'github/copilot.vim'
else
	" tpope/vim-commentary behaviour for VSCode-neovim
	xmap gc  <Plug>VSCodeCommentary
	nmap gc  <Plug>VSCodeCommentary
	omap gc  <Plug>VSCodeCommentary
	nmap gcc <Plug>VSCodeCommentaryLine
endif

if has("nvim")
	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
	Plug 'EdenEast/nightfox.nvim'
	Plug 'nvim-lualine/lualine.nvim'

	Plug 'nvim-lua/plenary.nvim'
	Plug 'sindrets/diffview.nvim'
	nnoremap <leader>dv :DiffviewOpen<CR>
	nnoremap <leader>dc :DiffviewClose<CR>

	Plug 'lewis6991/gitsigns.nvim'

	Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
	Plug 'nvim-tree/nvim-tree.lua'
	nnoremap <leader>nt :NvimTreeToggle<CR>
	nnoremap <leader>nr :NvimTreeRefresh<CR>
	nnoremap <leader>nf :NvimTreeFindFile<CR>

	Plug 'lukas-reineke/indent-blankline.nvim'

	" Better syntax highlighting
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'

	Plug 'neovim/nvim-lspconfig'
endif

" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required


if !exists('g:vscode')
	call coc#add_extension('coc-pyright')
	call coc#add_extension('coc-sh')
	call coc#add_extension('coc-clangd')
	call coc#add_extension('coc-vimlsp')
	call coc#add_extension('coc-java')
	call coc#add_extension('coc-html')
	"call coc#add_extension('coc-css')
	call coc#add_extension('coc-json')
	call coc#add_extension('coc-yaml')
	call coc#add_extension('coc-markdownlint')
endif

if has("nvim")
	lua require('gitsigns').setup()

	lua require'lspconfig'.pyright.setup{}

lua << EOF
	-- disable netrw at the very start of your init.lua (strongly advised)
	--vim.g.loaded_netrw = 1
	--vim.g.loaded_netrwPlugin = 1

	-- set termguicolors to enable highlight groups
	vim.opt.termguicolors = true

	-- setup with some options
	require("nvim-tree").setup({
	  sort_by = "case_sensitive",
	  view = {
		adaptive_size = true,
		mappings = {
		  list = {
			{ key = "u", action = "dir_up" },
		  },
		},
	  },
	  renderer = {
		group_empty = true,
	  },
	  filters = {
		dotfiles = true,
	  },
	  remove_keymaps = {
		  '-',
	  }
	})
EOF
	

lua << EOF

	require('nvim-treesitter.configs').setup {
	  -- A list of parser names, or "all"
	  ensure_installed = { "c", "lua", "rust", "python", "bash", "json", "yaml", "html", "css", "vim", "java" },

	  -- Install parsers synchronously (only applied to `ensure_installed`)
	  sync_install = false,

	  -- Automatically install missing parsers when entering buffer
	  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	  auto_install = true,

	  -- List of parsers to ignore installing (for "all")
	  ignore_install = { "javascript" },

	  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	  highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = { "c", "rust" },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		-- Kiyoon note: it enables additional highlighting such as `git commit`
		additional_vim_regex_highlighting = true,
	  },

	  textobjects = {
		select = {
		  enable = true,

		  -- Automatically jump forward to textobj, similar to targets.vim
		  lookahead = true,

		  keymaps = {
			-- You can use the capture groups defined in textobjects.scm
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			-- You can optionally set descriptions to the mappings (used in the desc parameter of
			-- nvim_buf_set_keymap) which plugins like which-key display
			["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
		  },
		  -- You can choose the select mode (default is charwise 'v')
		  --
		  -- Can also be a function which gets passed a table with the keys
		  -- * query_string: eg '@function.inner'
		  -- * method: eg 'v' or 'o'
		  -- and should return the mode ('v', 'V', or '<c-v>') or a table
		  -- mapping query_strings to modes.
		  selection_modes = {
			['@parameter.outer'] = 'v', -- charwise
			['@function.outer'] = 'V', -- linewise
			['@class.outer'] = '<c-v>', -- blockwise
		  },
		  -- If you set this to `true` (default is `false`) then any textobject is
		  -- extended to include preceding or succeeding whitespace. Succeeding
		  -- whitespace has priority in order to act similarly to eg the built-in
		  -- `ap`.
		  --
		  -- Can also be a function which gets passed a table with the keys
		  -- * query_string: eg '@function.inner'
		  -- * selection_mode: eg 'v'
		  -- and should return true of false
		  include_surrounding_whitespace = true,
		},
		swap = {
		  enable = true,
		  swap_next = {
			["<leader>a"] = "@parameter.inner",
		  },
		  swap_previous = {
			["<leader>A"] = "@parameter.inner",
		  },
		},
		move = {
		  enable = true,
		  set_jumps = true, -- whether to set jumps in the jumplist
		  goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = { query = "@class.outer", desc = "Next class start" },
		  },
		  goto_next_end = {
			["]M"] = "@function.outer",
			["]["] = "@class.outer",
		  },
		  goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
		  },
		  goto_previous_end = {
			["[M"] = "@function.outer",
			["[]"] = "@class.outer",
		  },
		},
		lsp_interop = {
		  enable = true,
		  border = 'none',
		  peek_definition_code = {
			["<leader>df"] = "@function.outer",
			["<leader>dF"] = "@class.outer",
		  },
		},
	  },

	}
EOF


lua << EOF
	vim.opt.list = true
	vim.opt.listchars:append "space:⋅"
	--vim.opt.listchars:append "eol:↴"

	require("indent_blankline").setup {
		space_char_blankline = " ",
		show_current_context = true,
		show_current_context_start = true,
	}
EOF

lua << EOF
	require("tokyonight").setup({
	  -- your configuration comes here
	  -- or leave it empty to use the default settings
	  style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
	  light_style = "day", -- The theme is used when the background is set to light
	  transparent = false, -- Enable this to disable setting the background color
	  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
	  styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = true },
		keywords = { italic = true },
		functions = {},
		variables = {},
		-- Background styles. Can be "dark", "transparent" or "normal"
		sidebars = "dark", -- style for sidebars, see below
		floats = "dark", -- style for floating windows
	  },
	  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
	  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
	  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
	  dim_inactive = false, -- dims inactive windows
	  lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

	  --- You can override specific color groups to use other groups or a hex color
	  --- function will be called with a ColorScheme table
	  ---@param colors ColorScheme
	  on_colors = function(colors) end,

	  --- You can override specific highlights to use other groups or a hex color
	  --- function will be called with a Highlights and ColorScheme table
	  ---@param highlights Highlights
	  ---@param colors ColorScheme
	  on_highlights = function(highlights, colors) end,
	})
EOF
endif


