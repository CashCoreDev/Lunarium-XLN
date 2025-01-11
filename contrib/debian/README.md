
Debian
====================
This directory contains files used to package lunariumcoind/lunariumcoin-qt
for Debian-based Linux systems. If you compile lunariumcoind/lunariumcoin-qt yourself, there are some useful files here.

## pivx: URI support ##


lunariumcoin-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install lunariumcoin-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your lunariumcoin-qt binary to `/usr/bin`
and the `../../share/pixmaps/pivx128.png` to `/usr/share/pixmaps`

lunariumcoin-qt.protocol (KDE)

