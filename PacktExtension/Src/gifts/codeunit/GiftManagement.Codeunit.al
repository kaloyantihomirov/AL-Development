codeunit 50202 "Gift Management_CUS_NTG"
{
    procedure AddGifts(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Handled: Boolean;
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Line Discount %", '<>100');

        if SalesLine.FindSet() then
            repeat
                //Integration event raised
                OnBeforeFreeGiftSalesLineAdded(SalesHeader, SalesLine, Handled);
                AddFreeGiftSalesLine(SalesHeader, SalesLine, Handled);
                //Integration event raised
                OnAfterFreeGiftSalesLineAdded(SalesHeader, SalesLine);
            until SalesLine.Next() = 0;
    end;

    local procedure AddFreeGiftSalesLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var Handled: Boolean)
    var
        GiftCampaign: Record "Gift Campaign_CUS_NTG";
        Customer: Record Customer;
        SalesLineGift: Record "Sales Line";
        LineNo: Integer;
    begin
        if Handled then
            exit;

        Customer.Get(SalesLine."Sell-to Customer No.");
        GiftCampaign.SetRange(CustomerCategoryCode, Customer."Customer Category Code_CUS_NTG");
        GiftCampaign.SetRange(ItemNo, SalesLine."No.");
        GiftCampaign.SetFilter(StartingDate, '<=%1', SalesHeader."Order Date");
        GiftCampaign.SetFilter(EndingDate, '>=%1', SalesHeader."Order Date");
        GiftCampaign.SetRange(Inactive, false);
        GiftCampaign.SetFilter(MinimumOrderQuantity, '<= %1', SalesLine.Quantity);

        if GiftCampaign.FindFirst() then begin
            LineNo := GetLastSalesDocumentLineNo(SalesHeader);
            SalesLineGift.Init();
            SalesLineGift.TransferFields(SalesLine);
            SalesLineGift."Line No." := LineNo + 10000;
            SalesLineGift.Validate(Quantity, GiftCampaign.GiftQuantity);
            SalesLineGift.Validate("Line Discount %", 100);
            if SalesLineGift.Insert() then;
        end;
    end;

    local procedure GetLastSalesDocumentLineNo(SalesHeader: Record "Sales Header"): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast() then
            exit(SalesLine."Line No.")
        else
            exit(0);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterValidateEvent, Quantity, false, false)]
    local procedure CheckGiftEligibility(var Rec: Record "Sales Line")
    var
        GiftCampaign: Record "Gift Campaign_CUS_NTG";
        Customer: Record Customer;
        SalesHeader: Record "Sales Header";
        Handled: Boolean;
    begin
        if (Rec.Type = Rec.Type::Item) then
            if (Customer.Get(Rec."Sell-to Customer No.")) then begin
                SalesHeader.Get(Rec."Document Type", Rec."Document No.");
                GiftCampaign.SetRange(CustomerCategoryCode, Customer."Customer Category Code_CUS_NTG");
                GiftCampaign.SetRange(ItemNo, Rec."No.");
                GiftCampaign.SetFilter(StartingDate, '<=%1', SalesHeader."Order Date");
                GiftCampaign.SetFilter(EndingDate, '>=%1', SalesHeader."Order Date");
                GiftCampaign.SetRange(Inactive, false);
                GiftCampaign.SetFilter(MinimumOrderQuantity, '> %1', Rec.Quantity);
                if GiftCampaign.FindFirst() then begin
                    //Integration event raised
                    OnBeforeFreeGiftAlert(Rec, Handled);
                    DoGiftCheck(Rec, GiftCampaign, Handled);
                    //Integration event raised
                    OnAfterFreeGiftAlert(Rec);
                end;
            end;
    end;

    local procedure DoGiftCheck(var SalesLine: Record "Sales Line"; var GiftCampaign: Record "Gift Campaign_CUS_NTG"; var Handled: Boolean)
    var
        PacktSetup: Record "Packt Setup_CUS_NTG";
        GiftAlertLbl: Label 'Attention: there is an active promotion for item %1. if you buy %2 you can have a gift of %3';
    begin
        if Handled then
            exit;
        PacktSetup.Get();
        if (SalesLine.Quantity < GiftCampaign.MinimumOrderQuantity) and (GiftCampaign.MinimumOrderQuantity - SalesLine.Quantity <= PacktSetup."Gift Tolerance Qty") then
            Message(GiftAlertLbl, SalesLine."No.", Format(GiftCampaign.MinimumOrderQuantity), Format(GiftCampaign.GiftQuantity));
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeFreeGiftSalesLineAdded(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterFreeGiftSalesLineAdded(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeFreeGiftAlert(var SalesLine: Record "Sales Line"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterFreeGiftAlert(var SalesLine: Record "Sales Line")
    begin
    end;
}