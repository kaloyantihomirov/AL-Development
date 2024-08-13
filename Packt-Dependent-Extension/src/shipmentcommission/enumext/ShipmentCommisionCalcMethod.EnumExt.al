enumextension 50120 "Shpmt. Comm. Calc Method Ext._CUST" extends "Shipm. Comm. Calc Method_CUST"
{
    value(10; "Fixed shipment charge")
    {
        Caption = 'Fixed shipment charge';
        Implementation = IShipmentCommisionCalculation_CUST = "Fixed Shipmt. Comm. Calc_CUST";
    }
}