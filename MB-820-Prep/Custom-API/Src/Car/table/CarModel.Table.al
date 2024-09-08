table 50101 CarModelNTG
{
    Caption = 'Car Model';
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
        field(3; "Brand Id"; Guid)
        {
            Caption = 'Brand Id';
            TableRelation = CarBrandNTG.SystemId;
        }
        field(4; Power; Integer)
        {
            Caption = 'Power (cc)';
        }
        field(5; "Fuel Type"; enum FuelTypeNTG)
        {
            Caption = 'Fuel Type';
        }
    }

    keys
    {
        key(PK; Name, "Brand Id")
        {
            Clustered = true;
        }
    }
}