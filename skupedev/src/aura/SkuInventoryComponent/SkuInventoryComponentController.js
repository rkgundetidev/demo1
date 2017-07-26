({
	doInit : function(component,event, helper) {
         console.log('in doInit ');
        var r = component.get('{!v.recordId}');
        console.log('r = '+r);
        var action = component.get("c.getInventoryDetails");
    action.setParams({
        "skuId": r
    });
        
        
    // Add callback behavior for when response is received
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            component.set("v.SKUResult", response.getReturnValue());
            console.log('success response '+response.getReturnValue());
             
           
        }
        else {
            console.log("Failed with state: " + state);
            
            var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            console.log("Error message: " + 
                                     errors[0].message);
                        }
                    } 
                    else 
                    {
                        console.log("Unknown error");
                    }
        }
    });

    // Send action off to be executed
    $A.enqueueAction(action);    



    action = component.get("c.getInventoryExceptions");
      r = component.get('{!v.recordId}');
            action.setParams({
                "skuId": r
            });
            action.setCallback(this,function(response) {
                  var state = response.getState();
                               if (component.isValid() && state === "SUCCESS")  {
              
               component.set("v.InventoryExceptions", response.getReturnValue());
               console.log('success response inv list'+response.getReturnValue());
             
                
            }
            else {
                 console.log("Failed with state: " + state);
                 var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            console.log("Error message: " + 
                                     errors[0].message);
                        }
                    } 
                    else 
                    {
                        console.log("Unknown error");
                    }

            }
        }); 
                               
          $A.enqueueAction(action);  
        
	}
})