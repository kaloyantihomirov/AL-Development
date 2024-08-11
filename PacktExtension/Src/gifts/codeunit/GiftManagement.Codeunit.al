codeunit 50202 "Gift Management_CUS_NTG"
{
    procedure AddGifts(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Handled: Boolean;
    //GiftAlreadyAppliedLbl: Label 'Gifts based on these sales lines are already applied';
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Line Discount %", '<>100');
        SalesLine.SetRange(GiftApplied_CUS_NTG, false);

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
        GiftCampaign.SetFilter(MinimumOrderQuantity, '<=%1', SalesLine.Quantity);

        if GiftCampaign.FindFirst() then begin
            LineNo := GetLastSalesDocumentLineNo(SalesHeader);
            SalesLineGift.Init();
            SalesLineGift.TransferFields(SalesLine);
            SalesLineGift."Line No." := LineNo + 10000;
            SalesLineGift.Validate(Quantity, GiftCampaign.GiftQuantity);
            SalesLineGift.Validate("Line Discount %", 100);
            if SalesLineGift.Insert() then begin
                SalesLine.Validate(GiftApplied_CUS_NTG, true);
                SalesLine.Modify();
            end;
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
                //GiftCampaign.FindFirst();
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
        GiftAlertLbl: Label 'Attention: There is an active promotion for item %1. If you buy %2, you can have a gift of %3. Get %4 more to activate the promotion.',
                Comment = '%1 is the item no.; %2 is the minimum quantity needed for the promotion; %3 is the gift quantity (how many items you get for free).; %4 is the count of items needed in order to activate the promotion';
    begin
        if Handled then
            exit;
        PacktSetup.Get();
        if (SalesLine.Quantity < GiftCampaign.MinimumOrderQuantity) and (GiftCampaign.MinimumOrderQuantity - SalesLine.Quantity <= PacktSetup."Gift Tolerance Qty") then
            Message(GiftAlertLbl, SalesLine."No.", Format(GiftCampaign.MinimumOrderQuantity), Format(GiftCampaign.GiftQuantity), Format(GiftCampaign.MinimumOrderQuantity - SalesLine.Quantity));
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