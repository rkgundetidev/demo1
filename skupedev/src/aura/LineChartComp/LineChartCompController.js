({
	afterScriptsLoaded: function(component, event, helper)
	{
		//alert('hello'+event.getParam("filters"));

		//helper.getTableData(component);
		//var appEvent = $A.get("e.c:FilterEvent");
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
        
        
        //var nowDate = new Date(); 
        //var sdate = startday.getFullYear()+'-'+(startday.getMonth()+1)+'-'+startday.getDate(); 
        //var edate = today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate(); 
        
        //alert(startday+'==='+today+'==date=='+date+'===edate==='+edate);
        
        //startday = startday.getFullYear() + "-" + (startday.getMonth() + 1) + "-" + startday.getDate();
        //today = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
        
        //component.set('v.rangeStart', startday.getFullYear() + "-" + (startday.getMonth() + 1) + "-" + startday.getDate());
        //component.set('v.rangeEnd', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        
		//alert('afterScriptsLoaded==='+filt+'==lCyc=='+lCyc+'startday=='+startday+'==today=='+today);
		helper.getTableData1(component,arr1,arr2,arr3,startday,today,strType);
		
		
		/*
		var action1 = component.get("c.getData");
        
		action1.setCallback(this,function(af){
			
			var state1 = af.getState();
            
			if(state1 == "SUCCESS"){
				var result1 = af.getReturnValue();
				//alert(JSON.stringify(result1));
				if(!$A.util.isEmpty(result1) && !$A.util.isUndefined(result1))
				{
					var labels = [];
					var custs = [];
					var conts = result1;
					for (var k=0; k<conts.length; k++) {
						custs.push({name:conts[k].name, color:conts[k].color, lineColor:conts[k].lineColor, data:conts[k].data});
						
						labels = conts[k].labelData;
						
					}

					//alert(labels);
					new Highcharts.chart({
					chart: {
						renderTo: component.find("chart1").getElement()
					},
					 title: {
						text: 'Data labels box options'
					},

					subtitle: {
						text: 'backgroundColor, borderColor, borderRadius, borderWidth, padding and shadow'
					},
					legend: {
						enabled: true,
						floating: true,
						verticalAlign: 'top',
						align:'right',
						y:40
					},
					xAxis: {
						title: {
							text: 'Month'
						},
						categories: labels	//['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
					},
					yAxis: {
						title: {
							text: 'SKU Count'
						}
					},
					plotOptions: {
						series: {
							color: '#FF0000',
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

					series: conts
				});
				}
			}

		});
		$A.enqueueAction(action1);
		*/
		/*
		new Highcharts.Chart({
			chart: {
				renderTo: component.find("chart").getElement(),
				type: 'line'
			},
			title: {
				text: 'Styling data labels by CSS'
			},

			xAxis: {
				title: {
					text: 'Month'
				},
				categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
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
				align:'right',
				y:40
			},
			plotOptions: {
				line: {
					dataLabels: {
						enabled: true
					},
					enableMouseTracking: false
				}
			},
			series: [{
				name: 'Tokyo',
				data: [7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6],
				color: '#3975A2',
				lineColor : '#3975A2'
			}, {
				name: 'London',
				data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8],
				color: '#FF0000',
				lineColor : '#FF0000'
			}]
		});
		*/
		/*
		new Highcharts.chart({
				chart: {
					renderTo: component.find("chart1").getElement()
				},
				 title: {
					text: 'Data labels box options'
				},

				subtitle: {
					text: 'backgroundColor, borderColor, borderRadius, borderWidth, padding and shadow'
				},
				legend: {
					enabled: true,
					floating: true,
					verticalAlign: 'top',
					align:'right',
					y:40
				},
				xAxis: {
					title: {
						text: 'Month'
					},
					categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
				},
				yAxis: {
					title: {
						text: 'SKU Count'
					}
				},
				plotOptions: {
					series: {
						color: '#FF0000',
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

				series: [{
					data: [29.9, 71.5, 106.4, 129.2, 144.0, 178.0, 135.6, 148.5, {
						y: 216.4,
						dataLabels: {
							borderColor: 'red',
							borderWidth: 2,
							padding: 5,
							shadow: true,
							style: {
								fontWeight: 'bold'
							}
						}
					}, 194.1, 95.6, 54.4],
					lineColor : '#3975A2'
				}]
			});
			*/
        
	},
    fetchRecords123 : function(component, event, helper) {
    
    	setTimeout($A.getCallback(()=>{
			if(!component.isValid())
				return;
				
	        /*
	        var count = component.get("v.count");
	        count++;
	      	component.set("v.count", count);
	    	*/
	        //alert('hello'+event.getParam("filters"));
	    	
			document.getElementById("Accspinner1").style.display = "block";
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
	        //alert(strType);
	        //var strType = event.getParam("strType");
	        //alert(strType);
			//alert('brand==='+brand);
			//alert('filters=LineChartComponent=293='+filters+' = '+lCycle+' = '+brand+' = '+stDate+' = '+endDate +' = '+strType);
			//alert('lCycle==='+lCycle);
			//alert('stDate==1='+stDate);
			//alert('endDate==1='+endDate);
			if (!$A.util.isEmpty(filters) && !$A.util.isUndefined(filters))
			{
				helper.getTableData1(component,filters,lCycle,brand,stDate,endDate, strType);
			}else
			{
				helper.getTableData1(component,arr1,arr2,arr3,startday,today,strType);
			}
		}),500);
     },
     showOppmodal: function(component, event, helper) {
		 //Toggle CSS styles for opening Modal
		 //var spinner = cmp.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-hide");
		
		helper.toggleClass(component,'backdrop','slds-backdrop--');
		helper.toggleClass(component,'modaldialog','slds-fade-in-');
		
		
		//document.getElementById("Accspinner").style.display = "block";
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
		
		helper.getSKUDynamicData(component,arr3,status,group);
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