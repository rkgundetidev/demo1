public class ManageProjectionsController {
    public class SKUDetails {
        
        @AuraEnabled 
        public String Brand {get;set;}
        @AuraEnabled 
        public String Brandcode {get;set;}
        @AuraEnabled 
        public String Sku {get;set;}
        @AuraEnabled 
        public String Description {get;set;}
        @AuraEnabled 
        public String ProjectionType {get;set;}
        @AuraEnabled
        public Date ProjectionMonth {get;set;} 
        @AuraEnabled
        public String RecordTypeName {get;set;}
        @AuraEnabled
        public Date ManualProjectedDate {get;set;}
        @AuraEnabled
        public Date BrandProjectedDate {get;set;}
        @AuraEnabled
        public String SKUProjectionId {get;set;}
        @AuraEnabled
        public String BrandProjectionId {get;set;}

        @AuraEnabled
        public SKU_Projection__c SKuProjection {get;set;}
        @AuraEnabled
        public Brand_Projection__c BrandProjection {get;set;}

        public SKUDetails(){

        }

        public SKUDetails(String Brand, String Brandcode, String Skucode, String Description, String ProjectionType, Date ProjectionMonth,String RecordTypeName,String SKUProjectionId,String BrandProjectionId,Date ManualProjectedDate){
            this.Brand = brand;
            this.Brandcode = brandcode;
            this.Sku = Skucode;
            this.Description = Description;
            this.ProjectionType = ProjectionType;
            this.ProjectionMonth = ProjectionMonth;
            if(RecordTypeName == 'G_11')
            this.BrandProjectedDate = ProjectionMonth;
            this.RecordTypeName = RecordTypeName;
            this.ManualProjectedDate = ManualProjectedDate;
            this.SKUProjectionId  = SKUProjectionId;
            this.BrandProjectionId = BrandProjectionId;
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

    
      @AuraEnabled
 public static ManageProjectionsPagerWrapper fetchProjections(Integer pageNumber ,Integer recordToDisply,Id[] skuids,String projType,Boolean isDelete) {
    ManageProjectionsPagerWrapper wrapperData =  new ManageProjectionsPagerWrapper();
     try {
            Integer pageSize = Integer.valueOf(recordToDisply);
            Integer offset = (Integer.valueOf(pageNumber) - 1) * Integer.valueOf(pageSize);
            isDelete = isDelete == null ? false:isDelete;
            System.Debug('fetchprojections '+projType);
            
           
            wrapperData.pageSize = pageSize;
            wrapperData.page = pageNumber;
            if(skuids!=null && skuids.size()>0){
                wrapperData.total = [SELECT count() FROM SKU_Projection__c  where Id in :skuids];
            }else{
                wrapperData.total = [SELECT count() FROM SKU_Projection__c  where Include_in_Projections__c=true];
            }
            System.Debug('skuids '+skuids);
            System.Debug('wrapperData = '+wrapperData+' '+pageSize+' '+offset);
            wrapperData.skuprojections = new SKUDetails[]{}; 
            
            If(skuids !=null) {
                for(SKU_Projection__c sp:[Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Projected_Date__c,Manual_Projected_Date__c,SKU_Text__c,RecordType.DeveloperName from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' and Include_in_Projections__c=true and id in :skuids LIMIT :pageSize OFFSET :offset]){
                    wrapperData.skuprojections.add(new SKUDetails(sp.Brand_Name__c,sp.Brand_Code__c,sp.SKU_Text__c,sp.Description__c,projType,sp.Projected_Date__c,sp.RecordType.DeveloperName,sp.Id,'',sp.Manual_Projected_Date__c));
                }
                System.Debug('obj.skuprojections before brand projection query '+wrapperData.skuprojections.size());
                if(wrapperData.skuprojections.size()<pageSize){
                    for(Brand_Projection__c bp:[Select SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName,sku_Projection__r.Manual_Projected_Date__c,sku_projection__c from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Include_in_Projections__c=true and sku_projection__c in :skuids LIMIT :pageSize OFFSET :offset]){
                        System.Debug('in bp soql loop '+bp);
                        //obj.skuprojections.add(new SKUDetails(bp.Id,bp.SKU_Projection__r.Group__c,bp.Brand__r.Brand_Code__c,bp.SKU_Projection__r.SKU__r.SKU__c,bp.Brand__r.Brand_Description__c,bp.SKU_Projection__r.Projection_Type__c,bp.Date_of_Projection__c,bp.SKU_Projection__r.RecordType.DeveloperName));
                        wrapperData.skuprojections.add(new SKUDetails(bp.SKU_Projection__r.Group__c,bp.Brand__r.Brand_Code__c,bp.SKU_Projection__r.SKU__r.SKU__c,bp.Brand__r.Brand_Description__c,projType,bp.Date_of_Projection__c,bp.SKU_Projection__r.RecordType.DeveloperName,bp.SKU_Projection__c,bp.Id,bp.sku_Projection__r.Manual_Projected_Date__c));
                    }
                }
                System.Debug('obj.skuprojections '+wrapperData.skuprojections.size());
                if(isDelete) wrapperData.total = wrapperData.skuprojections.size();
            }       
         }catch(Exception ex) {
          System.Debug('Error in fetchProjections '+ex.getMessage());
        }
       return wrapperData;   
     }

     @AuraEnabled
     public static SKU_Projection__c saveProjection(SKU_Projection__c projectionDataToInsert,String g11Projections) {
        Id manualRt = [Select id from RecordType where DeveloperName='Manual'].Id;
        System.Debug('in save method '+projectionDataToInsert);
        try {
         
            if ((projectionDataToInsert.SKU_Text__c !='' && projectionDataToInsert.Brand_Code__c =='') || 
                (projectionDataToInsert.Brand_Code__c !='' && projectionDataToInsert.SKU_Text__c =='') ||
                (projectionDataToInsert.Brand_Code__c !='' && projectionDataToInsert.SKU_Text__c !='') ){
                    
                System.Debug('about to insert ');   
                System.Debug('recordType name '+projectionDataToInsert.RecordType.DeveloperName);
                projectionDataToInsert.recordTypeid = manualRt;       
                projectionDataToInsert.SKU_Projection_Unique_Id__c =  projectionDataToInsert.SKU_Text__c + '-'+projectionDataToInsert.Projection_Type__c+'-'+projectionDataToInsert.RecordType.DeveloperName;
                upsert ProjectionDataToInsert SKU_Projection_Unique_Id__c ;
                System.Debug('inserted new projection '+ projectionDataToInsert);
            }

            else if(g11Projections !=null) {
                System.Debug('g11 size '+g11Projections);
                List<ManageProjectionsController.SKUDetails> g11List = (List<ManageProjectionsController.SKUDetails>)JSON.deserialize(g11Projections, List<ManageProjectionsController.SKUDetails>.class);
                System.Debug('g11 record '+g11List);
                List<SKU_Projection__c> skusToUpdate = new List<SKU_Projection__c>();
                List<Brand_Projection__c> brandsToUpdate = new List<Brand_Projection__c>();

                for(ManageProjectionsController.SKUDetails g11:g11List) {
                    System.Debug('sd loop '+g11);
                    if((g11.ProjectionMonth != g11.ManualProjectedDate && g11.ManualProjectedDate !=null)
                    ||(g11.BrandProjectedDate != g11.ProjectionMonth)) {
                        skusToUpdate.add(new SKU_Projection__c(Id=g11.SKUProjectionId,Manual_Projected_Date__c=g11.ProjectionMonth,Source__c='G-11 Override'));
                        brandsToUpdate.add(new Brand_Projection__c(Id=g11.BrandProjectionId,Date_of_Projection__c = g11.ProjectionMonth));
                    }
                }      
                
                System.Debug('skus to update '+skusToUpdate);
                System.Debug('brands to update'+brandsToUpdate);
                if(skusToUpdate.size() > 0) Update skusToUpdate;
                if(brandsToUpdate.size() > 0) Update brandsToUpdate;
                
            }
        
        }catch(Exception ex) {
            System.Debug('Error in saveProjection '+ex.getMessage());
        }
         return projectionDataToInsert;
     }
     

    @AuraEnabled
    public static void deleteProjection(Id projectionId) {
        try {
              SKU_Projection__c projection;
              System.Debug('delete id'+projectionId);
              List<Brand_Projection__c> bp = [Select SKU_Projection__c from Brand_Projection__c where id = :projectionId];
              if(!bp.isEmpty() && bp.size() > 0)  {
                    projection = [Select Include_in_Projections_Manual__c from SKU_Projection__c where id = :bp[0]. SKU_Projection__c];
                    if(projection !=null) {
                        projection.Include_in_Projections_Manual__c = false;
                        Update projection;
                        System.Debug('update of g11 sku projection is success!!'+'brand projection id = '+projectionId+' sku projection = '+projection.Id);
                    }
               }
              else {                
                Delete [Select id from SKU_Projection__c where id = :projectionId];
                System.Debug('deleted manual sku projection  '+projectionId);
              }
      
        }catch(Exception ex) {
            System.Debug('error in updating flag of projection data '+ex.getMessage());
        }
    }


    
    @AuraEnabled
    public static SKUDetails FetchDetailsBySKUOrBC(SKU_Projection__c value,String type) {
        SKUDetails skDetails;
        List<SKU_Projection__c> sp = new List<SKU_Projection__c>();
        SKU_Projection__c spcopy;
        List<Brand_Projection__c> bp = new List<Brand_Projection__c>();
        List<SKU__c> sku = new List<SKU__c>();
        List<Brand__c> brand = new List<Brand__c>();
        System.Debug('in fetchdetails '+value+' '+type);
        try {
              skDetails = new SKUDetails();
              if(type=='SKU') {
                sp  = [Select Id,Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,RecordType.DeveloperName from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' and SKU_Text__c = :value.SKU_Text__c and Include_in_Projections__c = true LIMIT 1];
                if(sp.size() > 0) {
                    System.Debug('SKU Search - Found manual projection');
                    spcopy = sp[0];   
                    skDetails.SkuProjection = sp[0];
                    skDetails = new SKUDetails(sp[0].Brand_Name__c,sp[0].Brand_Code__c,sp[0].SKU_Text__c,sp[0].Description__c,sp[0].Projection_Type__c,sp[0].Manual_Projected_Date__c,sp[0].RecordType.DeveloperName,sp[0].Id,'',sp[0].Manual_Projected_Date__c);
                }
                else {
                    bp = [Select SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName,Sku_Projection__c,Sku_Projection__r.Manual_Projected_Date__c from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Include_in_Projections__c=true and SKU_Projection__r.SKU__r.SKU__c = :value.SKU_Text__c LIMIT 1];
                    if(bp.size() > 0) {                     
                        skDetails = new SKUDetails(bp[0].SKU_Projection__r.Group__c,bp[0].Brand__r.Brand_Code__c,bp[0].SKU_Projection__r.SKU__r.SKU__c,bp[0].Brand__r.Brand_Description__c,bp[0].SKU_Projection__r.Projection_Type__c,bp[0].Date_of_Projection__c,bp[0].SKU_Projection__r.RecordType.DeveloperName,bp[0].SKU_Projection__c,bp[0].Id,bp[0].SKU_Projection__r.Manual_Projected_Date__c)  ;
                        skDetails.BrandProjection = bp[0];
                        System.Debug('SKU Search - Found G11 projection'+skDetails.BrandProjection);
                    }
                    else  {               
                        System.Debug('SKU Search - No manual/G11 sku');
                        skDetails = new SKUDetails(value.Brand_Name__c,value.Brand_Code__c,value.SKU_Text__c,value.Description__c,value.Projection_Type__c,value.Projected_Date__c,(value.RecordType !=null ? value.RecordType.DeveloperName:''),'','',null);
                    }
                }
            }
            else if(type=='Brandcode') {
                sp  = [Select Id,Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,RecordType.DeveloperName from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' and  Brand_Code__c = :value.Brand_Code__c and Include_in_Projections__c = true LIMIT 1];         
                if(sp.size() > 0) {             
                    System.Debug('Brand Search - Found manual projection');
                    skDetails = new SKUDetails(sp[0].Brand_Name__c,sp[0].Brand_Code__c,sp[0].SKU_Text__c,sp[0].Description__c,sp[0].Projection_Type__c,sp[0].Manual_Projected_Date__c,sp[0].RecordType.DeveloperName,sp[0].Id,'',sp[0].Manual_Projected_Date__c);
                    skDetails.SkuProjection = sp[0];              
                }
                else {          
                    bp = [Select SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName,SKU_Projection__r.Manual_Projected_Date__c from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Include_in_Projections__c=true and Brand__r.Brand_Code__c = :value.Brand_Code__c LIMIT 1];
                    if(bp.size() > 0) {                                  
                        skDetails = new SKUDetails(bp[0].SKU_Projection__r.Group__c,bp[0].Brand__r.Brand_Code__c,bp[0].SKU_Projection__r.SKU__r.SKU__c,bp[0].Brand__r.Brand_Description__c,bp[0].SKU_Projection__r.Projection_Type__c,bp[0].Date_of_Projection__c,bp[0].SKU_Projection__r.RecordType.DeveloperName,bp[0].SKU_Projection__c,bp[0].Id,bp[0].SKU_Projection__r.Manual_Projected_Date__c)  ;
                        skDetails.BrandProjection = bp[0];                 
                        System.Debug('Brand Search - Found G11 projection'+skDetails.BrandProjection);
                    }
                    else  {
                        skDetails = new SKUDetails(value.Brand_Name__c,value.Brand_Code__c,value.SKU_Text__c,value.Description__c,value.Projection_Type__c,value.Projected_Date__c,(value.RecordType !=null ? value.RecordType.DeveloperName:''),'','',null);
                        System.Debug('Brand Search - no manual/g11 projection');
                    }               
                }
            }
        }catch(Exception ex) {
            System.Debug('Error in FetchDetailsBySKUOrBC '+ex.getMessage());
        }
        return skDetails;
       
    }

}