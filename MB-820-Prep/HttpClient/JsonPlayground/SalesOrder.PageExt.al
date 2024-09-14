pageextension 60100 SalesOrderExt extends "Sales Order"
{
    actions
    {
        addlast(processing)
        {
            action("Order to JSON")
            {
                Caption = 'Order to JSON';
                ApplicationArea = All;
                ToolTip = 'Displays the order in JSON format';
                Image = Export;

                trigger OnAction()
                var
                    JsonPlaygroundCdu: Codeunit JsonPlayground;
                    JsonOrderTxt: Text;
                    OutS: OutStream;
                    InS: InStream;
                    FileName: Text;
                    File: File;
                    CannotDownloadFromStreamLbl: Label 'Cannot download from stream.';
                begin
                    JsonOrderTxt := JsonPlaygroundCdu.CreateJSONOrder(Rec);
                    File.CreateTempFile();
                    File.CreateOutStream(OutS);
                    OutS.WriteText(JsonOrderTxt);
                    File.CreateInStream(InS);
                    FileName := 'order' + '#' + Format(Rec."Document Type".AsInteger()) + '#' + Rec."No." + 'JSON.txt';
                    if not DownloadFromStream(InS, '', '', '', FileName) then
                        Error(CannotDownloadFromStreamLbl);
                    File.Close();
                end;
            }
        }
    }
}