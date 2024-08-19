table 50100 ExaminationHeader_MED_NTG
{
    Caption = 'Examination Header';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Examination Type"; enum ExaminationType_MED_NTG)
        {
            Caption = 'Examination Type';
        }
        field(10; "Examination No."; Code[20])
        {
            Caption = 'Examination No.';
        }
        field(11; ExaminationDate; Date)
        {
            Caption = 'Examination Date';
        }
        field(12; OnPatientCode; Code[20])
        {
            Caption = 'Patient Code';
            TableRelation = Patient_MED_NTG;
        }
        field(13; OnPatientName; Text[100])
        {
            Caption = 'Patient Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Patient_MED_NTG.Name where("No." = field(OnPatientCode)));
            Editable = false;
        }
        field(20; DoneByDoctorId; Code[20])
        {
            Caption = 'Done By';
            TableRelation = Doctor_MED_NTG;
        }
        field(21; DoctorName; Code[100])
        {
            Caption = 'Doctor Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Doctor_MED_NTG.Name where("No." = field(DoneByDoctorId)));
            Editable = false;
        }
        field(30; ReferralId; Code[20])
        {
            Caption = 'Referral Id';
            TableRelation = Referral_MED_NTG;
        }
        field(40; ReferralNotes; Text[250])
        {
            Caption = 'Referral Notes';
            FieldClass = FlowField;
            CalcFormula = lookup(Referral_MED_NTG.Notes where("No." = field(ReferralId)));
        }
    }

    keys
    {
        key(PK; "Examination No.")
        {
            Clustered = true;
        }
        key(FK1; "Examination Type")
        {
        }
        key(FK2; DoneByDoctorId)
        {
        }
        key(FK3; ExaminationDate)
        {
        }
    }
}