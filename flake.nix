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
      # Keep Zen at 1.23.2b until a stable release includes the compact-mode fix:
      # https://github.com/zen-browser/desktop/pull/16001
      url = "github:0xc000022070/zen-browser-flake/9342d127aa8c585e82f3f57ddb25800fd546029f";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        specialArgs = inputs;

        modules = [
          ./configuration

          ./hardware-configuration.nix
          ./hardware/fmvu90h1.nix

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
