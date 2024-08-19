page 50101 DiseasesSubform_MED_NTG
{
    Caption = 'Diseases Subform';
    PageType = ListPart;
    SourceTable = DiseasesLine_MED_NTG;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(DiseaseName; Rec.DiseaseName)
                {
                }
                field(DiseaseDescription; Rec.DiseaseDescription)
                {
                    MultiLine = true;
                }
                field(DiagnoseDate; Rec.DiagnoseDate)
                {
                }
                field("Examination No."; Rec."Examination No.")
                {
                    Caption = 'Associated with';
                }
            }
        }
    }
}