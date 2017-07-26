({
    doInit: function(component, event, helper) {
        /*
        var action = component.get("c.Allskus");              
        action.setCallback(this, function(a) {
            
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
        });
        // enqueue the action 
        $A.enqueueAction(action); 
        
                
        var action1 = component.get("c.fetchClcycle");      
        
        action1.setCallback(this, function(a) {         
            var result1 = a.getReturnValue();
            console.log('result1 ---->' + JSON.stringify(result1));            	
            component.set("v.categorylcycle", result1);
            
        });
        
        $A.enqueueAction(action1);
        
        var action2 = component.get("c.fetchCPtype"); 
        action2.setCallback(this, function(a) {         
            var result2 = a.getReturnValue();
            console.log('result2 ---->' + JSON.stringify(result2));                		
            component.set("v.categoryPtype", result2);
            //$A.enqueueAction(action1);
        });       
        $A.enqueueAction(action2);
        */
        
        var category = component.get("v.category");
        var lCycle = component.get("v.lCycle");
        var brand = component.get("v.brand");
		var Stype = component.get("v.strType");
		var strGBU = component.get("v.strGBU");
								
        
        //alert(category);   
        var category1=[];var lCycle1=[]; var brand1=[]; var Stype1=[];      		
               
        for(var i=0;i<category.length;i++)
        {category1[i]=component.get("v.filterLabel")[category[i]];}
            
        for(var i=0;i<lCycle.length;i++)
        {lCycle1[i]=component.get("v.filterLabel")[lCycle[i]];}
        
        for(var i=0;i<brand.length;i++)
        {brand1[i]=component.get("v.filterLabel")[brand[i]];}
        
        for(var i=0;i<Stype.length;i++)
        {Stype1[i]=component.get("v.filterLabel")[Stype[i]];}
        
        //alert("selected Category=="+category+"\nselected lCycle=="+lCycle+"\nselected brand=="+brand);
        
        helper.fetchTablesData(component, event, category1, lCycle1, brand1,Stype1,strGBU);

        component.set("v.category", category1);
        component.set("v.lCycle", lCycle1);
        component.set("v.brand", brand1);
        component.set("v.strType", Stype1);
        component.set("v.strGBU", strGBU);                
    },
        
    handleAccordionEvent : function(component, event, helper) {
    	
    	var category = component.get("v.category");
        var lCycle = component.get("v.lCycle");
        var brand = component.get("v.brand");
		var Stype = component.get("v.strType");
		var strGBU = component.get("v.strGBU");
		
    	var NthTime = component.get("v.CollapseHitting");
    	if(NthTime == 0){
        helper.fetchAccordionData(component, event, category, lCycle, brand , Stype , strGBU);
        NthTime +=1;
        component.set("v.CollapseHitting",NthTime);
        }
    },
    
    handleFilterEvent : function(component, event, helper) {
    	
		/*var category = event.getParam("filters");
        var lCycle = event.getParam("lCycle");
        var brand = event.getParam("brand");
        var Stype = event.getParam("strType");   */ 
        
        var category = component.get("v.category");
        var lCycle = component.get("v.lCycle");
        var brand = component.get("v.brand")
		var Stype = component.get("v.strType")
								
        
        //alert(category);   
        var category1=[];var lCycle1=[]; var brand1=[]; var Stype1=[];      		
               
        for(var i=0;i<category.length;i++)
        {category1[i]=component.get("v.filterLabel")[category[i]];}
            
        for(var i=0;i<lCycle.length;i++)
        {lCycle1[i]=component.get("v.filterLabel")[lCycle[i]];}
        
        for(var i=0;i<brand.length;i++)
        {brand1[i]=component.get("v.filterLabel")[brand[i]];}
        
        for(var i=0;i<Stype.length;i++)
        {Stype1[i]=component.get("v.filterLabel")[Stype[i]];}
        
        alert("selected Category=="+category+"\nselected lCycle=="+lCycle+"\nselected brand=="+brand);
        
        helper.filterChange(component, event, category1, lCycle1, brand1,Stype1);
    },    
    
    //<!--spinner start- -->
    showSpinner: function(component, event, helper) {       
        component.set("v.Spinner", true); 
    },
    
    hideSpinner : function(component,event,helper){       
        component.set("v.Spinner", false);
    },
    //<!--spinner end- -->
})