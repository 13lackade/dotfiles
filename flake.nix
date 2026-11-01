{
  description = "NixOS settings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration
            ./configuration/snapshots.nix
            ./hosts/laptop
          ];
        };

        vm = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration
            ./hosts/vm
          ];
        };
      };

      homeConfigurations = {
        denjo = home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit inputs;
            standalone = true;
          };

          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          modules = [
            ./home.nix
            {
              home.username = "denjo";
              home.homeDirectory = "/home/denjo";
              targets.genericLinux.enable = true;
            }
          ];
        };
      };

      formatter.${system} = pkgs.nixfmt-tree;
      apps.${system} = {
        update-plugins = {
          type = "app";
          program = "${pkgs.nvfetcher}/bin/nvfetcher";
        };
        home-manager = {
          type = "app";
          program = "${home-manager.packages.${system}.home-manager}/bin/home-manager";
        };
      };
    };
}
