let
    StartDate = #date(2026, 7, 1),
    EndDate = #date(2026, 9, 30),
    Dates = List.Dates(StartDate, Duration.Days(EndDate-StartDate)+1, #duration(1,0,0,0)),
    T = Table.FromList(Dates, Splitter.SplitByNothing(), {"Date"}),
    Typed = Table.TransformColumnTypes(T, {{"Date", type date}}),
    Year = Table.AddColumn(Typed, "Year", each Date.Year([Date]), Int64.Type),
    Quarter = Table.AddColumn(Year, "Quarter", each "Q" & Text.From(Date.QuarterOfYear([Date])), type text),
    MonthNumber = Table.AddColumn(Quarter, "MonthNumber", each Date.Month([Date]), Int64.Type),
    MonthName = Table.AddColumn(MonthNumber, "MonthName", each Date.MonthName([Date], "en-US"), type text),
    YearMonth = Table.AddColumn(MonthName, "YearMonth", each Date.ToText([Date], "yyyy-MM", "en-US"), type text),
    Day = Table.AddColumn(YearMonth, "Day", each Date.Day([Date]), Int64.Type),
    DayName = Table.AddColumn(Day, "DayName", each Date.DayOfWeekName([Date], "en-US"), type text),
    DayOfWeek = Table.AddColumn(DayName, "DayOfWeek", each Date.DayOfWeek([Date], Day.Monday)+1, Int64.Type),
    IsWeekend = Table.AddColumn(DayOfWeek, "IsWeekend", each [DayOfWeek] >= 6, type logical)
in
    IsWeekend
