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

        udpmessage = pkgs.writeShellScriptBin "udpmessage" ''
          if [[ $# -lt 1 ]]; then
            echo "Usage: $0 ip:port [message ...]"
            exit 1
          fi

          hostport="$1"
          shift

          IFS=':' read -r ip port <<< "$hostport"

          if [[ $# -gt 0 ]]; then
            msg="$*"
          else
            msg=$(cat)
          fi

          echo -n "$msg" > /dev/udp/"$ip"/"$port"          
        '';

        default = pkgs.symlinkJoin {
          name = "UDPWatch_tools";
          paths = with self.packages.${system}; [
            udpwatch
            udpmessage
          ];
        };
      };
    };
}
