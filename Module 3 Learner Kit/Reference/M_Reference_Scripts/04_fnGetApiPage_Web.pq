// Published no-account endpoint variant. Use only after pApiBaseUrl is verified.
(PageNumber as number) as record =>
let
    Relative = "page_" & Text.PadStart(Text.From(PageNumber), 3, "0") & ".json",
    Payload = Json.Document(Web.Contents(pApiBaseUrl, [RelativePath = Relative])),
    Data = Table.FromRecords(Payload[data]),
    NextPage = try Payload[nextPage] otherwise null
in
    [Data = Data, NextPage = NextPage]
