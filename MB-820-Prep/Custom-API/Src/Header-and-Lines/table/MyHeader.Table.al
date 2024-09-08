table 50102 MyHeaderNTG
{
    DataClassification = CustomerContent;
    Caption = 'My Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        MyHeader: Record MyHeaderNTG;
    begin
        if "No." = '' then
            if MyHeader.FindLast() then
                "No." := IncStr(MyHeader."No.")
            else
                "No." := 'HEADER001';
    end;
}