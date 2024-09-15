codeunit 50100 "Cust. Rewards Inst. Logic NTG" 
{ 
    // Customer Rewards Install Logic 
    Subtype = Install; 

    trigger OnInstallAppPerCompany(); 
    begin 
        SetDefaultCustomerRewardsExtMgtCodeunit(); 
    end; 

    procedure SetDefaultCustomerRewardsExtMgtCodeunit()
    var 
        CustomerRewardsExtMgtSetup: Record "Customer Rewards Mgt Setup NTG"; 
    begin 
        CustomerRewardsExtMgtSetup.DeleteAll(); 
        CustomerRewardsExtMgtSetup.Init(); 
        // Default Customer Rewards Ext. Mgt codeunit to use for handling events  
        CustomerRewardsExtMgtSetup."Customer Rewards Ext. Mgt. Codeunit ID" := Codeunit::"Customer Rewards Ext. Mgt. NTG"; 
        CustomerRewardsExtMgtSetup.Insert(); 
    end; 
}