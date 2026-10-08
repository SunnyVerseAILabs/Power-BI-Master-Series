let
    Files = Folder.Files(pMonthlyExtractFolder),
    CsvOnly = Table.SelectRows(Files, each Text.Lower([Extension]) = ".csv" and not Text.StartsWith([Name], ".")),
    Invoke = Table.AddColumn(CsvOnly, "Prepared", each fnTransformPlantExtract([Content], [Name]), type table),
    Keep = Table.SelectColumns(Invoke, {"Name","Prepared"}),
    Expand = Table.ExpandTableColumn(Keep, "Prepared", {"PlantID","Date","RegionName","TechnologyFamily","ActualGenerationMWh","ForecastGenerationMWh","Unit","SourceFile"})
in
    Expand
