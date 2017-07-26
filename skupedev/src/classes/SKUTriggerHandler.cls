/**
    When a new SKU is created, reparent the Manual Projections with the same SKU to this record.
**/

public class SKUTriggerHandler {


    /** This should be called After Insert **/
     public void handleInsert(){

         Map<String,Id> skuMap = new Map<String,Id>();
         for(SKU__c sk:(SKU__c[])Trigger.new){
             skuMap.put(sk.SKU__c,sk.Id);
         }

         SKU_Projection__c[] projectionsToUpdate = new SKU_Projection__c[]{};
         for(SKU_Projection__c skProj: [Select SKU__c,SKU_Text__c from SKU_Projection__c where Source__c='Manual' and SKU__r.Name='Manual Projection Default Parent SKU' and SKU_Text__c in :skuMap.keySet()]){
             skProj.SKU__c = skuMap.get(skProj.SKU_Text__c);
             projectionsToUpdate.add(skProj);
         }

         if(projectionsToUpdate.size()>0){
             update projectionsToUpdate;
         }
     }

}