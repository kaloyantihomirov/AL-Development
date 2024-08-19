page 50117 "Doctor List_MED_NTG"
{
    PageType = List;
    Caption = 'Doctors';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Doctor_MED_NTG;
    CardPageId = "Doctor Card_MED_NTG";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the no. of the doctor';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the doctor.';
                }
                field(SpecialisationCode; Rec.SpecialisationCode)
                {
                    ToolTip = 'Specifies the no. of the specialisation the doctor has. NONE is used for GPs.';
                }
                field(RegistrationDate; Rec.RegistrationDate)
                {
                    ToolTip = 'Specifies the date since the doctor works in our clinic.';
                }
            }
        }
    }
}