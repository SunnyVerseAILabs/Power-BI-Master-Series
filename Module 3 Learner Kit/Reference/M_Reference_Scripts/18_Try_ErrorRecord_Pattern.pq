let
    Raw = "five",
    Attempt = try Number.FromText(Raw, "en-US"),
    HasError = Attempt[HasError],
    Value = if HasError then null else Attempt[Value],
    ErrorRecord = if HasError then Attempt[Error] else null,
    Result = [Raw=Raw, HasError=HasError, Value=Value, Error=ErrorRecord]
in
    Result
