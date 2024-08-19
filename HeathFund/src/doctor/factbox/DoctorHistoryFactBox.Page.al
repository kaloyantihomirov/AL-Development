page 50120 "Doctor Hist. FactBox_MED_NTG"
{
    Caption = 'Doctor History';
    PageType = CardPart;
    SourceTable = Doctor_MED_NTG;

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
                Caption = 'Doctor No.';
                ToolTip = 'Specifies the number of the doctor';

                trigger OnDrillDown()
                begin
                    ShowDetails();
                end;
            }
            // group(Control23)
            // {
            //     Visible = false;
            //     ShowCaption = false;

            //     field("No. of Patients"; Rec."No. of Patients")
            //     {
            //         ApplicationArea = All;
            //         Caption = 'No. of Patients';
            //         DrillDownPageID = "Patient List";
            //         ToolTip = 'Specifies the number of patients that have been registered for the customer.';
            //     }
            // }
            cuegroup(DoctorsCueContainer)
            {
                ShowCaption = false;

                field("NoOfPatientsTile"; Rec."No. of Patients")
                {
                    ApplicationArea = All;
                    Caption = 'No. of Patients';
                    DrillDownPageId = "Patient List";
                    ToolTip = 'Specifies the number of patients that have been registered for the customer.';
                }
                field(SpecialisationDoctorsCount; Rec.DoctorsWSameSpecialisation)
                {
                    ApplicationArea = All;
                    Caption = 'Specialisation Doctors';
                    DrillDownPageId = "Doctor List_MED_NTG";
                    ToolTip = 'Specifies the number of doctors with the given specialisation.';
                }
            }
        }
    }

    local procedure ShowDetails()
    begin
        PAGE.Run(PAGE::"Doctor Card_MED_NTG", Rec);
    end;
}

