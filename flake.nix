{
  description = "NixOS settings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    shojiwm = {
      url = "github:bea4dev/ShojiWM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      shojiwm,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix

          ./hardware/fmvu90h1.nix

          shojiwm.nixosModules.default
          {
            programs.shojiwm = {
              enable = true;
              initConfig = {
                enable = true;
                users = [ "blackade" ];
              };
            };
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = {
              inherit inputs;
            };

            home-manager.users.blackade = import ./home.nix;
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt-tree;
      apps.${system}.update-plugins = {
        type = "app";
        program = "${pkgs.nvfetcher}/bin/nvfetcher";
      };
    };
}
