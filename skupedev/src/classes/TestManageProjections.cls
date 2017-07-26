@isTest
public class TestManageProjections {
    static testMethod void testManageProjections() {

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

          List<SKU_Projection__c> spList_manual =  DataFactory.createSKUProjection(skuList,2,'manual',true,projDate,'Customized New SKU');
          List<SKU_Projection__c> spList_g11 =  DataFactory.createSKUProjection(skuList2,2,'G11',true,projDate,'Customized New SKU');
          List<Brand_Projection__c> bpList = DataFactory.createBrandProjection(brandList3, spList_g11, 2, projDate, 'GBU Discos');
 
          Id[] skuIds = new Id[spList_manual.size()];
          for(Integer i = 0 ; i < spList_manual.size();i++) {                      
              skuIds[i] = spList_manual.get(i).Id; 
          }
         ManageProjectionsController.ManageProjectionsPagerWrapper wrapperData =  ManageProjectionsController.fetchProjections(1,10,skuIds,'Customized New SKU',false);
         System.assertEquals(54,wrapperData.total); 
         SKU_Projection__c spToDelete = [Select id from SKU_Projection__c where SKU__r.Name='SKU11' LIMIT 1];
         ManageProjectionsController.deleteProjection(spToDelete.Id);
         System.assertEquals(0,[Select count() from SKU_Projection__c where id=:spToDelete.Id]);

         SKU_Projection__c skuProj = [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,RecordType.DeveloperName FROM SKU_Projection__c where SKU__r.Name='SKU12' LIMIT 1];
         ManageProjectionsController.SKUDetails skuDetails =  ManageProjectionsController.FetchDetailsBySKUOrBC(skuProj,'SKU');
         System.assert(skuDetails !=null);
         System.assertEquals('Manual',skuDetails.recordTypeName);
         System.assertEquals('SKU120',skuDetails.sku);

         skuProj = [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,RecordType.DeveloperName FROM SKU_Projection__c where SKU__r.Name='SKU10' LIMIT 1];
         skuDetails =  ManageProjectionsController.FetchDetailsBySKUOrBC(skuProj,'Brandcode');
         System.assert(skuDetails !=null);
         System.assertEquals('Manual',skuDetails.recordTypeName);
         System.assertEquals('SKU00',skuDetails.sku);

         wrapperData =  ManageProjectionsController.fetchProjections(1,10,null,'Customized New SKU',false);
         System.assertEquals(79,wrapperData.total); 

         SKU_Projection__c newProj = new SKU_Projection__c();         
         SKU__c defaultSku = new SKU__c(Name='Manual Projection Default Parent SKU',SKU__C='Manual Projection Default Parent SKU',Status__c='Active & Planned');
         insert defaultSku;
         
         newProj.Brand_Name__c = 'All Air Care';
         newProj.SKU__c = defaultsku.Id;
         newProj.Brand_Code__c = '';
         newProj.Manual_Projected_Date__c= System.today().addMonths(2).toStartOfMonth();
         newProj.Projection_Type__c = 'New';
         newProj.Description__c = 'New Sku';
         newProj.SKU_Text__c = 'Test sku';

        
        newProj =  ManageProjectionsController.saveProjection(newProj, null);        
        System.assert(newProj.Id !=null);

        skuIds = new Id[spList_g11.size()];
          for(Integer i = 0 ; i < spList_g11.size();i++) {                          
              skuIds[i] = spList_g11.get(i).Id;              
          }

        skuProj = [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,RecordType.DeveloperName FROM SKU_Projection__c where SKU__r.Name='SKU22' LIMIT 1];
        skuDetails =  ManageProjectionsController.FetchDetailsBySKUOrBC(skuProj,'SKU');      
        wrapperData =  ManageProjectionsController.fetchProjections(1,10,skuIds,'Customized New SKU',false);
        System.assertEquals(26,wrapperData.total);
        

        Brand_Projection__c bpToDelete = [Select id,SKU_Projection__c From Brand_Projection__c where Name='Brand470' LIMIT 1];
        ManageProjectionsController.deleteProjection(bpToDelete.Id);
        skuProj = [Select Include_In_Projections_Manual__c from SKU_Projection__C where id = :bpToDelete.SKU_Projection__c];
        System.assertEquals(false,skuProj.Include_In_Projections_Manual__c);

        skuProj = new SKU_Projection__c(Name='ManualSKU',Brand_Name__c='ManualBrand',SKU_Text__c='ManualSKU',Description__c='Manual Description',Projection_Type__c='Disco');
        skuDetails =  ManageProjectionsController.FetchDetailsBySKUOrBC(skuProj,'SKU');
        System.assertEquals('ManualBrand',skuDetails.Brand);
        System.assertEquals('',skuDetails.SKUProjectionId);

        skuDetails =  ManageProjectionsController.FetchDetailsBySKUOrBC(skuProj,'Brandcode');

        for(SKU_Projection__c g11_proj: spList_g11) {
            g11_proj.Manual_Projected_Date__c = System.today().addMonths(3).toStartOfMonth();
        }
        skuIds.clear();

        for( ManageProjectionsController.SKUDetails sd:wrapperData.skuProjections) {
            sd.ProjectionMonth  = System.today().addMonths(3).toStartOfMonth();
            skuIds.add(sd.SKUProjectionId);
        }
        newProj.SKU_Text__c = '';
        newProj.Brand_Code__c = '';
        String jsonWrapperData = JSON.serializePretty(wrapperData.skuProjections);
        ManageProjectionsController.saveProjection(newProj, jsonWrapperData);
        List<SKU_Projection__c> spList = [Select Source__c,Manual_Projected_Date__c,RecordType.DeveloperName from SKU_Projection__c where id in :skuIds];
        System.assertEquals(10,spList.size());
        for(SKU_Projection__c sp:spList) {
            System.assertEquals(System.today().addMonths(3).toStartOfMonth(),sp.Manual_Projected_Date__c);
            System.assertEquals('G-11 Override',sp.Source__c);
            System.assertEquals('G_11',sp.RecordType.DeveloperName);
            
        }

        skuProj = new SKU_Projection__c(SKU_Text__c='SKU15');
        skuDetails =  ManageProjectionsController.FetchDetailsBySKUOrBC(skuProj,'SKU');

        Brand_Projection__c bp = [Select SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName,Sku_Projection__c,Sku_Projection__r.Manual_Projected_Date__c from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Include_in_Projections__c=true and SKU_Projection__r.SKU__r.SKU__c = 'SKU15' LIMIT 1];
        
        System.assertEquals(SkuDetails.Brand,bp.SKU_Projection__r.Group__c);
        System.assertEquals(SkuDetails.Brandcode,bp.Brand__r.Brand_Code__c);
        System.assertEquals(SkuDetails.Description,bp.Brand__r.Brand_Description__c);
        System.assertEquals(SkuDetails.ProjectionType,bp.SKU_Projection__r.Projection_Type__c);
        System.assertEquals(SkuDetails.ProjectionMonth,bp.Date_of_Projection__c);
        System.assertEquals(SkuDetails.BrandProjectionId,bp.Id);
        System.assertEquals(SkuDetails.SKUProjectionId,bp.SKU_Projection__c);

        //System.assertEquals('',skuDetails.SKUProjectionId);

        bp = [Select SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName,SKU_Projection__r.Manual_Projected_Date__c from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Include_in_Projections__c=true and Brand__r.Brand_Code__c = 'Brand47' LIMIT 1];
        skuProj = new SKU_Projection__c(SKU_Text__c='',Brand_Code__c='Brand47');
        skuDetails =  ManageProjectionsController.FetchDetailsBySKUOrBC(skuProj,'Brandcode');

        System.assertEquals(SkuDetails.Brand,bp.SKU_Projection__r.Group__c);
        System.assertEquals(SkuDetails.Brandcode,bp.Brand__r.Brand_Code__c);
        System.assertEquals(SkuDetails.Description,bp.Brand__r.Brand_Description__c);
        System.assertEquals(SkuDetails.ProjectionType,bp.SKU_Projection__r.Projection_Type__c);
        System.assertEquals(SkuDetails.ProjectionMonth,bp.Date_of_Projection__c);
        System.assertEquals(SkuDetails.BrandProjectionId,bp.Id);
        System.assertEquals(SkuDetails.SKUProjectionId,bp.SKU_Projection__c);

      
          

    }
}