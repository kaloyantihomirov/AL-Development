page 50201 MedicationCard_MED_NTG
{
    Caption = 'Medication Card';
    PageType = Card;
    ApplicationArea = All;
    SourceTable = Medication_MED_NTG;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field(VendorNo; Rec.VendorNo)
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                }
            }
        }
    }
}