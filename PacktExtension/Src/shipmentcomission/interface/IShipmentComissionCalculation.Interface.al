interface IShipmentCommisionCalculation_CUST
{
    procedure GetShipmentCommission(SalesHeader: Record "Sales Header"; var Total: Decimal)
}