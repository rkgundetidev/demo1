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
                    {
						component.set("v.lstHeading",result); 
						
					}
                } else if(state == "ERROR"){
                    alert('Error in calling server side action');
                } 
            });
        
		var conts ='';
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
		
		var catAction = component.get("c.categoryList");
		
        catAction.setCallback(this,function(a){
			
			var state = a.getState();
            //alert(state);
            //check if result is successfull
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
				//alert(result);
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
				{
                    component.set("v.catoptions",result);
					//alert(component.get("v.catoptions"));
					conts = result;
					component.set("v.selectedCategories", result);

					var arr = component.get("v.selSubCategories");
					arr.push('All Air Care');
					arr.push('ADW');
					arr.push('HDW');
					arr.push('Mr Clean');
					arr.push('Swiffer');
					component.set("v.selSubCategories", arr);
					//alert('conts==='+conts);			
					var datafunction = component.get("c.tableData1");
			
						datafunction.setParams({
										"cat":'',
										"selCat":conts,
										"selSubCat":arr
									});
					//Setting the Callback
						datafunction.setCallback(this,function(a){
							//get the response state
							var state1 = a.getState();
                
							//check if result is successfull
							if(state1 == "SUCCESS"){
								var result = a.getReturnValue();
					
								if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
								{
						
                    				

									var wrapper = { 'acc' : result.dWrapper, 
												'selected' : result.grandTotals
									};
									//alert(JSON.stringify(result));
									//alert(JSON.stringify(wrapper.selected));
									//alert(JSON.stringify(wrapper));
									component.set("v.lstData",result);
									component.set("v.lstdWrapper",wrapper.acc);
									//component.set("v.grandTotalsMap",wrapper.selected);
									var custs = [];
									var conts = wrapper.selected;
									for (var key in conts ) {
										//alert(key);
										custs.push({value:conts[key], key:key});
									}
									//alert(JSON.stringify(custs));
									//alert(JSON.stringify(wrapper.selected));
									component.set("v.grandTotalsMap", custs);
									component.set("v.customizeBool", true);
									/*
									//component.set("v.customers", custs);
									var mapToSend = {}
									for (int i=0; i< wrapper.selected.length();i++) {
										//mapToSend[key] = valueMap.get(key);
										alert('key==='+wrapper.selected[i]);
									}
									
									*/

									document.getElementById("Accspinner1").style.display = "none";
									//document.getElementById("boxId").style.display = "none";
									document.getElementById("Accspinner").style.display = "none";
								}
								//document.getElementById("Accspinner1").style.display = "none";
							} else if(state1 == "ERROR"){
								document.getElementById("Accspinner1").style.display = "none";
								alert('Error in calling server side action');
							}
						});
            
						//adds the server-side action to the queue        
						$A.enqueueAction(datafunction);
					//getData(component,'',component.get("v.catoptions"));
				}
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            } 
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(catAction);

		
		
		
	},
	getData : function(component, obj, Obj1, Obj2) {
		//document.getElementById("Accspinner1").style.display = "block";
		document.getElementById("Accspinner1").style.display = "block";
        var action = component.get("c.tableData1");
			//alert(Obj1);
			action.setParams({
                            "cat":obj,
                            "selCat":Obj1,
							"selSubCat":Obj2
                        });
        //Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
					
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
					{
						/*
						var custs = [];
						var conts = result.grandTotals;
						for ( key in conts ) {
							custs.push({value:conts[key], key:key});
						}*/
						//component.set("v.customers", custs);
                    	//component.set("v.lstData",result);

						var wrapper = { 'acc' : result.dWrapper, 
									'selected' : result.grandTotals
						};
						//alert(JSON.stringify(wrapper.selected));
						//alert(JSON.stringify(wrapper));
						component.set("v.lstData",{});
						component.set("v.lstData",result);
						component.set("v.lstdWrapper",wrapper.acc);
						//alert(component.get("v.lstData.selected"));
						//var custs = [];
						/*var conts = wrapper.selected;
						for ( key in conts ) {
							custs.push({value:conts[key], key:key});
						}
						*/
						//component.set("v.customers", custs);
						component.set("v.grandTotalsMap",wrapper.selected);
						//alert(custs);
						//alert(JSON.stringify(wrapper.selected));
						//component.set("v.gtotalsMap",result.grandTotals);

						document.getElementById("Accspinner1").style.display = "none";
						//document.getElementById("boxId").style.display = "none";
						document.getElementById("Accspinner").style.display = "none";
					}
					//document.getElementById("Accspinner1").style.display = "none";
                } else if(state == "ERROR"){
					document.getElementById("Accspinner1").style.display = "none";
                    alert('Error in calling server side action');
                }
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
	},
	getCategoryList : function(Component)
	{
		/*
		//alert('in');
		var action = component.get("c.catGroupCustList");
		
        action.setCallback(this,function(a){
			
			var state = a.getState();
            alert(state);
            //check if result is successfull
            if(state == "SUCCESS"){
                var result = a.getReturnValue();
				alert(result);
                if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
                    //component.set("v.catoptions",result);
            } else if(state == "ERROR"){
                alert('Error in calling server side action');
            } 
        });
        
        //adds the server-side action to the queue        
        $A.enqueueAction(action);
		*/	
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
	},
	getSKUDynamicData : function(component) {
		document.getElementById("Accspinner").style.display = "block";
		//alert(document.getElementById("CATEGORY").innerHTML);
        var action = component.get("c.fetchSKUData");
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
                    	component.set("v.lstDynamicData",result);
					document.getElementById("Accspinner").style.display = "none";
                } else if(state == "ERROR"){
                    alert('Error in calling server side action');
                }
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
	}
})