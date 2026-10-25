{ pkgs, host, ... }:
{
  system.activationScripts.dotfiles = {
    deps = [ "users" ];
    text = ''
      dotfiles=/home/blackade/Workspace/github.com/13lackade/dotfiles

      if [ ! -d "$dotfiles" ]; then
        install -d -o blackade -g users "$(dirname "$dotfiles")"

        if runuser -u blackade -- ${pkgs.git}/bin/git clone \
          https://github.com/13lackade/dotfiles.git "$dotfiles"
        then
          install -D -o blackade -g users -m 0644 \
            ${../hosts + "/${host}/hardware-configuration.nix"} \
            "$dotfiles/hosts/${host}/hardware-configuration.nix"
          runuser -u blackade -- ${pkgs.git}/bin/git -C "$dotfiles" \
            remote set-url origin git@github.com:13lackade/dotfiles.git
        fi
      fi
    '';
  };
}
