table 60100 Setup
{
    DataClassification = CustomerContent;
    Caption = 'My Custom Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        // the goal is to avoid that field to hide the secret API key from other extensions
        // field(2; "Weather API Key"; Text[50])
        // {
        //     Caption = 'Weather API Key';
        // }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure SetWeatherAPIKey(KeyVal: Text): Text
    var
        IsolatedStorageMgt: Codeunit "Isolated Storage Management";
    begin
        IsolatedStorageMgt.Set('WeatherAPIKey', KeyVal, DataScope::Module);
        exit(KeyVal);
    end;

    procedure GetWeatherAPIKey(): Text
    var
        IsolatedStorageMgt: Codeunit "Isolated Storage Management";
        KeyVal: Text;
    begin
        if IsolatedStorageMgt.Get('WeatherAPIKey', DataScope::Module, KeyVal) then
            exit(KeyVal);
    end;
}