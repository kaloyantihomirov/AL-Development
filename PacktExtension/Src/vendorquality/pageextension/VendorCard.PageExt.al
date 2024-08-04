pageextension 50203 VendorCardExt_CUS_NTG extends "Vendor Card"
{
    actions
    {
        addafter("Co&mments")
        {
            action("Quality Classification_CUS_NTG")
            {
                Caption = 'Quality Classification';
                ApplicationArea = All;
                Image = QualificationOverview;
                RunObject = Page "Vendor Quality Card_CUS_NTG";
                RunPageLink = "Vendor No." = field("No.");
            }
        }
        addlast(Promoted)
        {
            group(VendorQuality_CUS_NTG)
            {
                Caption = 'Vendor Quality';

                actionref(QualityClassification_Promoted_CUS_NTG; "Quality Classification_CUS_NTG")
                {
                }
            }
        }
    }
}