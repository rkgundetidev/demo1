global class ResetBrandDiscoProjections implements Database.Batchable<SObject>{

    global Database.Querylocator start(Database.BatchableContext bc){
       // LatestDates__c latestDtSetting = LatestDates__c.getInstance(); 
       LatestDates__c latestDtSetting = LatestDates__c.getOrgDefaults();
        return Database.getQueryLocator([Select Projected_Disco_Date__c from Brand__c where (Latest_Projection_Date__c < :latestDtSetting.Projection_Update_Date__c  or Latest_Projection_Date__c=null) and Projected_Disco_Date__c > LAST_MONTH]);
    }
    
    global void execute(Database.BatchableContext bc,Brand__c[] actnp){
        for(Brand__c b:actnp){
            b.Projected_Disco_Date__c=null;
        }
        update actnp;
    }

  /*  global void execute(QueueableContext QC) {
        Database.executeBatch(new ResetBrandDiscoProjections());
    }
*/
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
        mail.setSubject('Delete Projected SKUs from last month without any new Projections this month' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
    }

}