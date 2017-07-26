({
	    getDetailedSKUs : function(component) {
        var helper = this;
        var action = component.get("c.getDetailedSKUs");
        action.setParams({
                            "Cat":component.get("v.strCat"),
                            "intf":component.get("v.strIntf"),
            				"prjType":component.get("v.prjType")
                        });
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.lstSKU", actionResult.getReturnValue());
        });  
        $A.enqueueAction(action);
	},
})