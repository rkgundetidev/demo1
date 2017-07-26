public with sharing class ActualVsProjectionEstimatesController{
    public class RowWrapper{
        @AuraEnabled public String category;
        @AuraEnabled public String cat;
        @AuraEnabled public String lfCycle;
        @AuraEnabled public integer estimates;
        @AuraEnabled public integer actual;
        @AuraEnabled public string strClr;
        
        public RowWrapper(String category, String cat, String lfCycle, integer estimates, integer actual, string strClr){
            this.category = category;
            this.cat = cat;
            this.lfCycle = lfCycle;
            this.estimates = estimates;
            this.actual = actual;
            this.strClr = strClr;
        }
    }
    
    @AuraEnabled
    public static RowWrapper[] getEstimateActualSKUCnt(){
        
        list<RowWrapper> lstRowWrapper = new list<RowWrapper>();
        
        map<string, RowWrapper> mapRowWrap = new map<string, RowWrapper>();
        mapRowWrap.put('Air Care',new RowWrapper('Air Care','Air Care','A&P',0,0,''));
        mapRowWrap.put('Dish Care',new RowWrapper('Dish Care','Dish Care','A&P',0,0,''));
        mapRowWrap.put('Surface Care',new RowWrapper('Surface Care','Surface Care','A&P',0,0,''));

        Date dtMax = Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
        integer mnth = dtMax.Month();
        integer yr = dtMax.Year();
        integer lstMnth = dtMax.Month()-1;
        for(AggregateResult ar : [Select count(Id), Category__c From SKU__c 
                                    Where Category__c != null 
                                    And Category__c != '' 
                                    And Status__c = 'Active & Planned'
                                    And Max_Actual_Date__c =: dtMax  
                                    GROUP BY Category__c]){ 
            RowWrapper objWarp = mapRowWrap.get((string)ar.get('Category__c'));
            objWarp.actual = (integer)ar.get('expr0');
            mapRowWrap.put((string)ar.get('Category__c'), objWarp);
        }
        for(AggregateResult ar : [Select count(Id), SKU_Category__c From SKU_Actual__c 
                                    Where SKU_Category__c != null 
                                    And SKU_Category__c != '' 
                                    And Status__c = 'Active & Planned'
                                    And CALENDAR_MONTH(Date__c) =: lstMnth
                                    GROUP BY SKU_Category__c]){ 
            RowWrapper objWarp = mapRowWrap.get((string)ar.get('SKU_Category__c'));
            objWarp.estimates = (integer)ar.get('expr0');
            mapRowWrap.put((string)ar.get('SKU_Category__c'), objWarp);
        }
        for(SKU__c objSKU : [Select Id, Category__c, Status__c, Projected_Start_Date__c, Projected_Disco_Date__c, Max_Actual_Date__c 
                                    From SKU__c 
                                    Where Category__c != null And Category__c != '' And
                                    Status__c IN ('Active & Planned','Remnant & Historical','Projected') 
                                    And Max_Actual_Date__c =: dtMax ]){ 
            RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c);
            if(objSKU.Projected_Disco_Date__c.Month() == mnth && objSKU.Projected_Disco_Date__c.Year() == yr 
            && (objSKU.Status__c == 'Active & Planned' || objSKU.Status__c == 'Remnant & Historical' || objSKU.Status__c == 'Projected')){
                objWarp.estimates -= 1;
            }else if(objSKU.Projected_Start_Date__c.Month() == mnth && objSKU.Projected_Start_Date__c.Year() == yr 
            && (objSKU.Status__c == 'Active & Planned' || objSKU.Status__c == 'Projected')){
                objWarp.estimates += 1;
            }
            mapRowWrap.put(objSKU.Category__c, objWarp);
        }
        
        if(mapRowWrap != null && mapRowWrap.size() > 0){
            lstRowWrapper.addAll(mapRowWrap.values());
        }
        return lstRowWrapper;
    }
    
    @AuraEnabled
    public static RowWrapper[] getProjTypeEstimateActualSKUCount(){
        
        list<RowWrapper> lstRowWrapper = new list<RowWrapper>();
        
        Date dtMax = Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
        integer mnth = dtMax.Month();
        integer yr = dtMax.Year();
        String curMonthString = DateTime.newInstanceGMT(System.Date.newInstance(2000, dtMax.month(), 1), System.Time.newInstance(0, 0, 0, 0)).formatGMT('MMM');
    
        Integer lstMnth = dtMax.month()-1;
        String lstMonthString = DateTime.newInstanceGMT(System.Date.newInstance(2000, lstMnth, 1), System.Time.newInstance(0, 0, 0, 0)).formatGMT('MMM');
        
        map<string, RowWrapper> mapRowWrap = new map<string, RowWrapper>();
        mapRowWrap.put('Air Care~Count', new RowWrapper('Air Care','Air Care',lstMonthString+' SKU Count (A&P)',0,0,'e3f3ff'));
        mapRowWrap.put('Air Care~Customized New SKU', new RowWrapper('','Air Care','Customized New SKU',0,0,'e3f3ff'));
        mapRowWrap.put('Air Care~Customized Disco', new RowWrapper('','Air Care','Customized Disco',0,0,'e3f3ff'));
        mapRowWrap.put('Air Care~Customized Deletes', new RowWrapper('','Air Care','Customized Deletes',0,0,'e3f3ff'));
        mapRowWrap.put('Air Care~Non-Customized New SKU', new RowWrapper('','Air Care','Non-Customized New SKU',0,0,'e3f3ff'));
        mapRowWrap.put('Air Care~Non-Customized Disco', new RowWrapper('','Air Care','Non-Customized Disco',0,0,'e3f3ff'));
        mapRowWrap.put('Air Care~Non-Customized Deletes', new RowWrapper('','Air Care','Non-Customized Deletes',0,0,'e3f3ff'));
        mapRowWrap.put('Air Care',new RowWrapper(curMonthString+' SKU Count (A&P)','Air Care','',0,0,'408fd5'));
        
        mapRowWrap.put('Dish Care~Count', new RowWrapper('Dish Care','Dish Care',lstMonthString+' SKU Count (A&P)',0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care~Customized New SKU', new RowWrapper('','Dish Care','Customized New SKU',0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care~Customized Disco', new RowWrapper('','Dish Care','Customized Disco',0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care~Customized Deletes', new RowWrapper('','Dish Care','Customized Deletes',0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care~Non-Customized New SKU', new RowWrapper('','Dish Care','Non-Customized New SKU',0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care~Non-Customized Disco', new RowWrapper('','Dish Care','Non-Customized Disco',0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care~Non-Customized Deletes', new RowWrapper('','Dish Care','Non-Customized Deletes',0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care',new RowWrapper(curMonthString+' SKU Count (A&P)','Dish Care','',0,0,'408fd5'));

        mapRowWrap.put('Surface Care~Count', new RowWrapper('Surface Care','Surface Care',lstMonthString+' SKU Count (A&P)',0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care~Customized New SKU', new RowWrapper('','Surface Care','Customized New SKU',0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care~Customized Disco', new RowWrapper('','Surface Care','Customized Disco',0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care~Customized Deletes', new RowWrapper('','Surface Care','Customized Deletes',0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care~Non-Customized New SKU', new RowWrapper('','Surface Care','Non-Customized New SKU',0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care~Non-Customized Disco', new RowWrapper('','Surface Care','Non-Customized Disco',0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care~Non-Customized Deletes', new RowWrapper('','Surface Care','Non-Customized Deletes',0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care',new RowWrapper(curMonthString+' SKU Count (A&P)','Surface Care','',0,0,'408fd5'));
        
        for(AggregateResult ar : [Select count(Id), SKU_Category__c From SKU_Actual__c 
                                    Where SKU_Category__c != null 
                                    And SKU_Category__c != '' 
                                    And Status__c = 'Active & Planned'
                                    And CALENDAR_MONTH(Date__c) =: lstMnth
                                    GROUP BY SKU_Category__c]){ 
            RowWrapper objWarp = mapRowWrap.get((string)ar.get('SKU_Category__c')+'~Count');
            objWarp.actual = (integer)ar.get('expr0');
            objWarp.estimates = (integer)ar.get('expr0');
            mapRowWrap.put((string)ar.get('SKU_Category__c')+'~Count', objWarp);
            
            RowWrapper objWarp1 = mapRowWrap.get((string)ar.get('SKU_Category__c'));
            objWarp1.actual = (integer)ar.get('expr0');
            objWarp1.estimates = (integer)ar.get('expr0');
            mapRowWrap.put((string)ar.get('SKU_Category__c'), objWarp1);
        }
        
        for(SKU__c objSKU : [Select Id, Name, SKU_Description__c, Category__c, Status__c, SKU_Type__c, 
                                    Projected_Start_Date__c, Projected_Disco_Date__c, Max_Actual_Date__c,
                                    Latest_Undelete_Date__c,  Latest_Status_change_Date__c
                                    From SKU__c 
                                    Where Category__c != null And Category__c != '' And
                                    Status__c IN ('Active & Planned','Remnant & Historical','Projected') 
                                    And Max_Actual_Date__c =: dtMax]){ 
            //Disco Date
            if(objSKU.Projected_Disco_Date__c != null && objSKU.Projected_Disco_Date__c.Month() == mnth && objSKU.Projected_Disco_Date__c.Year() == yr 
            && (objSKU.Status__c == 'Active & Planned' || objSKU.Status__c == 'Remnant & Historical' || objSKU.Status__c == 'Projected')){
                //Customized Disco
                if(objSKU.SKU_Type__c=='MSO'){
                    RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Customized Disco');
                    objWarp.estimates -= 1;
                    mapRowWrap.put(objSKU.Category__c+'~Customized Disco', objWarp);
                }
                //Non-Customized Disco
                else{
                    RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Non-Customized Disco');
                    objWarp.estimates -= 1;
                    mapRowWrap.put(objSKU.Category__c+'~Non-Customized Disco', objWarp);
                }
                RowWrapper objWarp1 = mapRowWrap.get(objSKU.Category__c);
	            objWarp1.estimates -= 1;
	            mapRowWrap.put(objSKU.Category__c,objWarp1);
            }
            else 
            //Start Date
            if(objSKU.Projected_Start_Date__c != null && objSKU.Projected_Start_Date__c.Month() == mnth && objSKU.Projected_Start_Date__c.Year() == yr 
            && (objSKU.Status__c == 'Active & Planned' || objSKU.Status__c == 'Projected')){
                //Customized New SKU
                if(objSKU.SKU_Type__c=='MSO'){
                    RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Customized New SKU');
                    objWarp.estimates += 1;
                    mapRowWrap.put(objSKU.Category__c+'~Customized New SKU', objWarp);
                }
                //Non-Customized New SKU
                else{
                    RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Non-Customized New SKU');
                    objWarp.estimates += 1;
                    mapRowWrap.put(objSKU.Category__c+'~Non-Customized New SKU', objWarp);
                }
                RowWrapper objWarp1 = mapRowWrap.get(objSKU.Category__c);
	            objWarp1.estimates += 1;
	            mapRowWrap.put(objSKU.Category__c,objWarp1);
            }
        }
        
        for(SKU__c objSKU : [Select Id, Category__c, SKU_Type__c 
						        From SKU__c 
						        Where Category__c != null And Category__c != '' 
						        And Status__c = 'Remnant & Historical'
						        And CALENDAR_MONTH(Latest_Status_change_Date__c) =: mnth]){             
            //Customized Disco
            if(objSKU.SKU_Type__c=='MSO'){
                RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Customized Disco');
                objWarp.actual -= 1;
                mapRowWrap.put(objSKU.Category__c+'~Customized Disco', objWarp);
            }
            //Non-Customized Disco
            else{
                RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Non-Customized Disco');
                objWarp.actual -= 1;
                mapRowWrap.put(objSKU.Category__c+'~Non-Customized Disco', objWarp);
            }
            RowWrapper objWarp1 = mapRowWrap.get(objSKU.Category__c);
            objWarp1.actual -= 1;
            mapRowWrap.put(objSKU.Category__c,objWarp1);
		}
		
		for(SKU__c objSKU : [Select Id, SKU_Type__c, Category__c
						        From SKU__c 
						        Where Category__c != null And Category__c != '' 
						        And Status__c = 'Active & Planned'
						        And (CALENDAR_MONTH(Latest_Status_change_Date__c) =: mnth OR CALENDAR_MONTH(Latest_Undelete_Date__c) =: mnth)]){         
            //Customized New SKU
            if(objSKU.SKU_Type__c=='MSO'){
                RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Customized New SKU');
                objWarp.actual += 1;
                mapRowWrap.put(objSKU.Category__c+'~Customized New SKU', objWarp);
            }
            //Non-Customized New SKU
            else{
                RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Non-Customized New SKU');
                objWarp.actual += 1;
                mapRowWrap.put(objSKU.Category__c+'~Non-Customized New SKU', objWarp);
            }
            RowWrapper objWarp1 = mapRowWrap.get(objSKU.Category__c);
            objWarp1.actual += 1;
            mapRowWrap.put(objSKU.Category__c,objWarp1);
        }
        
        for(SKU__c objSKU : [Select Id, SKU_Type__c, Category__c
						        From SKU__c 
						        Where Category__c != null And Category__c != '' 
						        And Status__c =: 'Active & Planned' 
						        And CALENDAR_MONTH(Max_Actual_Date__c) =: lstMnth]){
				//Customized Disco
	            if(objSKU.SKU_Type__c=='MSO'){
	                RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Customized Deletes');
	                objWarp.actual -= 1;
	                mapRowWrap.put(objSKU.Category__c+'~Customized Deletes', objWarp);
	            }
	            //Non-Customized Disco
	            else{
	                RowWrapper objWarp = mapRowWrap.get(objSKU.Category__c+'~Non-Customized Deletes');
	                objWarp.actual -= 1;
	                mapRowWrap.put(objSKU.Category__c+'~Non-Customized Deletes', objWarp);
	            }
	            RowWrapper objWarp1 = mapRowWrap.get(objSKU.Category__c);
	            objWarp1.actual -= 1;
	            mapRowWrap.put(objSKU.Category__c,objWarp1);		        
    	}
        
        if(mapRowWrap != null && mapRowWrap.size() > 0){
            lstRowWrapper.addAll(mapRowWrap.values());
        }

        return lstRowWrapper;
    }
}