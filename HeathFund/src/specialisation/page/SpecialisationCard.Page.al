page 50140 SpecialisationCard_MED_NTG
{
    Caption = 'Specialisation Card';
    PageType = Card;
    SourceTable = Specialisation_MED_NTG;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Name; Rec.Name)
                {
                }
                field(Description; Rec.Description)
                {
                    MultiLine = true;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';

                field(SpecialisedInDoctors; Rec.SpecialisedInDoctors)
                {
                }
            }
        }
    }
}