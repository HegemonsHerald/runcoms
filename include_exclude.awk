# provide pattern file using 'file'-cli variable:
#  ... | awk -f <this> -v file=<pattern file> | ...

# pattern file has two ini-sections: [INCLUDE] and [EXCLUDE]

# lines matching include-patterns are definitely included.
# If a line also matches an exclude-pattern it will still
# be included, so the rule is:
#
#   Make exclude patterns more general and use specific
#   include patterns to keep what you don't want removed.
#
# Eg:
#
#   Exclude all patterns matching '.config/' but include
#   lines with '.config/alacritty' anyways.

BEGIN {

   read_state = "Neither"
   while (getline x <file > 0) {

      if      (match(x, /^\[INCLUDE\]$/) != 0) read_state = "Include";
      else if (match(x, /^\[EXCLUDE\]$/) != 0) read_state = "Exclude";

      else if (x == "") continue;

      else if (read_state == "Include") includes[x];
      else if (read_state == "Exclude") excludes[x];

   } 

}


{
   if (included(line) || !excluded(line)) { print } else { next }

   # included || ! excluded
   # 
   #   ┏━━━┳━━━┳━━━━━━━━━━━━━━┳━━━┓
   #   ┃ i ┃ e ┃ i OR (NOT e) ┃ = ┃
   #   ┣━━━╋━━━╋━━━━━━━━━━━━━━╋━━━┫
   #   │ 1 │ _ │ 1 OR _______ │ 1 │
   #   ├───┼───┼──────────────┼───┤
   #   │ 0 │ 0 │ 0 OR    1    │ 1 │
   #   ├───┼───┼──────────────┼───┤
   #   │ 0 │ 1 │ 0 OR    0    │ 0 │
   #   └───┴───┴──────────────┴───┘
   # 
   # >> true if included
   # >> true if not excluded (but also not included)
   # >> false if excluded
}

# true if line matches one of the include-patterns
function included(line) {
   return match_patterns(line, includes)
}

# true if line matches one of the exclude-patterns
function excluded(line) {
   return match_patterns(line, includes)
}

function match_patterns(line, patterns) {
   for (patt in patterns) {
      if (match(line, patt)) return 1;
   }
   return 0
}
