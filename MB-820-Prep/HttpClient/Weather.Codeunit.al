codeunit 60100 Weather
{
    procedure GetWeatherTemperatureInCelsiusForTown(Town: Text) Temperature: Decimal
    var
        Setup: Record Setup;
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        Uri: Text;
        Params: List of [Text];
        IsSuccessful: Boolean;
        ResponseTxt: Text;
        ResponseJson: JsonObject;
        CannotProcessRequestLbl: Label 'Error while processing the request!';
    begin
        Client.Timeout := 5 * 60 * 1000;
        Headers := Client.DefaultRequestHeaders;
        Headers.Add('Accept', '*/*');
        Headers.Add('Connection', 'keep-alive');
        Headers.Add('Accept-Encoding', 'gzip, deflate, br');

        Content.GetHeaders(ContentHeaders);
        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');

        ContentHeaders.Add('Content-Type', 'application/json');
        Request.Content := Content;

        Params.Add('key=' + Setup.GetWeatherAPIKey());
        Params.Add('q=' + Town);

        //Uri := GetUriWithQueryParams('http://api.weatherapi.com/v1/current.json', Params);
        Uri := 'http://api.weatherapi.com/v1/current.json?key=f9caa94776a34146b97205336241309&q=Sofia';

        Request.SetRequestUri(Uri);
        Request.Method := 'GET';
        IsSuccessful := Client.Send(Request, Response);

        if not IsSuccessful then
            Error(CannotProcessRequestLbl);

        if not Response.IsSuccessStatusCode() then
            Error(CannotProcessRequestLbl);

        Response.Content.ReadAs(ResponseTxt);
        if ResponseJson.ReadFrom(ResponseTxt) then begin
            Evaluate(Temperature, GetJsonField(ResponseJson, 'temp_c'));
            exit(Temperature);
        end;
    end;

    local procedure GetJsonField(JsonObj: JsonObject; Field: Text): Text
    var
        CurrentJSONToken: JsonToken;
        CurrentJSONObj: JsonObject;
        FieldJSONToken: JsonToken;
    begin
        JsonObj.Get('current', CurrentJSONToken);
        CurrentJSONObj := CurrentJSONToken.AsObject();
        CurrentJSONObj.Get(Field, FieldJSONToken);
        exit(FieldJSONToken.AsValue().AsText());
    end;

    local procedure GetUriWithQueryParams(BaseUri: Text; QueryParams: List of [Text]) FullUri: Text
    var
        Count: Integer;
    begin
        FullUri := BaseUri + '?';

        for Count := 1 to QueryParams.Count() - 1 do
            FullUri := FullUri + QueryParams.Get(Count) + '&';

        FullUri := FullUri + QueryParams.Get(QueryParams.Count());

        Message(FullUri);
    end;

}