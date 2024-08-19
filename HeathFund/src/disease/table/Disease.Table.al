table 50110 Disease_MED_NTG
{
    Caption = 'Disease';
    DataClassification = CustomerContent;

    DrillDownPageId = "Disease List_MED_NTG";
    LookupPageId = "Disease List_MED_NTG";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; DiseaseName; Text[50])
        {
            Caption = 'Name';
        }
        field(20; Description; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Short Description';
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
        fieldgroup(DropDown; DiseaseName, Description) { }
    }
}