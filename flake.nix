{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }: {
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
          ./hosts/cild/configuration.nix
        ];
      };

    };
  };
}
