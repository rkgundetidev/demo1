trigger BrandActualStagingTrigger on Brand_Actual_Staging__c (before insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            //BrandActualStagingHandler.handleInsert();
           //BrandActualStagingHandler.CreateSKUAndBrand();
             Map<String,Brand__c> brandCodeMap = new Map<String,Brand__c>();
             Map<String,SKU__c> skuCodeMap = new Map<String,SKU__c>();
             Set<String> brandCodeSet = new Set<String>();
             Set<String> skuCodeSet = new Set<String>();
             SKU__c theSKU;
             Brand__c theBrand;
             
                     
             for(Brand_Actual_Staging__c ba: (Brand_Actual_Staging__c[])Trigger.new) {
               brandCodeSet.add(ba.Brand_Code_Source__c);
               skuCodeSet.add(ba.Sku_Code_Source__c);
            }
                     
            for(Brand_Actual_Staging__c ba: (Brand_Actual_Staging__c[])Trigger.new) {
                      
                theSKU = new SKU__c(Name=ba.Sku_Code_Source__c,SKU__c=ba.Sku_Code_Source__c,Status__c=ba.Status__c,Category__c=ba.Category__c,Dish_Care_Group__c=ba.Group__c,GBU__c=ba.GBU__c,SKU_Description__c=ba.SKU_Description__c);           
                theBrand = new Brand__c(Name=ba.Brand_Code_Source__c,Brand_Code__c=ba.Brand_Code_Source__c,Status__c=ba.Status__c,sku__r=new SKU__c(SKU__c=ba.Sku_Code_Source__c),Brand_Description__c=ba.Brand_Description__c,Net_Invoice_Value_MM__c=ba.Net_Invoice_Value_MM__c,Shipments_in_MSU__c=ba.Shipment_in_MSU__c,Three_Month_MM_Net_Invoice__c=ba.Three_Month_MM_Net_Invoice__c,Three_Month_MSU_Shipment__c=ba.Three_Month_MSU_Shipment__c,Total_Quantity_Actuals__c=ba.Total_Quantity__c,EOH_Inventory__c=ba.EOH_Inventory__c);
                skuCodeMap.put(ba.Sku_Code_Source__c,theSKU);
                brandCodeMap.put(ba.Brand_Code_Source__c,theBrand);    
            }
            System.Debug('brandCodeMap '+brandCodeMap);
    
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
            
            List<Brand__c> brandList = [Select Brand_Code__c from Brand__c where Brand_Code__c = :brandCodeSet ] ;
            for(Brand__c b :brandList) {
               brandCodeMap.put(b.Brand_Code__c,b);
            }
                      
            for(Brand_Actual_Staging__c ba: (Brand_Actual_Staging__c[])Trigger.new) {               
                theBrand = brandCodeMap.get(ba.Brand_Code_Source__c);            
                if(theBrand!=null) {
                  ba.Brand__c = theBrand.Id;
                // System.Debug('assigning brand for '+ba.Brand_Code_Source__c+' '+ba.Brand__r.Name);
                }
            }
            
        }
    }
}