Dim File, Data, d

Data = Wscript.Arguments(0)
File = Wscript.Arguments(1)

Function SaveBinaryData(FileName, ByteArray)
    Set oFS = CreateObject("Scripting.FileSystemObject")
    Set writer = oFs.createtextfile(FileName)
    
    For Each b in ByteArray
       writer.write Chr(b)
    Next
End Function

Function IntToBinary (i)

    Dim Binary, Value

    Value = 32
    Binary = ""

    While Value > 1

        If i >= Value Then
            Binary = Binary & 1
            i = i - Value
            Value = Value/2
        Else
            Binary = Binary & 0
            Value = Value/2
        End If

    Wend

    If i = 1 Then
        Binary = Binary & 1

    Else
        Binary = Binary & 0

    End If

    IntToBinary = Binary

End Function

Function BinToByte (Binary)

    For x = 1 to Len(Binary) - 1 Step 8
        Bits = Mid(Binary, x, 8)
        Value = 128
        Tmp = 0

        For p = 1 To Len(Bits)
            Tmp = Tmp + (CInt(Mid(Bits, p, 1)) * Value)
            Value = Value / 2
        Next

    Next

    BinToByte = Tmp

End Function

Function Decode (c)

    Dim Dictionary, Bits, Value, Tmp

    Dictionary = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/="  
    Decode = IntToBinary(InStr(Dictionary, c) - 1)

End Function

Function Base64Decode (Data)

    Dim c, Binary, tmp (), p

    l = 0

    For i = 1 To Len(Data)
        c = Mid(Data,i,1)
        Binary = Binary & Decode(c)

        If i mod 4 = 0 Then
            
            For x = 1 to Len(Binary) / 8
                ReDim Preserve tmp (l)
                tmp (l) = BinToByte (Mid(Binary, (x * 8 - 8) + 1, 8))
                l = l + 1
            Next
            Binary = ""

        End If


        If c = "=" Then p = p + 1

    Next

    Redim Preserve tmp (l - p - 1)
    Base64Decode = tmp

End Function

If Not Len(Data) mod 4 = 0 Then
    Wscript.Echo "Invalid input."
    Wscript.Quit (5)

End If

d = Base64Decode(Data)

SaveBinaryData File, d
