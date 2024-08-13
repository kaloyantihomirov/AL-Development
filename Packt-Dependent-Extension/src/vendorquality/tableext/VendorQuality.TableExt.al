tableextension 50120 VendorQualityExt_CUST extends "Vendor Quality_CUS_NTG"
{
    fields
    {
        field(50100; "Certification No._CUST"; Text[50])
        {
            Caption = 'Certification No.';
            DataClassification = CustomerContent;
        }
    }
}