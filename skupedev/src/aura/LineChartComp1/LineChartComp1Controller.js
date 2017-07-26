({
	afterScriptsLoaded: function(component, event, helper)
	{
		/*var arr1 = [];
		arr1.push('Aircare');
		//arr1.push('Dishcare');
		//arr1.push('Surfacecare');

		var arr2 = [];
		arr2.push('AP');
		//arr2.push('RH');
		
		var arr3 = [];
		arr3.push('AllAirCare');
		//arr3.push('ADW');
		//arr3.push('HDW');
		//arr3.push('MrClean');
		//arr3.push('Swiffer');
		
		var filt = event.getParam("filters");
		var lCyc = event.getParam("lCycle");
		var strEvtType = event.getParam("strType");
        alert('linechartcomp1=='+strEvtType+'=='+filt+'=='+lCyc);
        
        var strType = [];
        
        strType.push('Customized');
        strType.push('Non-customized');
        
		var today = new Date();
        var startday = new Date();
        startday.setMonth(startday.getMonth() - 12);
        today.setMonth(today.getMonth() - 1);*/

		//alert('afterscr=='+component.get("v.category")+' == '+ component.get("v.lCycle")+' == '+ component.get("v.brand") +' == '+ component.get("v.rangeStart")+' == '+ component.get("v.rangeEnd")+' == '+ component.get("v.strType"));
		
		//alert('afterScriptsLoaded==='+filt+'==lCyc=='+lCyc+'startday=='+startday+'==today=='+today);
		//helper.getTableData1(component,arr1,arr2,arr3,startday,today,strType);
		helper.getTableData1(component, component.get("v.category"), component.get("v.lCycle"), component.get("v.brand"), component.get("v.rangeStart"),
								component.get("v.rangeEnd"), component.get("v.strType"), component.get("v.strGBU"));
        
	},
    fetchRecords123 : function(component, event, helper) {
    
    	setTimeout($A.getCallback(()=>{
			if(!component.isValid())
				return;
	    	
			document.getElementById("Accspinner1").style.display = "block";
			
			var filt = event.getParam("filters");
			var lCyc = event.getParam("lCycle");
			var strEvtType = event.getParam("strType");
	        alert('fetchRecords123=='+strEvtType);
        
			/*
			var filters = event.getParam("filters");
			var lCycle = event.getParam("lCycle");
			var brand = event.getParam("brand");
			
			var stDate = event.getParam("rangeStart");
	        var endDate = event.getParam("rangeEnd");
	        var strType = event.getParam("strType");
	        
	        var arr1 = [];
			arr1.push('Aircare');
			//arr1.push('Dishcare');
			//arr1.push('Surfacecare');
	
			var arr2 = [];
			arr2.push('AP');
			//arr2.push('RH');
			
			var arr3 = [];
			arr3.push('AllAirCare');
			//arr3.push('ADW');
			//arr3.push('HDW');
			//arr3.push('MrClean');
			//arr3.push('Swiffer');
			
			var filt = event.getParam("filters");
			var lCyc = event.getParam("lCycle");
			//var strType = event.getParam("strType");
	        //alert(strType);
	        
	        var strType = [];
	        
	        strType.push('Customized');
	        strType.push('Non-customized');
	        
			var today = new Date();
	        var startday = new Date();
	        startday.setMonth(startday.getMonth() - 12);
	        today.setMonth(today.getMonth() - 1);
			
			
			alert('filters=LineChartComponent=298='+filters+' = '+lCycle+' = '+brand+' = '+stDate+' = '+endDate +' = '+strType);
			
			if (!$A.util.isEmpty(filters) && !$A.util.isUndefined(filters))
			{
				helper.getTableData1(component,filters,lCycle,brand,stDate,endDate, strType);
			}else
			{
				helper.getTableData1(component,arr1,arr2,arr3,startday,today,strType);
			}
			*/
			//alert('filters=LineChartComponent=105==='+component.get("v.category")+' == '+ component.get("v.lCycle")+' == '+ component.get("v.brand") +' == '+ component.get("v.rangeStart")+' == '+ component.get("v.rangeEnd")+' == '+ component.get("v.strType"));
		
			helper.getTableData1(component, component.get("v.category"), component.get("v.lCycle"), component.get("v.brand"), component.get("v.rangeStart"),
								component.get("v.rangeEnd"), component.get("v.strType"), component.get("v.strGBU"));
								
		}),500);
     },
     showOppmodal: function(component, event, helper) {
		
		helper.toggleClass(component,'backdrop','slds-backdrop--');
		helper.toggleClass(component,'modaldialog','slds-fade-in-');
		
		
		var category = event.currentTarget.dataset.catagory;
		var status = event.currentTarget.dataset.status;
		var group = event.currentTarget.dataset.group;
		var mnth = event.currentTarget.dataset.mnth;
		var type = event.currentTarget.dataset.lifecycle;
		//alert(category+'==='+status+'==='+group+'==='+mnth);
		if(status == 'A & P')
		{
			status = 'ACTIVE & PLANNED';
		}

		if(status == 'R & H')
		{
			status = 'REMNANT & HISTORICAL';
		}

		document.getElementById("CATEGORY").innerHTML = category;
		//document.getElementById("GROUP").innerHTML = group;
		document.getElementById("MONTH").innerHTML = mnth;

		//document.getElementById("STATUS").innerHTML = status;
		document.getElementById("lifecycle").innerHTML = type;
		
		//helper.getSKUData(component);
		var arr3 = [];
		arr3.push('AllAirCare');
		arr3.push('ADW');
		arr3.push('HDW');
		arr3.push('MrClean');
		arr3.push('Swiffer');
		
		//alert(component.get("v.brand"));
		
        		 
		var brandArr = component.get("v.brand");
		
		if (!$A.util.isEmpty(brandArr) && !$A.util.isUndefined(brandArr))
		{
			arr3 = [];
        			 
			for(var i=0; i< brandArr.length; i++)
			{
				arr3.push(brandArr[i]);
			}
		}
		
		//alert(arr3);
		helper.getSKUDynamicData(component,arr3,status,group);
		//helper.getSKUDynamicData(component,arr3,status,group);
		//document.getElementById("Accspinner").style.display = "none";
		
		
	},

	hideModal : function(component, event, helper) {
		 //Toggle CSS styles for hiding Modal
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
		
	},

	exportFile: function(cmp,evt,helper){
		helper.exportToExcelAll(cmp);
	}
})