table 50102 Referral_MED_NTG
{
    Caption = 'Referral';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; IssuedBy; Code[20])
        {
            Caption = 'Issued By.';
            TableRelation = Doctor_MED_NTG;
        }
        field(20; IssuedFor; Code[20])
        {
            Caption = 'Issued For';
            TableRelation = Patient_MED_NTG;
        }
        field(30; ForWhatSpecialisation; Code[20])
        {
            Caption = 'Specialisation Type';
            TableRelation = Specialisation_MED_NTG;

            trigger OnValidate()
            var
                Special: Record Specialisation_MED_NTG;
                CannotIssueReferralToGPLbl: Label 'You cannot issue referral to a general practitioner.';
            begin
                Special.SetRange(Name, 'NONE');

                if Special.FindFirst() then
                    if Special."No." = ForWhatSpecialisation then
                        Error(CannotIssueReferralToGPLbl);
            end;
        }
        field(40; Notes; Text[250])
        {
            Caption = 'Notes';
        }
    }
}