({
	allRecords:[],
	maxdate:'',
	allProjRecords:[],
	doInit : function(cmp,category) {
		var helper=this;
		helper.allRecords=[];
		helper.allProjRecords=[];
        
		category = category || "all";
		var getMaxDateAction = cmp.get("c.GetMaxDate");
		var getBaseAction = cmp.get("c.GetBaseData");
		//getBaseAction.setParams({"categories":category});
		var getProjectionsAction = cmp.get("c.GetReportData");
		//getProjectionsAction.setParams({"categories":category});
		var base=0;
		var tempBase;

		var maxDatePromise = function(){
			return new Promise((resolve,reject)=>{
				getMaxDateAction.setCallback(this,$A.getCallback(res=>{
					if(cmp.isValid()&& res.getState()=="SUCCESS"){
						helper.maxdate = res.getReturnValue();
						
						getBaseAction.setParams({"maxDate":helper.maxdate});
						getProjectionsAction.setParams({"maxDate":helper.maxdate});
						resolve();
					}else{
						reject('failed to fetch projection data');
					}
				}));
				$A.enqueueAction(getMaxDateAction);
			});
		}

		var baseActionPromise = function(){
			return new Promise((resolve,reject)=>{
				getBaseAction.setCallback(this,$A.getCallback(res=>{
					if(cmp.isValid()&& res.getState()=="SUCCESS"){
						helper.allRecords = res.getReturnValue();
						resolve();
					}else{
						reject('failed to fetch projection data');
					}
				}));
				$A.enqueueAction(getBaseAction);
			});
		}

		
		var projectionsActionPromise = function(){
			return new Promise((resolve,reject)=>{
				getProjectionsAction.setCallback(helper,$A.getCallback(res=>{
					if(cmp.isValid()&& res.getState()=="SUCCESS"){
						helper.allProjRecords = res.getReturnValue();
						resolve();
					}else{
						reject('failed to fetch projection data');
					}
				}));
				$A.enqueueAction(getProjectionsAction);
			});
		}

		var evt = $A.get("e.c:renderdynamicvals");
		var setProjectionData = function(evt){
			helper.setMonthValues(cmp,helper.maxdate,12);
			if(helper.filterQueue.length>0){
				//alert('retrieving from queue');
				helper.filter(cmp,helper.filterQueue.pop().evt,true);
			}else{
				var repData = helper.prepareProjectionData(cmp);
				cmp.set("v.projectiondata",repData);
				evt.fire();
				helper.hideSpinner(cmp);
			}
		}.bind(this,evt);


		helper.showSpinner(cmp);
		 maxDatePromise()
		 .then(()=>Promise.all([baseActionPromise(),projectionsActionPromise()]))
		.catch((e)=>{alert('Failed: '+e.message);})
		.then($A.getCallback(setProjectionData));
		
		
	},

	setMonthValues: function(cmp,startDate,diff){
		var helper = this;
		var monthsArr = helper.getMonthArray(startDate,diff);
		var mnthsValArr=[];
		monthsArr.forEach(mn=>{
			mnthsValArr.push(mn.val);
		});
		cmp.set("v.mnthsValArr",mnthsValArr);
		cmp.set("v.monthsarr",monthsArr);
		
		cmp.set("v.mnthStart",mnthsValArr[0]);
		cmp.set("v.mnthEnd",mnthsValArr[mnthsValArr.length-1]);
	},

	prepareProjectionData: function(cmp){
		var helper = this;
		var mnthsValArr = cmp.get("v.mnthsValArr");
		var projTypes = cmp.get("v.projtypes");
		var categories = cmp.get("v.includedcategories");
		var brands = cmp.get("v.includedbrands");
		var allbrands = cmp.get("v.brands");
		//alert(categories+' '+brands);

		var anp = "Active & Planned";
		var rnh = "Remnant & Historical";
		var cnewsku = "Customized New SKU";
		var ncnewsku = "Non-Customized New SKU";
		var cdisco = "Customized Disco";
		var ncdisco = "Non-Customized Disco";


		var props = [{name:'category',vals:categories},{name:'projtype',vals:['Base',ncnewsku,ncdisco,cnewsku,cdisco]},{name:'projdate',vals:mnthsValArr}];
		var rawProjectionData = helper.allProjRecords, rawBaseData = helper.allRecords;
		if(categories.length < 3){
			rawProjectionData = helper.allProjRecords.filter(rec=>
								categories.indexOf(rec.category)>-1 
							);
			rawBaseData = helper.allRecords.filter(rec=>
								categories.indexOf(rec['Category__c'])>-1 
							);
		}
		if(brands.length < allbrands.length){
			rawProjectionData = helper.allProjRecords.filter(rec=>
								brands.indexOf(rec.dishcaregroup)>-1 
							);
			rawBaseData = helper.allRecords.filter(rec=>
								brands.indexOf(rec['Dish_Care_Group__c'])>-1 
							);
		}
		if((rawBaseData.length + rawProjectionData.length) > 0){
			
			var repData = helper.groupByMulti(rawProjectionData,props);
			var baseByStatus = _.groupBy(rawBaseData,'Status__c');
			var baseByCat = _.groupBy(baseByStatus[anp],'Category__c');
			var remnantBaseByCat = _.groupBy(baseByStatus[rnh],'Category__c');

			var finalRepData = {};
			if(projTypes.indexOf("Base")>-1){
				categories.forEach(cat=>{
					
					finalRepData[cat]={};
					finalRepData[cat][anp] = repData[cat];
					finalRepData[cat][rnh]={};
					finalRepData[cat][rnh]["Base"]={};
					finalRepData[cat][rnh][ncdisco] = repData[cat][ncdisco];
					finalRepData[cat][rnh][cdisco] = repData[cat][cdisco];
					
					mnthsValArr.forEach((mnth,i)=>{
						if(i==0){
							finalRepData[cat][anp]["Base"][mnth]=baseByCat[cat]||[];
							finalRepData[cat][rnh]["Base"][mnth]=remnantBaseByCat[cat]||[];
						}
						else{
							var prevMonth = mnthsValArr[i-1];
							var arrLength = finalRepData[cat][anp]["Base"][prevMonth].length+
											repData[cat][ncnewsku][prevMonth].length+
											repData[cat][cnewsku][prevMonth].length
											-repData[cat][ncdisco][prevMonth].length
											-repData[cat][cdisco][prevMonth].length;

							finalRepData[cat][anp]["Base"][mnth] = Array(arrLength).fill(0);
							var remnantArrLength = finalRepData[cat][rnh]["Base"][prevMonth].length +
												 repData[cat][ncdisco][prevMonth].length + 
												 repData[cat][cdisco][prevMonth].length;
							finalRepData[cat][rnh]["Base"][mnth] = Array(remnantArrLength).fill(0);
						}
					});
				});
			}else{
				categories.forEach(cat=>{
					finalRepData[cat]=[];
					finalRepData[cat][anp] = repData[cat];
					finalRepData[cat][rnh][ncdisco] = repData[cat][ncdisco];
					finalRepData[cat][rnh][cdisco] = repData[cat][cdisco];
				});
			}
			return [finalRepData];
		}else
			return [];
	},

	getMonthArray: function(maxdate,numMonths){

		var yr = parseInt(maxdate.split("-")[0]);
		var mn = parseInt(maxdate.split("-")[1]);
		var mntIntervalArray = [5,4,3,2,1,12,11,10,9,8,7,6];
		
		var months=[],monthlabels=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		for(var i=(mn+1),j=0;j<numMonths;i++,j++){
			var dtobj = {};
			var currmnth = ((i%12)||12);
			var curryr = yr+Math.floor(i/13);
			dtobj.val = curryr+"-"+ ("00"+currmnth).slice(-2) +"-01";
			dtobj.label = monthlabels[currmnth-1]+"-"+curryr;
			months.push(dtobj);
		}
		return months;
	},

	groupByMulti: function(list, values) {
		if (!values.length)
			return list;
		var byFirst = _.groupBy(list, values[0].name);
		
		values[0].vals.forEach(attr=>{
			if(!byFirst[attr])
				byFirst[attr]=[];
		});
		
		/*
		for(var prop in byFirst){
			if(values[0].vals.indexOf(prop)==-1)
				delete byFirst[prop];
		}*/

		var rest = values.slice(1);
		for (var prop in byFirst)
			byFirst[prop] = this.groupByMulti(byFirst[prop], rest);
		return byFirst;
  	},
	hideSpinner: function(cmp){
      $A.util.addClass(cmp.find('spinner'),'hidden');
    },
    showSpinner:function(cmp){
      $A.util.removeClass(cmp.find('spinner'),'hidden');  
    },

	filterByCategory: function(cmp,category,checked){
		var helper = this;
		helper.showSpinner(cmp);
		//cmp.set("v.categories",categories);
		var allcategories = cmp.get("v.categories");
		var includedCategories = cmp.get("v.includedcategories");
		//var catBrands = {"Air Care":["All Air Care"],"Dish Care":["ADW","HDW"],"Surface Care":["Mr Clean","Swiffer"]};
		if(checked==true && includedCategories.indexOf(category)==-1)
			includedCategories.splice(allcategories.indexOf(category),0,category);
		else if(checked == false && includedCategories.indexOf(category)>-1)
			includedCategories.splice(includedCategories.indexOf(category),1);
		
		var catbrandmap = cmp.get("v.catbrandmap");
		catbrandmap.forEach(obj=>{
			if(includedCategories.indexOf(obj.name)==-1){
				obj.brands=[];
			}
		});
		//cmp.set("v.includedcatbrandmap",catbrandmap);
		var repData = helper.prepareProjectionData(cmp);
		
		cmp.set("v.includedcategories",includedCategories);
		cmp.set("v.projectiondata",repData);
		$A.get("e.c:renderdynamicvals").fire();
		helper.hideSpinner(cmp);

	},
	
	filterByBrands: function(cmp,brand,checked){
		var helper = this;
		helper.showSpinner(cmp);
		var includedBrands = cmp.get("v.includedbrands");
		if(checked==true && includedBrands.indexOf(brand)==-1)
			includedBrands.push(brand);
		else if(checked == false && includedBrands.indexOf(brand)>-1)
			includedBrands.splice(includedBrands.indexOf(brand),1);
		cmp.set("v.includedbrands",includedBrands);
		var repData = helper.prepareProjectionData(cmp);
		cmp.set("v.projectiondata",repData);
		$A.get("e.c:renderdynamicvals").fire();
		helper.hideSpinner(cmp);
	},

	filterQueue:[],

	filter: function(cmp,evt,isInitialCall){
		var helper = this, isInitialCall=true;
		if(!helper.allRecords || helper.allRecords.length==0){
			//alert('Adding to queue');
			helper.filterQueue.push({"evt":evt});
			return;
		}
		//cmp.find("containerdiv").forEach(c=>c.set("v.body",[]));
		helper.showSpinner(cmp);
		
		setTimeout($A.getCallback(()=>{
			if(!cmp.isValid())
				return;
			var catFilters = (evt.getParam("filters")||"");
			var brandFilters = evt.getParam("brand");	// get brand filters from filter component
			var rangeEnd = isInitialCall?new Date(cmp.get("v.mnthEnd")+"T00:00:00"):new Date(evt.getParam("rangeEnd")+"T00:00:00");
			var lCycle = evt.getParam("lCycle");
			var projTypeVals = evt.getParam("strType");

			var statuses = [];
			if(lCycle.indexOf('AP')>-1)
				statuses.push('Active & Planned');
			if(lCycle.indexOf('RH')>-1)
				statuses.push('Remnant & Historical');	
			
			
			var projTypes=['Base'];
			var projTypesForDisplay=['Base'];
			if(projTypeVals.indexOf('Non-customized')>-1){
				projTypes.push('Non-Customized New SKU');
				projTypes.push('Non-Customized Disco');
				projTypesForDisplay.push('Non-Customized New SKUs');
				projTypesForDisplay.push('Non-Customized Discos');
			}
			if(projTypeVals.indexOf('Customized')>-1){
				projTypes.push('Customized New SKU');
				projTypes.push('Customized Disco');
				projTypesForDisplay.push('Customized New SKUs');
				projTypesForDisplay.push('Customized Discos');
			}
			

			
			var maxDate = new Date(helper.maxdate+"T00:00:00");
			
			var diff=12;
			//check if selected date is in the future
			if(rangeEnd.getYear() > maxDate.getYear() || (rangeEnd.getMonth() > maxDate.getMonth() && rangeEnd.getYear()== maxDate.getYear())){
				
				if(rangeEnd.getYear()== maxDate.getYear()){
					diff = rangeEnd.getMonth()- maxDate.getMonth();
				}else {
					diff = (rangeEnd.getYear()- maxDate.getYear())*12+rangeEnd.getMonth()- maxDate.getMonth();
				}
			}

			if(diff>12)
				diff=12;
			helper.setMonthValues(cmp,helper.maxdate,diff);
			
			var categories = [];
			var brands=[];
			if(catFilters.length>0)
				categories = catFilters.map(val=>{
						return /Air/i.test(val)?"Air Care":
							/Dish/i.test(val)?"Dish Care":
							/Surface/i.test(val)?"Surface Care":"";
					});

			if(brandFilters.length>0)
				brands = brandFilters.map(val=>{
						return /Air/i.test(val)?"All Air Care":
							/ADW/i.test(val)?"ADW":
							/HDW/i.test(val)?"HDW":
							/Clean/i.test(val)?"Mr Clean":
							/swiffer/i.test(val)?"Swiffer":"";
					});
			//cmp.find("containerdiv").forEach(c=>c.set("v.body",[]));

			var allcategories = cmp.get("v.categories");
			
			categories.sort((a,b)=>{
				if(a=='Air Care')
					return -1;
				else if(b=='Air Care')
					return 1;
				else if(a=='Dish Care')
					return -1;
				else if(b=='Dish Care')
					return 1;
				else return 0;
			});

			
			cmp.set("v.includedcategories",categories);
			cmp.set("v.includedbrands",brands);
			cmp.set("v.projtypesfordisplay",projTypesForDisplay);
			cmp.set("v.projtypes",projTypes);

			var repData = helper.prepareProjectionData(cmp);

			cmp.set("v.projectiondata",repData);
			
			var container = cmp.find("reportcontainer");
			
			var monthsarr = cmp.get("v.monthsarr");
			var mnthsValArr = cmp.get("v.mnthsValArr");
			var allcategories = cmp.get("v.categories");
			var allbrands = cmp.get("v.brands");
			var projtypes = cmp.get("v.projtypes");
			var projtypesfordisplay = cmp.get("v.projtypesfordisplay");


			$A.createComponent("c:ProjectionReportRenderer",
								{
									"includedcategories":categories,"includedbrands":brands,
									"projectiondata":repData,"monthsarr":monthsarr,"categories":allcategories,
									"mnthsValArr":mnthsValArr,"statuses":statuses,
									"brands":allbrands,
									"projtypesfordisplay":projtypesfordisplay,"projtypes":projtypes
								},
							function(comp){
								container.set("v.body",[comp]); 
								$A.get("e.c:renderdynamicvals").fire();
								helper.hideSpinner(cmp);
							});
		
		}),500);
		//cmp.find("containerdiv").forEach(c=>c.set("v.body",c.get("v.body")));
		
	},

	openProjDetails: function(cmp,evt){
		var skuids = evt.getParam('skuids');
		var projtype = evt.getParam('projType');
		var mnth = evt.getParam('mnth');
		var cat = evt.getParam("cat");
		 
		var modal = cmp.find("modalbody");
		//cmp.set("v.popuptitle","Adjust Projected Dates For "+projtype+" Projections");
	
		 
		$A.createComponent(
			"c:ManageProjectionsComponent",
			{
				"skuids":skuids,
				"projType":projtype,
				"mnth":mnth,
				"cat":cat
			},
			function(popup,status,errMessage){
				if(status=='SUCCESS'){
					var body = modal.get("v.body");
					body.push(popup);
					modal.set("v.body",popup);
					$A.util.removeClass(cmp.find("thecontainer"),"hidden");
				}
			}
		)
	},

	openReconcile: function(cmp,evt){
		
		//cmp.set("v.popuptitle","Adjust Projected Dates For "+projtype+" Projections");
		var modal = cmp.find("modalbody");
		$A.createComponent(
			"c:ProjectionReconcileComponent",
			{
			},
			function(popup,status,errMessage){
				if(status=='SUCCESS'){
					var body = modal.get("v.body");
					body.push(popup);
					modal.set("v.body",popup);
					$A.util.removeClass(cmp.find("thecontainer"),"hidden");
				}
			}
		)
	}                
})