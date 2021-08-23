//%attributes = {}
// PM: "compilerDirectivesToVar" (neu mho 12.08.2021)

#DECLARE($IN_code : Text)->$varDeclarations : Text

var $code : Text
var $dataTypes : Collection

$dataTypes:=New collection:C1472()
$dataTypes.push(New object:C1471("compilerDirective"; "C_BOOLEAN"; "varDeclaration"; "Boolean"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_BOOLEEN"; "varDeclaration"; "Booléen"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_DATE"; "varDeclaration"; "Date"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_LONGINT"; "varDeclaration"; "Integer"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_ENTIER LONG"; "varDeclaration"; "Entier long"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_OBJECT"; "varDeclaration"; "Object"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_OBJET"; "varDeclaration"; "Objet"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_PICTURE"; "varDeclaration"; "Picture"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_IMAGE"; "varDeclaration"; "Image"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_POINTER"; "varDeclaration"; "Pointer"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_POINTEUR"; "varDeclaration"; "Pointeur"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_REAL"; "varDeclaration"; "Real"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_REEL"; "varDeclaration"; "Numérique"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_TEXT"; "varDeclaration"; "Text"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_TEXTE"; "varDeclaration"; "Texte"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_TIME"; "varDeclaration"; "Time"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_HEURE"; "varDeclaration"; "Heure"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_VARIANT"; "varDeclaration"; "Variant"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_COLLECTION"; "varDeclaration"; "Collection"))
$dataTypes.push(New object:C1471("compilerDirective"; "C_BLOB"; "varDeclaration"; "Blob"))

If (Count parameters:C259=0)
	$code:=""
Else 
	$code:=$IN_code
End if 

$code:=Replace string:C233($code; "\r\n"; "\n")
$code:=Replace string:C233($code; "\r"; "\n")

var $codeLines : Collection
var $newCodeLines : Collection

$codeLines:=Split string:C1554($code; "\n"; sk trim spaces:K86:2)
$newCodeLines:=New collection:C1472()

var $codeLine; $varDeclaration : Text
var $dataType : Object

For each ($codeLine; $codeLines)
	var $isCompilerDirective : Boolean
	$isCompilerDirective:=False:C215
	
	For each ($dataType; $dataTypes) While (Not:C34($isCompilerDirective))
		$isCompilerDirective:=($codeLine=($dataType.compilerDirective+"(@"))
		
		If ($isCompilerDirective)
			$varDeclaration:=$dataType.varDeclaration
		End if 
	End for each 
	
	If ($isCompilerDirective)
		var $posStart; $posEnd : Integer
		
		$posStart:=Position:C15("("; $codeLine)
		$posEnd:=Position:C15(")"; $codeLine; $posStart+1)
		
		If (($posStart>0) & ($posEnd>0))
			var $variableNames : Collection
			var $variableDeclaration : Text
			
			$variableNames:=Split string:C1554(Substring:C12($codeLine; $posStart+1; $posEnd-$posStart-1); ";"; sk trim spaces:K86:2)
			$variableNames.sort()
			
			$variableDeclaration:="var "+$variableNames.join("; ")+" : "+$varDeclaration
			
			If (False:C215)  // set to True in order to preserve comments 
				$variableDeclaration:=$variableDeclaration+Substring:C12($codeLine; $posEnd+1)
			End if 
			
			$newCodeLines.push($variableDeclaration)
		End if 
	Else 
		$newCodeLines.push($codeLine)
	End if 
	
End for each 

$varDeclarations:=$newCodeLines.join("\r\n")
