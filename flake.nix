{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          devShell = self.devShells.${system}.default;
          devShells.default = pkgs.mkShell { buildInputs = [ pkgs.colmena ]; };
        }) // {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ ];
          };
        };

        cild = {
          deployment = {
            targetHost = "88.198.7.144";
            targetUser = "root";
            buildOnTarget = true;
          };

          imports = [
            ./common
            ./services/directus
            ./hosts/cild/configuration.nix
          ];
        };

      };
    };
}
