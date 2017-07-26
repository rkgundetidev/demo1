public with sharing class DisplaySLAStatusForSKUs{

    @AuraEnabled
    public static list<SKU__c> getSKUs(string Cat, string intf, string prjType){
        list<SKU__c> lstSKU = new list<SKU__c>();
        system.debug('Cat=='+Cat+'==intf=='+'==prjType=='+prjType);
        Date dtMax = Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
        integer mnth = dtMax.Month();
        integer yr = dtMax.Year();
        for(SKU__c newsku: [Select Id, Name, SKU_Description__c, Projection_Accuracy__c, Category__c, SKU_Type__c, Dish_Care_Group__c,
                            Max_Actual_Date__c, First_Actual_Date__c, First_Remnant_Date__c, Projected_Start_Date__c, 
                            Projected_Disco_Date__c, Latest_Projection_Date__c, Status__c
                            From SKU__c 
                            Where Category__c =: Cat  
                            And ((CALENDAR_MONTH(Projected_Start_Date__c) =: mnth And CALENDAR_YEAR(Projected_Start_Date__c) =: yr) 
                            OR (CALENDAR_MONTH(First_Remnant_Date__c) =: mnth And CALENDAR_YEAR(First_Remnant_Date__c) =: yr) 
                            OR (CALENDAR_MONTH(First_Actual_Date__c) =: mnth And CALENDAR_YEAR(First_Actual_Date__c) =: yr) 
                            OR (CALENDAR_MONTH(Projected_Disco_Date__c) =: mnth And CALENDAR_YEAR(Projected_Disco_Date__c) =: yr))]){
            if((prjType == 'Customized Disco' || prjType == 'Non-Customized Disco') 
            && (newsku.Projected_Disco_Date__c.month() == mnth && newsku.Projected_Disco_Date__c.year() == yr) 
            && (newsku.Status__c == 'Projected' || newsku.Status__c == 'Active & Planned')){
                //Completed as Planned
                if(intf == 'Completed as Planned' && (newsku.Projected_Start_Date__c == newsku.First_Actual_Date__c 
                    && newsku.Projected_Start_Date__c.month() == mnth && newsku.Projected_Start_Date__c.year() == yr) 
                        || 
                    (newsku.Projected_Disco_Date__c == newsku.First_Remnant_Date__c 
                    && newsku.Projected_Disco_Date__c.month() == mnth && newsku.Projected_Disco_Date__c.year() == yr)){
                    lstSKU.add(newsku);
                }else if(intf == 'Unplanned' && (newsku.Projected_Start_Date__c.month() != mnth && newsku.Projected_Start_Date__c.year() != yr
                    && newsku.First_Actual_Date__c != null && newsku.First_Actual_Date__c.month() == mnth && newsku.First_Actual_Date__c.year() == yr) 
                        || 
                    (newsku.Projected_Disco_Date__c.month() != mnth  && newsku.Projected_Disco_Date__c.year() != yr
                    && newsku.First_Remnant_Date__c != null && newsku.First_Remnant_Date__c.month() == mnth && newsku.First_Remnant_Date__c.year() == yr)){//Unplanned
                    lstSKU.add(newsku);
                }else if(intf == 'Not Completed as Planned' && (newsku.Projected_Start_Date__c.month() == mnth && newsku.Projected_Start_Date__c.year() == yr 
                    && newsku.Status__c == 'Projected') 
                        || 
                    (newsku.Projected_Disco_Date__c.month() == mnth  && newsku.Projected_Disco_Date__c.year() == yr 
                    && newsku.Status__c != 'Remnant & Historical')){//Missed/Not Completed as Planned
                   lstSKU.add(newsku);
                }
            }else if((prjType == 'Customized New SKU' || prjType == 'Non-Customized New SKU') 
            	&& newsku.Projected_Start_Date__c.month() == mnth && newsku.Projected_Start_Date__c.year() == yr 
                && newsku.Status__c == 'Projected'){
                //Completed as Planned
                if(intf == 'Completed as Planned' && (newsku.Projected_Start_Date__c == newsku.First_Actual_Date__c 
                    && newsku.Projected_Start_Date__c.month() == mnth && newsku.Projected_Start_Date__c.year() == yr) 
                    || 
                    (newsku.Projected_Disco_Date__c == newsku.First_Remnant_Date__c 
                    && newsku.Projected_Disco_Date__c.month() == mnth  && newsku.Projected_Disco_Date__c.year() == yr)){
                    lstSKU.add(newsku);
                }else if(intf == 'Unplanned' && (newsku.Projected_Start_Date__c.month() != mnth && newsku.Projected_Start_Date__c.year() != yr 
                        && newsku.First_Actual_Date__c != null && newsku.First_Actual_Date__c.month() == mnth && newsku.First_Actual_Date__c.year() == yr) 
                        || 
                        (newsku.Projected_Disco_Date__c.month() != mnth && newsku.Projected_Disco_Date__c.year() != yr
                        && newsku.First_Remnant_Date__c != null && newsku.First_Remnant_Date__c.month() == mnth && newsku.First_Remnant_Date__c.year() == yr)){//Unplanned
                    lstSKU.add(newsku);
                }else if(intf == 'Not Completed as Planned' && (newsku.Projected_Start_Date__c.month() == mnth && newsku.Projected_Start_Date__c.year() == yr 
                    && newsku.Status__c == 'Projected') 
                        || 
                    (newsku.Projected_Disco_Date__c.month() == mnth  && newsku.Projected_Disco_Date__c.year() == yr 
                    && newsku.Status__c != 'Remnant & Historical')){//Missed/Not Completed as Planned
                    lstSKU.add(newsku);
                }
			}
			if(string.isBlank(prjType) 
				&& 
			((newsku.Projected_Disco_Date__c.month() == mnth && newsku.Projected_Disco_Date__c.year() == yr) 
            && (newsku.Status__c == 'Projected' || newsku.Status__c == 'Active & Planned')
            	||
            (newsku.Projected_Start_Date__c.month() == mnth && newsku.Projected_Start_Date__c.year() == yr 
                && newsku.Status__c == 'Projected')	
            )){
				//Completed as Planned
                if(intf == 'Completed as Planned' && (newsku.Projected_Start_Date__c == newsku.First_Actual_Date__c 
                    && newsku.Projected_Start_Date__c.month() == mnth && newsku.Projected_Start_Date__c.year() == yr) 
                    || 
                    (newsku.Projected_Disco_Date__c == newsku.First_Remnant_Date__c 
                    && newsku.Projected_Disco_Date__c.month() == mnth  && newsku.Projected_Disco_Date__c.year() == yr)){
                    lstSKU.add(newsku);
                }else if(intf == 'Unplanned' && (newsku.Projected_Start_Date__c.month() != mnth && newsku.Projected_Start_Date__c.year() != yr 
                        && newsku.First_Actual_Date__c != null && newsku.First_Actual_Date__c.month() == mnth && newsku.First_Actual_Date__c.year() == yr) 
                        || 
                        (newsku.Projected_Disco_Date__c.month() != mnth && newsku.Projected_Disco_Date__c.year() != yr
                        && newsku.First_Remnant_Date__c != null && newsku.First_Remnant_Date__c.month() == mnth && newsku.First_Remnant_Date__c.year() == yr)){//Unplanned
                    lstSKU.add(newsku);
                }else if(intf == 'Not Completed as Planned' && (newsku.Projected_Start_Date__c.month() == mnth && newsku.Projected_Start_Date__c.year() == yr 
                    && newsku.Status__c == 'Projected') 
                        || 
                    (newsku.Projected_Disco_Date__c.month() == mnth  && newsku.Projected_Disco_Date__c.year() == yr 
                    && newsku.Status__c != 'Remnant & Historical')){//Missed/Not Completed as Planned
                    lstSKU.add(newsku);
                }
			}
        }
        system.debug('===size==='+lstSKU.size());
        return lstSKU;
    }
}