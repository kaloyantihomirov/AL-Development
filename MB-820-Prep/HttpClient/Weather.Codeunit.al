codeunit 60100 Weather
{
    var
        BaseWeatherUri: Label 'http://api.weatherapi.com/v1/current.json', Locked = true;

    procedure GetWeatherTemperatureForTown(Town: Text; Unit: Char) Temperature: Decimal
    var
        Client: HttpClient;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        IsSuccessful: Boolean;
        ResponseTxt: Text;
        ResponseJson: JsonObject;
        ServiceCallErr: Label 'Web service call failed';
        ServiceStatusErr: Label 'Web service status error';
        ErrorInfoObject: ErrorInfo;
        HttpStatusCode: Integer;
    begin
        if ((LowerCase(Unit) <> 'c') and (LowerCase(Unit) <> 'f')) then begin
            ErrorInfoObject.DetailedMessage := 'The provided unit for temperature is not valid. (Should be Celsius or Fahrenheit.)';
            ErrorInfoObject.Message := 'Invalid temperature unit.';
            Error(ErrorInfoObject);
        end;

        Content.GetHeaders(ContentHeaders);

        if ContentHeaders.Contains('Content-Type') then
            ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        if ContentHeaders.Contains('Content-Encoding') then
            ContentHeaders.Remove('Content-Encoding');
        ContentHeaders.Add('Content-Encoding', 'UTF8');

        Request.SetRequestUri(GetRequestUri(Town));
        Request.Method('GET');
        Request.Content(Content);

        IsSuccessful := Client.Send(Request, Response);

        if not IsSuccessful then begin
            ErrorInfoObject.DetailedMessage := 'Sorry, we could not retrive the weather info right now.';
            ErrorInfoObject.Message := ServiceCallErr;
            Error(ErrorInfoObject);
        end;

        if not Response.IsSuccessStatusCode() then begin
            HttpStatusCode := Response.HttpStatusCode();
            ErrorInfoObject.DetailedMessage := 'Sorry, we could not retrive the weather info right now.';
            ErrorInfoObject.Message := Format(ServiceStatusErr, HttpStatusCode, Response.ReasonPhrase());
            Error(ErrorInfoObject);
        end;

        Response.Content.ReadAs(ResponseTxt);

        if ResponseJson.ReadFrom(ResponseTxt) then begin
            case LowerCase(Unit) of
                'c':
                    Evaluate(Temperature, GetJsonField(ResponseJson, 'temp_c'));
                'f':
                    Evaluate(Temperature, GetJsonField(ResponseJson, 'temp_f'));
            end;

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

    local procedure GetUriWithQueryParams(BaseUri: Text; QueryParams: Dictionary of [Text, Text]) FullUri: Text
    var
        DictionaryKey: Text;
        ParamsSeparator: Text;
    begin
        ParamsSeparator := '&&';
        FullUri := '';
        FullUri := FullUri + BaseUri + '?';

        foreach DictionaryKey in QueryParams.Keys() do
            FullUri := FullUri + StrSubstNo('%1=%2%3', DictionaryKey, QueryParams.Get(DictionaryKey), ParamsSeparator);

        FullUri := FullUri.Substring(1, StrLen(FullUri) - 1);
    end;

    local procedure GetRequestUri(Town: Text): Text
    var
        Setup: Record Setup;
        QueryParams: Dictionary of [Text, Text];
    begin
        QueryParams.Add('key', Setup.GetWeatherAPIKey());
        QueryParams.Add('q', Town);

        exit(GetUriWithQueryParams(BaseWeatherUri, QueryParams));
    end;
}
