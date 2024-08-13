codeunit 50120 CustomShptCommisionMgt_CUST
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ShipmentComissionMgtNTG, OnBeforeGetShipmentComission, '', false, false)]
    local procedure CustomChargeCalculationHandler(var SalesHeader: Record "Sales Header"; var Total: Decimal; var Handled: Boolean)
    begin
        Total := GetDefaultChargeFromSetup();
        Handled := true;
    end;

    local procedure GetDefaultChargeFromSetup(): Decimal
    var
        PacktSetup: Record "Packt Setup_CUS_NTG";
    begin
        if not PacktSetup.Get() then exit(0);

        exit(PacktSetup."Default Charge_CUST");
    end;
}