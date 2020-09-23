{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  swift2nix-example = import ./default.nix { };
in
mkShell {
  buildInputs = [
    swift
    swift2nix-example
  ];
}
