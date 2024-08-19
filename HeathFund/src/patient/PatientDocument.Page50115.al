page 50115 "Patient Document"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Patient_MED_NTG;
    Caption = 'Patient Document';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name of the patient field.', Comment = '%';
                }
                field(Birthdate; Rec.Birthdate)
                {
                    ToolTip = 'Specifies the value of the Birth date of the patient field.', Comment = '%';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.', Comment = '%';
                }
                field(UCN; Rec.UCN)
                {
                    ToolTip = 'Specifies the value of the The unified citizen''s number field.', Comment = '%';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.', Comment = '%';
                }
            }
            group(Medical)
            {
                field(IsHealthInsured; Rec.IsHealthInsured)
                {
                    ToolTip = 'Specifies if the person pays their health insurance.';
                }
                field("GP Code"; Rec."GP Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the GP of the current patient.';
                    Importance = Standard;
                }
            }
            part(PatientLine; "Patient Subform")
            {
                ApplicationArea = All;
                Editable = false;
                SubPageLink = "Patient No." = field("No.");
                UpdatePropagation = Both;
            }
        }
    }

    procedure AssistEdit(OldPatient: Record Patient_MED_NTG) Result: Boolean
    var
        Setup: Record "Patient Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAssistEdit(Rec, xRec, Result, IsHandled);
        if IsHandled then
            exit(Result);

        Setup.Get();
        Setup.TestField("Patient Nos.");
        if NoSeriesMgt.SelectSeries(Setup."Patient Nos.", OldPatient."No. Series", Rec."No. Series") then begin
            NoSeriesMgt.SetSeries(Rec."No. Series");
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAssistEdit(var Item: Record Patient_MED_NTG; var xItem: Record Patient_MED_NTG; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;
}