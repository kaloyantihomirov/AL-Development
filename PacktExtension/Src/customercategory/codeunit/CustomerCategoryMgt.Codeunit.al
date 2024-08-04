codeunit 50200 "Customer Category Mgt_CUS_NTG"
{
    procedure GetSalesAmount(CustomerCategoryCode: Code[20]): Decimal
    var
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        TotalAmount: Decimal;
    begin
        Customer.SetCurrentKey("Customer Category Code_CUS_NTG");
        Customer.SetRange("Customer Category Code_CUS_NTG", CustomerCategoryCode);

        if Customer.FindSet() then
            repeat
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange("Sell-to Customer No.", Customer."No.");
                SalesLine.SetLoadFields("Line Amount");
                if SalesLine.FindSet() then
                    repeat
                        TotalAmount += SalesLine."Line Amount";
                    until SalesLine.Next() = 0;
            until Customer.Next() = 0;

        exit(TotalAmount);
    end;

    procedure CreateDefaultCategory()
    var
        CustomerCategory: Record "Customer Category_CUS_NTG";
        DefaultCodeTxt: Label 'DEFAULT';
        DefaultDescriptionTxt: Label 'Default Customer Category';
    begin
        CustomerCategory.Code := DefaultCodeTxt;
        CustomerCategory.Description := DefaultDescriptionTxt;
        CustomerCategory.Default := true;
        if CustomerCategory.Insert() then;
    end;

    procedure AssignDefaultCategory(CustomerCode: Code[20])
    var
        Customer: Record Customer;
        DefaultCategory: Record "Customer Category_CUS_NTG";
    begin
        DefaultCategory.SetRange(Default, true);

        if DefaultCategory.FindFirst() then
            if Customer.Get(CustomerCode) then begin
                Customer.Validate("Customer Category Code_CUS_NTG", DefaultCategory.Code);
                Customer.Modify();
            end;
    end;


    procedure AssignDefaultCategory()
    var
        Customer: Record Customer;
        CustomerCategory: Record "Customer Category_CUS_NTG";
    begin
        CustomerCategory.SetRange(Default, true);

        if CustomerCategory.FindFirst() then begin
            Customer.SetFilter("Customer Category Code_CUS_NTG", '%1', '');
            Customer.ModifyAll("Customer Category Code_CUS_NTG", CustomerCategory.Code);
        end;
    end;


}