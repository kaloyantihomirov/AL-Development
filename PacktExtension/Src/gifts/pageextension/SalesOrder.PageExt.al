pageextension 50202 "SalesOrderExt_CUS_NTG" extends "Sales Order"
{
    actions
    {
        addlast(processing)
        {
            action("Add Free Gifts_CUS_NTG")
            {
                Caption = 'Add Free Gifts';
                ToolTip = 'Add Free Gifts to the current sales order based on active campaigns';
                ApplicationArea = All;
                Image = Add;

                trigger OnAction()
                var
                    GiftManagement: Codeunit "Gift Management_CUS_NTG";
                begin
                    GiftManagement.AddGifts(Rec);
                end;
            }
        }
        addlast(Promoted)
        {
            group(Gifts_CUS_NTG)
            {
                Caption = 'Gifts';

                actionref(AddFreeGifts_Promoted_CUS_NTG; "Add Free Gifts_CUS_NTG")
                {
                }
            }
        }
    }
}