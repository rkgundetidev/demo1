@isTest
global class BatchDeleteInventoryStaging implements Database.Batchable<sObject> {

      global void finish(Database.BatchableContext BC){      
       // SendEmailTask(BC);    
        
    }

    
     global void execute(Database.BatchableContext BC, List<Inventory_Staging__c> inventoryStagingList) {
          delete inventoryStagingList;
     }
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id  from Inventory_Staging__c]);
    }

     private void SendEmailTask(Database.BatchableContext BC) {    
                 AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed ,CreatedBy.Email,
        TotalJobItems
        from AsyncApexJob where Id =:BC.getJobId()];
       
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};   
        String body = 'Total Jobs = '+a.TotalJobItems+' Jobs Processed = '+a.JobItemsProcessed+ '  status = '+a.status;
        mail.setSaveAsActivity(false); 
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('SKUPE Admin'); 
        mail.setPlainTextBody(body);
        mail.setSubject('BatchDeleteInventoryStaging job  ' + a.Status);
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  

    }
  

}