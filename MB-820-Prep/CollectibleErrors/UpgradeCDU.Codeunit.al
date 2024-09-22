codeunit 50385 UpgradeCDU
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    var
        Source: Record "Reservation";
        ModInfo: ModuleInfo;
        DataTransfer: DataTransfer;
    begin
        if NavApp.GetCurrentModuleInfo(ModInfo) then
            if ModInfo.AppVersion.Major = 2 then begin
                DataTransfer.SetTables(Database::Reservation, Database::Reservation);
                DataTransfer.AddFieldValue(Source.FieldNo("Description"), Source.FieldNo("DescriptionNew"));
                DataTransfer.CopyFields();
            end;
    end;
}