swift2nix
=========

The simplest use-case is the following:



```nix
buildSwiftExecutable {
  name = "your-swift-app";
  projectDir = ./.;
}
```
(demo Swift project included in `example/`)



TODOs:
-

- dependencies that wrap c/c++ libraries not building properly yet.
- fixed-output dependencies
- better handling of transitive dependencies
- refactoring


Contributing
-
PRs very welcome! It would be awesome if this evolved into something that would fit into `nixpkgs`


-

inspired by [poetry2nix](https://github.com/nix-community/poetry2nix)

