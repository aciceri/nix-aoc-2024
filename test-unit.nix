{ aoc, utils }: {
  testLex = {
    expr = aoc.lex "xmul(2,4)";
    expected = [
      { type = "ident"; text = "xmul"; }
      { type = "punct"; text = "("; }
      { type = "num"; text = "2"; }
      { type = "punct"; text = ","; }
      { type = "num"; text = "4"; }
      { type = "punct"; text = ")"; }
    ];
  };
  testLexIdentIsLettersUnderscoreApostrophe = {
    expr = aoc.lex "do_not_mul don't x1";
    expected = [
      { type = "ident"; text = "do_not_mul"; }
      { type = "punct"; text = " "; }
      { type = "ident"; text = "don't"; }
      { type = "punct"; text = " "; }
      { type = "ident"; text = "x"; }
      { type = "num"; text = "1"; }
    ];
  };
  testParseMuls = {
    expr = aoc.parseMuls (aoc.lex "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))");
    expected = [
      { op = "mul"; left = 2; right = 4; }
      { op = "mul"; left = 5; right = 5; }
      { op = "mul"; left = 11; right = 8; }
      { op = "mul"; left = 8; right = 5; }
    ];
  };
  testParseMulsRejectsLongNumber = {
    expr = aoc.parseMuls (aoc.lex "mul(1234,5)");
    expected = [];
  };
  testParseInstructions = {
    expr = aoc.parseInstructions (aoc.lex "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))");
    expected = [
      { op = "mul"; left = 2; right = 4; }
      { op = "dont"; }
      { op = "mul"; left = 5; right = 5; }
      { op = "mul"; left = 11; right = 8; }
      { op = "do"; }
      { op = "mul"; left = 8; right = 5; }
    ];
  };
  testAoc3bExample = {
    expr = aoc.aoc3b "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))";
    expected = 48;
  };
  testIsReportSafe = {
    expr = aoc.isReportSafe [1 2 4 5 6];
    expected = true;
  };
  testIsReportSafeWithTollerance = {
    expr = aoc.isReportSafeTollerant  [5 2 4 5 6];
    expected = true;
  };
  testIsReportSafeWithTolleranceOnyOneTime = {
    expr = aoc.isReportSafeTollerant  [5 2 4 5 1];
    expected = false;
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
    expr = utils.quicksort [2 6 23 6 8 9];
    expected = [2 6 6 8 9 23];
  };
}
