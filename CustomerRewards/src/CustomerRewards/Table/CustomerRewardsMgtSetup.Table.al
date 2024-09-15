table 50102 "Customer Rewards Mgt Setup NTG"
{
    Caption = 'Customer Rewards Mgt. Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Customer Rewards Ext. Mgt. Codeunit ID"; Integer)
        {
            Caption = 'Customer Rewards Ext. Mgt. Codeunit ID';
            TableRelation = "CodeUnit Metadata".ID;
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