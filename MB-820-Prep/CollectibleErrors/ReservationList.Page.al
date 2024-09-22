page 50385 ReservationList
{
    ApplicationArea = All;
    Caption = 'Reservation List';
    PageType = List;
    SourceTable = Reservation;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
#if CLEAN2
                field(Description; Rec.DescriptionNew)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';

                    trigger OnValidate()
                    begin

                    end;
                }
#else
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
#endif
                field("Reservation Date"; Rec."Reservation Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.', Comment = '%';
                }
                field(StayInDays; Rec.StayInDays)
                {
                    ToolTip = 'Specifies the value of the Stay in days field.', Comment = '%';
                }
            }
        }
    }
}
