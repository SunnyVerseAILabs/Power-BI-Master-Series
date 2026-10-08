// Pagination state machine. The frozen course contract returns 4 pages x 7 rows = 28 rows.
let
    Pages = List.Generate(
        () => fnGetApiPage(1),
        each _ <> null,
        each if [NextPage] = null then null else fnGetApiPage([NextPage]),
        each [Data]
    ),
    Combined = Table.Combine(Pages)
in
    Combined
