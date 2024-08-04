codeunit 50201 GeneralSubscribers_CUS_NTG
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeCheckCustBlockage', '', true, true)]
    local procedure OnBeforeCheckCustBlockageCustomerCategory(CustCode: Code[20];
        SalesHeader: Record "Sales Header";
        var ExecuteDocCheck: Boolean;
        var IsHandled: Boolean;
        var TempSalesLine: Record "Sales Line" temporary)
    var
        Customer: Record Customer;
        CustomerCategory: Record "Customer Category_CUS_NTG";
        CustBlockedCategoryLbl: Label 'The category of Customer %1 is marked as blocked.',
                                 Comment = '%1 is customer''s code';
    begin
        IsHandled := true;
        if Customer.Get(CustCode) then
            if Customer."Customer Category Code_CUS_NTG" <> '' then begin
                CustomerCategory.Get(Customer."Customer Category Code_CUS_NTG");
                if CustomerCategory.Blocked then
                    Error(CustBlockedCategoryLbl, Customer."No.");
            end;
    end;
}