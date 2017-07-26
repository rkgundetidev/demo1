({
    filterChange : function(component, event,category,lCycle,brand,Stype) {
        
        var action1 = component.get("c.fetchClcycle"); 
        action1.setParams({ "category":category });
        
        action1.setCallback(this, function(a) { 
            var stateData = a.getState();
            
            if(stateData == "SUCCESS"){
                var result1 = a.getReturnValue();
                console.log('result1 ---->' + JSON.stringify(result1));
                
                component.set("v.categorylcycle", result1);}
            
        });        
        $A.enqueueAction(action1);
        
        var actionpro = component.get("c.fetchCPtype"); 
        actionpro.setParams({ "category":category , "lifecycle":lCycle , "brand":brand , "Stype":Stype });
        
        actionpro.setCallback(this, function(aa) { 
            var stateData1 = aa.getState();
            
            if(stateData1 == "SUCCESS"){
                var result2 = aa.getReturnValue();
                console.log('result2 ---->' + JSON.stringify(result2));
                // set the component attributes value with wrapper class properties. 
                //alert(result2);   		
                component.set("v.categoryPtype", result2);}
            
        });
        // enqueue the actionpro 
        $A.enqueueAction(actionpro);
        
    },
    
    
    
})