({
	getPosition : function(component) {
		
        var action = component.get("c.tableHeadingsData");
        
        //Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
                    	component.set("v.lstHeading",result);
                } else if(state == "ERROR"){
                    alert('Error in calling server side action');
                } 
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
	},
    getData : function(component) {
		//document.getElementById("Accspinner1").style.display = "block";
        var action = component.get("c.tableData1");
        
        //Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
					//alert(result.grandTotals);
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
					{
						/*
						var custs = [];
						var conts = result.grandTotals;
						for ( key in conts ) {
							custs.push({value:conts[key], key:key});
						}*/
						//component.set("v.customers", custs);
                    	component.set("v.lstData",result);
						//component.set("v.gtotalsMap",result.grandTotals);
					}
					document.getElementById("Accspinner1").style.display = "none";
                } else if(state == "ERROR"){
					document.getElementById("Accspinner1").style.display = "none";
                    alert('Error in calling server side action');
                }
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
	},
	toggleClass: function(component,componentId,className) {
		var modal = component.find(componentId);
		$A.util.removeClass(modal,className+'hide');
		$A.util.addClass(modal,className+'open');
	},

	toggleClassInverse: function(component,componentId,className) {
		var modal = component.find(componentId);
		$A.util.addClass(modal,className+'hide');
		$A.util.removeClass(modal,className+'open');
	},
	getSKUData : function(component) {
		document.getElementById("Accspinner").style.display = "block";
		//alert(document.getElementById("CATEGORY").innerHTML);
        var action = component.get("c.getSKUData");
        action.setParams({
                            "cat":document.getElementById("CATEGORY").innerHTML,
                            "strgroup":document.getElementById("GROUP").innerHTML,
							"mon":document.getElementById("MONTH").innerHTML,
							"status":document.getElementById("STATUS").innerHTML
                        });
        //Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
                    	component.set("v.lstSKUs",result);
					document.getElementById("Accspinner").style.display = "none";
                } else if(state == "ERROR"){
                    alert('Error in calling server side action');
                }
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
	}
})