table 50201 "Packt Setup_CUS_NTG"
{
    Caption = 'Packt Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Minimum Accepted Vendor Rate"; Decimal)
        {
            Caption = 'Minimum Accepted Vendor Rate for Purchases';
        }
        field(3; "Gift Tolerance Qty"; Decimal)
        {
            Caption = 'Gift Tolerance Quantity for Sales';
        }
        field(4; "Default Charge (Item)"; Code[20])
        {
            Caption = 'Default Charge (Item)';
            TableRelation = "Item Charge";
        }
        field(10; "Shipmt Commission Calc. Method"; Integer)
        {
            Caption = 'Shipment Commission Calc. Method';
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