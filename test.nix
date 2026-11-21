let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;
  inherit (lib) runTests;
  aoc = import ./aoc.nix lib;
  utils = import ./utils.nix lib;
in runTests (import ./test-solutions.nix { inherit lib aoc; } // import ./test-unit.nix { inherit aoc utils; })
