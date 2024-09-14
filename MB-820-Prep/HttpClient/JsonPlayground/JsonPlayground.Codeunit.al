codeunit 60101 JsonPlayground
{
    procedure CreateJSONOrder(SalesHeader: Record "Sales Header"): Text
    var
        SalesLine: Record "Sales Line";
        HeaderJsonObject: JsonObject;
        LineJsonObject: JsonObject;
        JsonArray: JsonArray;
        ResultTxt: Text;
    begin
        HeaderJsonObject.Add('DocumentType', SalesHeader."Document Type".AsInteger());
        HeaderJsonObject.Add('No.', SalesHeader."No.");
        HeaderJsonObject.Add('SellToCustNo', SalesHeader."Sell-to Customer No.");
        HeaderJsonObject.Add('PostingDate', SalesHeader."Posting Date");

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");

        if SalesLine.FindSet() then
            repeat
                Clear(LineJsonObject);
                LineJsonObject.Add('LineNo', SalesLine."Line No.");
                LineJsonObject.Add('Type', SalesLine.Type.AsInteger());
                LineJsonObject.Add('No', SalesLine."No.");
                LineJsonObject.Add('Quantity', SalesLine.Quantity);
                LineJsonObject.Add('UnitPrice', SalesLine."Unit Price");
                JsonArray.Add(LineJsonObject);
            until SalesLine.Next() = 0;

        HeaderJsonObject.Add('Lines', JsonArray);

        // Message(Format(HeaderJsonObject));
        HeaderJsonObject.WriteTo(ResultTxt);
        exit(ResultTxt);
    end;
}