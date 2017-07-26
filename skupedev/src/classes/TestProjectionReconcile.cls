@isTest
public class TestProjectionReconcile {
    static testMethod void testReconcile() {

        Id orgId = [Select id from Organization].Id;
        Date actualDate = System.today().addMonths(-1).toStartOfMonth();
        Date projUpdateDate = System.today().addMonths(-1).toStartOfMonth();
        Date invUpdateDate = System.today().addMonths(-2).toStartOfMonth();
     
       
        
        DataFactory.createLatestDates(orgID, actualDate, projUpdateDate,invUpdateDate);
       

         List<SKU__c> skuList = DataFactory.createSKUs(40, 3, 'Air Care', 'Active & Planned','All Air Care','Home Care');
          Date projDate = System.today().addMonths(-1).toStartOfMonth();
          List<SKU__c> skuList2 = new List<SKU__c>();
          List<Brand__c> brandList = new List<Brand__c>();
          List<Brand__c> brandList2 = new List<Brand__c>();
          List<Brand__c> brandList3 = new List<Brand__c>();
          Integer count = 0;
          for(Integer r = 0 ; r < skuList.size();r++) {
            if(count < 10) brandList.addAll(skuList[r].Brands__r);
            else if(count >=10 && count <15)  brandList2.addAll(skuList[r].Brands__r);
            else if(count >= 15)  {
                brandList3.addAll(skuList[r].Brands__r);
                skuList2.add(skuList[r]);
                skuList.remove(r);

            }
            count++;      

        }        

          List<SKU_Projection__c> spList_manual =  DataFactory.createSKUProjection(skuList,2,'Manual',true,projDate,'Customized New SKU');
          List<SKU_Projection__c> spList_g11 =  DataFactory.createSKUProjection(skuList2,2,'G11',true,projDate,'Customized New SKU');

          List<Brand_Projection__c> bpList = DataFactory.createBrandProjection(brandList3, spList_g11, 2, projDate, 'GBU Discos');
          for(Brand_Projection__c bp:bpList) System.debug('bpList flag '+bp.sku_Projection__r.Is_current_G_11_Projection__c);
          
          ProjectionReconcileController.ManageProjectionsPagerWrapper wrapperData =  ProjectionReconcileController.fetchProjections(1);
          System.assertEquals(null,wrapperData.manualinput_total);
          System.assertEquals(4,wrapperData.systemdata_total);

          wrapperData =  ProjectionReconcileController.fetchProjections(2);
          wrapperData =  ProjectionReconcileController.fetchProjections(3);

          List<SKU_Projection__c> spToUpdate = new List<SKU_Projection__c>();
          count = 0;
          List<String> skusToUpdate = new List<String>();
          for(SKU_Projection__c sp:spList_manual) {
              skusToUpdate.add(sp.Id+':'+true);
              if(count < 20) spToUpdate.add(sp);
              count++;
          }

         ProjectionReconcileController.updateProjections(skusToUpdate);
         spToUpdate =[Select Include_in_Projections_Manual__c from SKU_Projection__c where id in :spList_manual];
         for(SKU_Projection__c sp:spToUpdate) System.assertEquals(true,sp.Include_in_Projections_Manual__c);

        SKU_Projection__c spToDelete = [Select id from SKU_Projection__c where SKU__r.Name='SKU11' LIMIT 1];
         ProjectionReconcileController.deleteProjection(spToDelete.Id);
         System.assertEquals(0,[Select count() from SKU_Projection__c where id = :spToDelete.Id]);

         SKU_Projection__c spToUpdt = [Select Include_in_Projections_Manual__c,SKU_Text__c,Brand_Code__c,Projection_Type__c,Manual_Projected_Date__c from SKU_Projection__c where  SKU__r.Name='SKU12' LIMIT 1 ];
         SKU_Projection__c spUpdated = ProjectionReconcileController.saveProjection(spToUpdt,null);



    }
}