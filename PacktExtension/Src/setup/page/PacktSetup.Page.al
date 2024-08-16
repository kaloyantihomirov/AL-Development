page 50200 "Packt Setup_CUS_NTG"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Packt Setup_CUS_NTG";
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Packt Extension Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Minimum Accepted Vendor Rate"; Rec."Minimum Accepted Vendor Rate")
                {
                }
                field("Gift Tolerance Qty"; Rec."Gift Tolerance Qty")
                {
                }
                field("Default Charge (Item)"; Rec."Default Charge (Item)")
                {
                }
                field("Shipmt Commission Calc. Method"; Rec."Shipmt Commission Calc. Method")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}