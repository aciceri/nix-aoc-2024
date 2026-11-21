lib: rec {
  quicksort = l: if l == [] then [] else let
    x = builtins.head l;
    xs = builtins.tail l;
    smallerSorted = quicksort (lib.lists.filter (a: a <= x) xs);
    biggerSorted = quicksort (lib.lists.filter (a: a > x) xs);
  in smallerSorted ++ [x] ++ biggerSorted;

  abs = n: if n >= 0 then n else -n;
}
