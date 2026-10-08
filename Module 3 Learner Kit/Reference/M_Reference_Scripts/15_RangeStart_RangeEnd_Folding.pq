let
    Source = Sql.Database(pSQLServer, pSQLDatabase),
    IntervalGeneration = Source{[Schema="dbo", Item="IntervalGeneration"]}[Data],
    Filtered = Table.SelectRows(IntervalGeneration, each [IntervalStartUTC] >= RangeStart and [IntervalStartUTC] < RangeEnd)
in
    Filtered
