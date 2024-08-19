page 50113 "Patient Diseases"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Patient Disease";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the line no. to help keep PK unique';
                }
                field("Patient No."; Rec."Patient No.")
                {
                    ToolTip = 'Specifies the patient no. for whom these disease applies.';
                    DrillDownPageId = "Patient List";
                }
                field("Disease No."; Rec."Disease No.")
                {
                    ToolTip = 'Specifies the disease no. for which the given record applies';
                    DrillDownPageId = "Disease List_MED_NTG";
                }
            }
        }
        area(Factboxes)
        {

        }
    }
}