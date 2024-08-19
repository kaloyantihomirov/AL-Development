table 50101 DiseasesLine_MED_NTG
{
    Caption = 'Diseases Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PatientCode; Code[20])
        {
            Caption = 'Patient Code';
            TableRelation = Patient_MED_NTG;
        }
        field(10; "Examination No."; Code[20])
        {
            Caption = 'Examination No.';
            TableRelation = ExaminationHeader_MED_NTG;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(30; DiseaseCode; Code[20])
        {
            Caption = 'Disease Code';
            TableRelation = Disease_MED_NTG;
        }
        field(40; DiseaseName; Text[50])
        {
            Caption = 'Disease Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Disease_MED_NTG.DiseaseName where("No." = field(DiseaseCode)));
            Editable = false;
        }
        field(41; DiseaseDescription; Text[150])
        {
            Caption = 'Disease Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Disease_MED_NTG.Description where("No." = field(DiseaseCode)));
        }
        field(50; DiagnoseDate; Date)
        {
            Caption = 'Diagnose Date';
            FieldClass = FlowField;
            CalcFormula = lookup(ExaminationHeader_MED_NTG.ExaminationDate where("Examination No." = field("Examination No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; PatientCode, "Examination No.", "Line No.")
        {
            Clustered = true;
        }
    }

}