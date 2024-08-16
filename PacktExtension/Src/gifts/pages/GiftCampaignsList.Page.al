page 50203 "Gift Campaigns List_CUS_NTG"
{
    Caption = 'Gift Campaigns List';
    PageType = List;
    SourceTable = "Gift Campaign_CUS_NTG";
    ApplicationArea = All;
    UsageCategory = Lists;
    AdditionalSearchTerms = 'marketing, promotions';
    AboutTitle = 'About Gift Campaigns';
    AboutText = 'Here you can define the **Gift Campaigns** for your customers. With a gift campaign you can define promotional periods for your items and define gifts which a customer will receive when ordering some items.';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(CustomerCategoryCode; Rec.CustomerCategoryCode)
                {
                }
                field(ItemNo; Rec.ItemNo)
                {
                }
                field(StartingDate; Rec.StartingDate)
                {
                }
                field(EndingDate; Rec.EndingDate)
                {
                }
                field(MinimumOrderQuantity; Rec.MinimumOrderQuantity)
                {
                    Style = Strong;
                }
                field(GiftQuantity; Rec.GiftQuantity)
                {
                    Style = Strong;
                }
                field(Inactive; Rec.Inactive)
                {
                }
            }
        }
    }

    views
    {
        view(ActiveCampaigns)
        {
            Caption = 'Active Gift Campaigns';

            Filters = where(Inactive = const(false));
        }
        view(InactiveCampaigns)
        {
            Caption = 'Inactive Gift Campaigns';
            Filters = where(Inactive = const(true));
        }
        view(OngoingCampaigns)
        {
            Caption = 'Ongoing Gift Campaigns';
            //Filters = where()
        }
    }
}