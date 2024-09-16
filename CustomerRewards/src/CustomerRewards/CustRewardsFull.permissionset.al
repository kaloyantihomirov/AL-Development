permissionset 50100 CustRewardsFull
{
    Caption = 'Customer Rewards';
    Assignable = true;
    IncludedPermissionSets = "D365 BUS FULL ACCESS";

    Permissions = tabledata "Activation Code Inform. NTG" = RIMD,
        tabledata "Customer Rewards Mgt Setup NTG" = RIMD,
        tabledata "Reward Level NTG" = RIMD,
        table "Activation Code Inform. NTG" = X,
        table "Customer Rewards Mgt Setup NTG" = X,
        table "Reward Level NTG" = X,
        codeunit "Cust. Rewards Inst. Logic NTG" = X,
        codeunit "Customer Rewards Ext. Mgt. NTG" = X,
        page "Customer Rewards Wizard NTG" = X,
        page "Reward Levels List NTG" = X;
}