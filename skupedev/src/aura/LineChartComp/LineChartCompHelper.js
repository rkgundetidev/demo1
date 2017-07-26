({
    getTableData: function(component, filters, lCycle, brand, startDt, endDt) {
        var actionTHeadings = component.get("c.tableHeadingsData");

        actionTHeadings.setCallback(this, function(af) {
            var stateHeading = af.getState();

            if (stateHeading == "SUCCESS") {
                var headingResults = af.getReturnValue();
                //alert(JSON.stringify(result1));
                if (!$A.util.isEmpty(headingResults) && !$A.util.isUndefined(headingResults)) {
                    //component.set("v.lstTHeadWrap", headingResults);

                    //var actionData = component.get("c.getTableData");
                    var actionData = component.get("c.loadData1");
                    var cats = filters;
                    var lcycle = lCycle;
                    var brandval = brand;
                    var startDtVal = startDt;
                    var endDtVal = endDt;
                    //alert('**********' + startDtVal + '&&&&&&&&' + endDtVal);
                    actionData.setParams({
                        "selCat": cats,
                        "selLCycle": lcycle,
                        "selBrand": brandval,
                        "startDT": startDtVal,
                        "endDt": endDtVal,
                        "sDate": startDtVal,
                        "eDate": endDtVal
                    });
                    actionData.setCallback(this, function(df) {
                        var stateData = df.getState();

                        if (stateData == "SUCCESS") {
                            var dataResults = df.getReturnValue();
                            //alert(JSON.stringify(result1));
                            if (!$A.util.isEmpty(dataResults) && !$A.util.isUndefined(dataResults)) {
                                //component.set("v.lstCatWrapper", dataResults);

                                //alert(JSON.stringify(dataResults['Actuals'].datWrap));
                                //alert(dataResults['Actuals']);
                                component.set("v.lstCatWrapper", dataResults['Actuals'].datWrap);
                                component.set("v.lstTHeadWrap", dataResults['Actuals'].headWrap);
                                component.set("v.lstMainProjectionWrapper", dataResults['Past Projections'].datWrap);
								
                                component.set("v.lstProjectionWrapper", dataResults['Future Projections'].datWrap);
                                var headingResults = dataResults['Future Projections'];
                                
                                //alert(JSON.stringify(dataResults['Actuals'].headWrap));
                                //alert(JSON.stringify(headingResults));
                                /*
                                for (var k = 0; k < headingResults.length; k++) {
                                
                                	alert(JSON.stringify(headingResults[k]));
                                }*/

                                /*var labels = [];
                                var custs = [];
                                var conts = headingResults;

                                for (var k = 0; k < headingResults.length; k++) {

                                    labels.push(headingResults[k].strDate);

                                }
                                var Key;
                                for (var kk = 0; kk < dataResults.length; kk++) {
                                    var opt = [];
                                    var temp = dataResults[kk].numActiveMap;
                                    component.set('v.myMap', temp);
                                    var actMap = component.get("v.myMap");
                                    //alert(JSON.stringify(actMap));
                                    for (var key in actMap) {
                                        opt.push(actMap[key]);
                                    }
                                    custs.push({
                                        name: dataResults[kk].strCategory + '~A & P',
                                        color: dataResults[kk].color,
                                        lineColor: dataResults[kk].lineColor,
                                        data: opt
                                    });

                                    var opt1 = [];
                                    var temp1 = dataResults[kk].numRemnantMap;
                                    for (var key in temp1) {
                                        opt1.push(temp1[key]);
                                    }

                                    custs.push({
                                        name: dataResults[kk].strCategory + '~R & H',
                                        color: dataResults[kk].color,
                                        lineColor: dataResults[kk].lineColor,
                                        data: opt1
                                    });

                                }


                                //alert(labels);
                                new Highcharts.chart({
                                    chart: {
                                        renderTo: component.find("chart1").getElement()
                                    },
                                    title: {
                                        text: '' //'Data labels box options'
                                    },

                                    subtitle: {
                                        text: '' //'backgroundColor, borderColor, borderRadius, borderWidth, padding and shadow'
                                    },
                                    legend: {
                                        enabled: true,
                                        floating: true,
                                        verticalAlign: 'top',
                                        align: 'right'
                                            //,
                                            //y:40
                                    },
                                    xAxis: {
                                        title: {
                                            text: 'Month'
                                        },
                                        categories: labels //['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
                                    },
                                    yAxis: {
                                        title: {
                                            text: 'SKU Count'
                                        }
                                    },
                                    plotOptions: {
                                        series: {
                                            color: '#FF0000',
                                            enableMouseTracking: false,
                                            dataLabels: {
                                                enabled: true,
                                                borderRadius: 5,
                                                backgroundColor: 'rgba(252, 255, 197, 0.7)',
                                                borderWidth: 1,
                                                borderColor: '#AAA',
                                                y: -6
                                            }
                                        }
                                    },

                                    series: custs
                                });


                                ---------------------------------------------
                                new Highcharts.Chart({
                                    chart: {
                                        renderTo: component.find("chart").getElement(),
                                        type: 'line'
                                    },
                                    title: {
                                        text: '' //'Styling data labels by CSS'
                                    },

                                    xAxis: {
                                        title: {
                                            text: 'Month'
                                        },
                                        categories: labels //['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
                                    },
                                    yAxis: {
                                        title: {
                                            text: 'SKU Count'
                                        }
                                    },
                                    legend: {
                                        enabled: true,
                                        floating: true,
                                        verticalAlign: 'top',
                                        align: 'right'
                                            //,
                                            //y:40
                                    },
                                    plotOptions: {
                                        line: {
                                            dataLabels: {
                                                enabled: true
                                            },
                                            enableMouseTracking: false
                                        }
                                    },
                                    series: custs
                                });*/

                                var spin = document.getElementById("Accspinner1");
                                if (!$A.util.isEmpty(spin) && !$A.util.isUndefined(spin)) {
                                    spin.style.display = "none";
                                }
                            }
                        }
                    });
                    $A.enqueueAction(actionData);


                }

            } else if (state == "ERROR") {
                alert('Error in calling server side action');
            }
        });
        $A.enqueueAction(actionTHeadings);


    },
    getTableData1: function(component, filters, lCycle, brand, startDt, endDt, strType) {
        document.getElementById("Accspinner1").style.display = "block";
        var actionData = component.get("c.loadData1");
        var cats = filters;
        var lcycle = lCycle;
        var brandval = brand;
        var startDtVal = startDt;
        var endDtVal = endDt;
        //alert('getTableData1=='+filters+'**'+strType+'***'+lCycle+'**'+brand+'***' + startDt + '&&&&&&&&' + endDt);
        //alert('getTableData1==='+strType);
        actionData.setParams({
            "selCat": cats,
            "selLCycle": lcycle,
            "selBrand": brandval,
            "startDT": startDtVal,
            "endDt": endDtVal,
            "sDate": startDtVal,
            "eDate": endDtVal,
            "strType" : strType
        });
        actionData.setCallback(this, function(df) {
            var stateData = df.getState();

            if (stateData == "SUCCESS") {
                var dataResults = df.getReturnValue();
                //alert(JSON.stringify(result1));
                if (!$A.util.isEmpty(dataResults) && !$A.util.isUndefined(dataResults)) {
                    //alert(JSON.stringify(dataResults['Actuals'].datWrap));
                    component.set("v.lstCatWrapper", dataResults['Actuals'].datWrap);
                    component.set("v.lstTHeadWrap", dataResults['Actuals'].headWrap);
                    component.set("v.lstMainProjectionWrapper", dataResults['Past Projections'].datWrap);
					
                    component.set("v.lstProjectionWrapper", dataResults['Future Projections'].datWrap);
                    component.set("v.lstFTHeadWrap",dataResults['Future Projections'].headWrap);
                    var headingResults = dataResults['Actuals'].headWrap;
                    var dataLResults = dataResults['Actuals'].datWrap;
                    
                    var dataPResults = dataResults['Past Projections'].datWrap;
                    
                    var headingFutureResults = dataResults['Future Projections'].headWrap;
                    var furuteDataResults = dataResults['Future Projections'].datWrap;

                    var labels = [];
                    var labels1 = [];
                    var custs = [];
                    var conts = headingResults;
                    var opt = [];
                    for (var k = 0; k < headingResults.length; k++) {

                        labels.push(headingResults[k]);
                    }
                    
                    for (var k = 0; k < headingFutureResults.length; k++) {

                        labels1.push(headingFutureResults[k]);
                    }

                    var Key;
                    for (var kk = 0; kk < dataLResults.length; kk++) {
                        var opt = [];
                        var temp = dataLResults[kk].numActiveMap;
                        component.set('v.myMap', temp);
                        var actMap = component.get("v.myMap");
                        //alert(JSON.stringify(actMap));
                        for (var k = 0; k < headingResults.length; k++) {
                        //for (var key in actMap) {
                        	//alert(actMap[dataLResults[kk].strCategory + '~A & P~'+headingResults[k]]+'==='+headingResults[k]);
                        	if(dataLResults[kk].strCategory + '~A & P~'+headingResults[k] in actMap)
                        		opt.push(actMap[dataLResults[kk].strCategory + '~A & P~'+headingResults[k]]);
                            //opts.push(actMap[headingResults[k]]);
                        }
                        if(opt!=null && opt.length>0)
                        {
	                        custs.push({
	                            name: dataLResults[kk].strCategory + '~A & P',
	                            color: dataLResults[kk].color,
	                            lineColor: dataLResults[kk].lineColor,
	                            data: opt
	                        });
                        }
                        var opt1 = [];
                        var temp1 = dataLResults[kk].numRemnantMap;
                        for (var k = 0; k < headingResults.length; k++) {
                        //for (var key in temp1) {
                        	if(dataLResults[kk].strCategory + '~R & H~'+headingResults[k] in temp1)
                        		opt1.push(temp1[dataLResults[kk].strCategory + '~R & H~'+headingResults[k]]);
                            //opts.push(temp1[headingResults[k]]);
                        }
                        
                        if(opt1!=null && opt1.length>0)
                        {
	                        custs.push({
	                            name: dataLResults[kk].strCategory + '~R & H',
	                            color: dataLResults[kk].color,
	                            lineColor: dataLResults[kk].lineColor,
	                            data: opt1
	                        });
	                    }

                    }
                    
                    var pVisible = false;
                    var pRVisible = false;
                    //alert(JSON.stringify(dataPResults));
                    for (var kk = 0; kk < dataPResults.length; kk++) {
                        var opt = [];
                        var temp = dataPResults[kk].numActiveMap;
                        //component.set('v.myMap', temp);
                        //var actMap = component.get("v.myMap");
                        //alert('actMap===='+JSON.stringify(temp));
                        for (var k = 0; k < headingResults.length; k++) {
                        //for (var key in actMap) {
                        	//alert('actMap==='+dataPResults[kk].strCategory+'--'+temp[dataPResults[kk].strCategory + '~'+headingResults[k]]+'==='+headingResults[k]);
                        	if(dataPResults[kk].strCategory + '~'+headingResults[k] in temp)
                        	{
                        		opt.push(temp[dataPResults[kk].strCategory + '~'+headingResults[k]]);
                        		pVisible = true;
                        	}
                        	else
                        		opt.push('');
                            //opts.push(actMap[headingResults[k]]);
                        }
                        
                        //alert(JSON.stringify(opt));
                        
                        if(pVisible == true)
                        {
	                        custs.push({
	                            name: 'Projection~'+dataPResults[kk].strCategory + '~A & P',
	                            color: dataPResults[kk].color,
	                            lineColor: dataPResults[kk].lineColor,
	                            data: opt
	                        });
                        }
                        var opt1 = [];
                        var temp1 = dataPResults[kk].numRemnantMap;
                        
                        for (var k = 0; k < headingResults.length; k++) {
                        //for (var key in temp1) {
                        	if(dataPResults[kk].strCategory + '~'+headingResults[k] in temp1)
                        	{
                        		opt1.push(temp1[dataPResults[kk].strCategory + '~'+headingResults[k]]);
                        		pRVisible = true;
                        	}
                        	else
                        		opt1.push('');
                            //opts.push(temp1[headingResults[k]]);
                        }
                        //alert(opt1.length);
                        if(pRVisible == true)
                        {
	                        custs.push({
	                            name: 'Projection~'+dataPResults[kk].strCategory + '~R & H',
	                            color: dataPResults[kk].color,
	                            lineColor: dataPResults[kk].lineColor,
	                            data: opt1
	                        });
	                    }

                    }
                   
                   //alert(JSON.stringify(custs));
                   new Highcharts.Chart({
                        chart: {
                            renderTo: component.find("chart").getElement(),
                            type: 'line',
                            height: 400
                        },
                        title: {
                            text: '' //'Styling data labels by CSS'
                        },

                        xAxis: {
                            title: {
                                text: 'Month'
                            },
                            categories: labels //['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
                        },
                        yAxis: {
                            title: {
                                text: 'SKU Count'
                            }
                        },
                        legend: {
                            enabled: true,
                            //floating: true,
                            verticalAlign: 'bottom',
                            align: 'left',
                            //y:40,
                            layout: 'horizontal'
                            ,maxHeight: 200   
                            
                        },
                        plotOptions: {
                            line: {
                                dataLabels: {
                                    enabled: true
                                },
                                enableMouseTracking: false
                            }
                        },
                        series: custs
                    });
                    //-----------------------------------------------
                    
                    var futureCusts = [];
                    for (var kk = 0; kk < furuteDataResults.length; kk++) {
                        var opt = [];
                        var temp = furuteDataResults[kk].numActiveMap;
                        component.set('v.myMap', temp);
                        var actMap = component.get("v.myMap");
                        //alert(JSON.stringify(actMap));
                        for (var k = 0; k < headingFutureResults.length; k++) {
                        //for (var key in actMap) {
                        	//alert(actMap[dataLResults[kk].strCategory + '~A & P~'+headingFutureResults[k]]+'==='+headingFutureResults[k]);
                        	if(furuteDataResults[kk].strCategory + '~A & P~'+headingFutureResults[k] in actMap)
                        		opt.push(actMap[furuteDataResults[kk].strCategory + '~A & P~'+headingFutureResults[k]]);
                        	/*else
	                        	opt.push(0);*/
                            //opts.push(actMap[headingFutureResults[k]]);
                        }
                        if(opt!=null && opt.length>0)
                        {
	                        futureCusts.push({
	                            name: furuteDataResults[kk].strCategory + '~A & P',
	                            color: furuteDataResults[kk].color,
	                            lineColor: furuteDataResults[kk].lineColor,
	                            data: opt
	                        });
                        }
                        var opt1 = [];
                        var temp1 = furuteDataResults[kk].numRemnantMap;
                        for (var k = 0; k < headingFutureResults.length; k++) {
                        //for (var key in temp1) {
	                        if(furuteDataResults[kk].strCategory + '~R & H~'+headingFutureResults[k] in temp1)
	                            opt1.push(temp1[furuteDataResults[kk].strCategory + '~R & H~'+headingFutureResults[k]]);
	                        /*else
	                        	opt1.push(0);*/
                            //opts.push(temp1[headingFutureResults[k]]);
                        }
                        
                        if(opt1!=null && opt1.length>0)
                        {
	                        futureCusts.push({
	                            name: furuteDataResults[kk].strCategory + '~R & H',
	                            color: furuteDataResults[kk].color,
	                            lineColor: furuteDataResults[kk].lineColor,
	                            data: opt1
	                        });
	                    }

                    }
                    
                    //alert(JSON.stringify(futureCusts));
                    
                    new Highcharts.chart({
                        chart: {
                            renderTo: component.find("chart1").getElement(),
                            height: 400
                        },
                        title: {
                            text: '' //'Data labels box options'
                        },

                        subtitle: {
                            text: '' //'backgroundColor, borderColor, borderRadius, borderWidth, padding and shadow'
                        },
                        legend: {
                            enabled: true,
                            //floating: true,
                            verticalAlign: 'bottom',
                            align: 'left',
                            //y:40,
                            layout: 'horizontal'
                            ,maxHeight: 200
                        },
                        xAxis: {
                            title: {
                                text: 'Month'
                            },
                            categories: labels1 //['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
                        },
                        yAxis: {
                            title: {
                                text: 'SKU Count'
                            }
                        },
                        plotOptions: {
                            series: {
                                color: '#FF0000',
                                enableMouseTracking: false,
                                dataLabels: {
                                    enabled: true,
                                    borderRadius: 5,
                                    backgroundColor: 'rgba(252, 255, 197, 0.7)',
                                    borderWidth: 1,
                                    borderColor: '#AAA',
                                    y: -6
                                }
                            }
                        },

                        series: futureCusts
                    });

                    
                    
                    

                    var spin = document.getElementById("Accspinner1");
                    if (!$A.util.isEmpty(spin) && !$A.util.isUndefined(spin)) {
                        spin.style.display = "none";
                    }
                }
            }
        });
        $A.enqueueAction(actionData);


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
	getSKUDynamicData : function(component,brandval,status,group) {
		component.set("v.lstSKUs",null);
		document.getElementById("Accspinner1").style.display = "block";
		//alert(document.getElementById("CATEGORY").innerHTML+' ===#'+group+' ===#'+document.getElementById("MONTH").innerHTML+' ===#'+status+' ===#'+brandval+' ===#'+document.getElementById("lifecycle").innerHTML);
        var action = component.get("c.fetchSKUData1");
        action.setParams({
                            "cat":document.getElementById("CATEGORY").innerHTML,
                            "strgroup": group,	//document.getElementById("GROUP").innerHTML,
							"mon":document.getElementById("MONTH").innerHTML,
							"status":status,	//document.getElementById("STATUS").innerHTML,
							"selBrand": brandval,
							"strType":document.getElementById("lifecycle").innerHTML
                        });
        //Setting the Callback
            action.setCallback(this,function(a){
                //get the response state
                var state = a.getState();
                
                //check if result is successfull
                if(state == "SUCCESS"){
                    var result = a.getReturnValue();
                    if(!$A.util.isEmpty(result) && !$A.util.isUndefined(result))
                    	//component.set("v.lstDynamicData",result);
                    	component.set("v.lstSKUs",result);
                    	
					document.getElementById("Accspinner1").style.display = "none";
                } else if(state == "ERROR"){
                	document.getElementById("Accspinner1").style.display = "none";
                    alert('Error in calling server side action');
                }
            });
            
            //adds the server-side action to the queue        
            $A.enqueueAction(action);
	},
	exportToExcelAll: function(cmp){
		var helper=this;
		/*var actualsActive = cmp.get("v.lstCatWrapper")[0].numActiveMap;
		var actualsAll = cmp.get("v.lstCatWrapper")[0].numMap;
		var actualsRemnant = cmp.get("v.lstCatWrapper")[0].numRemnantMap;
		//alert(JSON.stringify(actualsRemnant));
		var projActive = cmp.get("v.lstProjectionWrapper")[0].numActiveMap;
		var projAll = cmp.get("v.lstProjectionWrapper")[0].numMap;
		var projRemnant = cmp.get("v.lstProjectionWrapper")[0].numRemnantMap;
		
		var mProjActive = cmp.get("v.lstMainProjectionWrapper")[0].numActiveMap;
		var mProjAll = cmp.get("v.lstMainProjectionWrapper")[0].numMap;
		var mProjRemnant = cmp.get("v.lstMainProjectionWrapper")[0].numRemnantMap;*/
		
		var headerslst = cmp.get("v.lstCatWrapper")[0].headingLst;
		var actualsActive;	
		var actualsAll = cmp.get("v.lstCatWrapper");	//.numMap;
		var actualsRemnant;	
		//alert(JSON.stringify(headerslst));
		var projActive;
		var projAll = cmp.get("v.lstProjectionWrapper");	//.numMap;
		var projRemnant;
		var projHeaderslst = cmp.get("v.lstProjectionWrapper")[0].headingLst;
		
		var mProjActive;
		var mProjAll = cmp.get("v.lstMainProjectionWrapper");	//.numMap;
		var mProjRemnant;
		
		
		var actualsActiveJSON = new Array();
		var actualsAllJSON = new Array();
		var actualsRemnantJSON = new Array();
		var projActiveJSON = new Array();
		var projRemnantJSON = new Array();
		var projAllJSON = new Array();
		
		var mProjActiveJSON = new Array();
		var mProjRemnantJSON = new Array();
		var mProjAllJSON = new Array();
		
		
		/*===========actualsAll==================*/
		if (!$A.util.isEmpty(actualsAll) && !$A.util.isUndefined(actualsAll))
		{
			for(var ii = 0 ; ii < actualsAll.length; ii++)
			{
				var actMap = actualsAll[ii].numMap;
				var arr = new Array();
				for(var a in actMap)
				{
					
					//alert(a.split('~')[0]+'=='+a.split('~')[1]+'=='+actMap[a]);
					arr.push({
						cat:a.split('~')[0],
						mnth:a.split('~')[1],
						val:actMap[a],
						type:"AirCare"
					});
				}
				actualsAllJSON.push({cat:actualsAll[ii].strCategory,lst:arr});
				var activeMap = actualsAll[ii].numActiveMap;
				
				if (!$A.util.isEmpty(activeMap) && !$A.util.isUndefined(activeMap))
				{
					arr = new Array();
					for(var a in activeMap){
			            
			            arr.push({
							cat:a.split('~')[0],
							mnth:a.split('~')[2],
							val:activeMap[a],
							type:"AirCare -A & P"
						});
						
					}
					
					actualsActiveJSON.push({cat:actualsAll[ii].strCategory,lst:arr});
			    }
			    
			    var remnantMap = actualsAll[ii].numRemnantMap;
				
				if (!$A.util.isEmpty(remnantMap) && !$A.util.isUndefined(remnantMap))
				{
					arr = new Array();
					for(var a in remnantMap){
						//alert(a.split('~')+'==='+a.split('~')[0]+'=='+a.split('~')[1]+'=='+actMap[a]);
			            arr.push({
							cat:a.split('~')[0],
							mnth:a.split('~')[2],
							val:remnantMap[a],
							type:"AirCare -R & H"
						});
						
					}
					
					actualsRemnantJSON.push({cat:actualsAll[ii].strCategory,lst:arr});
			    }
			}
		}
		
		/*===========projAll==================*/
		//alert(JSON.stringify(projAll));
		if (!$A.util.isEmpty(projAll) && !$A.util.isUndefined(projAll))
		{
			for(var ii = 0 ; ii < projAll.length; ii++)
			{
				var actMap = projAll[ii].numMap;
				var arr = new Array();
				for(var a in actMap)
				{
					
					//alert(a.split('~')[0]+'=='+a.split('~')[1]+'=='+actMap[a]);
					arr.push({
						cat:a.split('~')[0],
						mnth:a.split('~')[1],
						val:actMap[a],
						type:"AirCare"
					});
				}
				projAllJSON.push({cat:projAll[ii].strCategory,lst:arr});
				var activeMap = projAll[ii].numActiveMap;
				
				if (!$A.util.isEmpty(activeMap) && !$A.util.isUndefined(activeMap))
				{
					arr = new Array();
					for(var a in activeMap){
			            
			            arr.push({
							cat:a.split('~')[0],
							mnth:a.split('~')[2],
							val:activeMap[a],
							type:"AirCare -A & P"
						});
						
					}
					
					projActiveJSON.push({cat:projAll[ii].strCategory,lst:arr});
			    }
			    
			    var remnantMap = projAll[ii].numRemnantMap;
				
				if (!$A.util.isEmpty(remnantMap) && !$A.util.isUndefined(remnantMap))
				{
					arr = new Array();
					for(var a in remnantMap){
						//alert(a.split('~')+'==='+a.split('~')[0]+'=='+a.split('~')[1]+'=='+actMap[a]);
			            arr.push({
							cat:a.split('~')[0],
							mnth:a.split('~')[2],
							val:remnantMap[a],
							type:"AirCare -R & H"
						});
						
					}
					
					projRemnantJSON.push({cat:projAll[ii].strCategory,lst:arr});
			    }
			}
		}
		
		/*===========mProjAll==================*/
		if (!$A.util.isEmpty(mProjAll) && !$A.util.isUndefined(mProjAll))
		{
			for(var ii = 0 ; ii < mProjAll.length; ii++)
			{
				var actMap = mProjAll[ii].numMap;
				var arr = new Array();
				for(var a in actMap)
				{
					
					//alert(a.split('~')[0]+'=='+a.split('~')[1]+'=='+actMap[a]);
					arr.push({
						cat:a.split('~')[0],
						mnth:a.split('~')[1],
						val:actMap[a],
						type:"AirCare"
					});
				}
				mProjAllJSON.push({cat:mProjAll[ii].strCategory,lst:arr});
				var activeMap = mProjAll[ii].numActiveMap;
				
				if (!$A.util.isEmpty(activeMap) && !$A.util.isUndefined(activeMap))
				{
					arr = new Array();
					for(var a in activeMap){
			            
			            arr.push({
							cat:a.split('~')[0],
							mnth:a.split('~')[1],
							val:activeMap[a],
							type:"AirCare -A & P"
						});
						
					}
					
					mProjActiveJSON.push({cat:mProjAll[ii].strCategory,lst:arr});
			    }
			    
			    var remnantMap = mProjAll[ii].numRemnantMap;
				
				if (!$A.util.isEmpty(remnantMap) && !$A.util.isUndefined(remnantMap))
				{
					arr = new Array();
					for(var a in remnantMap){
						//alert(a.split('~')+'==='+a.split('~')[0]+'=='+a.split('~')[1]+'=='+actMap[a]);
			            arr.push({
							cat:a.split('~')[0],
							mnth:a.split('~')[1],
							val:remnantMap[a],
							type:"AirCare -R & H"
						});
						
					}
					
					mProjRemnantJSON.push({cat:mProjAll[ii].strCategory,lst:arr});
			    }
			}
		}
		
		/*===========mProjActive==================*/
			
		
		var wb = XLSX.utils.book_new();
		
		
		var datArr=[];
		var header=[];
		var row1=[],row2=[],row3=[];
		header.push('');
		
		for(var k=0; k<headerslst.length; k++)
		{
			header.push(headerslst[k]);
		}
		
		for(var i=0;i<actualsAllJSON.length;i++){
			var aclst = actualsAllJSON[i]["lst"];
			var tempRow1 = new Array(header.length);
				//tempRow1.push(actualsAllJSON[i]["cat"]);
			for(var k=0;k<header.length;k++){
			
				var month1 = header[k];
				if(month1!=null && month1!='')
				{
					for(var ii=0;ii<aclst.length;ii++){
			            var mnth = aclst[ii]["mnth"];
			            
			            var areEqual = mnth.toUpperCase() === month1.toUpperCase();
			            //alert(month1+'=$$='+mnth+'==='+areEqual);
						if(areEqual)
						{
							tempRow1[k] = aclst[ii]["val"];
						}
					}
				}else
				{
					tempRow1[k] = actualsAllJSON[i]["cat"];
				}
			}
			row1.push(tempRow1);
			tempRow1 = new Array(header.length);
			if (!$A.util.isEmpty(actualsActiveJSON) && !$A.util.isUndefined(actualsActiveJSON))
			{
				aclst = actualsActiveJSON[i]["lst"];
					//tempRow1.push(actualsAllJSON[i]["cat"]);
				for(var k=0;k<header.length;k++){
				
					var month1 = header[k];
					if(month1!=null && month1!='')
					{
						for(var ii=0;ii<aclst.length;ii++){
				            var mnth = aclst[ii]["mnth"];
				            
				            var areEqual = mnth.toUpperCase() === month1.toUpperCase();
				            //alert(month1+'=$$='+mnth+'==='+areEqual);
							if(areEqual)
							{
								tempRow1[k] = aclst[ii]["val"];
							}
						}
					}else
					{
						tempRow1[k] = "A & P";
					}
				}
				row1.push(tempRow1);
			}
			tempRow1 = new Array(header.length);
			if (!$A.util.isEmpty(actualsRemnantJSON) && !$A.util.isUndefined(actualsRemnantJSON))
			{
				aclst = actualsRemnantJSON[i]["lst"];
					//tempRow1.push(actualsAllJSON[i]["cat"]);
				for(var k=0;k<header.length;k++){
				
					var month1 = header[k];
					if(month1!=null && month1!='')
					{
						for(var ii=0;ii<aclst.length;ii++){
				            var mnth = aclst[ii]["mnth"];
				            
				            var areEqual = mnth.toUpperCase() === month1.toUpperCase();
				            //alert(month1+'=$$='+mnth+'==='+areEqual);
							if(areEqual)
							{
								tempRow1[k] = aclst[ii]["val"];
							}
						}
					}else
					{
						tempRow1[k] = "R & H";
					}
				}
				row1.push(tempRow1);
			}
		}
		row2.push('Actuals');
		datArr.push(row2);
		datArr.push(header);
		if(row1!=null && row1.length>0)
		{
			for(var z=0; z< row1.length; z++)
			{
				//alert('row1===='+JSON.stringify(row1[z]));
				datArr.push(row1[z]);
			}
		}
		
        datArr.push([]);
        datArr.push([]);
        datArr.push([]);
        
        header=[];
		row1=[];row2=[];row3=[];
		
		header.push('');
		
		for(var k=0; k<projHeaderslst.length; k++)
		{
			header.push(projHeaderslst[k]);
		}

		for(var i=0;i<projAllJSON.length;i++){
			var aclst = projAllJSON[i]["lst"];
			var tempRow1 = new Array(header.length);
				//tempRow1.push(projAllJSON[i]["cat"]);
			for(var k=0;k<header.length;k++){
			
				var month1 = header[k];
				if(month1!=null && month1!='')
				{
					for(var ii=0;ii<aclst.length;ii++){
			            var mnth = aclst[ii]["mnth"];
			            
			            var areEqual = mnth.toUpperCase() === month1.toUpperCase();
			            //alert(month1+'=$$='+mnth+'==='+areEqual);
						if(areEqual)
						{
							tempRow1[k] = aclst[ii]["val"];
						}
					}
				}else
				{
					tempRow1[k] = projAllJSON[i]["cat"];
				}
			}
			//alert('tempRow1==='+JSON.stringify(tempRow1));
			row1.push(tempRow1);
			tempRow1 = new Array(header.length);
			if (!$A.util.isEmpty(projActiveJSON) && !$A.util.isUndefined(projActiveJSON))
			{
				aclst = projActiveJSON[i]["lst"];
					//tempRow1.push(actualsAllJSON[i]["cat"]);
				for(var k=0;k<header.length;k++){
				
					var month1 = header[k];
					if(month1!=null && month1!='')
					{
						for(var ii=0;ii<aclst.length;ii++){
				            var mnth = aclst[ii]["mnth"];
				            
				            var areEqual = mnth.toUpperCase() === month1.toUpperCase();
				            //alert(month1+'=$$='+mnth+'==='+areEqual);
							if(areEqual)
							{
								tempRow1[k] = aclst[ii]["val"];
							}
						}
					}else
					{
						tempRow1[k] = "A & P";
					}
				}
				row1.push(tempRow1);
			}
			tempRow1 = new Array(header.length);
			if (!$A.util.isEmpty(projRemnantJSON) && !$A.util.isUndefined(projRemnantJSON))
			{
				aclst = projRemnantJSON[i]["lst"];
					//tempRow1.push(actualsAllJSON[i]["cat"]);
				for(var k=0;k<header.length;k++){
				
					var month1 = header[k];
					if(month1!=null && month1!='')
					{
						for(var ii=0;ii<aclst.length;ii++){
				            var mnth = aclst[ii]["mnth"];
				            
				            var areEqual = mnth.toUpperCase() === month1.toUpperCase();
				            //alert(month1+'=$$='+mnth+'==='+areEqual);
							if(areEqual)
							{
								tempRow1[k] = aclst[ii]["val"];
							}
						}
					}else
					{
						tempRow1[k] = "R & H";
					}
				}
				row1.push(tempRow1);
			}
		}
		
		row2.push('Future Projections');
		datArr.push(row2);
		
		datArr.push(header);
		
		if(row1!=null && row1.length>0)
		{
			for(var z=0; z< row1.length; z++)
			{
				//alert('row1===='+JSON.stringify(row1[z]));
				datArr.push(row1[z]);
			}
		}
        
        datArr.push([]);
        datArr.push([]);
        datArr.push([]);
        
        header=[];
		row1=[];row2=[];row3=[];
		
		header.push('');
		
		for(var k=0; k<headerslst.length; k++)
		{
			header.push(headerslst[k]);
		}
		
		
		for(var i=0;i<mProjAllJSON.length;i++){
			var aclst = mProjAllJSON[i]["lst"];
			var tempRow1 = new Array(header.length);
				//tempRow1.push(mProjAllJSON[i]["cat"]);
			for(var k=0;k<header.length;k++){
			
				var month1 = header[k];
				if(month1!=null && month1!='')
				{
					for(var ii=0;ii<aclst.length;ii++){
			            var mnth = aclst[ii]["mnth"];
			            
			            var areEqual = mnth.toUpperCase() === month1.toUpperCase();
			            //alert(month1+'=$$='+mnth+'==='+areEqual);
						if(areEqual)
						{
							tempRow1[k] = aclst[ii]["val"];
						}
					}
				}else
				{
					tempRow1[k] = mProjAllJSON[i]["cat"];
				}
			}
			row1.push(tempRow1);
			tempRow1 = new Array(header.length);
			if (!$A.util.isEmpty(mProjActiveJSON) && !$A.util.isUndefined(mProjActiveJSON))
			{
				aclst = mProjActiveJSON[i]["lst"];
					//tempRow1.push(mProjAllJSON[i]["cat"]);
				for(var k=0;k<header.length;k++){
				
					var month1 = header[k];
					if(month1!=null && month1!='')
					{
						for(var ii=0;ii<aclst.length;ii++){
				            var mnth = aclst[ii]["mnth"];
				            
				            var areEqual = mnth.toUpperCase() === month1.toUpperCase();
				            //alert(month1+'=$$='+mnth+'==='+areEqual);
							if(areEqual)
							{
								tempRow1[k] = aclst[ii]["val"];
							}
						}
					}else
					{
						tempRow1[k] = "A & P";
					}
				}
				row1.push(tempRow1);
			}
			tempRow1 = new Array(header.length);
			if (!$A.util.isEmpty(mProjRemnantJSON) && !$A.util.isUndefined(mProjRemnantJSON))
			{
				aclst = mProjRemnantJSON[i]["lst"];
					//tempRow1.push(actualsAllJSON[i]["cat"]);
				for(var k=0;k<header.length;k++){
				
					var month1 = header[k];
					if(month1!=null && month1!='')
					{
						for(var ii=0;ii<aclst.length;ii++){
				            var mnth = aclst[ii]["mnth"];
				            
				            var areEqual = mnth.toUpperCase() === month1.toUpperCase();
				            //alert(month1+'=$$='+mnth+'==='+areEqual);
							if(areEqual)
							{
								tempRow1[k] = aclst[ii]["val"];
							}
						}
					}else
					{
						tempRow1[k] = "R & H";
					}
				}
				row1.push(tempRow1);
			}
		}
		
		row2.push('Actual Projections');
		datArr.push(row2);
		datArr.push(header);
		if(row1!=null && row1.length>0)
		{
			for(var z=0; z< row1.length; z++)
			{
				//alert('row1===='+JSON.stringify(row1[z]));
				datArr.push(row1[z]);
			}
		}
        
        

		var ws = XLSX.utils.aoa_to_sheet(datArr);

        
		
        XLSX.utils.book_append_sheet(wb, ws, 'Actuals');
		var wbout = XLSX.write(wb,{bookType:'xlsx',bookSST:true, type:'binary'});
        
		saveAs(new Blob([helper.s2ab(wbout)],{type:"application/octet-steam"}),"test.xlsx");
		 
	},
	exportToExcel: function(cmp){
		var helper=this;
		var actualsActive = cmp.get("v.lstCatWrapper")[0].numActiveMap;
		var actualsAll = cmp.get("v.lstCatWrapper")[0].numMap;
		
		var projActive = cmp.get("v.lstProjectionWrapper")[0].numActiveMap;
		var projAll = cmp.get("v.lstProjectionWrapper")[0].numMap;

		var actualsActiveJSON = [];
		var actualsAllJSON = [];
		var projActiveJSON = [];
		var projAllJSON = [];

		for(var a in actualsActive){
            var month = a.split('~')[2];
            var obj = {
				cat:a.split('~')[0],
				sts:a.split('~')[1],
				mnth:month,
				type:"actual"
			};

            obj[month] = actualsActive[a], 
			actualsActiveJSON.push(obj);
        }
		
		for(var a in actualsAll)
			actualsAllJSON.push({
				cat:a.split('~')[0],
				mnth:a.split('~')[1],
				val:actualsAll[a],
				type:"actual"
			});
		
		for(var a in projActive){
            var month = a.split('~')[2];
            var obj = {
				cat:a.split('~')[0],
				sts:a.split('~')[1],
				mnth:month,
				type:"proj"
			};

            obj[month] = projActive[a], 
			projActiveJSON.push(obj);
        }
		
		for(var a in projAll)
			projAllJSON.push({
				cat:a.split('~')[0],
				mnth:a.split('~')[1],
				val:projAll[a],
				type:"proj"
			});
		
		var wb = XLSX.utils.book_new();
		
		/*
		wb.SheetNames=[];
		wb.Sheets = [];
		
		var ws={};
        
		for(var i=0;i<actualsAllJSON.length;i++){
			var cellRef = XLSX.utils.encode_cell({c:i+1,r:1});
			var cellHeader = {t:'n',v:actualsAllJSON[i]["mnth"]};
			ws[cellRef] = cellHeader;
			cellRef = XLSX.utils.encode_cell({c:i+1,r:2});
			var cellRow = {t:'n',v:actualsAllJSON[i]["val"]};
			ws[cellRef] = cellRow;
		}
        */
		var datArr=[];
		var header=[];
		var row1=[],row2=[];
		for(var i=0;i<actualsAllJSON.length;i++){
            var month = actualsAllJSON[i]["mnth"];
			header.push(month);
			row1.push(actualsAllJSON[i]["val"]);
            row2.push(actualsActiveJSON[i][month]);
		}
		datArr.push(header);
		datArr.push(row1);
        datArr.push(row2);
        datArr.push([]);
        datArr.push([]);
        datArr.push([]);
        
        header=[];
		row1=[];row2=[];
		for(var i=0;i<projAllJSON.length;i++){
            var month = projAllJSON[i]["mnth"];
			header.push(month);
			row1.push(projAllJSON[i]["val"]);
            row2.push(projActiveJSON[i][month]);
		}
		datArr.push(header);
		datArr.push(row1);
        datArr.push(row2);
        

		var ws = XLSX.utils.aoa_to_sheet(datArr);

        /*
		var range = {s:{c:1,r:1},e:{c:actualsAllJSON.length,r:2}};
		ws['!ref']=XLSX.utils.encode_range(range);
		
		wb.SheetNames.push('Actuals');
		wb.Sheets['Actuals'] = ws;
        */

        XLSX.utils.book_append_sheet(wb, ws, 'Actuals');
		var wbout = XLSX.write(wb,{bookType:'xlsx',bookSST:true, type:'binary'});
        
		saveAs(new Blob([helper.s2ab(wbout)],{type:"application/octet-steam"}),"test.xlsx");
	},

	s2ab: function(s) {
		if(typeof ArrayBuffer !== 'undefined') {
			var buf = new ArrayBuffer(s.length);
			var view = new Uint8Array(buf);
			for (var i=0; i!=s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
			return buf;
		} else {
			var buf = new Array(s.length);
			for (var i=0; i!=s.length; ++i) buf[i] = s.charCodeAt(i) & 0xFF;
			return buf;
		}
	}

           
})