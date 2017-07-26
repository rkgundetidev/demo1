@isTest
public class TestBatchLoadInventory {
    static testmethod void testInventoryload() {
        Id orgId = [Select id from Organization].Id;
        Date actualDate = System.today().addMonths(-1).toStartOfMonth();
        Date projUpdateDate = System.today().addMonths(-1).toStartOfMonth();
        Date invUpdateDate = System.today().addMonths(-2).toStartOfMonth();
        Date uploadDate = System.today().addMonths(-1).toStartOfMonth();
        List<Brand__c> brandList = new List<Brand__c>();
        List<Brand__c> brandList2 = new List<Brand__c>();
        
        DataFactory.createLatestDates(orgID, actualDate, projUpdateDate,invUpdateDate);
        DataFactory.createLatestDates_OralCare(orgID, actualDate, projUpdateDate,invUpdateDate);
        List<SKU__c> skuList = DataFactory.createSKUs(20, 3, 'Air Care', 'Active & Planned','All Air Care','Home Care');
        Integer count = 0;
        for(SKU__c s:skuList) {
            if(count < 10) brandList.addAll(s.Brands__r);
            else  brandList2.addAll(s.Brands__r);
            count++;           
        }
        

        List<Plant__c> plantList= DataFactory.createPlant(5);

        DataFactory.CreateInventory(brandList, plantList,3, uploadDate,'Home Care','',true);
        DataFactory.createInventoryStaging(20,uploadDate,'Home Care');
        DataFactory.CreateInventory(brandList2, plantList,3, uploadDate,'Home Care','Ready For Steaming',false);
        
       
        BatchLoadInventory bli = new BatchLoadInventory(Enums.GBU.Home_Care);

     //  List<SKU__c> skList  = [Select Name,R_H_Substatus__c,Total_EOH__c from SKU__c ];
      // for(SKU__c s:skList) System.Debug('RH STATUS '+s.R_H_Substatus__c+' '+s.Total_EOH__c);
        Test.startTest();
        Database.executeBatch(bli);
        Test.stopTest();

        Date latestDate = System.today().addMonths(1).toStartOfMonth();
        GetLatestDates.getLatest(Enums.GBU.HOME_CARE,Enums.MODULE.ACTUALS);
        GetLatestDates.getLatest(Enums.GBU.HOME_CARE,Enums.MODULE.INVENTORIES);
        GetLatestDates.getLatest(Enums.GBU.HOME_CARE,Enums.MODULE.PROJECTIONS);

        GetLatestDates.getLatest(Enums.GBU.ORAL_CARE,Enums.MODULE.ACTUALS);
        GetLatestDates.getLatest(Enums.GBU.ORAL_CARE,Enums.MODULE.INVENTORIES);
        GetLatestDates.getLatest(Enums.GBU.ORAL_CARE,Enums.MODULE.PROJECTIONS);

        GetLatestDates.getLatest(Enums.GBU.SKIN_CARE,Enums.MODULE.ACTUALS);
        GetLatestDates.getLatest(Enums.GBU.SKIN_CARE,Enums.MODULE.INVENTORIES);
        GetLatestDates.getLatest(Enums.GBU.SKIN_CARE,Enums.MODULE.PROJECTIONS);

        GetLatestDates.updateLatest(Enums.GBU.HOME_CARE,Enums.MODULE.ACTUALS,latestDate);
        GetLatestDates.updateLatest(Enums.GBU.HOME_CARE,Enums.MODULE.INVENTORIES,latestDate);
        GetLatestDates.updateLatest(Enums.GBU.HOME_CARE,Enums.MODULE.PROJECTIONS,latestDate);

        GetLatestDates.updateLatest(Enums.GBU.ORAL_CARE,Enums.MODULE.ACTUALS,latestDate);
        GetLatestDates.updateLatest(Enums.GBU.ORAL_CARE,Enums.MODULE.INVENTORIES,latestDate);
        GetLatestDates.updateLatest(Enums.GBU.ORAL_CARE,Enums.MODULE.PROJECTIONS,latestDate);

        GetLatestDates.updateLatest(Enums.GBU.SKIN_CARE,Enums.MODULE.ACTUALS,latestDate);
        GetLatestDates.updateLatest(Enums.GBU.SKIN_CARE,Enums.MODULE.INVENTORIES,latestDate);
        GetLatestDates.updateLatest(Enums.GBU.SKIN_CARE,Enums.MODULE.PROJECTIONS,latestDate);

        Enums.getGBUStr(Enums.GBU.HOME_CARE);
        Enums.getGBUStr(Enums.GBU.SKIN_CARE);
        Enums.getGBUStr(Enums.GBU.ORAL_CARE);

        Enums.getGBUEnum('Home Care');
        Enums.getGBUEnum('Oral Care');
        Enums.getGBUEnum('Skin Care');



    }

    static testMethod void testLoadInventoryRemnant() {

       // DataFactory.reset();
        Id orgId = [Select id from Organization].Id;
        Date actualDate = System.today().addMonths(-1).toStartOfMonth();
        Date projUpdateDate = System.today().addMonths(-1).toStartOfMonth();
        Date invUpdateDate = System.today().addMonths(-2).toStartOfMonth();
        Date uploadDate = System.today().addMonths(-1).toStartOfMonth();
        List<Brand__c> brandList = new List<Brand__c>();
        List<Brand__c> brandList2 = new List<Brand__c>();

         DataFactory.createLatestDates(orgID, actualDate, projUpdateDate,invUpdateDate);

        List<SKU__c> skuList = DataFactory.createSKUs(20, 3, 'Air Care', 'Remnant & Historical','All Air Care','Home Care');
        Integer count = 0;
        for(SKU__c s:skuList) {
            if(count > 10) {
                brandList2.addAll(s.Brands__r);
            }
            if(count < 10) brandList.addAll(s.Brands__r);
            count++;
           // for(Brand__c b:brandList) System.Debug('brand '+b);
        }

        List<Plant__c> plantList= DataFactory.createPlant(5);

        DataFactory.CreateInventory(brandList, plantList,3, uploadDate,'Home Care','',true);
        DataFactory.createInventoryStaging(20,uploadDate,'Home Care');
       //DataFactory.CreateInventory(brandList2, plantList,3, uploadDate,'Home Care','Ready For Steaming',false);

        DataFactory.createSKUActual(skuList,10,'Air Care',System.today());
        BatchLoadInventory bli = new BatchLoadInventory(Enums.GBU.Home_Care);

        List<SKU__c> skList  = [Select Name,R_H_Substatus__c,Total_EOH__c,IsSKUMissing__c from SKU__c ];
       //for(SKU__c s:skList) System.Debug('RH STATUS '+s.R_H_Substatus__c+' '+s.Total_EOH__c+' '+s.IsSKUMissing__c);
        Test.startTest();
        Database.executeBatch(bli);
        Test.stopTest();

        DataFactory.createInventoryStaging(10,uploadDate,'Oral Care');
        try {
         BatchLoadInventory bli2 = new BatchLoadInventory(Enums.GBU.Home_Care);
        }catch(Exception ex) {
             System.assertEquals('Inventory Staging table contains data from multiple GBUs',ex.getMessage());
         }
      
    }

}