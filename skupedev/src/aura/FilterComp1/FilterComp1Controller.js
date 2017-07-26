({
    init: function(component, event, helper) {

        component.set("v.firstComp", true);
        component.set("v.secondComp", false);
        component.set("v.thirdComp", false);
        component.set("v.forthComp", false);
        component.set("v.fifthComp", false);
        
        //alert('Filtercomp1=='+component.get("v.rangeStart")+'==='+component.get("v.rangeEnd"));
        
        var today = new Date();
        var startday = new Date();
        startday.setMonth(startday.getMonth() - 12);
        today.setMonth(today.getMonth() - 1);
        
        component.set('v.rangeStart', (component.get("v.rangeStart")||startday.getFullYear() + "-" + (startday.getMonth() + 1) + "-" + startday.getDate()));
        component.set('v.rangeEnd', (component.get("v.rangeEnd")||today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate()));
        
        /*component.set('v.rangeStart', startday.getFullYear() + "-" + (startday.getMonth() + 1) + "-" + startday.getDate());
        component.set('v.rangeEnd', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());*/
        
    	component.set("v.aircareBox", true);
        component.set("v.dishcareBox", false);
        component.set("v.surfacecareBox", false);
        
        var arr11 = [];
        arr11.push('Aircare');
        //arr1.push('Dishcare');
        //arr1.push('Surfacecare');

        var arr22 = [];
        arr22.push('AP');
        
        var arr33 = [];
        arr33.push('AllAirCare');
        
        component.set("v.term", []);
        component.set("v.lCycle", []);
        component.set("v.brand", []);
        
        component.set("v.term", arr11);
        component.set("v.lCycle", arr22);
        component.set("v.brand", arr33);
        
        var defaultCategory = '';
        var defaultGBU = component.get("v.strGBU");
        
        var action = component.get("c.userSettings");

	    action.setCallback(this, function(response){
	        if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
	        	 var result = response.getReturnValue();
	        	 
	        	 //alert(JSON.stringify(result));
	        	 if(result!=null && result.length>0)
        		 for(var i=0; i< result.length; i++)
        		 {
        			 if (!$A.util.isEmpty(result[i].Category__c) && !$A.util.isUndefined(result[i].Category__c))
        			 {
        				 defaultCategory = result[i].Category__c;
        			 }else
        			 {
        				 defaultCategory = 'Aircare';
        			 }
        			 
        			 if (!$A.util.isEmpty(result[i].GBU__c) && !$A.util.isUndefined(result[i].GBU__c))
        			 {
        				 defaultGBU = result[i].GBU__c;
        			 }else
        			 {
        				 defaultGBU = 'Home Care';
        			 }
        			 
        			 
        		 }
        		 
        		 if(defaultCategory == 'Air Care')
        		 {
        			 component.set("v.aircareBox", true);
        			 component.set("v.dishcareBox", false);
        			 component.set("v.surfacecareBox", false);
        			 
        			 component.set("v.allAirCareBox", true);
        			 component.set("v.aDWBox", false);
        			 component.set("v.hDWBox", false);
        			 component.set("v.mrCleanBox", false);
        			 component.set("v.swifferBox", false);
        			 
        			 arr11 = [];
        			 arr11.push('Aircare');
        			 
        			 arr33 = [];
        			 arr33.push('AllAirCare');
        		 }
        		 else if(defaultCategory == 'Dish Care')
        		 {
        			 component.set("v.aircareBox", false);
        			 component.set("v.dishcareBox", true);
        			 component.set("v.surfacecareBox", false);
        			 
        			 component.set("v.allAirCareBox", false);
        			 component.set("v.aDWBox", true);
        			 component.set("v.hDWBox", true);
        			 component.set("v.mrCleanBox", false);
        			 component.set("v.swifferBox", false);
        			 
        			 arr11 = [];
        			 arr11.push('Dishcare');
        			 
        			 arr33 = [];
        			 arr33.push('ADW');
        			 arr33.push('HDW');
        		 }
        		 else if(defaultCategory == 'Surface Care')
        		 {
        			 component.set("v.aircareBox", false);
        			 component.set("v.dishcareBox", false);
        			 component.set("v.surfacecareBox", true);
        			 
        			 component.set("v.allAirCareBox", false);
        			 component.set("v.aDWBox", false);
        			 component.set("v.hDWBox", false);
        			 component.set("v.mrCleanBox", true);
        			 component.set("v.swifferBox", true);
        			 
        			 arr11 = [];
        			 arr11.push('Surfacecare');
        			 
        			 arr33 = [];
        			 arr33.push('MrClean');
        			 arr33.push('Swiffer');
        		 }
        		 
        		component.set("v.term", arr11);
				component.set("v.lCycle", arr22);
				component.set("v.brand", arr33);
				
				var arr1 = component.get("v.term");
		        var arr2 = component.get("v.lCycle");
		        var arr3 = component.get("v.brand");
		        var stDate = component.get("v.rangeStart");
		        var endDate = component.get("v.rangeEnd");
		        var strTtype = component.get("v.strType");
		        //alert(arr1+'='+arr2+'='+arr3+'='+stDate+'='+endDate+'='+strTtype);
		        /*appEvent = $A.get("e.c:FilterEvent");
		        appEvent.setParams({
		            "filters": arr1,
		            "lCycle": arr2,
		            "brand": arr3,
		            "rangeStart":stDate,
		            "rangeEnd":endDate,
		            "strType" : strTtype
		        });
		        appEvent.fire();*/
		        
		        var setEvent = component.getEvent("FilterAttribute");
		        setEvent.setParams({
		            "filters": arr1,
		            "lCycle": arr2,
		            "brand": arr3,
		            "rangeStart":stDate,
		            "rangeEnd":endDate,
		            "strType" : strTtype,
		            "strGBU" : defaultGBU
		        });
		        setEvent.fire();
	        }
	    });
	    $A.enqueueAction(action);
        
        
        
        
               
        
        
        

    },
    showSpinner: function(component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({
            isVisible: true
        });
        evt.fire();
    },
    hideSpinner: function(component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({
            isVisible: false
        });
        evt.fire();
    },
    doInit: function(component, event, helper) {
        /*
		var pageSize = component.get("v.pageSize");
        var action = component.get("c.getAccounts");
        action.setCallback(this, function(response) 
		{
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") 
            {
                console.log(response.getReturnValue());
                component.set('v.accList', response.getReturnValue());
                
            }
        });
        $A.enqueueAction(action);
		*/
    },
    tabOneAction: function(component, event, helper) {
        var tab1 = component.find('t1');
        var showTab1 = component.find('tab1');

        var tab2 = component.find('t2');
        var showTab2 = component.find('tab2');

        var tab3 = component.find('t3');
        var showTab3 = component.find('tab3');

        var tab4 = component.find('t4');
        var showTab4 = component.find('tab4');

        var tab5 = component.find('t5');
        var showTab5 = component.find('tab5');

        $A.util.addClass(tab1, 'slds-active');
        $A.util.addClass(showTab1, 'slds-show');
        $A.util.removeClass(showTab1, 'slds-hide');


        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(showTab2, 'slds-show');
        $A.util.addClass(showTab2, 'slds-hide');

        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(showTab3, 'slds-show');
        $A.util.addClass(showTab3, 'slds-hide');

        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(showTab4, 'slds-show');
        $A.util.addClass(showTab4, 'slds-hide');

        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(showTab5, 'slds-show');
        $A.util.addClass(showTab5, 'slds-hide');

        component.set("v.firstComp", true);
        component.set("v.secondComp", false);
        component.set("v.thirdComp", false);
        component.set("v.forthComp", false);
        component.set("v.fifthComp", false);
        //helper.loadSobjects(component);

    },
    tabTwoAction: function(component, event, helper) {

        var tab1 = component.find('t1');
        var showTab1 = component.find('tab1');

        var tab2 = component.find('t2');
        var showTab2 = component.find('tab2');

        var tab3 = component.find('t3');
        var showTab3 = component.find('tab3');

        var tab4 = component.find('t4');
        var showTab4 = component.find('tab4');

        var tab5 = component.find('t5');
        var showTab5 = component.find('tab5');



        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(showTab1, 'slds-show');
        $A.util.addClass(showTab1, 'slds-hide');

        $A.util.addClass(tab2, 'slds-active');
        $A.util.removeClass(showTab2, 'slds-hide');
        $A.util.addClass(showTab2, 'slds-show');


        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(showTab3, 'slds-show');
        $A.util.addClass(showTab3, 'slds-hide');

        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(showTab4, 'slds-show');
        $A.util.addClass(showTab4, 'slds-hide');

        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(showTab5, 'slds-show');
        $A.util.addClass(showTab5, 'slds-hide');

        component.set("v.firstComp", false);
        component.set("v.secondComp", true);
        component.set("v.thirdComp", false);
        component.set("v.forthComp", false);
        component.set("v.fifthComp", false);
        //helper.loadSobjects(component);
    },

    tabThreeAction: function(component, event, helper) {
        var tab1 = component.find('t1');
        var showTab1 = component.find('tab1');

        var tab2 = component.find('t2');
        var showTab2 = component.find('tab2');

        var tab3 = component.find('t3');
        var showTab3 = component.find('tab3');

        var tab4 = component.find('t4');
        var showTab4 = component.find('tab4');

        var tab5 = component.find('t5');
        var showTab5 = component.find('tab5');

        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(showTab1, 'slds-show');
        $A.util.addClass(showTab1, 'slds-hide');


        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(showTab2, 'slds-show');
        $A.util.addClass(showTab2, 'slds-hide');


        $A.util.addClass(tab3, 'slds-active');
        $A.util.addClass(showTab3, 'slds-hide');
        $A.util.addClass(showTab3, 'slds-show');

        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(showTab4, 'slds-show');
        $A.util.addClass(showTab4, 'slds-hide');

        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(showTab5, 'slds-show');
        $A.util.addClass(showTab5, 'slds-hide');

        component.set("v.firstComp", false);
        component.set("v.secondComp", false);
        component.set("v.thirdComp", true);
        component.set("v.forthComp", false);
        component.set("v.fifthComp", false);
        //helper.loadSobjects(component);
    },

    tabFourAction: function(component, event, helper) {
        var tab1 = component.find('t1');
        var showTab1 = component.find('tab1');

        var tab2 = component.find('t2');
        var showTab2 = component.find('tab2');

        var tab3 = component.find('t3');
        var showTab3 = component.find('tab3');

        var tab4 = component.find('t4');
        var showTab4 = component.find('tab4');

        var tab5 = component.find('t5');
        var showTab5 = component.find('tab5');

        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(showTab1, 'slds-show');
        $A.util.addClass(showTab1, 'slds-hide');


        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(showTab2, 'slds-show');
        $A.util.addClass(showTab2, 'slds-hide');

        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(showTab3, 'slds-show');
        $A.util.addClass(showTab3, 'slds-hide');

        $A.util.addClass(tab4, 'slds-active');
        $A.util.addClass(showTab4, 'slds-hide');
        $A.util.addClass(showTab4, 'slds-show');

        $A.util.removeClass(tab5, 'slds-active');
        $A.util.removeClass(showTab5, 'slds-show');
        $A.util.addClass(showTab5, 'slds-hide');

        component.set("v.firstComp", false);
        component.set("v.secondComp", false);
        component.set("v.thirdComp", false);
        component.set("v.forthComp", true);
        component.set("v.fifthComp", false);


        /*
        var today = new Date();
        var stDate = component.find('v.startdate');
        if(!$A.util.isEmpty(stDate) && !$A.util.isUndefined(stDate))
        {
        	component.set('v.startdate', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        }
        */
        //component.set('v.enddate', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        //helper.loadSobjects(component);
    },

    tabFiveAction: function(component, event, helper) {
        var tab1 = component.find('t1');
        var showTab1 = component.find('tab1');

        var tab2 = component.find('t2');
        var showTab2 = component.find('tab2');

        var tab3 = component.find('t3');
        var showTab3 = component.find('tab3');

        var tab4 = component.find('t4');
        var showTab4 = component.find('tab4');

        var tab5 = component.find('t5');
        var showTab5 = component.find('tab5');

        $A.util.removeClass(tab1, 'slds-active');
        $A.util.removeClass(showTab1, 'slds-show');
        $A.util.addClass(showTab1, 'slds-hide');


        $A.util.removeClass(tab2, 'slds-active');
        $A.util.removeClass(showTab2, 'slds-show');
        $A.util.addClass(showTab2, 'slds-hide');

        $A.util.removeClass(tab3, 'slds-active');
        $A.util.removeClass(showTab3, 'slds-show');
        $A.util.addClass(showTab3, 'slds-hide');

        $A.util.removeClass(tab4, 'slds-active');
        $A.util.removeClass(showTab4, 'slds-show');
        $A.util.addClass(showTab4, 'slds-hide');

        $A.util.addClass(tab5, 'slds-active');
        $A.util.addClass(showTab5, 'slds-show');
        $A.util.addClass(showTab5, 'slds-hide');

        component.set("v.firstComp", false);
        component.set("v.secondComp", false);
        component.set("v.thirdComp", false);
        component.set("v.forthComp", false);
        component.set("v.fifthComp", true);
        //helper.loadSobjects(component);
    },
    checkboxChange: function(component, event, helper) {
    	
        var cate = event.target.id;
        //var appEvent = $A.get("e.c:FilterEvent");
        var arr1 = component.get("v.term");
        var arr2 = component.get("v.lCycle");
        var arr3 = component.get("v.brand");
        var stDate = component.get("v.rangeStart");
        var endDate = component.get("v.rangeEnd");
        var strTtype = component.get("v.strType");
        
        //alert(event.target.checked+'==='+cate+'===='+arr1+'='+arr2+'='+arr3+'='+stDate+'='+endDate+'='+strTtype);
        alert(cate+'=='+event.target.checked);
        //alert('1==='+arr1);
        /*****************handling  the check boxes******************/
        if (cate == 'Aircare') {
            component.set("v.aircareBox", event.target.checked);
            component.set("v.allAirCareBox", event.target.checked);
        } else if (cate == 'Dishcare') {
        	document.getElementById("Dishcare").checked = "checked";
            component.set("v.dishcareBox", event.target.checked);
            component.set("v.aDWBox", event.target.checked);
            component.set("v.hDWBox", event.target.checked);
        } else if (cate == 'Surfacecare') {
            component.set("v.surfacecareBox", event.target.checked);
            component.set("v.mrCleanBox", event.target.checked);
            component.set("v.swifferBox", event.target.checked);
        }
        if (event.target.checked) {
            if (cate == 'Aircare') {
                arr3.push('AllAirCare');
            }
            if (cate == 'Dishcare') {
                arr3.push('ADW');
                arr3.push('HDW');
            }
            if (cate == 'Surfacecare') {
                arr3.push('MrClean');
                arr3.push('Swiffer');
            }
            arr1.push(cate);
        } else {
            for (var j = 0; j < arr3.length; j++) {
                if (cate == 'Aircare' && (arr3[j] == 'AllAirCare')) {
                    arr3.splice(j, 1);
                } else if (cate == 'Dishcare' && (arr3[j] == 'ADW' || arr3[j] == 'HDW')) {
                    arr3.splice(j, 1);
                    j--;
                } else if (cate == 'Surfacecare' && (arr3[j] == 'MrClean' || arr3[j] == 'Swiffer')) {
                    arr3.splice(j, 1);
                    j--;
                }

            }

            for (var i = 0; i < arr1.length; i++) {
                if (arr1[i] == cate) {
                    arr1.splice(i, 1);
                }
            }
        }
        //set all values
        if (arr1.length == 0) {
            arr1 = ['Aircare', 'Dishcare', 'Surfacecare'];
            arr3 = ['AllAirCare', 'ADW', 'HDW', 'MrClean', 'Swiffer'];
            component.set("v.aircareBox", 'true');
            component.set("v.allAirCareBox", 'true');
            component.set("v.dishcareBox", 'true');
            component.set("v.aDWBox", 'true');
            component.set("v.hDWBox", 'true');
            component.set("v.surfacecareBox", 'true');
            component.set("v.mrCleanBox", 'true');
            component.set("v.swifferBox", 'true');
        }
        //alert(arr1);
        component.set("v.term", arr1);
        component.set("v.brand", arr3);
        //alert(component.get("v.term"));
        /*component.set("v.childAttr", "Child");*/
        
        var setEvent = component.getEvent("FilterAttribute");
        setEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        setEvent.fire();
        
        //alert(arr1+'='+arr2+'='+arr3+'='+stDate+'='+endDate+'='+strTtype);
        /*
        var appEvent = $A.get("e.c:FilterEvent");
        appEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        appEvent.fire();
        */
    },
    uicheckboxChange: function(component, event, helper) {
    	
    	//var checkCmp = component.find("Aircare");
    	//var cate = checkCmp.get("v.name");
    	//alert(cate);
    	//var selected = checkCmp.get("v.value");
    	
    	var cate = event.source.get("v.name");
    	
    	//alert(JSON.stringify(event)+'==='+checkCmp.get("v.value")+'==='+checkCmp.get("v.label")+'==='+checkCmp.get("v.name"));
    	
    	//alert(id+'===='+event.source.get("v.value"));
    	/*if (event.source.get("v.value")) {
    	
    	}*/
     /*},
     getSelected: function(component, event, helper,cate,selected) {
     */
        //var appEvent = $A.get("e.c:FilterEvent");
        var arr1 = component.get("v.term");
        var arr2 = component.get("v.lCycle");
        var arr3 = component.get("v.brand");
        var stDate = component.get("v.rangeStart");
        var endDate = component.get("v.rangeEnd");
        var strTtype = component.get("v.strType");
        
        //alert(event.target.checked+'==='+cate+'===='+arr1+'='+arr2+'='+arr3+'='+stDate+'='+endDate+'='+strTtype);
        //alert(cate+'=='+event.source.get("v.value"));
        //alert('1==='+arr1);
        /*****************handling  the check boxes******************/
        if (cate == 'Aircare') {
            component.set("v.aircareBox", event.source.get("v.value"));
            component.set("v.allAirCareBox", event.source.get("v.value"));
        } else if (cate == 'Dishcare') {
        	
            component.set("v.dishcareBox", event.source.get("v.value"));
            component.set("v.aDWBox", event.source.get("v.value"));
            component.set("v.hDWBox", event.source.get("v.value"));
        } else if (cate == 'Surfacecare') {
            component.set("v.surfacecareBox", event.source.get("v.value"));
            component.set("v.mrCleanBox", event.source.get("v.value"));
            component.set("v.swifferBox", event.source.get("v.value"));
        }
        if (event.source.get("v.value")) {
            if (cate == 'Aircare') {
                arr3.push('AllAirCare');
            }
            if (cate == 'Dishcare') {
                arr3.push('ADW');
                arr3.push('HDW');
            }
            if (cate == 'Surfacecare') {
                arr3.push('MrClean');
                arr3.push('Swiffer');
            }
            arr1.push(cate);
        } else {
            for (var j = 0; j < arr3.length; j++) {
                if (cate == 'Aircare' && (arr3[j] == 'AllAirCare')) {
                    arr3.splice(j, 1);
                } else if (cate == 'Dishcare' && (arr3[j] == 'ADW' || arr3[j] == 'HDW')) {
                    arr3.splice(j, 1);
                    j--;
                } else if (cate == 'Surfacecare' && (arr3[j] == 'MrClean' || arr3[j] == 'Swiffer')) {
                    arr3.splice(j, 1);
                    j--;
                }

            }

            for (var i = 0; i < arr1.length; i++) {
                if (arr1[i] == cate) {
                    arr1.splice(i, 1);
                }
            }
        }
        //set all values
        if (arr1.length == 0) {
            arr1 = ['Aircare', 'Dishcare', 'Surfacecare'];
            arr3 = ['AllAirCare', 'ADW', 'HDW', 'MrClean', 'Swiffer'];
            component.set("v.aircareBox", 'true');
            component.set("v.allAirCareBox", 'true');
            component.set("v.dishcareBox", 'true');
            component.set("v.aDWBox", 'true');
            component.set("v.hDWBox", 'true');
            component.set("v.surfacecareBox", 'true');
            component.set("v.mrCleanBox", 'true');
            component.set("v.swifferBox", 'true');
        }
        //alert(arr1);
        component.set("v.term", arr1);
        component.set("v.brand", arr3);
        //alert(component.get("v.term"));
        /*component.set("v.childAttr", "Child");*/
        
        var setEvent = component.getEvent("FilterAttribute");
        setEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        setEvent.fire();
        
        //alert(arr1+'='+arr2+'='+arr3+'='+stDate+'='+endDate+'='+strTtype);
        /*
        var appEvent = $A.get("e.c:FilterEvent");
        appEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        appEvent.fire();
        */
    },
    brandcheckboxChange: function(component, event, helper) {
        //var brd = event.target.id;
        var brd = event.source.get("v.name");
        //var appEvent = $A.get("e.c:FilterEvent");
        var arr1 = component.get("v.term");
        var arr2 = component.get("v.lCycle");
        var arr3 = component.get("v.brand");
        var stDate = component.get("v.rangeStart");
        var endDate = component.get("v.rangeEnd");
        //Check and Uncheck boxes
        if (brd == 'AllAirCare') {
            //component.set("v.allAirCareBox", event.target.checked);
            component.set("v.allAirCareBox", event.source.get("v.value"));
            
        } else if (brd == 'ADW') {
            //component.set("v.aDWBox", event.target.checked);
            component.set("v.aDWBox", event.source.get("v.value"));
        } else if (brd == 'HDW') {
            //component.set("v.hDWBox", event.target.checked);
            component.set("v.hDWBox", event.source.get("v.value"));
        } else if (brd == 'MrClean') {
            //component.set("v.mrCleanBox", event.target.checked);
            component.set("v.mrCleanBox", event.source.get("v.value"));
        } else if (brd == 'Swiffer') {
            //component.set("v.swifferBox", event.target.checked);
            component.set("v.swifferBox", event.source.get("v.value"));
        }
        //if (event.target.checked) {
        if(event.source.get("v.value")){
            arr3.push(brd);
        } else {
            for (var i = 0; i < arr3.length; i++) {
                if (arr3[i] == brd) {
                    arr3.splice(i, 1);
                }
            }
        }
        
        //alert(arr3);
        if (arr3.length != 0) {
            arr1 = [];
            var dexist ='false';
        	var sexist ='false';
        	component.set("v.aircareBox", false);
        	component.set("v.dishcareBox", false);
        	component.set("v.surfacecareBox", false);
        	
        	for (var j = 0; j < arr3.length; j++){
        		if(arr3[j] =='AllAirCare'){
        			arr1.push('Aircare');
        			component.set("v.aircareBox", true);
        		}
        		else if((arr3[j] =='ADW' || arr3[j]=='HDW') && (dexist=='false')){
        			arr1.push('Dishcare');
        			dexist ='true';
        			component.set("v.dishcareBox", true);
        		}
        		else if((arr3[j] =='MrClean' || arr3[j]=='Swiffer') && (sexist =='false')){
        			arr1.push('Surfacecare');
        			sexist = 'true';
        			component.set("v.surfacecareBox", true);
        		}
        	}
        }
        //Select All categories and Brands
        if (arr3.length == 0 ||arr1.length == 0) {
            arr1 = ['Aircare', 'Dishcare', 'Surfacecare'];
            arr3 = ['AllAirCare', 'ADW', 'HDW', 'MrClean', 'Swiffer'];
            component.set("v.aircareBox", 'true');
            component.set("v.allAirCareBox", 'true');
            component.set("v.dishcareBox", 'true');
            component.set("v.aDWBox", 'true');
            component.set("v.hDWBox", 'true');
            component.set("v.surfacecareBox", 'true');
            component.set("v.mrCleanBox", 'true');
            component.set("v.swifferBox", 'true');
        }
        component.set("v.term", arr1);
        component.set("v.brand", arr3);
        var strTtype = component.get("v.strType");
        
        /*appEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        appEvent.fire();*/
        
        var setEvent = component.getEvent("FilterAttribute");
        setEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        setEvent.fire();
    },

    lCChange: function(component, event, helper) {
        var cate = event.target.id;

        //alert(cate+'===='+event.target.checked);
        //var appEvent = $A.get("e.c:FilterEvent");
        var arr2 = component.get("v.lCycle");
        var arr1 = component.get("v.term");
        var arr3 = component.get("v.brand");
        var stDate = component.get("v.rangeStart");
        var endDate = component.get("v.rangeEnd");
        if (cate == 'AP') {
            component.set("v.aPBox", event.target.checked);
        } else if (cate == 'RH') {
            component.set("v.rHBox", event.target.checked);
        }
        if (event.target.checked) {
            arr2.push(cate);
        } else {
            for (var i = 0; i < arr2.length; i++) {
                if (arr2[i] == cate) {
                    arr2.splice(i, 1);
                }
            }
        }
        component.set("v.lCycle", arr2);
        var strTtype = component.get("v.strType");
        
        /*appEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        appEvent.fire();*/
        
        var setEvent = component.getEvent("FilterAttribute");
        setEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        setEvent.fire();

    },
   
    nonCustomizedChange: function(component, event, helper) {
        var cate = event.target.id;

        //alert(cate+'===='+event.target.checked);
        //var appEvent = $A.get("e.c:FilterEvent");
        var arr2 = component.get("v.lCycle");
        var arr1 = component.get("v.term");
        var arr3 = component.get("v.brand");
        var stDate = component.get("v.rangeStart");
        var endDate = component.get("v.rangeEnd");
        var strTtype = component.get("v.strType");
        
        if (cate == 'Customized') {
            component.set("v.customisedBox", event.target.checked);
        } else if (cate == 'Non-customized') {
            component.set("v.nonCustomisedBox", event.target.checked);
        }
        
        if (event.target.checked) {
            strTtype.push(cate);
        } else {
            for (var i = 0; i < strTtype.length; i++) {
                if (strTtype[i] == cate) {
                    strTtype.splice(i, 1);
                }
            }
        }
        component.set("v.strType", strTtype);
        /*appEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        appEvent.fire();*/
        
        var setEvent = component.getEvent("FilterAttribute");
        setEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        setEvent.fire();

    },
    setOutput: function(component, event, helper) {
        //console.log('date change');
        //var stdayVal = component.find("startDate1").get("v.value");
        //var enddayVal = component.find("endDate1").get("v.value");
        
        //var appEvent = $A.get("e.c:FilterEvent");
        var arr2 = component.get("v.lCycle");
        var arr1 = component.get("v.term");
        var arr3 = component.get("v.brand");
        var stDate = component.get("v.rangeStart");
        var endDate = component.get("v.rangeEnd");
        var strTtype = component.get("v.strType");
        //alert(stDate+'==='+endDate);
        component.set("v.rangeStart", stDate);
        component.set("v.rangeEnd", endDate);
        
        /*appEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        appEvent.fire();*/
        
        var setEvent = component.getEvent("FilterAttribute");
        setEvent.setParams({
            "filters": arr1,
            "lCycle": arr2,
            "brand": arr3,
            "rangeStart":stDate,
            "rangeEnd":endDate,
            "strType" : strTtype
        });
        setEvent.fire();
        /*
        var stDate = component.get('v.rangeStart');
        if(!$A.util.isEmpty(stDate) && !$A.util.isUndefined(stDate))
        {
        	alert(conponent.get("v.rangeStart"));
        }
        var edDate = component.get('v.rangeEnd');
        if(!$A.util.isEmpty(edDate) && !$A.util.isUndefined(edDate))
        {
        	alert(conponent.get("v.rangeEnd"));
        }
        */
    },
    onChildAttrChange: function(cmp, evt) {
        /*alert("childAttr has changed");
        alert("old value: " + evt.getParam("oldValue"));
        alert("current value: " + evt.getParam("value"));*/
    }
})