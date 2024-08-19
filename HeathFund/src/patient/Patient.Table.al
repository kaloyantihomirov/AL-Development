table 50112 Patient_MED_NTG
{
    Caption = 'Patient';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(20; Birthdate; DateTime)
        {
            Caption = 'Birth Date';
        }
        field(21; Address; Text[100])
        {
            Caption = 'Address';
        }
        field(22; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region".Code;
        }
        field(23; City; Text[30])
        {
            Caption = 'City';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
        }
        field(30; UCN; Code[10])
        {
            Caption = 'Unified Citizen''s Number';

            trigger OnValidate()
            begin
                if ("Country/Region Code" = 'BG') and (StrLen(UCN) <> 10) then
                    Error('The UCN in Bulgaria must be exactly 10 characters long');
            end;
        }
        field(40; IsHealthInsured; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Do they pay their health insurance?';
        }
        //лекуващ лекар 
        //заболявания - flowfield?
        field(50; Diseases; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Patient Disease" where("Patient No." = field("No.")));
        }
        field(42; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(60; "GP Code"; Code[20])
        {
            Caption = 'GP Code';
            TableRelation = Doctor_MED_NTG."No.";
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnInsert()
    var
        PatientSetup: Record "Patient Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsert(Rec, IsHandled);
        if IsHandled then
            exit;

        if "No." = '' then begin
            PatientSetup.Get();
            PatientSetup.TestField("Patient Nos.");
            NoSeriesMgt.InitSeries(PatientSetup."Patient Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        OnAfterOnInsert(Rec, xRec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Patient: Record Patient_MED_NTG; xPatient: Record Patient_MED_NTG)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsert(var Patient: Record Patient_MED_NTG; var IsHandled: Boolean)
    begin
    end;
}