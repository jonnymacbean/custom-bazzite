#!/bin/bash

set -ouex pipefail

SKEL=/etc/skel

# Install repos
dnf config-manager addrepo -y --from-repofile=https://repo.librewolf.net/librewolf.repo
dnf config-manager addrepo --from-repofile=https://repository.mullvad.net/rpm/beta/mullvad.repo
dnf -y copr enable dejan/lazygit
dnf -y copr enable atim/bottom
dnf -y copr enable alternateved/keyd

# Enable writing to /opt
rm /opt
mkdir /opt

# install packages
dnf install -y \
  librewolf \
  keepassxc \
  mullvad-vpn \
  ncdu \
  tealdeer \
  gamemode \
  ripgrep \
  lazygit \
  nodejs \
  nodejs-npm \
  neovim \
  bottom \
  kitty \
  rofi \
  keyd \
  rust \
  cargo \
  eza \
  jetbrains-mono-fonts \
  qt6-qtsvg \
  qt6-qtvirtualkeyboard \
  qt6-qtmultimedia

systemctl enable keyd

# neovim setup
curl -L -o tree-sitter.gz 'https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz'
gzip -cd tree-sitter.gz > /usr/bin/tree-sitter
rm -rf tree-sitter.gz
rm -rf $SKEL/.config/nvim
git clone --depth 1 https://github.com/AstroNvim/template $SKEL/.config/nvim
rm -rf ~/.config/nvim/.git

# SDDM theme
git clone -b master --depth 1 https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | tee /etc/sddm.conf
touch /etc/sddm.conf.d/virtualkbd.conf
echo "[General]
InputMethod=qtvirtualkeyboard" | tee /etc/sddm.conf.d/virtualkbd.conf
sed -i 's|ConfigFile=Themes/astronaut.conf|ConfigFile=Themes/black_hole.conf|g' /usr/share/sddm/themes/sddm-astronaut-theme/metadata.desktop

# copy custom config
cp -rf /ctx/files/.config /ctx/files/.gitconfig $SKEL

# install additional Flatpaks
flatpak --system -y install --reinstall flathub org.jellyfin.JellyfinDesktop
