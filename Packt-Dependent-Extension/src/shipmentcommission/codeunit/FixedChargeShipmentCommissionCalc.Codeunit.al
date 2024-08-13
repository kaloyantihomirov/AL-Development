codeunit 50121 "Fixed Shipmt. Comm. Calc_CUST" implements IShipmentCommisionCalculation_CUST
{
    procedure GetShipmentCommission(SalesHeader: Record "Sales Header"; var Total: Decimal)
    begin
        Total := GetDefaultChargeFromSetup();
    end;

    local procedure GetDefaultChargeFromSetup(): Decimal
    var
        PacktSetup: Record "Packt Setup_CUS_NTG";
    begin
        if not PacktSetup.Get() then exit(0);

        exit(PacktSetup."Default Charge_CUST");
    end;
}