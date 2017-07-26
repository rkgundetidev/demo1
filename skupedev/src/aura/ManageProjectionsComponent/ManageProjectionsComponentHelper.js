({
    getprojections:  function(component, page, projType,recordToDisply,isDelete) {
         var action = component.get("c.fetchProjections");
          // set the parameters to method 
        //var skuidList = component.get("v.skuidlist");
        var skuidList = component.get("v.skuids");

      action.setParams({
         "pageNumber": page,
         "recordToDisply": recordToDisply,
         "skuids": skuidList,
         "projType" : projType,
         "isDelete" :isDelete
      });
       
      action.setCallback(this, function(response) {
           var state = response.getState();
           console.log('callback state '+state);

            if (component.isValid() && state === "SUCCESS") {
                // store the response return value (wrapper class insatance)  
                var result = response.getReturnValue();
                console.log('result ---->' + JSON.stringify(result));
                // set the component attributes value with wrapper class properties.   
        
                component.set("v.manualprojections", result.skuProjections);
                component.set("v.page", result.page);
                component.set("v.total", result.total);
               
                component.set("v.pages", Math.ceil(result.total / recordToDisply));

            }  else {
            console.log("Failed with state: " + state);            
            var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            console.log("Error message: " +  errors[0].message);
                        }
                    } 
                    else 
                    {
                        console.log("Unknown error");
                    }
        }
         
 
      });
      // enqueue the action 
      $A.enqueueAction(action);
    } ,
    createProjection:function(component,newProjection,g11Projections) {
        
        var id = newProjection.Id; 

        var projType = component.get("v.projType");
        var projMnth = component.get("v.mnth");
        
        newProjection.sobjectType = 'SKU_Projection__c';
        if(newProjection.Projection_Type__c.includes('New')) newProjection.Projection_Type__c = 'New';
        if(newProjection.Projection_Type__c.includes('Disco')) newProjection.Projection_Type__c = 'Disco';

        var action = component.get("c.saveProjection");
    action.setParams({
        "projectionDataToInsert": newProjection,       
        "g11Projections":g11Projections
    });
    action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            var manualprojections = component.get("v.manualprojections");
            manualprojections.push(response.getReturnValue());
            component.set("v.manualprojections", manualprojections);
              component.set("v.manualprojection",{'sobjectType': 'SKU_Projection__c',                
                                                                 'SKU_Text__c': '',
                                                                 'Brand_Code__c': '',
                                                                 'Description__c': ''});       

               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!!",                    
                    message: "SKU projection(s) saved successfully!!"                  
                 });
                 toastEvent.fire();   

                 component.set("v.manualprojection.Projection_Type__c",projType);
                 component.set("v.manualprojection.Manual_Projected_Date__c",projMnth);
                 component.set("v.manualprojection.Comments__c",'');

        }
        else {
            console.log("Failed with state: " + state);            
            var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            console.log("Error message: " +  errors[0].message);
                        }
                    } 
                    else 
                    {
                        console.log("Unknown error");
                    }
        }
    });
    $A.enqueueAction(action);

},
deleteProjection:function(component,projectionId) {
     var action = component.get("c.deleteProjection");
      console.log('projid before delete'+projectionId);
     action.setParams({
         "projectionId": projectionId,         
      });

       action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            var manualprojections = component.get("v.manualprojections");
            manualprojections.push(response.getReturnValue());
            component.set("v.manualprojections", manualprojections);
            

              var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!!",                    
                    message: "The selected projection was deactivated successfully!!"                  
                 });
                 toastEvent.fire();  
                 var projType = component.get("v.projType");
                 var projMnth = component.get("v.mnth");
                 component.set("v.manualprojection.Projection_Type__c",projType);
                 component.set("v.manualprojection.Manual_Projected_Date__c",projMnth);
          
        }
        else {
            console.log("Failed with state: " + state);            
            var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            console.log("Error message: " +  errors[0].message);
                        }
                    } 
                    else 
                    {
                        console.log("Unknown error");
                    }
        }
    });
    $A.enqueueAction(action);

},
FetchDetailsBySKUOrBC:function(component,sku,type) {
    
    var action = component.get("c.FetchDetailsBySKUOrBC");
    action.setParams({
                "value": sku,
                "type" :type
            });

 action.setCallback(this, function(response) {
        var state = response.getState();
        var opts;
        if (component.isValid() && state === "SUCCESS") {
            var result =  response.getReturnValue();          
            if(result !=null) {
                 
                if(type=='Brandcode')
                component.find("skuinp").set("v.value",result.Sku);
               else if(type=='SKU') 
                component.find("brandcodeinp").set("v.value",result.Brandcode);
                
                component.find("description").set("v.value",result.Description);
                component.find("brandinp").set("v.value",result.Brand);              
                //component.set("v.searchType","None");
                if(typeof(result.projMonth) != 'undefined') component.find("pdate").set("v.value",result.ProjectionMonth);                        
            }          
            console.log('success response '+result);     
        }
        else {
            console.log("Failed with state: " + state);            
            var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            console.log("Error message: " +  errors[0].message);        

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

} ,
closeModal : function(component) {
    component.find("commentsModal").close(); 
}
 

})