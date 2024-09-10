enum 50100 Urgency
{
    Caption = 'Urgency';
    Extensible = true;

    value(0; Default)
    {
        Caption = '', Locked = true;
    }
    value(1; Low)
    {
        Caption = 'Low';
    }
    value(2; Medium)
    {
        Caption = 'Medium';
    }
    value(3; High)
    {
        Caption = 'High';
    }
    value(4; Urgent)
    {
        Caption = 'Urgent';
    }
}