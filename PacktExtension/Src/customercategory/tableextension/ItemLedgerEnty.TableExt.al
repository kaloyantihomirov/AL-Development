tableextension 50201 ItemLedgerEntryExt_CUS_NTG extends "Item Ledger Entry"
{
    fields
    {
        field(50200; "Customer Category Code_CUS_NTG"; Code[20])
        {
            Caption = 'Customer Category Code';
            TableRelation = "Customer Category_CUS_NTG";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(CustomerCategory_CUS_NTG; "Customer Category Code_CUS_NTG")
        {
        }
    }
}