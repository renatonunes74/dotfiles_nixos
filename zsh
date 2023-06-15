# sistema
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec startx; fi
PS1='%~ '
GOTHAM_SHELL="$HOME/.config/gotham/gotham.sh"
[[ -s $GOTHAM_SHELL ]] && source $GOTHAM_SHELL

export EDITOR='nvim'

# colors
autoload -U colors && colors

# History in cache directory:
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export SAVEHIST=100000000
export HISTFILE=~/.zsh_history
#setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
alias history="history 0"
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# git branch
autoload -Uz vcs_info
precmd() { vcs_info }
setopt PROMPT_SUBST
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%b'


# auto correction
setopt correctall

# vi mode
bindkey -v
export KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    case ${KEYMAP} in
        (vicmd)      PS1="· %~ " ;;
        (main|viins) PS1="%~ " ;;
        (*)          PS1="%~ " ;;
    esac
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select



# Use nvim keys in tab complete menu:
#bindkey -M menuselect 'h' vi-backward-char
#bindkey -M menuselect 'k' vi-up-line-or-history
#bindkey -M menuselect 'l' vi-forward-char
#bindkey -M menuselect 'j' vi-down-line-or-history
#bindkey -v '^?' backward-delete-char

# Edit line in nvim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
#source /home/void/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting-filetypes.zsh

source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept''
source /usr/share/zsh/plugins/zsh-easy-motion/easy_motion.plugin.zsh
bindkey -M vicmd ' ' vi-easy-motion''

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.forgit/forgit.plugin.zsh ] && source ~/.forgit/forgit.plugin.zsh
export FZF_DEFAULT_OPTS="--reverse --tac --cycle --multi --prompt='' --bind=tab:down,btab:up,ctrl-a:select-all,ctrl-space:toggle+down --color=bw"

eval "$(fasd --init auto)"

# autosuggestions hi
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# sfeed
export SFEED_URL_FILE="$HOME/.sfeed/urls"
#export PAGER="fzf"

# aliases
alias md='mkdir -p'
alias rd='rm -rf'
alias g='grep'
alias gi='grep -i'
alias ls='ls --color=no'
alias sf='sfeed_update $HOME/.sfeed/sfeedrc && sfeed_curses $HOME/.sfeed/feeds/*'
#alias sf='sfeed_curses $HOME/.sfeed/feeds/*'
alias vsf='nvim $HOME/.sfeed/sfeedrc'
alias vim='nvim'
v () {
	ver=$(fasd -fr $1 | grep -v $type_media)
	if [ ! -z $ver ]; then
		nvim $ver
	fi
}
#alias pr='mkdir "$1" && cd $1 && kanban init && echo -e "digraph G {\n\n}" >> $1.ms'
alias p='nsxiv'
alias gc='git clone'
alias ff='ffmpeg -i'
cf () {
	nvim $(for i in */.md; do echo $(cat $i | tr '\n' ' '| sed "s/^/$i/"); done | fzf --color=light | awk '{ print $1 }' | sed 's/#//;s/---//')
}
alias ff2='ffmpeg -i "$1" -c copy -map 0 -segment_time 30 -f segment -reset_timestamps 1 "$2"%03d.mkv'
loud () {
for i in *.opus;do
ffmpeg -i "$i" -filter:a loudnorm "$i".opus
done
}
alias c="xclip -selection clipboard"
alias xi='doas pacman -S'
alias xr='doas pacman -R'
alias xo='doas pacman -remove -Oo'
alias xq='doas pacman -query -Rs'
alias xu='doas pacman -Syu'
alias zz='doas systemctl suspend'
alias pow='doas poweroff'
alias reboot='doas reboot'
# VIM
alias vv='nvim $HOME/.vimrc'
alias vn='cd $HOME/.config/nvim/'
alias vd='nvim $HOME/.config/dwm-6.3/config.h'
alias vs='nvim $HOME/.config/st-0.8.5/config.h'
alias vb='nvim $HOME/.bashrc'
alias vz='nvim $HOME/.zshrc'
alias vx='nvim $HOME/.xinitrc'
alias vc='nvim /usr/bin/compile'
alias vf='nvim /usr/bin/fzf-st'
alias vfm='nvim /usr/bin/fzf-menu'
alias r='rg -i.'
r1() {
	grep -A 3 -B 3 -i "$1" ../nt/.md | grep -v "\--" | sed -E 's/\(.\)//g' | sed -E 's/\..*.md-//' | sed -E 's/..\/nt\///' |sed -E 's/.md:/.md\n/' && echo "---------------------------" &&
	grep -A 3 -B 3 -i "$1" ../nt/.md | grep -v "\--" | sed -n 's/^.\(\[\[[^]]\]\]\).$/\1/p' | nl -s'. '
}
alias mv='mv -n'
#alias mpv='mpv --loop'
alias rename='rename -a -o'
alias rename2='sh $HOME/.config/rename2.sh'
alias mv='mv -n'
alias recorte='sh $HOME/.config/recorte.sh'
alias cortar='sh $HOME/.config/cortar.sh'
alias fps='sh $HOME/.config/fps.sh'
alias reduce='for i in *.mp4; do ffmpeg -i $i -vcodec libx265 -crf 24 compactado_$i && mv $i normal; done'
alias 3000k='sh $HOME/.config/3000k.sh'
datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
	echo $(( (d1 - d2) / 86400 ))
}
alias tesseract='ssh void@192.168.1.12 && sshfs void@192.168.1.12:/home/void $HOME/remote'
alias ac='doas adb kill-server && doas adb start-server && adb devices'
alias luamake=/luamake
export PATH="${HOME}/.config/lsp/lua-language-server/bin:${PATH}"

hash -d ur=/usr/share
export ur=/usr/share
export type_media=".mp4\|.mp3\|.avi\|.png\|.jpg\|.jpeg\|.opus\|.m4a"

function prepend-doas {
  if [[ $BUFFER != "doas "* ]]; then
    BUFFER="doas $BUFFER"; CURSOR+=5
  fi
}
zle -N prepend-doas
bindkey -M vicmd S prepend-doas
function prepend-copy {
  if [[ $BUFFER != "echo '"*"' | c " ]]; then
    BUFFER="echo '$BUFFER' | c"; CURSOR+=5
  fi
}
zle -N prepend-copy
bindkey -M vicmd C prepend-copy
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

zmodload -i zsh/parameter
insert-last-command-output() {
  LBUFFER+="$(eval $history[$((HISTCMD-1))])"
}
zle -N insert-last-command-output
bindkey "^Q" insert-last-command-output

source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:complete::' fzf-preview 'less ${(Q)realpath}'
zstyle ':fzf-tab:*' fzf-flags --reverse --tac --cycle --multi --prompt='' --bind=tab:down,btab:up,ctrl-a:select-all,ctrl-space:toggle+down --color=bw
export LESSOPEN='|~/.lessfilter %s'
bindkey '^I' fzf-tab-complete

PATH="/home/void/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/void/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/void/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/void/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/void/perl5"; export PERL_MM_OPT
