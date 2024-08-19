table 50111 Specialisation_MED_NTG
{
    Caption = 'Specialisation';
    DataClassification = CustomerContent;

    DrillDownPageId = "Specialisation List_MED_NTG";
    LookupPageId = "Specialisation List_MED_NTG";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    MedSetup.Get();
                    NoSeriesMgt.TestManual(MedSetup."Specialisation Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(10; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(20; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(30; SpecialisedInDoctors; Integer)
        {
            Caption = 'Doctors Count';

            FieldClass = FlowField;
            CalcFormula = count(Doctor_MED_NTG where(SpecialisationCode = field("No.")));
            Editable = false;
        }
        field(40; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
            Editable = false;
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
        fieldgroup(DropDown; "No.", Name) { }
    }

    var
        MedSetup: Record MedicalSetup_CUS_NTG;
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert()
    var
        Handled: Boolean;
    begin
        Handled := false;

        OnBeforeInsert(Rec, Handled);

        if Handled then
            exit;

        if "No." = '' then begin
            MedSetup.Get();
            MedSetup.TestField("Specialisation Nos.");
            NoSeriesMgt.InitSeries(MedSetup."Specialisation Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        OnAfterOnInsert(Rec, xRec);
    end;

    procedure AssistEdit(OldSpec: Record Specialisation_MED_NTG): Boolean
    var
        Spec: Record Specialisation_MED_NTG;
    begin
        Spec := Rec;
        MedSetup.Get();
        MedSetup.TestField("Specialisation Nos.");
        if NoSeriesMgt.SelectSeries(MedSetup."Specialisation Nos.", OldSpec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            Rec := Spec;
            //OnAssistEditOnBeforeExit(Cust);
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsert(var Rec: Record Specialisation_MED_NTG; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Rec: Record Specialisation_MED_NTG; var xRec: Record Specialisation_MED_NTG)
    begin
    end;
}