page 50103 MyAPILinesNTG
{
    PageType = ListPart;
    SourceTable = "MyLineNTG";
    DelayedInsert = true;
    AutoSplitKey = true;
    PopulateAllFields = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(lines)
            {
                field(id; Rec.SystemId) { }
                field(headerNo; Rec."Header No.") { }
                field(headerId; Rec."Header Id") { }
                field(lineNo; Rec."Line No.") { }
                field(description; Rec.Description) { }
            }
        }
    }

    var
        IsDeepInsert: Boolean;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        MyHeader: Record MyHeaderNTG;
        MyLine: Record MyLineNTG;
    begin
        if IsDeepInsert then begin
            MyHeader.GetBySystemId(Rec."Header Id");
            Rec."Header No." := MyHeader."No.";
            MyLine.SetRange("Header No.", Rec."Header No.");
            if MyLine.FindLast() then
                Rec."Line No." := MyLine."Line No." + 10000
            else
                Rec."Line No." := 10000;
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        MyHeader: Record MyHeaderNTG;
    begin
        IsDeepInsert := IsNullGuid(Rec."Header Id");
        if not IsDeepInsert then begin
            MyHeader.GetBySystemId(Rec."Header Id");
            Rec."Header No." := MyHeader."No.";
        end;
    end;
}