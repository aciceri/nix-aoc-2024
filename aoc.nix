lib: let
  quicksort = l: if l == [] then [] else let
    x = builtins.head l;
    xs = builtins.tail l;
    smallerSorted = quicksort (lib.lists.filter (a: a <= x) xs);
    biggerSorted = quicksort (lib.lists.filter (a: a > x) xs);
  in smallerSorted ++ [x] ++ biggerSorted;
  abs = n: if n >= 0 then n else -n;
in {
  inherit quicksort;
  
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
}
