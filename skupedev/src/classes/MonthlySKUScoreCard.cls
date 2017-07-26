/*
 * Block comments with details of changes
 */
public class MonthlySKUScoreCard
{
	@AuraEnabled
	public map<String,String> grandTotals{get;set;}

   	@AuraEnabled
    public static headingWrapper[] tableHeadingsData(){
        
		//Date minDate = Date.valueOf([Select MIN(Date__c) mindate from SKU_Actual__c][0].get('mindate'));
		//System.debug('minDate==='+minDate);
		//String strDate = minDate+'';
		//DateTime dt = DateTime.valueOf(strDate);
        //strDate = dt.format('MMMMM-YYYY');
        //system.debug('strDate==='+strDate);
		/*
		SELECT Category__c,Dish_Care_Group__c,calendar_year(Max_Actual_Date__c) Year,CALENDAR_MONTH(Max_Actual_Date__c) month_number,
		COUNT(Id) SKUs, Status__c FROM SKU__c
		WHERE Status__c = 'Active & Planned' OR Status__c = 'Remnant & Historical'
		GROUP BY Category__c,Dish_Care_Group__c,calendar_year(Max_Actual_Date__c),CALENDAR_MONTH(Max_Actual_Date__c), Status__c
		ORDER BY calendar_year(Max_Actual_Date__c) ASC 
		*/
		Date startOfMonth1 = Date.today();
		Date startOfNextMonth = startOfMonth1.addMonths(-11);
		system.debug('startOfMonth==='+startOfMonth1+'==='+startOfNextMonth);
		
        headingWrapper[] wrapperList = new headingWrapper[]{};
		Date minDate = Date.valueOf([Select MIN(Date__c) mindate from SKU_Actual__c][0].get('mindate'));
		System.debug('minDate==='+minDate);
		Date d1 = minDate;
		Date d2 = Date.Today();
		Set<String> monthYearSet = new Set<String>();
		//grandTotals = new map<String,String>();
		while(startOfNextMonth <= startOfMonth1)
		{
			String strDate = startOfNextMonth+'';
			DateTime dt = DateTime.valueOf(strDate);
			strDate = dt.format('MMMMM YYYY');
			system.debug('strDate==='+strDate);
			wrapperList.add(new headingWrapper(strDate.toUpperCase(),'ACTIVE & PLANNED','REMNANT & HISTORICAL'));
			//grandTotals.put(strDate.toUpperCase()+'ACTIVE & PLANNED','');
			//grandTotals.put(strDate.toUpperCase()+'REMNANT & HISTORICAL','');
			//monthYearSet.add(strDate);
			startOfNextMonth = startOfNextMonth.AddMonths(1);
		}
		system.debug('wrapperList==='+wrapperList);
		System.Debug('monthYearSet==='+monthYearSet);
        /*
        wrapperList.add(new headingWrapper('JUNE 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        
        wrapperList.add(new headingWrapper('JULY 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        
        wrapperList.add(new headingWrapper('AUGUST 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        wrapperList.add(new headingWrapper('SEPTEMBER 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        /*
        wrapperList.add(new headingWrapper('OCTOBER 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        wrapperList.add(new headingWrapper('NOVEMBER 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        wrapperList.add(new headingWrapper('DECEMBER 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        wrapperList.add(new headingWrapper('JANUARY 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        wrapperList.add(new headingWrapper('FEBRUARY 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        wrapperList.add(new headingWrapper('MARCH 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        wrapperList.add(new headingWrapper('APRIL 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        wrapperList.add(new headingWrapper('MAY 2016','ACTIVE & PLANNED','REMNANT & HISTORICAL'));
        */
        return wrapperList;
    }
    
    public class headingWrapper
    {
        @AuraEnabled
     	public String strDate;
        @AuraEnabled
        public String ActiveLifeCycle;
        @AuraEnabled
        public String RemnantLifeCycle;
        
        public headingWrapper(String strDate,String ActiveLifeCycle,String RemnantLifeCycle){
            this.strDate = strDate;
            this.ActiveLifeCycle = ActiveLifeCycle;
            this.RemnantLifeCycle = RemnantLifeCycle;      
        }
        
    }
    
	public class catWrapper
    {
        @AuraEnabled
        public List<categoryWrapper> dWrapper;
        @AuraEnabled
        public map<String,String> grandTotals;
		
        public catWrapper(List<categoryWrapper> dWrapper,map<String,String> grandTotals){
            this.dWrapper = dWrapper;
			this.grandTotals = grandTotals;
        }
		
    }

    public class categoryWrapper implements Comparable
    {
        @AuraEnabled
     	public String strCategory;
        @AuraEnabled
        public list<dataWrapper> lstDataWrapper;
        @AuraEnabled
        public map<String,String> categorySubTotals;

        public categoryWrapper(String strCategory,list<dataWrapper> lstDataWrapper,map<String,String> categorySubTotals){
            this.strCategory = strCategory;
            this.lstDataWrapper = lstDataWrapper;
			this.categorySubTotals = categorySubTotals;
        }

		public Integer compareTo(Object ObjToCompare) {
            return strCategory.CompareTo(((categoryWrapper)ObjToCompare).strCategory);
        }
    }
    
    public class dataWrapper  
    {
        @AuraEnabled
     	public String strCategory;
        @AuraEnabled
        public String strGroup;
        @AuraEnabled
        public map<String,String> numActiveMap;
        @AuraEnabled
        public map<String,String> numRemnantMap;
        
        public dataWrapper(String strCategory,String strGroup,map<String,String> numActiveMap,map<String,String> numRemnantMap){
            this.strCategory = strCategory;
            this.strGroup = strGroup;
            this.numActiveMap = numActiveMap;  
            this.numRemnantMap = numRemnantMap;  
        }

		
        
    }

	@AuraEnabled
    public static List<SKU__c> getSKUData(String cat,String strgroup,String mon, String status){
		
		System.debug('cat===='+cat);
		System.debug('strgroup===='+strgroup);
		System.debug('mon===='+mon);
		System.debug('status===='+status);
		String[] arrMon = mon.split(' ');
		status = status.replace('&amp;','&');

		map<String,Integer> monthsMap = new map<String,Integer>();
		monthsMap.put('JANUARY',1);
		monthsMap.put('FEBRUARY',2);
		monthsMap.put('MARCH',3);
		monthsMap.put('APRIL',4);
		monthsMap.put('MAY',5);
		monthsMap.put('JUNE',6);
		monthsMap.put('JULY',7);
		monthsMap.put('AUGUST',8);
		monthsMap.put('SEPTEMBER',9);
		monthsMap.put('OCTOBER',10);
		monthsMap.put('NOVEMBER',11);
		monthsMap.put('DECEMBER',12);

		Set<Id> setSKUs = new Set<Id>();
		for(SKU_Actual__c SA : [Select Id,IsDeleted,Name,LastActivityDate,SKU__c,Date__c,Actual_Status__c,Month__c,SKU_Actual_Unique_Id__c,
								Status__c,EOH_Inventory__c 
								from SKU_Actual__c
								WHERE SKU__r.Category__c = : cat
								AND SKU__r.Dish_Care_Group__c =:strgroup
								AND Actual_Status__c =:status
								AND CALENDAR_MONTH(Date__c) =: monthsMap.get(arrMon[0])
								AND CALENDAR_YEAR(Date__c) =: integer.valueOf(arrMon[1])
								])
		{

			setSKUs.add(SA.SKU__c);
		}
		System.debug('setSKUs==='+setSKUs);
		System.debug('setSKUs.size()==='+setSKUs.size());
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
	}
     
    @AuraEnabled
    public static catWrapper tableData1(){
		
		Date startOfMonth1 = Date.today();
		Date startOfNextMonth = startOfMonth1.addMonths(-11);
		system.debug('startOfMonth==='+startOfMonth1+'==='+startOfNextMonth);
		Date minDate = Date.valueOf([Select MIN(Date__c) mindate from SKU_Actual__c][0].get('mindate'));
		System.debug('minDate==='+minDate);
		Date d1 = minDate;
		Date d2 = Date.Today();
		Set<String> monthYearSet = new Set<String>();
		
		map<String,String> grandTotals = new map<String,String>();
		while(startOfNextMonth <= startOfMonth1)
		{
			String strDate = startOfNextMonth+'';
			DateTime dt = DateTime.valueOf(strDate);
			strDate = dt.format('MMMMM YYYY');
			system.debug('strDate==='+strDate);
			grandTotals.put(strDate.toUpperCase()+'ACTIVE & PLANNED','');
			grandTotals.put(strDate.toUpperCase()+'REMNANT & HISTORICAL','');
			startOfNextMonth = startOfNextMonth.AddMonths(1);
		}

		categoryWrapper[] lstCatWrapper = new categoryWrapper[]{};
		dataWrapper[] wrapperList = new dataWrapper[]{};
		map<String,String> numActiveMap = new map<String,String>();
		map<String,String> numRemnantMap = new map<String,String>();
		map<String,String> groupCategoryMap = new map<String,String>();
		map<String,String> categorySubTotals = new map<String,String>();
		//map<String,String> grandTotals = new map<String,String>();
		map<String,map<String,map<String,String>>> mapoutPut = new map<String,map<String,map<String,String>>>();
		map<String,map<String,map<String,String>>> mapoutPutRemnant = new map<String,map<String,map<String,String>>>();
		for (AggregateResult ag : [SELECT SKU__r.Category__c,SKU__r.Dish_Care_Group__c,calendar_year(Date__c) Year,
									CALENDAR_MONTH(Date__c) month_number, COUNT(SKU__r.Id) SKUs, Actual_Status__c 
									FROM SKU_Actual__c	
									WHERE (Actual_Status__c = 'Active & Planned' OR Actual_Status__c = 'Remnant & Historical')
									AND SKU__r.Category__c != null AND SKU__r.Dish_Care_Group__c!= null
									GROUP BY SKU__r.Category__c,SKU__r.Dish_Care_Group__c,calendar_year(Date__c),
									CALENDAR_MONTH(Date__c), Actual_Status__c
									ORDER BY calendar_year(Date__c) ASC ])
		{
			String monthString = DateTime.newInstanceGMT(System.Date.newInstance(2000, integer.valueof(ag.get('month_number')), 1), System.Time.newInstance(0, 0, 0, 0)).formatGMT('MMMM');
			System.debug('monthString==='+monthString.toUpperCase()+' '+ag.get('Year'));
			groupCategoryMap.put(string.valueOf(ag.get('Dish_Care_Group__c')),string.valueOf(ag.get('Category__c')));

			if(!categorySubTotals.isEmpty() && categorySubTotals.containsKey(string.valueOf(ag.get('Category__c'))+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase()))
			{
				String total = categorySubTotals.get(string.valueOf(ag.get('Category__c'))+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase());
				total = String.valueOf(Integer.valueOf(total) + Integer.valueOf(ag.get('SKUs')));
				categorySubTotals.put(string.valueOf(ag.get('Category__c'))+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),total);
			}else
			{
				categorySubTotals.put(string.valueOf(ag.get('Category__c'))+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
			}

			if(!grandTotals.isEmpty() && grandTotals.containsKey(monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase()))
			{
				String total = grandTotals.get(monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase());
				System.debug('ag.get(SKUs)==='+ag.get('SKUs')+'===:'+total);
				if(total!=null && total!='')
				{
					total = String.valueOf(Integer.valueOf(total) + Integer.valueOf(ag.get('SKUs')));
				}else{
					
					total = String.valueOf(ag.get('SKUs'));
				}
				grandTotals.put(monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),total);
			}else
			{
				grandTotals.put(monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
			}

			
			if(string.valueOf(ag.get('Actual_Status__c')) == 'Active & Planned')
			{
				if(!mapoutPut.isEmpty() && mapoutPut.containsKey(string.valueOf(ag.get('Category__c'))))
				{
					map<String,map<String,String>> groupMap = mapoutPut.get(string.valueOf(ag.get('Category__c')));
					//ADW ==>ADWJULY2016Active&planned
					if(!groupMap.isEmpty() && groupMap.containsKey(String.valueOf(ag.get('Dish_Care_Group__c'))))
					{
						map<String,String> newMap = groupMap.get(String.valueOf(ag.get('Dish_Care_Group__c')));
						newMap.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
						groupMap.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap);
					}else
					{
						map<String,String> newMap = new map<String,String>();
						newMap.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
						groupMap.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap);
				
					}
			
			
				}else
				{
					map<String,String> newMap = new map<String,String>();
					newMap.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
					//ADWJULY2016Active&planned==>2
					map<String,map<String,String>> groupMap = new map<String,map<String,String>>();
					groupMap.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap);
					//ADW ==>ADWJULY2016Active&planned
					mapoutPut.put(string.valueOf(ag.get('Category__c')),groupMap);
					//Dish Care ==> ADW
				}
			}else
			{
				if(!mapoutPutRemnant.isEmpty() && mapoutPutRemnant.containsKey(string.valueOf(ag.get('Category__c'))))
				{
					map<String,map<String,String>> groupMap1 = mapoutPutRemnant.get(string.valueOf(ag.get('Category__c')));
					//ADW ==>ADWJULY2016Active&planned
					if(!groupMap1.isEmpty() && groupMap1.containsKey(String.valueOf(ag.get('Dish_Care_Group__c'))))
					{
						map<String,String> newMap1 = groupMap1.get(String.valueOf(ag.get('Dish_Care_Group__c')));
						newMap1.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
						groupMap1.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap1);
					}else
					{
						map<String,String> newMap1 = new map<String,String>();
						newMap1.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
						groupMap1.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap1);
				
					}
			
			
				}else
				{
					map<String,String> newMap1 = new map<String,String>();
					newMap1.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
					//ADWJULY2016Active&planned==>2
					map<String,map<String,String>> groupMap1 = new map<String,map<String,String>>();
					groupMap1.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap1);
					//ADW ==>ADWJULY2016Active&planned
					mapoutPutRemnant.put(string.valueOf(ag.get('Category__c')),groupMap1);
					//Dish Care ==> ADW
				}
	
			}
	
	
		}

		System.debug('categorySubTotals===='+categorySubTotals);
		System.debug('grandTotals===='+grandTotals);
		System.debug('grandTotals======='+grandTotals.keyset());
		system.debug('groupCategoryMap==='+groupCategoryMap);
		system.debug('mapoutPut==='+mapoutPut);
		system.debug('mapoutPutRemnant==='+mapoutPutRemnant);
		
		for(String key : grandTotals.keyset())
		{
			System.debug('key===='+key+'===='+grandTotals.get(key));
		}
		map<String,dataWrapper[]> outPut = new map<String,dataWrapper[]>();
		map<String,string> dupCheck = new map<string,string>();
		for(String str : groupCategoryMap.KeySet())
		{
			system.debug('str==='+str);
			system.debug('groupCategoryMap.get(str)==='+groupCategoryMap.get(str));
			//if(!mapoutPut.isEmpty() && mapoutPut.containsKey(groupCategoryMap.get(str)))
			//{
				system.debug('mapoutPut.get(groupCategoryMap.get(str))==='+mapoutPut.get(groupCategoryMap.get(str)));
				system.debug('mapoutPutRemnant.get(groupCategoryMap.get(str))==='+mapoutPutRemnant.get(groupCategoryMap.get(str)));
				//wrapperList.add(new MonthlySKUScoreCard.dataWrapper(groupCategoryMap.get(str),str,mapoutPut.get(groupCategoryMap.get(str)),mapoutPutRemnant.get(groupCategoryMap.get(str))));
			//}
			//ADWJULY2016Active&planned==>2
			//ADW ==>ADWJULY2016Active&planned
			//Dish Care ==> ADW
			map<String,map<String,string>> activetempMap = mapoutPut.get(groupCategoryMap.get(str));
			map<String,map<String,string>> remnantTempMap = mapoutPutRemnant.get(groupCategoryMap.get(str));
			system.debug('activetempMap==='+activetempMap.keySet());
			system.debug('remnantTempMap==='+remnantTempMap.keySet());
			for(String str1: activetempMap.keySet())
			{
				system.debug('str1==='+str1);
				map<string,string> activetempMap1 = activetempMap.get(str1);
				system.debug('activetempMap1==='+activetempMap1);
				map<string,string> remnantTempMap1 = remnantTempMap.get(str1);
				system.debug('remnantTempMap1==='+remnantTempMap1);
		
				if(!outPut.isEmpty() && outPut.containsKey(groupCategoryMap.get(str)))
				{
					if(dupCheck.isEmpty() || !dupCheck.containsKey(str1))
					{
						dupCheck.put(str1,str1);
						dataWrapper[] wrapperList1 = outPut.get(groupCategoryMap.get(str));
						wrapperList1.add(new dataWrapper(groupCategoryMap.get(str),str1,activetempMap1,remnantTempMap1));
						outPut.put(groupCategoryMap.get(str),wrapperList1);
					}
				}else
				{
					if(dupCheck.isEmpty() || !dupCheck.containsKey(str1))
					{
						dupCheck.put(str1,str1);
						dataWrapper[] wrapperList1 = new dataWrapper[]{};
						wrapperList1.add(new dataWrapper(groupCategoryMap.get(str),str1,activetempMap1,remnantTempMap1));
						outPut.put(groupCategoryMap.get(str),wrapperList1);
					}
				}
			}
	
		}
		for(String strKey: outPut.keySet())
		{	
			lstCatWrapper.add(new categoryWrapper(strKey,outPut.get(strKey),categorySubTotals));
		}
		system.debug('lstCatWrapper.size==='+lstCatWrapper.size());
		system.debug('lstCatWrapper==='+lstCatWrapper);
		system.debug('outPut==='+outPut);

		
		system.debug('groupCategoryMap==='+groupCategoryMap);
		//groupCategoryMap==={ADW=Dish Care, All Air Care=Air Care, HDW=Dish Care, Mr Clean=Surface Care, Swiffer=Surface Care}
		system.debug('numActiveMap===='+numActiveMap);
		/*
			numActiveMap===={ADWAUGUST 2016Active & Planned=2, ADWDECEMBER 2016Active & Planned=4, ADWFEBRUARY 2017Active & Planned=118, 
			ADWJANUARY 2017Active & Planned=1, ADWJUNE 2016Active & Planned=2, ADWNOVEMBER 2016Active & Planned=2, ADWOCTOBER 2016Active & Planned=2, 
			ADWSEPTEMBER 2016Active & Planned=3, All Air CareAUGUST 2016Active & Planned=11, All Air CareDECEMBER 2016Active & Planned=5, ...}
		*/
		system.debug('numRemnantMap===='+numRemnantMap);
		/*
			numRemnantMap===={ADWAUGUST 2016Remnant & Historical=4, ADWDECEMBER 2016Remnant & Historical=1, ADWFEBRUARY 2017Remnant & Historical=62, 
			ADWJANUARY 2017Remnant & Historical=3, ADWJULY 2016Remnant & Historical=2, ADWJUNE 2016Remnant & Historical=6, 
			ADWNOVEMBER 2016Remnant & Historical=2, ADWOCTOBER 2016Remnant & Historical=4, ADWSEPTEMBER 2016Remnant & Historical=5, 
			All Air CareAUGUST 2016Remnant & Historical=27, ...}
		*/
		        
		lstCatWrapper.sort();

		catWrapper catWap = new catWrapper(lstCatWrapper,grandTotals);
        return catWap;
    }

	@AuraEnabled
    public static categoryWrapper[] tableData(){
		
		categoryWrapper[] lstCatWrapper = new categoryWrapper[]{};
		dataWrapper[] wrapperList = new dataWrapper[]{};
		map<String,String> numActiveMap = new map<String,String>();
		map<String,String> numRemnantMap = new map<String,String>();
		map<String,String> groupCategoryMap = new map<String,String>();
		map<String,String> categorySubTotals = new map<String,String>();
		map<String,String> grandTotals = new map<String,String>();
		map<String,map<String,map<String,String>>> mapoutPut = new map<String,map<String,map<String,String>>>();
		map<String,map<String,map<String,String>>> mapoutPutRemnant = new map<String,map<String,map<String,String>>>();
		for (AggregateResult ag : [SELECT SKU__r.Category__c,SKU__r.Dish_Care_Group__c,calendar_year(Date__c) Year,
									CALENDAR_MONTH(Date__c) month_number, COUNT(SKU__r.Id) SKUs, Actual_Status__c 
									FROM SKU_Actual__c	
									WHERE (Actual_Status__c = 'Active & Planned' OR Actual_Status__c = 'Remnant & Historical')
									AND SKU__r.Category__c != null AND SKU__r.Dish_Care_Group__c!= null
									GROUP BY SKU__r.Category__c,SKU__r.Dish_Care_Group__c,calendar_year(Date__c),
									CALENDAR_MONTH(Date__c), Actual_Status__c
									ORDER BY calendar_year(Date__c) ASC ])
		{
			String monthString = DateTime.newInstanceGMT(System.Date.newInstance(2000, integer.valueof(ag.get('month_number')), 1), System.Time.newInstance(0, 0, 0, 0)).formatGMT('MMMM');
			System.debug('monthString==='+monthString.toUpperCase()+' '+ag.get('Year'));
			groupCategoryMap.put(string.valueOf(ag.get('Dish_Care_Group__c')),string.valueOf(ag.get('Category__c')));

			if(!categorySubTotals.isEmpty() && categorySubTotals.containsKey(string.valueOf(ag.get('Category__c'))+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase()))
			{
				String total = categorySubTotals.get(string.valueOf(ag.get('Category__c'))+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase());
				total = String.valueOf(Integer.valueOf(total) + Integer.valueOf(ag.get('SKUs')));
				categorySubTotals.put(string.valueOf(ag.get('Category__c'))+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),total);
			}else
			{
				categorySubTotals.put(string.valueOf(ag.get('Category__c'))+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
			}

			if(!grandTotals.isEmpty() && grandTotals.containsKey(monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase()))
			{
				String total = grandTotals.get(monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase());
				total = String.valueOf(Integer.valueOf(total) + Integer.valueOf(ag.get('SKUs')));
				grandTotals.put(monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),total);
			}else
			{
				grandTotals.put(monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
			}

			
			if(string.valueOf(ag.get('Actual_Status__c')) == 'Active & Planned')
			{
				if(!mapoutPut.isEmpty() && mapoutPut.containsKey(string.valueOf(ag.get('Category__c'))))
				{
					map<String,map<String,String>> groupMap = mapoutPut.get(string.valueOf(ag.get('Category__c')));
					//ADW ==>ADWJULY2016Active&planned
					if(!groupMap.isEmpty() && groupMap.containsKey(String.valueOf(ag.get('Dish_Care_Group__c'))))
					{
						map<String,String> newMap = groupMap.get(String.valueOf(ag.get('Dish_Care_Group__c')));
						newMap.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
						groupMap.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap);
					}else
					{
						map<String,String> newMap = new map<String,String>();
						newMap.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
						groupMap.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap);
				
					}
			
			
				}else
				{
					map<String,String> newMap = new map<String,String>();
					newMap.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
					//ADWJULY2016Active&planned==>2
					map<String,map<String,String>> groupMap = new map<String,map<String,String>>();
					groupMap.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap);
					//ADW ==>ADWJULY2016Active&planned
					mapoutPut.put(string.valueOf(ag.get('Category__c')),groupMap);
					//Dish Care ==> ADW
				}
			}else
			{
				if(!mapoutPutRemnant.isEmpty() && mapoutPutRemnant.containsKey(string.valueOf(ag.get('Category__c'))))
				{
					map<String,map<String,String>> groupMap1 = mapoutPutRemnant.get(string.valueOf(ag.get('Category__c')));
					//ADW ==>ADWJULY2016Active&planned
					if(!groupMap1.isEmpty() && groupMap1.containsKey(String.valueOf(ag.get('Dish_Care_Group__c'))))
					{
						map<String,String> newMap1 = groupMap1.get(String.valueOf(ag.get('Dish_Care_Group__c')));
						newMap1.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
						groupMap1.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap1);
					}else
					{
						map<String,String> newMap1 = new map<String,String>();
						newMap1.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
						groupMap1.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap1);
				
					}
			
			
				}else
				{
					map<String,String> newMap1 = new map<String,String>();
					newMap1.put(ag.get('Dish_Care_Group__c')+monthString.toUpperCase()+' '+ag.get('Year')+String.valueOf(ag.get('Actual_Status__c')).toUpperCase(),string.valueOf(ag.get('SKUs')));
					//ADWJULY2016Active&planned==>2
					map<String,map<String,String>> groupMap1 = new map<String,map<String,String>>();
					groupMap1.put(string.valueOf(ag.get('Dish_Care_Group__c')),newMap1);
					//ADW ==>ADWJULY2016Active&planned
					mapoutPutRemnant.put(string.valueOf(ag.get('Category__c')),groupMap1);
					//Dish Care ==> ADW
				}
	
			}
	
	
		}

		System.debug('categorySubTotals===='+categorySubTotals);
		System.debug('grandTotals===='+grandTotals);
		system.debug('groupCategoryMap==='+groupCategoryMap);
		system.debug('mapoutPut==='+mapoutPut);
		system.debug('mapoutPutRemnant==='+mapoutPutRemnant);

		map<String,dataWrapper[]> outPut = new map<String,dataWrapper[]>();
		map<String,string> dupCheck = new map<string,string>();
		for(String str : groupCategoryMap.KeySet())
		{
			system.debug('str==='+str);
			system.debug('groupCategoryMap.get(str)==='+groupCategoryMap.get(str));
			//if(!mapoutPut.isEmpty() && mapoutPut.containsKey(groupCategoryMap.get(str)))
			//{
				system.debug('mapoutPut.get(groupCategoryMap.get(str))==='+mapoutPut.get(groupCategoryMap.get(str)));
				system.debug('mapoutPutRemnant.get(groupCategoryMap.get(str))==='+mapoutPutRemnant.get(groupCategoryMap.get(str)));
				//wrapperList.add(new MonthlySKUScoreCard.dataWrapper(groupCategoryMap.get(str),str,mapoutPut.get(groupCategoryMap.get(str)),mapoutPutRemnant.get(groupCategoryMap.get(str))));
			//}
			//ADWJULY2016Active&planned==>2
			//ADW ==>ADWJULY2016Active&planned
			//Dish Care ==> ADW
			map<String,map<String,string>> activetempMap = mapoutPut.get(groupCategoryMap.get(str));
			map<String,map<String,string>> remnantTempMap = mapoutPutRemnant.get(groupCategoryMap.get(str));
			system.debug('activetempMap==='+activetempMap.keySet());
			system.debug('remnantTempMap==='+remnantTempMap.keySet());
			for(String str1: activetempMap.keySet())
			{
				system.debug('str1==='+str1);
				map<string,string> activetempMap1 = activetempMap.get(str1);
				system.debug('activetempMap1==='+activetempMap1);
				map<string,string> remnantTempMap1 = remnantTempMap.get(str1);
				system.debug('remnantTempMap1==='+remnantTempMap1);
		
				if(!outPut.isEmpty() && outPut.containsKey(groupCategoryMap.get(str)))
				{
					if(dupCheck.isEmpty() || !dupCheck.containsKey(str1))
					{
						dupCheck.put(str1,str1);
						dataWrapper[] wrapperList1 = outPut.get(groupCategoryMap.get(str));
						wrapperList1.add(new dataWrapper(groupCategoryMap.get(str),str1,activetempMap1,remnantTempMap1));
						outPut.put(groupCategoryMap.get(str),wrapperList1);
					}
				}else
				{
					if(dupCheck.isEmpty() || !dupCheck.containsKey(str1))
					{
						dupCheck.put(str1,str1);
						dataWrapper[] wrapperList1 = new dataWrapper[]{};
						wrapperList1.add(new dataWrapper(groupCategoryMap.get(str),str1,activetempMap1,remnantTempMap1));
						outPut.put(groupCategoryMap.get(str),wrapperList1);
					}
				}
			}
	
		}
		for(String strKey: outPut.keySet())
		{	
			lstCatWrapper.add(new categoryWrapper(strKey,outPut.get(strKey),categorySubTotals));
		}
		system.debug('lstCatWrapper.size==='+lstCatWrapper.size());
		system.debug('lstCatWrapper==='+lstCatWrapper);
		system.debug('outPut==='+outPut);

		
		system.debug('groupCategoryMap==='+groupCategoryMap);
		//groupCategoryMap==={ADW=Dish Care, All Air Care=Air Care, HDW=Dish Care, Mr Clean=Surface Care, Swiffer=Surface Care}
		system.debug('numActiveMap===='+numActiveMap);
		/*
			numActiveMap===={ADWAUGUST 2016Active & Planned=2, ADWDECEMBER 2016Active & Planned=4, ADWFEBRUARY 2017Active & Planned=118, 
			ADWJANUARY 2017Active & Planned=1, ADWJUNE 2016Active & Planned=2, ADWNOVEMBER 2016Active & Planned=2, ADWOCTOBER 2016Active & Planned=2, 
			ADWSEPTEMBER 2016Active & Planned=3, All Air CareAUGUST 2016Active & Planned=11, All Air CareDECEMBER 2016Active & Planned=5, ...}
		*/
		system.debug('numRemnantMap===='+numRemnantMap);
		/*
			numRemnantMap===={ADWAUGUST 2016Remnant & Historical=4, ADWDECEMBER 2016Remnant & Historical=1, ADWFEBRUARY 2017Remnant & Historical=62, 
			ADWJANUARY 2017Remnant & Historical=3, ADWJULY 2016Remnant & Historical=2, ADWJUNE 2016Remnant & Historical=6, 
			ADWNOVEMBER 2016Remnant & Historical=2, ADWOCTOBER 2016Remnant & Historical=4, ADWSEPTEMBER 2016Remnant & Historical=5, 
			All Air CareAUGUST 2016Remnant & Historical=27, ...}
		*/
		        
		lstCatWrapper.sort();
        return lstCatWrapper;
    }
}