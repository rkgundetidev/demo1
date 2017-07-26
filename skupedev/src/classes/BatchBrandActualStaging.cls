global  class BatchBrandActualStaging implements Database.Batchable<sObject>      {

    class InvalidGBUException extends Exception{}
    
    Enums.GBU gbu;
    Time t = Time.newInstance(0,0,0,0);
    global BatchBrandActualStaging(Enums.GBU gbu) {   
         this.gbu = gbu;
         Init();
    }

    /*
    private void Init() {      
       //LatestDates__c latestDtSetting = LatestDates__c.getInstance();
       LatestDates__c latestDtSetting = LatestDates__c.getOrgDefaults();
        //Date actualdate = [Select Date__c from Brand_Actual_Staging__c WHERE Date__c !=null LIMIT 1].Date__c;
       AggregateResult ar = [Select MAX(Date__c) maxDate from Brand_Actual_Staging__c ];
        Date actualdate = (Date)ar.get('maxDate');
        SKU__c[] skusWithLatestDate = [Select Id from SKU__c where Max_Actual_date__c >= :latestDtSetting.Date__c limit 1];
        if(latestDtSetting.Date__c<actualdate || skusWithLatestDate.size()==0){
            latestDtSetting.Date__c = actualDate;
            System.Debug('latestDtSetting value = '+latestDtSetting+' '+latestDtSetting.Id);
           // if(latestDtSetting.Id == null) insert latestDtSetting;
           update latestDtSetting;
        }
    }*/

    private void Init() {
       
        Date latestDate = GetLatestDates.getLatest(gbu,ENUMS.MODULE.ACTUALS);
        String gbuStr = Enums.getGBUStr(gbu);
        if([Select count() from Brand_Actual_Staging__c where GBU__c!=:gbuStr]>0){
            throw new InvalidGBUException('Brand Actual Staging object contains records for more than one GBU');
        }
        AggregateResult ar = [Select MAX(Date__c) maxDate from Brand_Actual_Staging__c where GBU__c=:gbuStr];
        Date actualdate = (Date)ar.get('maxDate');
        SKU__c[] skusWithLatestDate = [Select Id from SKU__c where Max_Actual_date__c >= :latestDate limit 1];
        if(latestDate < actualdate || skusWithLatestDate.size()==0){
            GetLatestDates.updateLatest(gbu,ENUMS.MODULE.ACTUALS,actualDate);
        }
    }

      /**
    * This method is called after the batch process is completed. This method sends email to the specified users about the status of the completed job.  
    * @param  BatchableContext BC 
    * @return Void
    **/  
    global void finish(Database.BatchableContext BC){      
      //  SendEmailTask(BC); 
      //  BatchDeleteBrandActualStaging delete_batch = new BatchDeleteBrandActualStaging();
       // Database.executeBatch(delete_batch,2000); // Execute the delete with batch scope of 2000 for fewer batch jobs  
       Database.executeBatch(new MarkMissingBrandCodesAsDeleted(gbu),Test.isRunningTest()?2000:200);
    }
    /**
    * This method performs the batch process.     
    * @param  BatchableContext BC, List<TIP_PG_Item_Landing__c> landing_data_chunk 
    * @return Void
    **/ 
    global void execute(Database.BatchableContext BC, List<Brand_Actual_Staging__c> brandActualStagingList){
            
            Brand_Actual__c[] bas = new Brand_Actual__c[]{};
            Map<String,SKU_Actual__c> skuActualCodeMap = new Map<String,SKU_Actual__c>();

            Map<String,Brand__c> brandCodeMap = new Map<String,Brand__c>();
            Map<String,SKU__c> skuCodeMap = new Map<String,SKU__c>();
        
        

            for(Brand_Actual_Staging__c ba:brandActualStagingList) {

        
           SKU__c theSKU = new SKU__c(Name=ba.SKU_Code__c,SKU__c=ba.SKU_Code__c,Status__c=ba.Status__c,SKU_Description__c=ba.SKU_Description__c);
            Brand__c theBrand = new Brand__c(Name=ba.Brand_Code__c,Brand_Code__c=ba.Brand_Code__c,Status__c=ba.Status__c,sku__r=new SKU__c(SKU__c=ba.SKU_Code__c),Brand_Description__c=ba.Brand_Description__c);
            skuCodeMap.put(ba.SKU_Code__c,theSKU);
            brandCodeMap.put(ba.Brand_Code__c,theBrand);    
            
            
            String monthName = DateTime.newInstance(ba.date__c,t).format('MMMM');
            String skuActualUniqueId = monthName+'-'+ba.Date__c.year()+'-'+ba.SKU_Code__c;
            String brandActualUniqueId = monthName+'-'+ba.Date__c.year()+'-'+ba.Brand_code__c;
            if(!skuActualCodeMap.containsKey(skuActualUniqueId)){
                SKU_Actual__c theSKUActual = new SKU_Actual__c(SKU__r=new SKU__c(SKU__c=ba.SKU_Code__c),Date__c=ba.Date__c,SKU_Actual_Unique_Id__c=skuActualUniqueId,Name=skuActualUniqueId,Month__c=monthName);
                skuActualCodeMap.put(skuActualUniqueId,theSKUActual);
            }
            Brand_Actual__c theBrandActual = new Brand_Actual__c(Name=brandActualUniqueId,Date__c=ba.Date__c,Brand__r=new Brand__c(Brand_Code__c=ba.Brand_Code__c),EOH_Inventory__c=ba.EOH_Inventory__c,Month__c=monthName,SKU_Actual__r = new SKU_Actual__c(SKU_Actual_Unique_Id__c=skuActualUniqueId),Status__c=ba.Status__c,Three_Month_MM_Net_Invoice__c=ba.Three_Month_MM_Net_Invoice__c,Three_Month_MSU_Shipment__c=ba.Three_Month_MSU_Shipment__c,Total_Quantity__c=ba.Total_Quantity__c,Shipments_in_MSU__c=ba.Shipment_in_MSU__c,Net_Invoice_Value_MM__c=ba.Net_Invoice_Value_MM__c);
            
            bas.add(theBrandActual);
            
        }

        
        for(SKU__C sk: [Select SKU__c from SKU__c where SKU__c in :skuCodeMap.keySet()]){
            skuCodeMap.remove(sk.SKU__c);
        }
        if(skuCodeMap.size()>0){
            insert skuCodeMap.values();
        }
        for(Brand__c b: [Select Brand_Code__c from Brand__c where Brand_Code__c in :brandCodeMap.keySet()]){
            brandCodeMap.remove(b.Brand_Code__c);
        }
        if(brandCodeMap.size()>0){
            insert brandCodeMap.values();
        }
    
        
        /*
        for(SKU_Actual__c sk: [Select SKU_Actual_Unique_Id__c from SKU_Actual__c where SKU_Actual_Unique_Id__c in :skuActualCodeMap.keySet()]){
            skuActualCodeMap.remove(sk.SKU_Actual_Unique_Id__c);
        } */
        if(skuActualCodeMap.size()>0){
            upsert skuActualCodeMap.values() SKU_Actual_Unique_Id__c;
        }
        insert bas;

      
        }
    /**
    * This method schedules the batch apex class to run at a specific point of time.     
    * @param  SchedulableContext SC 
    * @return Void
    **/ 
   /* global void execute(SchedulableContext SC){
        BatchBrandActualStaging process_brandActualStaging =  new BatchBrandActualStaging();
        ID batchprocessid = Database.executeBatch(process_brandActualStaging);    
    
    }*/
    /**
    * This method kick starts the batch process execution. The source query is passed onto the queryLocator which will retrieve the data.    
    * @param  BatchableContext BC  
    * @return Void
    **/ 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Name,SKU_Code__c,SKU_Description__c,Brand_code__c,Date__c,Status__c,Brand__c,EOH_Inventory__c,Brand_Description__c,Three_Month_MM_Net_Invoice__c,Net_Invoice_Value_MM__c,Shipment_in_MSU__c,Three_Month_MSU_Shipment__c,Total_Quantity__c from Brand_Actual_Staging__c]);
    }
   
    /**
    * This method sends out email to the job owner about the job completion status.     
    * @param  BatchableContext BC  
    * @return Void
    
    private void SendEmailTask(Database.BatchableContext BC) {    
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,CreatedBy.Email ,
        TotalJobItems
        from AsyncApexJob where Id =:BC.getJobId()];
       
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         String[] toAddresses = new String[] {a.CreatedBy.Email};       
        String body = 'Total Jobs = '+a.TotalJobItems+' Jobs Processed = '+a.JobItemsProcessed+ '  status = '+a.status;
        mail.setSaveAsActivity(false); 
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('SKUPE Admin'); 
        mail.setPlainTextBody(body);
        mail.setSubject('BatchBrandActualStaging job  ' + a.Status);
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    } **/ 
 
}