// Reference pattern: downstream query depends on the prepared upstream result.
let
    Source = Maintenance_Prepared,
    CompletedOnly = Table.SelectRows(Source, each [Status] = "Completed")
in
    CompletedOnly

// A Duplicate is created through the UI as a separate copied definition; it does not keep this dependency.
