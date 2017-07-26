/**

    Description: Performs Tasks related to adjusting values and relationships when a new SKU Projection record is created
                 a) For new Manual Projections, relates it to the Default Master SKU record.
                 b) When an update is made to the SKU on a manual projection, reparents it to the new SKU record.
**/

public class SKUProjectionTriggerHandler {

    public static void handleInsert(){
        list<SKU__c> defaultMasterSKURec = [Select Id from SKU__c where Name='Manual Projection Default Parent SKU' Limit 1];
        
        if(defaultMasterSKURec!=null && defaultMasterSKURec.size()>0)
        {
	        for(SKU_Projection__c skuProj:(SKU_Projection__c[]) Trigger.new){
	            if(skuProj.Source__c=='Manual'){
	                skuProj.SKU__c = defaultMasterSKURec[0].Id;
	            }
	        }
        }
    }

    public static void handleUpdate(){

        Set<String> skusToFetch = new Set<String>();
        list<SKU__c> defaultMasterSKURec = [Select Id from SKU__c where Name='Manual Projection Default Parent SKU' Limit 1];
        SKU_Projection__c[] existingProjectionsToExclude = new SKU_Projection__c[]{};

        for(SKU_Projection__c skuProj:(SKU_Projection__c[]) Trigger.new){
            // Update Master SKU record if there has been an update to the SKU number.
            if(skuProj.Source__c=='Manual' && skuProj.SKU_Text__c!=((SKU_Projection__c)Trigger.oldMap.get(skuProj.Id)).SKU_Text__c){
                skusToFetch.add(skuProj.SKU_Text__c);
            }
        }

        if(skusToFetch.size()>0){
            Map<String,SKU__c> skuMap = new Map<String,SKU__c>();
            for(SKU__c sk:[Select SKU__c,(Select Include_in_Projections_Manual__c from SKU_Projections__r where Include_in_Projections__c=true and Source__c='Manual') from SKU__c where SKU__c in :skusToFetch]){
                skuMap.put(sk.SKU__c,sk);
            }

            for(SKU_Projection__c skuProj:(SKU_Projection__c[]) Trigger.new){
                if(skuMap.containsKey(skuProj.SKU__c)){
                    SKU__c masterSKU = skuMap.get(skuProj.SKU_Text__c);
                    skuProj.SKU__c = masterSKU.Id;
                    if(masterSKU.SKU_Projections__r.size()>0){
                        existingProjectionsToExclude.add(new SKU_Projection__c(Id=masterSKU.SKU_Projections__r[0].Id,Include_in_Projections_Manual__c=false));
                    }
                }else{
                	if(defaultMasterSKURec!=null && defaultMasterSKURec.size()>0)
                	{
                    	skuProj.SKU__c = defaultMasterSKURec[0].Id;
                	}
                }
            }

            if(existingProjectionsToExclude.size()>0){
                update existingProjectionsToExclude;
            }
        }
    }

}