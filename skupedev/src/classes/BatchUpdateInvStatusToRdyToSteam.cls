/**
    Update status of Inventory items with total value less than 500 in a plant to 'Ready to Steam'
    This class is invoked from BatchIdentifyPlantInvForElim
**/
global class BatchUpdateInvStatusToRdyToSteam implements Database.Batchable<Inventory__c>{

    global Set<Id> invIds = new Set<Id>();
    global BatchUpdateInvStatusToRdyToSteam(Id[] idList){
        invIds = new Set<Id>(idList);
    }

    global Iterable<Inventory__c> start(Database.BatchableContext bc){
        return [Select Status__c,Reason_for_Steaming__c from Inventory__c where Id in :invIds and Status__c='Not Ready for Steaming'];
    }

    global void execute(Database.BatchableContext bc,Inventory__c[] inventories){
        for(Inventory__c inv:inventories){
            inv.Status__c='Ready for Steaming';
            inv.Reason_for_Steaming__c ='Plant value less than $5000';
        }
    }

     global void finish(Database.BatchableContext BC){
         Database.executeBatch(new CreateInventoryTasks());
         AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Update Inventory records with value less than $500 ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +' batches with '+ a.NumberOfErrors + ' failures.');
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
     }
}