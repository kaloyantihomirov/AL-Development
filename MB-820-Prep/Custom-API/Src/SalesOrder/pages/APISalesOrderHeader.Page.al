page 50105 APISalesOrderHeader
{
    PageType = API;

    APIPublisher = 'bctech';
    APIGroup = 'demo';
    APIVersion = 'v1.0';

    EntityName = 'mySalesOrderHeader';
    EntitySetName = 'mySalesOrderHeaders';

    SourceTable = "Sales Header";
    ODataKeyFields = SystemId;

    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { }
                field(number; Rec."No.") { }
                field(selltoCustomerNumber; Rec."Sell-to Customer No.") { }
                field(address; Rec."Sell-to Address") { }
                field(documentDate; Rec."Document Date") { }
                field(postingDate; Rec."Posting Date") { }
            }

            part(lines; APISalesOrderLines)
            {
                EntitySetName = 'mySalesOrderLines';
                EntityName = 'mySalesOrderLine';
                SubPageLink = "Header Id" = field(SystemId);
            }
        }
    }
}