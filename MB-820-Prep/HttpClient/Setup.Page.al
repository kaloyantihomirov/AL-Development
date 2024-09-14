page 60100 Setup
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Setup;
    Caption = 'My Custom Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group("Weather API")
            {
                Caption = 'Weather API';

                field("Weather API Key"; ApiKey)
                {
                    Caption = 'Weather API Key';
                    ExtendedDatatype = Masked;
                    Editable = ApiKeyEditable;

                    trigger OnValidate()
                    begin
                        Rec.SetWeatherAPIKey(ApiKey);
                    end;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("GetWeatherAPIKey")
            {
                Caption = 'Get Weather API Key';
                Image = EncryptionKeys;

                trigger OnAction()
                begin
                    Message(Rec.GetWeatherAPIKey());
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then
            Rec.Insert();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ApiKeyEditable := CurrPage.Editable;
        ApiKey := Rec.GetWeatherAPIKey();
    end;

    var
        ApiKey: Text;
        ApiKeyEditable: Boolean;
}