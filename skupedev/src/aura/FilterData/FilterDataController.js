({
    doInit : function(component, event, helper) {
        
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
    },
    
    handleFilterEvent : function(component, event, helper) {
		var category = event.getParam("filters");
        var lCycle = event.getParam("lCycle");
        var brand = event.getParam("brand");
        var Stype = event.getParam("strType");
        var category1=[];var lCycle1=[]; var brand1=[]; var Stype1=[];          		
               
        for(var i=0;i<category.length;i++)
        {category1[i]=component.get("v.filterLabel")[category[i]];}
            
        for(var i=0;i<lCycle.length;i++)
        {lCycle1[i]=component.get("v.filterLabel")[lCycle[i]];}
        
        for(var i=0;i<brand.length;i++)
        {brand1[i]=component.get("v.filterLabel")[brand[i]];}
        for(var i=0;i<Stype.length;i++)
        {Stype1[i]=component.get("v.filterLabel")[Stype[i]];}
        
       // alert("selected Category=="+category+"\nselected lCycle=="+lCycle+"\nselected brand=="+brand+"\nselected Sku-type=="+Stype);
        
        helper.filterChange(component, event, category1, lCycle1, brand1,Stype1);
    },
    
})