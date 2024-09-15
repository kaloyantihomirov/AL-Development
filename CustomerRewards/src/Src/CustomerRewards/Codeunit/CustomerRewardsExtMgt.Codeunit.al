codeunit 50101 "Customer Rewards Ext. Mgt. NTG"
{
    var
        NoRewardLevelLbl: Label 'NONE';
        DummySuccessResponseLbl: Label '{"ActivationResponse": "Success"}', Locked = true;

    procedure OpenRewardsLevelPage()
    var
        RewardsLevelList: Page "Reward Levels List NTG";
    begin
        RewardsLevelList.RunModal();
    end;

    procedure ActivateCustomerRewards(ActivationCode: Text): Boolean
    var
        ActivationCodeInfo: Record "Activation Code Inform. NTG";
    begin
        OnGetActivationCodeStatusFromServer(ActivationCode);
        exit(ActivationCodeInfo.Get(ActivationCode));
    end;

    [IntegrationEvent(false, false)]
    procedure OnGetActivationCodeStatusFromServer(ActivationCode: Text)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Rewards Ext. Mgt. NTG", OnGetActivationCodeStatusFromServer, '', false, false)]
    local procedure OnGetActivationCodeStatusFromServerSubscriber(ActivationCode: Text)
    var
        ActivationCodeInfo: record "Activation Code Inform. NTG";
        ResponseTxt: Text;
        Result: JsonToken;
        ResponseJson: JsonToken;
    begin
        if not CanHandle() then
            exit;

        if GetHttpResponse(ActivationCode, ResponseTxt) then begin
            ResponseJson.ReadFrom(ResponseTxt);

            if ResponseJson.SelectToken('ActivationResponse', Result) then
                if Result.AsValue().AsText() = 'Success' then begin
                    ActivationCodeInfo.Init();
                    ActivationCodeInfo.ActivationCode := ActivationCode;
                    ActivationCodeInfo."Date Activated" := Today;
                    ActivationCodeInfo."Expiration Date" := CalcDate('<1Y>', Today);
                    ActivationCodeInfo.Insert();
                end;
        end;
    end;

    local procedure GetHttpResponse(ActivationCode: Text; var ResponseTxt: Text): Boolean
    begin
        if ActivationCode = '' then
            exit(false);

        ResponseTxt := DummySuccessResponseLbl;
        exit(true);
    end;

    procedure IsCustomerRewardsActivated(): Boolean
    var
        ActivationCodeInformation: Record "Activation Code Inform. NTG";
    begin
        if not ActivationCodeInformation.FindFirst() then
            exit(false);

        if ((ActivationCodeInformation."Date Activated" <= Today) and (Today <= ActivationCodeInformation."Expiration Date")) then
            exit(true);

        exit(false);
    end;

    procedure GetRewardLevel(RewardPoints: Integer) RewardLevelTxt: Text
    var
        RewardLevelRec: Record "Reward Level NTG";
    begin
        RewardLevelTxt := NoRewardLevelLbl;

        if RewardLevelRec.IsEmpty() then
            exit;
        RewardLevelRec.SetRange("Minimum Reward Points", 0, RewardPoints);
        RewardLevelRec.SetCurrentKey("Minimum Reward Points"); // sorted in ascending order 

        if not RewardLevelRec.FindLast() then
            exit;

        RewardLevelTxt := RewardLevelRec.Level;
    end;

    procedure OpenCustomerRewardsWizard()
    var
        CustomerRewardsWizard: Page "Customer Rewards Wizard NTG";
    begin
        CustomerRewardsWizard.Run();
    end;

    local procedure CanHandle(): Boolean
    var
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt Setup NTG";
    begin
        if CustomerRewardsExtMgtSetup.Get() then
            exit(CustomerRewardsExtMgtSetup."Customer Rewards Ext. Mgt. Codeunit ID" = Codeunit::"Customer Rewards Ext. Mgt. NTG");
        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDocSubscriber(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; var LinesWereModified: Boolean)
    var
        Customer: Record Customer;
    begin
        if SalesHeader.Status = SalesHeader.Status::Released then
            exit;

        Customer.Get(SalesHeader."Sell-to Customer No.");
        Customer."Reward Points NTG" += 1;
        Customer.Modify();
    end;

}