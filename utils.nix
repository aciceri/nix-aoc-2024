lib: rec {
  quicksort = l: if l == [] then [] else let
    x = builtins.head l;
    xs = builtins.tail l;
    smallerSorted = quicksort (lib.lists.filter (a: a <= x) xs);
    biggerSorted = quicksort (lib.lists.filter (a: a > x) xs);
  in smallerSorted ++ [x] ++ biggerSorted;

  abs = n: if n >= 0 then n else -n;

  toInt = builtins.fromJSON;

  isDigit = c: builtins.elem c (lib.strings.stringToCharacters "0123456789");

  isAlpha = c: builtins.elem c (lib.strings.stringToCharacters "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
}
