#!/bin/sh
# ~/.xinitrc
# Executed by startx

VBoxClient-all &
eval $(gnome-keyring-daemon --start)
export GNOME_KEYRING_PID
export GNOME_KEYRING_SOCKET
export SSH_AUTH_SOCK
dbus-launch xmonad

# DEFAULT_SESSION=ck-launch-session gnome-session
# ck-launch-session gnome-session
