@isTest
public class TestSKUInventoryController {

static testMethod void TestSKUInventory() {
       Id orgId = [Select id from Organization].Id;
        Date actualDate = System.today().addMonths(-1).toStartOfMonth();
        Date projUpdateDate = System.today().addMonths(-1).toStartOfMonth();
        Date invUpdateDate = System.today().addMonths(-2).toStartOfMonth();
        Date uploadDate = System.today().addMonths(-1).toStartOfMonth();
        List<Brand__c> brandList = new List<Brand__c>();
        List<Brand__c> brandList2 = new List<Brand__c>();
         List<Brand__c> brandList3 = new List<Brand__c>();
        
        DataFactory.createLatestDates(orgID, actualDate, projUpdateDate,invUpdateDate);
        DataFactory.createLatestDates_OralCare(orgID, actualDate, projUpdateDate,invUpdateDate);
        List<SKU__c> skuList = DataFactory.createSKUs(20, 3, 'Air Care', 'Active & Planned','All Air Care','Home Care');
        Integer count = 0;
        for(SKU__c s:skuList) { 
            if(count < 10) brandList.addAll(s.Brands__r);
            else if(count >=10 && count <15)  brandList2.addAll(s.Brands__r);
            else if(count >= 15)  brandList3.addAll(s.Brands__r);
            count++;           
        }        

        List<Plant__c> plantList= DataFactory.createPlant(5);

        DataFactory.CreateInventory(brandList, plantList,3, uploadDate,'Home Care','In Exception',false);
        DataFactory.CreateInventory(brandList2, plantList,3, uploadDate,'Home Care','Ready for Steaming',false);
        DataFactory.CreateInventory(brandList3, plantList,3, uploadDate,'Home Care','Eliminated',false);

        Id skuId = [Select brand__r.SKU__c from Inventory__C where Status__c ='In Exception' LIMIT 1].brand__r.SKU__c;
        List<Inventory__c> invResults = SKUInventoryController.getInventoryExceptions(skuId);
        System.assert(invResults.size() > 0);

        SKUInventoryController.InventoryDetails invDetails = SKUInventoryController.getInventoryDetails(skuId);
        System.Debug('invdetails in exception'+invDetails);
        System.assertEquals(0,invDetails.ElimAmt);
        System.assertEquals(0,invDetails.ElimQty);
        System.assertEquals(23550.0,invDetails.ExcAmt);
        System.assertEquals(3000.0,invDetails.ExcQty);
        System.assertEquals(0,invDetails.ToScrapAmt);
        System.assertEquals(0,invDetails.ToScrapQty);

       
        skuId = [Select brand__r.SKU__c from Inventory__C where Status__c ='Ready for Steaming' LIMIT 1].brand__r.SKU__c;
        invDetails = SKUInventoryController.getInventoryDetails(skuId);
        System.Debug('invdetails ready for steaming'+invDetails);
        System.assertEquals(0,invDetails.ElimAmt);
        System.assertEquals(0,invDetails.ElimQty);
        System.assertEquals(0,invDetails.ExcAmt);
        System.assertEquals(0,invDetails.ExcQty);
        System.assertEquals(23550.0,invDetails.ToScrapAmt);
        System.assertEquals(3000.0,invDetails.ToScrapQty);
        invResults = SKUInventoryController.getInventoryExceptions(skuId);       
        System.assertEquals(0,invResults.size());

        skuId = [Select brand__r.SKU__c from Inventory__C where Status__c ='Eliminated' LIMIT 1].brand__r.SKU__c;
        invDetails = SKUInventoryController.getInventoryDetails(skuId);
        System.Debug('invdetails Eliminated'+invDetails);
        System.assertEquals(23550.0,invDetails.ElimAmt);
        System.assertEquals(3000.0,invDetails.ElimQty);
        System.assertEquals(0,invDetails.ExcAmt);
        System.assertEquals(0,invDetails.ExcQty);
        System.assertEquals(0,invDetails.ToScrapAmt);
        System.assertEquals(0,invDetails.ToScrapQty);


}

}