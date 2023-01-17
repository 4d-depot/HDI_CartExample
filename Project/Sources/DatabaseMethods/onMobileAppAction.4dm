#DECLARE($request : Object) : Object

var $productExist : Boolean
var $product; $response; $status : Object
var $mobileData : Collection
var $entity : 4D:C1709.Entity

$response:=New object:C1471

$action:=MobileAppServer.Action.new($request)

Case of 
		
	: ($request.action="shareContact")
		
		$response:=$action.shareContext()
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	: ($request.action="addToCart")
		
		If (Session:C1714.storage.mobileData=Null:C1517)
			
			$mobileData:=New shared collection:C1527
			
			Use (Session:C1714.storage)
				
				Session:C1714.storage.mobileData:=$mobileData
				
			End use 
			
		Else 
			
			$mobileData:=Session:C1714.storage.mobileData
			
		End if 
		
		$entity:=ds:C1482[$request.context.dataClass].query("ID = "+String:C10($request.context.entity.primaryKey)).first()
		
		// CHECK IF STOCK > 0
		If ($entity.Stock>0)
			
			If ($mobileData.length>0)
				
				$product:=$mobileData.query("Name = :1"; $entity.Name).pop()
				$productExist:=$product#Null:C1517
				
				If ($productExist)
					
					Use ($mobileData)
						
						$product.Quantity:=$product.Quantity+1
						$product.Price:=($entity.Price)*($product.Quantity)
						
					End use 
					
				End if 
			End if 
			
			If (Not:C34($productExist))
				
				$product:=New shared object:C1526(\
					"Name"; $entity.Name; \
					"Picture"; $entity.Picture; \
					"Quantity"; 1; \
					"Price"; $entity.Price)
				
				Use ($mobileData)
					
					$mobileData.push($product)
					
				End use 
			End if 
			
			$entity.Stock:=$entity.Stock-1
			$status:=$entity.save()
			
			If ($status.success)
				
				$response.success:=True:C214
				$response.dataSynchro:=True:C214
				$response.statusText:="Well done 👍\n"+$entity.Name+" has been added to your cart!"
				
			Else 
				
				$response.statusText:="Bad luck 🫤\n"+$entity.Name+" has not been added to your cart!"
				
			End if 
			
		Else 
			
			// STOCK = 0
			$response.dataSynchro:=True:C214
			$response.statusText:="Bad luck 👎\n No more stock available for this product!"
			
		End if 
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	Else 
		
		// Unknown action
		$response.statusText:="Unknown action: "+$request.action
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 

return $response