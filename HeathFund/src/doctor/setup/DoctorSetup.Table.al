table 50115 DoctorSetup_MED_NTG
{
    Caption = 'Doctor Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary key';
        }
        field(10; "Doctor Nos."; Code[20])
        {
            Caption = 'Doctor Nos.';
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}