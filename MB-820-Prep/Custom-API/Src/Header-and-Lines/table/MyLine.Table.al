table 50103 MyLineNTG
{
    DataClassification = CustomerContent;
    Caption = 'My Line';

    fields
    {
        field(1; "Header No."; Code[20])
        {
            Caption = 'Header No.';
            TableRelation = MyHeaderNTG."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Header Id"; Guid)
        {
            Caption = 'Header Id';
            TableRelation = MyHeaderNTG.SystemId;
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Header No.", "Line No.")
        {
            Clustered = true;
        }
    }
}