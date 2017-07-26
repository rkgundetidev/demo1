/**
    Reset flag that triggers inv status calculations on SKU. Also updates First Inv Batch Upload Date field on SKUs that get inventory positions for the first time

    Invokes Batch Process that sets the Is Inventory Missing flag on Inventories that did not receive any updates.
**/

global class BatchUnSetInventoryUpdateFlag implements Database.Batchable<SKU__c>{
    /*
    global Id[] skuids = new Id[]{};

    public BatchUnSetInventoryUpdateFlag(Id[] skuids){
        this.skuids = skuids;
    }*/

    global Enums.GBU gbu;
    global BatchUnSetInventoryUpdateFlag(Enums.GBU gbu){
        this.gbu = gbu;
    }

    global Iterable<SKU__c> start(Database.BatchableContext bc){
        String gbuStr = Enums.getGbuStr(gbu);
        Date latestInvDate = [Select Upload_Date__c from Inventory_Staging__c order by Upload_Date__c desc limit 1][0].Upload_Date__c;
        return [Select Latest_Inventory_Upload_Date__c,Trigger_Inventory_Status_Calculations__c,First_Inventory_Batch_Upload_Date__c from SKU__c where Latest_Inventory_Upload_Date__c=:latestInvDate and GBU__c=:gbuStr];
    }

    global void execute(Database.BatchableContext bc,SKU__c[] stagingrecs){
        system.debug('>>>>>>> size of staging recs '+stagingrecs.size());
        for(SKU__c sk:stagingrecs){
            sk.Trigger_Inventory_Status_Calculations__c = false;
            if(sk.First_Inventory_Batch_Upload_Date__c == null){
                sk.First_Inventory_Batch_Upload_Date__c = sk.Latest_Inventory_Upload_Date__c;
            }
        }
        update stagingrecs;
    }
    
    global void finish(Database.BatchableContext bc){

        Database.executeBatch(new BatchUpdateInventoryMissing(gbu));
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