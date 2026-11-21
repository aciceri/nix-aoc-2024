{ lib, aoc }: {
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
    expected = 252;
  };
  testAoc2b = {
    expr = aoc.aoc2b (lib.readFile ./aoc2.txt);
    expected = 324;
  };
  testAoc3a = {
    expr = aoc.aoc3a (lib.readFile ./aoc3.txt);
    expected = 164730528;
  };
  testAoc3b = {
    expr = aoc.aoc3b (lib.readFile ./aoc3.txt);
    expected = 70478672;
  };
}
