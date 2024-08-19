page 50118 "Doctor Setup Card_MED_NTG"
{
    PageType = Card;
    Caption = 'Doctor Setup';
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = DoctorSetup_MED_NTG;

    layout
    {
        area(Content)
        {
            field("Doctor Nos."; Rec."Doctor Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number series that will be used to assign numbers to doctors.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            OnOpenPageOnBeforeRecInsert(Rec);
            Rec.Insert();
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnOpenPageOnBeforeRecInsert(var DoctorSetup: Record "DoctorSetup_MED_NTG")
    begin
    end;
}