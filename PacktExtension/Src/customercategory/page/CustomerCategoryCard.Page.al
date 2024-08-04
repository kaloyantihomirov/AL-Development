page 50202 "Customer Category Card_CUS_NTG"
{
    PageType = Card;
    Caption = 'Customer Category Card';
    UsageCategory = Documents;
    ApplicationArea = All;
    SourceTable = "Customer Category_CUS_NTG";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field(Default; Rec.Default)
                {
                    ToolTip = 'Specifies the value of the Default field.';
                }
                field(EnableNewsLetter; Rec.EnableNewsLetter)
                {
                    ToolTip = 'Specifies the value of the Enable Newsletter field.', Comment = '%';
                }
                field(FreeGiftsAvailable; Rec.FreeGiftsAvailable)
                {
                    ToolTip = 'Specifies the value of the Free Gifts Available field.', Comment = '%';
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies the value of the Blocked field.', Comment = '%';
                }
            }
            group(Statistics)
            {

                field(TotalCustomersForCategory; Rec.TotalCustomersForCategory)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Total Customers for Category field.', Comment = '%';
                }
                field(TotalSalesAmount; TotalSalesAmount)
                {
                    Editable = false;
                    Style = Strong;
                    ToolTip = 'Specifies the total sales amount for the current category.';
                    Caption = 'Total Sales Amount';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        TotalSalesAmount := Rec.GetSalesAmount();
    end;

    var
        TotalSalesAmount: Decimal;
}