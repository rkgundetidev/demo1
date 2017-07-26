({
    ToggleCollapse : function(component, event, helper) {
        
		helper.ToggleCollapseHandler(component, event);
        
        var appEvent = $A.get("e.c:SkuAccordionevent");        
        appEvent.fire();
    },
    collpaseAll : function(component, event, helper) { 
        var container = component.find("containerCollapsable") ;
        $A.util.addClass(container, 'hide');
        component.set("v.collpase",true);
    }    
})