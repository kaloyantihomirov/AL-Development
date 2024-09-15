pageextension 50101 "Customer List Ext. NTG" extends "Customer List" 
{ 
    actions 
    { 
        addfirst("&Customer") 
        { 
            action("Reward Levels NTG") 
            { 
                ApplicationArea = All; 
                Image = CustomerRating; 
                Promoted = true; 
                PromotedCategory = Process; 
                PromotedIsBig = true;
                ToolTip = 'Open the list of reward levels.';
                Caption = 'Reward Levels';


                trigger OnAction(); 
                begin 
                    if CustomerRewardsExtMgt.IsCustomerRewardsActivated() then 
                        CustomerRewardsExtMgt.OpenRewardsLevelPage()
                    else 
                        CustomerRewardsExtMgt.OpenCustomerRewardsWizard(); 
                end; 
            } 
        } 
    } 

    var 
        CustomerRewardsExtMgt: Codeunit "Customer Rewards Ext. Mgt. NTG"; 
}