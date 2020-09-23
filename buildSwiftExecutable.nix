{ pkgs ? import <nixpkgs> { }
, projectDir
, name
, transitives ? { }
, extraBuildInputs ? [ ]
, meta ? { }
}:

with pkgs;
let
  src = builtins.filterSource
    (path: type:
      baseNameOf path != ".git" &&
      baseNameOf path != ".build")
    projectDir;

  fetchSwiftDependencies = import ./fetchSwiftDependencies.nix;

  swiftDeps = fetchSwiftDependencies { inherit src transitives; };

  # TODO: make this less fragile
  rewriteDependency = dep: ''
    sed -i "\|${dep.url}|c.package(path:\"${dep}/\")," ./Package.swift
  '';

  rewritePackageDependencies = builtins.concatStringsSep ''
  ''
    (map rewriteDependency swiftDeps);
in
stdenv.mkDerivation rec {
  inherit src name meta;

  buildInputs = [ clang swift coreutils ] ++ extraBuildInputs;

  buildPhase = ''
    ${rewritePackageDependencies}
    rm -f Package.resolved || true
    swift package resolve
    CC=clang++ swift build -v -c release --skip-update
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./.build/release/${name} $out/bin/${name}
  '';
}
