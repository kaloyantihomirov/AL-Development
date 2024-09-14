pageextension 60101 CustomerListExt extends "Customer List"
{
    actions
    {
        addlast(processing)
        {
            action("Current temp in SF")
            {
                Caption = 'Current temp in SF';
                ApplicationArea = All;
                Image = Alerts;
                ToolTip = 'Gets the current temp in SF using an API call';

                trigger OnAction()
                var
                    Weather: codeunit Weather;
                begin
                    Message(Format(Weather.GetWeatherTemperatureInCelsiusForTown('Sofia')));
                end;
            }
        }
    }
}