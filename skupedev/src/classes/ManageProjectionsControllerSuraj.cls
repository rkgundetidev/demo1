public class ManageProjectionsControllerSuraj {
    public class SKUDetails {
        @AuraEnabled 
        public String brand {get;set;}
        @AuraEnabled 
        public String brand_code {get;set;}
        @AuraEnabled 
        public String sku {get;set;}
        @AuraEnabled 
        public String description {get;set;}
        @AuraEnabled 
        public String projType {get;set;}
        @AuraEnabled
        public Date projMonth {get;set;} 
        @AuraEnabled
        public String recordTypeName {get;set;}

        public SKUDetails(){

        }

        public SKUDetails(String brand, String brandcode, String skucode, String description, String projType, Date projMonth,String recordTypeName){

            this.brand = brand;
            this.brand_code = brandcode;
            this.sku = skucode;
            this.description = description;
            this.projType = projType;
            this.projMonth = projMonth;
            this.recordTypeName = recordTypeName;

        }
    }

    // create a wrapper class with @AuraEnabled Properties   
 
 public class ManageProjectionsPagerWrapper {
    @AuraEnabled public Integer pageSize {get;set;}
    @AuraEnabled public Integer page {get;set;}
    @AuraEnabled public Integer total {get;set;}
    //@AuraEnabled public List<SKU_Projection__c> skuProjections {get;set;}
    @AuraEnabled public List<SKUDetails> skuProjections {get;set;}
   }

   class ProjectionRecord {
       @AuraEnabled public String brandName {get;set;}
       @AuraEnabled public String brandDescription {get;set;}
       @AuraEnabled public String skuCode {get;set;}
       @AuraEnabled public String brandCode {get;set;}
       @AuraEnabled public String description {get;set;}
       @AuraEnabled public Date projectedDate {get;set;}
       @AuraEnabled public String projectionType {get;set;}
   }

      @AuraEnabled
 public static ManageProjectionsPagerWrapper fetchProjections(Integer pageNumber ,Integer recordToDisply,Id[] skuids) {
      Integer pageSize = Integer.valueOf(recordToDisply);
      Integer offset = (Integer.valueOf(pageNumber) - 1) * Integer.valueOf(pageSize);
    
    // create a instance of wrapper class.
   ManageProjectionsPagerWrapper obj =  new ManageProjectionsPagerWrapper();
    // set the pageSize,Page(Number), total records and accounts List(using OFFSET)   
        obj.pageSize = pageSize;
        obj.page = pageNumber;
        if(skuids!=null && skuids.size()>0){
            obj.total = [SELECT count() FROM SKU_Projection__c  where Id in :skuids];
        }else{
            obj.total = [SELECT count() FROM SKU_Projection__c  where Include_in_Projections__c=true];
        }
        System.Debug('skuids '+skuids);
        System.Debug('obj = '+obj+' '+pageSize+' '+offset);
        /*obj.skuprojections = [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' LIMIT :pageSize OFFSET :offset];*/

        obj.skuprojections = new SKUDetails[]{}; 
        for(SKU_Projection__c sp:[Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Projected_Date__c,SKU_Text__c,RecordType.DeveloperName from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' and Include_in_Projections__c=true and id in :skuids LIMIT :pageSize OFFSET :offset]){
            obj.skuprojections.add(new SKUDetails(sp.Brand_Name__c,sp.Brand_Code__c,sp.SKU_Text__c,sp.Description__c,sp.Projection_Type__c,sp.Projected_Date__c,sp.RecordType.DeveloperName));
        }

        System.Debug('obj.skuprojections before brand projection query '+obj.skuprojections.size());

        if(obj.skuprojections.size()<pageSize){
            for(Brand_Projection__c bp:[Select SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Include_in_Projections__c=true and sku_projection__c in :skuids LIMIT :pageSize OFFSET :offset]){
                System.Debug('in bp soql loop '+bp);
                obj.skuprojections.add(new SKUDetails(bp.SKU_Projection__r.Group__c,bp.Brand__r.Brand_Code__c,bp.SKU_Projection__r.SKU__r.SKU__c,bp.Brand__r.Brand_Description__c,bp.SKU_Projection__r.Projection_Type__c,bp.Date_of_Projection__c,bp.SKU_Projection__r.RecordType.DeveloperName));
            }
        }
        System.Debug('obj.skuprojections '+obj.skuprojections.size());
    // return the wrapper class instance .
        return obj;   
     }

     @AuraEnabled
     public static SKU_Projection__c saveProjection(SKU_Projection__c projectionDataToInsert,Id updateId) {
        Id manualRt = [Select id from RecordType where DeveloperName='Manual'].Id;
        System.Debug('in save method '+updateId+' '+projectionDataToInsert);
        if(updateId!=null) update projectionDataToInsert;
        else {
         System.Debug('about to insert ');   
         projectionDataToInsert.recordTypeid = manualRt;
         projectionDataToInsert.SKu_Projection_Unique_Id__c =  projectionDataToInsert.SKU_Text__c + '-'+projectionDataToInsert.Projection_Type__c+'-'+projectionDataToInsert.RecordType.DeveloperName;
         //insert projectionDataToInsert;
         upsert ProjectionDataToInsert SKu_Projection_Unique_Id__c ;
         System.Debug('inserted new projection '+ projectionDataToInsert);
     }
         return projectionDataToInsert;

     }
     

    @AuraEnabled
    public static void deleteProjection(Id projectionId) {
        delete [Select id from SKU_Projection__c where id = :projectionId];
    }


    @AuraEnabled 
    public static Brand__c getSKUDetails(String brandcode) {
        SKUDetails skDetails;
        Brand__c bcData = [ Select Brand_Code__c, SKU__r.Dish_Care_Group__c,Type__c,SKU__r.SKU_Description_Short__c,Brand_Description__c,SKU__r.Name,SKU__r.Status__c from Brand__c where Brand_Code__c = :brandcode ];

        return bcData;
    }
    @AuraEnabled 
    public static Brand__c getSKUDetailsBySKU(String sku) {
        SKUDetails skDetails;
        Brand__c bcData = [ Select Brand_Code__c, SKU__r.Dish_Care_Group__c,Type__c,SKU__r.SKU_Description_Short__c,Brand_Description__c,SKU__r.Name,SKU__r.Status__c from Brand__c where SKU__r.Name = :sku ];

        return bcData;
    }
    @AuraEnabled
    public static SKU_Projection__c FetchDetailsBySKUOrBC(SKU_Projection__c value,String type) {
        SKUDetails skDetails;
        List<SKU_Projection__c> sp = new List<SKU_Projection__c>();
        SKU_Projection__c spcopy;
        Brand_Projection__c bp;
        List<SKU__c> sku = new List<SKU__c>();
        List<Brand__c> brand = new List<Brand__c>();
        System.Debug('in fetchdetails '+value);
        if(type=='SKU') {
           sp  = [Select Id,Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,RecordType.Name from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' and SKU_Text__c = :value.SKU_Text__c and Include_in_Projections__c = true LIMIT 1];
          // skDetails = new SKUDetails();
           if(sp.size() > 0) {
              spcopy = sp[0];
              //return spcopy;
              //return spcopy;
           }
           else {
              // sku = [Select SKU__c,SKU_Description__c,Dish_Care_Group__c,(Select Brand_Code__c from Brands__r Limit 1) from SKU__c where SKU__c = :value.SKU_Text__c LIMIT 1];
                   //sku = [Select SKU__c,SKU_Description__c,Dish_Care_Group__c,(Select Brand_Code__c from Brands__r Limit 1) from SKU__c where SKU__c = :value.SKU_Text__c LIMIT 1];
               sp = [Select Id,Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,RecordType.Name from  SKU_Projection__c where RecordType.DeveloperName = 'G_11' and SKU__r.SKU__c = :value.SKU_Text__c  and Include_in_Projections__c = true LIMIT 1];
               //spcopy = new SKU_Projection__c();
               if(sp.size() > 0) {  
                    spcopy = sp[0];             
             /*  spcopy.Brand_Name__c = sku[0].Dish_Care_Group__c;
               spcopy.Brand_Code__c = sku[0].Brands__r.size() > 0 ? sku[0].Brands__r[0].Brand_Code__c : '';
               spcopy.Description__c = sku[0].SKU_Description__c;     */  
               }
               else spcopy =value;
              /* else  {
                 spcopy.Brand_Name__c = '';
                 spcopy.Brand_Code__c = '';
                 spcopy.SKU_Text__c = value;
                 

               }*/
           }
       }

       else if(type=='Brandcode') {
           sp  = [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c from  SKU_Projection__c where  Brand_Code__c = :value.Brand_Code__c  LIMIT 1];
           skDetails = new SKUDetails();
           if(sp.size() > 0) {
              spcopy = sp[0];
               //return spcopy;
               //return spcopy;
         /*  skDetails.brand = sp.Brand_Name__c;
           skDetails.brand_code = sp.Brand_Code__c;
           skDetails.description = sp.Description__c;
           skDetails.projMonth = sp.Manual_Projected_Date__c;
           skDetails.projType = sp.Projection_Type__c;*/
           }
           else {
               brand = [Select SKU__r.Name,Brand_Description__c,SKU__r.Dish_Care_Group__c from Brand__c where Brand_Code__c = :value.Brand_Code__c LIMIT 1];
                spcopy = new SKU_Projection__c();
               if(brand.size() > 0) {
              
               spcopy.Brand_Name__C = brand[0].SKU__r.Dish_Care_Group__c;
               spcopy.SKU_Text__c = brand[0].SKU__r.Name;
               spcopy.Description__c = brand[0].Brand_Description__c;       
               }
               else spcopy = value;
              /* else  {
                 spcopy.Brand_Name__c = '';
                 spcopy.Brand_Code__c = value;
                 spcopy.SKU_Text__c = ''; 
                 spcopy.Projection_Type__c = 'Disco';
               }*/
           }
       }


        return spcopy; 
    }

    @AuraEnabled 
    public static List<SKU_Projection__c> getManualProjections() {
        return [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' ];
     //  return [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c from  SKU_Projection__c limit 200 ];

    }

    public static List<String> getProjectionTypes(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = SKU_Projection__c.Projection_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f: ple) {
            options.add(f.getLabel());
        }

        return options;
     }

}