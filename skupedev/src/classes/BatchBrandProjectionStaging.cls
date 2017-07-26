global class BatchBrandProjectionStaging implements Database.Batchable<sObject>,Database.Stateful {

      Date dateOfProjection = null;
      Id g11ProjectionRecordTypeId = Schema.SObjectType.SKU_Projection__c.getRecordTypeInfosByName().get('G-11').getRecordTypeId();

      global Set<String> allSKUProjections = new Set<String>();
      global BatchBrandProjectionStaging(Enums.GBU gbu) {
          Init(gbu);
      }  
      
      /*
      private void Init() {      
      //  LatestDates__c latestDtSetting = LatestDates__c.getInstance();
       LatestDates__c latestDtSetting = LatestDates__c.getOrgDefaults();
        //Date actualdate = ((Brand_Actual_Staging__c[])Trigger.new)[0].Date__c;
       // Date projectionDate = [Select Projection_Date__c from Brand_Projection_Staging__c WHERE Projection_Date__c !=null LIMIT 1].Projection_Date__c;
        AggregateResult ar =  [Select MAX(Date_of_Projection__c) ProjectionDate from Brand_Projection_Staging__c ];
        dateOfProjection = (Date)ar.get('ProjectionDate');
        //SKU__c[] skusWithLatestDate = [Select Id from SKU__c where Projected_Start_Date__c >= :latestDtSetting.Projection_Update_Date__c limit 1];
        //if(latestDtSetting.Projection_Update_Date__c<projectionDate  || skusWithLatestDate.size()==0){
        if(latestDtSetting.Projection_Update_Date__c==null || latestDtSetting.Projection_Update_Date__c<dateOfProjection){
            System.Debug('updating the projection date in custom settings BEFORE '+latestDtSetting.Projection_Update_Date__c);
            latestDtSetting.Projection_Update_Date__c = dateOfProjection;          
            update latestDtSetting;
            System.Debug('updating the projection date in custom settings AFTER '+latestDtSetting.Projection_Update_Date__c);
        }
    }
    */

    private void Init(Enums.GBU gbu) {      
        Date latestDate = GetLatestDates.getLatest(gbu,ENUMS.MODULE.PROJECTIONS);
        String gbuStr = Enums.getGBUStr(gbu);
        AggregateResult ar =  [Select MAX(Date_of_Projection__c) ProjectionDate from Brand_Projection_Staging__c where GBU__c=:gbuStr];
        dateOfProjection = (Date)ar.get('ProjectionDate');
        
        if(latestDate==null || latestDate < dateOfProjection){
           GetLatestDates.updateLatest(gbu,ENUMS.MODULE.PROJECTIONS,dateOfProjection);
        }
    }

    global Database.Querylocator start(Database.BatchableContext bc){
         return Database.getQueryLocator([Select Category__c,Name,SKU_Code__c,Brand_code__c,Projection_Date__c,Date_of_Projection__c,Type__c,Group__c,BrandCode_Description__c,SKU_Description__c,GBU__c from Brand_Projection_Staging__c]);
    }
    
    global void execute(Database.BatchableContext bc,List<Brand_Projection_Staging__c> brandProjectionList){
        SKU_Projection__c[] skuprojections = new SKU_Projection__c[]{};
        Brand_Projection__c[] bps = new Brand_Projection__c[]{};
        Map<String,Brand__c> brandCodeMap = new Map<String,Brand__c>();
        Map<String,SKU__c> skuCodeMap = new Map<String,SKU__c>();
        Map<String,SKU_Projection__c> skuProjectionMap = new Map<String,SKU_Projection__c>();
        try {
        for(Brand_Projection_Staging__c bp: brandProjectionList){
           
            SKU__c theSKU = new SKU__c(Name=bp.SKU_Code__c,Category__c=bp.Category__c,Dish_Care_Group__c=bp.Group__c,SKU__c=bp.SKU_Code__c,Status__c='Projected',SKU_Description__c=bp.SKU_Description__c,GBU__c=bp.GBU__c);

            Brand__c theBrand = new Brand__c(Name=bp.Brand_Code__c,Brand_Code__c=bp.Brand_Code__c,Status__c='Projected',sku__r=new SKU__c(SKU__c=bp.SKU_Code__c),Brand_Description__c=bp.BrandCode_Description__c);
            skuCodeMap.put(bp.SKU_Code__c,theSKU);
            brandCodeMap.put(bp.Brand_Code__c,theBrand);
        }

        System.Debug('skupCodeMap  keyset before remove'+skuCodeMap.size());
        System.Debug('brandCodeMap keyset before remove'+brandCodeMap.size());

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
        for(Brand_Projection_Staging__c bp: brandProjectionList){
            String type = bp.Type__c.indexOf('New')>-1?'New':'Disco';
            String skuMApKey = bp.SKU_Code__c+'-'+bp.Date_of_Projection__c+'-'+type;
            if(!allSKUProjections.contains(skuMApKey)){
                skuProjectionMap.put(skuMApKey,new SKU_Projection__c(Name=skuMapKey,SKU__r = new SKU__c(SKU__c=bp.SKU_code__c),Date_of_Projection__c=bp.Date_of_Projection__c,SKU_Projection_Unique_ID__c=skuMApKey,Include_in_Projections_Manual__c=true,Source__c='G-11 Unchanged',RecordTypeId=g11ProjectionRecordTypeId,Projection_Type__c=type));
                allSKUProjections.add(skuMapKey);
            }
            
            bps.add(new Brand_Projection__c(Name=bp.Type__c+'-'+bp.Brand_Code__c,Brand__r=new Brand__c(Brand_Code__c=bp.Brand_Code__c),Date_of_Projection__c=bp.Projection_Date__c,Projection_Type__c=bp.Type__c,Date_Of_creation__c=bp.Date_of_Projection__c,SKU_Projection__r=new SKU_Projection__c(SKU_Projection_Unique_ID__c=skuMApKey)));
        }
        if(skuProjectionMap.size()>0){
            insert skuProjectionMap.values() ;
        }
        if(bps.size()>0){
            insert bps;
        }
        }catch(Exception ex) {
            System.Debug('exception in BatchBrandProjectionStaging '+ex.getStackTraceString());
            throw ex;
        }
        System.Debug('brandProjectionList size '+brandProjectionList.size());
        System.Debug('inserted bps list '+bps.size());
        System.Debug('skupCodeMap  keyset after remove'+skuCodeMap.size());
        System.Debug('brandCodeMap keyset after remove'+brandCodeMap.size());

    }

    global void finish(Database.BatchableContext BC){
       //SendEmailTask(BC); Activate in Production
       //Database.executeBatch(new DeleteProjectionStaging(),2000);
       // We can delete staging records later
      // Database.executeBatch(new DeleteProjectedSKUs(),2000);
    }
    
    /*
    private void SendEmailTask(Database.BatchableContext BC) {  
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
        mail.setSubject('BatchBrandProjectionStaging Job Status ' + a.Status);
        mail.setPlainTextBody
        ('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
    } */
}