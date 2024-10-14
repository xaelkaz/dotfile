export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export PATH="$HOME/.tmuxifier/bin:$PATH"

ZSH_THEME="eastwood"

plugins=(
  git
  zsh-autosuggestions
  jsontools
  command-not-found
  colored-man-pages
  copypath
  tmux
  web-search
  rbenv
  ruby
)

source $ZSH/oh-my-zsh.sh

eval "$(rbenv init - zsh)"

eval "$(atuin init zsh)"

eval "$(tmuxifier init -)"

alias vim="nvim"

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'

alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

# Similar to `gunwip` but recursive "Unwips" all recent `--wip--` commits not just the last one
function gunwipall() {
  local _commit=$(git log --grep='--wip--' --invert-grep --max-count=1 --format=format:%H)

  # Check if a commit without "--wip--" was found and it's not the same as HEAD
  if [[ "$_commit" != "$(git rev-parse HEAD)" ]]; then
    git reset $_commit || return 1
  fi
}


export LDFLAGS="-L/opt/homebrew/opt/postgresql/lib"
export CPPFLAGS="-I/opt/homebrew/opt/postgresql/include"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
# End Nix
