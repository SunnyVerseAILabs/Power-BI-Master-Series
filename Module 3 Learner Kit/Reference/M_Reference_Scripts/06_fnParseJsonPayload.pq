(PayloadText as nullable text) as record =>
let
    Attempt = try if PayloadText = null then null else Json.Document(Text.ToBinary(PayloadText)),
    Result = if Attempt[HasError]
        then [HasError=true, Value=null, Error=Attempt[Error]]
        else [HasError=false, Value=Attempt[Value], Error=null]
in
    Result
