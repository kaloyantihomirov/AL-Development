page 50119 "Doctor Card_MED_NTG"
{
    PageType = Card;
    Caption = 'Doctor Card';
    ApplicationArea = All;
    SourceTable = Doctor_MED_NTG;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No"; Rec."No.")
                {
                    Caption = 'No.';
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the customer.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    Importance = Standard;
                    ToolTip = 'Specifies the doctor''s name.';
                }
                field(RegistrationDate; Rec.RegistrationDate)
                {
                    ApplicationArea = All;
                    Caption = 'Registration Date';
                    Importance = Standard;
                    ToolTip = 'Specifies the date since the doctor works in our clinic.';
                }
            }
            group(Medical)
            {
                field(SpecialisationCode; Rec.SpecialisationCode)
                {
                    ApplicationArea = All;
                    Caption = 'Specialisation Code';
                    Importance = Standard;
                    ToolTip = 'Specifies the code of the doctor''s specialisation.';
                }
            }
        }
        area(FactBoxes)
        {
            part(NumberOfPatientsFactBox; "Doctor Hist. FactBox_MED_NTG")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }

    procedure AssistEdit(OldDoctor: Record "Doctor_MED_NTG") Result: Boolean
    var
        Setup: Record DoctorSetup_MED_NTG;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAssistEdit(Rec, xRec, Result, IsHandled);
        if IsHandled then
            exit(Result);

        Setup.Get();
        Setup.TestField("Doctor Nos.");
        if NoSeriesMgt.SelectSeries(Setup."Doctor Nos.", OldDoctor."No. Series", Rec."No. Series") then begin
            NoSeriesMgt.SetSeries(Rec."No. Series");
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAssistEdit(var Item: Record Doctor_MED_NTG; var xItem: Record Doctor_MED_NTG; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;
}