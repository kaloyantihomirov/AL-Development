page 50111 "Specialisation List_MED_NTG"
{
    Caption = 'Specialisations';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Specialisation_MED_NTG;
    CardPageId = SpecialisationCard_MED_NTG;
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
                    ToolTip = 'Specifies the value of the Name of the specialisation field.', Comment = '%';
                }
                field(SpecialisedInDoctors; Rec.SpecialisedInDoctors)
                {
                    ToolTip = 'Specifies how many doctors have the relevant specialisation.';
                }
            }
        }
    }
}