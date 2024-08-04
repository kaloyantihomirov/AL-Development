pageextension 50200 "CustomerCardExt_CUS_NTG" extends "Customer Card"
{
    layout
    {
        addlast(General)
        {
            field("Customer Category Code_CUS_NTG"; Rec."Customer Category Code_CUS_NTG")
            {
                ToolTip = 'Specifies the code of the cagory of the current user.';
            }
        }
    }

    actions
    {
        addlast(Promoted)
        {
            group(CustomerCategory_CUS_NTG)
            {
                Caption = 'Customer Category';
                actionref(AssignDefCategory_Promoted_CUS_NTG; "Assign default category_CUS_NTG")
                {
                }
            }
        }
        addlast("F&unctions")
        {
            action("Assign default category_CUS_NTG")
            {
                Caption = 'Assign default category';
                ToolTip = 'Assign default category';
                Image = ChangeCustomer;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;
                // PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustomerCategoryMgt: Codeunit "Customer Category Mgt_CUS_NTG";
                begin
                    CustomerCategoryMgt.AssignDefaultCategory(Rec."No.");
                end;
            }
        }
    }
}