pageextension 50121 PacktSetupExt_CUST extends "Packt Setup_CUS_NTG"
{
    layout
    {
        addlast(General)
        {
            field("Default Charge_CUST"; Rec."Default Charge_CUST")
            {
                ApplicationArea = All;
            }
        }
    }
}