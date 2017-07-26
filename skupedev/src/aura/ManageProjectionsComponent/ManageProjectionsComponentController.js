({
   doInit:function(component,event,helper) {
      var page = component.get("v.page") || 1;   
      var recordToDisply = component.get("v.pagesize");
      var projType = component.get("v.projType");
      var projMnth = component.get("v.mnth");
      var cat = component.get("v.cat");     
      var ptype = component.find("ptype").set("v.value",projType);
      var pdate = component.find("pdate").set("v.value",projMnth);
      helper.getprojections(component, page, projType ,recordToDisply);
   },
   previousPage: function(component, event, helper) {      
      var page = component.get("v.page") || 1;      
      var direction = event.getSource().get("v.label");    
      var recordToDisply = component.get("v.pagesize");
      page = direction === "Previous Page" ? (page - 1) : (page + 1);
      var projType = component.get("v.projType");
      helper.getprojections(component, page, projType,recordToDisply); 
   }, 
   nextPage: function(component, event, helper) {      
      var page = component.get("v.page") || 1;      
      var direction = event.getSource().get("v.label");       
      var recordToDisply = component.get("v.pagesize");   
      page = direction === "Previous Page" ? (page - 1) : (page + 1);
      var projType = component.get("v.projType");
      helper.getprojections(component, page, projType,recordToDisply);
   },
   handleSave:function(component,event,helper) {      
     var page = component.get("v.page") || 1;
     var recordToDisply = component.get("v.pagesize");
     var newProjection = component.get("v.manualprojection");
     var projType = component.get("v.projType");
     var isValid = true;
     var descriptionField = component.find("description");
     var brandField = component.find("brandinp");   
     var pdateField = component.find("pdate");
     var ptypeField = component.find("ptype");
     var description = descriptionField.get("v.value");
     var brand = brandField.get("v.value");
     var pdate =pdateField.get("v.value");
     var ptype = ptypeField.get("v.value");
     var searchType = component.get("v.searchType");

    if(searchType != "None") {
        if($A.util.isEmpty(description)) {
            isValid = false;
            descriptionField.set("v.errors", [{message:"Description cannot be blank!!"}]);
        }
        else descriptionField.set("v.errors",null);
    
        if($A.util.isEmpty(pdate)) {
            isValid = false;
            pdateField.set("v.errors", [{message:"Projection Month cannot be blank!!"}]);
        }
        else pdateField.set("v.errors",null);
        if($A.util.isEmpty(ptype)) {
            isValid = false;
            ptypeField.set("v.errors", [{message:"Projection Type cannot be blank!!"}]);
        }
        else ptypeField.set("v.errors",null);
        if($A.util.isEmpty(brand)) {
            isValid = false;
            brandField.set("v.errors", [{message:"Brand cannot be blank!!"}]);
        }
        else brandField.set("v.errors",null);

        if(isValid) component.find("commentsModal").open();      
    } 
    else  {
        helper.createProjection(component,newProjection,JSON.stringify(component.get("v.manualprojections")));
        helper.getprojections(component,page,projType,recordToDisply);
    }
   },
   handleDelete:function(component,event,helper) {   
        var page = component.get("v.page") || 1;
        var recordToDisply = component.get("v.pagesize");
        var projectionId = event.getSource().get("v.value");
        var projType = component.get("v.projType");
        helper.deleteProjection(component,projectionId);
        helper.getprojections(component,page,projType,recordToDisply,true);    
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
      component.set("v.searchType","SKU");
      var mp = component.get("v.manualprojection");
      helper.FetchDetailsBySKUOrBC(component,mp,'SKU');
   },
   brandcodeChange:function(component,event,helper) {
       var brandcode = event.getSource().get('v.value');
       component.set("v.searchType","Brandcode");
       var mp = component.get("v.manualprojection");
       helper.FetchDetailsBySKUOrBC(component,mp,'Brandcode');      
     },
   closeModal:function(component,event,helper) {
        var page = component.get("v.page") || 1;
        var recordToDisply = component.get("v.pagesize");
        helper.closeModal(component);
        var newProjection = component.get("v.manualprojection");
        var projType = component.get("v.projType");
        // helper.saveComments(component,newProjection);
        helper.createProjection(component,newProjection);
        helper.getprojections(component,page,projType,recordToDisply);
   },
    saveComments:function(component,event,helper) {
        var page = component.get("v.page") || 1;
        var recordToDisply = component.get("v.pagesize");
        var newProjection = component.get("v.manualprojection");
        var g11Projections = component.get("v.manualprojections");
        var projType = component.get("v.projType");
        
        helper.createProjection(component,newProjection);
        helper.getprojections(component,page,projType,recordToDisply);
        helper.closeModal(component);
   }


})