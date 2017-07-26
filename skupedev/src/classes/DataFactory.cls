@isTest
public class DataFactory {
    public static List<SKU__c> createSKUs(Integer countSkus,Integer brandsPerSKU,String category,String status,String GroupName,String GBU) {
        List<SKU__c> skusToReturn = new List<SKU__c>();
        List<Brand__c> brandList = new List<Brand__c>();
        List<Inventory__c> invList = new List<Inventory__c>();

        SKU__c skuobj;
        Brand__c brandObj;

        Delete [Select id from SKU__c where GBU__c = :GBU and Status__c = :status ];

        for(Integer i = 0 ; i < countSkus  ;i++) {
            skuobj = new SKU__c(Name='SKU'+i,SKU__c='SKU'+i,Category__c = category,Status__c=status ,Dish_Care_Group__c = GroupName,GBU__c=GBU);
            skusToReturn.add(skuobj);
        }
       insert skusToReturn;
       Integer i = 0;       
       Integer c = 0;


       for(SKU__c sku:skusToReturn) {
          
           for( i = 0 ; i <brandsPerSKU; i++ ) {           
             brandObj = new Brand__c(Name='Brand'+c,Brand_Code__c='Brand'+c,SKU__c = sku.id,Status__c=status,EOH_Inventory__c=7000);            
             brandList.add(brandObj);
               c++;
           }
          
       }

       insert brandList;

      
       
       return  [select Name,SKU__c,Category__c,Status__c,Dish_Care_Group__c,(select Name,Brand_Code__c,SKU__c,Status__c from Brands__r) from SKU__c where GBU__c = :gbu and Status__c =:status and Category__c =:category ];

    }

    public static List<Plant__c> createPlant(Integer plantCount) {
         List<Plant__c> plantList = new List<Plant__c>();
        
        for(Integer intCt= 0 ;intCt < plantCount ; intCt++ )
        plantList.add(new Plant__c(Name='Plant'+intCt,Plant_Number__c='Plant'+intCt));

        insert plantList;
        return plantList;

    }

    public static LatestDates__c createLatestDates(Id ownerId,Date actualDate,Date projectionUpdateDate,Date invUpdateDate) {
         LatestDates__c latestDtSetting = new  LatestDates__c(SetupOWnerId=ownerId,Date__c=actualDate,Projection_Update_Date__c=projectionUpdateDate,InvUpdateDate__c=invUpdateDate);
         insert latestDtSetting;
         return latestDtSetting;
    }

    public static Latest_Dates_OralCare__c createLatestDates_OralCare(Id ownerId,Date actualDate,Date projectionUpdateDate,Date invUpdateDate) {
         Latest_Dates_OralCare__c latestDtSetting_OralCare = new  Latest_Dates_OralCare__c(SetupOWnerId=ownerId,ActualDate__c=actualDate,ProjDate__c=projectionUpdateDate,InvDate__c=invUpdateDate);
         insert latestDtSetting_OralCare;
         return latestDtSetting_OralCare;
    }

    public static List<Brand_Actual_Staging__c> createBrandActualStaging(Integer stagingCount,Date actualDate,String status,String GBU) {
        List<Brand_Actual_Staging__c> basList = new List<Brand_Actual_Staging__c>();
        for(Integer i = 0 ; i < stagingCount; i++)
        basList.add(new Brand_Actual_Staging__c(Brand_Code_Source__c='Brand'+i,Date__c=actualDate,Sku_Code_Source__c='SKU'+i,EOH_Inventory__c=100.00,Status__c=status,GBU__c=gbu));
        return basList;
    }

    public static List<Brand_Projection_Staging__c> createBrandProjectionStaging(Integer projectionCount,String Category,String type,String groupName,Date projectionDate,String GBU) {
         List<Brand_Projection_Staging__c> bpsList = new List<Brand_Projection_Staging__c>();
        for(Integer i = 0 ; i < projectionCount; i++)
        bpsList.add(new Brand_Projection_Staging__c(Brand_Code__c='Brand'+i,BrandCode_Description__c='Brand_DESC'+i,Type__c=type,Category__c =category,SKU_Code__c='SKU'+i,Group__c=groupName,Projection_Date__c=projectionDate,GBU__c=GBU));
        return bpsList;
    }

    Public static List<SKU_Actual__c> createSKUActual(List<SKU__c> skuList,Integer skuCount,String Category,Date actualDate) {
    
        List<SKU_Actual__c> skuActualList = new List<SKU_Actual__c>();
        Integer count = 0;
        for(SKU__c sku:skuList) {
          if(count <skuCount) skuActualList.add(new SKU_Actual__c(SKU__c=sku.id,Date__c=actualDate,SKU_Category__c=category));
           count++;
            
        }
        insert skuActualList;
        return skuActualList;

    }

    public static List<Brand_Projection__c> createBrandProjection(List<Brand__c> brandList,List<SKU_Projection__c> spList,Integer spCountPerbrand,Date projDate,String projType) {
        List<Brand_Projection__c> bpList = new List<Brand_Projection__c>();
        Integer intCount = 0;
       for(Brand__c brand :brandList) {
           
            for(Integer count = 0 ; count < spCountPerBrand;count++) {     
                if(intCount < spList.size()) {
                    bpList.add(new Brand_Projection__c(Name=brand.Name+count,Brand__c = brand.Id,SKU_Projection__c = spList.get(intCount).Id,Projection_Type__c = projType,Date_Of_Projection__c = projDate));   
                 intCount++; 

                } 
             }
       }
        insert bpList;
        System.Debug('return brand projections '+bpList);
        
        return bpList;
    }

   

    Public static List<SKU_Projection__c> createSKUProjection(List<SKU__c> skuList,Integer spCountPerSku,String spType,Boolean includeInProj,Date projDate,String projType) {
        Id rtypeid;
        List<SKU_Projection__c> spList = new List<SKU_Projection__c>();

        if(spType=='manual') rtypeid =  [Select id From RecordType where DeveloperName = 'Manual'].Id;
        else rtypeid = [Select id From RecordType where DeveloperName = 'G_11'].Id;
       
        for(SKU__c sku :skuList) {
            for(Integer count = 0 ; count < spCountPerSKU;count++) {
                if(spType=='G11')
                 spList.add(new SKU_Projection__c(SKU_Text__c=sku.Name+count,Name=sku.Name+count,SKU__c = sku.Id,RecordTypeId=rtypeid,Projection_Type__c = projType,Date_Of_Projection__c = projDate,Include_in_Projections_Manual__c=includeInProj));    
                else
                 spList.add(new SKU_Projection__c(SKU_Text__c=sku.Name+count,Name=sku.Name+count,Brand_Name__c='Brand_'+sku.Name+'_'+count,Description__c='Description'+sku.Name+count,SKU__c = sku.Id,RecordTypeId=rtypeid,Projection_Type__c = projType,Date_Of_Projection__c = projDate,Manual_Projected_Date__c = projDate,Include_in_Projections_Manual__c=includeInProj));    
            }
        }
        insert spList;
        System.Debug('return sku projections '+spList);
        return spList;
    }

    public static List<Inventory__c> CreateInventory(List<Brand__c> brandList,List<Plant__c> plantList,Integer invCountPerPlant,Date uploadDate,String gbu,String status,Boolean isMissing) {
        List<Inventory__c> invList = new List<Inventory__c>();
       

     //   List<Brand__c> brandList = [select Name,Brand_Code__c,SKU__c,Status__c from Brand__c];
     
        Integer count = 0;
        String uniqueid = '';
        if(Status == null||Status =='') Status = 'Not Ready For Steaming'; 
      
        for(Plant__c p :plantList) {
            for(Integer i = 0 ; i < invCountPerPlant ; i++) {
                uniqueid = brandList.get(count).Brand_Code__c+'-'+('BN'+count) +'-'+p.Plant_Number__c+'-'+('SL'+count);
                invList.add(new Inventory__c(Status__c=status,Is_Inventory_Missing__c=isMissing,Batch_Number__c='BN'+count,Site__c=p.Plant_Number__c,Plant__c=p.Id,Quantity_QualityInsp__c=1000,Quantity_Restricted__c=0,Quantity_Transit_and_Transfer__c=0,Quantity_Rets__c=0,Quantity_Unrestricted__c=0,Quantity_Blocked__c=0,Storage_Location__c='SL'+count,Value_Blocked_Stock__c=1200,Value_in_QualInsp__c=2500,Value_in_Transit_Transfr__c=1050,Value_Restricted__c=900,Value_Rets_Blocked__c=850,Value_Unrestricted__c=1350,Inventory_Unique_Id__c=uniqueid,Latest_Upload_Date__c=uploadDate,Brand__c= brandList.get(count).Id));
                count++;
            }
        }
              
         insert invList;

         System.Debug('data factory return invList '+invList);
         return invList; 
        

    }

    public static List<Inventory_Staging__c> createInventoryStaging(Integer stagingCount,Date uploadDate,String GBU) {
        List<Inventory_Staging__c> invsList = new List<Inventory_Staging__c>();
        for(Integer i = 0 ; i < stagingCount ; i++) {
             invsList.add(new Inventory_Staging__c(Brand_Code__c='Brand'+i,Batch_Number__c='BN'+i,Plant_Number__c='Plant'+i,Quantity_Quality_Inspection__c=0,Quantity_Restricted__c=0,Quantity_Transit_and_Transfer__c=0,Quantity_Rets__c=0,Quantity_Unrestricted__c=0,Quantity_Blocked__c=0,Storage_Location__c='SL'+i,Value_Blocked_Stock__c=0,Value_in_QualInsp__c=0,Value_in_Transit_Transfr__c=0,Value_Restricted__c=0,Value_Rets_Blocked__c=0,Value_Unrestricted__c=0,Upload_Date__c=uploadDate,GBU__c=gbu));
        }
        insert invsList;
        return invsList;
    }

    public static void reset() {
         Delete [Select id from SKU__c];
         Delete [Select id from Inventory__c];
         Delete [Select id from SKU_Actual__c];
         Delete [Select id from Brand_Actual__c];
         Delete [Select id from SKU_Projection__c];
         Delete [Select id from Brand_Projection__c];
         
    }

    
}