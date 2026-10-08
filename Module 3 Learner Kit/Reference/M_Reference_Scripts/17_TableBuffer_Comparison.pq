// Demonstration only: Table.Buffer can create a local materialization boundary and may help or harm.
let
    Source = Sql.Database(pSQLServer, pSQLDatabase),
    IntervalGeneration = Source{[Schema="dbo", Item="IntervalGeneration"]}[Data],
    Buffered = Table.Buffer(IntervalGeneration),
    FilteredLocally = Table.SelectRows(Buffered, each [IntervalStartUTC] >= RangeStart and [IntervalStartUTC] < RangeEnd)
in
    FilteredLocally
