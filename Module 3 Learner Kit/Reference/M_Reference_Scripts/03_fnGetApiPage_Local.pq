// Mandatory no-account/local deterministic pagination function.
(PageNumber as number) as record =>
let
    FileName = "page_" & Text.PadStart(Text.From(PageNumber), 3, "0") & ".json",
    Payload = Json.Document(File.Contents(pDataRoot & "\\API_Pages\\" & FileName)),
    Data = Table.FromRecords(Payload[data]),
    NextPage = try Payload[nextPage] otherwise null
in
    [Data = Data, NextPage = NextPage]
