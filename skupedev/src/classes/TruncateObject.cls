global class TruncateObject implements Database.Batchable<SObject>{
    private String sobjName;
    private boolean sendEmail=false;
    global Database.Querylocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('Select Id from '+sobjName);
    }
    global TruncateObject(String sobjectName,boolean sendEmail){
        this.sobjName = sobjectName;
        this.sendEmail = sendEmail;
    }
    global void execute(Database.BatchableContext bc,SObject[] records){
        delete records;
    }
    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        if(sendEmail){
            AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                TotalJobItems, CreatedBy.Email
                FROM AsyncApexJob WHERE Id =
                :BC.getJobId()];
            // Send an email to the Apex job's submitter notifying of job completion.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Delete '+sobjName+' records ' + a.Status);
            mail.setPlainTextBody
            ('The batch Apex job processed ' + a.TotalJobItems +
            ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}