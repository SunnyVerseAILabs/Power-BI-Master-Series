// Canonical file-transform function for the healthy monthly generation CSV contract.
(Content as binary, optional FileName as nullable text) as table =>
let
    Csv = Csv.Document(Content, [Delimiter=",", Encoding=65001, QuoteStyle=QuoteStyle.Csv]),
    Headers = Table.PromoteHeaders(Csv, [PromoteAllScalars=true]),
    Contract = Table.SelectColumns(
        Headers,
        {"PlantID","Date","RegionName","TechnologyFamily","ActualGenerationMWh","ForecastGenerationMWh","Unit"},
        MissingField.Error
    ),
    Typed = Table.TransformColumnTypes(
        Contract,
        {
            {"PlantID", type text}, {"Date", type date}, {"RegionName", type text},
            {"TechnologyFamily", type text}, {"ActualGenerationMWh", type number},
            {"ForecastGenerationMWh", type number}, {"Unit", type text}
        },
        "en-US"
    ),
    WithSource = if FileName = null then Typed else Table.AddColumn(Typed, "SourceFile", each FileName, type text)
in
    WithSource
