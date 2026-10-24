# dotfiles

## Installation

```sh
git clone https://github.com/13lackade/dotfiles.git /tmp/dotfiles
cd /tmp/dotfiles
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix ./hardware-configuration.nix
sudo nixos-install --flake .#laptop
```
