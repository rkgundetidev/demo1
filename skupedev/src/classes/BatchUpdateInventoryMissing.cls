global class BatchUpdateInventoryMissing implements Database.Batchable<Inventory__c>{

    global Enums.GBU gbu;
    global BatchUpdateInventoryMissing(Enums.GBU gbu){
        this.gbu = gbu;
    }
    global Iterable<Inventory__c> start(Database.BatchableContext bc){
        String gbuStr = Enums.getGBUStr(gbu);
        return [Select Is_Inventory_Missing__c,status__c from Inventory__c where ((IsMissing_Formula__c=true and Is_Inventory_Missing__c=false) or (IsMissing_Formula__c=false and Is_Inventory_Missing__c=true)) and Brand__r.SKU__r.GBU__c=:gbuStr];
    }

    global void execute(Database.BatchableContext bc,Inventory__c[] inventories){
        for(Inventory__c inv:inventories){
           if(inv.Is_Inventory_Missing__c==false){
                inv.Is_Inventory_Missing__c=true;
                inv.status__c='Eliminated';
           }else{
               inv.Is_Inventory_Missing__c=false;
               inv.status__c='';
           }
        }
        update inventories;
    }
    
    global void finish(Database.BatchableContext bc){

        Database.executeBatch(new BatchIdentifyPlantInvForElim(gbu));
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
       /* AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Update Missing Inventory Flags ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */

    }
}