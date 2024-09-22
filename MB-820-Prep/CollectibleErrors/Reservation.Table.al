table 50385 Reservation
{
    DataClassification = CustomerContent;
    Caption = 'Reservation';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';

#if CLEAN2
            ObsoleteState = Removed;
            ObsoleteTag = '2.0';
#else
            ObsoleteState = Pending;
            ObsoleteTag = '1.0';
#endif

            ObsoleteReason = 'Field is depricated and moved to a new field';

            trigger OnValidate()
            begin
#if not CLEAN2

                if StrLen(Description) < 3 then begin
                    ErrorInfoTooShortDescription.DetailedMessage := 'Description must be at least 3 characters long';
                    ErrorInfoTooShortDescription.Message := 'Description is too short';
                    Error(ErrorInfoTooShortDescription);
                end;
#endif
            end;
        }
        field(6; DescriptionNew; Text[50])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                OnValidateMethod();
            end;
        }
        field(3; "Reservation Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(5; StayInDays; Integer)
        {
            Caption = 'Stay in days';
            MinValue = 0;
            NotBlank = true;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var
        ErrorInfoTooShortDescription: ErrorInfo;

    trigger OnInsert()
    begin
        if Rec."No." = '' then
            Rec."No." := IncStr(GetLastReservationNo());
    end;

    local procedure GetLastReservationNo(): Code[20]
    var
        Reservation: Record "Reservation";
    begin
        if Reservation.FindLast() then
            exit(Reservation."No.")
        else
            exit('RES0001');
    end;


    [ErrorBehavior(ErrorBehavior::Collect)]
    local procedure OnValidateMethod()
    var
        errors: Record "Error Message" temporary;
        error: ErrorInfo;
    begin
        if not Codeunit.Run(Codeunit::ValidateFields, Rec) then begin
            errors.ID := errors.ID + 1;
            errors.Message := GetLastErrorText();
            errors.Insert();
        end;

        if HasCollectedErrors then
            foreach error in system.GetCollectedErrors() do begin
                errors.ID := errors.ID + 1;
                errors.Message := error.Message;
                errors.Validate("Record ID", error.RecordId);
                errors.Insert();
            end;

        ClearCollectedErrors();
        Page.RunModal(Page::"Error Messages", errors);
    end;

}

codeunit 50386 ValidateFields
{
    TableNo = Reservation;

    trigger OnRun()
    begin
        ValidateDescription(Rec.DescriptionNew);
    end;

    //[ErrorBehavior(ErrorBehavior::Collect)]
    local procedure ValidateDescription(Desc: Text[50])
    var
        TooShortDescErrInfo: ErrorInfo;
        SecondErrInfo: ErrorInfo;
        ThirdErrInfo: ErrorInfo;
    begin
        if StrLen(Desc) < 3 then begin
            TooShortDescErrInfo.DetailedMessage := 'Description must be at least 3 characters long';
            TooShortDescErrInfo.Message := 'Description is too short';
            TooShortDescErrInfo.Collectible := true;
            Error(TooShortDescErrInfo);
        end;

        SecondErrInfo.Message := 'Second error';
        SecondErrInfo.Collectible := true;
        Error(SecondErrInfo);

        ThirdErrInfo.Message := 'Third error';
        ThirdErrInfo.Collectible := true;
        Error(ThirdErrInfo);
    end;
}