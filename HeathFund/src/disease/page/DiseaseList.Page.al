page 50110 "Disease List_MED_NTG"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Disease_MED_NTG;
    Caption = 'Disease List';
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
                field(DiseaseName; Rec.DiseaseName)
                {
                    ToolTip = 'Specifies the value of the Name of the disease field.', Comment = '%';
                }
            }
        }
    }
}