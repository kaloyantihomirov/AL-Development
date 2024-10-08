table 50101 "Activation Code Inform. NTG"
{
    Caption = 'Activation Code Information';
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; ActivationCode; Text[14])
        {
            Caption = 'Activation Code';
            Description = 'Activation code used to activate Customer Rewards';            
        }
        field(2; "Date Activated"; Date)
        {
            Caption = 'Date Activated';
            Description = 'Date Customer Rewards was activated';
        }
        field(3; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            Description = 'Date Customer Rewards activation expires';
        }
    }
    
    keys
    {
        key(PK; ActivationCode)
        {
            Clustered = true;
        }
    }
}