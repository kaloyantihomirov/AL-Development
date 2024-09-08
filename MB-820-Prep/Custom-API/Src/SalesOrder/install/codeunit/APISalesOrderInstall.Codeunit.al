codeunit 50100 APISalesOrderInstall
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        FillInTheHeaderIdField();
    end;

    local procedure FillInTheHeaderIdField()
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);

        if SalesLine.FindSet() then
            repeat
                SalesHeader.Get(SalesHeader."Document Type"::Order, SalesLine."Document No.");
                SalesLine."Header Id" := SalesHeader.SystemId;
                SalesLine.Modify();
            until SalesLine.Next() = 0;
    end;
}