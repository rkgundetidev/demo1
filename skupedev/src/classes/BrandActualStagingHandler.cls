public class BrandActualStagingHandler {

    public static void CreateSKUAndBrand() {
         Map<String,Brand__c> brandCodeMap = new Map<String,Brand__c>();
         Map<String,SKU__c> skuCodeMap = new Map<String,SKU__c>();
        for(Brand_Actual_Staging__c ba: (Brand_Actual_Staging__c[])Trigger.new) {
            SKU__c theSKU = new SKU__c(Name=ba.Sku_Code_Source__c,SKU__c=ba.Sku_Code_Source__c,Status__c=ba.Status__c);
            Brand__c theBrand = new Brand__c(Name=ba.Brand_Code_Source__c,Brand_Code__c=ba.Brand_Code_Source__c,Status__c=ba.Status__c,sku__r=new SKU__c(SKU__c=ba.Sku_Code_Source__c));
            skuCodeMap.put(ba.Sku_Code_Source__c,theSKU);
            brandCodeMap.put(ba.Brand_Code_Source__c,theBrand);    
        }

         for(SKU__C sk: [Select SKU__c from SKU__c where SKU__c in :skuCodeMap.keySet()]){
            skuCodeMap.remove(sk.SKU__c);
        }
        if(skuCodeMap.size()>0){
            insert skuCodeMap.values();
        }
        for(Brand__c b: [Select Brand_Code__c from Brand__c where Brand_Code__c in :brandCodeMap.keySet()]){
            brandCodeMap.remove(b.Brand_Code__c);
        }
        if(brandCodeMap.size()>0){
            insert brandCodeMap.values();
        }
      

    }

    public static void handleInsert(){
        Brand_Actual__c[] bas = new Brand_Actual__c[]{};
        Map<String,SKU_Actual__c> skuActualCodeMap = new Map<String,SKU_Actual__c>();
        
        Time t = Time.newInstance(0,0,0,0);
        Date actualdate = ((Brand_Actual_Staging__c[])Trigger.new)[0].Date__c;
        //LatestDates__c latestDtSetting = LatestDates__c.getInstance();
        LatestDates__c latestDtSetting = LatestDates__c.getOrgDefaults();
      
       
        SKU__c[] skusWithLatestDate = [Select Id from SKU__c where Max_Actual_date__c >= :latestDtSetting.Date__c limit 1];
        if(latestDtSetting.Date__c<actualdate || skusWithLatestDate.size()==0){
            latestDtSetting.Date__c = actualDate;
            update latestDtSetting;
        }
        for(Brand_Actual_Staging__c ba: (Brand_Actual_Staging__c[])Trigger.new){

            String monthName = DateTime.newInstance(ba.date__c,t).format('MMMM');
            String skuActualUniqueId = monthName+'-'+ba.Date__c.year()+'-'+ba.SKU_Code__c;
            String brandActualUniqueId = monthName+'-'+ba.Date__c.year()+'-'+ba.Brand_code__c;
            if(!skuActualCodeMap.containsKey(skuActualUniqueId)){
                SKU_Actual__c theSKUActual = new SKU_Actual__c(SKU__r=new SKU__c(SKU__c=ba.SKU_Code__c),Date__c=ba.Date__c,SKU_Actual_Unique_Id__c=skuActualUniqueId,Name=skuActualUniqueId,Month__c=monthName);
                skuActualCodeMap.put(skuActualUniqueId,theSKUActual);
            }

            Brand_Actual__c theBrandActual = new Brand_Actual__c(Name=brandActualUniqueId,Date__c=ba.Date__c,Brand__r=new Brand__c(Brand_Code__c=ba.Brand_Code__c),EOH_Inventory__c=ba.EOH_Inventory__c,Month__c=monthName,SKU_Actual__r = new SKU_Actual__c(SKU_Actual_Unique_Id__c=skuActualUniqueId),Status__c=ba.Status__c);
            
            bas.add(theBrandActual);
            
        }

        for(SKU_Actual__c sk: [Select SKU_Actual_Unique_Id__c from SKU_Actual__c where SKU_Actual_Unique_Id__c in :skuActualCodeMap.keySet()]){
            skuActualCodeMap.remove(sk.SKU_Actual_Unique_Id__c);
        }
        if(skuActualCodeMap.size()>0){
            insert skuActualCodeMap.values();
        }
        insert bas;
      //  TruncateFuture.truncate(new Map<Id,Brand_Actual_Staging__c>([select Id from Brand_Actual_Staging__c]).keySet(),'Brand_Actual_Staging__c');
    }
}