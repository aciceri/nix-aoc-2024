lib: let
  inherit (import ./utils.nix lib) quicksort abs toInt isDigit isAlpha;

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

  lex = input: let
    chars = lib.strings.stringToCharacters input;
    isWordChar = c: isAlpha c || c == "_" || c == "'";
    classOf = c:
      if isDigit c
      then "num"
      else if isWordChar c
           then "ident"
           else "punct";
    initial = { tokens = []; current = null; };
    flush = acc:
      if acc.current == null
      then acc.tokens
      else acc.tokens ++ [acc.current];
    step = acc: c: let
      class = classOf c;
      sameClass = acc.current != null && acc.current.type == class;
      continues = sameClass && class != "punct";
      extended = acc.current // { text = acc.current.text + c; };
      flushed = flush acc;
      started = { type = class; text = c; };
    in
      if continues
      then builtins.seq extended.text (acc // { current = extended; })
      else builtins.seq flushed { tokens = flushed; current = started; };
    scanned = builtins.foldl' step initial chars;
    result = flush scanned;
  in result;

  parseMuls = tokens: let
    isMul = t: t.type == "ident" && lib.strings.hasSuffix "mul" t.text;
    isNum = t: t.type == "num" && builtins.stringLength t.text <= 3;
    isPunct = p: t: t.type == "punct" && t.text == p;
    shape = [ isMul (isPunct "(") isNum (isPunct ",") isNum (isPunct ")") ];
    shapeLength = builtins.length shape;
    tokenAt = i: builtins.elemAt tokens i;
    predicateAt = k: builtins.elemAt shape k;
    indexes = lib.lists.range 0 (shapeLength - 1);
    matchesAt = i: builtins.all (k: predicateAt k (tokenAt (i + k))) indexes;
    mulAt = i: let
      left = tokenAt (i + 2);
      right = tokenAt (i + 4);
    in { op = "mul"; left = toInt left.text; right = toInt right.text; };
    starts = lib.lists.range 0 (builtins.length tokens - shapeLength);
    matchingStarts = builtins.filter matchesAt starts;
    result = builtins.map mulAt matchingStarts;
  in result;

  parseInstructions = tokens: let
    isWordEnding = w: t: t.type == "ident" && lib.strings.hasSuffix w t.text;
    isNum = t: t.type == "num" && builtins.stringLength t.text <= 3;
    isPunct = p: t: t.type == "punct" && t.text == p;
    tokenAt = i: builtins.elemAt tokens i;
    numAt = i: toInt (tokenAt i).text;
    mulRule = {
      shape = [ (isWordEnding "mul") (isPunct "(") isNum (isPunct ",") isNum (isPunct ")") ];
      build = i: { op = "mul"; left = numAt (i + 2); right = numAt (i + 4); };
    };
    doRule = {
      shape = [ (isWordEnding "do") (isPunct "(") (isPunct ")") ];
      build = i: { op = "do"; };
    };
    dontRule = {
      shape = [ (isWordEnding "don't") (isPunct "(") (isPunct ")") ];
      build = i: { op = "dont"; };
    };
    grammar = [ mulRule doRule dontRule ];
    fits = i: shape: i + builtins.length shape <= builtins.length tokens;
    matchesShape = i: shape: let
      indexes = lib.lists.range 0 (builtins.length shape - 1);
      predicateHolds = k: (builtins.elemAt shape k) (tokenAt (i + k));
    in fits i shape && builtins.all predicateHolds indexes;
    matchesAt = i: rule: matchesShape i rule.shape;
    instructionsAt = i: let
      matchingRules = builtins.filter (matchesAt i) grammar;
    in builtins.map (rule: rule.build i) matchingRules;
    positions = lib.lists.range 0 (builtins.length tokens - 1);
    result = builtins.concatMap instructionsAt positions;
  in result;

  isReportSafeTollerant = report: let
    reportCombinations = builtins.genList (n: let
      before = (lib.lists.take n report);
      after = (lib.lists.take ((lib.lists.length report)-n) (lib.lists.drop (n+1) report));
      in isReportSafe (before ++ after)
    ) (lib.lists.length report);
  in (builtins.any (a: a) reportCombinations);
in {
  inherit isReportSafe isReportSafeTollerant lex parseMuls parseInstructions;

  aoc1a = input: let
    lines = lib.strings.splitString "\n" input;
    lines' = lib.lists.take (lib.lists.length lines - 1) lines;
    splitLine = lib.strings.splitString "   ";
    ls = lib.lists.map splitLine lines';
    listLeft = lib.lists.map ((lib.flip lib.pipe) [lib.lists.head toInt]) ls;
    listRight = lib.lists.map ((lib.flip lib.pipe) [lib.lists.last toInt]) ls;
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
    listLeft = lib.lists.map ((lib.flip lib.pipe) [lib.lists.head toInt]) ls;
    listRight = lib.lists.map ((lib.flip lib.pipe) [lib.lists.last toInt]) ls;
    occurrences = builtins.foldl' (acc: item: acc // {"${builtins.toString item}" = (acc."${builtins.toString item}" or 0) + 1;}) {} listRight;
    similiratyScore = builtins.foldl' (acc: item: acc + item * (occurrences."${builtins.toString item}" or 0)) 0 listLeft;
    result = similiratyScore;
  in result;

  aoc2a = input: let
    lines = lib.strings.splitString "\n" input;
    lines' = lib.lists.take (lib.lists.length lines - 1) lines;
    splitLine = lib.strings.splitString " ";
    ls = lib.lists.map splitLine lines';
    reports = lib.lists.map (lib.lists.map toInt) ls;
    countSafe = builtins.foldl' (acc: report: acc + (if isReportSafe report then 1 else 0)) 0 reports;
    result = countSafe;
  in result;

  aoc2b = input: let
    lines = lib.strings.splitString "\n" input;
    lines' = lib.lists.take (lib.lists.length lines - 1) lines;
    splitLine = lib.strings.splitString " ";
    ls = lib.lists.map splitLine lines';
    reports = lib.lists.map (lib.lists.map toInt) ls;
    countSafe = builtins.foldl' (acc: report: acc + (if isReportSafeTollerant report then 1 else 0)) 0 reports;
    result = countSafe;
  in result;

  aoc3a = input: let
    tokens = lex input;
    muls = parseMuls tokens;
    product = m: m.left * m.right;
    result = builtins.foldl' (acc: m: acc + product m) 0 muls;
  in result;

  aoc3b = input: let
    tokens = lex input;
    instructions = parseInstructions tokens;
    initial = { enabled = true; sum = 0; };
    product = instr: instr.left * instr.right;
    step = acc: instr:
      if instr.op == "do"
      then acc // { enabled = true; }
      else if instr.op == "dont"
           then acc // { enabled = false; }
           else if acc.enabled
                then acc // { sum = acc.sum + product instr; }
                else acc;
    executed = builtins.foldl' step initial instructions;
    result = executed.sum;
  in result;
}
