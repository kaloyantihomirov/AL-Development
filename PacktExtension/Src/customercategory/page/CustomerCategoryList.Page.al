page 50201 "Customer Category List_CUS_NTG"
{
    PageType = List;
    Caption = 'Customer Category List';
    SourceTable = "Customer Category_CUS_NTG";
    CardPageId = "Customer Category Card_CUS_NTG";
    UsageCategory = Lists;
    ApplicationArea = All;
    AdditionalSearchTerms = 'ranking, categorization';
    AboutTitle = 'About Customer Categories';
    AboutText = 'Here you can define the **categories** for your customers. You can then categorize your customers via the **Customer Card**.';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Default; Rec.Default)
                {
                    ToolTip = 'Specifies the value of the Default field.', Comment = '%';
                }
                field(TotalCustomersForCategory; Rec.TotalCustomersForCategory)
                {
                    ToolTip = 'Specifies the value of the Total Customers for Category field.', Comment = '%';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Create Default Category")
            {
                Caption = 'Create default category';
                ToolTip = 'Create default category';
                Image = CreateForm;

                trigger OnAction()
                var
                    CustomerCategoryMgt: Codeunit "Customer Category Mgt_CUS_NTG";
                begin
                    CustomerCategoryMgt.CreateDefaultCategory();
                end;
            }
        }
        area(Promoted)
        {
            group(CustomerCategory_CUS_NTG)
            {
                Caption = 'Customer Category';
                actionref(CreateDefaultCategory; "Create Default Category")
                {

                }
            }
        }
    }

}