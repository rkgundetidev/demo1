@isTest
public class TestDataFactory {
 
 static testMethod void testDataFactory() {
     List<Brand__c> brandList = new List<Brand__c>();
     List<SKU__c> skuList = DataFactory.createSKUs(20,2,'Air Care','Remnant & Historical','HDW','Home Care');

     System.Debug('SKU list '+skuList);
     System.assertEquals(20,skuList.size());
     for(SKU__c s:SKUList) 
       System.assertEquals(2,s.Brands__r.size());

     skuList = DataFactory.createSKUs(20,0,'Air Care','Remnant & Historical','HDW','Home Care');
    
     System.assertEquals(20,skuList.size());
     for(SKU__c s:SKUList) 
     System.assertEquals(0,s.Brands__r.size());

    List<Plant__c> plantList = DataFactory.createPlant(25);
    System.assertEquals(25,plantList.size());

    skuList = DataFactory.createSKUs(50,10,'Air Care','Remnant & Historical','ADW','Home Care');
     for(SKU__c s:SKUList) brandList.addAll(s.Brands__r);

    List<Inventory__c> invList = DataFactory.CreateInventory(brandList, plantList,20,System.today().toStartOfMonth(),'Home Care',true);
    
    System.assertEquals(500,invList.size());
    for(Inventory__C inv:invList)
      System.assertEquals(System.today().toStartOfMonth(),inv.Latest_Upload_Date__c);
    
    List<Brand_Actual_Staging__c> basList = DataFactory.createBrandActualStaging(200,System.today().addMonths(-1).toStartOfMonth(),'Active & Planned','Home Care');
    System.assertEquals(200,basList.size());
    for(Brand_Actual_Staging__c bas:basList)  {
      System.assertEquals(100.00,bas.EOH_Inventory__c);
      System.assertEquals('Active & Planned',bas.Status__c);
      System.assertEquals(System.today().addMonths(-1).toStartOfMonth(),bas.Date__c);
    }

    List<Brand_Projection_Staging__c> bpsList = DataFactory.createBrandProjectionStaging(200,'Air Care','GBU Discos','All Air Care',System.today().addMonths(1).toStartOfMonth(),'Home Care');
    System.assertEquals(200,bpsList.size());
    for(Brand_Projection_Staging__c bps:bpsList)  {    
      
      System.assertEquals(System.today().addMonths(1).toStartOfMonth(),bps.Projection_Date__c);
    }

    List<Inventory_Staging__c> invsList = DataFactory.createInventoryStaging(200, System.today().toStartOfMonth(),'Home Care');
    System.assertEquals(200,invsList.size());
    
      
 }
 

}