public with sharing class LineChartController061917 {
    
	public class wrapperData {
		@AuraEnabled
        public string name;
		@AuraEnabled
        public string color;
		@AuraEnabled
        public string lineColor;
		@AuraEnabled
		public List<decimal> data;
		@AuraEnabled
		public List<string> labelData;
		
		private map<string,integer> totalFutureProjected = new  map<string,integer>();
		private map<string,integer> ActiveFutureProjected = new  map<string,integer>();
		private map<string,integer> DiscFutureProjected = new  map<string,integer>();
		

        public wrapperData(string name, string color, string lineColor, List<decimal> data, List<string> labelData) {
            this.name = name;
            this.color = color;
			this.lineColor = lineColor;
			this.data = data;
			this.labelData = labelData;
        }
    }
	@AuraEnabled
	public static list<wrapperData> getData(){
        list<wrapperData> data = new list<wrapperData>();
		//[7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
		list<decimal> tempData = new list<decimal>{7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6};
		system.debug('tempData===='+tempData);
		List<string> lblData = new list<string>{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
		data.add(new wrapperData('Tokyo', '#3975A2', '#3975A2',tempData, lblData));

		tempData = new list<decimal>{3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8};
		system.debug('tempData===='+tempData);
		
		data.add(new wrapperData('London', '#FF0000', '#FF0000',tempData,lblData));

		return data;
	}
	public class futureProjectWrapper{
		public string skuStatus;
		public string skuCategory;
		public integer skuMonth;
		public integer skuYear;
		public decimal skuTotal;
		
	}
	public class dataHeaderWrapper{
        @AuraEnabled
     	public list<dataWrapper> datWrap;
     	@AuraEnabled
     	public list<String> headWrap;
     	public dataHeaderWrapper(list<dataWrapper> datWrap, list<String> headWrap){
     		this.datWrap = datWrap;
     		this.headWrap = headWrap;
		}
	} 

	public class dataWrapper{
        @AuraEnabled
     	public String strCategory;
        @AuraEnabled
        public String strGroup;
		@AuraEnabled
        public string color;
		@AuraEnabled
        public string lineColor;
		@AuraEnabled
        public map<String,decimal> numMap;
        @AuraEnabled
        public Map<String,decimal> numActiveMap;
        @AuraEnabled
        public map<String,decimal> numRemnantMap;
        
        @AuraEnabled
        public list<String> headingLst;
        
        public dataWrapper(String strCategory,String strGroup,string color,string lineColor, map<String,decimal> numMap,Map<String,
										decimal> numActiveMap,map<String,decimal> numRemnantMap,list<String> headingLst){
            this.strCategory = strCategory;
            this.strGroup = strGroup;
			this.color = color;
			this.lineColor = lineColor;
			this.numMap = numMap; 
            this.numActiveMap = numActiveMap;  
            this.numRemnantMap = numRemnantMap;  
            this.headingLst = headingLst;
        }
    }
/*
	@AuraEnabled
	public static map<string,list<dataWrapper>> loadData(String[] selCat,String[] selLCycle,string[] selBrand,date startDT,date endDt, String sDate, String eDate){
		//outputlist of all lists 
		//Key with be Actuals,Projection and Projection2
		
		map<string,list<dataWrapper>> outputMap = new map<string,list<dataWrapper>> ();	 
		//Aircare maps
		map<String,decimal> airCareMap = new map<String,decimal>();
		map<String,decimal> airCareActiveMap = new map<String,decimal>();
		map<String,decimal> airCareRemnantMap = new map<String,decimal>();
		//Dishcare maps
		map<String,decimal> dishCareMap = new map<String,decimal>();
		map<String,decimal> dishCareActiveMap = new map<String,decimal>();
		map<String,decimal> dishCareRemnantMap = new map<String,decimal>();
		//surface care maps
		map<String,decimal> surfaceCareMap = new map<String,decimal>();
		map<String,decimal> surfaceCareActiveMap = new map<String,decimal>();
		map<String,decimal> surfaceCareRemnantMap = new map<String,decimal>();
		map<String,decimal> AlldataMap = new map<String,decimal>();
		set<string> selectedCate = new set<string>();
		set<string> selectedLC = new set<string>();
		set<String> selectedBrand = new set<String>();
		map<string,string> calendarmap =  new map<string,string>{'1'=>'Jan','2'=>'Feb', '3'=>'Mar', '4'=>'Apr','5'=> 'May', '6'=>'Jun',
		 									 '7'=>'Jul', '8'=>'Aug','9'=> 'Sep','10'=> 'Oct', '11'=>'Nov', '12'=>'Dec'};
		//Categories
		for(integer i =0 ; i< selCat.size();i++){
			if(selCat[i]=='Aircare'){
				selectedCate.add('Air Care');	
			}
			else if(selCat[i]=='Dishcare'){
				selectedCate.add('Dish Care');
			}
			else if(selCat[i]=='Surfacecare'){
				selectedCate.add('Surface Care');
			}
		}
		//Life cycles
		for(integer j=0;j<selLCycle.size();j++){
			if(selLCycle[j]=='AP'){
				selectedLC.add('Active & Planned');	
			}
			else if(selLCycle[j]=='RH'){
				selectedLC.add('Remnant & Historical');
			}
		}
		
		for(integer j=0;j<selBrand.size();j++){
			if(selBrand[j]=='AllAirCare'){
				selectedBrand.add('All Air Care');
			}else if(selBrand[j]=='ADW'){
				selectedBrand.add('ADW');
			}else if(selBrand[j]=='HDW'){
				selectedBrand.add('HDW');
			}else if(selBrand[j]=='MrClean'){
				selectedBrand.add('Mr Clean');
			}else if(selBrand[j]=='Swiffer'){
				selectedBrand.add('Swiffer');
			}
		}
		
		headingWrapper[] wrapperList = new headingWrapper[]{};
		List<String> dateHeadings = new list<String>();
		system.debug('startDT==='+startDT+' ==== '+endDt+'===sDate==='+sDate+'==eDate=='+eDate);
		//Process the Actual Data
		if(sDate!=null && sDate!='')
			AlldataMap = LineChartController.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,date.valueOf(sDate),date.valueOf(eDate));
		else
			AlldataMap = LineChartController.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,startDT,endDt);
		
		for(string echKey : AlldataMap.keyset()){
			//========================== Headings======================
			Date stDate;
			Date endDate;
			if(startDT==null || endDt==null){
				date dtTemp;
				integer month;
				integer Year ;
				//Start date today - 12 months
				dtTemp = system.today().addMonths(-12);
				month = dtTemp.month();
				Year = dtTemp.Year();
				stDate =  Date.newInstance(Year, month, 1); //1st of month
				//End date today - last month
				dtTemp = system.today().addMonths(-1);
				month = dtTemp.month();
				Year = dtTemp.Year();
				endDate = Date.newInstance(Year, month, 31); //31 st of last month
			}
			system.debug('stDate==='+stDate+'=='+endDate);
			Date startOfMonth1 = endDate;
			Date startOfNextMonth = stDate;
			
		
		
			while(startOfNextMonth < startOfMonth1)
			{
				String strDate = startOfNextMonth+'';
				DateTime dt = DateTime.valueOf(strDate);
				strDate = dt.format('MMMMM YYYY');
				system.debug('strDate==='+strDate);
				dateHeadings.add(strDate);
				wrapperList.add(new headingWrapper(strDate));
				startOfNextMonth = startOfNextMonth.AddMonths(1);
			}
			system.debug('dateHeadings==='+dateHeadings);
			//========================== Headings======================
			list<string> tempLst = new list<string>();
			//Air Care~Active & Planned~10~2016=307
			tempLst =echKey.split('~');
			if(tempLst!=null && tempLst.size() > 0){
				//Building AirCare Maps
				if(tempLst[0]=='Air Care'){
					//Load all Air care in Map
					if(tempLst[1]=='Active & Planned'){
						//Active values
						airCareActiveMap.put('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
						//Check airCareRemnantMap if value already exists				
						if(airCareRemnantMap.containsKey('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Aircare active
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
					if(tempLst[1]=='Remnant & Historical'){
						//load the airCareRemnantMap 
						airCareRemnantMap.put('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
						//Check the airCareActiveMap  map
						if(airCareActiveMap.containsKey('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Aircare Remnant
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}				
					}
				}
				//END of Aircare
				////Building Dishcare Maps  
				else if(tempLst[0]=='Dish Care'){
					//Dishcare Active items
					if(tempLst[1]=='Active & Planned'){
						dishCareActiveMap.put('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
					//Check dishCareRemnantMap if value already exists				
						if(dishCareRemnantMap.containsKey('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = dishCareRemnantMap.get('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only dishCare Active 
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
					//Dishcare Remnant items
					if(tempLst[1]=='Remnant & Historical'){
						//Remnant in Dishcare
						dishCareRemnantMap.put('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the dishCareActiveMap in Discare
						if(dishCareActiveMap.containsKey('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = dishCareActiveMap.get('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Remnant
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}	
					}
				}
				//End of Dishcare
				//Start of Surfacecare Maps
				else if(tempLst[0]=='Surface Care'){
					//Load all Air care in Map
					if(tempLst[1]=='Active & Planned'){
						surfaceCareActiveMap.put('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the surfaceCareRemnantMap  in Surfacecare	
						if(surfaceCareRemnantMap.containsKey('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = surfaceCareRemnantMap.get('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only active to surfaceCareMap
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
				
					if(tempLst[1]=='Remnant & Historical'){
						//Load the Remnant map in Surfacecare
						surfaceCareRemnantMap.put('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the surfaceCareActiveMap  in Remnant
						if(surfaceCareActiveMap.containsKey('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = surfaceCareActiveMap.get('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Remnant to surfaceCareMap
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}	
					}
				}
				//End of Dishcare
			}
		}
		list<dataWrapper> dWrap = new list<dataWrapper>();
		if(selCat!=null && selCat.size()>0){
			for(integer i=0; i<selCat.size(); i++){
				System.debug('selCat=i=='+selCat[i]);
				if(selCat[i] == 'Dishcare'){
					dWrap.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,dateHeadings));
				}else if(selCat[i] == 'Surfacecare'){
					dWrap.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,dateHeadings));
				}else if(selCat[i] == 'Aircare'){
					dWrap.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,dateHeadings));
				}
			}
			outputMap.put('Actuals',dWrap);//Put values in display Map
		}
		
		for(String key :airCareMap.keySet())
		{
			system.debug('key==='+key+' === '+airCareMap.get(key));
		}
		system.debug('outputMap==='+outputMap);
		dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap,dateHeadings);
		//End of Actuals data
		//Clear the data
		list<dataWrapper> dWrap1 = new list<dataWrapper>();
		//dWrap.clear();
		airCareActiveMap = new map<String,decimal>();
		airCareMap = new map<String,decimal>();
		
		airCareRemnantMap = new map<String,decimal>();
		dishCareActiveMap = new map<String,decimal>();
		dishCareRemnantMap = new map<String,decimal>();
		dishCareMap = new map<String,decimal>();
		surfaceCareActiveMap = new map<String,decimal>();
		surfaceCareRemnantMap = new map<String,decimal>();
		surfaceCareMap = new map<String,decimal>();
		//*******************************************Past Projection******************************************************
		//Start of Past Projections
		if(sDate!=null && sDate!='')
			AlldataMap = LineChartController.grandTotalsPastProjections(selectedCate,selectedLC,date.valueOf(sDate),date.valueOf(eDate));
		else
			AlldataMap = LineChartController.grandTotalsPastProjections(selectedCate,selectedLC,startDT,endDt);
		system.debug('AlldataMap==='+AlldataMap);
		for(string echKey : AlldataMap.keyset()){
			system.debug('echKey==='+echKey+'===='+AlldataMap.get(echKey));
			list<string> tempLst = new list<string>();
			//Air Care~Active & Planned~10~2016=307
			tempLst =echKey.split('~');
			if(tempLst!=null && tempLst.size() > 0){
				//Building AirCare Maps
				if(tempLst[0]=='Air Care'){
					//Load all Air care in Map
					if(tempLst[1]=='Active & Planned'){
						//Active values
						airCareActiveMap.put('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
						//Check airCareRemnantMap if value already exists				
						if(airCareRemnantMap.containsKey('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Aircare active
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
					
					system.debug('airCareMap==air=='+airCareMap);
					if(tempLst[1]=='Remnant & Historical'){
						//load the airCareRemnantMap 
						airCareRemnantMap.put('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
						//Check the airCareActiveMap  map
						if(airCareActiveMap.containsKey('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Aircare Remnant
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}				
					}
				}
				//END of Aircare
				////Building Dishcare Maps  
				else if(tempLst[0]=='Dish Care'){
					//Dishcare Active items
					if(tempLst[1]=='Active & Planned'){
						dishCareActiveMap.put('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
					//Check dishCareRemnantMap if value already exists				
						if(dishCareRemnantMap.containsKey('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = dishCareRemnantMap.get('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only dishCare Active 
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
					//Dishcare Remnant items
					if(tempLst[1]=='Remnant & Historical'){
						//Remnant in Dishcare
						dishCareRemnantMap.put('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the dishCareActiveMap in Discare
						if(dishCareActiveMap.containsKey('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = dishCareActiveMap.get('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Remnant
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}	
					}
				}
				//End of Dishcare
				//Start of Surfacecare Maps
				else if(tempLst[0]=='Surface Care'){
					//Load all Air care in Map
					if(tempLst[1]=='Active & Planned'){
						surfaceCareActiveMap.put('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the surfaceCareRemnantMap  in Surfacecare	
						if(surfaceCareRemnantMap.containsKey('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = surfaceCareRemnantMap.get('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only active to surfaceCareMap
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
				
					if(tempLst[1]=='Remnant & Historical'){
						//Load the Remnant map in Surfacecare
						surfaceCareRemnantMap.put('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the surfaceCareActiveMap  in Remnant
						if(surfaceCareActiveMap.containsKey('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = surfaceCareActiveMap.get('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Remnant to surfaceCareMap
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}	
					}
				}
				//End of Dishcare
			}
		}
		//Adding values to map
		if(selCat!=null && selCat.size()>0){
			for(integer i=0; i<selCat.size(); i++){
				System.debug('selCat=i=111='+selCat[i]);
				if(selCat[i] == 'Dishcare'){
					dWrap1.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,null));
				}else if(selCat[i] == 'Surfacecare'){
					dWrap1.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,null));
				}else if(selCat[i] == 'Aircare'){
					dWrap1.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,null));
				}
			}
			outputMap.put('Past Projections',dWrap1);//Put values in display Map
		}
		system.debug('airCareMap=11=='+airCareMap);
		for(String key :airCareMap.keySet())
		{
			system.debug('key=11=='+key+' === '+airCareMap.get(key));
		}
		//End of Past Projections
		//Clear data
		list<dataWrapper> dWrap2 = new list<dataWrapper>();
		//dWrap.clear();
		airCareActiveMap = new map<String,decimal>();
		airCareMap = new map<String,decimal>();
		airCareRemnantMap = new map<String,decimal>();
		dishCareActiveMap = new map<String,decimal>();
		dishCareRemnantMap = new map<String,decimal>();
		dishCareMap = new map<String,decimal>();
		surfaceCareActiveMap = new map<String,decimal>();
		surfaceCareRemnantMap = new map<String,decimal>();
		surfaceCareMap = new map<String,decimal>();
		//*******************************************************Future Projections**********************************************
		//Start of Future Projections
		//Logic : Last month actual +projection of current month (new)+projection of current month (manual)
		// Minus projection of current month (disc)  -->base level 
		//next month based level + projection of current month (new)+projection of current month (manual)
		// Minus projection of current month (disc)
		//Default 6 months data
		map<string,decimal> lastMonthActuals = new map<string,decimal> ();
		date dtTemp;
		integer month;
		integer Year ;
		date startDT1; 
		date  endDt1;
		if(sDate!=null && sDate!='')
		{
			startDT = date.valueOf(sDate);
			endDt = date.valueOf(eDate);
		}	
		if(endDt==null || startDT==null){
			dtTemp = system.today().addMonths(-1);
			month = dtTemp.month();
			Year = dtTemp.Year();
			startDT1 = Date.newInstance(Year, month, 1);
			endDt1  = Date.newInstance(Year, month, 31);
			//last month Actuals
			lastMonthActuals =LineChartController.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,startDT1,endDt1);
			//Next 6 months of projections
			dtTemp = system.today().addMonths(6);
			month = dtTemp.month();
			Year = dtTemp.Year();
			startDT1 = Date.newInstance(Year, month, 1);
			endDt1  = Date.newInstance(Year, month, 31);
		}
		//integer monthDiff =  startDT1.monthsBetween(endDt1);
		
		map<string,decimal> newProjectionMap = new map<string,decimal>();
		newProjectionMap = LineChartController.grandTotalsFutureProjections(selectedCate,selectedLC,selectedBrand,startDT1,endDt1,'New');
		
		map<string,decimal> discProjectionMap = new map<string,decimal>();
		discProjectionMap = LineChartController.grandTotalsFutureProjections(selectedCate,selectedLC,selectedBrand,startDT1,endDt1,'Disco');
		
		map<string,decimal> ManualProjectionMap = new map<string,decimal>();
		AggregateResult[] totalproducts =[SELECT  count(id)projections,SKU__r.Category__c,SKU__r.Status__c,
											CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
											 FROM SKU_Projection__c
											 Where Include_in_Projections__c=true and
											 		SKU__r.Category__c in:selectedCate and
											 		SKU__r.Status__c in:selectedCate and
											 		Projected_date__c >=: startDT1 and Projected_date__c<=:endDt1  and
											 		Source__c ='Manual'
											 GROUP BY SKU__r.Category__c,SKU__r.Status__c,CALENDAR_MONTH(Projected_date__c),
											 CALENDAR_Year(Projected_date__c)
											 order by SKU__r.Category__c asc,SKU__r.Status__c asc,
											 CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
		//End of Future Projections
		for(AggregateResult ar: totalproducts){
		    ManualProjectionMap.put(ar.get('Category__c')+'~'+ ar.get('Status__c')+'~' +ar.get('month')+'~'+ar.get('year'),
		    					((Decimal)(ar.get('projections'))));
		}
		map<string,decimal> baseLineMap = new map<string,decimal>();
		
		for(string baseLine:lastMonthActuals.keyset()){
			list<string> tempLst = new list<string>();
			//Air Care~Active & Planned~10~2016=307
			tempLst =baseLine.split('~');
			//prepare based line with Category and Status 
			baseLineMap.put(tempLst[0]+'~'+tempLst[1],lastMonthActuals.get(baseLine));
		}
		//Prepare output Map of future data
		AggregateResult[] totalproductsFuture =[SELECT  count(id)projections,SKU__r.Category__c,SKU__r.Status__c,
											CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
											 FROM SKU_Projection__c
											 Where Include_in_Projections__c=true and
											 		SKU__r.Category__c in:selectedCate and
											 		SKU__r.Status__c in:selectedLC and
											 		Projected_date__c >=: startDT1 and Projected_date__c<=:endDt1  and
											 		Projection_Type__c ='New'
											 GROUP BY SKU__r.Category__c,SKU__r.Status__c,CALENDAR_MONTH(Projected_date__c),
											 CALENDAR_Year(Projected_date__c)
											 order by SKU__r.Category__c asc,SKU__r.Status__c asc,
											 CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
		//Order collection
		for(AggregateResult ar: totalproductsFuture){
			decimal baseline = baseLineMap.get(ar.get('Category__c')+'~'+ar.get('Status__c'))!=null ?
								baseLineMap.get(ar.get('Category__c')+'~'+ar.get('Status__c')): 0.00;
								
			decimal newLine = newProjectionMap.get(ar.get('Category__c')+'~'+ ar.get('Status__c')+
												'~' +ar.get('month')+'~'+ar.get('year')) !=null ?
								newProjectionMap.get(ar.get('Category__c')+'~'+ ar.get('Status__c')+
												'~' +ar.get('month')+'~'+ar.get('year')):0.00;
												
			decimal discoLine = discProjectionMap.get(ar.get('Category__c')+'~'+ ar.get('Status__c')+
												'~' +ar.get('month')+'~'+ar.get('year')) !=null ?
								discProjectionMap.get(ar.get('Category__c')+'~'+ ar.get('Status__c')+
												'~' +ar.get('month')+'~'+ar.get('year')):0.00;
												
			decimal manualLine= ManualProjectionMap.get(ar.get('Category__c')+'~'+ ar.get('Status__c')+
												'~' +ar.get('month')+'~'+ar.get('year')) !=null ?
								ManualProjectionMap.get(ar.get('Category__c')+'~'+ ar.get('Status__c')+
												'~' +ar.get('month')+'~'+ar.get('year')):0.00;
			//Logic to create values
			decimal newBaselineValue = 	baseline+newLine+manualLine-discoLine;	
			//Start of Air Care				
			if(ar.get('Category__c')=='Air Care'){
				if(ar.get('Status__c')=='Active & Planned'){
					string monthVal = ar.get('month')+'';
					string yearVal = ar.get('year')+'';
					//load Active values
					airCareActiveMap.put('Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal
										,newBaselineValue);
										
					//Update baseline for next itreation of Active
					baseLineMap.put(ar.get('Category__c')+'~'+ar.get('Status__c'),newBaselineValue);
					
					//If value exist in the RemnantMap
					if(airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
						//Remnant value in the map with newBaselineValue
						decimal tmVal = airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)+
													newBaselineValue;
						airCareMap.put('Aircare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal );
					
					}
					else{
						airCareMap.put('Aircare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
					}
				}
				//load Remnant
				if(ar.get('Status__c')=='Remnant & Historical'){
					//load Active values
					string monthVal = ar.get('month')+'';
					string yearVal = ar.get('year')+'';
					airCareRemnantMap.put('Aircare~R & H~' +calendarmap.get(monthVal)+'-'+yearVal
									,newBaselineValue);
									
					//Update baseline for next itreation of Remnant
					baseLineMap.put(ar.get('Category__c')+'~'+ar.get('Status__c'),newBaselineValue);
					
					//If value exist in the ActiveMap
					if(airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
						//Active value in the map with newBaselineValue
						decimal tmVal = airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)+
													newBaselineValue;
						airCareMap.put('Aircare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal);
					}
					else{
						airCareMap.put('Aircare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
					}
					
				}
			} 
			//End Of Air care
			//Start of DishCare
			if(ar.get('Category__c')=='Dish Care'){
				if(ar.get('Status__c')=='Active & Planned'){
					string monthVal = ar.get('month')+'';
					string yearVal = ar.get('year')+'';
					//load Active values
					dishCareActiveMap.put('Dishcare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal
										,newBaselineValue);
										
					//Update baseline for next itreation of Active
					baseLineMap.put(ar.get('Category__c')+'~'+ar.get('Status__c'),newBaselineValue);
					
					//If value exist in the RemnantMap
					if(dishCareRemnantMap.get('Dishcare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
						//Remnant value in the map with newBaselineValue
						decimal tmVal = airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)+
													newBaselineValue;
						dishCareMap.put('Dishcare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal );
					
					}
					else{
						dishCareMap.put('Dishcare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
					}
				}
				//load Remnant
				if(ar.get('Status__c')=='Remnant & Historical'){
					//load Active values
					string monthVal = ar.get('month')+'';
					string yearVal = ar.get('year')+'';
					dishCareRemnantMap.put('Dishcare~R & H~' +calendarmap.get(monthVal)+'-'+yearVal
									,newBaselineValue);
									
					//Update baseline for next itreation of Remnant
					baseLineMap.put(ar.get('Category__c')+'~'+ar.get('Status__c'),newBaselineValue);
					
					//If value exist in the ActiveMap
					if(dishCareActiveMap.get('Dishcare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
						//Active value in the map with newBaselineValue
						decimal tmVal = airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)+
													newBaselineValue;
						dishCareMap.put('Dishcare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal);
					}
					else{
						dishCareMap.put('Dishcare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
					}
					
				}
			} 
			//End Of Dishcare
			//Start of Surface Care
			if(ar.get('Category__c')=='Surface Care'){
				if(ar.get('Status__c')=='Active & Planned'){
					string monthVal = ar.get('month')+'';
					string yearVal = ar.get('year')+'';
					//load Active values
					surfaceCareActiveMap.put('Surfacecare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal
										,newBaselineValue);
										
					//Update baseline for next itreation of Active
					baseLineMap.put(ar.get('Category__c')+'~'+ar.get('Status__c'),newBaselineValue);
					
					//If value exist in the RemnantMap
					if(surfaceCareRemnantMap.get('Surfacecare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
						//Remnant value in the map with newBaselineValue
						decimal tmVal = airCareRemnantMap.get('Surfacecare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)+
													newBaselineValue;
						surfaceCareMap.put('Surfacecare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal );
					
					}
					else{
						surfaceCareMap.put('Surfacecare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
					}
				}
				//load Remnant
				if(ar.get('Status__c')=='Remnant & Historical'){
					//load Active values
					string monthVal = ar.get('month')+'';
					string yearVal = ar.get('year')+'';
					surfaceCareRemnantMap.put('Surfacecare~R & H~' +calendarmap.get(monthVal)+'-'+yearVal
									,newBaselineValue);
									
					//Update baseline for next itreation of Remnant
					baseLineMap.put(ar.get('Category__c')+'~'+ar.get('Status__c'),newBaselineValue);
					
					//If value exist in the ActiveMap
					if(surfaceCareActiveMap.get('Surfacecare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
						//Active value in the map with newBaselineValue
						decimal tmVal = airCareActiveMap.get('Surfacecare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)+
													newBaselineValue;
						surfaceCareMap.put('Surfacecare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal);
					}
					else{
						surfaceCareMap.put('Surfacecare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
					}
					
				}
			} 
			//End of Surface care
		}
		//Adding values to map
		if(selCat!=null && selCat.size()>0){
			for(integer i=0; i<selCat.size(); i++){
				System.debug('selCat=i=='+selCat[i]);
				if(selCat[i] == 'Dishcare'){
					dWrap2.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,null));
				}else if(selCat[i] == 'Surfacecare'){
					dWrap2.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,null));
				}else if(selCat[i] == 'Aircare'){
					dWrap2.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,null));
				}
			}
			outputMap.put('Future Projections',dWrap2);//Put values in display Map
		}
		
		for(String str : outputMap.keySet())
		{
			//for(String key :airCareMap.keySet())
			//{
			system.debug('str==='+str+' === '+outputMap.get(str));
			//}
		}
		system.debug('outputMap==='+outputMap);
		
		return outputMap;
	}*/
	//end of main method
	//Future Projections
	public static map<string,decimal> grandTotalsFutureProjections(set<string> selectedCate,set<string> selectedLC, set<string> selectedBrand,date stDate,date endDate,string projStatus){
		map<string,decimal> grandTotalMap = new map<string,decimal>();
		if(stDate==null || endDate==null){
			date dtTemp;
			integer month;
			integer Year ;
			//Start date today - 12 months
			dtTemp = system.today().addMonths(-12);
			month = dtTemp.month();
			Year = dtTemp.Year();
			stDate =  Date.newInstance(Year, month, 1); //1st of month
			//End date today - last month
			dtTemp = system.today().addMonths(-1);
			month = dtTemp.month();
			Year = dtTemp.Year();
			endDate = Date.newInstance(Year, month, 31); //31 st of last month
		}
		//group by category and life cycle
		/*
		AggregateResult[] totalproducts =[SELECT  count(id)projections,SKU__r.Category__c,SKU__r.Status__c,
											CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
											 FROM SKU_Projection__c
											 Where Include_in_Projections__c=true and
											 		SKU__r.Category__c in:selectedCate and
											 		SKU__r.Status__c in:selectedLC and
											 		SKU__r.Dish_Care_Group__c IN:selectedBrand and
											 		Projected_date__c >=: stDate and Projected_date__c<=:endDate  and
											 		Projection_Type__c =:projStatus
											 GROUP BY SKU__r.Category__c,SKU__r.Status__c,CALENDAR_MONTH(Projected_date__c),
											 CALENDAR_Year(Projected_date__c)
											 order by SKU__r.Category__c asc,SKU__r.Status__c asc,
											 CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
		*/
		AggregateResult[] totalproducts =[SELECT  count(id)projections,SKU__r.Category__c,
											CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
											 FROM SKU_Projection__c
											 Where Include_in_Projections__c=true and
											 		SKU__r.Category__c in:selectedCate and
											 		SKU__r.Status__c in:selectedLC and
											 		SKU__r.Dish_Care_Group__c IN:selectedBrand and
											 		Projected_date__c >=: stDate and Projected_date__c<=:endDate  and
											 		Projection_Type__c =:projStatus
											 GROUP BY SKU__r.Category__c,CALENDAR_MONTH(Projected_date__c),
											 CALENDAR_Year(Projected_date__c)
											 order by SKU__r.Category__c asc,
											 CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
		for(AggregateResult ar: totalproducts){
		    grandTotalMap.put(ar.get('Category__c')+'~'+ ar.get('month')+'~'+ar.get('year'),
		    					((Decimal)(ar.get('projections'))));
		}
		return grandTotalMap;
	}
	
	//Group by category and Lifecycle
	//Pass the seleted categories,selected Lifecycle,startdate and end date
	//Return map total for all months 
	public static map<string,decimal> grandTotalsActuals(set<string> selectedCate,set<string> selectedLC, set<String> selBrand,date stDate,date endDate){
		map<string,decimal> grandTotalMap = new map<string,decimal>();
		if(stDate==null || endDate==null){
			date dtTemp;
			integer month;
			integer Year ;
			//Start date today - 12 months
			dtTemp = system.today().addMonths(-12);
			month = dtTemp.month();
			Year = dtTemp.Year();
			stDate =  Date.newInstance(Year, month, 1); //1st of month
			//End date today - last month
			dtTemp = system.today().addMonths(-1);
			month = dtTemp.month();
			Year = dtTemp.Year();
			endDate = Date.newInstance(Year, month, 31); //31 st of last month
		}
		//group by category and life cycle
		
		system.debug('selectedCate===@@==='+selectedCate);
		system.debug('selectedLC===@@==='+selectedLC);
		system.debug('selBrand===@@==='+selBrand);
		//system.debug('selectedCate===@@==='+selectedCate);
		AggregateResult[] totalproducts =[SELECT  Actual_Status__c, SKU_Category__c, CALENDAR_MONTH(Date__c)month,  
											CALENDAR_Year(Date__c)year,count(id)TotalSkus	
											 from SKU_Actual__c
											 where SKU_Category__c in:selectedCate and
											 Date__c >=: stDate and Date__c<=:endDate and 
											 Status__c in :selectedLC  and
											 SKU__r.Dish_Care_Group__c IN :selBrand
											 group by SKU_Category__c,Actual_Status__c,CALENDAR_MONTH(Date__c),CALENDAR_Year(Date__c)
											 order  by SKU_Category__c asc,Actual_Status__c asc,CALENDAR_MONTH(Date__c) asc,CALENDAR_Year(Date__c) desc];
		for(AggregateResult ar: totalproducts){
		    grandTotalMap.put(ar.get('SKU_Category__c')+'~'+ ar.get('Actual_Status__c')+'~' +ar.get('month')+'~'+ar.get('year'),
		    					((Decimal)(ar.get('TotalSkus'))));
		}
		
		system.debug('grandTotalMap==='+grandTotalMap);
		return grandTotalMap;
	}
	//Past Projections data
	public static map<string,decimal> grandTotalsPastProjections(set<string> selectedCate,set<string> selectedLC,date stDate,date endDate){
		map<string,decimal> grandTotalMap = new map<string,decimal>();
		if(stDate==null || endDate==null){
			date dtTemp;
			integer month;
			integer Year ;
			//Start date today - 12 months
			dtTemp = system.today().addMonths(-12);
			month = dtTemp.month();
			Year = dtTemp.Year();
			stDate =  Date.newInstance(Year, month, 1); //1st of month
			//End date today - last month
			dtTemp = system.today().addMonths(-1);
			month = dtTemp.month();
			Year = dtTemp.Year();
			endDate = Date.newInstance(Year, month, 31); //31 st of last month
		}
		
		system.debug('selectedCate==='+selectedCate+'==stDate===='+stDate+'==='+endDate);
		//group by category and life cycle
		AggregateResult[] totalproducts =[SELECT  count(id)projections,SKU__r.Category__c,SKU__r.Status__c,
											CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
											 FROM SKU_Projection__c
											 Where Include_in_Projections__c=true and
											 		SKU__r.Category__c in:selectedCate and
											 		SKU__r.Status__c in:selectedLC and
											 		Projected_date__c >=: stDate and Projected_date__c<=:endDate  
											 GROUP BY SKU__r.Category__c,SKU__r.Status__c,CALENDAR_MONTH(Projected_date__c),
											 CALENDAR_Year(Projected_date__c)
											 order by SKU__r.Category__c asc,SKU__r.Status__c asc,
											 CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
		for(AggregateResult ar: totalproducts){
		    grandTotalMap.put(ar.get('Category__c')+'~'+ ar.get('Status__c')+'~' +ar.get('month')+'~'+ar.get('year'),
		    					((Decimal)(ar.get('projections'))));
		}
		return grandTotalMap;
	}
		
	@AuraEnabled
	public static list<dataWrapper> getTableData(String[] selCat,String[] selLCycle,string[] selBrand,date startDT,date endDt){
		List<dataWrapper> dWrap = new list<dataWrapper>();
		system.debug('*****selBrand******'+selBrand);
		system.debug('*****startDT******'+startDT);
		system.debug('*****endDt******'+endDt);
		
		Map<String,decimal> airCareMap = new Map<String,decimal>();
		Map<String,decimal> airCareActiveMap = new Map<String,decimal>();
		Map<String,decimal> airCareRemnantMap = new Map<String,decimal>();
		
		airCareMap.put('Aircare~Jan-17',406); airCareMap.put('Aircare~Feb-17',480); 
		airCareMap.put('Aircare~Mar-17',492); airCareMap.put('Aircare~Apr-17',481); 
		airCareMap.put('Aircare~May-17',464); airCareMap.put('Aircare~Jun-17',456); 
		airCareMap.put('Aircare~Jul-16',491); airCareMap.put('Aircare~Aug-16',493); 
		airCareMap.put('Aircare~Sep-16',496); airCareMap.put('Aircare~Oct-16',500); 
		airCareMap.put('Aircare~Nov-16',491); airCareMap.put('Aircare~Dec-16',493);

		Map<String,decimal> dishCareMap = new Map<String,decimal>();
		Map<String,decimal> dishCareActiveMap = new Map<String,decimal>();
		Map<String,decimal> dishCareRemnantMap = new Map<String,decimal>();
		
		dishCareMap.put('Dishcare~Jan-17',406); dishCareMap.put('Dishcare~Feb-17',480); 
		dishCareMap.put('Dishcare~Mar-17',492); dishCareMap.put('Dishcare~Apr-17',481); 
		dishCareMap.put('Dishcare~May-17',464); dishCareMap.put('Dishcare~Jun-17',456); 
		dishCareMap.put('Dishcare~Jul-16',491); dishCareMap.put('Dishcare~Aug-16',493); 
		dishCareMap.put('Dishcare~Sep-16',496); dishCareMap.put('Dishcare~Oct-16',500); 
		dishCareMap.put('Dishcare~Nov-16',491); dishCareMap.put('Dishcare~Dec-16',493);

		Map<String,decimal> surfaceCareMap = new Map<String,decimal>();
		Map<String,decimal> surfaceCareActiveMap = new Map<String,decimal>();
		Map<String,decimal> surfaceCareRemnantMap = new Map<String,decimal>();
		
		surfaceCareMap.put('Surfacecare~Jan-17',406); surfaceCareMap.put('Surfacecare~Feb-17',480); 
		surfaceCareMap.put('Surfacecare~Mar-17',492); surfaceCareMap.put('Surfacecare~Apr-17',481); 
		surfaceCareMap.put('Surfacecare~May-17',464); surfaceCareMap.put('Surfacecare~Jun-17',456); 
		surfaceCareMap.put('Surfacecare~Jul-16',491); surfaceCareMap.put('Surfacecare~Aug-16',493); 
		surfaceCareMap.put('Surfacecare~Sep-16',496); surfaceCareMap.put('Surfacecare~Oct-16',500); 
		surfaceCareMap.put('Surfacecare~Nov-16',491); surfaceCareMap.put('Surfacecare~Dec-16',493);

		//dWrap.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap));
		//dWrap.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap));
		//dWrap.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap));
		
		
		System.debug('selCat==='+selCat);
		system.debug('selLCycle==='+selLCycle);
		if(selLCycle!=null && selLCycle.size()>0)
		{
			//airCareActiveMap = new Map<String,decimal>();
			//airCareRemnantMap = new Map<String,decimal>();
			//dishCareActiveMap = new Map<String,decimal>();
			//dishCareRemnantMap = new Map<String,decimal>();
			//surfaceCareActiveMap = new Map<String,decimal>();
			//surfaceCareRemnantMap = new Map<String,decimal>();

			for(integer i=0; i<selLCycle.size(); i++)
			{
				if(selLCycle[i] == 'AP')
				{
					airCareActiveMap.put('Aircare~A & P~Jan-17',77); airCareActiveMap.put('Aircare~A & P~Feb-17',87); 
					airCareActiveMap.put('Aircare~A & P~Mar-17',93); airCareActiveMap.put('Aircare~A & P~Apr-17',7); 
					airCareActiveMap.put('Aircare~A & P~May-17',95); airCareActiveMap.put('Aircare~A & P~Jun-17',8); 
					airCareActiveMap.put('Aircare~A & P~Jul-16',71); airCareActiveMap.put('Aircare~A & P~Aug-16',62); 
					airCareActiveMap.put('Aircare~A & P~Sep-16',73); airCareActiveMap.put('Aircare~A & P~Oct-16',62); 
					airCareActiveMap.put('Aircare~A & P~Nov-16',50); airCareActiveMap.put('Aircare~A & P~Dec-16',0);

					dishCareActiveMap.put('Dishcare~A & P~Jan-17',27); dishCareActiveMap.put('Dishcare~A & P~Feb-17',28); 
					dishCareActiveMap.put('Dishcare~A & P~Mar-17',29); dishCareActiveMap.put('Dishcare~A & P~Apr-17',30); 
					dishCareActiveMap.put('Dishcare~A & P~May-17',29); dishCareActiveMap.put('Dishcare~A & P~Jun-17',30); 
					dishCareActiveMap.put('Dishcare~A & P~Jul-16',27); dishCareActiveMap.put('Dishcare~A & P~Aug-16',26); 
					dishCareActiveMap.put('Dishcare~A & P~Sep-16',27); dishCareActiveMap.put('Dishcare~A & P~Oct-16',26); 
					dishCareActiveMap.put('Dishcare~A & P~Nov-16',25); dishCareActiveMap.put('Dishcare~A & P~Dec-16',30);

					surfaceCareActiveMap.put('Surfacecare~A & P~Jan-17',27); surfaceCareActiveMap.put('Surfacecare~A & P~Feb-17',27); 
					surfaceCareActiveMap.put('Surfacecare~A & P~Mar-17',23); surfaceCareActiveMap.put('Surfacecare~A & P~Apr-17',37); 
					surfaceCareActiveMap.put('Surfacecare~A & P~May-17',25); surfaceCareActiveMap.put('Surfacecare~A & P~Jun-17',38); 
					surfaceCareActiveMap.put('Surfacecare~A & P~Jul-16',21); surfaceCareActiveMap.put('Surfacecare~A & P~Aug-16',22); 
					surfaceCareActiveMap.put('Surfacecare~A & P~Sep-16',23); surfaceCareActiveMap.put('Surfacecare~A & P~Oct-16',22); 
					surfaceCareActiveMap.put('Surfacecare~A & P~Nov-16',20); surfaceCareActiveMap.put('Surfacecare~A & P~Dec-16',30);

				}else if(selLCycle[i] == 'RH')
				{
					airCareRemnantMap.put('Aircare~R & H~Jan-17',329); airCareRemnantMap.put('Aircare~R & H~Feb-17',393); 
					airCareRemnantMap.put('Aircare~R & H~Mar-17',399); airCareRemnantMap.put('Aircare~R & H~Apr-17',474); 
					airCareRemnantMap.put('Aircare~R & H~May-17',369); airCareRemnantMap.put('Aircare~R & H~Jun-17',448); 
					airCareRemnantMap.put('Aircare~R & H~Jul-16',420); airCareRemnantMap.put('Aircare~R & H~Aug-16',431); 
					airCareRemnantMap.put('Aircare~R & H~Sep-16',423); airCareRemnantMap.put('Aircare~R & H~Oct-16',438); 
					airCareRemnantMap.put('Aircare~R & H~Nov-16',441); airCareRemnantMap.put('Aircare~R & H~Dec-16',493);

					dishCareRemnantMap.put('Dishcare~R & H~Jan-17',129); dishCareRemnantMap.put('Dishcare~R & H~Feb-17',193); 
					dishCareRemnantMap.put('Dishcare~R & H~Mar-17',199); dishCareRemnantMap.put('Dishcare~R & H~Apr-17',174); 
					dishCareRemnantMap.put('Dishcare~R & H~May-17',169); dishCareRemnantMap.put('Dishcare~R & H~Jun-17',148); 
					dishCareRemnantMap.put('Dishcare~R & H~Jul-16',220); dishCareRemnantMap.put('Dishcare~R & H~Aug-16',231); 
					dishCareRemnantMap.put('Dishcare~R & H~Sep-16',223); dishCareRemnantMap.put('Dishcare~R & H~Oct-16',238); 
					dishCareRemnantMap.put('Dishcare~R & H~Nov-16',241); dishCareRemnantMap.put('Dishcare~R & H~Dec-16',193);

					surfaceCareRemnantMap.put('Surfacecare~R & H~Jan-17',129); surfaceCareRemnantMap.put('Surfacecare~R & H~Feb-17',193); 
					surfaceCareRemnantMap.put('Surfacecare~R & H~Mar-17',199); surfaceCareRemnantMap.put('Surfacecare~R & H~Apr-17',174); 
					surfaceCareRemnantMap.put('Surfacecare~R & H~May-17',169); surfaceCareRemnantMap.put('Surfacecare~R & H~Jun-17',148); 
					surfaceCareRemnantMap.put('Surfacecare~R & H~Jul-16',220); surfaceCareRemnantMap.put('Surfacecare~R & H~Aug-16',231); 
					surfaceCareRemnantMap.put('Surfacecare~R & H~Sep-16',223); surfaceCareRemnantMap.put('Surfacecare~R & H~Oct-16',238); 
					surfaceCareRemnantMap.put('Surfacecare~R & H~Nov-16',241); surfaceCareRemnantMap.put('Surfacecare~R & H~Dec-16',193);
				}
			}

			
		}//else{
			//airCareActiveMap.put('Aircare~A & P~Jan-16',77); airCareActiveMap.put('Aircare~A & P~Feb-16',87); 
			//airCareActiveMap.put('Aircare~A & P~Mar-16',93); airCareActiveMap.put('Aircare~A & P~Apr-16',7); 
			//airCareActiveMap.put('Aircare~A & P~May-16',95); airCareActiveMap.put('Aircare~A & P~Jun-16',8); 
			//airCareActiveMap.put('Aircare~A & P~Jul-16',71); airCareActiveMap.put('Aircare~A & P~Aug-16',62); 
			//airCareActiveMap.put('Aircare~A & P~Sep-16',73); airCareActiveMap.put('Aircare~A & P~Oct-16',62); 
			//airCareActiveMap.put('Aircare~A & P~Nov-16',50); airCareActiveMap.put('Aircare~A & P~Dec-16',0);

			//dishCareActiveMap.put('Dishcare~A & P~Jan-16',27); dishCareActiveMap.put('Dishcare~A & P~Feb-16',28); 
			//dishCareActiveMap.put('Dishcare~A & P~Mar-16',29); dishCareActiveMap.put('Dishcare~A & P~Apr-16',30); 
			//dishCareActiveMap.put('Dishcare~A & P~May-16',29); dishCareActiveMap.put('Dishcare~A & P~Jun-16',30); 
			//dishCareActiveMap.put('Dishcare~A & P~Jul-16',27); dishCareActiveMap.put('Dishcare~A & P~Aug-16',26); 
			//dishCareActiveMap.put('Dishcare~A & P~Sep-16',27); dishCareActiveMap.put('Dishcare~A & P~Oct-16',26); 
			//dishCareActiveMap.put('Dishcare~A & P~Nov-16',25); dishCareActiveMap.put('Dishcare~A & P~Dec-16',30);

			//surfaceCareActiveMap.put('Surfacecare~A & P~Jan-16',27); surfaceCareActiveMap.put('Surfacecare~A & P~Feb-16',27); 
			//surfaceCareActiveMap.put('Surfacecare~A & P~Mar-16',23); surfaceCareActiveMap.put('Surfacecare~A & P~Apr-16',37); 
			//surfaceCareActiveMap.put('Surfacecare~A & P~May-16',25); surfaceCareActiveMap.put('Surfacecare~A & P~Jun-16',38); 
			//surfaceCareActiveMap.put('Surfacecare~A & P~Jul-16',21); surfaceCareActiveMap.put('Surfacecare~A & P~Aug-16',22); 
			//surfaceCareActiveMap.put('Surfacecare~A & P~Sep-16',23); surfaceCareActiveMap.put('Surfacecare~A & P~Oct-16',22); 
			//surfaceCareActiveMap.put('Surfacecare~A & P~Nov-16',20); surfaceCareActiveMap.put('Surfacecare~A & P~Dec-16',30);


			//airCareRemnantMap.put('Aircare~R & H~Jan-16',329); airCareRemnantMap.put('Aircare~R & H~Feb-16',393); 
			//airCareRemnantMap.put('Aircare~R & H~Mar-16',399); airCareRemnantMap.put('Aircare~R & H~Apr-16',474); 
			//airCareRemnantMap.put('Aircare~R & H~May-16',369); airCareRemnantMap.put('Aircare~R & H~Jun-16',448); 
			//airCareRemnantMap.put('Aircare~R & H~Jul-16',420); airCareRemnantMap.put('Aircare~R & H~Aug-16',431); 
			//airCareRemnantMap.put('Aircare~R & H~Sep-16',423); airCareRemnantMap.put('Aircare~R & H~Oct-16',438); 
			//airCareRemnantMap.put('Aircare~R & H~Nov-16',441); airCareRemnantMap.put('Aircare~R & H~Dec-16',493);

			//dishCareRemnantMap.put('Dishcare~R & H~Jan-16',129); dishCareRemnantMap.put('Dishcare~R & H~Feb-16',193); 
			//dishCareRemnantMap.put('Dishcare~R & H~Mar-16',199); dishCareRemnantMap.put('Dishcare~R & H~Apr-16',174); 
			//dishCareRemnantMap.put('Dishcare~R & H~May-16',169); dishCareRemnantMap.put('Dishcare~R & H~Jun-16',148); 
			//dishCareRemnantMap.put('Dishcare~R & H~Jul-16',220); dishCareRemnantMap.put('Dishcare~R & H~Aug-16',231); 
			//dishCareRemnantMap.put('Dishcare~R & H~Sep-16',223); dishCareRemnantMap.put('Dishcare~R & H~Oct-16',238); 
			//dishCareRemnantMap.put('Dishcare~R & H~Nov-16',241); dishCareRemnantMap.put('Dishcare~R & H~Dec-16',193);

			//surfaceCareRemnantMap.put('Surfacecare~R & H~Jan-16',129); surfaceCareRemnantMap.put('Surfacecare~R & H~Feb-16',193); 
			//surfaceCareRemnantMap.put('Surfacecare~R & H~Mar-16',199); surfaceCareRemnantMap.put('Surfacecare~R & H~Apr-16',174); 
			//surfaceCareRemnantMap.put('Surfacecare~R & H~May-16',169); surfaceCareRemnantMap.put('Surfacecare~R & H~Jun-16',148); 
			//surfaceCareRemnantMap.put('Surfacecare~R & H~Jul-16',220); surfaceCareRemnantMap.put('Surfacecare~R & H~Aug-16',231); 
			//surfaceCareRemnantMap.put('Surfacecare~R & H~Sep-16',223); surfaceCareRemnantMap.put('Surfacecare~R & H~Oct-16',238); 
			//surfaceCareRemnantMap.put('Surfacecare~R & H~Nov-16',241); surfaceCareRemnantMap.put('Surfacecare~R & H~Dec-16',193);
		//}

			System.debug('airCareActiveMap==='+airCareActiveMap);
			System.debug('dishCareActiveMap==='+dishCareActiveMap);
			System.debug('surfaceCareActiveMap==='+surfaceCareActiveMap);
			System.debug('airCareRemnantMap==='+airCareRemnantMap);
			System.debug('dishCareRemnantMap==='+dishCareRemnantMap);
			System.debug('surfaceCareRemnantMap==='+surfaceCareRemnantMap);
		if(selCat!=null && selCat.size()>0)
		{
			dWrap = new list<dataWrapper>();
			for(integer i=0; i<selCat.size(); i++)
			{
				
				System.debug('selCat=i=='+selCat[i]);
				if(selCat[i] == 'Dishcare')
				{
					dWrap.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,null));
				}else if(selCat[i] == 'Surfacecare')
				{
					dWrap.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,null));
				}else if(selCat[i] == 'Aircare')
				{
					dWrap.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,null));
				}
			}
		}

		System.debug('dWrap==='+dWrap);
		return dWrap;
	}
	
	public class headingWrapper
    {
        @AuraEnabled
     	public String strDate;
                
        public headingWrapper(String strDate){
            this.strDate = strDate;
        }
    }

	@AuraEnabled
    public static headingWrapper[] tableHeadingsData(){
		headingWrapper[] wrapperList = new headingWrapper[]{};
		/*PG Fiscal year*/
		wrapperList.add(new headingWrapper('Jun-2016'));
		wrapperList.add(new headingWrapper('Jul-2016')); wrapperList.add(new headingWrapper('Aug-2016')); wrapperList.add(new headingWrapper('Sep-2016'));
		wrapperList.add(new headingWrapper('Oct-2016')); wrapperList.add(new headingWrapper('Nov-2016')); wrapperList.add(new headingWrapper('Dec-2016'));
		wrapperList.add(new headingWrapper('Jan-2017')); wrapperList.add(new headingWrapper('Feb-2017')); wrapperList.add(new headingWrapper('Mar-2017'));
		wrapperList.add(new headingWrapper('Apr-2017')); wrapperList.add(new headingWrapper('May-2017')); 
		return wrapperList;
	}
	
	
	@AuraEnabled
	public static map<string,dataHeaderWrapper> loadData1(String[] selCat,String[] selLCycle,string[] selBrand,date startDT,date endDt, String sDate, String eDate){
		//outputlist of all lists 
		//Key with be Actuals,Projection and Projection2
		
		map<string,dataHeaderWrapper> outputMap = new map<string,dataHeaderWrapper> ();	 
		//Aircare maps
		map<String,decimal> airCareMap = new map<String,decimal>();
		map<String,decimal> airCareActiveMap = new map<String,decimal>();
		map<String,decimal> airCareRemnantMap = new map<String,decimal>();
		//Dishcare maps
		map<String,decimal> dishCareMap = new map<String,decimal>();
		map<String,decimal> dishCareActiveMap = new map<String,decimal>();
		map<String,decimal> dishCareRemnantMap = new map<String,decimal>();
		//surface care maps
		map<String,decimal> surfaceCareMap = new map<String,decimal>();
		map<String,decimal> surfaceCareActiveMap = new map<String,decimal>();
		map<String,decimal> surfaceCareRemnantMap = new map<String,decimal>();
		map<String,decimal> AlldataMap = new map<String,decimal>();
		set<string> selectedCate = new set<string>();
		set<string> selectedLC = new set<string>();
		set<String> selectedBrand = new set<String>();
		map<string,string> calendarmap =  new map<string,string>{'1'=>'Jan','2'=>'Feb', '3'=>'Mar', '4'=>'Apr','5'=> 'May', '6'=>'Jun',
		 									 '7'=>'Jul', '8'=>'Aug','9'=> 'Sep','10'=> 'Oct', '11'=>'Nov', '12'=>'Dec'};
		//Categories
		for(integer i =0 ; i< selCat.size();i++){
			if(selCat[i]=='Aircare'){
				selectedCate.add('Air Care');	
			}
			else if(selCat[i]=='Dishcare'){
				selectedCate.add('Dish Care');
			}
			else if(selCat[i]=='Surfacecare'){
				selectedCate.add('Surface Care');
			}
		}
		//Life cycles
		for(integer j=0;j<selLCycle.size();j++){
			if(selLCycle[j]=='AP'){
				selectedLC.add('Active & Planned');	
			}
			else if(selLCycle[j]=='RH'){
				selectedLC.add('Remnant & Historical');
			}
		}
		
		for(integer j=0;j<selBrand.size();j++){
			if(selBrand[j]=='AllAirCare'){
				selectedBrand.add('All Air Care');
			}else if(selBrand[j]=='ADW'){
				selectedBrand.add('ADW');
			}else if(selBrand[j]=='HDW'){
				selectedBrand.add('HDW');
			}else if(selBrand[j]=='MrClean'){
				selectedBrand.add('Mr Clean');
			}else if(selBrand[j]=='Swiffer'){
				selectedBrand.add('Swiffer');
			}
		}
		
		headingWrapper[] wrapperList = new headingWrapper[]{};
		List<String> dateHeadings = new list<String>();
		system.debug('startDT==='+startDT+' ==== '+endDt+'===sDate==='+sDate+'==eDate=='+eDate);
		//Process the Actual Data
		
		//========================== Headings======================
		Date stDate;
		Date endDate;
		if(sDate==null || eDate==null){
			date dtTemp;
			integer month;
			integer Year ;
			//Start date today - 12 months
			dtTemp = system.today().addMonths(-12);
			month = dtTemp.month();
			Year = dtTemp.Year();
			stDate =  Date.newInstance(Year, month, 1); //1st of month
			//End date today - last month
			dtTemp = system.today().addMonths(-1);
			month = dtTemp.month();
			Year = dtTemp.Year();
			endDate = Date.newInstance(Year, month, 31); //31 st of last month
		}else
		{
			stDate = date.valueOf(sDate);
			endDate = date.valueOf(eDate);
		}
		system.debug('stDate==='+stDate+'=='+endDate);
		Date startOfMonth1 = endDate;
		Date startOfNextMonth = stDate;
		
	
	
		while(startOfNextMonth <= startOfMonth1)
		{
			String strDate = startOfNextMonth+'';
			DateTime dt = DateTime.valueOf(strDate);
			//strDate = dt.format('MMMMM YYYY');
			strDate = dt.format('MMM-YYYY');
			system.debug('strDate==='+strDate);
			dateHeadings.add(strDate);
			wrapperList.add(new headingWrapper(strDate));
			startOfNextMonth = startOfNextMonth.AddMonths(1);
		}
		system.debug('dateHeadings==='+dateHeadings);
		//========================== Headings======================
			
		if(sDate!=null && sDate!='')
			AlldataMap = LineChartController.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,date.valueOf(sDate),date.valueOf(eDate));
		else
			AlldataMap = LineChartController.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,startDT,endDt);
		
		for(string echKey : AlldataMap.keyset()){
			
			list<string> tempLst = new list<string>();
			//Air Care~Active & Planned~10~2016=307
			tempLst =echKey.split('~');
			if(tempLst!=null && tempLst.size() > 0){
				//Building AirCare Maps
				if(tempLst[0]=='Air Care'){
					//Load all Air care in Map
					if(tempLst[1]=='Active & Planned'){
						//Active values
						airCareActiveMap.put('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
						//Check airCareRemnantMap if value already exists				
						if(airCareRemnantMap.containsKey('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Aircare active
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
					if(tempLst[1]=='Remnant & Historical'){
						//load the airCareRemnantMap 
						airCareRemnantMap.put('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
						//Check the airCareActiveMap  map
						if(airCareActiveMap.containsKey('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Aircare Remnant
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}				
					}
				}
				//END of Aircare
				////Building Dishcare Maps  
				else if(tempLst[0]=='Dish Care'){
					//Dishcare Active items
					if(tempLst[1]=='Active & Planned'){
						dishCareActiveMap.put('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
					//Check dishCareRemnantMap if value already exists				
						if(dishCareRemnantMap.containsKey('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = dishCareRemnantMap.get('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only dishCare Active 
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
					//Dishcare Remnant items
					if(tempLst[1]=='Remnant & Historical'){
						//Remnant in Dishcare
						dishCareRemnantMap.put('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the dishCareActiveMap in Discare
						if(dishCareActiveMap.containsKey('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = dishCareActiveMap.get('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Remnant
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}	
					}
				}
				//End of Dishcare
				//Start of Surfacecare Maps
				else if(tempLst[0]=='Surface Care'){
					//Load all Air care in Map
					if(tempLst[1]=='Active & Planned'){
						surfaceCareActiveMap.put('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the surfaceCareRemnantMap  in Surfacecare	
						if(surfaceCareRemnantMap.containsKey('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = surfaceCareRemnantMap.get('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only active to surfaceCareMap
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
				
					if(tempLst[1]=='Remnant & Historical'){
						//Load the Remnant map in Surfacecare
						surfaceCareRemnantMap.put('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the surfaceCareActiveMap  in Remnant
						if(surfaceCareActiveMap.containsKey('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = surfaceCareActiveMap.get('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Remnant to surfaceCareMap
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}	
					}
				}
				//End of Dishcare
			}
		}
		list<dataWrapper> dWrap = new list<dataWrapper>();
		if(selCat!=null && selCat.size()>0){
			for(integer i=0; i<selCat.size(); i++){
				System.debug('selCat=i=='+selCat[i]);
				if(selCat[i] == 'Dishcare'){
					dWrap.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,dateHeadings));
				}else if(selCat[i] == 'Surfacecare'){
					dWrap.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,dateHeadings));
				}else if(selCat[i] == 'Aircare'){
					dWrap.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,dateHeadings));
				}
			}
			dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap,dateHeadings);
			outputMap.put('Actuals',wrapObj);//Put values in display Map
		}
		
		for(String key :airCareMap.keySet())
		{
			system.debug('key==='+key+' === '+airCareMap.get(key));
		}
		system.debug('outputMap==='+outputMap);
		
		//End of Actuals data
		//Clear the data
		list<dataWrapper> dWrap1 = new list<dataWrapper>();
		//dWrap.clear();
		airCareActiveMap = new map<String,decimal>();
		airCareMap = new map<String,decimal>();
		
		airCareRemnantMap = new map<String,decimal>();
		dishCareActiveMap = new map<String,decimal>();
		dishCareRemnantMap = new map<String,decimal>();
		dishCareMap = new map<String,decimal>();
		surfaceCareActiveMap = new map<String,decimal>();
		surfaceCareRemnantMap = new map<String,decimal>();
		surfaceCareMap = new map<String,decimal>();
		//*******************************************Past Projection******************************************************
		//Start of Past Projections
		if(sDate!=null && sDate!='')
			AlldataMap = LineChartController.grandTotalsPastProjections(selectedCate,selectedLC,date.valueOf(sDate),date.valueOf(eDate));
		else
			AlldataMap = LineChartController.grandTotalsPastProjections(selectedCate,selectedLC,startDT,endDt);
		system.debug('AlldataMap==='+AlldataMap);
		for(string echKey : AlldataMap.keyset()){
			system.debug('echKey==='+echKey+'===='+AlldataMap.get(echKey));
			list<string> tempLst = new list<string>();
			//Air Care~Active & Planned~10~2016=307
			tempLst =echKey.split('~');
			if(tempLst!=null && tempLst.size() > 0){
				//Building AirCare Maps
				if(tempLst[0]=='Air Care'){
					//Load all Air care in Map
					if(tempLst[1]=='Active & Planned'){
						//Active values
						airCareActiveMap.put('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
						//Check airCareRemnantMap if value already exists				
						if(airCareRemnantMap.containsKey('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Aircare active
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
					
					system.debug('airCareMap==air=='+airCareMap);
					if(tempLst[1]=='Remnant & Historical'){
						//load the airCareRemnantMap 
						airCareRemnantMap.put('Aircare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
						//Check the airCareActiveMap  map
						if(airCareActiveMap.containsKey('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Aircare Remnant
							airCareMap.put('Aircare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}				
					}
				}
				//END of Aircare
				////Building Dishcare Maps  
				else if(tempLst[0]=='Dish Care'){
					//Dishcare Active items
					if(tempLst[1]=='Active & Planned'){
						dishCareActiveMap.put('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
					//Check dishCareRemnantMap if value already exists				
						if(dishCareRemnantMap.containsKey('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = dishCareRemnantMap.get('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only dishCare Active 
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
					//Dishcare Remnant items
					if(tempLst[1]=='Remnant & Historical'){
						//Remnant in Dishcare
						dishCareRemnantMap.put('Dishcare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the dishCareActiveMap in Discare
						if(dishCareActiveMap.containsKey('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = dishCareActiveMap.get('Dishcare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Remnant
							dishCareMap.put('Dishcare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}	
					}
				}
				//End of Dishcare
				//Start of Surfacecare Maps
				else if(tempLst[0]=='Surface Care'){
					//Load all Air care in Map
					if(tempLst[1]=='Active & Planned'){
						surfaceCareActiveMap.put('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the surfaceCareRemnantMap  in Surfacecare	
						if(surfaceCareRemnantMap.containsKey('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							//Add the Rememant and Active
							decimal tmVal = surfaceCareRemnantMap.get('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
													
							//load total						
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only active to surfaceCareMap
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}
					}
				
					if(tempLst[1]=='Remnant & Historical'){
						//Load the Remnant map in Surfacecare
						surfaceCareRemnantMap.put('Surfacecare~R & H~'+calendarmap.get(tempLst[2])+'-'+tempLst[3]
										,AlldataMap.get(echKey));
										
						//Check the surfaceCareActiveMap  in Remnant
						if(surfaceCareActiveMap.containsKey('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])){
							decimal tmVal = surfaceCareActiveMap.get('Surfacecare~A & P~'+calendarmap.get(tempLst[2])+'-'+tempLst[3])+
													AlldataMap.get(echKey);
							//load total						
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											tmVal);
						}
						else{
							//add only Remnant to surfaceCareMap
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(tempLst[2])+'-'+tempLst[3],
											AlldataMap.get(echKey));
						}	
					}
				}
				//End of Dishcare
			}
		}
		//Adding values to map
		if(selCat!=null && selCat.size()>0){
			for(integer i=0; i<selCat.size(); i++){
				System.debug('selCat=i=111='+selCat[i]);
				if(selCat[i] == 'Dishcare'){
					dWrap1.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,null));
				}else if(selCat[i] == 'Surfacecare'){
					dWrap1.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,null));
				}else if(selCat[i] == 'Aircare'){
					dWrap1.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,null));
				}
			}
			dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap1,dateHeadings);
			outputMap.put('Past Projections',wrapObj);//Put values in display Map
		}
		system.debug('airCareMap=11=='+airCareMap);
		for(String key :airCareMap.keySet())
		{
			system.debug('key=11=='+key+' === '+airCareMap.get(key));
		}
		//End of Past Projections
		//Clear data
		list<dataWrapper> dWrap2 = new list<dataWrapper>();
		//dWrap.clear();
		airCareActiveMap = new map<String,decimal>();
		airCareMap = new map<String,decimal>();
		airCareRemnantMap = new map<String,decimal>();
		dishCareActiveMap = new map<String,decimal>();
		dishCareRemnantMap = new map<String,decimal>();
		dishCareMap = new map<String,decimal>();
		surfaceCareActiveMap = new map<String,decimal>();
		surfaceCareRemnantMap = new map<String,decimal>();
		surfaceCareMap = new map<String,decimal>();
		//*******************************************************Future Projections**********************************************
		//Start of Future Projections
		//Logic : Last month actual +projection of current month (new)+projection of current month (manual)
		// Minus projection of current month (disc)  -->base level 
		//next month based level + projection of current month (new)+projection of current month (manual)
		// Minus projection of current month (disc)
		//Default 6 months data
		map<string,decimal> lastMonthActuals = new map<string,decimal> ();
		date dtTemp;
		integer month;
		integer Year ;
		date startDT1; 
		date  endDt1;
		if(sDate!=null && sDate!='')
		{
			startDT = date.valueOf(sDate);
			endDt = date.valueOf(eDate);
		}	
		
		system.debug('endDt==='+endDt +'==='+startDT);
		if(endDt!=null && startDT!=null){
			dtTemp = system.today().addMonths(-1);
			month = dtTemp.month();
			Year = dtTemp.Year();
			startDT1 = Date.newInstance(Year, month, 1);
			endDt1  = Date.newInstance(Year, month, 31);
			//last month Actuals
			lastMonthActuals =LineChartController.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,startDT1,endDt1);
			//Next 6 months of projections
			dtTemp = system.today().addMonths(5);
			month = dtTemp.month();
			Year = dtTemp.Year();
			
			date cdtTemp = system.today().addMonths(1);
			integer cmonth = cdtTemp.month();
			integer cYear = cdtTemp.Year();
			startDT1 = Date.newInstance(cYear, cmonth, 1);
			endDt1  = Date.newInstance(Year, month, 31);
		}
		
		system.debug('startDT1==='+startDT1+'==='+endDt1);
		//integer monthDiff =  startDT1.monthsBetween(endDt1);
		set<string> tempLC = new set<string>{'Projected'};
		map<string,decimal> newProjectionMap = new map<string,decimal>();
		newProjectionMap = LineChartController.grandTotalsFutureProjections(selectedCate,tempLC,selectedBrand,startDT1,endDt1,'New');
		
		set<string> tempLCdisco = new set<string>{'Projected','Active & Planned'};
		map<string,decimal> discProjectionMap = new map<string,decimal>();
		discProjectionMap = LineChartController.grandTotalsFutureProjections(selectedCate,tempLCdisco,selectedBrand,startDT1,endDt1,'Disco');
		
		
		map<string,decimal> ManualProjectionMap = new map<string,decimal>();
		AggregateResult[] totalproducts =[SELECT  count(id)projections,SKU__r.Category__c,SKU__r.Status__c,
											CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
											 FROM SKU_Projection__c
											 Where Include_in_Projections__c=true and
											 		SKU__r.Category__c in:selectedCate and
											 		SKU__r.Status__c in:tempLC and
											 		SKU__r.Dish_Care_Group__c IN:selectedBrand and
											 		Projected_date__c >=: startDT1 and Projected_date__c<=:endDt1  and
											 		Source__c ='Manual'
											 GROUP BY SKU__r.Category__c,SKU__r.Status__c,CALENDAR_MONTH(Projected_date__c),
											 CALENDAR_Year(Projected_date__c)
											 order by SKU__r.Category__c asc,SKU__r.Status__c asc,
											 CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
	 	//End of Future Projections
		for(AggregateResult ar: totalproducts){
		    ManualProjectionMap.put(ar.get('Category__c')+'~'+ar.get('month')+'~'+ar.get('year'),
		    					((Decimal)(ar.get('projections'))));
		}
		map<string,decimal> baseLineMap = new map<string,decimal>();
		
		for(string baseLine:lastMonthActuals.keyset()){
			list<string> tempLst = new list<string>();
			//Air Care~Active & Planned~10~2016=307
			tempLst =baseLine.split('~');
			//prepare based line with Category and Status 
			baseLineMap.put(tempLst[0]+'~'+tempLst[1],lastMonthActuals.get(baseLine));
		}
		system.debug('baseLineMap==='+baseLineMap);
		system.debug('selectedLC==='+selectedLC);
		//Prepare output Map of future data
		/*AggregateResult[] totalproductsFuture =[SELECT  count(id)projections,SKU__r.Category__c,SKU__r.Status__c,
											CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
											 FROM SKU_Projection__c
											 Where Include_in_Projections__c=true and
											 		SKU__r.Category__c in:selectedCate and
											 		SKU__r.Status__c in:tempLC and
											 		SKU__r.Dish_Care_Group__c IN:selectedBrand and
											 		Projected_date__c >=: startDT1 and Projected_date__c<=:endDt1  and
											 		Projection_Type__c ='New'
											 GROUP BY SKU__r.Category__c,SKU__r.Status__c,CALENDAR_MONTH(Projected_date__c),
											 CALENDAR_Year(Projected_date__c)
											 order by SKU__r.Category__c asc,SKU__r.Status__c asc,
											 CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];*/
			date dtTemp1 = system.today().addMonths(-1);
			integer month1 = dtTemp1.month();
			integer Year1 = dtTemp1.Year();
			date startDT12 = Date.newInstance(Year1, month1, 1);
			date endDt12  = Date.newInstance(Year1, month1, 31);
											 
		AggregateResult[] totalproductsFuture =[SELECT  Actual_Status__c, SKU_Category__c, CALENDAR_MONTH(Date__c)month,  
											CALENDAR_Year(Date__c)year,count(id)TotalSkus	
											 from SKU_Actual__c
											 where SKU_Category__c in:selectedCate and
											 Date__c >=: startDT12 and Date__c<=:endDt12 and 
											 Status__c in :selectedLC  and
											 SKU__r.Dish_Care_Group__c IN :selBrand and
											 Date__c!=null
											 group by SKU_Category__c,Actual_Status__c,CALENDAR_MONTH(Date__c),CALENDAR_Year(Date__c)
											 order  by SKU_Category__c asc,Actual_Status__c asc,CALENDAR_MONTH(Date__c) asc,CALENDAR_Year(Date__c) desc];
											 
		//Order collection
		system.debug('totalproductsFuture==='+totalproductsFuture);
		list<futureProjectWrapper> lstOfActuals =new list<futureProjectWrapper>();
		//Prepare empty list for last month
		map<integer,string> categoryMap = new map<integer,string> {1=>'Air Care',2 =>'Dish Care',3 =>'Surface Care'};
		
		for(integer acts=1;acts<4;acts++){
			//load 	Active & Planned
			futureProjectWrapper active = new futureProjectWrapper(); 
			active.skuCategory =categoryMap.get(acts);
			active.skuStatus ='Active & Planned';
			active.skuMonth =month1;
			active.skuYear=Year1;
			//baseLineMap.put(tempLst[0]+'~'+tempLst[1],lastMonthActuals.get(baseLine)
			active.skuTotal=baseLineMap.get(active.skuCategory+'~'+active.skuStatus)!=null ?
							baseLineMap.get(active.skuCategory+'~'+active.skuStatus) : 0;
			lstOfActuals.add(active);
			//load Remnant & Historical
			futureProjectWrapper remant = new futureProjectWrapper();
			remant.skuCategory =categoryMap.get(acts);
			remant.skuStatus ='Remnant & Historical';
			remant.skuMonth = month1;
			remant.skuYear=Year1;
			remant.skuTotal=baseLineMap.get(remant.skuCategory+'~'+remant.skuStatus)!=null ?
								baseLineMap.get(remant.skuCategory+'~'+remant.skuStatus) : 0;
			lstOfActuals.add(remant);
		}
		for(integer setMonthVal=1;setMonthVal<7;setMonthVal++){
			for(futureProjectWrapper ar: lstOfActuals){
				decimal baseline = baseLineMap.get(ar.skuCategory+'~'+ar.skuStatus)!=null ?
									baseLineMap.get(ar.skuCategory+'~'+ar.skuStatus): 0.00;
				integer mpMonth = ar.skuMonth+setMonthVal;					
				decimal newLine = newProjectionMap.get(ar.skuCategory+'~'+mpMonth+'~'+ar.skuYear) !=null ?
									newProjectionMap.get(ar.skuCategory+'~'+mpMonth+'~'+ar.skuYear):0.00;
													
				decimal discoLine = discProjectionMap.get(ar.skuCategory+'~' +mpMonth+'~'+ar.skuYear) !=null ?
									discProjectionMap.get(ar.skuCategory+'~' +mpMonth+'~'+ar.skuYear):0.00;
													
				decimal manualLine= ManualProjectionMap.get(ar.skuCategory+'~' +mpMonth+'~'+ar.skuYear) !=null ?
									ManualProjectionMap.get(ar.skuCategory+'~'+mpMonth+'~'+ar.skuYear):0.00;
									
				//Logic to create values
				decimal newBaselineValue =0.00;	
				if(ar.skuStatus=='Active & Planned'){
					newBaselineValue=baseline+newLine+manualLine-discoLine;
				}
				else{
					newBaselineValue=baseline+discoLine;
				}
				//Start of Air Care				
				if(ar.skuCategory=='Air Care'){
					if(ar.skuStatus=='Active & Planned'){
						string monthVal = mpMonth+'';
						string yearVal = ar.skuYear+'';
						//load Active values
						airCareActiveMap.put('Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal
											,newBaselineValue);
											
						//Update baseline for next itreation of Active
						baseLineMap.put(ar.skuCategory+'~'+ar.skuStatus,newBaselineValue);
						
						//If value exist in the RemnantMap
						if(airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
							//Remnant value in the map with newBaselineValue
							decimal tmVal = airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)!=null ?
											airCareRemnantMap.get('Aircare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)+
														newBaselineValue :newBaselineValue;
							airCareMap.put('Aircare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal );
						
						}
						else{
							airCareMap.put('Aircare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
						}
					}
					//load Remnant
					if(ar.skuStatus=='Remnant & Historical'){
						//load Active values
						string monthVal = mpMonth+'';
						string yearVal = ar.skuYear+'';
						airCareRemnantMap.put('Aircare~R & H~' +calendarmap.get(monthVal)+'-'+yearVal
										,newBaselineValue);
										
						//Update baseline for next itreation of Remnant
						baseLineMap.put(ar.skuCategory+'~'+ar.skuStatus,newBaselineValue);
						
						//If value exist in the ActiveMap
						if(airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
							//Active value in the map with newBaselineValue
							decimal tmVal = airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)!=null ?
											airCareActiveMap.get('Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)+
														newBaselineValue :newBaselineValue;
							airCareMap.put('Aircare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal);
						}
						else{
							airCareMap.put('Aircare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
						}
						
					}
				} 
				//End Of Air care
				//Start of DishCare
				if(ar.skuCategory=='Dish Care'){
					if(ar.skuStatus=='Active & Planned'){
						string monthVal = mpMonth+'';
						string yearVal = ar.skuYear+'';
						//load Active values
						dishCareActiveMap.put('Dishcare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal
											,newBaselineValue);
											
						//Update baseline for next itreation of Active
						baseLineMap.put(ar.skuCategory+'~'+ar.skuStatus,newBaselineValue);
						
						//If value exist in the RemnantMap
						if(dishCareRemnantMap.get('Dishcare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
							//Remnant value in the map with newBaselineValue
							decimal tmVal = dishCareRemnantMap.get('Dishcare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)!=null ?
												dishCareRemnantMap.get('Dishcare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)+
														newBaselineValue :newBaselineValue;
							dishCareMap.put('Dishcare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal );
						
						}
						else{
							dishCareMap.put('Dishcare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
						}
					}
					//load Remnant
					if(ar.skuStatus=='Remnant & Historical'){
						//load Active values
						string monthVal = mpMonth+'';
						string yearVal = ar.skuYear+'';
						dishCareRemnantMap.put('Dishcare~R & H~' +calendarmap.get(monthVal)+'-'+yearVal
										,newBaselineValue);
										
						//Update baseline for next itreation of Remnant
						baseLineMap.put(ar.skuCategory+'~'+ar.skuStatus,newBaselineValue);
						
						//If value exist in the ActiveMap
						if(dishCareActiveMap.get('Dishcare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
							//Active value in the map with newBaselineValue
							decimal tmVal = dishCareActiveMap.get('Dishcare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)!=null ?
											dishCareActiveMap.get('Dishcare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)+
														newBaselineValue :newBaselineValue;
							dishCareMap.put('Dishcare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal);
						}
						else{
							dishCareMap.put('Dishcare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
						}
						
					}
				} 
				//End Of Dishcare
				//Start of Surface Care
				if(ar.skuCategory=='Surface Care'){
					if(ar.skuStatus=='Active & Planned'){
						string monthVal = mpMonth+'';
						string yearVal = ar.skuYear+'';
						//load Active values
						surfaceCareActiveMap.put('Surfacecare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal
											,newBaselineValue);
											
						//Update baseline for next itreation of Active
						baseLineMap.put(ar.skuCategory+'~'+ar.skuStatus,newBaselineValue);
						
						//If value exist in the RemnantMap
						if(surfaceCareRemnantMap.get('Surfacecare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
							//Remnant value in the map with newBaselineValue
							decimal tmVal = airCareRemnantMap.get('Surfacecare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)!=null ? 
											airCareRemnantMap.get('Surfacecare~R & H~'+calendarmap.get(monthVal)+'-'+yearVal)+
														newBaselineValue :newBaselineValue;
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal );
						}
						else{
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
						}
					}
					//load Remnant
					if(ar.skuStatus=='Remnant & Historical'){
						//load Active values
						string monthVal = mpMonth+'';
						string yearVal = ar.skuYear+'';
						system.debug('********ar***'+monthVal +'***'+yearVal);
						surfaceCareRemnantMap.put('Surfacecare~R & H~' +calendarmap.get(monthVal)+'-'+yearVal
										,newBaselineValue);
										
						//Update baseline for next itreation of Remnant
						baseLineMap.put(ar.skuCategory+'~'+ar.skuStatus,newBaselineValue);
						
						//If value exist in the ActiveMap
						if(surfaceCareActiveMap.get('Surfacecare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)!=null){
							//Active value in the map with newBaselineValue
							decimal tmVal = surfaceCareActiveMap.get('Surfacecare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)!=null ?
											 surfaceCareActiveMap.get('Surfacecare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal)+
														newBaselineValue :newBaselineValue;
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(monthVal)+'-'+yearVal,tmVal);
						}
						else{
							surfaceCareMap.put('Surfacecare~'+calendarmap.get(monthVal)+'-'+yearVal,newBaselineValue);
						}
						
					}
				} 
				//End of Surface care
			}
		}
		
		//========================== Headings======================
		Date stDate1;
		Date endDate1;
		date fdtTemp;
		integer fmonth;
		integer fYear ;
		
		stDate = date.valueOf(sDate);
		endDate = date.valueOf(eDate);
		
		system.debug('endDate==='+endDate);
		if(endDate == system.today())
		{
			//stDate1 = system.today().addMonths(+1);
			fdtTemp = system.today();
			fmonth = fdtTemp.month();
			fYear = fdtTemp.Year();
			stDate1 =  Date.newInstance(fYear, fmonth, 1); //1st of month
			
			fdtTemp = stDate1.addMonths(+6);
			fmonth = fdtTemp.month();
			fYear = fdtTemp.Year();
			endDate1 =  Date.newInstance(fYear, fmonth, 1); //1st of month
			
		}else if(endDate > system.today())
		{
			fdtTemp = system.today().addMonths(+1);
			fmonth = fdtTemp.month();
			fYear = fdtTemp.Year();
			stDate1 =  Date.newInstance(fYear, fmonth, 1); //1st of month
			
			fdtTemp = endDate;
			fmonth = fdtTemp.month();
			fYear = fdtTemp.Year();
			endDate1 =  Date.newInstance(fYear, fmonth, 1); //1st of month
		}
		
		system.debug('stDate1==='+stDate1+'=='+endDate1);
		Date endMonth1 = endDate1;
		Date startMonth = stDate1;
		dateHeadings = new list<String>();
		while(startMonth < endMonth1)
		{
			String strDate = startMonth+'';
			DateTime dt = DateTime.valueOf(strDate);
			//strDate = dt.format('MMMMM YYYY');
			strDate = dt.format('MMM-YYYY');
			system.debug('strDate==='+strDate);
			dateHeadings.add(strDate);
			wrapperList.add(new headingWrapper(strDate));
			startMonth = startMonth.AddMonths(1);
		}
		system.debug('dateHeadings==='+dateHeadings);
		//========================== Headings======================
		
		system.debug('dishCareMap==='+dishCareMap);
		system.debug('dishCareActiveMap==='+dishCareActiveMap);
		system.debug('dishCareRemnantMap==='+dishCareRemnantMap);
		system.debug('surfaceCareMap==='+surfaceCareMap);
		system.debug('surfaceCareActiveMap==='+surfaceCareActiveMap);
		//Adding values to map
		if(selCat!=null && selCat.size()>0){
			for(integer i=0; i<selCat.size(); i++){
				System.debug('selCat=i=='+selCat[i]);
				if(selCat[i] == 'Dishcare'){
					dWrap2.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,dateHeadings));
				}else if(selCat[i] == 'Surfacecare'){
					dWrap2.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,dateHeadings));
				}else if(selCat[i] == 'Aircare'){
					dWrap2.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,dateHeadings));
				}
			}
			dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap2,dateHeadings);
			outputMap.put('Future Projections',wrapObj);//Put values in display Map
		}
		
		for(String str : outputMap.keySet())
		{
			//for(String key :airCareMap.keySet())
			//{
			system.debug('str==='+str+' === '+outputMap.get(str));
			//}
		}
		system.debug('outputMap==='+outputMap);
		
		return outputMap;
	}
	//end of main method
	
	@AuraEnabled
    public static SKUDynamicDataWrapper fetchSKUData(String cat,String strgroup,String mon, String status, String[] selBrand, String strType){
		
		system.debug('selBrand==='+selBrand);
		System.debug('cat===='+cat);
		System.debug('strgroup===='+strgroup);
		System.debug('mon===='+mon);
		System.debug('status===='+status);
		String[] arrMon = mon.split('-');
		status = status.replace('&amp;','&');

		map<String,Integer> monthsMap = new map<String,Integer>();
		monthsMap.put('Jan',1);
		monthsMap.put('Feb',2);
		monthsMap.put('Mar',3);
		monthsMap.put('Apr',4);
		monthsMap.put('May',5);
		monthsMap.put('Jun',6);
		monthsMap.put('Jul',7);
		monthsMap.put('Aug',8);
		monthsMap.put('Sep',9);
		monthsMap.put('Oct',10);
		monthsMap.put('Nov',11);
		monthsMap.put('Dec',12);
		
		if(cat=='Surfacecare')
		{
			cat = 'Surface Care';
		}else if(cat=='Dishcare')
		{
			cat = 'Dish Care';
		}else if(cat=='Aircare')
		{
			cat = 'Air Care';
		}
		
		if(status == 'AP')
		{
			status = 'ACTIVE & PLANNED';
		}

		if(status == 'RH')
		{
			status = 'REMNANT & HISTORICAL';
		}
			
		/*
		if(strType == 'CUSTOMISED')
		{
			strType = 'MSO';
		}else
		{
			strType = 'GBU';
		}
		*/
		system.debug('cat==='+cat);
		system.debug('selBrand==='+selBrand);
		system.debug('monthsMap.get(arrMon[0]==='+monthsMap.get(arrMon[0])+'==='+integer.valueOf(arrMon[1]));
		Set<Id> setSKUs = new Set<Id>();
		
		String strQuery = 'Select Id,IsDeleted,Name,LastActivityDate,SKU__c,Date__c,Actual_Status__c,Month__c,SKU_Actual_Unique_Id__c,'+
								' Status__c,EOH_Inventory__c '+ 
								' from SKU_Actual__c';
		if(cat!=null && cat!='')
		{
			strQuery += ' WHERE SKU__r.Category__c = \''+ cat +'\'';
		}
		
		if(selBrand!=null && selBrand.size()>0)
		{
			//strQuery += ' AND SKU__r.Dish_Care_Group__c IN :selBrand ';
			String inClause1 = String.format( '(\'\'{0}\'\')', new List<String> { String.join( new List<String>(selBrand) , '\',\'') });
			System.debug('inClause1===='+inClause1);
			strQuery += ' AND SKU__r.Dish_Care_Group__c IN '+inClause1 ;
		}
		if(status!=null && status!='')
		{
			strQuery += ' AND Actual_Status__c = \''+status +'\'';
		}
		
		strQuery += ' AND CALENDAR_MONTH(Date__c) ='+ monthsMap.get(arrMon[0]) +' AND CALENDAR_YEAR(Date__c) ='+ integer.valueOf(arrMon[1]);
		/*
		for(SKU_Actual__c SA : [Select Id,IsDeleted,Name,LastActivityDate,SKU__c,Date__c,Actual_Status__c,Month__c,SKU_Actual_Unique_Id__c,
								Status__c,EOH_Inventory__c 
								from SKU_Actual__c
								WHERE SKU__r.Category__c = : cat
								AND SKU__r.Dish_Care_Group__c =:selBrand
								//AND Actual_Status__c =:status
								AND CALENDAR_MONTH(Date__c) =: monthsMap.get(arrMon[0])
								AND CALENDAR_YEAR(Date__c) =: integer.valueOf(arrMon[1])
								])
		*/
		system.debug('strQuery===='+strQuery);
		for(SKU_Actual__c SA : database.query(strQuery))
		{

			setSKUs.add(SA.SKU__c);
		}
		System.debug('setSKUs==='+setSKUs);
		System.debug('setSKUs.size()==='+setSKUs.size());
		
		Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
		
		Schema.DescribeSObjectResult res = GlobalDescribeMap.get('SKU__c').getDescribe();  
		Map<String, Schema.FieldSet> fieldSetMap= res.fieldSets.getMap();  
		Schema.FieldSet fs = fieldSetMap.get('PopupComponentFields');  

		String Querystring = 'SELECT ';
		map<String,String> mapSKUFields = new map<String,String>();
		List<String> strKey = new list<String>();
		List<String> strAPIKey = new list<String>();
		
		for( Schema.FieldSetMember fieldSetMemberObj : fs.getFields() ) {            
			system.debug('API Name ====>' + fieldSetMemberObj.getFieldPath()); //api name
			system.debug('Label ====>' + fieldSetMemberObj.getLabel());
			system.debug('Required ====>' + fieldSetMemberObj.getRequired());
			system.debug('DbRequired ====>' + fieldSetMemberObj.getDbRequired());
			system.debug('Type ====>' + fieldSetMemberObj.getType());

			Querystring += fieldSetMemberObj.getFieldPath() + ', ';
			mapSKUFields.put(fieldSetMemberObj.getLabel(),fieldSetMemberObj.getFieldPath());
			strKey.add(fieldSetMemberObj.getLabel());
			strAPIKey.add(fieldSetMemberObj.getFieldPath());
		}  

		Querystring += ' id FROM SKU__c ';
		Querystring += ' WHERE Id IN :setSKUs';
		//Querystring += ' AND SKU_Type__c =:strType ';
		
		System.debug('**Query string**'+Querystring );
		List<SKU__c> SKUList = Database.query(Querystring);  

		SKUDynamicDataWrapper sdWrap = new SKUDynamicDataWrapper(SKUList,strKey,strAPIKey,mapSKUFields);
		
		
		return sdWrap;
	}

	 public class SKUDynamicDataWrapper
    {
        
        @AuraEnabled
        public list<SKU__c> lstSKUData;
		@AuraEnabled
        public list<String> strKey;
		@AuraEnabled
        public list<String> strAPIKey;
        @AuraEnabled
        public map<String,String> mapSKUFields;

        public SKUDynamicDataWrapper(list<SKU__c> lstSKUData,list<String> strKey,list<String> strAPIKey,map<String,String> mapSKUFields){
            this.lstSKUData = lstSKUData;
			this.strKey = strKey;
			this.strAPIKey = strAPIKey;
			this.mapSKUFields = mapSKUFields;
        }

    }
    
    @AuraEnabled
    public static List<Brand__c> fetchSKUData1(String cat,String strgroup,String mon, String status, String[] selBrand, String strType){
		
		system.debug('selBrand==='+selBrand);
		System.debug('cat===='+cat);
		System.debug('strgroup===='+strgroup);
		System.debug('mon===='+mon);
		System.debug('status===='+status);
		String[] arrMon = mon.split('-');
		status = status.replace('&amp;','&');

		map<String,Integer> monthsMap = new map<String,Integer>();
		monthsMap.put('Jan',1);
		monthsMap.put('Feb',2);
		monthsMap.put('Mar',3);
		monthsMap.put('Apr',4);
		monthsMap.put('May',5);
		monthsMap.put('Jun',6);
		monthsMap.put('Jul',7);
		monthsMap.put('Aug',8);
		monthsMap.put('Sep',9);
		monthsMap.put('Oct',10);
		monthsMap.put('Nov',11);
		monthsMap.put('Dec',12);
		
		if(cat=='Surfacecare')
		{
			cat = 'Surface Care';
		}else if(cat=='Dishcare')
		{
			cat = 'Dish Care';
		}else if(cat=='Aircare')
		{
			cat = 'Air Care';
		}
		
		if(status == 'AP')
		{
			status = 'ACTIVE & PLANNED';
		}

		if(status == 'RH')
		{
			status = 'REMNANT & HISTORICAL';
		}
		
		list<String> selectedBrand = new list<String>();
		
		for(integer j=0;j<selBrand.size();j++){
			if(selBrand[j]=='AllAirCare'){
				selectedBrand.add('All Air Care');
			}else if(selBrand[j]=='ADW'){
				selectedBrand.add('ADW');
			}else if(selBrand[j]=='HDW'){
				selectedBrand.add('HDW');
			}else if(selBrand[j]=='MrClean'){
				selectedBrand.add('Mr Clean');
			}else if(selBrand[j]=='Swiffer'){
				selectedBrand.add('Swiffer');
			}
		}
		
		system.debug('cat==='+cat);
		system.debug('selBrand==='+selBrand);
		system.debug('monthsMap.get(arrMon[0]==='+monthsMap.get(arrMon[0])+'==='+integer.valueOf(arrMon[1]));
		Set<Id> setSKUs = new Set<Id>();
		if(strgroup == null || strgroup =='')
		{
		
			String strQuery = 'Select Id,IsDeleted,Name,LastActivityDate,SKU__c,SKU__r.SKU__c,Date__c,Actual_Status__c,Month__c,SKU_Actual_Unique_Id__c,'+
									' Status__c,EOH_Inventory__c '+ 
									' from SKU_Actual__c';
			if(cat!=null && cat!='')
			{
				strQuery += ' WHERE SKU__r.Category__c = \''+ cat +'\'';
			}
			
			if(selBrand!=null && selBrand.size()>0)
			{
				//strQuery += ' AND SKU__r.Dish_Care_Group__c IN :selBrand ';
				String inClause1 = String.format( '(\'\'{0}\'\')', new List<String> { String.join( new List<String>(selectedBrand) , '\',\'') });
				System.debug('inClause1===='+inClause1);
				strQuery += ' AND SKU__r.Dish_Care_Group__c IN '+inClause1 ;
			}
			if(status!=null && status!='')
			{
				strQuery += ' AND Actual_Status__c = \''+status +'\'';
			}
			
			strQuery += ' AND CALENDAR_MONTH(Date__c) ='+ monthsMap.get(arrMon[0]) +' AND CALENDAR_YEAR(Date__c) ='+ integer.valueOf(arrMon[1]);
			
			system.debug('strQuery===='+strQuery);
			for(SKU_Actual__c SA : database.query(strQuery))
			{
	
				setSKUs.add(SA.SKU__c);
			}
			System.debug('setSKUs==='+setSKUs);
			System.debug('setSKUs.size()==='+setSKUs.size());
		}
		else if(strgroup == 'SKU_Projection__c')
		{
			String strQuery = 'Select SKU__c,SKU__r.SKU__c, Name, IsDeleted, Id, Date_of_Projection__c From SKU_Projection__c ';
			
			if(cat!=null && cat!='')
			{
				strQuery += ' WHERE Include_in_Projections__c=true and Projection_Type__c =\'New\' and SKU__r.Category__c = \''+ cat +'\'';
			}
			if(status!=null && status!='')
			{
				strQuery += ' AND SKU__r.Status__c = \''+status +'\'';
			}else
			{
				strQuery += ' AND SKU__r.Status__c IN (\'ACTIVE & PLANNED\',\'REMNANT & HISTORICAL\')';
			}
			if(selBrand!=null && selBrand.size()>0)
			{
				//strQuery += ' AND SKU__r.Dish_Care_Group__c IN :selBrand ';
				String inClause1 = String.format( '(\'\'{0}\'\')', new List<String> { String.join( new List<String>(selectedBrand) , '\',\'') });
				System.debug('inClause1===='+inClause1);
				strQuery += ' AND SKU__r.Dish_Care_Group__c IN '+inClause1 ;
			}
			
			strQuery += ' AND CALENDAR_MONTH(Projected_date__c) ='+ monthsMap.get(arrMon[0]) +' AND CALENDAR_YEAR(Projected_date__c) ='+ integer.valueOf(arrMon[1]);
			
			system.debug('strQuery===@@==='+strQuery);
			for(SKU_Projection__c SA : database.query(strQuery))
			{
	
				setSKUs.add(SA.SKU__c);
			}
			System.debug('setSKUs=11=='+setSKUs);
			System.debug('setSKUs.size()=11=='+setSKUs.size());
		}
		/*
		List<SKU__c> lstSKUs = new List<SKU__c>();
		lstSKUs = [Select Id, Name, SKU__c, SKU_Description__c, Number_of_Brands__c, Total_Inventory_Count__c, First_Actual_Date__c 
					FROM SKU__c
					WHERE Id IN:setSKUs
					//Category__c =: cat
					//AND Dish_Care_Group__c =: strgroup 
					//AND Status__c =:status
					//AND CALENDAR_MONTH(Max_Actual_Date__c) =: monthsMap.get(arrMon[0])
					//AND CALENDAR_YEAR(Max_Actual_Date__c) =: integer.valueOf(arrMon[1])
					];
		return lstSKUs;
		*/
		list<Brand__c> lstBrands = new list<Brand__c>();
		lstBrands = [Select b.Type__c, b.Total_EOH_Inventory__c, b.SKU__c,SKU__r.SKU__c, b.Id, b.Brand_Projection_Type__c, b.Brand_Description__c, b.Brand_Code__c 
					From Brand__c b
					WHERE SKU__c IN:setSKUs];
		
		return lstBrands;
		
	}
}