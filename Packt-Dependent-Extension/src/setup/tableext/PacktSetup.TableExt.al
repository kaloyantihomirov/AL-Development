tableextension 50121 PacktSetupExt_CUST extends "Packt Setup_CUS_NTG"
{
    fields
    {
        field(50100; "Default Charge_CUST"; Decimal)
        {
            Caption = 'Default Charge';
            DataClassification = CustomerContent;
        }
    }
}