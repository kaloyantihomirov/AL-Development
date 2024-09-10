table 50100 ToDo
{
    DataClassification = CustomerContent;
    Caption = 'To-Do';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(4; Urgency; enum Urgency)
        {
            Caption = 'Urgency';
        }
        field(5; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(6; "End Date"; Date)
        {
            Caption = 'End Date';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    //simulating a no. series
    trigger OnInsert()
    var
        ToDoRec: Record ToDo;
    begin
        if "No." = '' then
            if ToDoRec.FindLast() then
                Rec."No." := IncStr(ToDoRec."No.")
            else
                Rec."No." := 'TD001';
    end;
}