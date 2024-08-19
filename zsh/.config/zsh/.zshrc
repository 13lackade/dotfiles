### Plugins ###
fpath=($XDG_DATA_HOME/zsh/site/*(N-/) $fpath)
autoload -Uz colors; colors
autoload -Uz compinit; compinit -d "$XDG_CACHE_HOME/zsh/.zcompdump"
# zsh-syntax-highlighting is not autoload-able right now ;)
# https://github.com/zsh-users/zsh-syntax-highlighting/issues/252
source "$XDG_DATA_HOME/zsh/site/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
autoload -Uz zsh-autosuggestions.zsh; zsh-autosuggestions.zsh

### Options ###
setopt prompt_subst
setopt no_beep
setopt print_eight_bit
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_param_slash
setopt magic_equal_subst
zstyle ":completion:*:default" menu true select
zstyle ":completion:*:default" list-colors "di=34"
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"

### Useful commands ###
function ex() {
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

### Aliases ###
# ls
if command -v eza &> /dev/null; then
    alias ls='eza --color=always --group-directories-first -l'
    alias la='eza --color=always --group-directories-first -lA'
else
    alias ls='ls --color=always --group-directories-first -l'
    alias la='ls --color=always --group-directories-first -lA'
fi

# confirm before overwriting something
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# fastfetch
command -v fastfetch &> /dev/null && alias ff='fastfetch'

# cd
alias -- --='cd -'
alias ..='cd ..'
for i in $(seq 1 5); do
    alias .$i="cd .${(l:$i * 3::/..:)}"
done

# open file
alias o='xdg-open'

### Prompts ###
export PROMPT=$(echo -e "\n%B%F{blue}%~%f\n%F{%(?.002.red)}$ %f%b")
export PROMPT2=$(echo -e "%B%F{%(?.002.red)}$ %f%b")
export PROMPT3=$(echo -e "%B%F{002}S$ %f%b")
export PROMPT4=$(echo -e "%B%F{002}[DEBUG(%x:%I)] %f%b")

### History ###
export HISTFILE="$XDG_CACHE_HOME/zsh/histfile"
export HISTSIZE=1000000
export SAVEHIST=1000000

setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_reduce_blanks
setopt inc_append_history_time
setopt extended_history
