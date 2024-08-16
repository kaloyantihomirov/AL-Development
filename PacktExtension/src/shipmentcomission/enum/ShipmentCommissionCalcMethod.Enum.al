enum 50201 "Shipm. Comm. Calc Method_CUST" implements IShipmentCommisionCalculation_CUST
{
    Extensible = true;

    value(0; Default)
    {
        Implementation = IShipmentCommisionCalculation_CUST = "Shipm. Comm. Calc Base_CUST";
    }
}