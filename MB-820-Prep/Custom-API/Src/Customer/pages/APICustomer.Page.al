page 50104 APICustomer
{
    PageType = API;

    APIPublisher = 'bctech';
    APIGroup = 'demo';
    APIVersion = 'v1.0';

    EntityName = 'myCustomer';
    EntitySetName = 'myCustomers';

    SourceTable = Customer;
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
                field(displayName; Rec.Name) { }
                field(address; Rec.Address) { }
                field(countryCode; Rec."Country/Region Code") { }
                field(lastModifiedDateTime; Rec."Last Modified Date Time") { }
            }
        }
    }
}