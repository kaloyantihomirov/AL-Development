page 50102 MyHeaderAPINTG
{
    PageType = API;
    Caption = 'My Header API';

    APIPublisher = 'bctech';
    APIGroup = 'demo';
    APIVersion = 'v1.0';

    EntityCaption = 'Header';
    EntitySetCaption = 'Headers';
    EntityName = 'header';
    EntitySetName = 'headers';

    SourceTable = MyHeaderNTG;
    ODataKeyFields = SystemId;

    DelayedInsert = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'System Id';
                    Editable = false;
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(lastModifiedDate; Rec.SystemModifiedAt)
                {
                }
            }
            part(lines; MyAPILinesNTG)
            {
                EntityName = 'line';
                EntitySetName = 'lines';
                SubPageLink = "Header Id" = field(SystemId);
            }
        }
    }
}