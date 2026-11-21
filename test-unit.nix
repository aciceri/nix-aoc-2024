{ aoc, utils }: {
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
