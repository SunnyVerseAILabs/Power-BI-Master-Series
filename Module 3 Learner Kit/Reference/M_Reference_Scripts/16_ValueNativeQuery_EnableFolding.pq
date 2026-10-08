let
    Source = Sql.Database(pSQLServer, pSQLDatabase),
    Native = Value.NativeQuery(
        Source,
        "SELECT PlantID, IntervalStartUTC, ActualGenerationMWh, ForecastGenerationMWh FROM dbo.IntervalGeneration",
        null,
        [EnableFolding=true]
    ),
    Filtered = Table.SelectRows(Native, each [IntervalStartUTC] >= RangeStart and [IntervalStartUTC] < RangeEnd)
in
    Filtered
