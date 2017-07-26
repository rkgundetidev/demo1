({
    getTableData1: function(component, filters, lCycle, brand, startDt, endDt) {
        document.getElementById("Accspinner1").style.display = "block";
        var actionData = component.get("c.loadData1");
        var cats = filters;
        var lcycle = lCycle;
        var brandval = brand;
        var startDtVal = startDt;
        var endDtVal = endDt;
        //alert('**********' + startDtVal + '&&&&&&&&' + endDtVal+'==='+filters+'==='+lCycle+'===='+brand);
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
                    
                    component.set("v.lstCatWrapper", dataResults['Actuals'].datWrap);
                    component.set("v.lstTHeadWrap", dataResults['Actuals'].headWrap);
                    component.set("v.lstMainProjectionWrapper", dataResults['Past Projections'].datWrap);
                    component.set("v.lstProjectionWrapper", dataResults['Future Projections'].datWrap);
                    component.set("v.lstFTHeadWrap",dataResults['Future Projections'].headWrap);
                    var headingResults = dataResults['Actuals'].headWrap;
                    var dataLResults = dataResults['Actuals'].datWrap;
                    
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
                    
                   
                var chartComp = component.find("chart");
                //alert(JSON.stringify(result1));
                if (!$A.util.isEmpty(chartComp) && !$A.util.isUndefined(chartComp)) {
                   
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
                }
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
                 var chartComp1 = component.find("chart1");
                //alert(JSON.stringify(result1));
                if (!$A.util.isEmpty(chartComp1) && !$A.util.isUndefined(chartComp1)) {   
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

                   }
                    
                    

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
	}

           
})