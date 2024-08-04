pageextension 50201 "CustomerListExt_CUS_NTG" extends "Customer List"
{
    actions
    {
        addlast(processing)
        {
            action("Assign Default Category_CUS_NTG")
            {
                Image = ChangeCustomer;
                ApplicationArea = All;
                Caption = 'Assign Default Category to all Customers';
                ToolTip = 'Assigns the Default Category to all Customers';

                trigger OnAction()
                var
                    CustomerCategoryMgt: Codeunit "Customer Category Mgt_CUS_NTG";
                begin
                    CustomerCategoryMgt.AssignDefaultCategory();
                end;
            }
        }
        addlast(Promoted)
        {
            group(CustomerCategory_CUS_NTG)
            {
                Caption = 'Customer Category';
                actionref(AssignDefaultCategory_CUS_NTG; "Assign Default Category_CUS_NTG")
                {

                }
            }
        }
    }

    views
    {
        addlast
        {
            view(CustomersWithoutCategory)
            {
                Caption = 'Customers without Category';
                Filters = where("Customer Category Code_CUS_NTG" = filter(''));
            }
        }
    }
}