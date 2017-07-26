public class CreateNewSKUWithBrandsCntrl{
    @AuraEnabled
    public static List<String> getPicklistValues(String strFieldName){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult;
        if(strFieldName=='Category__c')
        {
            fieldResult = SKU__c.Category__c.getDescribe();
        }else if(strFieldName=='Dish_Care_Group__c'){
            fieldResult = SKU__c.Dish_Care_Group__c.getDescribe();
        }
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add('--Select--');
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }
        system.debug('picklistvalues===='+options);
        return options;
    }
    
    @AuraEnabled
    public static string createSKU(SKU__c objSKU, Brand__c objBrnd){
        string strResult = '';
        Savepoint sp = Database.setSavepoint();
        try{
            system.debug('objSKU==='+objSKU+'===objBrnd==='+objBrnd);
            string strSKU = string.valueof(objSKU.Name);
            if(string.isBlank(strSKU)){
                objSKU.Name = 'Temp';
                objSKU.SKU__c = 'Temp';
            }else{
                objSKU.Name = strSKU;
                objSKU.SKU__c = strSKU;
            }
            objSKU.Status__c = 'Projected';
            insert objSKU;
            
            SKU__c sku = [Select Id, Name, SKU__c, SKU_Auto_Number__c From SKU__c Where Id =: objSKU.Id];
            if(sku.Name == 'Temp'){    
                sku.Name = sku.SKU_Auto_Number__c;
                sku.SKU__c = sku.SKU_Auto_Number__c;
                update sku;
            }
            objBrnd.Name = 'Temp';
            objBrnd.Brand_Code__c = 'Temp';
            objBrnd.SKU__c = sku.Id;
            insert objBrnd;
            
            Brand__c brand = [Select Id, Name, Brand_Code__c, Brand_Auto_Number__c From Brand__c Where Id =: objBrnd.Id];
            objBrnd.Name = brand.Brand_Auto_Number__c;
            objBrnd.Brand_Code__c = brand.Brand_Auto_Number__c;
            update objBrnd;
            
            strResult = 'Success';
        }catch(Exception Ex){
            strResult = ex.getMessage();
            Database.rollback(sp);
        }
        return strResult;
    }
}