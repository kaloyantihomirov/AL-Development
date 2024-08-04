tableextension 50200 CustomerExt_CUS_NTG extends Customer
{
    fields
    {
        field(50200; "Customer Category Code_CUS_NTG"; Code[20])
        {
            Caption = 'Customer Category Code';
            TableRelation = "Customer Category_CUS_NTG";
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                CustomerCategory: Record "Customer Category_CUS_NTG";
                BlockedErr: Label 'Cannot assign a blocked category to a customer.';
            begin
                if CustomerCategory.Get("Customer Category Code_CUS_NTG") then
                    if CustomerCategory.Blocked then
                        Error(BlockedErr);
            end;
        }
    }

    keys
    {
        key(CustomerCategory_CUS_NTG; "Customer Category Code_CUS_NTG")
        {

        }
    }
}