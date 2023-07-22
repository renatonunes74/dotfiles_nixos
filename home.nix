{ config, pkgs, ... }:

{
	home.username = "void";
	home.homeDirectory = "/home/void";
	home.stateVersion = "23.05"; # Please read the comment before changing.
		home.packages = [
		pkgs.android-tools
			pkgs.dunst
			pkgs.chromium
			pkgs.mutt
			pkgs.sfeed
			pkgs.nsxiv
			pkgs.fasd
			pkgs.maim
			pkgs.python3Minimal
			pkgs.nodePackages.typescript
			pkgs.nodePackages.typescript-language-server
			pkgs.xdragon
#			pkgs.nodePackages.vscode-html-languageserver-bin
#		pkgs.nodePackages.vscode-langservers-extracted
			pkgs.nodePackages.yaml-language-server
			pkgs.nodejs
			pkgs.ripgrep
			pkgs.rnix-lsp
#pkgs.sumneko-lua-language-server
			pkgs.vimv
			pkgs.xclip
			pkgs.zoxide
			pkgs.tree-sitter
			pkgs.solvespace
			pkgs.xcolor
			pkgs.exiftool
			pkgs.mimeo
			pkgs.taskwarrior
			pkgs.timewarrior
			pkgs.hledger
			pkgs.hledger-web
#pkgs.hledger-iadd
			pkgs.nodePackages.create-react-app
#pkgs.nodePackages.vscode-css-languageserver-bin
			pkgs.jdt-language-server
			];

	home.sessionVariables = {
		EDITOR="nvim";
		FZF_DEFAULT_OPTS="--reverse --border sharp --cycle --multi --prompt='' --bind=tab:down,btab:up,ctrl-a:select-all,ctrl-space:toggle+down --color=bw --preview='less {}'";
	};

	programs.home-manager.enable = true;
	services.dunst = {
		enable = true;
		settings = {
			global = {
				font = "tamzen 8";
				frame_width = 1;
				frame_color = "#005577";
				background = "#0a0f14";
				foreground = "#99d1ce";
			};
		};
	};
	programs.zathura = {
		enable = true;
		extraConfig = ''
			set selection-clipboard clipboard
			'';
	};

	programs.neovim = {
		enable = true;
#defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		extraLuaConfig = ''
			-- bullets-vim
			vim.cmd("let g:bullets_outline_levels = ['ROM', 'ABC', 'num', 'abc', 'rom', 'std-']")
			-- Requires
			-- Auto pairs
			require "pears".setup()

			-- Tressitter
			require'nvim-treesitter.configs'.setup {
				-- ensure_installed = "all",
					indent = {
						enable = true,
					},
					highlight = {
						enable = true,
						additional_vim_regex_highlighting = true
					},
			}
		-- Comment
			require('Comment').setup()

			-- Spectre / auto replace
			vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").open()<CR>')
			vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>')
			vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>')
			vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>')

			require('spectre').setup({
					color_devicons = false,
					live_update = true,
					})

		-- Git message
			require('gitsigns').setup {
				current_line_blame = true,
			}

		-- Config
			vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
			vim.o.completeopt = "menuone,noselect"

			-- Keymaps
			vim.g.mapleader = " "
			vim.g.maplocalleader = " "

			vim.opt.backspace = "2"

			vim.cmd('filetype on')
			-- vim.cmd('source $HOME/nix/gotham.vim')
			vim.cmd('syntax on')

			-- Copy selected code with VISUAL + Leader + y
			vim.cmd('vnoremap <silent><Leader>y "yy <Bar> :call system("xclip -selection clipboard", @y)<CR>: echo "Copiado com sucesso"<CR>')

			vim.cmd('set nuw=1')
			vim.wo.number = true
			vim.wo.relativenumber = true

			-- Easy motion
			vim.api.nvim_set_keymap("", '<Leader>w', '<Plug>(easymotion-bd-w)', {})

			-- highlighter
			vim.cmd('set termguicolors')
			require('nvim-highlight-colors').setup {}

		-- Snippet

			-- Vim rooter alternative
			-- Array of file names indicating root directory. Modify to your liking.
			local root_names = { '.git', 'Makefile', 'App.tsx', 'Gemfile' }

		-- Cache to use for speed up (at cost of possibly outdated results)
			local root_cache = {}

		local set_root = function()
			-- Get directory path to start search from
			local path = vim.api.nvim_buf_get_name(0)
			if path == "" then return end
				path = vim.fs.dirname(path)

					-- Try cache and resort to searching upward for root directory
					local root = root_cache[path]
					if root == nil then
						local root_file = vim.fs.find(root_names, { path = path, upward = true })[1]
							if root_file == nil then return end
								root = vim.fs.dirname(root_file)
									root_cache[path] = root
									end
									-- Set current directory
									vim.fn.chdir(root)
									end
									local root_augroup = vim.api.nvim_create_augroup('MyAutoRoot', {})
									vim.api.nvim_create_autocmd('BufEnter', { group = root_augroup, callback = set_root })


									-- Open files list FZF for with Leader + f
									vim.keymap.set("n", "<leader>f", vim.cmd.Files)

									-- Open files content RG with Leader + s
									vim.keymap.set("n", "<leader>s", vim.cmd.Rg)

									-- Open Git logs FZF with Ctrl + p
									vim.keymap.set("n", "<C-p>", vim.cmd.GitFiles)

									-- Others
									vim.api.nvim_set_keymap('n', '<Leader>b', ':Buffers<CR>', { silent = trun })
									-- Open directories list FZF for :Ex with Leader + p
									vim.api.nvim_set_keymap('n', '<Leader>p', ':Cd<CR>', { silent = trun })
									vim.api.nvim_set_keymap('n', '<Leader>g', ':Commits<CR>', { silent = true })
									vim.api.nvim_set_keymap('n', 'q', ':x<CR>', { silent = true })
									vim.api.nvim_set_keymap('n', 'Q', ':bd<CR>', { silent = true })
									vim.api.nvim_set_keymap('n', '<Leader>H', ':Helptags<CR>', { silent = true })
									vim.api.nvim_set_keymap('n', '<Leader>hh', ':History<CR>', { silent = true })
									vim.api.nvim_set_keymap('n', '<Leader>h:', ':History:<CR>', { silent = true })
									vim.api.nvim_set_keymap('n', '<Leader>h/', ':History/<CR>', { silent = true })

									-- Lsp servers
									require'lspconfig'.tsserver.setup{}
		-- require'lspconfig'.typescript-language-server.setup{}
		require'lspconfig'.rnix.setup{}
		-- require'lspconfig'.sumneko_lua.setup{}
		require'lspconfig'.html.setup{}
		require'lspconfig'.cssls.setup{}
		require'lspconfig'.jsonls.setup{}

		-- ???
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.textDocument.completion.completionItem.resolveSupport = {
				properties = {
					'documentation',
					'detail',
					'additionalTextEdits',
				}
			}
		-- Nvim compe
			require'compe'.setup {
				enabled = true;
				autocomplete = true;
				debug = false;
				min_length = 1;
				preselect = 'enable';
				throttle_time = 80;
				source_timeout = 200;
				resolve_timeout = 800;
				incomplete_delay = 400;
				max_abbr_width = 100;
				max_kind_width = 100;
				max_menu_width = 100;
				documentation = {
					border = { "", "" ,"", " ", "", "", "", " " }, -- the border option is the same as `|help nvim_open_win|`
						winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
					max_width = 120,
					min_width = 60,
					max_height = math.floor(vim.o.lines * 0.3),
					min_height = 1,
				};

				source = {
					path = true;
					buffer = true;
					calc = true;
					nvim_lsp = true;
					nvim_lua = true;
					vsnip = true;
					ultisnips = true;
					luasnip = true;
					treesitter = true;
				};
			}


		local t = function(str)
			return vim.api.nvim_replace_termcodes(str, true, true, true)
			end

			local check_back_space = function()
			local col = vim.fn.col(".") - 1
			return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
																 end

																	-- Use (s-)tab to:
																		--- move to prev/next item in completion menuone
																		--- jump to prev/next snippet"s placeholder
																		_G.tab_complete = function()
																		if vim.fn.pumvisible() == 1 then
																			return t "<C-n>"
																				elseif vim.fn["vsnip#available"](1) == 1 then
																				return t "<Plug>(vsnip-expand-or-jump)"
																				elseif check_back_space() then
																				return t "<Tab>"
																		else
																			return vim.fn["compe#complete"]()
																				end
																				end
																				_G.s_tab_complete = function()
																				if vim.fn.pumvisible() == 1 then
																					return t "<C-p>"
																						elseif vim.fn["vsnip#jumpable"](-1) == 1 then
																						return t "<Plug>(vsnip-jump-prev)"
																				else
																					-- If <S-Tab> is not working in your terminal, change it to <C-h>
																						return t "<S-Tab>"
																						end
																						end

																						vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
																						vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
																						vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
																						vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

																						-- Ultisnips
																						vim.g.UltiSnipsSnippetDirectories = { "/home/void/.config/nvim/snippets/vim-react-snippets/" }
		-- Remove problems with <TAB> and nvim compe
			vim.cmd("let g:UltiSnipsExpandTrigger = '<CR>'")

			-- Markdown preview
			vim.cmd([[
					" let g:mkdp_auto_start = 1
					function! SetMarkdownCSS()
					let layout = matchstr(getline(1), 'layout:\s*\zs\S\+')
					if layout ==# 'teste'
					let g:mkdp_markdown_css = '/home/void/teste.css'
					elseif l:layout ==# 'imagem_explicada'
					let g:mkdp_markdown_css = 'path/to/imagem_explicada.css'
					endif
					endfunction

					augroup MarkdownPreview
					autocmd!
					autocmd BufNewFile,BufReadPost *.md call SetMarkdownCSS()
					augroup END
			]])

			-- remover
			vim.cmd('source $HOME/teste.lua')

			-- Arrumar
			vim.cmd([[
					map <F6> :setlocal spell! spelllang=pt_br,en_us<CR>
					let spell_language_list = "brasileiro, american, castellano"

					set guifont=tamzen:h11

					function! SetupMappings()
					nmap <buffer> <Tab> j
					nmap <buffer> <S-Tab> k
					endfunction

					augroup filetype_mappings
					autocmd!
					autocmd FileType * call SetupMappings()
					augroup END

					nnoremap @ q
					nnoremap # @
					command! -bang -bar -nargs=? -complete=dir Cd
					\ call fzf#run(fzf#wrap(
							\ {'source': 'find '.( empty("<args>") ? ( <bang>0 ? "~" : "." ) : "<args>" ) .' -type d',
							\ 'sink': 'Ex'}))



					"cnoremap q <C-C>
					nmap <buffer> <Tab> j
					nmap <buffer> <S-Tab> k
					nnoremap @ q
					nnoremap # @
					command! -bang -bar -nargs=? -complete=dir Cd
					\ call fzf#run(fzf#wrap(
								\ {'source': 'find '.( empty("<args>") ? ( <bang>0 ? "~" : "." ) : "<args>" ) .' -type d',
								\ 'sink': 'Ex'}))

					inoremap <silent><expr> <C-Space>      compe#confirm('<CR>')

					]])
					'';
		plugins = with pkgs.vimPlugins; [
# utilidades
			zoxide-vim
				comment-nvim
				firenvim
				fzf-vim
				markdown-preview-nvim
				nvim-spectre
				undotree
				nvim-jdtls
				vim-easymotion
# git
				vim-fugitive
				gitsigns-nvim

# coc-java
# coc-nvim

# sintaxe
				vim-ledger
				bullets-vim
				pears-nvim

# lsp
				nvim-lspconfig
				nvim-compe
# nvim-treesitter.withAllGrammars
				(pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
															  p.c
															  p.css
															  p.go
															  p.java
															  p.javascript
															  p.json
															  p.tsx
															  p.typescript
				]))

# snippet
				ultisnips
# vim-react-snippets
				emmet-vim

# estilizacao
				nvim-highlight-colors
				];
	};
	programs.firefox = {
		enable = true;
		profiles.default = {
			isDefault = true;
# search.engines = {
# 	"searx" = {
# 		urls = [{ template = "https://searx.work/search?q={searchTerms}"; }];
# 		definedAliases = [ "@sx" ];
# 	};
# };
			userChrome = ''
				@import "${
					builtins.fetchGit {
						url = "https://github.com/renatonunes74/firefox-cli-theme";
						ref = "main";
						rev = "b522f41f15abe82e4b2c2d27317c8f4d1527723f"; # <-- Change this
					}
				}/userChrome.css";
			'';
		};
		profiles.default.settings = {
# Enable userChrome customizations
			"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
		};
	};
	programs.bash.enable = false;
	programs.zsh = {
		enable = true;
		enableAutosuggestions = true;
		enableCompletion = true;
		enableSyntaxHighlighting = true;
		defaultKeymap = "viins";
		history = {
			expireDuplicatesFirst = true;
			ignoreDups = true;
			size = 10000;
		};
		shellAliases = {
			ac = "sudo adb kill-server && sudo adb start-server && adb devices";
			t = "task";
			h = "hledger";
			he = "home-manager edit";
			hs = "home-manager switch";
			ne = "sudo nvim /etc/nixos/configuration.nix";
			ns = "sudo nixos-rebuild switch";
			ghre = "gh repo edit $(gh repo list | fzf | awk '{print $1}')";
			c = "xclip -selection clipboard";
			d = "fasd_cd -d";
			e = "echo";
			ff = "ffmpeg -i";
			o = "mimeo";
			g = "grep";
			gc = "git clone";
			gi = "grep -i";
			md = "mkdir -pv";
			ms = "mpv --no-video --shuffle $HOME/msc";
			mv = "mv -n";
			spring="sh ~/projetos/spring_cli/spring_cli.sh";
			pow = "doas systemctl poweroff";
			r = "rg -i.";
			rd = "rm -rf";
			reboot = "doas reboot";
			rename = "rename -a -o";
			rename2 = "sh $HOME/rename2.sh";
			sf = "sfeed_curses $HOME/.sfeed/feeds/*";
			vb = "nvim $HOME/.bashrc";
			vc = "nvim /usr/bin/compile";
			vd = "nvim $HOME/.config/dwm-6.3/config.h";
			vf = "nvim /usr/bin/fzf-st";
			vfm = "nvim /usr/bin/fzf-menu";
			vim = "nvim";
			vn = "cd $HOME/.config/nvim/";
			vno = "doas nixos-rebuild edit";
			vs = "nvim $HOME/.config/st-0.8.5/config.h";
			vsf = "nvim $HOME/.sfeed/sfeedrc";
			xi = "nix-env -iAv";
			xo = "nix-env --uninstall";
			xq = "doas pacman -query -Rs";
			xr = "nix-env --uninstall";
			xu = "doas pacman -Syu";
			zz = "doas systemctl suspend"; 
#sf = "sfeed_update $HOME/.sfeed/sfeedrc && sfeed_curses $HOME/.sfeed/feeds/*";
		};
		initExtra = ''
# Auto startx
			if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi
				PS1='%~ '
# Shell color
# GOTHAM_SHELL="$HOME/.config/gotham/gotham.sh"
# [[ -s $GOTHAM_SHELL ]] && source $GOTHAM_SHELL
# Auto correction
					setopt correctall
# Prompt git branch
					autoload -Uz vcs_info
					precmd() { vcs_info }
		setopt PROMPT_SUBST
			RPROMPT=\$vcs_info_msg_0_
			zstyle ':vcs_info:git:*' formats '%b'

# Prompt mode
			function zle-line-init zle-keymap-select {
				case $KEYMAP in
					(vicmd)      PS1="· %~ " ;;
				(main|viins) PS1="%~ " ;;
				(*)          PS1="%~ " ;;
				esac
					zle reset-prompt
			}
		zle -N zle-line-init
			zle -N zle-keymap-select

# Start fasd
			eval "$(fasd --init auto)"

# Edit line in nvim with ctrl-e:
			autoload edit-command-line; zle -N edit-command-line
			bindkey '^e' edit-command-line

# Plugins
# Auto suggestions
			source /home/void/nix/zsh-autosuggestions/zsh-autosuggestions.zsh
			ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,underline"
			ZSH_AUTOSUGGEST_STRATEGY=(history completion)
			bindkey "^ " autosuggest-accept""

# Easy motion
			source /home/void/nix/zsh-easy-motion/easy_motion.plugin.zsh
			bindkey -M vicmd " " vi-easy-motion""

# Fzf tab
			source /home/void/nix/fzf-tab/fzf-tab.plugin.zsh
			zstyle ":fzf-tab:*" fzf-flags --reverse --tac --cycle --multi --prompt="" --bind=tab:down,btab:up,ctrl-a:select-all,ctrl-space:toggle+down --color=bw
			bindkey "^I" fzf-tab-complete

# Functions
# Datediff
			datediff() {
				d1=$(date -d "$1" +%s)
					d2=$(date -d "$2" +%s)
					echo $(( (d1 - d2) / 86400 ))
			}
# Fasd + Vim
		v () {
			ver=$(fasd -a $1 | grep -v $type_media)
				if [ ! -z $ver ]; then
					nvim $ver
						fi
		}
# Media List
		export type_media=".mp4\|.mp3\|.avi\|.png\|.jpg\|.jpeg\|.opus\|.m4a"

# Sfeed
			export SFEED_URL_FILE=~/.sfeed/sfeed_lido.txt

# Markdown Search
			cf () {
				nvim $(for i in **/*.md; do echo $(cat $i | tr '\n' ' '| sed "s/^/$i/"); done | fzf --color=light | awk '{ print $1 }' | sed 's/#//;s/---//')
			}

# Change start command to doas with ESC+S
		function prepend-doas {
			if [[ $BUFFER != "doas "* ]]; then
				BUFFER="doas $BUFFER"; CURSOR+=5
					fi
		}
		zle -N prepend-doas
			bindkey -M vicmd S prepend-doas

# Copy command with ESC+C
			function prepend-copy {
				if [[ $BUFFER != "e '"*"' | c " ]]; then
					BUFFER="echo '$BUFFER' | c"; CURSOR+=5
						fi
			}
		zle -N prepend-copy
			bindkey -M vicmd C prepend-copy

# Remove primary command with ESC+Z
			function prepend-suffix {
				if [[ $BUFFER != "" ]]; then
					suffix=$(echo $BUFFER | sed 's/^[^ ]* / /')
						BUFFER="$suffix"; CURSOR+=0
						zle beginning-of-line
						zle vi-insert
						fi
			}
		zle -N prepend-suffix
			bindkey -M vicmd Z prepend-suffix

#	zmodload -i zsh/parameter
			'';
	};
	programs.fzf = {
		enable = true;
		enableZshIntegration = true;
	};
}
