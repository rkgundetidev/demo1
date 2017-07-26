({
  getprojections:  function(component, manualinputpage, systemdatapage,recordToDisply,step,skip) {
         var action = component.get("c.fetchProjections");
       
           
     if(skip) {
    
        if(systemdatapage !=1) systemdatapage = 1;
        if(manualinputpage !=1) manualinputapage = 1;

        var img1 = component.find('img1');
        var img2 = component.find('img2');
        var img3 = component.find('img3');

        if(img1.getElement().classList.contains('disabled') && !img2.getElement().classList.contains('disabled') && img3.getElement().classList.contains('disabled'))  {
         
            $A.util.addClass(img2, 'disabled cProjectionReconcileComponent');
            $A.util.removeClass(img3, 'disabled cProjectionReconcileComponent');   
            component.set('v.step','3'); 
        }

        else if(!img1.getElement().classList.contains('disabled') && img2.getElement().classList.contains('disabled') && img3.getElement().classList.contains('disabled'))  {
              
          $A.util.removeClass(img2, 'disabled cProjectionReconcileComponent');
           $A.util.addClass(img1, 'disabled cProjectionReconcileComponent');
           component.set('v.step','2');
        }

        else if(img1.getElement().classList.contains('disabled') && img2.getElement().classList.contains('disabled') && !img3.getElement().classList.contains('disabled'))  {
              
          $A.util.removeClass(img1, 'disabled cProjectionReconcileComponent');
           $A.util.addClass(img3, 'disabled cProjectionReconcileComponent');
           component.set('v.step','1');
          
        }
        step = component.get("v.step");
          
         // helper.getprojections(component,manualinput_page,systemdata_page,10,'System Data',step);

     }
      action.setParams({        
         "step":step
      });
      // set a call back   
      action.setCallback(this, function(response) {
           var state = response.getState();
           console.log('callback state '+state);

            if (component.isValid() && state === "SUCCESS") {
                // store the response return value (wrapper class insatance)  
                var result = response.getReturnValue();
                //console.log('result ---->' + JSON.stringify(result));
                // set the component attributes value with wrapper class properties.   
        
                component.set("v.manualprojections", result.skuProjections);
                component.set("v.systemprojections", result.brandProjections);
                component.set("v.systemprojections_data",result.systemDataWrapper);
                component.set("v.manualprojections_data", result.skuProjectionsWrapper);
                

                var g11_data = result.systemDataWrapper;
                var manual_data = result.skuProjectionsWrapper;

               
                if(manual_data !=null) {

                var manual_total = manual_data.length;
                var manual_pages = Math.ceil(manual_total / recordToDisply) ;
                var manual_offset= (manualinputpage-1)*recordToDisply;
                var manual_pageproj = [];
                
                for(var i=manual_offset;i<(manual_total<(systemdatapage*recordToDisply) ? manual_total:systemdatapage*recordToDisply);i++)
                {
                    manual_pageproj.push(manual_data[i]); 
                }
                
                component.set("v.skudetails",manual_pageproj);
                component.set("v.manualinput_page", manualinputpage);
                component.set("v.manualinput_total", manual_total);
                component.set("v.manualinput_pages", manual_pages);
                
                var pnums = [];  
                var noOfPages=manual_pages<10?manual_pages:10;
                //alert(noOfPages);
                for(var i=1;i<=noOfPages;i++){
                    pnums.push(i);
                }
                component.set("v.manualinput_pagenumbers",pnums);

                 }
            

                if(g11_data !=null) {   
                
                var g11_total = g11_data.length;
                var g11_pages = Math.ceil(g11_total / recordToDisply) ;
                var g11_offset= (systemdatapage-1)*recordToDisply;
                var g11_pageproj = [];
                
                for(var i=g11_offset;i<(g11_total<(systemdatapage*recordToDisply) ? g11_total:systemdatapage*recordToDisply);i++)
                {
                    g11_pageproj.push(g11_data[i]); 
                }
                
                component.set("v.systemdetails",g11_pageproj);
                component.set("v.systemdata_page", systemdatapage);
                component.set("v.systemdata_total", g11_total);
                component.set("v.systemdata_pages", g11_pages);
                
                var pnums = []; 
                var noOfPages=g11_pages<10?g11_pages:10;
                //alert(noOfPages);
                for(var i=1;i<=noOfPages;i++){
                    pnums.push(i);
                }
                component.set("v.systemdata_pagenumbers",pnums);
                
              }
             

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
        //console.log('systemdata updateproj'+projections);        
        action.setParams({
            "skusToUpdate" :projections   
        });

     action.setCallback(this, function(response){
        var state = response.getState();
        if (component.isValid() && state === "SUCCESS") {
            var manualprojections = component.get("v.manualprojections");            
            console.log('update of projections success');            
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
               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!!",                    
                    message: "SKU projection was deleted successfully!!"                  
                 });
                 toastEvent.fire();    
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

}, paginate:function(component,source,page,data,recordToDisply) {

    
        var total = data.length;
        var pages = Math.ceil(total / recordToDisply) ;
        var offset= (page-1)*recordToDisply;
        var pagedata = [];
        var count = 0;
        var system_data = [],manual_data = [];

        system_data = component.get('v.systemproj_checkarray');
        manual_data = component.get('v.manualproj_checkarray');
        
        var checkvalues_system = component.find("checkprojsystem");
        var checkvalues_manual = component.find("checkproj");

        if(source.includes('btng11')) {            
           if(system_data.length == 0)  {
              for(var j = 0 ; j <checkvalues_system.length ; j++) {      
                system_data.push(checkvalues_system[j].get("v.text")+':'+checkvalues_system[j].get("v.value"));     
              }            
           }
           else {           
                for(var j = 0 ; j <checkvalues_system.length ; j++)  {
                  var isFound = false; 
                  for(var i = 0; i < system_data.length ;i++) {
                     var split = system_data[i].split(':');
                     if(split[0] ==checkvalues_system[j].get("v.text")) {  
                       // console.log("found "+split[0]);
                        isFound = true;
                        system_data[i] = split[0]+':'+checkvalues_system[j].get("v.value");
                        break;
                       }    
                   }
                   if(!isFound) system_data.push(checkvalues_system[j].get("v.text")+':'+checkvalues_system[j].get("v.value"));
              }              
            }
            component.set('v.systemproj_checkarray',system_data);  
        }
        
         if(source.includes('btnmanual')) {
             if(manual_data.length == 0)  {
              for(var j = 0 ; j <checkvalues_manual.length ; j++) {      
                manual_data.push(checkvalues_manual[j].get("v.text")+':'+checkvalues_manual[j].get("v.value"));     
              }            
           }
           else {           
                for(var j = 0 ; j <checkvalues_manual.length ; j++)  {
                  var isFound = false; 
                  for(var i = 0; i < manual_data.length ;i++) {
                     var split = manual_data[i].split(':');
                     if(split[0] ==checkvalues_manual[j].get("v.text")) {  
                       // console.log("found "+split[0]);
                        isFound = true;
                        manual_data[i] = split[0]+':'+checkvalues_manual[j].get("v.value");
                        break;
                       }    
                   }
                   if(!isFound) manual_data.push(checkvalues_manual[j].get("v.text")+':'+checkvalues_manual[j].get("v.value"));
              }              
            }
            component.set('v.manualproj_checkarray',manual_data);   
         }
         
        for(var i=offset;i<(total<(page*recordToDisply) ? total:page*recordToDisply);i++)
        {   
               pagedata.push(data[i]);  
        }
         
        
        if(source.includes('btng11')) {           
            component.set("v.systemdetails",pagedata);
            component.set("v.systemdata_page", page);
            component.set("v.systemdata_total", total);
            component.set("v.systemdata_pages", pages);               
        }
         else {           
            component.set("v.skudetails",pagedata);
            component.set("v.manualinput_page", page);
            component.set("v.manualinput_total",total);
            component.set("v.manualinput_pages", pages); 
        }
        
        var pnums = []; 
        var noOfPages=pages<10?pages:10;
        //alert(noOfPages);
        for(var i=1;i<=noOfPages;i++){
            pnums.push(i);
        }
        if(source.includes('btng11'))
        component.set("v.systemdata_pagenumbers",pnums);
        else
         component.set("v.manualinput_pagenumbers",pnums);
    

},

hideSpinner: function(cmp){
     
      $A.util.addClass(cmp.find('spinner'),'slds-hide');
    },
    showSpinner:function(cmp){
       
      $A.util.removeClass(cmp.find('spinner'),'slds-hide');  
    },
    createProjection:function(component,newProjection) {
       
        var id = component.get("v.selectedprojection.Id");  
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
            console.log("update projection success!!");
            component.set("v.manualprojections", manualprojections);
              component.set("v.manualprojection",{'sobjectType': 'SKU_Projection__c',
                    'Brand_Name__c': '',
                    'Manual_Projected_Date__c': '',
                   'Projection_Type__c':'Disco',
                    'SKU_Text__c': '',
                    'Brand_Code__c': '',
                    'Description__c': ''});

               var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title: "Success!!",                    
                    message: "SKU projection was updated successfully!!"                  
                 });
                 toastEvent.fire();           
        }
        else {
 
            console.log("Failed with state: "+ state);            
            var errors = response.getError();
                    if (errors) 
                    {
                        if (errors[0] && errors[0].message) 
                        {
                            console.log("Error message: " +errors[0].message);
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
closeProjectionModal : function(cmp){        
//Hide the task modal once editing is done 
cmp.find("editProjectionmodal").close();                
 
cmp.set("v.selectedprojection",{'sobjectType':'SKU_Projection__c',
                                            'Brand_Name__c': '',
                                            'Manual_Projected_Date__c': '',
                                            'Projection_Type__c':'',
                                            'SKU_Text__c': '',
                                            'Brand_Code__c': '',
                                            'Description__c': ''
                                        }
 )},
 toggleHelper : function(component,event) {
   // var toggleText = component.find("tooltip"+event.currentTarget.dataset.index);
     var toggleText = component.find("tooltip_comments");
   
     $A.util.toggleClass(toggleText, "toggle cProjectionReconcileComponent");
       
    
   }

 })