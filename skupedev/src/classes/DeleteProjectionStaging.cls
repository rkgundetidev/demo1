global class DeleteProjectionStaging implements Database.Batchable<SObject>{
    global Database.Querylocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id from Brand_Projection_Staging__c');
    }
    global void execute(Database.BatchableContext bc,Brand_Projection_Staging__c[] staging){
        delete staging;
    }

   /* global void execute(QueueableContext QC) {
        System.enqueueJob(new DeleteProjectedSKUs());        
       
    }*/
    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
      /*  AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Delete Projection Staging records ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
        Database.executeBatch(new DeleteProjectedSKUs(),2000);
    }
}