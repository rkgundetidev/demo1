global class DeleteProjectedBrands implements Database.Batchable<SObject>{

    /**
        Some SKUs may not be in 'Projected' status. However, they may have Brands in Projected status, which did not receive updates this month and need to be 
        deleted.
    **/
    
    global Database.Querylocator start(Database.BatchableContext bc){
       // LatestDates__c latestDtSetting = LatestDates__c.getInstance(); 
       LatestDates__c latestDtSetting = LatestDates__c.getOrgDefaults();
        return Database.getQueryLocator([Select Id from Brand__c where Status__c='Projected' and ((Latest_Projection_Date__c < :latestDtSetting.Projection_Update_Date__c and Projected_start_Date__c > LAST_MONTH) or Latest_Projection_Date__c=null or Projected_Start_date__c=null) and Projected_Start_Date_Override__c=null and Projected_Disco_Date_Override__c=null]);
    }
    
    global void execute(Database.BatchableContext bc,SObject[] projected){
        delete projected;
    }
  /*  global void execute(QueueableContext QC) {
        Database.executeBatch(new DeleteProjectedBrands() );
         System.enqueueJob(new ResetBrandDiscoProjections());
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
        mail.setSubject('Delete Projected SKUs from last month without any new Projections this month' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
        Database.executeBatch(new ResetBrandDiscoProjections(),2000);
    }

}