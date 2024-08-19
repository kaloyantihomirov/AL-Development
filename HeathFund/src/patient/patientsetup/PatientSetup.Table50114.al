table 50114 "Patient Setup"
{
    Caption = 'Patient Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PKEY; Code[10])
        {
            Caption = 'PKEY';
            DataClassification = CustomerContent;
        }
        field(2; "Patient Nos."; Code[20])
        {
            Caption = 'No. Series for Patient';
            TableRelation = "No. Series".Code;
        }
    }

    keys
    {
        key(PK; PKEY)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}