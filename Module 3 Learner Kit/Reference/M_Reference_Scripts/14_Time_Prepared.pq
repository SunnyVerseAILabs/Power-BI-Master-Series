let
    Times = List.Times(#time(0,0,0), 96, #duration(0,0,15,0)),
    T = Table.FromList(Times, Splitter.SplitByNothing(), {"Time"}),
    Typed = Table.TransformColumnTypes(T, {{"Time", type time}}),
    Index = Table.AddIndexColumn(Typed, "TimeKey", 0, 1, Int64.Type),
    Hour = Table.AddColumn(Index, "Hour", each Time.Hour([Time]), Int64.Type),
    Minute = Table.AddColumn(Hour, "Minute", each Time.Minute([Time]), Int64.Type),
    QuarterHourIndex = Table.AddColumn(Minute, "QuarterHourIndex", each Number.IntegerDivide([Minute],15), Int64.Type),
    QuarterHourLabel = Table.AddColumn(QuarterHourIndex, "QuarterHourLabel", each Time.ToText([Time], "HH:mm"), type text)
in
    QuarterHourLabel
