global class BatchIdentifyPlantInvForElim implements Database.Batchable<Brand__c>, Database.Stateful {

    global Map<String,Map<String,Decimal>> skuPlantValMap = new Map<String,Map<String,Decimal>>();
    global Map<String,Map<String,Id[]>> skuPlantInvMap = new Map<String,Map<String,Id[]>>();
    global Enums.GBU gbu;

    global BatchIdentifyPlantInvForElim(Enums.GBU gbu){
        this.gbu = gbu;
    }

    global Iterable<Brand__c> start(Database.BatchableContext bc){
        String gbuStr = Enums.getGBUStr(gbu);
        return [Select Id,SKU__c,SKU__r.Name,(select Plant__c,Total_Value__c  from Inventories__r where Is_Inventory_Missing__c=false and Status__c!='Eliminated') from Brand__c where SKU__r.R_H_Substatus__c='Not Ready for Steaming' and SKU__r.GBU__c=:gbuStr];
    }

    global void execute(Database.BatchableContext bc,Brand__c[] brands){
        
        for(Brand__c br:brands){
            if(br.Inventories__r.size()>0){
                if(!skuPlantValMap.containsKey(br.SKu__r.Name)){
                    skuPlantValMap.put(br.SKu__r.Name,new Map<String,Decimal>());
                    skuPlantInvMap.put(br.SKu__r.Name,new Map<String,Id[]>());
                }
                Map<String,Decimal> skuValMap = skuPlantValMap.get(br.SKu__r.Name);
                Map<String,Id[]> skuInvMap = skuPlantInvMap.get(br.SKu__r.Name);
                for(Inventory__c inv:br.Inventories__r){
                    if(!skuValMap.containsKey(inv.Plant__c)){
                        skuValMap.put(inv.Plant__c,inv.Total_Value__c);
                        skuInvMap.put(inv.Plant__c,new Id[]{inv.Id});
                    }else{
                        skuValMap.put(inv.Plant__c,skuValMap.get(inv.Plant__c)+inv.Total_Value__c);
                        skuInvMap.get(inv.Plant__c).add(inv.Id);
                    }
                }
            }
        }
    }

    global void finish(Database.BatchableContext BC){

        Id[] invIdsToUpdate = new Id[]{};
        for(String sku: skuPlantValMap.keySet()){
            for(String plant: skuPlantValMap.get(sku).keySet()){
                if(skuPlantValMap.get(sku).get(plant)<500){
                    invIdsToUpdate.addAll(skuPlantInvMap.get(sku).get(plant));
                }
            }
        }
        System.debug('>>> size of invIdsToUpdate '+invIdsToUpdate.size());
        Database.executeBatch(new BatchUpdateInvStatusToRdyToSteam(invIdsToUpdate));
        /*
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Load Inventory records ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */
    }
}