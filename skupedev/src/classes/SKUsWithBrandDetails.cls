public with sharing class SKUsWithBrandDetails{
    @AuraEnabled
    public static list<SKUBrandWrapper> getSKUsWithBrandDetails(String[] skuids,String projType){
        system.debug('>>>>>>>>>> skuids '+skuids);
        system.debug('>>>>>>>>>> projType '+projType);
        list<SKUBrandWrapper> lstWrapper = new list<SKUBrandWrapper>();
        string strQuery = 'Select Id, Name, Category__c, Dish_Care_Group__c, Status__c, Projected_Start_Date__c, Projected_Disco_Date__c, SKU_Description__c, '
                          +'(Select Id, Name, Type__c, Status__c, EOH_Inventory_Formula__c, Projected_Disco_Date_Effective__c, Brand_Description__c, '
                          +'Projected_Disco_Date_Override__c, Projected_Start_Date_Effective__c, Projected_Start_Date_Override__c From Brands__r where Status__c in (\'Projected\',\'Active & Planned\')) '
                          +'From SKU__c Where Id in :skuids';
        lstWrapper.clear();
        for(SKU__c objSKU : DataBase.Query(strQuery)){
            if(objSKU.Brands__r != null && objSKU.Brands__r.size() > 0){
                lstWrapper.add(new SKUBrandWrapper(objSKU, objSKU.Brands__r, projType));
            }else{
               // Lets not add skus with no brands
              //  lstWrapper.add(new SKUBrandWrapper(objSKU, null, fldAPIName));
            }
        }
        if(lstWrapper != null && lstWrapper.size() > 0){
            return lstWrapper;
        }else{
            return null;
        }
        //return DataBase.Query(strQuery);
    }
    
    @AuraEnabled
    public static string updateBrands(String strWrapperParam){//(list<SaveWrapper> lstWrapper){
        SaveWrapper[] lstWrapperParam = (SaveWrapper[]) JSON.deserialize(strWrapperParam, List<SaveWrapper>.class);
        system.debug('=====:::'+lstWrapperParam);
        
        try{
            list<Brand__c> updateBrands = new list<Brand__c>();
            system.debug('number of brands in this sku '+lstWrapperParam.size());
            for(SaveWrapper objWrapper : lstWrapperParam){
                system.debug('looping around the wrappers before save');
                if(objWrapper.projType.indexOf('New')>-1){
                    updateBrands.add(new Brand__c(Id = objWrapper.brandId,Projected_Start_Date_Override__c=objWrapper.dateoverride));
                }else{
                    updateBrands.add(new Brand__c(Id = objWrapper.brandId,Projected_Disco_Date_Override__c=objWrapper.dateoverride));
                }
            }
            system.debug('number of brands added for update '+updateBrands.size());
            /*for(SaveWrapper objWrapper : lstWrapper){
                if(objWrapper.Disco_Date_Override != null){
                    updateBrands.add(new Brand__c(Id = objWrapper.brandId, Projected_Disco_Date_Override__c = objWrapper.Disco_Date_Override));
                }
                if(objWrapper.Start_Date_Override != null){
                    updateBrands.add(new Brand__c(Id = objWrapper.brandId, Projected_Disco_Date_Override__c = objWrapper.Start_Date_Override));
                }
                    
            }*/
            if(updateBrands != null && updateBrands.size() > 0){
                update updateBrands;
            }
            return 'Success';
        }catch(Exception Ex){
            system.debug('exeption==='+ex.getmessage());    
            return 'Error';
        }
    }
    
    @AuraEnabled
    public static SaveWrapper getSampleWrapper(){
        return new SaveWrapper('1',system.today(),'gbu new sku');
    }

    public class SaveWrapper{
        @AuraEnabled public string brandId {get;set;}
        @AuraEnabled public Date dateoverride {get;set;}
        @AuraEnabled public String projType {get;set;}

        public SaveWrapper(String id,Date dt,String type){
            this.brandId = id;
            this.dateoverride = dt;
            this.projType = type;
        }
    }
    
    public class SKUBrandWrapper{
        @AuraEnabled public SKU__c objSKU {get;set;}
        @AuraEnabled public list<Brand__c> lstBrand {get;set;}
        @AuraEnabled public string strInterface{get;set;}
        public SKUBrandWrapper(SKU__c sku, list<Brand__c> brands, string intFace){
            this.objSKU = sku;
            this.lstBrand = brands;
            this.strInterface = intFace;
        }
    }       
}