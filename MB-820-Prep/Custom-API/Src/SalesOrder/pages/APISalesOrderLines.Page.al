page 50106 APISalesOrderLines
{
    PageType = API;

    APIPublisher = 'bctech';
    APIGroup = 'demo';
    APIVersion = 'v1.0';

    EntityName = 'mySalesOrderLine';
    EntitySetName = 'mySalesOrderLines';

    SourceTable = "Sales Line";
    ODataKeyFields = SystemId;

    PopulateAllFields = true;
    AutoSplitKey = true;

    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { }
                field(documentType; Rec."Document Type") { }
                field(documentNumber; Rec."Document No.") { }
                field(headerId; Rec."Header Id") { }
                field(lineNumber; Rec."Line No.") { }
                field(itemNumber; Rec."No.") { }
                field(quantity; Rec.Quantity) { }
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.GetBySystemId(Rec."Header Id");
        Rec."Document No." := SalesHeader."No.";
        Rec."Sell-to Customer No." := Rec."Sell-to Customer No.";
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Document Type" := Rec."Document Type"::Order;
        exit(true);
    end;
}