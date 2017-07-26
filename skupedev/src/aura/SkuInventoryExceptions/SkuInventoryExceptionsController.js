({
	doInit : function(component, event, helper) {
	 var action = component.get("c.getInventoryExceptions");
     var r = component.get('{!v.recordId}');
            action.setParams({
                "skuId": r
            });
            action.setCallback(this,function(response) {
                               if (component.isValid() && state === "SUCCESS")  {
                 var state = response.getState();
               component.set("v.InventoryExceptions", response.getReturnValue());
               console.log('success response inv list'+response.getReturnValue());
             
                
            }
            else {
                 console.log("Failed with state: " + state);
            }
        }); 
                               
          $A.enqueueAction(action);                      
        
	}
})