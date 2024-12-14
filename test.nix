let
  pkgs = import <nixpkgs> {};
  inherit (pkgs) lib;
  inherit (lib) runTests;
  aoc = import ./aoc.nix lib;
in runTests {
  testAoc1a = {
    expr = aoc.aoc1a (lib.readFile ./aoc1.txt);
    expected = 1666427;
  };
  testQuickSort = {
    expr = aoc.quicksort [2 6 23 6 8 9];
    expected = [2 6 6 8 9 23];
  };
}
