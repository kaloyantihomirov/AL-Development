table 50100 CarBrandNTG
{
    Caption = 'Car Brand';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; Country; Text[100])
        {
            Caption = 'Country';
        }
    }

    keys
    {
        key(PK; Name)
        {
            Clustered = true;
        }
    }
}