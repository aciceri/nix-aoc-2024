lib: let
  quicksort = l: if l == [] then [] else let
    x = builtins.head l;
    xs = builtins.tail l;
    smallerSorted = quicksort (lib.lists.filter (a: a <= x) xs);
    biggerSorted = quicksort (lib.lists.filter (a: a > x) xs);
  in smallerSorted ++ [x] ++ biggerSorted;
  
  abs = n: if n >= 0 then n else -n;
  
  isReportSafe = report: let
    _isSafe = report: builtins.foldl'
    (acc: level: let
      diff = level - acc.previousLevel;
      isInRange = diff >= -3 && diff <= 3 && diff != 0;
    in rec {
      inc = level > acc.previousLevel;
      previousLevel = level;
      safe = if acc.safe == false || (!isInRange) || (acc.inc != null && inc != acc.inc) then false else true;
    })
      {inc = null; previousLevel = lib.lists.head report; safe = true;} (lib.lists.tail report);
  in (_isSafe report).safe;

  isReportSafeTollerant = report: let
    reportCombinations = builtins.genList (n: let 
      before = (lib.lists.take n report);
      after = (lib.lists.take ((lib.lists.length report)-n) (lib.lists.drop (n+1) report));
      in isReportSafe (before ++ after)
    ) (lib.lists.length report); 
  in (builtins.any (a: a) reportCombinations);
in {
  inherit quicksort isReportSafe isReportSafeTollerant;
  
  aoc1a = input: let
    lines = lib.strings.splitString "\n" input;
    lines' = lib.lists.take (lib.lists.length lines - 1) lines;
    splitLine = lib.strings.splitString "   ";
    ls = lib.lists.map splitLine lines';
    listLeft = lib.lists.map ((lib.flip lib.pipe) [lib.lists.head builtins.fromJSON]) ls;
    listRight = lib.lists.map ((lib.flip lib.pipe) [lib.lists.last builtins.fromJSON]) ls;
    sortedListLeft = quicksort listLeft;
    sortedListRight = quicksort listRight;
    sortedZippedList = lib.lists.zipLists sortedListLeft sortedListRight;
    result = builtins.foldl' (acc: item: acc + (abs (item.fst - item.snd))) 0 sortedZippedList;
  in result;
  
  aoc1b = input: let
    lines = lib.strings.splitString "\n" input;
    lines' = lib.lists.take (lib.lists.length lines - 1) lines;
    splitLine = lib.strings.splitString "   ";
    ls = lib.lists.map splitLine lines';
    listLeft = lib.lists.map ((lib.flip lib.pipe) [lib.lists.head builtins.fromJSON]) ls;
    listRight = lib.lists.map ((lib.flip lib.pipe) [lib.lists.last builtins.fromJSON]) ls;
    occurrences = builtins.foldl' (acc: item: acc // {"${builtins.toString item}" = (acc."${builtins.toString item}" or 0) + 1;}) {} listRight;
    similiratyScore = builtins.foldl' (acc: item: acc + item * (occurrences."${builtins.toString item}" or 0)) 0 listLeft;
    result = similiratyScore;
  in result;

  aoc2a = input: let
    lines = lib.strings.splitString "\n" input;
    lines' = lib.lists.take (lib.lists.length lines - 1) lines;
    splitLine = lib.strings.splitString " ";
    ls = lib.lists.map splitLine lines';
    reports = lib.lists.map (lib.lists.map builtins.fromJSON) ls;
    countSafe = builtins.foldl' (acc: report: acc + (if isReportSafe report then 1 else 0)) 0 reports;
    result = countSafe;
  in result;

  aoc2b = input: let
    lines = lib.strings.splitString "\n" input;
    lines' = lib.lists.take (lib.lists.length lines - 1) lines;
    splitLine = lib.strings.splitString " ";
    ls = lib.lists.map splitLine lines';
    reports = lib.lists.map (lib.lists.map builtins.fromJSON) ls;
    countSafe = builtins.foldl' (acc: report: acc + (if isReportSafeTollerant report then 1 else 0)) 0 reports;
    result = countSafe;
  in result;
}
