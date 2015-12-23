Const adOpenKeyset = 1
Const adTypeBinary = 1
Const adSaveCreateOverWrite = 2
Const adLockOptimistic = 3

Set cnnConnection = CreateObject("ADODB.Connection")
Set rstRecordset = CreateObject("ADODB.Recordset")
Set strStream = CreateObject("ADODB.Stream")

cnnConnection.Open ("Provider=SQLOLEDB; data Source=server\instance;Initial Catalog=database; Trusted_Connection=yes")
rstRecordset.Open "Select pdfPassport from clientes where id = 1", cnnConnection, adOpenKeyset, adLockOptimistic

strStream.Type = adTypeBinary
strStream.Open

strStream.Write rstRecordset.Fields("pdfPassport").Value
strStream.SaveToFile "C:\file.pdf", adSaveCreateOverWrite

strStream.Close ()
rstRecordset.Close ()
cnnConnection.Close ()
