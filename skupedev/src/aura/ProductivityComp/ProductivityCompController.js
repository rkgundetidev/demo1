({
	afterScriptsLoaded: function(component, event, helper)
	{
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
		
		var today = new Date();
        var startday = new Date();
        startday.setMonth(startday.getMonth() - 11);
        
        component.set("v.rangeEnd1", startday);
        component.set("v.rangeStart1", today);
        
		helper.getTableData1(component,arr1,arr2,arr3,startday,today);
        
	},
    fetchRecords : function(component, event, helper) {
        
    	
		document.getElementById("Accspinner1").style.display = "block";
		var filters = event.getParam("filters");
		var lCycle = event.getParam("lCycle");
		var brand = event.getParam("brand");
		
		var stDate = event.getParam("rangeStart");
        var endDate = event.getParam("rangeEnd");
        
        component.set("v.term1", filters);
        component.set("v.lCycle1", lCycle);
        component.set("v.brand1", brand);
        component.set("v.rangeEnd1", stDate);
        component.set("v.rangeStart1", endDate);
        
		helper.getTableData1(component,filters,lCycle,brand,stDate,endDate);
    },
     
    tabOneAction: function(component, event, helper) {
        var tab1 = component.find('t1');
        var showTab1 = component.find('tab1');

        var tab2 = component.find('t2');
        var showTab2 = component.find('tab2');

        $A.util.addClass(tab1, 'slds-active');
        $A.util.addClass(showTab1, 'slds-show');
        $A.util.removeClass(showTab1, 'slds-hide');


        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(showTab2, 'slds-show');
        $A.util.addClass(showTab2, 'slds-hide');

        component.set("v.firstComp", true);
        component.set("v.secondComp", false);
        
        //document.getElementById("Accspinner1").style.display = "block";
        
        /*component.set("v.term1", filters);
        component.set("v.lCycle1", lCycle);
        component.set("v.brand1", brand);
        component.set("v.rangeEnd1", stDate);
        component.set("v.rangeStart1", endDate);*/
        
		var filters = component.get("v.term1");
		var lCycle = component.get("v.lCycle1");
		var brand = component.get("v.brand1");
		
		var stDate = component.get("v.rangeEnd1");
        var endDate = component.get("v.rangeStart1");
        
		helper.getTableData1(component,filters,lCycle,brand,stDate,endDate);

    },
    tabTwoAction: function(component, event, helper) {

        var tab1 = component.find('t1');
        var showTab1 = component.find('tab1');

        var tab2 = component.find('t2');
        var showTab2 = component.find('tab2');

        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(showTab1, 'slds-show');
        $A.util.addClass(showTab1, 'slds-hide');

        $A.util.addClass(tab2, 'slds-active');
        $A.util.removeClass(showTab2, 'slds-hide');
        $A.util.addClass(showTab2, 'slds-show');

        component.set("v.firstComp", false);
        component.set("v.secondComp", true);
        
        //document.getElementById("Accspinner1").style.display = "block";
		var filters = component.get("v.term1");
		var lCycle = component.get("v.lCycle1");
		var brand = component.get("v.brand1");
		
		var stDate = component.get("v.rangeEnd1");
        var endDate = component.get("v.rangeStart1");
        
		helper.getTableData1(component,filters,lCycle,brand,stDate,endDate);

    }
})