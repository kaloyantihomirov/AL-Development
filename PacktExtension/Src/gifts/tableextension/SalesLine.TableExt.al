tableextension 50202 SalesLineExt_CUS_NTG extends "Sales Line"
{
    fields
    {
        field(50200; GiftApplied_CUS_NTG; Boolean)
        {
            Caption = 'Gift Applied';
            DataClassification = CustomerContent;
        }
    }
}