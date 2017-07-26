global class BatchLoadInventory implements Database.Batchable<Inventory_Staging__c>{

    class InvalidGBUException extends Exception{}

    global BatchLoadInventory(Enums.GBU gbu){
        this.gbu = gbu;
        Init();
    }

    global Enums.GBU gbu;

    private void Init(){

        Date latestDate = GetLatestDates.getLatest(gbu,ENUMS.MODULE.INVENTORIES);
        String gbuStr = Enums.getGBUStr(gbu);
        if([Select count() from Inventory_Staging__c where GBU__c!=:gbuStr]>0){
            throw new InvalidGBUException('Inventory Staging table contains data from multiple GBUs');
        }
        AggregateResult ar = [Select MAX(Upload_Date__c) maxDate from Inventory_Staging__c where GBU__c=:gbuStr];
        Date invUploadDate = (Date)ar.get('maxDate');
        
        GetLatestDates.updateLatest(gbu,ENUMS.MODULE.INVENTORIES,invUploadDate);
    }

    class NonUniqueException extends Exception{
    }

    //global Set<Id> skuids = new Set<Id>();
    
    global Iterable<Inventory_Staging__c> start(Database.BatchableContext bc){
        
        Inventory_Staging__c[] stagingRecords =  [Select Brand_Code__c,Batch_Number__c,Plant_Number__c,Quantity_Quality_Inspection__c,Quantity_Restricted__c,Quantity_Transit_and_Transfer__c,Quantity_Rets__c,Quantity_Unrestricted__c,Quantity_Blocked__c,Storage_Location__c,Value_Blocked_Stock__c,Value_in_QualInsp__c,Value_in_Transit_Transfr__c,Value_Restricted__c,Value_Rets_Blocked__c,Value_Unrestricted__c, createddate, Upload_Date__c, Total_Quantity__c from Inventory_Staging__c order by Upload_Date__c desc];
        
        return stagingrecords;
    }

    global void execute(Database.BatchableContext bc,Inventory_Staging__c[] stagingrecs){
        Inventory__c[] inventories = new Inventory__c[]{};
        Set<String> plantNumbersToCreate = new Set<String>();
        Plant__c[] plantsToCreate = new Plant__c[]{};
        Set<String> uniqueIds = new Set<String>();
        for(Inventory_Staging__c stg:stagingrecs){
            if(!plantNumbersToCreate.contains(stg.Plant_Number__c)){
                plantNumbersToCreate.add(stg.Plant_Number__c);
                plantsToCreate.add(new Plant__c(Name=stg.Plant_Number__c,Plant_Number__c=stg.Plant_Number__c));
            }
            
            string uniqueid = stg.Brand_Code__c+'-'+ (String.isBlank(stg.Batch_Number__c)?'null':stg.Batch_Number__c).trim()  +'-'+stg.Plant_Number__c+'-'+(String.isBlank(stg.Storage_Location__c)?'null':stg.Storage_Location__c).trim();
            //string uniqueid = stg.Brand_Code__c+'-'+ stg.Batch_Number__c.trim() +'-'+stg.Plant_Number__c+'-'+stg.Storage_Location__c.trim();

            system.debug('>>>>>>>>>>>>> unique id '+uniqueid);
            if(!uniqueIds.contains(uniqueId)){
                uniqueIds.add(uniqueId);
               
                inventories.add(new Inventory__c(Batch_Number__c=stg.Batch_Number__c,Site__c=stg.Plant_Number__c,Plant__r=new Plant__c(Plant_Number__c=stg.Plant_Number__c),Quantity_QualityInsp__c=stg.Quantity_Quality_Inspection__c,Quantity_Restricted__c=stg.Quantity_Restricted__c,Quantity_Transit_and_Transfer__c=stg.Quantity_Transit_and_Transfer__c,Quantity_Rets__c=stg.Quantity_Rets__c,Quantity_Unrestricted__c=stg.Quantity_Unrestricted__c,Quantity_Blocked__c=stg.Quantity_Blocked__c,Storage_Location__c=stg.Storage_Location__c,Value_Blocked_Stock__c=stg.Value_Blocked_Stock__c,Value_in_QualInsp__c=stg.Value_in_QualInsp__c,Value_in_Transit_Transfr__c=stg.Value_in_Transit_Transfr__c,Value_Restricted__c=stg.Value_Restricted__c,Value_Rets_Blocked__c=stg.Value_Rets_Blocked__c,Value_Unrestricted__c=stg.Value_Unrestricted__c,Inventory_Unique_Id__c=uniqueid,Brand__r=new Brand__c(Brand_Code__c=stg.Brand_Code__c),Latest_Upload_Date__c=stg.Upload_Date__c,Total_Quantity_Direct__c=stg.Total_Quantity__c));
            }
        }
        if(plantsToCreate.size()>0){
            upsert plantsToCreate Plant_Number__c;
        }
        if(inventories.size()>0){
            upsert inventories Inventory_Unique_Id__c;
        }

        /**
        for(Inventory__c inv:[Select Brand__c,Brand__r.SKU__c from Inventory__c where ID in :inventories]){
            skuids.add(inv.Brand__r.SKU__c);
        } **/
    }

    global void finish(Database.BatchableContext BC){
        
        // Get the ID of the AsyncApexJob representing this batch job
        // from Database.BatchableContext.
        // Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob WHERE Id =
            :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Load Inventory records ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
      //  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
       // Database.executeBatch(new BatchSetInventoryUpdateFlag(new List<Id>(skuids)));
       Database.executeBatch(new BatchSetInventoryUpdateFlag(gbu));
    }


}