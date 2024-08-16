codeunit 50205 "ShipmentComissionMgtNTG"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", OnBeforeReleaseSalesDoc, '', false, false)]
    local procedure AssignShipmentComission(var SalesHeader: Record "Sales Header")
    var
        PacktSetup: Record "Packt Setup_CUS_NTG";
        Total: Decimal;
        IShipmentCommisionCalc: Interface IShipmentCommisionCalculation_CUST;
    begin
        PacktSetup.Get();
        IShipmentCommisionCalc := PacktSetup."Shipmt Commission Calc. Method";
        IShipmentCommisionCalc.GetShipmentCommission(SalesHeader, Total);
        //GetShipmentCommission(SalesHeader, Total);
        AddItemCharge(SalesHeader, Total);
    end;

    procedure GetShipmentCommission(SalesHeader: Record "Sales Header"; var Total: Decimal)
    var
        SalesLine: Record "Sales Line";
        Handled, HandledLine : Boolean;
    begin
        OnBeforeGetShipmentComission(SalesHeader, Total, Handled);

        if Handled then
            exit;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        if SalesLine.FindSet() then
            repeat
                OnBeforeCalculateShipmentComissionLine(SalesLine, Total, HandledLine);

                if not HandledLine then
                    if SalesLine.Quantity < 10 then
                        Total += 1.5
                    else
                        Total += 5;
                        
                OnAfterCalculateShipmentComissionLine(SalesLine, Total);
            until SalesLine.Next() = 0;

        OnAfterGetShipmentComission(SalesHeader, Total);
    end;

    local procedure AddItemCharge(SalesHeader: Record "Sales Header"; TotalCharge: Decimal)
    var
        SalesLine: Record "Sales Line";
        PacktSetup: Record "Packt Setup_CUS_NTG";
        MissingDefaultChargeItemLbl: Label 'Missing Default Charge (Item) in Packt Setup';
    begin
        PacktSetup.Get();
        if PacktSetup."Default Charge (Item)" = '' then
            Error(MissingDefaultChargeItemLbl);
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := GetNextLineNo(SalesHeader);
        SalesLine.Validate(Type, SalesLine.Type::"Charge (Item)");
        SalesLine.Validate("No.", PacktSetup."Default Charge (Item)");
        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", TotalCharge);
        SalesLine.Insert(true);
    end;

    local procedure GetNextLineNo(var SalesHeader: Record "Sales Header"): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");

        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000)
        else
            exit(10000);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeGetShipmentComission(var SalesHeader: Record "Sales Header"; var Total: Decimal; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterGetShipmentComission(var SalesHeader: Record "Sales Header"; var Total: Decimal)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeCalculateShipmentComissionLine(var SalesLine: Record "Sales Line"; var Total: Decimal; var HandledLine: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterCalculateShipmentComissionLine(var SalesLine: Record "Sales Line"; var Total: Decimal)
    begin
    end;
}