public with sharing class DisplaySKUs{

    @AuraEnabled
    public static list<SKU__c> getSKUs(string Cat, string intf){
        list<SKU__c> lstSKU = new list<SKU__c>();
        Date dtMax = Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
        integer mnth = dtMax.Month();
        integer yr = dtMax.Year();
        integer lstMnth = dtMax.Month()-1;
        if(intf == 'Actual'){
        	for(SKU__c objSKU : [Select Id, Name, SKU_Description__c, Category__c, Status__c, Projected_Start_Date__c, 
        							Projected_Disco_Date__c, Max_Actual_Date__c 
                                    From SKU__C 
                                    Where Category__c =: Cat
                                    And Status__c = 'Active & Planned'
                                    And Max_Actual_Date__c =: dtMax  ]){ 
	            lstSKU.add(objSKU);
	        }
		}else if(intf == 'Estimate'){
			set<string> setSKUsFromActuals = new set<string>();
	        for(SKU_Actual__c objSKUActual : [Select SKU__c From SKU_Actual__c 
	                                    Where SKU_Category__c =: Cat
	                                    And Status__c = 'Active & Planned'
	                                    And CALENDAR_MONTH(Date__c) =: lstMnth]){ 
	            setSKUsFromActuals.add(objSKUActual.SKU__c);
	        }
	        for(SKU__c objSKU : [Select Id, Status__c, Projected_Start_Date__c, Projected_Disco_Date__c 
	                                    From SKU__c 
	                                    Where Category__c =: Cat 
	                                    And Status__c IN ('Active & Planned','Remnant & Historical','Projected') 
	                                    And Max_Actual_Date__c =: dtMax ]){ 
	            if(objSKU.Projected_Disco_Date__c.Month() == mnth && objSKU.Projected_Disco_Date__c.Year() == yr 
	            && (objSKU.Status__c == 'Active & Planned' || objSKU.Status__c == 'Remnant & Historical' || objSKU.Status__c == 'Projected')){
	                setSKUsFromActuals.remove(objSKU.Id);
	            }
	            if(objSKU.Projected_Start_Date__c.Month() == mnth && objSKU.Projected_Start_Date__c.Year() == yr 
	            && (objSKU.Status__c == 'Active & Planned' || objSKU.Status__c == 'Projected')){
	                setSKUsFromActuals.add(objSKU.Id);
	            }
	        }
	        for(SKU__c objSKU : [Select Id, Name, SKU_Description__c, Category__c, Status__c, Projected_Start_Date__c, 
        								Projected_Disco_Date__c, Max_Actual_Date__c 
	                                    From SKU__c Where Id IN: setSKUsFromActuals]){
				lstSKU.add(objSKU);                     
			}
		}
        system.debug('===size==='+lstSKU.size());
        return lstSKU;
    }
    
    @AuraEnabled
    public static list<SKU__c> getDetailedSKUs(string Cat, string intf, string prjType){
    	system.debug('Cat=='+Cat+'==intf=='+intf+'==prjType=='+prjType);
    	list<SKU__c> lstSKU = new list<SKU__c>();
    	Date dtMax = Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
        integer mnth = dtMax.Month();
        integer yr = dtMax.Year();
        String curMonthString = DateTime.newInstanceGMT(System.Date.newInstance(2000, dtMax.month(), 1), System.Time.newInstance(0, 0, 0, 0)).formatGMT('MMM');
    
        Integer lstMnth = dtMax.month()-1;
        String lstMonthString = DateTime.newInstanceGMT(System.Date.newInstance(2000, lstMnth, 1), System.Time.newInstance(0, 0, 0, 0)).formatGMT('MMM');
        
        if(((intf == 'Actual' || intf == 'Estimate') && string.isNotBlank(prjType) && prjType == lstMonthString+' SKU Count (A&P)')
        || (intf == 'Estimate' && string.isBlank(prjType))){
        	set<string> setSKUIds = new set<string>();
        	for(SKU_Actual__c objActual : [Select Id, SKU__c From SKU_Actual__c Where SKU_Category__c =: Cat
	                                    And Status__c = 'Active & Planned'
	                                    And CALENDAR_MONTH(Date__c) =: lstMnth]){ 
        		setSKUIds.add(objActual.SKU__c);
        	}
        	if(setSKUIds != null && setSKUIds.size() > 0){
	        	for(SKU__c objSKU : [Select Id, Name, SKU_Description__c, Category__c, Status__c, Projected_Start_Date__c, 
	        							Projected_Disco_Date__c, Max_Actual_Date__c 
	        							From SKU__c Where ID IN:setSKUIds]){
	        		lstSKU.add(objSKU); 
	        	}
        	}
    	}else if(intf == 'Actual'){
        	if(string.isNotBlank(prjType)){
        		if(prjType == 'Customized Deletes' || prjType == 'Non-Customized Deletes'){
        			for(SKU__c objSKU : [Select Id, Name, SKU_Type__c, SKU_Description__c, Category__c, Status__c, Projected_Start_Date__c, 
		        							Projected_Disco_Date__c, Max_Actual_Date__c 
		        							From SKU__c 
									        Where Category__c =: Cat 
									        And Status__c =: 'Active & Planned' 
									        And CALENDAR_MONTH(Max_Actual_Date__c) =: lstMnth]){
						if(objSKU.SKU_Type__c=='MSO' && prjType == 'Customized Deletes'){
			                lstSKU.add(objSKU);
			            }else if(objSKU.SKU_Type__c!='MSO' && prjType == 'Non-Customized Deletes'){
			                lstSKU.add(objSKU);
			            }								        
			    	}
        		}else if(prjType == 'Customized Disco' || prjType == 'Non-Customized Disco'){
        			for(SKU__c objSKU : [Select  Id, Name, SKU_Type__c, SKU_Description__c, Category__c, Status__c, Projected_Start_Date__c, 
	        								Projected_Disco_Date__c, Max_Actual_Date__c
									        From SKU__c 
									        Where Category__c =: Cat 
									        And Status__c = 'Remnant & Historical'
									        And CALENDAR_MONTH(Latest_Status_change_Date__c) =: mnth]){             
			            if(objSKU.SKU_Type__c=='MSO' && prjType == 'Customized Disco'){
			                lstSKU.add(objSKU);
			            }else if(objSKU.SKU_Type__c!='MSO' && prjType == 'Non-Customized Disco'){
			                lstSKU.add(objSKU);
			            }
					}
        		}else if(prjType == 'Customized New SKU' || prjType == 'Non-Customized New SKU'){
	        		for(SKU__c objSKU : [Select  Id, SKU_Type__c, Name, SKU_Description__c, Category__c, Status__c, Projected_Start_Date__c, 
	        								Projected_Disco_Date__c, Max_Actual_Date__c
									        From SKU__c 
									        Where Category__c =: Cat
									        And Status__c = 'Active & Planned'
									        And (CALENDAR_MONTH(Latest_Status_change_Date__c) =: mnth OR CALENDAR_MONTH(Latest_Undelete_Date__c) =: mnth)]){         
			            if(objSKU.SKU_Type__c=='MSO' && prjType == 'Customized New SKU'){
			                lstSKU.add(objSKU);
			            }else if(objSKU.SKU_Type__c!='MSO' && prjType == 'Non-Customized New SKU'){
			                lstSKU.add(objSKU);
			            }
			        }
        		}
        	}else{
        		for(SKU__c objSKU : [Select Id, Name, SKU_Description__c, Category__c, Status__c, Projected_Start_Date__c, 
	        							Projected_Disco_Date__c, Max_Actual_Date__c 
	                                    From SKU__C 
	                                    Where Category__c =: Cat
	                                    And Status__c = 'Active & Planned'
	                                    And Max_Actual_Date__c =: dtMax  ]){ 
		              lstSKU.add(objSKU);
		        }
        	}
        } 
        if(intf == 'Estimate' && ((string.isBlank(prjType) && lstSKU != null && lstSKU.size() > 0)
        || (string.isNotBlank(prjType) && (lstSKU == null || lstSKU.size() == 0)))){
			for(SKU__c objSKU : [Select Id, Name, SKU_Description__c, Category__c, Status__c, SKU_Type__c, 
	                            Projected_Start_Date__c, Projected_Disco_Date__c, Max_Actual_Date__c,
	                            Latest_Undelete_Date__c,  Latest_Status_change_Date__c
	                            From SKU__c 
	                            Where Category__c =: Cat 
	                            And Status__c IN ('Active & Planned','Remnant & Historical','Projected') 
	                            And Max_Actual_Date__c =: dtMax]){ 
                
	            if(objSKU.Projected_Disco_Date__c != null && objSKU.Projected_Disco_Date__c.Month() == mnth && objSKU.Projected_Disco_Date__c.Year() == yr 
	            && (objSKU.Status__c == 'Active & Planned' || objSKU.Status__c == 'Remnant & Historical' || objSKU.Status__c == 'Projected')){
	                
	                if(string.isNotBlank(prjType) && objSKU.SKU_Type__c=='MSO' && prjType == 'Customized Disco'){
	                    lstSKU.add(objSKU);
	                }else if(string.isNotBlank(prjType) && objSKU.SKU_Type__c!='MSO' && prjType == 'Non-Customized Disco'){
	                    lstSKU.add(objSKU);
	                }else if(string.isBlank(prjType)){
	                	lstSKU.add(objSKU);
	                }
	            }
	           	if(objSKU.Projected_Start_Date__c != null && objSKU.Projected_Start_Date__c.Month() == mnth && objSKU.Projected_Start_Date__c.Year() == yr 
	            && (objSKU.Status__c == 'Active & Planned' || objSKU.Status__c == 'Projected')){
	                if(string.isNotBlank(prjType) && objSKU.SKU_Type__c=='MSO' && prjType == 'Customized New SKU'){
	                    lstSKU.add(objSKU);
	                }
	                else if(string.isNotBlank(prjType) && objSKU.SKU_Type__c!='MSO' && prjType == 'Non-Customized New SKU'){
	                	lstSKU.add(objSKU);
	                }else if(string.isBlank(prjType)){
	                	lstSKU.add(objSKU);
	                }
	            }
            }
        }
        
    	system.debug('===size==='+lstSKU.size());
        return lstSKU;
    }
}