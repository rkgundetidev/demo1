({    
    handleEvent : function(component, event, helper) {
      	var page = 1;         
        var recordToDisply = '10';       
        helper.pageskus(component, page, recordToDisply);
    },

    PageDirection: function(component, event, helper) {
    	var page = component.get("v.page");
        var recordToDisply = '10';
       // var direction = event.getSource().get("v.value");
       	var direction = event.currentTarget.dataset.dir;
        page=page*1;
        page = direction === "previous" ? (page - 1) : (page + 1);        
    	helper.pageskus(component, page, recordToDisply);
    },

    pageNum : function(component, event, helper) {
        
        var recordToDisply = '10';	//component.find("recordSize").get("v.value"); 
        var page = event.currentTarget.dataset.index;
        helper.pageskus(component, page, recordToDisply); 
        
    },
    
    deleteRec : function(component, event, helper) {
        
        var idx= event.currentTarget.dataset.index;
        var recordID= event.currentTarget.dataset.recid;
        var skus= component.get("v.SKUdata");
        var allskus= component.get("v.SKU");
        var delSku=skus[idx];
        skus.splice(idx,1);        
        allskus.pop(delSku);
        //Call Controller to Delete record ---------------//
      /*  var action = component.get("c.deleteRec"); 
        action.setParams({ "RecordId":recordID });
        
        action.setCallback(this, function(a) { 
            var stateData = a.getState();
            
            if(stateData == "SUCCESS"){
        
         }            
        });
        // enqueue the action 
        $A.enqueueAction(action);
*/
        
        component.set("v.SKUdata",skus);
        component.set("v.SKU",allskus);
        alert('Record deleted');
        var total=component.get("v.total", total);
        total=total-1;
        component.set("v.total", total);
        
        
        
        //alert(skus.length);
    }
})