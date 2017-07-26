({
   
    doInit:function(component,event,helper) {
        
      var skumatch = component.find('skumatch');
      var img2 = component.find('img2');
      var img3 = component.find('img3');

      $A.util.toggleClass(skumatch, 'boldcss'); 
      $A.util.addClass(img2, 'disabled cProjectionReconcileComponent');
      $A.util.addClass(img3, 'disabled cProjectionReconcileComponent');
       $A.util.addClass('tooltip','toggleoff cProjectionReconcileComponent');
       
      var manualinput_page = component.get("v.manualinput_page") || 1;
      var systemdata_page = component.get("v.systemdata_page") || 1;
       //var recordToDisply = component.find("recordSize").get("v.value");
       var recordToDisply = 10;     
       helper.getprojections(component, manualinput_page,systemdata_page ,recordToDisply,1);
       var result = component.get("v.systemdetails");      
       helper.hideSpinner(component);
    },      
    handleSkip:function(component,event,helper) {
      helper.showSpinner(component);
      var step = component.get("v.step");
      // $A.util.addClass('tooltip','toggleoff cProjectionReconcileComponent');
      var manualinput_page = component.get("v.manualinput_page") || 1;
      var systemdata_page = component.get("v.systemdata_page") || 1;
      var recordToDisply = 10;  
      helper.getprojections(component,manualinput_page,systemdata_page,recordToDisply,step,true);
      helper.hideSpinner(component);
   },   
   saveRecord:function(component,event,helper) {
      var editProjection = component.get("v.selectedprojection");
      var step = component.get("v.step");         
      helper.createProjection(component,editProjection);
      if(editProjection && editProjection.Id !=null )  {           
        component.find("editProjectionmodal").close();       
      }
      helper.getprojections(component,1,1,10,step);
   },
   handleSave:function(component,event,helper) {      
          
      var manualinput_page = component.get("v.manualinput_page") || 1;
      var systemdata_page = component.get("v.systemdata_page") || 1;
      var step = component.get("v.step");    
      var checkvalues_manual = component.find("checkproj");
      var checkvalues_system = component.find("checkprojsystem");
      var manual_array = component.get('v.manualproj_checkarray'); 
      var system_array = component.get('v.systemproj_checkarray'); 
      

      if(typeof system_array != 'undefined' && typeof checkvalues_system != 'undefined' && system_array.length == 0) {
         for(var j = 0 ; j <checkvalues_system.length ; j++) {      
            system_array.push(checkvalues_system[j].get("v.text")+':'+checkvalues_system[j].get("v.value"));
          }
         component.set('v.systemproj_checkarray',system_array);     
      }
      else if(typeof system_array != 'undefined' && typeof checkvalues_system != 'undefined')  {            
         for(var j = 0 ; j <checkvalues_system.length ; j++)  {
            var isFound = false; 
            for(var i = 0; i < system_array.length ;i++) {
               var split = system_array[i].split(':');
               if(split[0] ==checkvalues_system[j].get("v.text")) {                       
                    isFound = true;
                    system_array[i] = split[0]+':'+checkvalues_system[j].get("v.value");
                     break;
                }    
             }
            if(!isFound) system_array.push(checkvalues_system[j].get("v.text")+':'+checkvalues_system[j].get("v.value"));
         }              
      }

      if(typeof manual_array != 'undefined' && typeof checkvalues_manual != 'undefined' && manual_array.length == 0) {
        for(var j = 0 ; j <checkvalues_manual.length ; j++) {      
           manual_array.push(checkvalues_manual[j].get("v.text")+':'+checkvalues_manual[j].get("v.value"));
        }
        component.set('v.manualproj_checkarray',manual_array);      
      }
      else if(typeof manual_array !='undefined' && typeof checkvalues_manual != 'undefined')  {            
        for(var j = 0 ; j <checkvalues_manual.length ; j++)  {
           var isFound = false; 
           for(var i = 0; i < manual_array.length ;i++) {
               var split = manual_array[i].split(':');
               if(split[0] ==checkvalues_manual[j].get("v.text")) {  
                  isFound = true;
                  manual_array[i] = split[0]+':'+checkvalues_manual[j].get("v.value");
                  break;
               }    
           }
           if(!isFound) manual_array.push(checkvalues_manual[j].get("v.text")+':'+checkvalues_manual[j].get("v.value"));
        }              
      }

      if(system_array.length > 0) helper.updateProjections(component,system_array);
      if(manual_array.length > 0) helper.updateProjections(component,manual_array);
       helper.getprojections(component,manualinput_page,systemdata_page,10,step,true);
   
   },
   editProjection:function(component,event,helper) {     
     var selRecord = event.getSource().get("v.value") ;      
     component.set("v.selectedprojection.Id",selRecord.Id); 
     component.set("v.selectedprojection.Brand_Name__c",selRecord.Brand_Name);
     component.set("v.selectedprojection.Projection_Type__c",selRecord.Projection_Type);
     component.set("v.selectedprojection.Manual_Projected_Date__c",selRecord.Projected_Date);
     component.set("v.selectedprojection.Brand_Code__c",selRecord.Brand_Code);
     component.set("v.selectedprojection.Description__c",selRecord.Description);
     component.set("v.selectedprojection.SKU_Text__c",selRecord.SKU_Text);   
     component.find("editProjectionmodal").open(); 
   },
   closeProjectionModal:function(component,event,helper) {    
      helper.closeProjectionModal(component);
   },
   handleDelete:function(component,event,helper) {   
      var projectionId = event.getSource().get("v.value");
      var step = component.get("v.step");      
      var manualinput_page = component.get("v.manualinput_page") || 1;
      var systemdata_page = component.get("v.systemdata_page") || 1;    
      helper.deleteProjection(component,projectionId);
      helper.getprojections(component,manualinput_page,systemdata_page,10,step);
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
   pageDirection: function(component, event, helper) {
       var btnId = event.currentTarget.id;
       var page,data;       

       if(btnId.includes('btng11')) {          
            data = component.get('v.systemprojections_data');            
            page = component.get("v.systemdata_page");
       }
        else {          
            data = component.get('v.manualprojections_data');          
            page = component.get("v.manualinput_page");
        }
          
        var recordToDisply = '10';       
       	var direction = event.currentTarget.dataset.dir;
        page=page*1;
        page = direction === "previous" ? (page - 1) : (page + 1);  
        helper.paginate(component,btnId,page,data,recordToDisply);
       
    },
      pageNum : function(component, event, helper) {
        
        var recordToDisply = '10';	//component.find("recordSize").get("v.value"); 
        var page = event.currentTarget.dataset.index;   
        var btnId = event.currentTarget.id;
        var data;
        var recordToDisply = '10';
        
        if(btnId.includes('btng11')) 
           data = component.get('v.systemprojections_data');          
        else   
           data = component.get('v.manualprojections_data');      
        helper.paginate(component,btnId,page,data,recordToDisply);  
        
    },
    display : function(component, event, helper) {  
    // helper.toggleHelper(component, event);
     //debugger;
     // alert(event.currentTarget.dataset.index);
      $A.util.removeClass(component.find("tooltip_comments"+event.currentTarget.dataset.index),"toggleoff cProjectionReconcileComponent");
      $A.util.addClass(component.find("tooltip_comments"+event.currentTarget.dataset.index),"toggleon cProjectionReconcileComponent");
  },

  displayOut : function(component, event, helper) {
    
  // helper.toggleHelper(component, event);
   //debugger;
   // alert(event.currentTarget.dataset.index);
     $A.util.removeClass(component.find("tooltip_comments"+event.currentTarget.dataset.index),"toggleon cProjectionReconcileComponent");
     $A.util.addClass(component.find("tooltip_comments"+event.currentTarget.dataset.index),"toggleoff cProjectionReconcileComponent");
  
  },
   handleMouseEnter : function(component, event, helper) {
        var popover = component.find("tooltip");
        $A.util.removeClass(popover,'slds-hide');
    } 
})