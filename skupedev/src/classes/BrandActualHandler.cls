public class BrandActualHandler {

    public static void handleInsert(){
        SKU_Actual__c[] newSKUActuals = new SKU_Actual__c[]{};
        
        Time t = Time.newInstance(0,0,0,0);
        Map<String,SKU_Actual__c> skuActualMapBrandCode = new Map<String,SKU_Actual__c>();
        Map<String,SKU_Actual__c> skuActualMapSKUNumber = new Map<String,SKU_Actual__c>();
        for(Brand_Actual__c actual: (Brand_Actual__c[])Trigger.new){
            if(actual.SKU_Actual__c==null){
                String monthName = DateTime.newInstance(actual.date__c,t).format('MMMM');
                String skuActualUniqueId = monthName+'-'+actual.Date__c.year()+'-'+actual.SKU__c;
                // This doesn't work in a before trigger
                //actual.SKU_Actual__r=new SKU_Actual__c(SKU_Actual_Unique_Id__c=skuActualUniqueId);
                actual.Month__c=monthName;
                actual.Name=monthName+'-'+actual.Date__c.year()+'-'+actual.Brand_code__c;
                if(skuActualMapSKUNumber.containsKey(skuActualUniqueId)){
                    skuActualMapBrandCode.put(actual.Name,skuActualMapSKUNumber.get(skuActualUniqueId));
                }else{
                    SKU_Actual__c skuActual = new SKU_Actual__c(SKU__c=actual.SKU_Id__c,Date__c=actual.Date__c,SKU_Actual_Unique_Id__c=skuActualUniqueId,Name=skuActualUniqueId,Month__c=monthName);
                    skuActualMapSKUNumber.put(skuActualUniqueId,skuActual);
                    skuActualMapBrandCode.put(actual.Name,skuActual);
                }
            }
        }
        if(skuActualMapSKUNumber.size()>0){
            upsert skuActualMapSKUNumber.values() SKU_Actual_Unique_Id__c;
        }
        for(Brand_Actual__c actual: (Brand_Actual__c[])Trigger.new){
            actual.SKU_Actual__c = skuActualMapBrandCode.get(actual.Name).Id;
        }
    }
}