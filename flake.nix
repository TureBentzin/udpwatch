{
  description = "UDPWatch";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {

      packages.${system} = {
        udpwatch = pkgs.stdenv.mkDerivation {
          pname = "udpwatch";
          version = "1.0";
          src = ./.;

          buildInputs = [ pkgs.gcc ];

          buildPhase = ''
            $CC -Wall -O2 -o udpwatch udpwatch.c
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp $src/LICENSE $out/
            cp $src/README.md $out/
            cp udpwatch $out/bin/
          '';
        };

        default = self.packages.${system}.udpwatch;
      };
    };
}
