pageextension 50120 VendorQualityCardExt_CUST extends "Vendor Quality Card_CUS_NTG"
{
    layout
    {
        addlast(General)
        {
            field("Certification No._CUST"; Rec."Certification No._CUST")
            {
                ApplicationArea = All;
            }
        }
    }
}