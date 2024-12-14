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
  testAoc1b = {
    expr = aoc.aoc1b (lib.readFile ./aoc1.txt);
    expected = 24316233;
  };
  testAoc2a = {
    expr = aoc.aoc2a (lib.readFile ./aoc2.txt);
    expected = 24316233;
  };
  testIsReportSafe = {
    expr = aoc.isReportSafe [1 2 4 5 6];
    expected = true;
  };
  testIsReportSafeIsUnsafeIfIncreasingMoreThanThree = {
    expr = aoc.isReportSafe [1 4 8 9];
    expected = false;
  };
  testIsReportSafeNotMonotonic = {
    expr = aoc.isReportSafe [1 1];
    expected = false;
  };
  testQuickSort = {
    expr = aoc.quicksort [2 6 23 6 8 9];
    expected = [2 6 6 8 9 23];
  };
}
