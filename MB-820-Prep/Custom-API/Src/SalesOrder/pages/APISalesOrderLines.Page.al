page 50106 APISalesOrderLines
{
    PageType = API;

    APIPublisher = 'bctech';
    APIGroup = 'demo';
    APIVersion = 'v1.0';

    EntityName = 'mySalesOrderLine';
    EntitySetName = 'mySalesOrderLines';

    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = const(Order));

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
                field(lineNumber; Rec."Line No.") { }
                field(itemType; Rec.Type) { }
                field(itemNumber; Rec."No.") { }
                field(quantity; Rec.Quantity) { }
                field(lastModifiedDateTime; Rec.SystemModifiedAt) { }
            }
        }
    }
}