({
    getCount : function(component) {
        var helper = this;
        var action = component.get("c.getEstimateAndActualSKUCount");
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.lstWrapper", actionResult.getReturnValue());
        });        
        $A.enqueueAction(action);
	},
    
    getSKUDetailsInfo : function(cmp,evt,strInterface){
        var ctgry = evt.getSource().get("v.class");
        var pType = evt.getSource().get("v.title");
        var modal = cmp.find("modalbody");
        $A.createComponent(
			"c:DisplaySLAStatusForSKUs",
			{
                "strCat": ctgry,
				"strIntf": strInterface,
				"prjType": pType
			},
			function(popup,status,errMessage){
				if(status=='SUCCESS'){
					var body = modal.get("v.body");
					body.push(popup);
					modal.set("v.body",popup);
					$A.util.removeClass(cmp.find("thecontainer"),"hidden");
				}
			}
		)
        
    }
})