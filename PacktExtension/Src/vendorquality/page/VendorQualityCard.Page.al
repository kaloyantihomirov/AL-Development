page 50204 "Vendor Quality Card_CUS_NTG"
{
    Caption = 'Vendor Quality Card';
    PageType = Card;
    ApplicationArea = All;
    InsertAllowed = false;
    UsageCategory = Administration;
    SourceTable = "Vendor Quality_CUS_NTG";
    AdditionalSearchTerms = 'vendor rating, vendors';
    AboutTitle = 'About Vendor Quality';
    AboutText = '**Vendor Quality** gives you an overview on how your Vendors perform and how they are ranked internally in your company.';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Vendor No."; Rec."Vendor No.")
                {
                    Editable = false;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    Editable = false;
                }
                field("Vendor Activity Description"; Rec."Vendor Activity Description")
                {
                }
                field(Rate; Rec.Rate)
                {
                    Style = Strong;
                    Editable = false;
                }
                field(UpdateDate; Rec.UpdateDate)
                {
                    Editable = false;
                }
            }
            group(Scoring)
            {
                Caption = 'Scoring';

                field(ScoreItemQuality; Rec.ScoreItemQuality)
                {
                }
                field(ScoreDelivery; Rec.ScoreDelivery)
                {
                }
                field(ScorePackaging; Rec.ScorePackaging)
                {
                }
                field(ScorePricing; Rec.ScorePricing)
                {
                }
            }
            group(Financials)
            {
                Caption = 'Financials';

                field(InvoicedYearN; Rec.InvoicedYearN)
                {
                    Editable = false;
                }
                field(InvoicedYearN1; Rec.InvoicedYearN1)
                {
                    Editable = false;
                }
                field(InvoicedYearN2; Rec.InvoicedYearN2)
                {
                    Editable = false;
                }
                field(DueAmount; Rec.DueAmount)
                {
                    Editable = false;
                    Style = Attention;
                }
                field(AmountNotDue; Rec.AmountNotDue)
                {
                    Editable = false;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Insert() then;
    end;

    trigger OnAfterGetRecord()
    var
        VendorQualityMgt: Codeunit VendorQualityMgt_CUS_NTG;
    begin
        VendorQualityMgt.UpdateVendorQualityStatistics(Rec);
    end;
}