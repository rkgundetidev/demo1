@isTest
public  class TestBatchBrandActualStaging {
    static testMethod void testBatch() {
        
         Id orgId = [Select id from Organization].Id;
         Date actualDate = System.today().addMonths(-1).toStartOfMonth();
         Date projectionDate = System.today().toStartOfMonth();
       
         List<Brand_Actual_Staging__c> baList = new List<Brand_Actual_Staging__c>();
         List<SKU__c> skuList = new List<SKU__c>();
         List<Brand__c> brandList = new List<Brand__c>();
         Map<String,Id> mapSKU = new Map<String,Id>();
         Set<String> skuSet = new Set<String>();
         Set<String> brandSet = new Set<String>();
         String SKU,Brand_code;
         Integer count;

          LatestDates__c latestDtSetting = new  LatestDates__c(SetupOWnerId=orgId,Date__c=actualDate,Projection_Update_Date__c=projectionDate,InvUpdateDate__c=actualDate);
         insert latestDtSetting;

         for(Integer i = 0 ; i <50 ; i++) {
             SKU = 'SK'+i;
             skuList.add(new SKU__c(Name=SKU,Category__c='Air Care',Dish_Care_Group__c='All Air Care',SKU__c=SKU,Status__c='Active & Planned'));
             skuSet.add(SKU);
         }

         insert skuList;

         System.Debug('skulist in test '+skuList.size());

         

         for(SKU__c s:skuList) if(!mapSKU.containsKey(s.Name)) mapSKU.put(s.Name,s.Id);

          for(Integer i = 0 ; i <50 ; i++) {
             Brand_Code = 'BC'+i;
             brandList.add(new Brand__c(Name=Brand_code,Brand_Code__c=Brand_code,Status__c='Active & Planned',sku__c= mapSKU.get('SK'+i),Brand_Description__c='BC_DESC'+i));
             brandSet.add(Brand_code);
         }

         insert brandList;

         for(Integer i = 0 ; i < 200; i++) {
             baList.add(new Brand_Actual_Staging__c(Brand_Code_Source__c='BC'+i,Date__c=System.today().toStartOfMonth(),Sku_Code_Source__c='SK'+i,EOH_Inventory__c=200.50,Status__c='Active & Planned'));
         }

         insert baList;
         Test.startTest();
         Database.executeBatch(new BatchBrandActualStaging(Enums.GBU.HOME_CARE));
         Test.stopTest();
         Date DateActual = [Select Date__c from LatestDates__c ].Date__c;
         System.assertEquals(System.today().toStartOfMonth(),DateActual);
      
         count = [Select count() from Brand_Actual_Staging__c ];
         System.assertEquals(0,count);
         count = [Select count() from Brand_Actual__c ];
         System.assertEquals(200,count);
         count = [Select count() from SKU_Actual__c ];
         System.assertEquals(200,count);
         count = [Select count() from SKU__c];
         System.assertEquals(200,count);
         count = [Select count() from Brand__c];
         System.assertEquals(200,count);


    }

    static testMethod void testMarkMissingBrandcodesFound() {

         Id orgId = [Select id from Organization].Id;
         Date actualDate = System.today().addMonths(1).toStartOfMonth();
         Date projectionDate = System.today().toStartOfMonth();
       
         List<Brand_Actual_Staging__c> baList = new List<Brand_Actual_Staging__c>();
         List<SKU__c> skuList = new List<SKU__c>();
         List<Brand__c> brandList = new List<Brand__c>();
         Map<String,Id> mapSKU = new Map<String,Id>();
         Set<String> skuSet = new Set<String>();
         Set<String> brandSet = new Set<String>();
         String SKU,Brand_code;
         Integer count;

          LatestDates__c latestDtSetting = new  LatestDates__c(SetupOWnerId=orgId,Date__c=actualDate,Projection_Update_Date__c=projectionDate,InvUpdateDate__c=actualDate);
         insert latestDtSetting;

        System.Debug('lastestdtsetting from test after insert '+latestDtSetting);

         for(Integer i = 0 ; i <200 ; i++) {
             SKU = 'SK'+i;
             skuList.add(new SKU__c(Name=SKU,Category__c='Air Care',Dish_Care_Group__c='All Air Care',SKU__c=SKU,Status__c='Active & Planned'));
             skuSet.add(SKU);
         }

         insert skuList;

            

         for(SKU__c s:skuList) if(!mapSKU.containsKey(s.Name)) mapSKU.put(s.Name,s.Id);

          for(Integer i = 0 ; i <200 ; i++) {
             Brand_Code = 'BC'+i;
             brandList.add(new Brand__c(Name=Brand_code,Brand_Code__c=Brand_code,Status__c='Active & Planned',sku__c= mapSKU.get('SK'+i),Brand_Description__c='BC_DESC'+i));
             brandSet.add(Brand_code);
         }

         insert brandList;

        for(Integer i = 0 ; i < 200; i++) {
             baList.add(new Brand_Actual_Staging__c(Brand_Code_Source__c='BC'+i,Date__c=System.today().toStartOfMonth().addMonths(-1),Sku_Code_Source__c='SK'+i,EOH_Inventory__c=200.50,Status__c='Active & Planned'));
         }

         insert baList;

         Test.startTest();
         Database.executeBatch(new BatchBrandActualStaging(Enums.GBU.HOME_CARE));
         Test.stopTest();
         Date DateActual = [Select Date__c from LatestDates__c ].Date__c;
         System.assertEquals(System.today().toStartOfMonth().addMonths(-1),DateActual);
      
         count = [Select count() from Brand_Actual_Staging__c ];
         System.assertEquals(0,count);
         count = [Select count() from Brand_Actual__c ];
         System.assertEquals(200,count);
         count = [Select count() from SKU_Actual__c ];
         System.assertEquals(200,count);
         count = [Select count() from SKU__c];
         System.assertEquals(200,count);
         count = [Select count() from Brand__c];
         System.assertEquals(200,count);

          List<Brand__c> bl = [Select  IsMissing__c from Brand__c ];
          System.Debug('bl ' +bl);
         Set<Boolean> bls = new Set<Boolean>();
         for(Brand__c b:bl) 
            bls.add(b.IsMissing__c);
           System.Debug('ar bl '+bls);




    }

}