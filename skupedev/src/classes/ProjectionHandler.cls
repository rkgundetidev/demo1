public class ProjectionHandler {

    public static void handleInsert(){
        Brand_Projection__c[] bps = new Brand_Projection__c[]{};
        Map<String,Brand__c> brandCodeMap = new Map<String,Brand__c>();
        Map<String,SKU__c> skuCodeMap = new Map<String,SKU__c>();
        for(Brand_Projection_Staging__c bp: (Brand_Projection_Staging__c[])Trigger.new){
           
            SKU__c theSKU = new SKU__c(Name=bp.SKU_Code__c,Category__c=bp.Category__c,Dish_Care_Group__c=bp.Group__c,SKU__c=bp.SKU_Code__c,Status__c='Projected');

            Brand__c theBrand = new Brand__c(Name=bp.Brand_Code__c,Brand_Code__c=bp.Brand_Code__c,Status__c='Projected',sku__r=new SKU__c(SKU__c=bp.SKU_Code__c),Brand_Description__c=bp.BrandCode_Description__c);
            skuCodeMap.put(bp.SKU_Code__c,theSKU);
            brandCodeMap.put(bp.Brand_Code__c,theBrand);
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
        for(Brand_Projection_Staging__c bp: (Brand_Projection_Staging__c[])Trigger.new){
            bps.add(new Brand_Projection__c(Name=bp.Type__c+'-'+bp.Brand_Code__c,Brand__r=new Brand__c(Brand_Code__c=bp.Brand_Code__c),Date_of_Projection__c=bp.Projection_Date__c,Projection_Type__c=bp.Type__c));
        }
        insert bps;
        Database.executeBatch(new DeleteProjectionStaging());
    }
}