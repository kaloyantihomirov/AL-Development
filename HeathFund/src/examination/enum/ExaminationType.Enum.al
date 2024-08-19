enum 50100 ExaminationType_MED_NTG
{
    Extensible = true;

    value(0; CheckUp)
    {
        Caption = 'Medical Check-up';
    }
    value(1; NormalExamination)
    {
        Caption = 'Normal examination';
    }
    value(2; ReferralExamination)
    {
        Caption = 'Referral Examination';
    }
}