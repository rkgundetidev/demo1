global class BatchMarkMissingBrandCodesFound implements Database.Batchable<SObject>{

    global Enums.GBU gbu;
    global BatchMarkMissingBrandCodesFound(Enums.GBU gbu){
        this.gbu = gbu;
    }
    
    global Database.Querylocator start(Database.BatchableContext bc){
        String gbuStr = Enums.getGBUStr(gbu);
        return Database.getQueryLocator([Select Less_than_SKU_Max_Actual_Date__c,Is_less_than_SKU_Max_Actual_Date_formula__c, Missing_from_Latest_Actuals__c,Brand_Code_Latest_Undelete_Date__c,Max_Actual_Date__c from Brand__c where Missing_from_Latest_Actuals__c=true and IsMissing__c=false and SKU__r.GBU__c=:gbuStr]);
    }
    
    global void execute(Database.BatchableContext bc,Brand__c[] missingbrands){
        for(Brand__c b:missingbrands){
            b.Missing_from_Latest_Actuals__c=false;
            b.Brand_Code_Latest_Undelete_Date__c=b.Max_Actual_Date__c;
            b.Less_than_SKU_Max_Actual_Date__c = b.Is_less_than_SKU_Max_Actual_Date_formula__c;
        }
        update missingbrands;
    }
/*
     global void execute(QueueableContext QC) {
        Database.executeBatch(new BatchMarkMissingBrandCodesFound());
    }*/

    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
    /*    AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,CreatedBy.Email,
            TotalJobItems
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Update Brand Missing from Latest Actuals true ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
        Database.executeBatch(new BatchUpdateSKULatestStatusUpdateDates(gbu),Test.isRunningTest()?2000:200);
    }

}