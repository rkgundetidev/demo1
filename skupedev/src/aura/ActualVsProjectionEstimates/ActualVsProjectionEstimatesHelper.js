({
    getEstimateActualSKUCount : function(component) {
        var helper = this;
        var action = component.get("c.getEstimateActualSKUCnt");
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.lstWrapper", actionResult.getReturnValue());
        });  
        $A.enqueueAction(action);
	},
    
    getProjEstimateActualSKUCount : function(component) {
        var helper = this;
        var action = component.get("c.getProjTypeEstimateActualSKUCount");
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.lstProjWrapper", actionResult.getReturnValue());
        });  
        $A.enqueueAction(action);
	},
    
    getSKUDetails : function(cmp,category,strInterface){
        /*alert(strInterface+'==='+category);
        var evt = $A.get("e.c:Navigate");
        evt.setParams({ "strIntf":strInterface,
				"Category": category});
        evt.fire();*/
        var modal = cmp.find("modalbody");
        $A.createComponent(
			"c:DisplaySKUs",
			{
				"strIntf":strInterface,
				"Category": category
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
    },
    getSKUDetailedInfo : function(cmp,evt,strInterface){
        var ctgry = evt.getSource().get("v.class");
        var pType = evt.getSource().get("v.title");
        var modal = cmp.find("modalbody");
        $A.createComponent(
			"c:DisplayDetailedSKUs",
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