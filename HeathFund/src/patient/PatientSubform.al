page 50116 "Patient Subform"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Patient Disease";
    Caption = 'Patient Diseases';

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Disease No."; Rec."Disease No.")
                {
                    ToolTip = 'Specifies the disease no. for which the given record applies';
                }
                // field("Line No."; Rec."Line No.")
                // {
                //     ToolTip = 'Specifies the line no. to help keep PK unique';
                // }
                // field("Patient No."; Rec."Patient No.")
                // {
                //     ToolTip = 'Specifies the patient no. for whom these disease applies.';
                // }
                field(DiseaseName; Rec.DiseaseName)
                {
                    ToolTip = 'Specifies the value of the Disease Name field.', Comment = '%';
                }
                field(DiseaseDescription; Rec.DiseaseDescription)
                {
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Disease Description field.', Comment = '%';
                }
            }
        }
    }
}