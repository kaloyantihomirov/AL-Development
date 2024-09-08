page 50101 APICarModel
{
    PageType = API;

    APIPublisher = 'bctech';
    APIGroup = 'demo';
    APIVersion = 'v1.0';

    EntityCaption = 'Car Model';
    EntitySetCaption = 'Car Models';
    EntityName = 'carModel';
    EntitySetName = 'carModels';

    ODataKeyFields = SystemId;
    SourceTable = CarModelNTG;

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
                    Caption = 'Id';
                    Editable = false;
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(brandId; Rec."Brand Id")
                {
                    Caption = 'Brand Id';
                }
                field(power; Rec.Power)
                {
                    Caption = 'Power';
                }
                field(fuelType; Rec."Fuel Type")
                {
                    Caption = 'Fuel Type';
                }
            }
        }
    }
}