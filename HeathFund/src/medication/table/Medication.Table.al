table 50200 Medication_MED_NTG
{
    Caption = 'Medication';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; VendorNo; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
    }
}