({
	filterChange : function(component, event,category,lCycle,brand,Stype) {
        
        var action = component.get("c.Allskus"); 
        action.setParams({ "category":category , "lifecycle":lCycle , "brand":brand , "Stype":Stype });
        
        action.setCallback(this, function(a) { 
            var stateData = a.getState();
            
            if(stateData == "SUCCESS"){
                
            var result=new Map();
            result = a.getReturnValue();
            console.log('result ---->' + JSON.stringify(result));
            
            var newskus =result['newskus'];
            if(newskus.length > 0){
                component.set("v.newSKUs", newskus);           
                component.set("v.newSKUcount" , JSON.stringify(newskus[0].lstCnt));
            }
            
            var discskus =result['discskus'];
            if(discskus.length > 0){
                component.set("v.discSKUs", discskus);
                component.set("v.discSKUcount" , JSON.stringify(discskus[0].lstCnt));
            }

            var incorrectNewskus =result['incorrectNewskus'];     
            if(incorrectNewskus.length > 0){
                component.set("v.incorrectNewSKUs", incorrectNewskus);
                component.set("v.incorrectNewSKUcount" , JSON.stringify(incorrectNewskus[0].lstCnt));
            }

            
            var incorrectDiscoskus =result['incorrectDiscoskus'];           
            if(incorrectDiscoskus.length > 0){
                component.set("v.incorrectDiscSKUs", incorrectDiscoskus);
                component.set("v.incorrectDiscSKUcount" , JSON.stringify(incorrectDiscoskus[0].lstCnt));
            }
           
          	var nochangeskus =result['nochangeskus'];
            if(nochangeskus.length > 0){
            	component.set("v.noChangeSKUs", nochangeskus);
            	component.set("v.noChangeSKUcount" , JSON.stringify(nochangeskus[0].lstCnt));  
            }
            }            
        });
        // enqueue the action 
        $A.enqueueAction(action);
        
    },
})