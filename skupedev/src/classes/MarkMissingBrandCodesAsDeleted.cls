global class MarkMissingBrandCodesAsDeleted implements Database.Batchable<SObject>{

    global Enums.GBU gbu;
    global MarkMissingBrandCodesAsDeleted(Enums.GBU gbu){
        this.gbu = gbu;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc){
        String gbuStr = Enums.getGbuStr(gbu);
        
        return Database.getQueryLocator('Select Missing_from_Latest_Actuals__c,Is_less_than_SKU_Max_Actual_Date_formula__c,Less_than_SKU_Max_Actual_Date__c,Brand_Code_Latest_Delete_Date__c,Max_Actual_Date__c from Brand__c where Missing_from_Latest_Actuals__c=false and IsMissing__c=true and SKU__r.GBU__c=\''+gbuStr+'\'');
    }
    
    global void execute(Database.BatchableContext bc,Brand__c[] missingbrands){
        system.debug('>>>> size of missing brands '+missingbrands.size());
        
        for(Brand__c b:missingbrands){
            b.Missing_from_Latest_Actuals__c=true;
            b.Brand_Code_Latest_Delete_Date__c=b.Max_Actual_Date__c;
            b.Less_than_SKU_Max_Actual_Date__c = b.Is_less_than_SKU_Max_Actual_Date_formula__c;
        }
        update missingbrands;
    }

   /* global void execute(QueueableContext QC) {
        Database.executeBatch(new MarkMissingBrandCodesAsDeleted());
          System.enqueueJob(new BatchMarkMissingBrandCodesFound());
       
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

        Database.executeBatch(new BatchMarkMissingBrandCodesFound(gbu),Test.isRunningTest()?2000:200);
    }

}