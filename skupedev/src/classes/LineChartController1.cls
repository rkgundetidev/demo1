public class LineChartController1 {
    
    public class headingWrapper
    {
        @AuraEnabled
        public String strDate;
                
        public headingWrapper(String strDate){
            this.strDate = strDate;
        }
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

    public class dataWrapper implements Comparable{
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
        
        public Integer compareTo(Object ObjToCompare) {
            return strCategory.CompareTo(((dataWrapper)ObjToCompare).strCategory);
        }
    }


    //Future Projections
    public static map<string,decimal> grandTotalsFutureProjections(set<string> selectedCate,set<string> selectedLC, set<string> selectedBrand,date stDate,date endDate,
                                                            string projStatus , set<String> strTypeTemp, string strGBU){
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
        system.debug('selectedCate=fp=='+selectedCate);
        system.debug('selectedLC=fp=='+selectedLC);
        system.debug('selectedBrand=fp=='+selectedBrand);
        system.debug('stDate=fp=='+stDate+'==='+endDate);
        system.debug('projStatus=fp=='+projStatus);
        system.debug('strTypeTemp==='+strTypeTemp);
        AggregateResult[] totalproducts =[SELECT  count(id)projections,SKU__r.Category__c,
                                            CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
                                             FROM SKU_Projection__c
                                             Where 
                                                Include_in_Projections__c=true and
                                                SKU__r.SKU_Type__c IN: strTypeTemp and
                                                SKU__r.Category__c in:selectedCate and
                                                SKU__r.Status__c in:selectedLC and
                                                SKU__r.Dish_Care_Group__c IN:selectedBrand and
                                                Projected_date__c >=: stDate and Projected_date__c<=:endDate  and
                                                Projection_Type__c =:projStatus and
                                                SKU__r.GBU__c =:strGBU
                                             GROUP BY SKU__r.Category__c,CALENDAR_MONTH(Projected_date__c),
                                             CALENDAR_Year(Projected_date__c)
                                             order by SKU__r.Category__c asc,
                                             CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
        system.debug('totalproducts===='+totalproducts);
        for(AggregateResult ar: totalproducts){
            grandTotalMap.put(ar.get('Category__c')+'~'+ ar.get('month')+'~'+ar.get('year'),
                                ((Decimal)(ar.get('projections'))));
        }
        return grandTotalMap;
    }
    
    //Group by category and Lifecycle
    //Pass the seleted categories,selected Lifecycle,startdate and end date
    //Return map total for all months 
    public static map<string,decimal> grandTotalsActuals(set<string> selectedCate,set<string> selectedLC, set<String> selBrand,date stDate,date endDate,
                                                                set<String> strTypeTemp, String strGBU){
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
        }else
        {
            date dtTemp;
            integer month;
            integer Year ;
            dtTemp = date.valueOf(stDate);
            month = dtTemp.month();
            Year = dtTemp.Year();
            stDate =  Date.newInstance(Year, month, 1); //1st of month
            //End date today - last month
            dtTemp = date.valueOf(endDate);
            month = dtTemp.month();
            Year = dtTemp.Year();
            endDate = Date.newInstance(Year, month, 31); 
        }
        //group by category and life cycle
        set<String> strLC = new set<String>();
        strLC.add('Active & Planned');
        strLC.add('Remnant & Historical');
        system.debug('selectedCate===@@==='+selectedCate);
        system.debug('selectedLC===@@==='+selectedLC);
        system.debug('selBrand===@@==='+selBrand);
        system.debug('stDate===@@==='+stDate+'==='+endDate);
        system.debug('strTypeTemp==='+strTypeTemp);
        //system.debug('selectedCate===@@==='+selectedCate);
        AggregateResult[] totalproducts =[SELECT  Actual_Status__c, SKU_Category__c, CALENDAR_MONTH(Date__c)month,  
                                            CALENDAR_Year(Date__c)year,count(id)TotalSkus   
                                             from SKU_Actual__c
                                             where SKU_Category__c in:selectedCate and
                                             SKU__r.SKU_Type__c IN: strTypeTemp and
                                             Date__c >=: stDate and Date__c<=:endDate and 
                                             Status__c in :strLC and //selectedLC  and
                                             SKU__r.Dish_Care_Group__c IN :selBrand and
                                             SKU__r.GBU__c =:strGBU
                                             group by SKU_Category__c,Actual_Status__c,CALENDAR_MONTH(Date__c),CALENDAR_Year(Date__c)
                                             order  by SKU_Category__c asc,Actual_Status__c asc,CALENDAR_MONTH(Date__c) asc,CALENDAR_Year(Date__c) desc];
        for(AggregateResult ar: totalproducts){
            system.debug('=========@@@==='+ar.get('month')+'~'+ar.get('year'));
            grandTotalMap.put(ar.get('SKU_Category__c')+'~'+ ar.get('Actual_Status__c')+'~' +ar.get('month')+'~'+ar.get('year'),
                                ((Decimal)(ar.get('TotalSkus'))));
        }
        
        system.debug('grandTotalMap==='+grandTotalMap);
        return grandTotalMap;
    }
    //Past Projections data
    public static map<string,decimal> grandTotalsPastProjections(set<string> selectedCate,set<string> selectedLC,date stDate,date endDate, set<String> strTypeTemp,
                                                                string strGBU){
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
        
        system.debug('selectedCate=###=='+selectedCate+'==stDate===='+stDate+'==='+endDate);
        system.debug('selectedLC===####=='+selectedLC);
        //group by category and life cycle
        AggregateResult[] totalproducts =[SELECT  count(id)projections,SKU__r.Category__c,SKU__r.Status__c,
                                            CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
                                             FROM SKU_Projection__c
                                             Where 
                                                Include_in_Projections__c=true and
                                                SKU__r.SKU_Type__c IN: strTypeTemp and
                                                SKU__r.Category__c in:selectedCate and
                                                SKU__r.Status__c in:selectedLC and
                                                SKU__r.GBU__c =:strGBU and
                                                Projected_date__c >=: stDate and Projected_date__c<=:endDate  
                                             GROUP BY SKU__r.Category__c,SKU__r.Status__c,CALENDAR_MONTH(Projected_date__c),
                                             CALENDAR_Year(Projected_date__c)
                                             order by SKU__r.Category__c asc,SKU__r.Status__c asc,
                                             CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
        system.debug('totalproducts===='+totalproducts);
        for(AggregateResult ar: totalproducts){
            grandTotalMap.put(ar.get('Category__c')+'~'+ ar.get('Status__c')+'~' +ar.get('month')+'~'+ar.get('year'),
                                ((Decimal)(ar.get('projections'))));
        }
        return grandTotalMap;
    }
    
    @AuraEnabled
    public static map<string,dataHeaderWrapper> loadTableData(String[] selCat,String[] selLCycle,string[] selBrand,date startDT,date endDt, String sDate, String eDate,
                                                            String[] strType, String strGBU){
        
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
        
        //headingWrapper[] wrapperList = new headingWrapper[]{};
        List<String> dateHeadings = new list<String>();
        
        //Process the Actual Data
        Date lastUpdatedDate = null;
    	integer lastUpdatedStartMonth = 0;
    	integer lastUpdatedStartYear = 0;
    	
        set<String> strTypeTemp = new set<String>();
        if(strType!=null && strType.size()>0)
        {
            for(integer i=0;i<strType.size();i++)
            {
                if(strType[i] == 'Customized')
                {
                    strTypeTemp.add('MSO');
                }else if(strType[i] == 'Non-customized')
                {
                    strTypeTemp.add('GBU');
                }
            }
        }
        
        set<String> strLC = new set<String>();
        strLC.add('Active & Planned');
        strLC.add('Remnant & Historical');
        
        system.debug('startDT==='+startDT+' ==== '+endDt+'===sDate==='+sDate+'==eDate=='+eDate);
        system.debug('strType===='+strType);
        system.debug('strGBU==='+strGBU);
        system.debug('selectedCate===='+selectedCate);
        system.debug('strTypeTemp===='+strTypeTemp);
        
        system.debug('strLC===='+strLC);
        system.debug('selectedBrand===='+selectedBrand);
        system.debug('strGBU===='+strGBU);
        
        map<string,decimal>lastMonthActuals = new map<string,decimal>();
        AggregateResult[] tempTotalproducts =[SELECT  Actual_Status__c, SKU_Category__c, CALENDAR_MONTH(Date__c)month,  
	                                            CALENDAR_Year(Date__c)year,count(id)TotalSkus   
	                                             from SKU_Actual__c
	                                             where SKU_Category__c in:selectedCate and
	                                             SKU__r.SKU_Type__c IN: strTypeTemp and
	                                             //Date__c >=: stDate and Date__c<=:endDate and 
	                                             SKU__r.IsSKUMissing__c = false and
	                                             Status__c in :strLC and //selectedLC  and
	                                             SKU__r.Dish_Care_Group__c IN :selectedBrand and
	                                             SKU__r.GBU__c =:strGBU
	                                             group by SKU_Category__c,Actual_Status__c,CALENDAR_MONTH(Date__c),CALENDAR_Year(Date__c)
	                                             //order  by SKU_Category__c asc,Actual_Status__c asc,CALENDAR_MONTH(Date__c) asc,CALENDAR_Year(Date__c) desc
	                                             order  by CALENDAR_Year(Date__c) desc, CALENDAR_MONTH(Date__c) desc, SKU_Category__c asc, Actual_Status__c asc];
		for(AggregateResult ar: tempTotalproducts){
		    system.debug('=========@@@==='+ar.get('SKU_Category__c')+'~'+ ar.get('Actual_Status__c')+'~' +ar.get('month')+'~'+ar.get('year')+' === '+ar.get('TotalSkus'));
		    
		    if(lastUpdatedStartMonth == null || lastUpdatedStartMonth ==0)
		    	lastUpdatedStartMonth = integer.valueOf(ar.get('month'));
		    
		    if(lastUpdatedStartYear == null || lastUpdatedStartYear ==0)
		    	lastUpdatedStartYear = integer.valueOf(ar.get('year'));
		    
		    //if(lastUpdatedDate == null)
		    	//lastUpdatedDate = Date.newInstance(lastUpdatedStartYear, lastUpdatedStartMonth, 1); //first Day of Current Month
		    
		    //lastUpdatedDate = Date.newInstance(lastUpdatedStartYear, lastUpdatedStartMonth, 0); //Last Day of Previous Month
		    lastMonthActuals.put(ar.get('SKU_Category__c')+'~'+ ar.get('Actual_Status__c')+'~' +ar.get('month')+'~'+ar.get('year'),
		                        ((Decimal)(ar.get('TotalSkus'))));
		}
		
		Integer numberOfDays = Date.daysInMonth(lastUpdatedStartYear, lastUpdatedStartMonth);
		lastUpdatedDate = Date.newInstance(lastUpdatedStartYear, lastUpdatedStartMonth, numberOfDays);

		system.debug('lastMonthActuals==='+lastMonthActuals);
        
        system.debug('lastUpdatedStartMonth===='+lastUpdatedStartMonth);
        system.debug('lastUpdatedStartYear===='+lastUpdatedStartYear);
        system.debug('lastUpdatedDate===='+lastUpdatedDate);
        
        Date actualStartDate = null;
        Date actualEndDate = lastUpdatedDate;
        
        date dtTemp;
        integer month;
        integer Year ;
        dtTemp = lastUpdatedDate.addMonths(-11);
        month = dtTemp.month();
        Year = dtTemp.Year();
        actualStartDate =  Date.newInstance(Year, month, 1); //1st of month
        
        Date futureStartDate = actualStartDate;
        Date futureEndDate = lastUpdatedDate;
        
        
        system.debug('actualStartDate===='+actualStartDate);
        system.debug('actualEndDate===='+actualEndDate);
        
        system.debug('startDT==='+startDT+' ==== '+endDt+'===sDate==='+sDate+'==eDate=='+eDate);
        
        if(sDate!=null && sDate!='' && eDate!=null && eDate!= '' )
        {
        	Date stDate = date.valueOf(sDate);
        	Date edDate = date.valueOf(eDate);
        	Date firstDayOfMonth = stDate.toStartOfMonth();
        	Date lastDayofEndMonth = edDate.toStartOfMonth();
        	Date lastDayOfMonth = lastDayofEndMonth.addDays(Date.daysInMonth(lastDayofEndMonth.year(), lastDayofEndMonth.month()) - 1);
        	
        	system.debug('firstDayOfMonth==='+firstDayOfMonth+' ==== '+lastDayOfMonth);
        	
	        if(firstDayOfMonth <= lastDayOfMonth && firstDayOfMonth >= actualStartDate && firstDayOfMonth < actualEndDate)
	        {
	        	actualStartDate = firstDayOfMonth; 
	        	
	        }
	        
	        if(lastDayOfMonth < actualEndDate)
	        {
	        	actualEndDate = lastDayOfMonth;   
	        }
        }
        /*
        if(date.valueOf(eDate) < actualEndDate)
        {
        	actualEndDate = date.valueOf(eDate); 
        }
        */
        system.debug('actualStartDate=after==='+actualStartDate);
        system.debug('actualEndDate=after==='+actualEndDate);
		
		Date startOfMonth1 = actualEndDate;   //.addMonths(1);
        Date startOfNextMonth = actualStartDate;
        
        
    
    	//========================== Headings======================
        
        
        while(startOfNextMonth < startOfMonth1)
        {
            system.debug('startOfNextMonth==='+startOfNextMonth);
            String strDate = startOfNextMonth+'';
            DateTime dt = DateTime.valueOf(strDate);
            //strDate = dt.format('MMMMM YYYY');
            strDate = dt.format('MMM-YYYY');
            system.debug('strDate==='+strDate);
            dateHeadings.add(strDate);
            //wrapperList.add(new headingWrapper(strDate));
            startOfNextMonth = startOfNextMonth.AddMonths(1);
            system.debug('startOfNextMonth=@@@=='+startOfNextMonth);
        }
        system.debug('dateHeadings==='+dateHeadings);
        //========================== Headings======================
        
        AlldataMap = LineChartController1.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,actualStartDate,actualEndDate,strTypeTemp, strGBU);
        
        for(string echKey : AlldataMap.keyset()){
            
            list<string> tempLst = new list<string>();
            //Air Care~Active & Planned~10~2016=307
            system.debug('echKey==='+echKey);
            tempLst =echKey.split('~');
            if(tempLst!=null && tempLst.size() > 0){
                //Building AirCare Maps
                if(tempLst[0]=='Air Care'){
                    //Load all Air care in Map
                    if(tempLst[1]=='Active & Planned'){
                        system.debug('echKey=ap=='+echKey);
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
                system.debug('selectedLC==='+selectedLC);
                if(!selectedLC.contains('Remnant & Historical'))
                {
                    system.debug('selectedLC=if=='+selectedLC);
                    airCareRemnantMap = new map<String,decimal>();
                    surfaceCareRemnantMap = new map<String,decimal>();
                    dishCareRemnantMap = new map<String,decimal>();
                }else if(!selectedLC.contains('Active & Planned')){
                    airCareActiveMap = new map<String,decimal>();
                    surfaceCareActiveMap = new map<String,decimal>();
                    dishCareActiveMap = new map<String,decimal>();
                }
                system.debug('airCareRemnantMap==='+airCareRemnantMap);
                if(selCat[i] == 'Dishcare'){
                    dWrap.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,dateHeadings));
                }else if(selCat[i] == 'Surfacecare'){
                    dWrap.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,dateHeadings));
                }else if(selCat[i] == 'Aircare'){
                    dWrap.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,dateHeadings));
                }
            }
            
            dWrap.sort();
            
            dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap,dateHeadings);
            outputMap.put('Actuals',wrapObj);//Put values in display Map
        }
        
        //End of Actuals data
        //*******************************************************End of Actuals**********************************************
        //*******************************************************Past Projection*********************************************
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
        
        //Start of Past Projections
        
        //Get Actuals of last 12 months
        map<string,decimal> grandTotalMap = new map<string,decimal>();
        
        if(actualStartDate !=null || actualEndDate != null){
            dtTemp = null;
            month = 0;
            Year = 0;
            //Start date today - 12 months
            dtTemp = date.valueOf(actualStartDate).addmonths(-1);
            month = dtTemp.month();
            Year = dtTemp.Year();
            actualStartDate =  Date.newInstance(Year, month, 1); //1st of month
            
            dtTemp = date.valueOf(actualEndDate);
            month = dtTemp.month();
            Year = dtTemp.Year();
            actualEndDate = Date.newInstance(Year, month, 31);
            
            //stDate = date.valueOf(sDate).addmonths(-1);
            //endDate = date.valueOf(eDate);    //.addmonths(-1);
        }
        //group by category and life cycle
        system.debug('selectedCate===@@==='+selectedCate);
        system.debug('selectedLC===@@==='+selectedLC);
        system.debug('selBrand===@@==='+selBrand);
        system.debug('actualEndDate===@@==='+actualStartDate+'==='+actualEndDate);
        //system.debug('selectedCate===@@==='+selectedCate);
        AggregateResult[] totalAproducts =[SELECT  Actual_Status__c, SKU_Category__c, CALENDAR_MONTH(Date__c)month,  
                                            CALENDAR_Year(Date__c)year,count(id)TotalSkus   
                                             from SKU_Actual__c
                                             where SKU_Category__c in:selectedCate and
                                             SKU__r.SKU_Type__c IN: strTypeTemp and
                                             SKU__r.GBU__c =:strGBU and
                                             Date__c >=: actualStartDate and Date__c<=:actualEndDate and 
                                             Status__c in :strLC and //selectedLC  and
                                             SKU__r.Dish_Care_Group__c IN :selectedBrand
                                             group by SKU_Category__c,Actual_Status__c,CALENDAR_MONTH(Date__c),CALENDAR_Year(Date__c)
                                             order  by SKU_Category__c asc,Actual_Status__c asc,CALENDAR_MONTH(Date__c) asc,CALENDAR_Year(Date__c) desc];
        for(AggregateResult ar: totalAproducts){
            system.debug('=========####@@@==='+ar.get('Actual_Status__c')+'~' +ar.get('month')+'~'+ar.get('year'));
            grandTotalMap.put(ar.get('SKU_Category__c')+'~'+ ar.get('Actual_Status__c')+'~' +ar.get('month')+'~'+ar.get('year'),
                                ((Decimal)(ar.get('TotalSkus'))));
        }
        
        map<String,Decimal> grandTotalMapNew = new map<String,Decimal>();
        map<String,Decimal> airCareActiveMapTemp = new map<String,Decimal>();
        map<String,Decimal> dishCareActiveMapTemp = new map<String,Decimal>();
        map<String,Decimal> surfaceCareActiveMapTemp = new map<String,Decimal>();
        
        map<String,Decimal> airCareRemnantMapTemp = new map<String,Decimal>();
        map<String,Decimal> dishCareRemnantMapTemp = new map<String,Decimal>();
        map<String,Decimal> surfaceCareRemnantMapTemp = new map<String,Decimal>();
        
        map<String,Decimal> airCareMapTemp = new map<String,Decimal>();
        map<String,Decimal> dishCareMapTemp = new map<String,Decimal>();
        map<String,Decimal> surfaceCareMapTemp = new map<String,Decimal>();
        
        if(grandTotalMap!=null)
        {
            for(String key : grandTotalMap.keySet())
            {
                system.debug('key==###=='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp[2]+'==='+temp[3]);
                integer mon = Integer.valueOf(temp[2]);
                integer yr = Integer.valueOf(temp[3]);
                if(mon == 12)
                {
                    mon = 1;
                    yr = yr+1;
                }else
                {
                    mon = mon+1;
                }
                grandTotalMapNew.put(temp[0]+'~'+temp[1]+'~'+mon+'~'+yr,grandTotalMap.get(key));
                
                if(temp[1] == 'Active & Planned')
                {
                    if(temp[0] == 'Air Care')
                        airCareActiveMapTemp.put('Aircare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                    else if(temp[0] == 'Dish Care')
                        dishCareActiveMapTemp.put('Dishcare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                    else if(temp[0] == 'Surface Care')
                        surfaceCareActiveMapTemp.put('Surfacecare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                        
                }else if(temp[1] == 'Remnant & Historical')
                {
                    if(temp[0] == 'Air Care')
                        airCareRemnantMapTemp.put('Aircare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                    else if(temp[0] == 'Dish Care')
                        dishCareRemnantMapTemp.put('Dishcare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                    else if(temp[0] == 'Surface Care')
                        surfaceCareRemnantMapTemp.put('Surfacecare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                }
                
            }
        }
        system.debug('grandTotalMap==@@=='+grandTotalMap);
        system.debug('grandTotalMapNew==@@=='+grandTotalMapNew);
        //end of actuals 
        
        /*=========================================================*/
        if(airCareActiveMapTemp!=null)
        {
            for(String key: airCareActiveMapTemp.keySet())
            {
                Decimal val = airCareActiveMapTemp.get(key);
                if(airCareRemnantMapTemp!=null && airCareRemnantMapTemp.containsKey(key))
                {
                    val = val + airCareRemnantMapTemp.get(key);
                }
                
                if(airCareMap!=null && airCareMap.containsKey(key))
                {
                    val = val + airCareMap.get(key);
                }
                airCareMapTemp.put(key,val);
            }
        }
        
        if(dishCareActiveMapTemp!=null)
        {
            for(String key: dishCareActiveMapTemp.keySet())
            {
                Decimal val = dishCareActiveMapTemp.get(key);
                if(dishCareRemnantMapTemp!=null && dishCareRemnantMapTemp.containsKey(key))
                {
                    val = val + dishCareRemnantMapTemp.get(key);
                }
                
                if(dishCareMap!=null && dishCareMap.containsKey(key))
                {
                    val = val + dishCareMap.get(key);
                }
                
                dishCareMapTemp.put(key,val);
            }
        }
        
        if(surfaceCareActiveMapTemp!=null)
        {
            for(String key: surfaceCareActiveMapTemp.keySet())
            {
                Decimal val = surfaceCareActiveMapTemp.get(key);
                if(surfaceCareRemnantMapTemp!=null && surfaceCareRemnantMapTemp.containsKey(key))
                {
                    val = val + surfaceCareRemnantMapTemp.get(key);
                }
                
                if(surfaceCareMap!=null && surfaceCareMap.containsKey(key))
                {
                    val = val + surfaceCareMap.get(key);
                }
                
                surfaceCareMapTemp.put(key,val);
            }
        }
        
        system.debug('actualEndDate==='+actualStartDate+' === '+actualEndDate);
        list<Historical_Projection_Counts__c> lstHPC =[SELECT Category__c,Count__c,Date_of_Projection__c,Projection_Type__c 
                                                        FROM Historical_Projection_Counts__c
                                                        Where 
                                                            Category__c in:selectedCate and
                                                            Date_of_Projection__c >=: actualStartDate and Date_of_Projection__c<=:actualEndDate  
                                                         order by Category__c asc,
                                                         Date_of_Projection__c asc];
        system.debug('lstHPC===='+lstHPC);
        for(Historical_Projection_Counts__c ar: lstHPC){
            Integer yearInt = ar.Date_of_Projection__c.year();  
            Integer monthInt = ar.Date_of_Projection__c.month();
            
            system.debug('ar.Projection_Type__c==='+ar.Projection_Type__c);
            
            if(ar.Projection_Type__c == 'New')
            {
                if(ar.Category__c == 'Air Care')
                {
                    airCareMap.put('Aircare'+'~'+calendarmap.get(string.valueOf(monthInt))+'-'+yearInt,ar.Count__c);
                }else if(ar.Category__c == 'Dish Care')
                {
                    dishCareMap.put('Dishcare'+'~'+calendarmap.get(string.valueOf(monthInt))+'-'+yearInt,ar.Count__c);
                }else if(ar.Category__c == 'Surface Care')
                {
                    surfaceCareMap.put('Surfacecare'+'~'+calendarmap.get(string.valueOf(monthInt))+'-'+yearInt,ar.Count__c);
                }
            }
            else if(ar.Projection_Type__c == 'Disco')
            {
                if(ar.Category__c == 'Air Care')
                {
                    airCareRemnantMap.put('Aircare'+'~'+calendarmap.get(string.valueOf(monthInt))+'-'+yearInt,ar.Count__c);
                }else if(ar.Category__c == 'Dish Care')
                {
                    dishCareRemnantMap.put('Dishcare'+'~'+calendarmap.get(string.valueOf(monthInt))+'-'+yearInt,ar.Count__c);
                }else if(ar.Category__c == 'Surface Care')
                {
                    surfaceCareRemnantMap.put('Surfacecare'+'~'+calendarmap.get(string.valueOf(monthInt))+'-'+yearInt,ar.Count__c);
                }
            }
        }
        
        if(airCareMap!=null)
        {
            for(String key :airCareMap.keySet())
            {
                decimal val = airCareMap.get(key);
                decimal subVal = 0;
                
                if(airCareRemnantMap!=null && airCareRemnantMap.containsKey(key))
                {
                    subVal = airCareRemnantMap.get(key);
                    val = val - subVal;
                }
                airCareActiveMap.put(key,val);
            }
        }
        
        if(dishCareMap!=null)
        {
            for(String key :dishCareMap.keySet())
            {
                decimal val = dishCareMap.get(key);
                decimal subVal = 0;
                
                if(dishCareRemnantMap!=null && dishCareRemnantMap.containsKey(key))
                {
                    subVal = dishCareRemnantMap.get(key);
                    val = val - subVal;
                }
                dishCareActiveMap.put(key,val);
            }
        }
        
        if(surfaceCareMap!=null)
        {
            for(String key :surfaceCareMap.keySet())
            {
                decimal val = surfaceCareMap.get(key);
                decimal subVal = 0;
                
                if(surfaceCareRemnantMap!=null && surfaceCareRemnantMap.containsKey(key))
                {
                    subVal = surfaceCareRemnantMap.get(key);
                    val = val - subVal;
                }
                surfaceCareActiveMap.put(key,val);
            }
        }
        
        map<String,Decimal> airCareMapOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareMapOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareMapOutPut = new map<String,Decimal>();
        
        map<String,Decimal> airCareActiveMapOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareActiveMapOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareActiveMapOutPut = new map<String,Decimal>();
        
        map<String,Decimal> airCareRemnantMapOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareRemnantMapOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareRemnantMapOutPut = new map<String,Decimal>();
        
        
        if(airCareMapTemp!=null && !airCareMapTemp.isEmpty() )
        {
            for(String key : airCareMapTemp.keySet())
            {
                decimal val = airCareMapTemp.get(key);
                if(airCareMap!=null && airCareMap.containsKey(key))
                {
                    val = val + airCareMap.get(key);
                }
                
                airCareMapOutPut.put(key,val);
            }
        }
        
        if(dishCareMapTemp!=null && !dishCareMapTemp.isEmpty() )
        {
            for(String key : dishCareMapTemp.keySet())
            {
                decimal val = dishCareMapTemp.get(key);
                if(dishCareMap!=null && dishCareMap.containsKey(key))
                {
                    val = val + dishCareMap.get(key);
                }
                
                dishCareMapOutPut.put(key,val);
            }
        }
        
        if(surfaceCareMapTemp!=null && !surfaceCareMapTemp.isEmpty() )
        {
            for(String key : surfaceCareMapTemp.keySet())
            {
                decimal val = surfaceCareMapTemp.get(key);
                if(surfaceCareMap!=null && surfaceCareMap.containsKey(key))
                {
                    val = val + surfaceCareMap.get(key);
                }
                
                surfaceCareMapOutPut.put(key,val);
            }
        }
        /*================Active Map================*/
        if(airCareActiveMapTemp!=null && !airCareActiveMapTemp.isEmpty() )
        {
            for(String key : airCareActiveMapTemp.keySet())
            {
                decimal val = airCareActiveMapTemp.get(key);
                if(airCareActiveMap!=null && airCareActiveMap.containsKey(key))
                {
                    val = val + airCareActiveMap.get(key);
                }
                
                airCareActiveMapOutPut.put(key,val);
            }
        }
        
        if(dishCareActiveMapTemp!=null && !dishCareActiveMapTemp.isEmpty() )
        {
            for(String key : dishCareActiveMapTemp.keySet())
            {
                decimal val = dishCareActiveMapTemp.get(key);
                if(dishCareActiveMap!=null && dishCareActiveMap.containsKey(key))
                {
                    val = val + dishCareActiveMap.get(key);
                }
                
                dishCareActiveMapOutPut.put(key,val);
            }
        }
        
        if(surfaceCareActiveMapTemp!=null && !surfaceCareActiveMapTemp.isEmpty() )
        {
            for(String key : surfaceCareActiveMapTemp.keySet())
            {
                decimal val = surfaceCareActiveMapTemp.get(key);
                if(surfaceCareActiveMap!=null && surfaceCareActiveMap.containsKey(key))
                {
                    val = val + surfaceCareActiveMap.get(key);
                }
                
                surfaceCareActiveMapOutPut.put(key,val);
            }
        }
        
        /*================Remnana Map================*/
        if(airCareRemnantMapTemp!=null && !airCareRemnantMapTemp.isEmpty() )
        {
            for(String key : airCareRemnantMapTemp.keySet())
            {
                decimal val = airCareRemnantMapTemp.get(key);
                if(airCareRemnantMap!=null && airCareRemnantMap.containsKey(key))
                {
                    val = val + airCareRemnantMap.get(key);
                }
                
                airCareRemnantMapOutPut.put(key,val);
            }
        }
        
        if(dishCareRemnantMapTemp!=null && !dishCareRemnantMapTemp.isEmpty() )
        {
            for(String key : dishCareRemnantMapTemp.keySet())
            {
                decimal val = dishCareRemnantMapTemp.get(key);
                if(dishCareRemnantMap!=null && dishCareRemnantMap.containsKey(key))
                {
                    val = val + dishCareRemnantMap.get(key);
                }
                
                dishCareRemnantMapOutPut.put(key,val);
            }
        }
        
        if(surfaceCareRemnantMapTemp!=null && !surfaceCareRemnantMapTemp.isEmpty() )
        {
            for(String key : surfaceCareRemnantMapTemp.keySet())
            {
                decimal val = surfaceCareRemnantMapTemp.get(key);
                if(surfaceCareRemnantMap!=null && surfaceCareRemnantMap.containsKey(key))
                {
                    val = val + surfaceCareRemnantMap.get(key);
                }
                
                surfaceCareRemnantMapOutPut.put(key,val);
            }
        }
        
        map<String,Decimal> airCareOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareOutPut = new map<String,Decimal>();
        
        map<String,Decimal> airCareActiveOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareActiveOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareActiveOutPut = new map<String,Decimal>();
        
        map<String,Decimal> airCareRemnantOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareRemnantOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareRemnantOutPut = new map<String,Decimal>();
        
        map<string,string> calMap =  new map<string,string>{'Jan'=>'1','Feb'=>'2', 'Mar'=>'3', 'Apr'=>'4','May'=>'5', 'Jun'=>'6',
                                             'Jul'=>'7', 'Aug'=>'8','Sep'=>'9', 'Oct'=>'10', 'Nov'=>'11', 'Dec'=>'12'};
                                             
        if(airCareMapOutPut!=null && !airCareMapOutPut.isEmpty())
        {
            for(String key: airCareMapOutPut.keySet())
            {
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                
                airCareOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,airCareMapOutPut.get(key));
            }
        }
        if(airCareActiveMapOutPut!=null && !airCareActiveMapOutPut.isEmpty())
        {
            for(String key: airCareActiveMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                airCareActiveOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,airCareActiveMapOutPut.get(key));
            }
        }
        if(airCareRemnantMapOutPut!=null && !airCareRemnantMapOutPut.isEmpty())
        {
            for(String key: airCareRemnantMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                airCareRemnantOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,airCareRemnantMapOutPut.get(key));
            }
        }
        
        
        /*=====================*/
        if(dishCareMapOutPut!=null && !dishCareMapOutPut.isEmpty())
        {
            for(String key: dishCareMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                dishCareOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,dishCareMapOutPut.get(key));
            }
        }
        if(dishCareActiveMapOutPut!=null && !dishCareActiveMapOutPut.isEmpty())
        {
            for(String key: dishCareActiveMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                dishCareActiveOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,dishCareActiveMapOutPut.get(key));
            }
        }
        if(dishCareRemnantMapOutPut!=null && !dishCareRemnantMapOutPut.isEmpty())
        {
            for(String key: dishCareRemnantMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                dishCareRemnantOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,dishCareRemnantMapOutPut.get(key));
            }
        }
        
        /*=====================*/
        if(surfaceCareMapOutPut!=null && !surfaceCareMapOutPut.isEmpty())
        {
            for(String key: surfaceCareMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                surfaceCareOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,surfaceCareMapOutPut.get(key));
            }
        }
        if(surfaceCareActiveMapOutPut!=null && !surfaceCareActiveMapOutPut.isEmpty())
        {
            for(String key: surfaceCareActiveMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                surfaceCareActiveOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,surfaceCareActiveMapOutPut.get(key));
            }
        }
        if(surfaceCareRemnantMapOutPut!=null && !surfaceCareRemnantMapOutPut.isEmpty())
        {
            for(String key: surfaceCareRemnantMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                surfaceCareRemnantOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,surfaceCareRemnantMapOutPut.get(key));
            }
        }
        
        system.debug('airCareOutPut==##==='+airCareOutPut);
        system.debug('airCareActiveOutPut==##==='+airCareActiveOutPut);
        system.debug('airCareRemnantOutPut==##==='+airCareRemnantOutPut);
        
        system.debug('dishCareOutPut==##==='+dishCareOutPut);
        system.debug('dishCareActiveOutPut==##==='+dishCareActiveOutPut);
        system.debug('dishCareRemnantOutPut==##==='+dishCareRemnantOutPut);
        
        system.debug('surfaceCareOutPut==##==='+surfaceCareOutPut);
        system.debug('surfaceCareActiveOutPut==##==='+surfaceCareActiveOutPut);
        system.debug('surfaceCareRemnantOutPut==##==='+surfaceCareRemnantOutPut);
        
        //Adding values to map
        if(selCat!=null && selCat.size()>0){
            for(integer i=0; i<selCat.size(); i++){
                System.debug('selCat=i=111='+selCat[i]);
                if(!selectedLC.contains('Remnant & Historical'))
                {
                    system.debug('selectedLC=if=='+selectedLC);
                    airCareRemnantOutPut = new map<String,decimal>();
                    surfaceCareRemnantOutPut = new map<String,decimal>();
                    dishCareRemnantOutPut = new map<String,decimal>();
                }else if(!selectedLC.contains('Active & Planned')){
                    airCareActiveOutPut = new map<String,decimal>();
                    surfaceCareActiveOutPut = new map<String,decimal>();
                    dishCareActiveOutPut = new map<String,decimal>();
                }
                
                if(selCat[i] == 'Dishcare'){
                    //dWrap1.add(new dataWrapper('Dishcare','Dishcare','maroon', 'maroon',dishCareMap,dishCareActiveMap,dishCareRemnantMap,null));
                    dWrap1.add(new dataWrapper('Dishcare','Dishcare','maroon', 'maroon',dishCareOutPut,dishCareActiveOutPut,dishCareRemnantOutPut,null));
                }else if(selCat[i] == 'Surfacecare'){
                    dWrap1.add(new dataWrapper('Surfacecare','Surfacecare','lightgreen', 'lightgreen',surfaceCareOutPut,surfaceCareActiveOutPut,
                                                        surfaceCareRemnantOutPut,null));
                }else if(selCat[i] == 'Aircare'){
                    dWrap1.add(new dataWrapper('Aircare','Aircare','yellow', 'yellow',airCareOutPut,airCareActiveOutPut,airCareRemnantOutPut,null));
                }
            }
            
            dWrap1.sort();
            dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap1,dateHeadings);
            outputMap.put('Past Projections',wrapObj);//Put values in display Map
        }
        
        //*******************************************************End of Past Projection******************************************
        //*******************************************************Future Projections**********************************************
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
        
        //Start of Future Projections
        //Logic : Last month actual +projection of current month (new)+projection of current month (manual)
        // Minus projection of current month (disc)  -->base level 
        //next month based level + projection of current month (new)+projection of current month (manual)
        // Minus projection of current month (disc)
        //Default 6 months data
        
        //map<string,decimal> lastMonthActuals = new map<string,decimal> ();
        /*
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
        */
        /*
        
        
        Date futureStartDate = null;
        Date futureEndDate = null;
        */
        system.debug('actualStartDate==='+actualStartDate +'==='+actualEndDate+'====rkg===');
        system.debug('futureStartDate==='+futureStartDate +'==='+futureEndDate+'====rkg===');
        if(futureStartDate!=null && futureEndDate!=null){
            
            dtTemp = futureStartDate.addMonths(11);
            
            month = dtTemp.month();
            Year = dtTemp.Year();
            
            date cdtTemp = futureEndDate.addMonths(12);
            integer cmonth = cdtTemp.month();
            integer cYear = cdtTemp.Year();
            futureStartDate = Date.newInstance(Year, month, 1);
            futureEndDate  = Date.newInstance(cYear, cmonth, 31);
        }
        
        system.debug('futureStartDate==future='+futureStartDate+'==='+futureEndDate);
        /*
        date edtTemp = date.valueOf(eDate);
        integer emonth = edtTemp.month();
        integer eYear = edtTemp.Year();
        edtTemp = Date.newInstance(eYear, emonth, 1);
        */
        Date fstDate = date.valueOf(sDate);
    	Date fedDate = date.valueOf(eDate);
    	Date futurefirstDayOfMonth = fstDate.toStartOfMonth();
    	Date futurelastDayofEndMonth = fedDate.toStartOfMonth();
    	Date futurelastDayOfMonth = futurelastDayofEndMonth.addDays(Date.daysInMonth(futurelastDayofEndMonth.year(), futurelastDayofEndMonth.month()) - 1);
        	
        
        //if(date.valueOf(eDate) > futureStartDate.addMonths(1) && date.valueOf(eDate) < futureEndDate)
        if(futurelastDayOfMonth > futureStartDate.addMonths(1) && futurelastDayOfMonth < futureEndDate)
        {
        	futureEndDate = futurelastDayOfMonth; 
        }
        
        system.debug('futureStartDate==future='+futureStartDate+'==='+futureEndDate);
        //integer monthDiff =  startDT1.monthsBetween(endDt1);
        set<string> tempLC = new set<string>{'Projected'};
        map<string,decimal> newProjectionMap = new map<string,decimal>();
        newProjectionMap = LineChartController1.grandTotalsFutureProjections(selectedCate,tempLC,selectedBrand,futureStartDate,futureEndDate,'New',strTypeTemp, strGBU);
        
        set<string> tempLCdisco = new set<string>{'Projected','Active & Planned'};
        map<string,decimal> discProjectionMap = new map<string,decimal>();
        discProjectionMap = LineChartController1.grandTotalsFutureProjections(selectedCate,tempLCdisco,selectedBrand,futureStartDate,futureEndDate,'Disco',strTypeTemp, strGBU);
        system.debug('discProjectionMap==##=='+discProjectionMap);
        system.debug('newProjectionMap==##=='+newProjectionMap);
        map<string,decimal> ManualProjectionMap = new map<string,decimal>();
        AggregateResult[] totalproducts =[SELECT  count(id)projections,SKU__r.Category__c,SKU__r.Status__c,
                                            CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
                                             FROM SKU_Projection__c
                                             Where Include_in_Projections__c=true and
                                                    SKU__r.SKU_Type__c IN: strTypeTemp and
                                                    SKU__r.Category__c in:selectedCate and
                                                    SKU__r.Status__c in:tempLC and
                                                    SKU__r.Dish_Care_Group__c IN:selectedBrand and
                                                    Projected_date__c >=: futureStartDate and Projected_date__c<=:futureEndDate  and
                                                    Source__c ='Manual' and
                                                    SKU__r.GBU__c =:strGBU
                                             GROUP BY SKU__r.Category__c,SKU__r.Status__c,CALENDAR_MONTH(Projected_date__c),
                                             CALENDAR_Year(Projected_date__c)
                                             order by SKU__r.Category__c asc,SKU__r.Status__c asc,
                                             CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
        //End of Future Projections
        for(AggregateResult ar: totalproducts){
            ManualProjectionMap.put(ar.get('Category__c')+'~'+ar.get('month')+'~'+ar.get('year'),
                                ((Decimal)(ar.get('projections'))));
        }
        
        system.debug('ManualProjectionMap==='+ManualProjectionMap);
        map<string,decimal> baseLineMap = new map<string,decimal>();
        
        for(string baseLine:lastMonthActuals.keyset()){
        	system.debug('baseLine==== '+baseLine+' === '+lastMonthActuals.get(baseLine));
            list<string> tempLst = new list<string>();
            //Air Care~Active & Planned~10~2016=307
            tempLst =baseLine.split('~');
            //prepare based line with Category and Status
            system.debug('lastUpdatedStartMonth==='+lastUpdatedStartMonth+'=='+tempLst[2]+'==='+lastUpdatedStartYear+'==='+tempLst[3]);
            if(lastUpdatedStartMonth == integer.valueOf(tempLst[2]) && lastUpdatedStartYear == integer.valueOf(tempLst[3]))
            	baseLineMap.put(tempLst[0]+'~'+tempLst[1],lastMonthActuals.get(baseLine));
        }
        
        system.debug('baseLineMap==='+baseLineMap);
        system.debug('selectedLC==='+selectedLC);
        //Prepare output Map of future data
        
        date dtTemp1 = futureStartDate;
        integer month1 = dtTemp1.month();
        integer Year1 = dtTemp1.Year();
        /*
        date startDT12 = Date.newInstance(Year1, month1, 1);
        date endDt12  = Date.newInstance(Year1, month1, 31);
		
        AggregateResult[] totalproductsFuture =[SELECT  Actual_Status__c, SKU_Category__c, CALENDAR_MONTH(Date__c)month,  
                                            CALENDAR_Year(Date__c)year,count(id)TotalSkus   
                                             from SKU_Actual__c
                                             where SKU_Category__c in:selectedCate and
                                             Date__c >=: startDT12 and Date__c<=:endDt12 and 
                                             Status__c in :selectedLC  and
                                             SKU__r.Dish_Care_Group__c IN :selBrand and
                                             Date__c!=null and 
                                             SKU__r.GBU__c =:strGBU
                                             group by SKU_Category__c,Actual_Status__c,CALENDAR_MONTH(Date__c),CALENDAR_Year(Date__c)
                                             order  by SKU_Category__c asc,Actual_Status__c asc,CALENDAR_MONTH(Date__c) asc,CALENDAR_Year(Date__c) desc];
                                             
        //Order collection
        system.debug('totalproductsFuture==='+totalproductsFuture);
        */
        list<futureProjectWrapper> lstOfActuals =new list<futureProjectWrapper>();
        //Prepare empty list for last month
        map<integer,string> categoryMap = new map<integer,string> {1=>'Air Care',2 =>'Dish Care',3 =>'Surface Care'};
        
        for(integer acts=1;acts<4;acts++){
            //load  Active & Planned
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
        for(integer setMonthVal=1;setMonthVal<13;setMonthVal++){
            for(futureProjectWrapper ar: lstOfActuals){
                decimal baseline = baseLineMap.get(ar.skuCategory+'~'+ar.skuStatus)!=null ?
                                    baseLineMap.get(ar.skuCategory+'~'+ar.skuStatus): 0.00;
                integer mpMonth = ar.skuMonth+setMonthVal;  
                system.debug(ar.skuMonth+'========########======='+setMonthVal+'===='+mpMonth);
                integer mpYear = ar.skuYear;    
                if(mpMonth >12){
                    mpMonth = mpMonth-12;
                    mpYear = mpYear +1;
                }           
                
                system.debug('===#==='+ar.skuCategory+'==='+mpMonth+'===='+ar.skuYear+'==='+mpYear);
                decimal newLine = newProjectionMap.get(ar.skuCategory+'~'+mpMonth+'~'+mpYear) !=null ?
                                    newProjectionMap.get(ar.skuCategory+'~'+mpMonth+'~'+mpYear):0.00;
                                                    
                decimal discoLine = discProjectionMap.get(ar.skuCategory+'~' +mpMonth+'~'+mpYear) !=null ?
                                    discProjectionMap.get(ar.skuCategory+'~' +mpMonth+'~'+mpYear):0.00;
                                                    
                decimal manualLine= ManualProjectionMap.get(ar.skuCategory+'~' +mpMonth+'~'+mpYear) !=null ?
                                    ManualProjectionMap.get(ar.skuCategory+'~'+mpMonth+'~'+mpYear):0.00;
                                    
                //Logic to create values
                decimal newBaselineValue =0.00; 
                if(ar.skuStatus=='Active & Planned'){
                    //if(ar.skuCategory == 'Surface Care')
                    system.debug(ar.skuCategory+'~'+mpMonth+'~'+ar.skuYear+'baseline==='+baseline+'==newLine=='+newLine+'==manualLine=='+manualLine+'==discoLine=='+discoLine);
                    newBaselineValue=baseline+newLine+manualLine-discoLine;
                }
                else{
                    system.debug('baseline==##=='+baseline+'==discoLine=='+discoLine);
                    newBaselineValue=baseline+discoLine;
                }
                
                system.debug('newBaselineValue=@@=='+newBaselineValue);
                //Start of Air Care             
                if(ar.skuCategory=='Air Care'){
                    if(ar.skuStatus=='Active & Planned'){
                        string monthVal = mpMonth+'';
                        string yearVal = mpYear+'';
                        //load Active values
                        system.debug('newBaselineValue==1622=='+'Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal+' = '+newBaselineValue);
                        
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
                        string yearVal = mpYear+'';
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
                        string yearVal = mpYear+'';
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
                        string yearVal = mpYear+'';
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
                        string yearVal = mpYear+'';
                        //load Active values
                        system.debug('newBaselineValue==1724=='+'Surfacecare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal+' = '+newBaselineValue);
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
                        string yearVal = mpYear+'';
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
        /*
        edtTemp = date.valueOf(eDate);
        emonth = edtTemp.month();
        eYear = edtTemp.Year();
        edtTemp = Date.newInstance(eYear, emonth, 1);
        
        system.debug('futureEndDate=before=='+futureEndDate+'==='+futureStartDate+'==='+eDate);
        //if(date.valueOf(eDate) > futureStartDate.addMonths(1) && date.valueOf(eDate) <= futureEndDate)
        
        if(edtTemp > futureStartDate.addMonths(1) && edtTemp <= futureEndDate)
        {
        	futureEndDate = date.valueOf(eDate).addMonths(+1); 
        	system.debug('futureEndDate==if='+futureEndDate+'==='+futureStartDate);
        }
        */
        system.debug('futureEndDate=after=='+futureEndDate+'==='+futureStartDate);
        system.debug('stDate1==='+stDate1+'=='+endDate1);
        Date endMonth1 = futureEndDate;
        Date startMonth = futureStartDate.addMonths(+1);
        
        system.debug('futureEndDate==='+startMonth+'==='+endMonth1 +'==='+futureStartDate+'==='+futureEndDate);
        
        dateHeadings = new list<String>();
        while(startMonth < endMonth1)
        {
            String strDate = startMonth+'';
            DateTime dt = DateTime.valueOf(strDate);
            //strDate = dt.format('MMMMM YYYY');
            strDate = dt.format('MMM-YYYY');
            system.debug('strDate==='+strDate);
            dateHeadings.add(strDate);
            //wrapperList.add(new headingWrapper(strDate));
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
                if(!selectedLC.contains('Remnant & Historical'))
                {
                    system.debug('selectedLC=if=='+selectedLC);
                    airCareRemnantMap = new map<String,decimal>();
                    surfaceCareRemnantMap = new map<String,decimal>();
                    dishCareRemnantMap = new map<String,decimal>();
                }else if(!selectedLC.contains('Active & Planned')){
                    airCareActiveMap = new map<String,decimal>();
                    surfaceCareActiveMap = new map<String,decimal>();
                    dishCareActiveMap = new map<String,decimal>();
                }
                
                if(selCat[i] == 'Dishcare'){
                    dWrap2.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,dateHeadings));
                }else if(selCat[i] == 'Surfacecare'){
                    dWrap2.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,dateHeadings));
                }else if(selCat[i] == 'Aircare'){
                    dWrap2.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,dateHeadings));
                }
            }
            dWrap2.sort();
            dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap2,dateHeadings);
            outputMap.put('Future Projections',wrapObj);//Put values in display Map
        }
        system.debug('outputMap===='+outputMap);
		return outputMap;
	}
    
    @AuraEnabled
    public static map<string,dataHeaderWrapper> loadData1(String[] selCat,String[] selLCycle,string[] selBrand,date startDT,date endDt, String sDate, String eDate,
                                                            String[] strType, String strGBU){
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
        
        //headingWrapper[] wrapperList = new headingWrapper[]{};
        List<String> dateHeadings = new list<String>();
        system.debug('startDT==='+startDT+' ==== '+endDt+'===sDate==='+sDate+'==eDate=='+eDate);
        system.debug('strType===='+strType);
        system.debug('strGBU==='+strGBU);
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
            date dtTemp;
            integer month;
            integer Year ;
            dtTemp = date.valueOf(sDate);
            month = dtTemp.month();
            Year = dtTemp.Year();
            stDate =  Date.newInstance(Year, month, 1); //1st of month
            //End date today - last month
            dtTemp = date.valueOf(eDate);
            month = dtTemp.month();
            Year = dtTemp.Year();
            endDate = Date.newInstance(Year, month, 31); //31 st of last month
            
            //stDate = date.valueOf(sDate);
            //endDate = date.valueOf(eDate);
        }
        system.debug('stDate==1='+stDate+'=='+endDate);
        Date startOfMonth1 = endDate;   //.addMonths(1);
        Date startOfNextMonth = stDate;
        
    
    
        while(startOfNextMonth < startOfMonth1)
        {
            system.debug('startOfNextMonth==='+startOfNextMonth);
            String strDate = startOfNextMonth+'';
            DateTime dt = DateTime.valueOf(strDate);
            //strDate = dt.format('MMMMM YYYY');
            strDate = dt.format('MMM-YYYY');
            system.debug('strDate==='+strDate);
            dateHeadings.add(strDate);
            //wrapperList.add(new headingWrapper(strDate));
            startOfNextMonth = startOfNextMonth.AddMonths(1);
            system.debug('startOfNextMonth=@@@=='+startOfNextMonth);
        }
        system.debug('dateHeadings==='+dateHeadings);
        //========================== Headings======================
        set<String> strTypeTemp = new set<String>();
        if(strType!=null && strType.size()>0)
        {
            for(integer i=0;i<strType.size();i++)
            {
                if(strType[i] == 'Customized')
                {
                    strTypeTemp.add('MSO');
                }else if(strType[i] == 'Non-customized')
                {
                    strTypeTemp.add('GBU');
                }
            }
        }
        
        
        if(sDate!=null && sDate!='')
            AlldataMap = LineChartController1.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,date.valueOf(sDate),date.valueOf(eDate),strTypeTemp, strGBU);
        else
            AlldataMap = LineChartController1.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,startDT,endDt,strTypeTemp, strGBU);
        
        for(string echKey : AlldataMap.keyset()){
            
            list<string> tempLst = new list<string>();
            //Air Care~Active & Planned~10~2016=307
            system.debug('echKey==='+echKey);
            tempLst =echKey.split('~');
            if(tempLst!=null && tempLst.size() > 0){
                //Building AirCare Maps
                if(tempLst[0]=='Air Care'){
                    //Load all Air care in Map
                    if(tempLst[1]=='Active & Planned'){
                        system.debug('echKey=ap=='+echKey);
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
                system.debug('selectedLC==='+selectedLC);
                if(!selectedLC.contains('Remnant & Historical'))
                {
                    system.debug('selectedLC=if=='+selectedLC);
                    airCareRemnantMap = new map<String,decimal>();
                    surfaceCareRemnantMap = new map<String,decimal>();
                    dishCareRemnantMap = new map<String,decimal>();
                }else if(!selectedLC.contains('Active & Planned')){
                    airCareActiveMap = new map<String,decimal>();
                    surfaceCareActiveMap = new map<String,decimal>();
                    dishCareActiveMap = new map<String,decimal>();
                }
                system.debug('airCareRemnantMap==='+airCareRemnantMap);
                if(selCat[i] == 'Dishcare'){
                    dWrap.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,dateHeadings));
                }else if(selCat[i] == 'Surfacecare'){
                    dWrap.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,dateHeadings));
                }else if(selCat[i] == 'Aircare'){
                    dWrap.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,dateHeadings));
                }
            }
            
            dWrap.sort();
            
            dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap,dateHeadings);
            outputMap.put('Actuals',wrapObj);//Put values in display Map
        }
        /*
        for(String key :airCareMap.keySet())
        {
            system.debug('key==='+key+' === '+airCareMap.get(key));
        }
        system.debug('outputMap==='+outputMap);
        */
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
        
        //Get Actuals of last 12 months
        map<string,decimal> grandTotalMap = new map<string,decimal>();
        
        if(sDate ==null || eDate==null){
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
        else
        {
            date dtTemp;
            integer month;
            integer Year ;
            //Start date today - 12 months
            dtTemp = date.valueOf(sDate).addmonths(-1);
            month = dtTemp.month();
            Year = dtTemp.Year();
            stDate =  Date.newInstance(Year, month, 1); //1st of month
            
            dtTemp = date.valueOf(eDate);
            month = dtTemp.month();
            Year = dtTemp.Year();
            endDate = Date.newInstance(Year, month, 31);
            
            //stDate = date.valueOf(sDate).addmonths(-1);
            //endDate = date.valueOf(eDate);    //.addmonths(-1);
        }
        //group by category and life cycle
        set<String> strLC = new set<String>();
        strLC.add('Active & Planned');
        strLC.add('Remnant & Historical');
        system.debug('selectedCate===@@==='+selectedCate);
        system.debug('selectedLC===@@==='+selectedLC);
        system.debug('selBrand===@@==='+selBrand);
        system.debug('stDate===@@==='+stDate+'==='+endDate);
        //system.debug('selectedCate===@@==='+selectedCate);
        AggregateResult[] totalAproducts =[SELECT  Actual_Status__c, SKU_Category__c, CALENDAR_MONTH(Date__c)month,  
                                            CALENDAR_Year(Date__c)year,count(id)TotalSkus   
                                             from SKU_Actual__c
                                             where SKU_Category__c in:selectedCate and
                                             SKU__r.SKU_Type__c IN: strTypeTemp and
                                             SKU__r.GBU__c =:strGBU and
                                             Date__c >=: stDate and Date__c<=:endDate and 
                                             Status__c in :strLC and //selectedLC  and
                                             SKU__r.Dish_Care_Group__c IN :selectedBrand
                                             group by SKU_Category__c,Actual_Status__c,CALENDAR_MONTH(Date__c),CALENDAR_Year(Date__c)
                                             order  by SKU_Category__c asc,Actual_Status__c asc,CALENDAR_MONTH(Date__c) asc,CALENDAR_Year(Date__c) desc];
        for(AggregateResult ar: totalAproducts){
            system.debug('=========####@@@==='+ar.get('Actual_Status__c')+'~' +ar.get('month')+'~'+ar.get('year'));
            grandTotalMap.put(ar.get('SKU_Category__c')+'~'+ ar.get('Actual_Status__c')+'~' +ar.get('month')+'~'+ar.get('year'),
                                ((Decimal)(ar.get('TotalSkus'))));
        }
        
        map<String,Decimal> grandTotalMapNew = new map<String,Decimal>();
        map<String,Decimal> airCareActiveMapTemp = new map<String,Decimal>();
        map<String,Decimal> dishCareActiveMapTemp = new map<String,Decimal>();
        map<String,Decimal> surfaceCareActiveMapTemp = new map<String,Decimal>();
        
        map<String,Decimal> airCareRemnantMapTemp = new map<String,Decimal>();
        map<String,Decimal> dishCareRemnantMapTemp = new map<String,Decimal>();
        map<String,Decimal> surfaceCareRemnantMapTemp = new map<String,Decimal>();
        
        map<String,Decimal> airCareMapTemp = new map<String,Decimal>();
        map<String,Decimal> dishCareMapTemp = new map<String,Decimal>();
        map<String,Decimal> surfaceCareMapTemp = new map<String,Decimal>();
        /*
        if(grandTotalMap!=null)
        {
            for(String key : grandTotalMap.keySet())
            {
                system.debug('key==###=='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp[2]+'==='+temp[3]);
                integer mon = Integer.valueOf(temp[2]);
                integer yr = Integer.valueOf(temp[3]);
                if(mon == 12)
                {
                    mon = 1;
                    yr = yr+1;
                }else
                {
                    mon = mon+1;
                }
                grandTotalMapNew.put(temp[0]+'~'+temp[1]+'~'+mon+'~'+yr,grandTotalMap.get(key));
            }
        }
        */
        if(grandTotalMap!=null)
        {
            for(String key : grandTotalMap.keySet())
            {
                system.debug('key==###=='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp[2]+'==='+temp[3]);
                integer mon = Integer.valueOf(temp[2]);
                integer yr = Integer.valueOf(temp[3]);
                if(mon == 12)
                {
                    mon = 1;
                    yr = yr+1;
                }else
                {
                    mon = mon+1;
                }
                grandTotalMapNew.put(temp[0]+'~'+temp[1]+'~'+mon+'~'+yr,grandTotalMap.get(key));
                
                if(temp[1] == 'Active & Planned')
                {
                    if(temp[0] == 'Air Care')
                        airCareActiveMapTemp.put('Aircare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                    else if(temp[0] == 'Dish Care')
                        dishCareActiveMapTemp.put('Dishcare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                    else if(temp[0] == 'Surface Care')
                        surfaceCareActiveMapTemp.put('Surfacecare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                        
                }else if(temp[1] == 'Remnant & Historical')
                {
                    if(temp[0] == 'Air Care')
                        airCareRemnantMapTemp.put('Aircare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                    else if(temp[0] == 'Dish Care')
                        dishCareRemnantMapTemp.put('Dishcare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                    else if(temp[0] == 'Surface Care')
                        surfaceCareRemnantMapTemp.put('Surfacecare'+'~'+calendarmap.get(string.valueOf(mon))+'-'+yr,grandTotalMap.get(key));
                }
                
            }
        }
        system.debug('grandTotalMap==@@=='+grandTotalMap);
        system.debug('grandTotalMapNew==@@=='+grandTotalMapNew);
        //end of actuals 
        
        /*=========================================================*/
        if(airCareActiveMapTemp!=null)
        {
            for(String key: airCareActiveMapTemp.keySet())
            {
                Decimal val = airCareActiveMapTemp.get(key);
                if(airCareRemnantMapTemp!=null && airCareRemnantMapTemp.containsKey(key))
                {
                    val = val + airCareRemnantMapTemp.get(key);
                }
                
                if(airCareMap!=null && airCareMap.containsKey(key))
                {
                    val = val + airCareMap.get(key);
                }
                airCareMapTemp.put(key,val);
            }
        }
        
        if(dishCareActiveMapTemp!=null)
        {
            for(String key: dishCareActiveMapTemp.keySet())
            {
                Decimal val = dishCareActiveMapTemp.get(key);
                if(dishCareRemnantMapTemp!=null && dishCareRemnantMapTemp.containsKey(key))
                {
                    val = val + dishCareRemnantMapTemp.get(key);
                }
                
                if(dishCareMap!=null && dishCareMap.containsKey(key))
                {
                    val = val + dishCareMap.get(key);
                }
                
                dishCareMapTemp.put(key,val);
            }
        }
        
        if(surfaceCareActiveMapTemp!=null)
        {
            for(String key: surfaceCareActiveMapTemp.keySet())
            {
                Decimal val = surfaceCareActiveMapTemp.get(key);
                if(surfaceCareRemnantMapTemp!=null && surfaceCareRemnantMapTemp.containsKey(key))
                {
                    val = val + surfaceCareRemnantMapTemp.get(key);
                }
                
                if(surfaceCareMap!=null && surfaceCareMap.containsKey(key))
                {
                    val = val + surfaceCareMap.get(key);
                }
                
                surfaceCareMapTemp.put(key,val);
            }
        }
        
        system.debug('stDate==='+stDate+' === '+endDate);
        list<Historical_Projection_Counts__c> lstHPC =[SELECT Category__c,Count__c,Date_of_Projection__c,Projection_Type__c 
                                                        FROM Historical_Projection_Counts__c
                                                        Where 
                                                            Category__c in:selectedCate and
                                                            Date_of_Projection__c >=: stDate and Date_of_Projection__c<=:endDate  
                                                         order by Category__c asc,
                                                         Date_of_Projection__c asc];
        system.debug('lstHPC===='+lstHPC);
        for(Historical_Projection_Counts__c ar: lstHPC){
            Integer year = ar.Date_of_Projection__c.year();  
            Integer month = ar.Date_of_Projection__c.month();
            
            system.debug('ar.Projection_Type__c==='+ar.Projection_Type__c);
            
            if(ar.Projection_Type__c == 'New')
            {
                if(ar.Category__c == 'Air Care')
                {
                    airCareMap.put('Aircare'+'~'+calendarmap.get(string.valueOf(month))+'-'+year,ar.Count__c);
                }else if(ar.Category__c == 'Dish Care')
                {
                    dishCareMap.put('Dishcare'+'~'+calendarmap.get(string.valueOf(month))+'-'+year,ar.Count__c);
                }else if(ar.Category__c == 'Surface Care')
                {
                    surfaceCareMap.put('Surfacecare'+'~'+calendarmap.get(string.valueOf(month))+'-'+year,ar.Count__c);
                }
            }
            else if(ar.Projection_Type__c == 'Disco')
            {
                if(ar.Category__c == 'Air Care')
                {
                    airCareRemnantMap.put('Aircare'+'~'+calendarmap.get(string.valueOf(month))+'-'+year,ar.Count__c);
                }else if(ar.Category__c == 'Dish Care')
                {
                    dishCareRemnantMap.put('Dishcare'+'~'+calendarmap.get(string.valueOf(month))+'-'+year,ar.Count__c);
                }else if(ar.Category__c == 'Surface Care')
                {
                    surfaceCareRemnantMap.put('Surfacecare'+'~'+calendarmap.get(string.valueOf(month))+'-'+year,ar.Count__c);
                }
            }
        }
        
        if(airCareMap!=null)
        {
            for(String key :airCareMap.keySet())
            {
                decimal val = airCareMap.get(key);
                decimal subVal = 0;
                
                if(airCareRemnantMap!=null && airCareRemnantMap.containsKey(key))
                {
                    subVal = airCareRemnantMap.get(key);
                    val = val - subVal;
                }
                airCareActiveMap.put(key,val);
            }
        }
        
        if(dishCareMap!=null)
        {
            for(String key :dishCareMap.keySet())
            {
                decimal val = dishCareMap.get(key);
                decimal subVal = 0;
                
                if(dishCareRemnantMap!=null && dishCareRemnantMap.containsKey(key))
                {
                    subVal = dishCareRemnantMap.get(key);
                    val = val - subVal;
                }
                dishCareActiveMap.put(key,val);
            }
        }
        
        if(surfaceCareMap!=null)
        {
            for(String key :surfaceCareMap.keySet())
            {
                decimal val = surfaceCareMap.get(key);
                decimal subVal = 0;
                
                if(surfaceCareRemnantMap!=null && surfaceCareRemnantMap.containsKey(key))
                {
                    subVal = surfaceCareRemnantMap.get(key);
                    val = val - subVal;
                }
                surfaceCareActiveMap.put(key,val);
            }
        }
        
        map<String,Decimal> airCareMapOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareMapOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareMapOutPut = new map<String,Decimal>();
        
        map<String,Decimal> airCareActiveMapOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareActiveMapOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareActiveMapOutPut = new map<String,Decimal>();
        
        map<String,Decimal> airCareRemnantMapOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareRemnantMapOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareRemnantMapOutPut = new map<String,Decimal>();
        
        
        if(airCareMapTemp!=null && !airCareMapTemp.isEmpty() )
        {
            for(String key : airCareMapTemp.keySet())
            {
                decimal val = airCareMapTemp.get(key);
                if(airCareMap!=null && airCareMap.containsKey(key))
                {
                    val = val + airCareMap.get(key);
                }
                
                airCareMapOutPut.put(key,val);
            }
        }
        
        if(dishCareMapTemp!=null && !dishCareMapTemp.isEmpty() )
        {
            for(String key : dishCareMapTemp.keySet())
            {
                decimal val = dishCareMapTemp.get(key);
                if(dishCareMap!=null && dishCareMap.containsKey(key))
                {
                    val = val + dishCareMap.get(key);
                }
                
                dishCareMapOutPut.put(key,val);
            }
        }
        
        if(surfaceCareMapTemp!=null && !surfaceCareMapTemp.isEmpty() )
        {
            for(String key : surfaceCareMapTemp.keySet())
            {
                decimal val = surfaceCareMapTemp.get(key);
                if(surfaceCareMap!=null && surfaceCareMap.containsKey(key))
                {
                    val = val + surfaceCareMap.get(key);
                }
                
                surfaceCareMapOutPut.put(key,val);
            }
        }
        /*================Active Map================*/
        if(airCareActiveMapTemp!=null && !airCareActiveMapTemp.isEmpty() )
        {
            for(String key : airCareActiveMapTemp.keySet())
            {
                decimal val = airCareActiveMapTemp.get(key);
                if(airCareActiveMap!=null && airCareActiveMap.containsKey(key))
                {
                    val = val + airCareActiveMap.get(key);
                }
                
                airCareActiveMapOutPut.put(key,val);
            }
        }
        
        if(dishCareActiveMapTemp!=null && !dishCareActiveMapTemp.isEmpty() )
        {
            for(String key : dishCareActiveMapTemp.keySet())
            {
                decimal val = dishCareActiveMapTemp.get(key);
                if(dishCareActiveMap!=null && dishCareActiveMap.containsKey(key))
                {
                    val = val + dishCareActiveMap.get(key);
                }
                
                dishCareActiveMapOutPut.put(key,val);
            }
        }
        
        if(surfaceCareActiveMapTemp!=null && !surfaceCareActiveMapTemp.isEmpty() )
        {
            for(String key : surfaceCareActiveMapTemp.keySet())
            {
                decimal val = surfaceCareActiveMapTemp.get(key);
                if(surfaceCareActiveMap!=null && surfaceCareActiveMap.containsKey(key))
                {
                    val = val + surfaceCareActiveMap.get(key);
                }
                
                surfaceCareActiveMapOutPut.put(key,val);
            }
        }
        
        /*================Remnana Map================*/
        if(airCareRemnantMapTemp!=null && !airCareRemnantMapTemp.isEmpty() )
        {
            for(String key : airCareRemnantMapTemp.keySet())
            {
                decimal val = airCareRemnantMapTemp.get(key);
                if(airCareRemnantMap!=null && airCareRemnantMap.containsKey(key))
                {
                    val = val + airCareRemnantMap.get(key);
                }
                
                airCareRemnantMapOutPut.put(key,val);
            }
        }
        
        if(dishCareRemnantMapTemp!=null && !dishCareRemnantMapTemp.isEmpty() )
        {
            for(String key : dishCareRemnantMapTemp.keySet())
            {
                decimal val = dishCareRemnantMapTemp.get(key);
                if(dishCareRemnantMap!=null && dishCareRemnantMap.containsKey(key))
                {
                    val = val + dishCareRemnantMap.get(key);
                }
                
                dishCareRemnantMapOutPut.put(key,val);
            }
        }
        
        if(surfaceCareRemnantMapTemp!=null && !surfaceCareRemnantMapTemp.isEmpty() )
        {
            for(String key : surfaceCareRemnantMapTemp.keySet())
            {
                decimal val = surfaceCareRemnantMapTemp.get(key);
                if(surfaceCareRemnantMap!=null && surfaceCareRemnantMap.containsKey(key))
                {
                    val = val + surfaceCareRemnantMap.get(key);
                }
                
                surfaceCareRemnantMapOutPut.put(key,val);
            }
        }
        
        map<String,Decimal> airCareOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareOutPut = new map<String,Decimal>();
        
        map<String,Decimal> airCareActiveOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareActiveOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareActiveOutPut = new map<String,Decimal>();
        
        map<String,Decimal> airCareRemnantOutPut = new map<String,Decimal>();
        map<String,Decimal> dishCareRemnantOutPut = new map<String,Decimal>();
        map<String,Decimal> surfaceCareRemnantOutPut = new map<String,Decimal>();
        
        map<string,string> calMap =  new map<string,string>{'Jan'=>'1','Feb'=>'2', 'Mar'=>'3', 'Apr'=>'4','May'=>'5', 'Jun'=>'6',
                                             'Jul'=>'7', 'Aug'=>'8','Sep'=>'9', 'Oct'=>'10', 'Nov'=>'11', 'Dec'=>'12'};
                                             
        if(airCareMapOutPut!=null && !airCareMapOutPut.isEmpty())
        {
            for(String key: airCareMapOutPut.keySet())
            {
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                
                airCareOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,airCareMapOutPut.get(key));
            }
        }
        if(airCareActiveMapOutPut!=null && !airCareActiveMapOutPut.isEmpty())
        {
            for(String key: airCareActiveMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                airCareActiveOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,airCareActiveMapOutPut.get(key));
            }
        }
        if(airCareRemnantMapOutPut!=null && !airCareRemnantMapOutPut.isEmpty())
        {
            for(String key: airCareRemnantMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                airCareRemnantOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,airCareRemnantMapOutPut.get(key));
            }
        }
        
        
        /*=====================*/
        if(dishCareMapOutPut!=null && !dishCareMapOutPut.isEmpty())
        {
            for(String key: dishCareMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                dishCareOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,dishCareMapOutPut.get(key));
            }
        }
        if(dishCareActiveMapOutPut!=null && !dishCareActiveMapOutPut.isEmpty())
        {
            for(String key: dishCareActiveMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                dishCareActiveOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,dishCareActiveMapOutPut.get(key));
            }
        }
        if(dishCareRemnantMapOutPut!=null && !dishCareRemnantMapOutPut.isEmpty())
        {
            for(String key: dishCareRemnantMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                dishCareRemnantOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,dishCareRemnantMapOutPut.get(key));
            }
        }
        
        /*=====================*/
        if(surfaceCareMapOutPut!=null && !surfaceCareMapOutPut.isEmpty())
        {
            for(String key: surfaceCareMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                surfaceCareOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,surfaceCareMapOutPut.get(key));
            }
        }
        if(surfaceCareActiveMapOutPut!=null && !surfaceCareActiveMapOutPut.isEmpty())
        {
            for(String key: surfaceCareActiveMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                surfaceCareActiveOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,surfaceCareActiveMapOutPut.get(key));
            }
        }
        if(surfaceCareRemnantMapOutPut!=null && !surfaceCareRemnantMapOutPut.isEmpty())
        {
            for(String key: surfaceCareRemnantMapOutPut.keySet())
            {
            
                system.debug('key==='+key);
                string[] temp = key.split('~');
                system.debug('temp===='+temp);
                system.debug('temp===='+temp[0]+'==='+temp[1]);
                string[] day = temp[1].split('-');
                integer mon = Integer.valueOf(calMap.get(day[0]));
                integer yr = Integer.valueOf(day[1]);
                if(mon == 1)
                {
                    mon = 12;
                    yr = yr-1;
                }else
                {
                    mon = mon-1;
                }
                surfaceCareRemnantOutPut.put(temp[0]+'~'+calendarmap.get(String.valueOf(mon))+'-'+yr,surfaceCareRemnantMapOutPut.get(key));
            }
        }
        
        system.debug('airCareOutPut==##==='+airCareOutPut);
        system.debug('airCareActiveOutPut==##==='+airCareActiveOutPut);
        system.debug('airCareRemnantOutPut==##==='+airCareRemnantOutPut);
        
        system.debug('dishCareOutPut==##==='+dishCareOutPut);
        system.debug('dishCareActiveOutPut==##==='+dishCareActiveOutPut);
        system.debug('dishCareRemnantOutPut==##==='+dishCareRemnantOutPut);
        
        system.debug('surfaceCareOutPut==##==='+surfaceCareOutPut);
        system.debug('surfaceCareActiveOutPut==##==='+surfaceCareActiveOutPut);
        system.debug('surfaceCareRemnantOutPut==##==='+surfaceCareRemnantOutPut);
        
        //Adding values to map
        if(selCat!=null && selCat.size()>0){
            for(integer i=0; i<selCat.size(); i++){
                System.debug('selCat=i=111='+selCat[i]);
                /*
                if(!selectedLC.contains('Remnant & Historical'))
                {
                    system.debug('selectedLC=if=='+selectedLC);
                    airCareRemnantMap = new map<String,decimal>();
                    surfaceCareRemnantMap = new map<String,decimal>();
                    dishCareRemnantMap = new map<String,decimal>();
                }else if(!selectedLC.contains('Active & Planned')){
                    airCareActiveMap = new map<String,decimal>();
                    surfaceCareActiveMap = new map<String,decimal>();
                    dishCareActiveMap = new map<String,decimal>();
                }
                */
                /*
                if(!selectedLC.contains('Remnant & Historical'))
                {
                    system.debug('selectedLC=if=='+selectedLC);
                    airCareRemnantMapOutPut = new map<String,decimal>();
                    surfaceCareRemnantMapOutPut = new map<String,decimal>();
                    dishCareRemnantMapOutPut = new map<String,decimal>();
                }else if(!selectedLC.contains('Active & Planned')){
                    airCareActiveMapOutPut = new map<String,decimal>();
                    surfaceCareActiveMapOutPut = new map<String,decimal>();
                    dishCareActiveMapOutPut = new map<String,decimal>();
                }*/
                
                if(!selectedLC.contains('Remnant & Historical'))
                {
                    system.debug('selectedLC=if=='+selectedLC);
                    airCareRemnantOutPut = new map<String,decimal>();
                    surfaceCareRemnantOutPut = new map<String,decimal>();
                    dishCareRemnantOutPut = new map<String,decimal>();
                }else if(!selectedLC.contains('Active & Planned')){
                    airCareActiveOutPut = new map<String,decimal>();
                    surfaceCareActiveOutPut = new map<String,decimal>();
                    dishCareActiveOutPut = new map<String,decimal>();
                }
                
                if(selCat[i] == 'Dishcare'){
                    //dWrap1.add(new dataWrapper('Dishcare','Dishcare','maroon', 'maroon',dishCareMap,dishCareActiveMap,dishCareRemnantMap,null));
                    dWrap1.add(new dataWrapper('Dishcare','Dishcare','maroon', 'maroon',dishCareOutPut,dishCareActiveOutPut,dishCareRemnantOutPut,null));
                }else if(selCat[i] == 'Surfacecare'){
                    dWrap1.add(new dataWrapper('Surfacecare','Surfacecare','lightgreen', 'lightgreen',surfaceCareOutPut,surfaceCareActiveOutPut,
                                                        surfaceCareRemnantOutPut,null));
                }else if(selCat[i] == 'Aircare'){
                    dWrap1.add(new dataWrapper('Aircare','Aircare','yellow', 'yellow',airCareOutPut,airCareActiveOutPut,airCareRemnantOutPut,null));
                }
            }
            
            dWrap1.sort();
            dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap1,dateHeadings);
            outputMap.put('Past Projections',wrapObj);//Put values in display Map
        }
        /*
        system.debug('airCareMap=11=='+airCareMap);
        for(String key :airCareMap.keySet())
        {
            system.debug('key=11=='+key+' === '+airCareMap.get(key));
        }
        */
        //=======================================================End of Past Projections===================================================================
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
        
        system.debug('endDt==='+endDt +'==='+startDT+'====rkg===');
        if(endDt!=null && startDT!=null){
            dtTemp = system.today().addMonths(-1);
            month = dtTemp.month();
            Year = dtTemp.Year();
            startDT1 = Date.newInstance(Year, month, 1);
            endDt1  = Date.newInstance(Year, month, 31);
            //last month Actuals
            lastMonthActuals =LineChartController1.grandTotalsActuals(selectedCate,selectedLC,selectedBrand,startDT1,endDt1,strTypeTemp, strGBU);
            //Next 6 months of projections
            dtTemp = system.today().addMonths(12);
            month = dtTemp.month();
            Year = dtTemp.Year();
            
            date cdtTemp = system.today();  //.addMonths(1);
            integer cmonth = cdtTemp.month();
            integer cYear = cdtTemp.Year();
            startDT1 = Date.newInstance(cYear, cmonth, 1);
            endDt1  = Date.newInstance(Year, month, 31);
        }
        
        system.debug('startDT1==='+startDT1+'==='+endDt1);
        //integer monthDiff =  startDT1.monthsBetween(endDt1);
        set<string> tempLC = new set<string>{'Projected'};
        map<string,decimal> newProjectionMap = new map<string,decimal>();
        newProjectionMap = LineChartController1.grandTotalsFutureProjections(selectedCate,tempLC,selectedBrand,startDT1,endDt1,'New',strTypeTemp, strGBU);
        
        set<string> tempLCdisco = new set<string>{'Projected','Active & Planned'};
        map<string,decimal> discProjectionMap = new map<string,decimal>();
        discProjectionMap = LineChartController1.grandTotalsFutureProjections(selectedCate,tempLCdisco,selectedBrand,startDT1,endDt1,'Disco',strTypeTemp, strGBU);
        system.debug('discProjectionMap==##=='+discProjectionMap);
        system.debug('newProjectionMap==##=='+newProjectionMap);
        map<string,decimal> ManualProjectionMap = new map<string,decimal>();
        AggregateResult[] totalproducts =[SELECT  count(id)projections,SKU__r.Category__c,SKU__r.Status__c,
                                            CALENDAR_MONTH(Projected_date__c)month,CALENDAR_Year(Projected_date__c)year
                                             FROM SKU_Projection__c
                                             Where Include_in_Projections__c=true and
                                                    SKU__r.SKU_Type__c IN: strTypeTemp and
                                                    SKU__r.Category__c in:selectedCate and
                                                    SKU__r.Status__c in:tempLC and
                                                    SKU__r.Dish_Care_Group__c IN:selectedBrand and
                                                    Projected_date__c >=: startDT1 and Projected_date__c<=:endDt1  and
                                                    Source__c ='Manual' and
                                                    SKU__r.GBU__c =:strGBU
                                             GROUP BY SKU__r.Category__c,SKU__r.Status__c,CALENDAR_MONTH(Projected_date__c),
                                             CALENDAR_Year(Projected_date__c)
                                             order by SKU__r.Category__c asc,SKU__r.Status__c asc,
                                             CALENDAR_MONTH(Projected_date__c) asc,CALENDAR_Year(Projected_date__c) desc];
        //End of Future Projections
        for(AggregateResult ar: totalproducts){
            ManualProjectionMap.put(ar.get('Category__c')+'~'+ar.get('month')+'~'+ar.get('year'),
                                ((Decimal)(ar.get('projections'))));
        }
        
        system.debug('ManualProjectionMap==='+ManualProjectionMap);
        map<string,decimal> baseLineMap = new map<string,decimal>();
        /*
        if(lastMonthActuals == null || lastMonthActuals.isEmpty())
        {
	        lastMonthActuals = new map<string,decimal>();
        	AggregateResult[] tempTotalproducts =[SELECT  Actual_Status__c, SKU_Category__c, CALENDAR_MONTH(Date__c)month,  
	                                            CALENDAR_Year(Date__c)year,count(id)TotalSkus   
	                                             from SKU_Actual__c
	                                             where SKU_Category__c in:selectedCate and
	                                             SKU__r.SKU_Type__c IN: strTypeTemp and
	                                             //Date__c >=: stDate and Date__c<=:endDate and 
	                                             SKU__r.IsSKUMissing__c = false and
	                                             Status__c in :strLC and //selectedLC  and
	                                             SKU__r.Dish_Care_Group__c IN :selBrand and
	                                             SKU__r.GBU__c =:strGBU
	                                             group by SKU_Category__c,Actual_Status__c,CALENDAR_MONTH(Date__c),CALENDAR_Year(Date__c)
	                                             order  by SKU_Category__c asc,Actual_Status__c asc,CALENDAR_MONTH(Date__c) asc,CALENDAR_Year(Date__c) desc];
	        for(AggregateResult ar: tempTotalproducts){
	            system.debug('=========@@@==='+ar.get('month')+'~'+ar.get('year'));
	            lastMonthActuals.put(ar.get('SKU_Category__c')+'~'+ ar.get('Actual_Status__c')+'~' +ar.get('month')+'~'+ar.get('year'),
	                                ((Decimal)(ar.get('TotalSkus'))));
	        }
        	system.debug('lastMonthActuals==='+lastMonthActuals);
        }
        */
        for(string baseLine:lastMonthActuals.keyset()){
            system.debug('baseLine==== '+baseLine+' === '+lastMonthActuals.get(baseLine));
            list<string> tempLst = new list<string>();
            //Air Care~Active & Planned~10~2016=307
            tempLst =baseLine.split('~');
            //prepare based line with Category and Status 
            baseLineMap.put(tempLst[0]+'~'+tempLst[1],lastMonthActuals.get(baseLine));
        }
        
        system.debug('baseLineMap==='+baseLineMap);
        system.debug('selectedLC==='+selectedLC);
        //Prepare output Map of future data
        
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
                                             Date__c!=null and 
                                             SKU__r.GBU__c =:strGBU
                                             group by SKU_Category__c,Actual_Status__c,CALENDAR_MONTH(Date__c),CALENDAR_Year(Date__c)
                                             order  by SKU_Category__c asc,Actual_Status__c asc,CALENDAR_MONTH(Date__c) asc,CALENDAR_Year(Date__c) desc];
                                             
        //Order collection
        system.debug('totalproductsFuture==='+totalproductsFuture);
        list<futureProjectWrapper> lstOfActuals =new list<futureProjectWrapper>();
        //Prepare empty list for last month
        map<integer,string> categoryMap = new map<integer,string> {1=>'Air Care',2 =>'Dish Care',3 =>'Surface Care'};
        
        for(integer acts=1;acts<4;acts++){
            //load  Active & Planned
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
        for(integer setMonthVal=1;setMonthVal<13;setMonthVal++){
            for(futureProjectWrapper ar: lstOfActuals){
                decimal baseline = baseLineMap.get(ar.skuCategory+'~'+ar.skuStatus)!=null ?
                                    baseLineMap.get(ar.skuCategory+'~'+ar.skuStatus): 0.00;
                integer mpMonth = ar.skuMonth+setMonthVal;  
                system.debug(ar.skuMonth+'========########======='+setMonthVal+'===='+mpMonth);
                integer mpYear = ar.skuYear;    
                if(mpMonth >12){
                    mpMonth = mpMonth-12;
                    mpYear = mpYear +1;
                }           
                
                system.debug('===#==='+ar.skuCategory+'==='+mpMonth+'===='+ar.skuYear+'==='+mpYear);
                decimal newLine = newProjectionMap.get(ar.skuCategory+'~'+mpMonth+'~'+mpYear) !=null ?
                                    newProjectionMap.get(ar.skuCategory+'~'+mpMonth+'~'+mpYear):0.00;
                                                    
                decimal discoLine = discProjectionMap.get(ar.skuCategory+'~' +mpMonth+'~'+mpYear) !=null ?
                                    discProjectionMap.get(ar.skuCategory+'~' +mpMonth+'~'+mpYear):0.00;
                                                    
                decimal manualLine= ManualProjectionMap.get(ar.skuCategory+'~' +mpMonth+'~'+mpYear) !=null ?
                                    ManualProjectionMap.get(ar.skuCategory+'~'+mpMonth+'~'+mpYear):0.00;
                                    
                //Logic to create values
                decimal newBaselineValue =0.00; 
                if(ar.skuStatus=='Active & Planned'){
                    //if(ar.skuCategory == 'Surface Care')
                    system.debug(ar.skuCategory+'~'+mpMonth+'~'+ar.skuYear+'baseline==='+baseline+'==newLine=='+newLine+'==manualLine=='+manualLine+'==discoLine=='+discoLine);
                    newBaselineValue=baseline+newLine+manualLine-discoLine;
                }
                else{
                    system.debug('baseline==##=='+baseline+'==discoLine=='+discoLine);
                    newBaselineValue=baseline+discoLine;
                }
                
                system.debug('newBaselineValue=@@=='+newBaselineValue);
                //Start of Air Care             
                if(ar.skuCategory=='Air Care'){
                    if(ar.skuStatus=='Active & Planned'){
                        string monthVal = mpMonth+'';
                        string yearVal = mpYear+'';
                        //load Active values
                        system.debug('newBaselineValue==1622=='+'Aircare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal+' = '+newBaselineValue);
                        
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
                        string yearVal = mpYear+'';
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
                        string yearVal = mpYear+'';
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
                        string yearVal = mpYear+'';
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
                        string yearVal = mpYear+'';
                        //load Active values
                        system.debug('newBaselineValue==1724=='+'Surfacecare~A & P~'+calendarmap.get(monthVal)+'-'+yearVal+' = '+newBaselineValue);
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
                        string yearVal = mpYear+'';
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
        
        if(sDate!=null)
        stDate = date.valueOf(sDate);
        if(eDate!=null)
        endDate = date.valueOf(eDate);
        
        system.debug(sDate+'==endDate==='+endDate);
        if(endDate.addMonths(+1) == system.today())
        {
            //stDate1 = system.today().addMonths(+1);
            fdtTemp = system.today();
            fmonth = fdtTemp.month();
            fYear = fdtTemp.Year();
            stDate1 =  Date.newInstance(fYear, fmonth, 1); //1st of month
            
            fdtTemp = stDate1.addMonths(+12);
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
        }else
        {
            fdtTemp = system.today();
            fmonth = fdtTemp.month();
            fYear = fdtTemp.Year();
            stDate1 =  Date.newInstance(fYear, fmonth, 1); //1st of month
            
            fdtTemp = stDate1.addMonths(+12);
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
            //wrapperList.add(new headingWrapper(strDate));
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
                if(!selectedLC.contains('Remnant & Historical'))
                {
                    system.debug('selectedLC=if=='+selectedLC);
                    airCareRemnantMap = new map<String,decimal>();
                    surfaceCareRemnantMap = new map<String,decimal>();
                    dishCareRemnantMap = new map<String,decimal>();
                }else if(!selectedLC.contains('Active & Planned')){
                    airCareActiveMap = new map<String,decimal>();
                    surfaceCareActiveMap = new map<String,decimal>();
                    dishCareActiveMap = new map<String,decimal>();
                }
                
                if(selCat[i] == 'Dishcare'){
                    dWrap2.add(new dataWrapper('Dishcare','Dishcare','#FF0000', '#FF0000',dishCareMap,dishCareActiveMap,dishCareRemnantMap,dateHeadings));
                }else if(selCat[i] == 'Surfacecare'){
                    dWrap2.add(new dataWrapper('Surfacecare','Surfacecare','green', 'green',surfaceCareMap,surfaceCareActiveMap,surfaceCareRemnantMap,dateHeadings));
                }else if(selCat[i] == 'Aircare'){
                    dWrap2.add(new dataWrapper('Aircare','Aircare','#3975A2', '#3975A2',airCareMap,airCareActiveMap,airCareRemnantMap,dateHeadings));
                }
            }
            dWrap2.sort();
            dataHeaderWrapper wrapObj = new dataHeaderWrapper(dWrap2,dateHeadings);
            outputMap.put('Future Projections',wrapObj);//Put values in display Map
        }
        /*
        for(String str : outputMap.keySet())
        {
            //for(String key :airCareMap.keySet())
            //{
            system.debug('str==='+str+' === '+outputMap.get(str));
            //}
        }
        system.debug('outputMap==='+outputMap);
        */
        return outputMap;
    }
    //end of main method
    
    
    /*
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
    */
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
        
        list<Brand__c> lstBrands = new list<Brand__c>();
        lstBrands = [Select b.Type__c, b.Total_EOH_Inventory__c, b.SKU__c,SKU__r.SKU__c, b.Id, b.Brand_Projection_Type__c, b.Brand_Description__c, b.Brand_Code__c,
                        Net_Invoice_Value_MM__c,Shipments_in_MSU__c, Three_Month_MM_Net_Invoice__c, Three_Month_MSU_Shipment__c,EOH_Inventory__c,
                        Total_Quantity_Actuals__c  
                    From Brand__c b
                    WHERE SKU__c IN:setSKUs];
        
        return lstBrands;
        
    }
    
    @AuraEnabled
    public static list<ExportToExcel__c> exportToExcelSettings(){
        
        list<ExportToExcel__c> lstExports = [SELECT Name, Required__c from ExportToExcel__c ];
        //Map<String,ExportToExcel__c> allExports = ExportToExcel__c.getAll();
        //lstExports = allExports.values();
        
        return lstExports;
    }
    
    @AuraEnabled
    public static List<User> userSettings(){
        
        Id userId = UserInfo.getUserId();
        
        list<User> lstUser = [SELECT Id, Name, Category__c, GBU__c from User WHERE id=:userId ];
        
        return lstUser;
    }
}