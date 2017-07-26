({
    fetchAccordionData : function(component, event,category,lCycle,brand,Stype,strGBU) {
    	
    	component.set("v.Spinner", true);
    	var action = component.get("c.Allskus"); 
        action.setParams({ "category":category , "lifecycle":lCycle , "brand":brand , "Stype":Stype , "userGBU":strGBU });
        
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
	        component.set("v.Spinner", false);        
        });        
        $A.enqueueAction(action);				
    },
    
    fetchTablesData : function(component, event,category,lCycle,brand,Stype,strGBU) {
    	component.set("v.Spinner", true);
        var fetchTableAction = component.get("c.fetchTableData"); 
        fetchTableAction.setParams({ "category":category , "lifecycle":lCycle , "brand":brand , "Stype":Stype  , "userGBU":strGBU});
        
        fetchTableAction.setCallback(this, function(a) { 
            var stateData = a.getState();
            if(stateData == "SUCCESS"){
                var TableResult = a.getReturnValue();
                console.log('TableResult ---->' + JSON.stringify(TableResult));
                
                var Table1data =TableResult['Table1data'];
	            if(Table1data.length > 0){
	            	component.set("v.categorylcycle", Table1data);            	
	            }
	            
	            var Table2data =TableResult['Table2data'];
	            if(Table2data.length > 0){
	            	component.set("v.categoryPtype", Table2data);            	 
	            }
	            var AccData =TableResult['AccData'];
				if(AccData.length > 0){
				component.set("v.newSKUcount" , JSON.stringify(AccData[0].actuals));
				component.set("v.discSKUcount" , JSON.stringify(AccData[1].actuals));
				component.set("v.incorrectNewSKUcount" , JSON.stringify(AccData[2].actuals));
				component.set("v.incorrectDiscSKUcount" , JSON.stringify(AccData[3].actuals));
				component.set("v.noChangeSKUcount" , JSON.stringify(AccData[4].actuals));
				}
				
	        component.set("v.Spinner", false);
            }            
            
        });        
        $A.enqueueAction(fetchTableAction);
    },
    
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
        $A.enqueueAction(action);
        
        //Loads Table data  ------
        component.set("v.Spinner", true);
        var fetchTableAction = component.get("c.fetchTableData"); 
        fetchTableAction.setParams({ "category":category , "lifecycle":lCycle , "brand":brand , "Stype":Stype });
        
        fetchTableAction.setCallback(this, function(a) { 
            var stateData = a.getState();
            // Call Controller to Load Accordion data
            //$A.enqueueAction(action);
            //--------
            if(stateData == "SUCCESS"){
                var TableResult = a.getReturnValue();
                console.log('TableResult ---->' + JSON.stringify(TableResult));
                
                var Table1data =TableResult['Table1data'];
	            if(Table1data.length > 0){
	            	component.set("v.categorylcycle", Table1data);            	
	            }
	            
	            var Table2data =TableResult['Table2data'];
	            if(Table2data.length > 0){
	            	component.set("v.categoryPtype", Table2data);            	 
	            }	        
            }            
            component.set("v.Spinner", false);
        });        
        $A.enqueueAction(fetchTableAction);
        //Loads Table data End ------
        
/*       
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
*/
    },
    

    
})