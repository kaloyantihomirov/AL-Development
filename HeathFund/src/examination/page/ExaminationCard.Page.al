page 50100 ExaminationCard_MED_NTG
{
    Caption = 'Examination Card';
    PageType = Document;
    SourceTable = ExaminationHeader_MED_NTG;
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General Examination Info';

                field("Examination Type"; Rec."Examination Type")
                {
                    ToolTip = 'Specifies the value of the Examination Type field.', Comment = '%';

                    trigger OnValidate()
                    begin
                        if Rec."Examination Type" = Rec."Examination Type"::ReferralExamination then
                            isVisible := true
                        else
                            isVisible := false;
                    end;
                }
                field("Examination No."; Rec."Examination No.")
                {
                    ToolTip = 'Specifies the value of the Examination No. field.', Comment = '%';
                }
                field(DoneByDoctorId; Rec.DoneByDoctorId)
                {
                    ToolTip = 'Specifies the value of the Done By field.', Comment = '%';
                }
                field(DoctorName; Rec.DoctorName)
                {
                    ToolTip = 'Specifies the value of the Doctor Name field.', Comment = '%';
                }
                field(ExaminationDate; Rec.ExaminationDate)
                {
                    ToolTip = 'Specifies the value of the Examination Date field.', Comment = '%';
                }
            }
            group(HideGroup)
            {
                ShowCaption = false;
                Visible = isVisible;

                field(ReferralId; Rec.ReferralId)
                {
                    ToolTip = 'Specifies the value of the Referral Id field.', Comment = '%';
                    ShowMandatory = isVisible;
                }
                field(ReferralNotes; Rec.ReferralNotes)
                {
                    ToolTip = 'Specifies the value of the Referral Notes field.', Comment = '%';
                }
            }
            group(History)
            {
                Caption = 'Already diagnosed conditions';

                part(PatientAlreadyRegisteredDiseases; DiseasesSubform_MED_NTG)
                {
                    Editable = false;
                    SubPageLink = PatientCode = field(OnPatientCode);
                }

                part(PatientAlreadyTakenMedications; TakenMedicationsSubformMEDNTG)
                {
                    Editable = false;
                    SubPageLink = PatientCode = field(OnPatientCode);
                }
            }
            group(Diagnose)
            {
                Caption = 'Diagnose';


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Finalise Examination")
            {
                Caption = 'Finalise Examination';
                Image = CheckList;

                trigger OnAction()
                begin
                    Message('Clicked!');
                end;
            }
        }
    }

    var
        isVisible: Boolean;

    trigger OnOpenPage()
    begin
        isVisible := false;
    end;
}