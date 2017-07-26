({
    ToggleCollapseHandler : function(component, event) {  
        var existingText = component.get("v.collpase"); 
        var container = component.find("containerCollapsable") ;
        
        if(existingText === false){
            component.set("v.collpase",true);
            $A.util.addClass(container, 'hide');
        }else{
            component.set("v.collpase",false);
            $A.util.removeClass(container, 'hide'); 
        }  
    }
})