({
    getprojections:  function(component, page, recordToDisply,screen,step) {
         var action = component.get("c.fetchProjectionsg11");
          // set the parameters to method 
          //  var step = component.get("v.step");
      action.setParams({
         "pageNumber": page,
         "recordToDisply": recordToDisply,
         "screen": screen,
         "step":step
      });
      // set a call back   
      action.setCallback(this, function(response) {
           var state = response.getState();
           console.log('callback state '+state);

            if (component.isValid() && state === "SUCCESS") {
                // store the response return value (wrapper class insatance)  
                var result = response.getReturnValue();
                console.log('result ---->' + JSON.stringify(result));
                // set the component attributes value with wrapper class properties.   
        
                component.set("v.manualprojections", result.skuProjections);
                component.set("v.skudetails", result.skuProjectionsWrapper);
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
    },
    updateProjections:function(component,projections) {
        var action = component.get("c.updateProjections");
        action.setParams({
        "projToUpdate": projections,
         
    });

     action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            var manualprojections = component.get("v.manualprojections");
           // manualprojections.push(response.getReturnValue());
           // component.set("v.manualprojections", manualprojections);
           console.log('update of projections sucess');
             
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
    createProjection:function(component,newProjection) {
        //var sel = component.find("ptype").get("v.value");
        //console.log("sel value "+sel);
        //component.set("v.manualprojection.Projection_Type__c",sel);
        var id = component.get("v.manualprojection.Id");
   
        newProjection.sobjectType = 'SKU_Projection__c';
        
        var action = component.get("c.saveProjection");
    action.setParams({
        "projectionDataToInsert": newProjection,
        "updateId":id
    });
    action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            var manualprojections = component.get("v.manualprojections");
            manualprojections.push(response.getReturnValue());
            component.set("v.manualprojections", manualprojections);
              component.set("v.manualprojection",{'sobjectType': 'SKU_Projection__c',
                    'Brand_Name__c': '',
                    'Manual_Projected_Date__c': '',
                   'Projection_Type__c':'Disco',
                    'SKU_Text__c': '',
                    'Brand_Code__c': '',
                    'Description__c': ''});
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
     action.setParams({
         "projectionId": projectionId,         
      });

       action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            var manualprojections = component.get("v.manualprojections");
            manualprojections.push(response.getReturnValue());
            component.set("v.manualprojections", manualprojections);
              component.set("v.manualprojection",{'sobjectType': 'SKU_Projection__c',
                    'Brand_Name__c': '',
                    'Manual_Projected_Date__c': '',
                   'Projection_Type__c':'Disco',
                    'SKU_Text__c': '',
                    'Brand_Code__c': '',
                    'Description__c': ''});
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
    //alert('in helper '+sku+' '+type);
    var action = component.get("c.FetchDetailsBySKUOrBC");
     

   //  var copyid = component.get('v.manualprojectioncopy.Brand_Code__c');
     //alert(copyid);
    //if(component.get("v.manualprojection")!=null)
    // component.set("v.manualprojectioncopy",component.get("v.manualprojection"));      
    action.setParams({
                "value": sku,
                "type" :type
            });

 action.setCallback(this, function(response) {
        var state = response.getState();
        var opts;
        if (component.isValid() && state === "SUCCESS") {
            var result =  response.getReturnValue();
           
            component.set("v.manualprojection",result);   
            if(result.SKU_Projection__c !=null && result.SKU_Projection__c.Id !='undefined')
           // component.set("v.recordId",result.SKU_Projection__c.Id);       
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

} 

})