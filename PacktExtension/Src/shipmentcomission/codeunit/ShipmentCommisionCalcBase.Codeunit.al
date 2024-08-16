codeunit 50206 "Shipm. Comm. Calc Base_CUST" implements IShipmentCommisionCalculation_CUST
{
    procedure GetShipmentCommission(SalesHeader: Record "Sales Header"; var Total: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        if SalesLine.FindSet() then
            repeat
                if SalesLine.Quantity < 10 then
                    Total += 1.5
                else
                    Total += 5;
            until SalesLine.Next() = 0;
    end;
}