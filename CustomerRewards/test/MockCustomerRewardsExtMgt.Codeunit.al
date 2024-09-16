codeunit 50150 MockCustomerRewardsExtMgt

{

    // When set to Manual subscribers in this codeunit are bound to an event by calling the BINDSUBSCRIPTION method.  
    // This enables you to control which event subscriber instances are called when an event is raised.  
    // If the BINDSUBSCRIPTION method is not called, then nothing will happen when the published event is raised. 

    EventSubscriberInstance = Manual;

    var
        DummyResponseTxt: Text;
        DummySuccessResponseTxt: Label '{"ActivationResponse": "Success"}', Locked = true;
        DummyFailureResponseTxt: Label '{"ActivationResponse": "Failure"}', Locked = true;

    // Mocks the response text for testing success and failure scenarios 

    procedure MockActivationResponse(Success: Boolean)
    begin
        if Success then
            DummyResponseTxt := DummySuccessResponseTxt
        else
            DummyResponseTxt := DummyFailureResponseTxt;
    end;

    // Modifies the default Customer Rewards Ext. Mgt codeunit to this codeunit to prevent the  
    // OnGetActivationCodeStatusFromServerSubscriber in Customer Rewards Ext. Mgt from handling 
    // the OnGetActivationCodeStatusFromServer event when it is raised  

    procedure Setup()
    var
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt Setup NTG";
    begin
        CustomerRewardsExtMgtSetup.Get();
        CustomerRewardsExtMgtSetup."Customer Rewards Ext. Mgt. Codeunit ID" := Codeunit::MockCustomerRewardsExtMgt;
        CustomerRewardsExtMgtSetup.Modify();
    end;

    // Subscribes to OnGetActivationCodeStatusFromServer event and handles it when the event is raised 

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Customer Rewards Ext. Mgt. NTG", 'OnGetActivationCodeStatusFromServer', '', false, false)]

    local procedure MockOnGetActivationCodeStatusFromServerSubscriber(ActivationCode: Text)
    var
        ActivationCodeInfo: Record "Activation Code Inform. NTG";
        ResponseText: Text;
        Result: JsonToken;
        JsonResponse: JsonToken;
    begin
        if (MockGetHttpResponse(ActivationCode, ResponseText)) then begin
            JsonResponse.ReadFrom(ResponseText);

            if (JsonResponse.SelectToken('ActivationResponse', Result)) then
                if (Result.AsValue().AsText() = 'Success') then begin
                    if ActivationCodeInfo.FindFirst() then
                        ActivationCodeInfo.Delete();
                    ActivationCodeInfo.Init();
                    ActivationCodeInfo.ActivationCode := ActivationCode;
                    ActivationCodeInfo."Date Activated" := Today;
                    ActivationCodeInfo."Expiration Date" := CALCDATE('<1Y>', Today);
                    ActivationCodeInfo.Insert();
                end;
        end;
    end;

    // Mocks making calls to external service 

    local procedure MockGetHttpResponse(ActivationCode: Text; var ResponseText: Text): Boolean
    begin
        if ActivationCode = '' then
            exit(false);

        ResponseText := DummyResponseTxt;

        exit(true);
    end;
}
