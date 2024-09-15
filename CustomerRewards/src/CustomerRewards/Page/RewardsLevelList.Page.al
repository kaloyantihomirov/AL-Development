page 50101 "Reward Levels List NTG"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Reward Level NTG";
    SourceTableView = sorting("Minimum Reward Points") order(ascending);
    Caption = 'Reward Levels List';
    ContextSensitiveHelpPage = 'sales-rewards';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Level; Rec.Level)
                {
                    Tooltip = 'Specifies the level of reward that the customer has at this point.';
                }
                field("Minimum Reward Points"; Rec."Minimum Reward Points")
                {
                    Tooltip = 'Specifies the number of points that customers must have to reach this level.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if (not CustomerRewardsExtMgt.IsCustomerRewardsActivated()) then
            Error(NotActivatedTxt);
    end;

    var
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG";
        NotActivatedTxt: Label 'Customer Rewards is not activated.';
}