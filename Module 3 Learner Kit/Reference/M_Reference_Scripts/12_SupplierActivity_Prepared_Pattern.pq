// Architecture pattern: deterministic normalization/transformation first, fuzzy only for the remainder.
let
    Activity0 = stg_SupplierActivity_Raw,
    Activity = Table.AddColumn(Activity0, "SupplierNameNormalized", each fnNormalizeSupplierName([SupplierNameRaw]), type text),
    Master0 = stg_SupplierMaster_Raw,
    Master = Table.AddColumn(Master0, "CanonicalNormalized", each fnNormalizeSupplierName([SupplierNameCanonical]), type text),
    Transform0 = stg_SupplierTransform_Raw,
    Transform = Table.TransformColumns(Transform0, {{"From", fnNormalizeSupplierName, type text}, {"To", fnNormalizeSupplierName, type text}}),
    AliasJoin = Table.NestedJoin(Activity, {"SupplierNameNormalized"}, Transform, {"From"}, "Alias", JoinKind.LeftOuter),
    AliasExpand = Table.ExpandTableColumn(AliasJoin, "Alias", {"To"}, {"MappedNormalized"}),
    Candidate = Table.AddColumn(AliasExpand, "CandidateNormalized", each if [MappedNormalized] <> null then [MappedNormalized] else [SupplierNameNormalized], type text),
    ExactJoin = Table.NestedJoin(Candidate, {"CandidateNormalized"}, Master, {"CanonicalNormalized"}, "Exact", JoinKind.LeftOuter),
    ExactExpand = Table.ExpandTableColumn(ExactJoin, "Exact", {"SupplierID","SupplierNameCanonical"}, {"ExactSupplierID","ExactSupplierName"}),
    Matched = Table.SelectRows(ExactExpand, each [ExactSupplierID] <> null),
    Unmatched = Table.SelectRows(ExactExpand, each [ExactSupplierID] = null),
    Fuzzy = Table.FuzzyNestedJoin(Unmatched, {"CandidateNormalized"}, Master, {"CanonicalNormalized"}, "Fuzzy", JoinKind.LeftOuter,
        [IgnoreCase=true, IgnoreSpace=true, NumberOfMatches=1, SimilarityColumnName="Similarity", Threshold=0.80]),
    FuzzyExpand = Table.ExpandTableColumn(Fuzzy, "Fuzzy", {"SupplierID","SupplierNameCanonical","Similarity"}, {"FuzzySupplierID","FuzzySupplierName","Similarity"}),
    ExactTagged = Table.AddColumn(Matched, "MatchMethod", each if [MappedNormalized] <> null then "Transformation" else "Exact", type text),
    FuzzyTagged = Table.AddColumn(FuzzyExpand, "MatchMethod", each if [FuzzySupplierID] <> null then "Fuzzy" else "Unmatched", type text),
    ExactID = Table.AddColumn(ExactTagged, "SupplierID", each [ExactSupplierID], type nullable text),
    FuzzyID = Table.AddColumn(FuzzyTagged, "SupplierID", each [FuzzySupplierID], type nullable text),
    Combined = Table.Combine({ExactID, FuzzyID})
in
    Combined
