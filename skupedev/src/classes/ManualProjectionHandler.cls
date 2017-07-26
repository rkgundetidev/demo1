public class ManualProjectionHandler {

    public void handleInsert(){
        SKU__c defaultMasterSKURec = [Select Id from SKU__c where Name='Manual Projection Default Holder SKU' Limit 1];
        
        for(Manual_Projection__c manProj:(Manual_Projection__c[]) Trigger.new){
            manProj.SKU_Mstr__c = defaultMasterSKURec.Id;
        }
    }

    public void handleUpdate(){
        Set<String> skusToFetch = new Set<String>();
        SKU__c defaultMasterSKURec = [Select Id from SKU__c where Name='Manual Projection Default Holder SKU' Limit 1];
        Manual_Projection__c[] existingProjectionsToExclude = new Manual_Projection__c[]{};

        for(Manual_Projection__c manProj:(Manual_Projection__c[]) Trigger.new){
            // Update Master SKU record if there has been an update to the SKU number.
            if(manProj.SKU__c!=((Manual_Projection__c)Trigger.oldMap.get(manProj.Id)).SKU__c){
                skusToFetch.add(manProj.SKU__c);
            }
        }

        if(skusToFetch.size()>0){
            Map<String,SKU__c> skuMap = new Map<String,SKU__c>();
            for(SKU__c sk:[Select SKU__c,(Select Include_in_New_SKU_Projections__c from Manual_Projections__r where Include_in_New_SKU_Projections__c=true) from SKU__c where SKU__c in :skusToFetch]){
                skuMap.put(sk.SKU__c,sk);
            }

            for(Manual_Projection__c manProj:(Manual_Projection__c[]) Trigger.new){
                if(skuMap.containsKey(manProj.SKU__c)){
                    SKU__c masterSKU = skuMap.get(manProj.SKU__c);
                    manProj.SKU_Mstr__c=masterSKU.Id;
                    if(masterSKU.Manual_Projections__r.size()>0){
                        existingProjectionsToExclude.add(new Manual_Projection__c(Id=masterSKU.Manual_Projections__r[0].Id,Include_in_New_SKU_Projections__c=false));
                    }
                }else{
                    manProj.SKU_Mstr__c = defaultMasterSKURec.Id;
                }
            }

            if(existingProjectionsToExclude.size()>0){
                update existingProjectionsToExclude;
            }
        }
    }

    public void handleDelete(){

    }

}