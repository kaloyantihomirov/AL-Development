table 50113 "Patient Disease"
{
    Caption = 'Patient Disease';

    fields
    {
        field(1; "Patient No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Patient No.';
            TableRelation = Patient_MED_NTG."No.";
        }
        field(10; "Disease No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Disease No.';
            TableRelation = Disease_MED_NTG."No.";
        }
        field(20; "Line No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(30; DiseaseName; Text[50])
        {
            Caption = 'Disease Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Disease_MED_NTG.DiseaseName where("No." = field("Disease No.")));
        }
        field(40; DiseaseDescription; Text[150])
        {
            Caption = 'Disease Description';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Disease_MED_NTG.Description where("No." = field("Disease No.")));
        }
    }

    keys
    {
        key(PK; "Patient No.", "Disease No.")
        {

        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}