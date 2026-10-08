// Error evidence stays separate from the prepared business output.
let
    Source = stg_Maintenance_Raw,
    NonBlank = Table.SelectRows(Source, each List.NonNullCount(Record.FieldValues(_)) > 0),
    ExactDistinct = Table.Distinct(NonBlank),
    WithStart = Table.AddColumn(ExactDistinct, "StartAttempt", each try DateTime.FromText([StartDateTimeText], [Culture=pCulture])),
    WithDuration = Table.AddColumn(WithStart, "DurationAttempt", each try if [DurationHoursText]=null or Text.Trim([DurationHoursText])="" then null else Number.FromText(Text.Trim([DurationHoursText]), pCulture)),
    WithCost = Table.AddColumn(WithDuration, "CostAttempt", each try if [CostUSDText]=null or Text.Trim([CostUSDText])="" then null else Number.FromText(Text.Replace(Text.Replace(Text.Trim([CostUSDText]), "$", ""), ",", ""), pCulture)),
    ErrorRows = Table.SelectRows(WithCost, each [StartAttempt][HasError] or [DurationAttempt][HasError] or [CostAttempt][HasError]),
    WithReason = Table.AddColumn(ErrorRows, "ErrorField", each if [StartAttempt][HasError] then "StartDateTimeText" else if [DurationAttempt][HasError] then "DurationHoursText" else "CostUSDText", type text),
    Result = Table.SelectColumns(WithReason, {"MaintenanceEventID","PlantID","ErrorField","StartDateTimeText","DurationHoursText","CostUSDText"})
in
    Result
