{ inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = { 
      inherit inputs;
      standalone = false;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.blackade = import ../home.nix;
  };
}
