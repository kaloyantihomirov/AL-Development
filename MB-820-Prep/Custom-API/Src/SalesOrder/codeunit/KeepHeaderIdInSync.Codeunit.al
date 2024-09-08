codeunit 50101 KeepHeaderIdInSync
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInsertEvent', '', true, true)]
    local procedure FillTheHeaderIdOnAfterInsertEvent(var Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        Rec."Header Id" := SalesHeader.SystemId;
        Rec.Modify();
    end;
}