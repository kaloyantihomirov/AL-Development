table 50203 MedicationsLine_MED_NTG
{
    Caption = 'Medications Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PatientCode; Code[20])
        {
            Caption = 'Patient Code';
            TableRelation = Patient_MED_NTG;
        }
        field(10; "Examination No."; Code[20])
        {
            Caption = 'Examination No.';
            TableRelation = ExaminationHeader_MED_NTG;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(30; MedicationCode; Code[20])
        {
            Caption = 'Medication Code';
            TableRelation = Medication_MED_NTG;
        }
        field(40; MedicationName; Text[50])
        {
            Caption = 'Medication Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Medication_MED_NTG.Name where("No." = field(MedicationCode)));
            Editable = false;
        }
        field(50; UnitOfMeasurement; enum UnitOfMeasurement_MED_NTG)
        {
            Caption = 'Unit of Measurement';
        }
        field(60; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(70; StartDate; Date)
        {
            Caption = 'Start Date';
        }
        field(80; EndDate; Date)
        {
            Caption = 'End Date';
        }
    }
}