Dim Padding, File, Data

File = Wscript.Arguments(0)

Function GetFile(FileName)
	Dim Stream: Set Stream = CreateObject("ADODB.Stream")
	Stream.Type = 1
	Stream.Open
	Stream.LoadFromFile FileName
	GetFile = Stream.Read
	Stream.Close
End Function

Function WordToBinary (Word)
	Dim Binary, Value

	Value = 128
	Binary = ""

	While Value > 1

		If Word >= Value Then
			Binary = Binary & 1
			Word = Word - Value
			Value = Value/2
		Else
			Binary = Binary & 0
			Value = Value/2
		End If

	Wend

	If Word = 1 Then
		Binary = Binary & 1
	Else
		Binary = Binary & 0
	End If

	WordToBinary = Binary
End Function

Function Encode (Binary)
	Dim Dictionary, Bits, Value, Tmp
	Dictionary = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="
	
	For x = 1 to Len(Binary) - 1 Step 6
		Bits = Mid(Binary, x, 6)
		Value = 32
		Tmp = 0

		For p = 1 To Len(Bits)
			Tmp = Tmp + (CInt(Mid(Bits, p, 1)) * Value)
			Value = Value / 2
		Next

		Encode = Encode & Mid(Dictionary, Tmp + 1, 1)

	Next
End Function

Function Base64Encode (Data)
	Dim c, Binary

    For i = 1 To LenB(Data)
        c = MidB(Data,i,1)
        Binary = Binary & WordToBinary(AscB(c))
        
        If i mod 3 = 0 Then
        	Base64Encode = Base64Encode & Encode(Binary)
        	Binary = ""
        End If

    Next

    If Binary <> "" Then
    	Binary = Binary & String(6 - (Len(Binary) mod 6) , "0")
    	Base64Encode = Base64Encode & Encode(Binary)
        Binary = ""
    End If
End Function

Data = GetFile(File)
If LenB(Data) mod 3 > 0 Then Padding = 3 - (LenB(Data) mod 3)

Padding = String(Padding, "=")
WScript.Echo Base64Encode(Data) & Padding
