// Keep the required contract; ignore additional optional columns.
let
    Source = stg_SupplierActivity_Raw,
    Contract = Table.SelectColumns(
        Source,
        {"ActivityID","PlantID","SupplierNameRaw","CountryCode","ActivityDateText"},
        MissingField.Error
    )
in
    Contract
