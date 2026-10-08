// Deterministic normalization before transformation-table or fuzzy matching.
(Name as nullable text) as nullable text =>
let
    Trimmed = if Name = null then null else Text.Trim(Text.Clean(Name)),
    Upper = if Trimmed = null then null else Text.Upper(Trimmed),
    NoDots = if Upper = null then null else Text.Replace(Upper, ".", ""),
    NormalizedSpaces = if NoDots = null then null else Text.Combine(List.Select(Text.SplitAny(NoDots, " "), each _ <> ""), " ")
in
    NormalizedSpaces
