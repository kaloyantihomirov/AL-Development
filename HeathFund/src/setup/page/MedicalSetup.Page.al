page 50141 MedicalSetup_CUS_NTG
{
    Caption = 'Medical Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = MedicalSetup_CUS_NTG;

    layout
    {
        area(Content)
        {
            group("No. Series")
            {
                Caption = 'No. Series';
                field("Specialisation Nos."; Rec."Specialisation Nos.")
                {
                }
            }
        }
    }

    //TODO: why can't we just use if not Rec.Insert(). I tried to debug and I think that even before
    //entering the onopenpage trigger the rec is initialised, so what does reset and init do 
    //in this case that may come helpful?
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}