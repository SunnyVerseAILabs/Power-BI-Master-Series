// Meaning-preserving maintenance preparation: remove blank/exact duplicate rows,
// repair duration only from stronger timestamp evidence, retain unknown cost as null,
// and quarantine invalid StartDateTime rows from the prepared output.
let
    Source = stg_Maintenance_Raw,
    NonBlank = Table.SelectRows(Source, each List.NonNullCount(Record.FieldValues(_)) > 0),
    ExactDistinct = Table.Distinct(NonBlank),
    CleanText = Table.TransformColumns(ExactDistinct, {
        {"MaintenanceType", each if _ = null then null else Text.Proper(Text.Trim(Text.Clean(_))), type text},
        {"Status", each if _ = null then null else Text.Proper(Text.Trim(Text.Clean(_))), type text},
        {"TechnicianTeam", each if _ = null then null else Text.Trim(Text.Clean(_)), type text},
        {"SafetyCriticalText", each if _ = null then null else Text.Upper(Text.Trim(Text.Clean(_))), type text}
    }),
    AddStartTry = Table.AddColumn(CleanText, "StartTry", each try DateTime.FromText([StartDateTimeText], [Culture=pCulture])),
    AddEndTry = Table.AddColumn(AddStartTry, "EndTry", each try if [EndDateTimeText]=null or Text.Trim([EndDateTimeText])="" then null else DateTime.FromText([EndDateTimeText], [Culture=pCulture])),
    AddDurationTry = Table.AddColumn(AddEndTry, "DurationTry", each try if [DurationHoursText]=null or Text.Trim([DurationHoursText])="" then null else Number.FromText(Text.Trim([DurationHoursText]), pCulture)),
    AddCostTry = Table.AddColumn(AddDurationTry, "CostTry", each try if [CostUSDText]=null or Text.Trim([CostUSDText])="" then null else Number.FromText(Text.Replace(Text.Replace(Text.Trim([CostUSDText]), "$", ""), ",", ""), pCulture)),
    AddStart = Table.AddColumn(AddCostTry, "StartDateTime", each if [StartTry][HasError] then null else [StartTry][Value], type nullable datetime),
    AddEnd = Table.AddColumn(AddStart, "EndDateTime", each if [EndTry][HasError] then null else [EndTry][Value], type nullable datetime),
    AddDuration = Table.AddColumn(AddEnd, "DurationHours", each
        if not [DurationTry][HasError] then [DurationTry][Value]
        else if [StartDateTime] <> null and [EndDateTime] <> null then Duration.TotalHours([EndDateTime]-[StartDateTime])
        else null, type nullable number),
    AddCost = Table.AddColumn(AddDuration, "CostUSD", each if [CostTry][HasError] then null else [CostTry][Value], Currency.Type),
    AddSafety = Table.AddColumn(AddCost, "SafetyCritical", each if [SafetyCriticalText]="TRUE" then true else if [SafetyCriticalText]="FALSE" then false else null, type nullable logical),
    ValidStart = Table.SelectRows(AddSafety, each [StartDateTime] <> null),
    Final = Table.SelectColumns(ValidStart, {"MaintenanceEventID","PlantID","WorkOrderID","MaintenanceType","Status","StartDateTime","EndDateTime","DurationHours","CostUSD","TechnicianTeam","SafetyCritical","Notes"})
in
    Final
