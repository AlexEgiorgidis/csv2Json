namespace AE.JsonLibrary;

using System.Utilities;

codeunit 50100 "CSV To JSON"
{
    procedure CSV2Json(p_CSVText: Text; p_FieldDelemiter: text[1]; p_DownloadFile: Boolean; p_FileName: text)
    var
        Blob: Codeunit "Temp Blob";
        DataEntry: JsonObject;
        Data: JsonArray;
        InS: InStream;
        OutS: OutStream;
        BooleanV: Boolean;
        DateTimV: DateTime;
        DecimalV: Decimal;
        i: Integer;
        FieldNames: List of [Text];
        Parts: List of [Text];
    begin
        Blob.CreateOutStream(OutS);
        Blob.CreateInStream(InS);
        InS.ReadText(p_CSVText);
        FieldNames := p_CSVText.Split(p_FieldDelemiter);
        while InS.ReadText(p_CSVText) > 0 do begin
            Parts := p_CSVText.Split(p_FieldDelemiter);
            Clear(DataEntry);
            for i := 1 to Parts.Count do begin
                case true of
                    Evaluate(DateTimV, Parts.Get(i)):
                        DataEntry.Add(FieldNames.Get(i), DateTimV);
                    Evaluate(DecimalV, Parts.Get(i)):
                        DataEntry.Add(FieldNames.Get(i), DecimalV);
                    Evaluate(BooleanV, Parts.Get(i)):
                        DataEntry.Add(FieldNames.Get(i), BooleanV);
                    else
                        DataEntry.Add(FieldNames.get(i), Parts.Get(i));
                end;
            end;
            Data.Add(DataEntry);
        end;
        if p_DownloadFile then begin
            if p_FileName = '' then
                p_FileName := 'data.csv';
            DownloadFromStream(InS, '', '', '', p_FileName);
        end;
    end;

}
