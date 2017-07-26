({
   doInit:function(component,event,helper) {

      // this function call on the component load first time     
      // get the page Number if it's not define, take 1 as default
      var page = component.get("v.page") || 1;
      var screen = component.get("v.screen");
      // get the select option (drop-down) values.   
      //var recordToDisply = component.find("recordSize").get("v.value");
      var recordToDisply = 10;
       helper.getprojections(component, page, recordToDisply,screen);

/*      var taskColumns =[  
            {  
      'label':'Brand',
      'name':'Brand_Name__c',
      'type':'string'
   },
   {  
      'label':'Pillar',
      'name':'',
      'type':'string'
   },     
   {  
      'label':'Projection Type',
      'name':'Projection_Type__c',
      'type':'string',    
   },
   {  
      'label':'Projection Month',
      'name':'Manual_Projected_Date__c',
      'type':'date'
   },
    {  
      'label':'SKU',
      'name':'SKU_Text__c',
      'type':'string'
   },
    {  
      'label':'BrandCode',
      'name':'Brand_Code__c',
      'type':'string '    
   },
    {  
      'label':'Description',
      'name':'Description__c',
      'type':'string '    
   }
   
  
];

var tableConfig = { "searchBox":false };

     action.setCallback(this, function(response) {
        var state = response.getState();
        
        if (component.isValid() && state === "SUCCESS") {
            var result =  response.getReturnValue();
            component.set("v.manualprojections",result);          
            console.log('success response '+result);   


  component.set("v.bcColumns" , taskColumns );  
  component.set("v.bcConfig",tableConfig);  
  //    component.find ("mptable" ). initialize ( { "order" :[0, " desc " ] } ); 

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
    */

   },

   previousPage: function(component, event, helper) {
      // this function call on click on the previous page button  
      var page = component.get("v.page") || 1;
      // get the previous button label  
      var direction = event.getSource().get("v.label");
      // get the select option (drop-down) values.  
     // var recordToDisply = component.find("recordSize").get("v.value");
       var recordToDisply = 10;
      // set the current page,(using ternary operator.)  
      page = direction === "Previous Page" ? (page - 1) : (page + 1);
      // call the helper function
      helper.getprojections(component, page, recordToDisply);
 
   },
 
   nextPage: function(component, event, helper) {
      // this function call on click on the next page button   
      var page = component.get("v.page") || 1;
      // get the next button label 
      var direction = event.getSource().get("v.label");
      // get the select option (drop-down) values.   
     // var recordToDisply = component.find("recordSize").get("v.value");
       var recordToDisply = 10;
      // set the current page,(using ternary operator.)  "(page + 1)"
      page = direction === "Previous Page" ? (page - 1) : (page + 1);
      // call the helper function
      helper.getprojections(component, page, recordToDisply);
   },
   handleSave:function(component,event,helper) {      
         var page = component.get("v.page") || 1;
       var newProjection = component.get("v.manualprojection");
     //  alert(newProjection);
       helper.createProjection(component,newProjection);
       helper.getprojections(component,1,10);
   },
   handleUpdate:function(component,event,helper)  {
      var proj = [];
      var checkvalues = component.find("checkproj");
      var projlist = component.get("v.manualprojections");
      
      for(var i = 0 ; i < projlist.length ; i++) {
        
         /* if(checkvalues[i].get("v.value") == true)  {
               projlist[i].Include_in_Projections_Manual__c = true;
               proj.push(projlist[i]); 

          }*/
          projlist[i].Include_in_Projections_Manual__c =  checkvalues[i].get("v.value");
          proj.push(projlist[i]); 
          
         
         
      }
        
      helper.updateProjections(component,proj);
       helper.getprojections(component,1,10);

   },
   checkboxselect:function(component,event,helper) { 
       var selectedRec = event.getSource().get("v.value");
   },
   handleDelete:function(component,event,helper) {   
    var projectionId = event.getSource().get("v.value");
    helper.deleteProjection(component,projectionId);
     helper.getprojections(component,1,10);
   },
   handleCancel:function(component,event,helper) {
      component.set("v.manualprojection",{'sobjectType': 'SKU_Projection__c',
                    'Brand_Name__c': '',
                    'Manual_Projected_Date__c': '',
                   'Projection_Type__c':'Disco',
                    'SKU_Text__c': '',
                    'Brand_Code__c': '',
                    'Description__c': ''});
   },
   skuChange:function(component,event,helper) {
      var sku = event.getSource().get('v.value');
       var mp = component.get("v.manualprojection");
        //alert('mp '+mp);

      helper.FetchDetailsBySKUOrBC(component,mp,'SKU');
   },

    brandcodeChange:function(component,event,helper) {
       var brandcode = event.getSource().get('v.value');


        var mp = component.get("v.manualprojection");
      //  alert('mp '+mp);


     
        helper.FetchDetailsBySKUOrBC(component,mp,'Brandcode');
        
       /*   var action = component.get("c.getSKUDetails");
          action.setParams({
                "brandcode": brandcode
            });

        action.setCallback(this, function(response) {
        var state = response.getState();
        var opts;
        if (component.isValid() && state === "SUCCESS") {
            var result =  response.getReturnValue();
            component.set("v.skuinfo",result);
           if(result.SKU__r.Status__c == 'Active & Planned') {
             // component.set("c.isActive",true);   
              //component.set("c.isRemnant",false);   
           }
           else if(result.SKU__r.Status__c == 'Remnant & Historical') {
            //component.set("c.isRemnant",true); 
            // component.set("c.isActive",false);     
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
  */


     }

})