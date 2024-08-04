table 50202 "Gift Campaign_CUS_NTG"
{
    Caption = 'Gift Campaign';
    DataClassification = CustomerContent;

    DrillDownPageId = "Gift Campaigns List_CUS_NTG";
    LookupPageId = "Gift Campaigns List_CUS_NTG";

    fields
    {
        field(1; CustomerCategoryCode; Code[20])
        {
            Caption = 'Customer Category Code';
            TableRelation = "Customer Category_CUS_NTG";

            trigger OnValidate()
            var
                CustomerCategory: Record "Customer Category_CUS_NTG";
                CategoryBlockedLbl: Label 'Category %1 is marked as blocked.',
                                     Comment = '%1 is the code of the blocked category';
                NoFreeGiftsAvailableForCatLbl: Label 'No free gifts for Category %1.',
                                     Comment = '%1 is the code of the category with no gifts available';

            begin
                if CustomerCategory.Get(CustomerCategoryCode) then begin
                    if CustomerCategory.Blocked then
                        Error(CategoryBlockedLbl, CustomerCategoryCode);
                    if not CustomerCategory.FreeGiftsAvailable then
                        Error(NoFreeGiftsAvailableForCatLbl, CustomerCategoryCode);
                end;

            end;
        }
        field(2; ItemNo; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            Editable = false;
        }
        field(3; StartingDate; Date)
        {
            Caption = 'Starting Date';
        }
        field(4; EndingDate; Date)
        {
            Caption = 'Ending Date';
        }
        field(5; MinimumOrderQuantity; Decimal)
        {
            Caption = 'Minimum Order Quantity';
        }
        field(6; GiftQuantity; Decimal)
        {
            Caption = 'Gift Quantity';
        }
        field(7; Inactive; Boolean)
        {
            Caption = 'Inactive';
        }
    }

    keys
    {
        key(PK; CustomerCategoryCode, ItemNo, StartingDate, EndingDate)
        {
            Clustered = true;
        }
    }
}