let
    Source = stg_TargetsWide_Raw,
    TypedIDs = Table.TransformColumnTypes(Source, {{"PlantID", type text}, {"TargetType", type text}, {"Unit", type text}}),
    Long = Table.UnpivotOtherColumns(TypedIDs, {"PlantID","TargetType","Unit"}, "TargetMonthText", "TargetValue"),
    Month = Table.AddColumn(Long, "TargetMonth", each Date.FromText([TargetMonthText] & "-01", [Culture="en-US"]), type date),
    Numeric = Table.TransformColumnTypes(Month, {{"TargetValue", type number}}),
    Final = Table.RemoveColumns(Numeric, {"TargetMonthText"})
in
    Final
