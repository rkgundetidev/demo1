global class BatchUpdateSKULatestStatusUpdateDates implements Database.Batchable<SKU__c>{
    
    Enums.GBU thegbu;
    global BatchUpdateSKULatestStatusUpdateDates(Enums.GBU gbu){
        this.thegbu = gbu;
    }
    global Iterable<SKU__c> start(Database.BatchableContext bc){
        Date latestActualDate = LatestDates__c.getOrgDefaults().Date__c;
        String gbuStr = Enums.getGBUStr(thegbu);
        return [Select Id,Latest_Status_change_Date__c,Latest_Undelete_Date__c,(Select Status__c,Date__c from SKU_Actuals__r order by Date__c desc) from SKU__c where GBU__c= :gbuStr];
    }
    
    global void execute(Database.BatchableContext bc,SKU__c[] skus){
        SKU__c[] skusToUpdate = new SKU__c[]{};
        for(SKU__c sku:skus){
            String prevStatus='';
            Date prevDate=null;
            boolean foundLatestUndeleteDate=false,foundLatestStsChangeDate=false;
            SKU__c currSKU = new SKU__c(Id=sku.Id);
            for(SKU_Actual__c sa:sku.SKU_Actuals__r){

                if(!foundLatestStsChangeDate && currSKU.Latest_Status_change_Date__c!=null && sa.Date__c<=currSKU.Latest_Status_change_Date__c){
                    if(foundLatestUndeleteDate){
                        break;
                    }else{
                        foundLatestStsChangeDate=true;
                    }
                }
                if(!foundLatestUndeleteDate && currSKU.Latest_Undelete_Date__c!=null && sa.Date__c<=currSKU.Latest_Undelete_Date__c){
                    if(foundLatestStsChangeDate){
                        break;
                    }else{
                        foundLatestUndeleteDate=true;
                    }
                }

                if(!String.isBlank(prevStatus) && !foundLatestStsChangeDate && sa.Status__c!=prevStatus){
                    currSKU.Latest_Status_change_Date__c=prevDate;
                    if(foundLatestUndeleteDate){
                        break;
                    }else{
                        skusToUpdate.add(currSKU);
                        foundLatestStsChangeDate=true;
                    }
                }
                if(prevDate!=null && !foundLatestUndeleteDate && Math.abs(prevDate.daysBetween(sa.Date__c)) > 31){
                    currSKU.Latest_Undelete_Date__c = prevDate;
                    if(foundLatestStsChangeDate){
                        break;
                    }else{
                        skusToUpdate.add(currSKU);
                        foundLatestUndeleteDate=true;
                    }
                }
                prevDate = sa.Date__c;
                prevStatus = sa.Status__c;
            }
        }
        if(skusToUpdate.size()>0)
            update skusToUpdate;
    }
/*
     global void execute(QueueableContext QC) {
        Database.executeBatch(new BatchMarkMissingBrandCodesFound());
    }*/

    global void finish(Database.BatchableContext BC){
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
       AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,CreatedBy.Email,
            TotalJobItems
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Update Latest Transition Date on SKU ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}