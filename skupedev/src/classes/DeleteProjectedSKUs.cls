global class DeleteProjectedSKUs implements Database.Batchable<SObject>{

    global Database.Querylocator start(Database.BatchableContext bc){
        
      //  LatestDates__c latestDtSetting = LatestDates__c.getInstance(); 
        LatestDates__c latestDtSetting = LatestDates__c.getOrgDefaults();
        System.Debug('latestDtSetting '+latestDtSetting);
        List<SKU__c> skc = [Select Projected_Start_Date__c from SKU__c where Status__c='Projected' and ((Projected_start_date__c > LAST_MONTH and Latest_Projection_Date__c < :latestDtSetting.Projection_Update_Date__c) OR Latest_Projection_Date__c=null or Projected_Start_date__c=null) and Brands_with_Start_Date_Override__c =0 and Brands_with_Disco_date_override__c=0];
        return Database.getQueryLocator([Select Id from SKU__c where Status__c='Projected' and ((Projected_start_date__c > LAST_MONTH and Latest_Projection_Date__c < :latestDtSetting.Projection_Update_Date__c) OR Latest_Projection_Date__c=null or Projected_Start_date__c=null) and Brands_with_Start_Date_Override__c =0 and Brands_with_Disco_date_override__c=0]);
    }
    
    global void execute(Database.BatchableContext bc,SObject[] projected){
        delete projected;
    }
 

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
       Database.executeBatch(new DeleteProjectedBrands(),2000);
    }

}