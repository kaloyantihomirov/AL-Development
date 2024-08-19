page 50200 MedicationList_MED_NTG
{
    Caption = 'Medication List';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Medication_MED_NTG;
    CardPageId = MedicationCard_MED_NTG;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
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