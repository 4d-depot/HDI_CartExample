#DECLARE($path : Text; $header : Text; $ipB : Text; $ipS : Text; \
$user : Text; $pw : Text)->$valid : Boolean

$handler:=MobileAppServer.WebHandler.new()
$context:=$handler.getContext()
$dataclass:=$context.dataClass
$primaryKey:=$context.entity.primaryKey

$session:=Session:C1714

If (Session:C1714.storage.mobileData=Null:C1517)
	
	$mobileData:=New shared collection:C1527
	
	Use (Session:C1714.storage)
		
		Session:C1714.storage.mobileData:=$mobileData
		
	End use 
	
Else 
	
	$mobileData:=Session:C1714.storage.mobileData
	
End if 





