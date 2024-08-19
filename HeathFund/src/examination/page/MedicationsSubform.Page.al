page 50205 TakenMedicationsSubformMEDNTG
{
    Caption = 'Taken Medications Subform';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = MedicationsLine_MED_NTG;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(MedicationCode; Rec.MedicationCode)
                {
                    ToolTip = 'Specifies the value of the Medication Code field.', Comment = '%';
                }
                field(MedicationName; Rec.MedicationName)
                {
                    ToolTip = 'Specifies the value of the Medication Name field.', Comment = '%';
                }
                field(UnitOfMeasurement; Rec.UnitOfMeasurement)
                {
                    ToolTip = 'Specifies the value of the Unit of Measurement field.', Comment = '%';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.', Comment = '%';
                }
                field(StartDate; Rec.StartDate)
                {
                    ToolTip = 'Specifies the value of the Start Date field.', Comment = '%';
                }
                field(EndDate; Rec.EndDate)
                {
                    ToolTip = 'Specifies the value of the End Date field.', Comment = '%';
                }
                field("Examination No."; Rec."Examination No.")
                {
                    ToolTip = 'Specifies the value of the Examination No. field.', Comment = '%';
                }
            }
        }
    }

    // views
    // {
    //     view(CurrentlyTaken)
    //     {
    //     }
    // }
}