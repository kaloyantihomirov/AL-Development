tableextension 50202 SalesLineExt_CUS_NTG extends "Sales Line"
{
    fields
    {
        field(50200; "Parent Line No._CUS_NTG"; Integer)
        {
            Caption = 'Parent Line No.';
            DataClassification = CustomerContent;
        }
        field(50201; IsGiftLine_CUS_NTG; Boolean)
        {
            Caption = 'Is Gift Line';
            DataClassification = CustomerContent;
        }
    }
}