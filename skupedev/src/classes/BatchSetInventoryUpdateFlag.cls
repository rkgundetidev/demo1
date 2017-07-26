global class BatchSetInventoryUpdateFlag implements Database.Batchable<SKU__c>{
    /*
    global Id[] skuids = new Id[]{};

    public BatchSetInventoryUpdateFlag(Id[] skuids){
        this.skuids = skuids;
    }*/

    global Enums.GBU gbu;
    global BatchSetInventoryUpdateFlag(Enums.GBU gbu){
        this.gbu = gbu;
    }

    global Iterable<SKU__c> start(Database.BatchableContext bc){
        Date latestInvDate = [Select Upload_Date__c from Inventory_Staging__c order by Upload_Date__c desc limit 1][0].Upload_Date__c;
        String gbuStr = Enums.getGBUStr(gbu);
        return [Select Trigger_Inventory_Status_Calculations__c from SKU__c where Latest_Inventory_Upload_Date__c=:latestInvDate and GBU__c=:gbuStr];
    }

    global void execute(Database.BatchableContext bc,SKU__c[] stagingrecs){
        for(SKU__c sk:stagingrecs){
            sk.Trigger_Inventory_Status_Calculations__c = true;
        }
        update stagingrecs;
    }
    
    global void finish(Database.BatchableContext bc){
        //system.debug('>>> Finish method for setinventoryupdateflag '+skuids.size());
        
        Database.executeBatch(new BatchUnSetInventoryUpdateFlag(gbu));
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
        mail.setSubject('Set Trigger Inventory Status calculation ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
}