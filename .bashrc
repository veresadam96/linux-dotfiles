#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return;

export GPG_TTY;
GPG_TTY=$(tty);
export VISUAL=nvim;
export EDITOR=nvim;
export PATH="$HOME/bin:$HOME/.local/bin:$PATH";

gpg-connect-agent updatestartuptty /bye >/dev/null;

PS1='[\u@\h \W]\$ ';
[[ -n $NNNLVL ]] && PS1="N$NNNLVL $PS1";
export NNN_SEL=/tmp/.nnn_sel;
export NNN_TMPFILE=/tmp/.nnn_lastd;
export NNN_FIFO=/tmp/nnn.fifo;
export NNN_PLUG='p:preview-tui;f:fzcd';
export NNN_PREVIEWIMGPROG='img2sixel';
#export NNN_TERMINAL='wezterm';

#for android studio avd gui - cant handle wayland yet
export QT_QPA_PLATFORM=xcb;

alias ls='ls --color=auto';
alias grep='grep --color=auto';

# work
if [ -f "$HOME/work/.meta/.bashrc" ]; then
	source "$HOME/work/.meta/.bashrc";
fi

#UTILS
alias passgen='shuf -n 4 ~/.config/.meta/passgen-words.txt | tr -d "\n" | tr "\r" " " | rev | cut -c 2- | rev';
alias passgen-copy='passgen | wl-copy -n';

#DOTFILES
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME';
alias dotfiles-init='git init --bare $HOME/.dotfiles';
alias dotfiles-lazygit='lazygit --git-dir=$HOME/.dotfiles --work-tree=$HOME';

#PACMAN (just notes)
alias pacman-list-export='pacman -Qqe > packagelist.txt';
alias pacman-list-import='pacman -S --needed $(cat packagelist.txt)';

#PROGRAMS
alias n="/bin/tmux -u new-session 'TERM=screen-256color /bin/nnn -deoHAJu'; [ -f \"\$NNN_TMPFILE\" ] && . \"\$NNN_TMPFILE\" && rm -f -- \"\$NNN_TMPFILE\" > /dev/null";
alias cal='cal -mw';
alias mpc-addplaylist='nnn -p - ~/music | grep -oE "[^/]+\.[a-zA-Z0-9]+" | mpc addplaylist';
alias git-list-tags="git for-each-ref --sort=creatordate --format '%(refname) %(creatordate)' refs/tags";
alias yt-dlp-playlist="yt-dlp --ignore-errors --continue --no-overwrites --download-archive progress.txt -x -f bestaudio";
alias yt-dlp-song="yt-dlp -x -f bestaudio";

#launch sway
#use this line below in a vm if the mouse pointer is upside down
#export WLR_NO_HARDWARE_CURSORS=1;
if [[ -z $WAYLAND_DISPLAY ]] && [[ -n $XDG_VTNR ]] && [[ $XDG_VTNR -eq 1 ]]; then
	#exec sway;
	export XDG_SESSION_TYPE=wayland;
	export XDG_SESSION_DESKTOP=sway;
	export XDG_CURRENT_DESKTOP=sway;

	# Wayland stuff
	export MOZ_ENABLE_WAYLAND=1;
	export QT_QPA_PLATFORM=wayland;
	export SDL_VIDEODRIVER=wayland;
	export _JAVA_AWT_WM_NONREPARENTING=1;

	# Launch Sway with a D-Bus server
	exec dbus-run-session sway "$@";
fi


# Load Angular CLI autocompletion.
source <(ng completion script)
