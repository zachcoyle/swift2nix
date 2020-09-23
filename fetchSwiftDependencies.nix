{ pkgs ? import <nixpkgs> { }
, src
, transitives
}:

with pkgs;
let
  # TODO: make this less fragile
  rewriteDependency = dep: ''
    sed -i "\|${dep.url}|c.package(path:\"${dep}/\")," ./Package.swift
  '';

  rewritePackageDependencies = deps: builtins.concatStringsSep ''
      ''
    (map rewriteDependency deps);

  fetchSwiftModule = { url, rev, name }: { swiftDeps ? [ ] }:
    stdenv.mkDerivation rec {
      inherit rev name url;
      src = builtins.fetchGit {
        inherit url;
      };
      buildInputs = [ swift ];

      buildPhase = ''
        ${rewritePackageDependencies swiftDeps}
        rm -f Package.resolved || true
        swift package resolve
      '';
      installPhase = ''
        mkdir -p $out
        cp -r ./* $out
      '';
    };

  packageResolvedPath = src + "/Package.resolved";

  packageResolved =
    if (builtins.pathExists packageResolvedPath)
    then builtins.fromJSON (builtins.readFile packageResolvedPath)
    else null;

  srcFromPin = pin: (lib.nameValuePair pin.package (fetchSwiftModule {
    url = pin.repositoryURL;
    rev = pin.state.revision;
    name = pin.package;
  }));

  _swiftDeps = builtins.listToAttrs
    (if builtins.isNull packageResolved then [ ]
    else map srcFromPin packageResolved.object.pins);

  fixupDeps = lib.mapAttrs
    (name: value: value {
      swiftDeps = map
        (x: (lib.attrsets.getAttrFromPath [ x ] _swiftDeps) { })
        (if (builtins.hasAttr name transitives)
        then (lib.attrsets.getAttrFromPath [ name ] transitives)
        else [ ]);
    });

  fixedDeps = lib.mapAttrsToList
    (name: value: value)
    (fixupDeps _swiftDeps);

in
fixedDeps
