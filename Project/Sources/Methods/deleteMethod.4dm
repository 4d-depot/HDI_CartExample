//%attributes = {"publishedWeb":true}
ARRAY TEXT:C222($var1; 0)
ARRAY TEXT:C222($var2; 0)

WEB GET VARIABLES:C683($var1; $var2)
$indexToRemove:=Find in array:C230($var1; "index")

If ($indexToRemove>0)
	$productIndex:=Num:C11($var2{$indexToRemove})
	
	Use (Session:C1714.storage.mobileData)
		$mobileData:=Session:C1714.storage.mobileData
		$mobileData.remove($productIndex)
	End use 
End if 