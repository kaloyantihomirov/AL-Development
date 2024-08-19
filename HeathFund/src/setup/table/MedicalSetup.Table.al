table 50140 MedicalSetup_CUS_NTG
{
    Caption = 'Medical Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(10; "Specialisation Nos."; Code[20])
        {
            Caption = 'Specialisation Nos.';
            TableRelation = "No. Series";
        }
    }
}