codeunit 50204 PacktInstall_CUS_NTG
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        CustomerCategory: Record "Customer Category_CUS_NTG";
        PacktSetup: Record "Packt Setup_CUS_NTG";
    begin
        if CustomerCategory.IsEmpty() then
            InsertDefaultCustomerCategory();
        if PacktSetup.IsEmpty() then
            InsertDefaultSetup();
    end;

    local procedure InsertDefaultCustomerCategory()
    begin
        InsertCustomerCategory('DEFAULT', 'Default', true);
        InsertCustomerCategory('GOLD', 'Gold customers', false);
        InsertCustomerCategory('SILVER', 'Silver customers', false);
        InsertCustomerCategory('BRONZE', 'Bronze customers', false);
    end;

    local procedure InsertCustomerCategory(ID: Code[20]; Description: Text[50]; Default: Boolean)
    var
        CustomerCategory: Record "Customer Category_CUS_NTG";
    begin
        CustomerCategory.Init();
        CustomerCategory.Code := ID;
        CustomerCategory.Description := Description;
        CustomerCategory.Default := Default;
        CustomerCategory.Insert();
    end;

    local procedure InsertDefaultSetup()
    var
        PacktSetup: Record "Packt Setup_CUS_NTG";
    begin
        PacktSetup.Init();
        PacktSetup."Minimum Accepted Vendor Rate" := 6;
        PacktSetup."Gift Tolerance Qty" := 2;
        PacktSetup.Insert();
    end;
}