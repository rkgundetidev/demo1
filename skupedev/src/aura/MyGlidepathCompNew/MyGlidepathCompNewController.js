({
	init : function(component, event, helper) {
		
		var today = new Date();
        var startday = new Date();
        startday.setMonth(startday.getMonth() - 12);
        today.setMonth(today.getMonth() - 1);
        
        //alert('MyGlidePath=@@='+component.get("v.rangeStart")+'==='+component.get("v.rangeEnd"));
        component.set('v.rangeStart', (component.get("v.rangeStart")||startday.getFullYear() + "-" + (startday.getMonth() + 1) + "-" + startday.getDate()));
        component.set('v.rangeEnd', (component.get("v.rangeEnd")||today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate()));
        
        var sDate = startday.getFullYear() + "-" + (startday.getMonth() + 1) + "-" + startday.getDate();
        var eDate = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
        //alert('MyGlidePath=='+component.get("v.rangeStart")+'==='+component.get("v.rangeEnd"));
        var arr1 = [];
		arr1.push('Aircare');

		var arr2 = [];
		arr2.push('AP');
		
		var arr3 = [];
		arr3.push('AllAirCare');
		
		/*var strType = [];
	        
        strType.push('Customized');
        strType.push('Non-customized');*/
	        
        if (!$A.util.isEmpty(component.get("v.rangeStart")) && !$A.util.isUndefined(component.get("v.rangeStart")) &&
        	!$A.util.isEmpty(component.get("v.rangeEnd")) && !$A.util.isUndefined(component.get("v.rangeEnd")))
        {
        	
        	//component.set('v.compDisplay',true);
        	
        	/*alert('hi');
        	var container = component.find("filterContainer");
			if (!$A.util.isEmpty(container) && !$A.util.isUndefined(container))
	        {
				
		    	$A.createComponent("c:FilterComp1",
					{
						"firstComp":true,
						"secondComp":false,
						"thirdComp":false; 
						"forthComp":false, 
						"fifthComp":false,
						"aircareBox":true,
						"dishcareBox":false, 
						"surfacecareBox": false,
						"allAirCareBox":true, 
						"aDWBox": false,
						"hDWBox":false,
						"mrCleanBox":false,
						"swifferBox":false,
						"customisedBox":true,
						"nonCustomisedBox":true,
						"rangeStart":sDate, 
						"rangeEnd":eDate,
						"term": arr1,
						"lCycle":arr2,
						"brand":arr3,
						"strType":strType

					},
				function(comp){
					container.set("v.body",[comp]); 
					//$A.get("e.c:renderdynamicvals").fire();
					//helper.hideSpinner(cmp);
				});
				
				
			}*/
			
		        	 
		        	
        	
        }
	},
    setAttributeValue: function(component, event, helper)
    {
        //var eventValue= event.getParam("attributeValue");
        //component.set("v.B", eventValue);
        var filt = event.getParam("filters");
		var lCyc = event.getParam("lCycle");
		var strType = event.getParam("strType");
		var strbrand = event.getParam("brand");
		var rangeStart = event.getParam("rangeStart");
		var rangeEnd = event.getParam("rangeEnd");
		component.set('v.compDisplay',true);
		//alert('MyGlidePath='+filt+' = '+lCyc+' = '+strbrand+' = '+rangeStart+' = '+rangeEnd +' = '+strType);
		var container = component.find("lineChartContainer");
		if (!$A.util.isEmpty(container) && !$A.util.isUndefined(container))
        {
	    	$A.createComponent("c:LineChartComp1",
				{
					"category": filt,
					"lCycle": lCyc,
					"brand" : strbrand,
					"rangeStart" : rangeStart,
					"rangeEnd" :rangeEnd,
					"strType" : strType
				},
			function(comp){
				container.set("v.body",[comp]); 
				//$A.get("e.c:renderdynamicvals").fire();
				//helper.hideSpinner(cmp);
			});
		}
    }
})