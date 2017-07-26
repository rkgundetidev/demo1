public with sharing class ActualVsProjectionController{
    public class RowWrapper{
        @AuraEnabled public String category;
        @AuraEnabled public String cat;
        @AuraEnabled public String projtype;
        @AuraEnabled public integer CmptAsPlan;
        @AuraEnabled public integer unPlan;
        @AuraEnabled public integer NotdoneAsPlan;
        @AuraEnabled public string strClr;
        
        public RowWrapper(String category, String cat, String projtype, integer CmptAsPlan, integer unPlan, integer NotdoneAsPlan, string strClr){
            this.category = category;
            this.cat = cat;
            this.projtype = projtype;
            this.CmptAsPlan = CmptAsPlan;
            this.unPlan = unPlan;
            this.NotdoneAsPlan = NotdoneAsPlan;
            this.strClr = strClr;
        }
    }
    
    @AuraEnabled
    public static RowWrapper[] getEstimateAndActualSKUCount(){
        
        list<RowWrapper> lstRowWrapper = new list<RowWrapper>();
        
        map<string, RowWrapper> mapRowWrap = new map<string, RowWrapper>();
        mapRowWrap.put('Air Care~Customized New SKU~New SKU', new RowWrapper('Air Care','Air Care','Customized New SKU',0,0,0,'e3f3ff'));
        mapRowWrap.put('Air Care~Customized Disco~Disco', new RowWrapper('','Air Care','Customized Disco',0,0,0,'e3f3ff'));
        mapRowWrap.put('Air Care~Non-Customized New SKU~New SKU', new RowWrapper('','Air Care','Non-Customized New SKU',0,0,0,'e3f3ff'));
        mapRowWrap.put('Air Care~Non-Customized Disco~Disco', new RowWrapper('','Air Care','Non-Customized Disco',0,0,0,'e3f3ff'));
        mapRowWrap.put('Air Care',new RowWrapper('Air Care Total','Air Care','',0,0,0,'408fd5'));
        
        mapRowWrap.put('Dish Care~Customized New SKU~New SKU', new RowWrapper('Dish Care','Dish Care','Customized New SKU',0,0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care~Customized Disco~Disco', new RowWrapper('','Dish Care','Customized Disco',0,0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care~Non-Customized New SKU~New SKU', new RowWrapper('','Dish Care','Non-Customized New SKU',0,0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care~Non-Customized Disco~Disco', new RowWrapper('','Dish Care','Non-Customized Disco',0,0,0,'e3f3ff'));
        mapRowWrap.put('Dish Care',new RowWrapper('Dish Care Total','Dish Care','',0,0,0,'408fd5'));
        
        mapRowWrap.put('Surface Care~Customized New SKU~New SKU', new RowWrapper('Surface Care','Surface Care','Customized New SKU',0,0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care~Customized Disco~Disco', new RowWrapper('','Surface Care','Customized Disco',0,0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care~Non-Customized New SKU~New SKU', new RowWrapper('','Surface Care','Non-Customized New SKU',0,0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care~Non-Customized Disco~Disco', new RowWrapper('','Surface Care','Non-Customized Disco',0,0,0,'e3f3ff'));
        mapRowWrap.put('Surface Care',new RowWrapper('Surface Care Total','Surface Care','',0,0,0,'408fd5'));
        
        Date dtMax = Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
        integer mnth = dtMax.Month();
        integer yr = dtMax.Year();
        
        integer lstMnth = mnth-1;
		Date firstDay2MnthsAgo = Date.newInstance(dtMax.Year(),dtMax.Month()-1,1);
        
        //Completed as Planned
        for(SKU__c newsku: [Select Id, Projection_Accuracy__c, Category__c, SKU_Type__c, Dish_Care_Group__c,
                            Max_Actual_Date__c, Latest_Status_change_Date__c, Latest_Undelete_Date__c, Projected_Start_Date__c, 
                            Projected_Disco_Date__c, Latest_Projection_Date__c, Status__c
                            From SKU__c 
                            Where (Category__c != null And Category__c != '') 
                            And  (((Latest_Undelete_date__c = last_month or Latest_status_change_date__c = last_month) AND Projected_Start_Date__c = LAST_MONTH) OR (latest_status_change_date__c = last_month and Projected_Disco_Date__c = last_month))]){
             
			/*if((((newsku.Latest_status_change_date__c != null && newsku.Projected_Start_Date__c == newsku.Latest_status_change_date__c) 
				|| (newsku.Latest_Undelete_date__c != null && newsku.Projected_Start_Date__c == newsku.Latest_Undelete_date__c)) 
	         	&& newsku.Projected_Start_Date__c.month() == mnth) 
         	|| (newsku.latest_status_change_date__c != null && newsku.Projected_Disco_Date__c == newsku.latest_status_change_date__c 
         		&& newsku.Projected_Disco_Date__c.month() == mnth)) { */
				
				string ProjType = '';
	            string intFace = '';         			
				if(newsku.Status__c == 'Remnant & Historical'){
	                //disco 
	                intFace = 'Disco';
	                if(string.isNotBlank(newsku.SKU_Type__c) && newsku.SKU_Type__c=='MSO'){
	                    ProjType = 'Customized Disco';
	                }else{
	                    ProjType = 'Non-Customized Disco';
	                }
				}else if(newsku.Status__c == 'Active & Planned'){
	                //new sku
	                ProjType = '';
	                intFace = 'New SKU';
	                if(string.isNotBlank(newsku.SKU_Type__c) && newsku.SKU_Type__c=='MSO'){
	                    ProjType = 'Customized New SKU';
	                }else{
	                    ProjType = 'Non-Customized New SKU';
	                }
				}  
				if(string.isNotBlank(ProjType) && string.isNotBlank(intFace)){
					RowWrapper objWrap = mapRowWrap.get(newsku.Category__c+'~'+ProjType+'~'+intFace);
	                RowWrapper objtotWrap = mapRowWrap.get(newsku.Category__c);
					objWrap.CmptAsPlan += 1;
	                objtotWrap.CmptAsPlan += 1;		
	                
	                mapRowWrap.put(newsku.Category__c+'~'+ProjType+'~'+intFace, objWrap);
	                mapRowWrap.put(newsku.Category__c,objtotWrap);
				}
//			}
                            
		}
		
		//Unplanned
		for(SKU__c newsku: [Select Id, Projection_Accuracy__c, Category__c, SKU_Type__c, Dish_Care_Group__c,
                            Max_Actual_Date__c, Latest_Status_change_Date__c, Latest_Undelete_Date__c, Projected_Start_Date__c, 
                            Projected_Disco_Date__c, Latest_Projection_Date__c, Status__c
                            From SKU__c 
                            Where (Category__c != null And Category__c != '') 
                            And ((Projected_Start_Date__c!= Last_month and (latest_status_change_date__c = last_month or latest_undelete_date__c = last_month) and status__c='Active & Planned') or  (Projected_Disco_Date__c!= last_month and latest_status_change_date__c=last_month and status__c='Remnant & Historical'))]){
             
			/*if((newsku.Projected_Start_Date__c.month() != mnth && newsku.latest_status_change_date__c != null && newsku.latest_status_change_date__c.month() == mnth) 
				|| (newsku.latest_undelete_date__c != null && newsku.latest_undelete_date__c.month() == mnth && newsku.status__c == 'Active & Planned') 
				|| (newsku.Projected_Disco_Date__c.month() != mnth && newsku.latest_status_change_date__c != null && newsku.latest_status_change_date__c.month() == mnth 
				&& newsku.status__c == 'Remnant & Historical')){*/
				
				string ProjType = '';
	            string intFace = '';         			
				if(newsku.Status__c == 'Remnant & Historical'){
	                //disco 
	                intFace = 'Disco';
	                if(string.isNotBlank(newsku.SKU_Type__c) && newsku.SKU_Type__c=='MSO'){
	                    ProjType = 'Customized Disco';
	                }else{
	                    ProjType = 'Non-Customized Disco';
	                }
				}else if(newsku.Status__c == 'Active & Planned'){
	                //new sku
	                ProjType = '';
	                intFace = 'New SKU';
	                if(string.isNotBlank(newsku.SKU_Type__c) && newsku.SKU_Type__c=='MSO'){
	                    ProjType = 'Customized New SKU';
	                }else{
	                    ProjType = 'Non-Customized New SKU';
	                }
				} 
				if(string.isNotBlank(ProjType) && string.isNotBlank(intFace)){ 
					RowWrapper objWrap = mapRowWrap.get(newsku.Category__c+'~'+ProjType+'~'+intFace);
	                RowWrapper objtotWrap = mapRowWrap.get(newsku.Category__c);
					objWrap.unPlan += 1;
	                objtotWrap.unPlan += 1;		
	                
	                mapRowWrap.put(newsku.Category__c+'~'+ProjType+'~'+intFace, objWrap);
	                mapRowWrap.put(newsku.Category__c,objtotWrap);	
				}
//			}
                            
		}
		
		//Missed/Not Completed as Planned
		for(SKU__c newsku: [Select Id, Projection_Accuracy__c, Category__c, SKU_Type__c, Dish_Care_Group__c,
                            Max_Actual_Date__c, Latest_Status_change_Date__c, Latest_Undelete_Date__c, Projected_Start_Date__c, 
                            Projected_Disco_Date__c, Latest_Projection_Date__c, Status__c
                            From SKU__c 
                            Where (Category__c != null And Category__c != '') 
                            And ((Projected_Start_Date__c = last_month and status__c ='Projected') OR (Projected_Start_Date__c = last_month and status__c ='Active & Planned' and latest_status_change_date__c!= last_month and latest_undelete_date__c != last_month) OR (Projected_Disco_Date__c = last_month and status__c != 'Remnant & Historical') or (Projected_Disco_Date__c = last_month and status__c = 'Remnant & Historical' and latest_status_change_date__c!= last_month) or ((Projected_Start_Date__c=last_month or Projected_Disco_Date__c = last_month) and Max_actual_Date__c=:firstDay2MnthsAgo))]){
             
			/*if((newsku.Projected_Start_Date__c.month() == mnth && newsku.status__c == 'Projected') 
			|| (newsku.Projected_Disco_Date__c.month() == mnth && newsku.status__c != 'Remnant & Historical') 
			|| ((newsku.Projected_Start_Date__c.month() == mnth || newsku.Projected_Disco_Date__c.month() == mnth) 
			&& newsku.Max_actual_Date__c.month() == lstMnth)){ */
				
				string ProjType = '';
	            string intFace = '';         			
				if(newsku.Projected_Start_Date__c==dtMax && (newsku.Status__c!='Active & Planned' || (newsku.latest_status_change_date__c!=dtMax && newsku.latest_undelete_date__c!=dtMax))){
					 //new sku
	                ProjType = '';
	                intFace = 'New SKU';
	                if(string.isNotBlank(newsku.SKU_Type__c) && newsku.SKU_Type__c=='MSO'){
	                    ProjType = 'Customized New SKU';
	                }else{
	                    ProjType = 'Non-Customized New SKU';
	                }
				}
				if(newsku.Projected_Disco_Date__c==dtMax && (newsku.Status__c!='Remnant & Historical'||newsku.latest_status_change_date__c!=dtMax)){
	                 //disco 
	                intFace = 'Disco';
	                if(string.isNotBlank(newsku.SKU_Type__c) && newsku.SKU_Type__c=='MSO'){
	                    ProjType = 'Customized Disco';
	                }else{
	                    ProjType = 'Non-Customized Disco';
	                }
				}  
				if(string.isNotBlank(ProjType) && string.isNotBlank(intFace)){
					RowWrapper objWrap = mapRowWrap.get(newsku.Category__c+'~'+ProjType+'~'+intFace);
	                RowWrapper objtotWrap = mapRowWrap.get(newsku.Category__c);
					objWrap.NotdoneAsPlan += 1;
	                objtotWrap.NotdoneAsPlan += 1;	
	                
	                mapRowWrap.put(newsku.Category__c+'~'+ProjType+'~'+intFace, objWrap);
	                mapRowWrap.put(newsku.Category__c,objtotWrap);		
				}
//			}
		}
        
        if(mapRowWrap != null && mapRowWrap.size() > 0){
            lstRowWrapper.addAll(mapRowWrap.values());
        }

        return lstRowWrapper;
    }
}