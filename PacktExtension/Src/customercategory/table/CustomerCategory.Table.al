table 50200 "Customer Category_CUS_NTG"
{
    Caption = 'Customer Category';
    DrillDownPageId = "Customer Category List_CUS_NTG";
    LookupPageId = "Customer Category List_CUS_NTG";
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(3; Default; Boolean)
        {
            Caption = 'Default';
        }
        field(4; EnableNewsLetter; enum "Newsletter Type_CUS_NTG")
        {
            Caption = 'Enable Newsletter';
            DataClassification = CustomerContent;
        }
        field(5; FreeGiftsAvailable; Boolean)
        {
            Caption = 'Free Gifts Available';
        }
        field(6; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(10; TotalCustomersForCategory; Integer)
        {
            Caption = 'Total Customers for Category';
            FieldClass = FlowField;
            CalcFormula = count(Customer where("Customer Category Code_CUS_NTG" = field(Code)));
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }

        key(K2; Description)
        {
            Unique = true;
        }
    }

    procedure GetSalesAmount(): Decimal
    var
        CustomerCategoryMgt: Codeunit "Customer Category Mgt_CUS_NTG";
    begin
        exit(CustomerCategoryMgt.GetSalesAmount(Rec.Code));
    end;
}