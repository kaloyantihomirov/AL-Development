page 50100 APICarBrand
{
    PageType = API;

    Caption = 'apiCarBrand';

    APIPublisher = 'bctech';
    APIGroup = 'demo';
    APIVersion = 'v1.0';

    EntityCaption = 'Car Brand';
    EntitySetCaption = 'Car Brands';
    EntityName = 'carBrand';
    EntitySetName = 'carBrands';

    ODataKeyFields = SystemId;
    SourceTable = CarBrandNTG;

    Extensible = false;
    DelayedInsert = true;

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
                field(name; rec.Name)
                {
                    Caption = 'Name';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(country; Rec.Country)
                {
                    Caption = 'Country';
                }
            }

            part(carModels; APICarModel)
            {
                Caption = 'Car Models';
                EntityName = 'carModel';
                EntitySetName = 'carModels';
                SubPageLink = "Brand Id" = field(SystemId);
            }
        }
    }
}