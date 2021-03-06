# common stuff for both shells

export PATH=${PATH}:~/.dotfiles/bin:~/.dotfiles/sbin:~/.local/bin/
export EDITOR="vim"

# VARS

# xterm breaks zsh
#export TERM="xterm"
export MC_SKIN=${HOME}/.dotfiles/ext/mc/solarized.ini
export PAGER="/usr/bin/less"
export LESS="-n -r -X"
# <3 symlinks
export AUTOJUMP_KEEP_SYMLINKS=1
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
export GOPATH="${HOME}/dev/go"
export GOBIN="${HOME}/dev/go/bin"

export PYTHONDONTWRITEBYTECODE="fuck-yes"

# ALIAS

alias ls="ls --color=auto"
alias llt="ls -lht --color=auto"
alias ll="ls -lh --color=auto"
alias lla="ls -lha --color=auto"
alias vR="vim -R"
alias tree="tree -C"
alias rsync="rsync -Prza"  # progress, recursive, compress, archive

# vim aliases/functions
vim() { if [ -f /usr/bin/vimx ] ; then /usr/bin/vimx ${@} ; else /usr/bin/vim ${@} ; fi }
alias vs="vim ./*.spec"
alias vm="vim Makefile"
alias vd="vim Dockerfile"
alias vc="vim ./docker-compose.yml"
alias vr="vim README*"
alias vy="vim ./*.y*ml"
alias v="vim"
# halp!!1!
alias h="less ~/.dotfiles/mysterious-keybinds/README.md"

alias m="make"

# git aliases
alias g="git"
alias gs="git status"
alias gst="git stash"
alias gsp="git stash pop"
alias gd="git diff"
alias gp="git push -u"
alias gpf="git push -f"
alias gf="git fetch"
alias gdw="git diff --color-words"
alias gdc="git diff --color-words --word-diff-regex='[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+'"
alias gc="git commit --verbose"
alias gca="git commit --verbose --amend"
alias gpr="git pull --rebase --recurse-submodules"
alias gpum="git pull --rebase upstream master"
alias gpom="git pull --rebase origin master"
alias gau="git add --verbose --update -- ."
alias gaa="git add --verbose --all -- ."
alias gr="git rebase"
alias gri="git rebase -i"
alias grc="git rebase --continue"
alias grh="git reset --hard"
alias grho="git reset --hard origin/master"
alias grhu="git reset --hard upstream/master"
alias gb="git checkout -B"
alias gba="git branch --all"
alias grau="git remote add upstream"
alias grao="git remote add origin"
alias grs="git remote set-url"
alias gra="git remote add"
alias grv="git remote -v"
alias gcl="git clone"
alias gfa="git fetch --all"
alias gsp="git submodule foreach git pull --rebase origin master"
gi() { git init . && git add . && git commit -m ${1:-init} >/dev/null; }
gsr() { git rev-list --all | xargs git grep ${1}; }

alias t="env TERM=screen-256color tmux -2"
alias htop="TERM=screen htop"
alias mock6="mock -r rhel-6-x86_64"
alias mock7="mock -r rhel-7-x86_64"
alias mock20="mock -r fedora-20-x86_64"
alias mockr="mock -r fedora-rawhide-x86_64"
alias sc="systemctl"
sr () { systemctl restart ${@} ; systemctl --no-pager --full status ${@} }
sta () { systemctl start ${@} ; systemctl --no-pager --full status ${@} }
alias s="systemctl status"
alias stp="systemctl stop"
alias ju="journalctl"
alias sysdig="docker run -it --rm --privileged -v /:/host:ro -e TERM=$TERM sysdig/sysdig csysdig"

alias d="docker"
alias di="docker images"
alias dit="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock nate/dockviz images -t"
alias dp="docker ps"
alias dpa="docker ps -a"
alias dr="docker run"
alias drt="docker run --rm -ti"
alias de="docker exec"
alias det="docker exec -ti"
alias c="docker-compose"
drm() { docker rm -f $(docker ps -a -q) }
drmi() { docker rmi $(docker images -a | grep "^<none>" | awk '{print $3}') }

# root aliases
alias monitor="xrandr --auto && xrandr --output LVDS1 --off"
alias pm-suspend="xscreensaver-command -lock ; pm-suspend"

# https://blog.cryptomilk.org/2010/12/23/gdb-backtrace-to-file/
alias bt='echo 0 | gdb -batch-silent -ex "run" -ex "set logging overwrite on" -ex "set logging file gdb.bt" -ex "set logging on" -ex "set pagination off" -ex "handle SIG33 pass nostop noprint" -ex "echo backtrace:\n" -ex "backtrace full" -ex "echo \n\nregisters:\n" -ex "info registers" -ex "echo \n\ncurrent instructions:\n" -ex "x/16i \$pc" -ex "echo \n\nthreads backtrace:\n" -ex "thread apply all backtrace" -ex "set logging off" -ex "quit" --args'

# COLORS
eval `dircolors ~/.dotfiles/ext/dircolors-solarized/dircolors.ansi-universal`

# functions
rpmw () { rpm -qf "$(which ${1})" ; }
rpmg () { rpm -qa | grep "${1}" ; }
gg () { grep -inR --exclude-dir=".git" --color=always "${1}" . ; }

ff () { find . -iname "*${1}*" ; }
laptop () {
    xrandr --auto
    for i in {1..3}
    do
        # we dont care if the output doesn't exist
        xrandr --output VGA${i} --off --output HDMI${i} --off &>/dev/null
    done
}
rpmb () {
    rpmbuild ./*.spec --define "_sourcedir ${PWD}" \
                      --define "_specdir ${PWD}" \
                      --define "_builddir ${PWD}" \
                      --define "_srcrpmdir ${PWD}" \
                      --define "_rpmdir ${PWD}" \
                      ${@}
}
which-rpm-contains () {
    echo "Searching for '${2}' in rpms matching '${1}'"
    for rpm in `yum search all | egrep "${1}" | awk '{ print $1 }'`
    do
        file_list=$(rpm -ql ${rpm} | egrep "${2}")
        [[ ${?} == 0 ]] && echo -n "'${rpm}' contains '${2}':\n${file_list}"
    done
}
# Create a directory and cd into it
mcd() {
    mkdir "${1}" && cd "${1}"
}
nicemount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2=$4="";1') | column -t; }

# show random aliases, as a reminder
# alias | shuf -n 5

# "disable" ctrl-{s,q}
stty start '^-' stop '^-'
