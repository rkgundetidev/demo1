({
	    getSKUs : function(component) {
        var helper = this;
        var action = component.get("c.getSKUs");
        action.setParams({
                            "Cat":component.get("v.Category"),
                            "intf":component.get("v.strIntf")
                        });
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.lstSKU", actionResult.getReturnValue());
        });  
        $A.enqueueAction(action);
	},
})