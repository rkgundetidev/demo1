global class BatchDeleteBrandProjections implements Database.Batchable<Brand_Projection__c>{

    global Iterable<Brand_Projection__c> start(Database.BatchableContext bc){
       // LatestDates__c latestDtSetting = LatestDates__c.getInstance(); 
       AggregateResult ar =  [Select MIN(createddate) MinProjection from Brand_Projection_Staging__c ];
       Date projectionDate = (Date)ar.get('MinProjection');
       return [Select Id,Projection_Type__c,Brand__r.Latest_Projection_Date__c,Brand__r.Projected_start_Date__c,Brand__r.Projected_Disco_Date__c,Date_of_Projection__c from Brand_Projection__c where createddate < :projectionDate];
    }
    
    global void execute(Database.BatchableContext bc,Brand_Projection__c[] bprojs){
        Brand_Projection__c[] projsToDelete = new Brand_Projection__c[]{};
        Date currDate = System.today();
        Date startofMonth = Date.newInstance(currDate.year(),currDate.month(),1);
        for(Brand_Projection__c bps: bprojs){
            if(bps.Date_of_Projection__c >= startofMonth || 
            ((bps.Projection_Type__c=='GBU New SKUs' || bps.Projection_Type__c=='MSO New SKUs') && bps.Brand__r.Projected_start_Date__c!=bps.Date_of_Projection__c) || 
            ((bps.Projection_Type__c=='GBU Discos' || bps.Projection_Type__c=='MSO MSO Discos') && bps.Brand__r.Projected_Disco_Date__c!=bps.Date_of_Projection__c)
            ){
                projsToDelete.add(bps);
            }
        }
        delete projsToDelete;
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