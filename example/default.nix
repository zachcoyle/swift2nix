{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  buildSwiftExecutable = import ../buildSwiftExecutable.nix;
in
buildSwiftExecutable {
  name = "example";
  projectDir = ./.;
  transitives = {
    Decree = [ "XMLCoder" ];
  };
  extraBuildInputs = [ ];
}
