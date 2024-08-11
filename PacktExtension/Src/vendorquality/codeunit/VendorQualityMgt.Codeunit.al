codeunit 50203 VendorQualityMgt_CUS_NTG
{
    procedure CalculateVendorRate(var VendorQuality: Record "Vendor Quality_CUS_NTG")
    var
        Handled: Boolean;
    begin
        OnBeforeCalculateVendorRate(VendorQuality, Handled);
        VendorRateCalculation(VendorQuality, Handled);
        OnAfterCalculateVendorRate(VendorQuality);
    end;

    local procedure VendorRateCalculation(var VendorQuality: Record "Vendor Quality_CUS_NTG"; var Handled: Boolean)
    begin
        if Handled then
            exit;

        VendorQuality.Rate := (VendorQuality.ScoreDelivery + VendorQuality.ScoreItemQuality + VendorQuality.ScorePackaging
            + VendorQuality.ScorePricing) / 4;
    end;

    procedure UpdateVendorQualityStatistics(var VendorQuality: Record "Vendor Quality_CUS_NTG")
    var
        Year: Integer;
        DW: Dialog;
        DialogMessageMsg: Label 'Calculating Vendor statistics...';
    begin
        DW.Open(DialogMessageMsg);
        Year := Date2DMY(TODAY, 3);
        VendorQuality.InvoicedYearN := GetInvoicedAmount(VendorQuality."Vendor No.", DMY2Date(1, 1, Year), TODAY);
        VendorQuality.InvoicedYearN1 := GetInvoicedAmount(VendorQuality."Vendor No.", DMY2DATE(1, 1, Year - 1), DMY2DATE(31, 12, Year - 1));
        VendorQuality.InvoicedYearN2 := GetInvoicedAmount(VendorQuality."Vendor No.", DMY2DATE(1, 1, Year - 2), DMY2DATE(31, 12, Year - 2));
        VendorQuality.DueAmount := GetDueAmount(VendorQuality."Vendor No.", true);
        VendorQuality.AmountNotDue := GetDueAmount(VendorQuality."Vendor No.", false);
        DW.Close();
    end;

    local procedure GetInvoicedAmount(VendorNo: Code[20]; StartDate: Date; EndDate: Date): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.SetRange("Vendor No.", VendorNo);
        VendorLedgerEntry.SetFilter("Document Date", '%1..%2', StartDate, EndDate);
        VendorLedgerEntry.SetLoadFields("Purchase (LCY)");
        VendorLedgerEntry.CalcSums("Purchase (LCY)");
        exit(VendorLedgerEntry."Purchase (LCY)" * (-1));
    end;

    local procedure GetDueAmount(VendorNo: Code[20]; Due: Boolean): Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        Total: Decimal;
    begin
        VendorLedgerEntry.SetRange("Vendor No.", VendorNo);
        VendorLedgerEntry.SetRange(Open, true);
        if Due then
            VendorLedgerEntry.SetFilter("Due Date", '< %1', TODAY)
        else
            VendorLedgerEntry.SetFilter("Due Date", '> %1', TODAY);

        VendorLedgerEntry.SetAutoCalcFields(VendorLedgerEntry."Remaining Amt. (LCY)");
        if VendorLedgerEntry.FindSet() then
            repeat
                Total += VendorLedgerEntry."Remaining Amt. (LCY)"
            until VendorLedgerEntry.Next() = 0;

        exit(Total * (-1));
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, OnAfterOnInsert, '', false, false)]
    local procedure OnAfterOnInsertCreateVendorQuality(var Vendor: Record Vendor)
    var
        VendorQuality: Record "Vendor Quality_CUS_NTG";
    begin
        VendorQuality.Init();
        VendorQuality."Vendor No." := Vendor."No.";
        VendorQuality.CalcFields("Vendor Name");
        if VendorQuality.Insert() then;
    end;

    // [EventSubscriber(ObjectType::Table, Database::Vendor, OnAfterInsertEvent, '', false, false)]
    // local procedure OnAfterInsertEventCreateVendorQuality(var Vendor: Record Vendor; RunTrigger: Boolean)
    // var
    //     VendorQuality: Record "Vendor Quality_CUS_NTG";
    // begin
    //     VendorQuality.Init();
    //     VendorQuality."Vendor No." := Vendor."No.";
    //     VendorQuality.CalcFields("Vendor Name");
    //     if VendorQuality.Insert() then;
    // end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, OnAfterDeleteEvent, '', false, false)]
    local procedure OnAfterDeleteEventDeleteVendorQuality(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        VendorQuality: Record "Vendor Quality_CUS_NTG";
    begin
        if VendorQuality.Get(Rec."No.") then
            VendorQuality.Delete(RunTrigger);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeCalculateVendorRate(var VendorQuality: Record "Vendor Quality_CUS_NTG"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterCalculateVendorRate(var VendorQuality: Record "Vendor Quality_CUS_NTG")
    begin
    end;
}