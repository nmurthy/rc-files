#!/bin/sh
# ~/.xinitrc
# Executed by startx

VBoxClient-all &
eval $(gnome-keyring-daemon --start)
export GNOME-KEYRING-SOCKET
export GNOME-KEYRING-PID
export SSH_AUTH_SOCK="$GNOME_KEYRING_CONTROL/ssh"
exec xmonad

# DEFAULT_SESSION=ck-launch-session gnome-session
# ck-launch-session gnome-session
