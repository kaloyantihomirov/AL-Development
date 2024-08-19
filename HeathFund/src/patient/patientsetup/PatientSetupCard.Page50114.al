page 50114 "Patient Setup"
{
    Caption = 'Patient Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Patient Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Patient Nos."; Rec."Patient Nos.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then
            Rec.Insert();
    end;
}
