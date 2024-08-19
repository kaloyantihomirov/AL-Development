table 50116 Doctor_MED_NTG
{
    Caption = 'Doctor';
    DataClassification = CustomerContent;

    DrillDownPageId = "Doctor List_MED_NTG";
    LookupPageId = "Doctor List_MED_NTG";

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
        field(20; RegistrationDate; Date)
        {
            Caption = 'Registration Date';
        }
        field(30; SpecialisationCode; Code[20])
        {
            Caption = 'Specialisation Code';
            TableRelation = Specialisation_MED_NTG."No.";
        }
        field(40; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series".Code;
        }
        field(50; "No. of Patients"; Integer)
        {
            Caption = 'No. of Patients';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(Patient_MED_NTG where("GP Code" = field("No.")));
        }
        field(60; "DoctorsWSameSpecialisation"; Integer)
        {
            Caption = 'Doctors With Same Specialisation';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count(Doctor_MED_NTG where(SpecialisationCode = field(SpecialisationCode)));
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
        DoctorSetup: Record DoctorSetup_MED_NTG;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeInsert(Rec, IsHandled);
        if IsHandled then
            exit;

        if "No." = '' then begin
            DoctorSetup.Get();
            DoctorSetup.TestField("Doctor Nos.");
            NoSeriesMgt.InitSeries(DoctorSetup."Doctor Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        OnAfterOnInsert(Rec, xRec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Doctor: Record Doctor_MED_NTG; xDoctor: Record Doctor_MED_NTG)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsert(var Doctor: Record Doctor_MED_NTG; var IsHandled: Boolean)
    begin
    end;
}