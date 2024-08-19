page 50112 "Patient List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Patient_MED_NTG;
    Caption = 'Patients';
    CardPageId = "Patient Document";

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
                    ToolTip = 'Specifies the value of the Name of the patient field.', Comment = '%';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.', Comment = '%';
                }
                field(UCN; Rec.UCN)
                {
                    Caption = 'UCN';
                    ToolTip = 'Specifies the value of the The unified citizen''s number field.', Comment = '%';
                }
                field(Birthdate; Rec.Birthdate)
                {
                    ToolTip = 'Specifies the value of the Birth date of the patient field.', Comment = '%';
                }
                // field(Address; Rec.Address)
                // {
                //     ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                // }
                // field(City; Rec.City)
                // {
                //     ToolTip = 'Specifies the value of the City field.', Comment = '%';
                // }
                field(IsHealthInsured; Rec.IsHealthInsured)
                {
                    ToolTip = 'Specifies if the person pays their health insurance.';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}