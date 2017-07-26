({
	handleFilterEvent : function(component, event, helper) {
    	
		var filt = event.getParam("filters");
		var lCyc = event.getParam("lCycle");
		var strType = event.getParam("strType");
		var strbrand = event.getParam("brand");
		var rangeStart = event.getParam("rangeStart");
		var rangeEnd = event.getParam("rangeEnd");
		var strGBU = event.getParam("strGBU");
        
        
        //alert('MyGlidePath='+filt+' = '+lCyc+' = '+strbrand+' = '+rangeStart+' = '+rangeEnd +' = '+strType);
        var container = component.find("projectionsContainer");
		if (!$A.util.isEmpty(container) && !$A.util.isUndefined(container))
        {
	    	$A.createComponent("c:ProjectionsVsActualsComp",
				{
					"category": filt,
					"lCycle": lCyc,
					"brand" : strbrand,
					"rangeStart" : rangeStart,
					"rangeEnd" :rangeEnd,
					"strType" : strType,
					"strGBU" : strGBU
				},
			function(comp){
				container.set("v.body",[comp]); 
				//$A.get("e.c:renderdynamicvals").fire();
				//helper.hideSpinner(cmp);
			});
		}
        
    },
        
})