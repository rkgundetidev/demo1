public class ProjectionReconcileController {
    public class SKUDetails { 
        @AuraEnabled 
        public String Brand_Name {get;set;}
        @AuraEnabled 
        public String Brand_Code {get;set;}
        @AuraEnabled 
        public String SKU_Text {get;set;}
        @AuraEnabled  
        public String Description {get;set;}
        @AuraEnabled 
        public String Projection_Type {get;set;}
        @AuraEnabled
        public Date Projected_Date {get;set;} 
         //public String Projected_Date {get;set;} 
        @AuraEnabled
        public Boolean Include_In_Projections_Manual {get;set;}
        @AuraEnabled
        public Boolean isChecked {get;set;}
        @AuraEnabled
        public String Id {get;set;}    
        @AuraEnabled
        public String Comments {get;set;} 
    }     
  
    // create a wrapper class with @AuraEnabled Properties   
  
 public class ManageProjectionsPagerWrapper {
    @AuraEnabled public Integer manualinput_pageSize {get;set;}
    @AuraEnabled public Integer manualinput_page {get;set;}
    @AuraEnabled public Integer manualinput_total {get;set;}

     @AuraEnabled public Integer systemdata_pageSize {get;set;}
    @AuraEnabled public Integer systemdata_page {get;set;}
    @AuraEnabled public Integer systemdata_total {get;set;}


    @AuraEnabled public List<SKU_Projection__c> skuProjections {get;set;}
    @AuraEnabled public List<Brand_Projection__c> brandProjections {get;set;}
    @AuraEnabled public List<SKUDetails> skuProjectionsWrapper {get;set;}
    @AuraEnabled public List<SKUDetails> systemDataWrapper {get;set;}
   }

   
   /* @AuraEnabled
    public static void updateProjections(List<SKU_Projection__c> projToUpdate,List<SKU_Projection__c> brandToUpdate) {
        System.Debug('update projections '+projToUpdate);
         System.Debug('update system data '+brandToUpdate);
       // for(SKU_Projection__c sp:projToUpdate) sp.Include_in_Projections_Manual__c = !sp.Include_in_Projections_Manual__c ;
       try {
        if(projToUpdate !=null) update projToUpdate;
        if(brandToUpdate !=null) update brandToUpdate;
        System.debug('update of projections and/or system data is/are successful!');
       }catch(Exception ex) {
           System.Debug('error in updating projections '+ex.getMessage());
       }

       // return projToUpdate;
    }*/

     @AuraEnabled
    public static void updateProjections(List<String> skusToUpdate) {
        System.Debug('update projections '+skusToUpdate);
        Map<Id,SKU_Projection__c> mapProjections;
        List<SKU_Projection__c> projectionsUpdateList = new List<SKU_Projection__c>();
        Set<Id> projIds = new Set<Id>();
        String[] val;
        try {
            for(String str:skusToUpdate)  {
                projIds.add(str.split(':')[0]);
            }
            mapProjections = new Map<Id,SKU_Projection__c>([Select Id,Include_in_Projections_Manual__c,RecordType.DeveloperName from SKU_Projection__c where id in :projIds]);
            for(String str:skusToUpdate) {
                val = str.split(':');
                Boolean checkValue = Boolean.valueOf(val[1]);
                SKU_Projection__c spDb = mapProjections.get(val[0]);
                if(spDb !=null && val[0]==spDb.Id && checkValue != spDb.Include_in_Projections_Manual__c) 
                projectionsUpdateList.add(new SKU_Projection__c(Id=spDb.Id,Include_in_Projections_Manual__c=checkValue));
                //System.Debug('from page '+val[0]+' '+val[1]+' from db '+spDb);
            }
            System.Debug('projections update list' +projectionsUpdateList);
            if(projectionsUpdateList.size() > 0 ) update projectionsUpdateList;
        // for(SKU_Projection__c sp:projToUpdate) sp.Include_in_Projections_Manual__c = !sp.Include_in_Projections_Manual__c ;
       
      
       }catch(Exception ex) {
           System.Debug('error in updating projections '+ex.getMessage());
       }

       // return projToUpdate;
    }
  @AuraEnabled
  
public static ManageProjectionsPagerWrapper fetchProjections(Integer step) {
    Set<String> skuIds = new Set<String>();    
    List<Brand_Projection__c> g11_projections ;
    List<SKU_Projection__c> manualProjections;
    step = Integer.valueOf(step);
    System.Debug('step in '+step);
    
    // create a instance of wrapper class.
   ManageProjectionsPagerWrapper obj =  new ManageProjectionsPagerWrapper();
   Set<String> skuSet = new Set<String>();
   Set<String> brandCodeSet = new Set<String>();
   Set<String> brandSet = new Set<String>();
      
   Set<String> skuSet_g11 = new Set<String>();
   Set<String> brandCodeSet_g11 = new Set<String>();
   Set<String> brandSet_g11 = new Set<String>();

   Map<Integer,Set<String>> skuMap = new Map<Integer,Set<String>>();
   Map<Integer,Set<String>> brandCodeMap = new Map<Integer,Set<String>>();
   Map<Integer,Set<String>> brandMap = new Map<Integer,Set<String>>();
   Map<String,Brand_Projection__c> skuMap_g11 = new Map<String,Brand_Projection__c>();
   Map<String,Brand_Projection__c> brandCodeMap_g11 = new Map<String,Brand_Projection__c>();
   Map<String,Brand_Projection__c> brandMap_g11 = new Map<String,Brand_Projection__c>();

   manualProjections = [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,Include_in_Projections_Manual__c,Category__c,Comments__c from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' ];
   g11_projections = [select SKU_Projection__c, SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName,SKU_Projection__r.Include_in_Projections_Manual__c,SKU_Projection__r.SKU__r.Id,Brand__r.SKU__c,SKU_Projection__r.Category__c,SKU_Projection__r.SKU__r.Dish_Care_Group__c   from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Is_current_G_11_Projection__c = true];

   for(Brand_Projection__c bp:g11_projections) {
        skuSet_g11.add(bp.SKU_Projection__r.SKU__r.SKU__c);
        brandCodeSet_g11.add(bp.Brand__r.Brand_Code__c);
        // brandSet_g11.add(bp.SKU_Projection__r.Category__c);
         brandSet_g11.add(bp.SKU_Projection__r.SKU__r.Dish_Care_Group__c);
    }
    for(SKU_Projection__c sp:manualProjections) {
        skuSet.add(sp.SKU_Text__c);
        brandCodeSet.add(sp.Brand_Code__c);
        brandSet.add(sp.Brand_Name__c);
     // brandSet.add(sp.Category__c); 
        if(step == 1 && sp.SKU_Text__c !=null && sp.SKU_Text__c !='') skuIds.add(sp.SKU_Text__c);          
         else if(step == 2 && sp.Brand_Code__c !=null && sp.Brand_Code__c !='') skuIds.add(sp.Brand_Code__c);
    }
    
     skuMap.put(step,skuSet);
     brandCodeMap.put(step,brandCodeSet);
     brandMap.put(step,brandSet);

     System.Debug('skuset values '+skuset);
     System.Debug('bcset values '+brandcodeset);
     System.Debug('brandset values '+brandset);

     System.Debug('skuset values g11 '+skuset_g11);
     System.Debug('bcset values g11 '+brandcodeset_g11);
     System.Debug('brandset values g11 '+brandset_g11);
     System.Debug('step d'+skuIds+' '+step);
             
    if(step == 1)  manualProjections = [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,Include_in_Projections_Manual__c,Category__c,Comments__c from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' and SKU_Text__c in :skuSet_g11     order by SKU_Text__c asc ];
    else if(step == 2) manualProjections = [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,Include_in_Projections_Manual__c,Category__c,Comments__c from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' and Brand_Code__c in :brandCodeSet_g11 AND (SKU_Text__c NOT IN:skuSet_g11 OR SKU_Text__c = null)  order by Brand_Code__c asc ];
    else if(step ==3){
        manualProjections = [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,Include_in_Projections_Manual__c,Category__c,Comments__c from  SKU_Projection__c where RecordType.DeveloperName = 'Manual' and (Brand_Name__c in :brandSet_g11)   AND ((SKU_Text__c NOT IN :skuSet_g11 AND Brand_Code__c NOT in :brandCodeSet_g11) OR (SKU_Text__c = NULL AND Brand_Code__c = NULL) OR (SKU_Text__c = NULL AND Brand_Code__c NOT IN :brandCodeSet_g11) OR (Brand_Code__c = NULL AND SKU_Text__c NOT IN :skuSet_g11))    order by Category__c,Brand_Name__c ];
        for(SKU_Projection__c sp:manualProjections) {
            if(sp.Brand_Name__c !=null && sp.Brand_Name__c !='')  skuIds.add(sp.Brand_Name__c);
          // if(sp.Category__c !=null && sp.Category__c != '') skuIds.add(sp.Category__c);
         }
    }
    g11_projections =  getsystemdata(skuIds,step,skuMap,brandCodeMap,brandMap); 
    obj.brandprojections = g11_projections;
    obj.skuprojections =  manualProjections;
    obj.skuProjectionsWrapper = getWrapperdata(obj.skuProjections,null);       
    System.Debug('size check '+obj.skuProjections.size()+' '+obj.brandProjections.size());
    if(obj.skuProjections.size() ==0 && obj.brandProjections.size() > 0) obj.brandProjections = null;            
    obj.systemdata_total =  obj.brandProjections != null ? obj.brandProjections.size():0;
    System.Debug('total for step 3 '+ obj.systemdata_total );    
     obj.systemDataWrapper = obj.brandProjections !=null  ? getsystemdata2(obj.brandProjections):null;
          
    // return the wrapper class instance .
        return obj;   
     }

       @AuraEnabled
    public static void deleteProjection(Id projectionId) {
        delete [Select id from SKU_Projection__c where id = :projectionId];
    }

     @AuraEnabled 
     public static SKU_Projection__c saveProjection(SKU_Projection__c projectionDataToInsert,Id updateId) {
         
        System.Debug('in save method '+updateId+' '+projectionDataToInsert);
        update projectionDataToInsert;        
         return projectionDataToInsert;

     }

   
    private static List<Brand_Projection__c> getsystemdata(Set<String> skus,Integer step, Map<Integer,Set<String>> skuMap,Map<Integer,Set<String>> brandCodeMap,Map<Integer,Set<String>> brandMap) {
         List<Brand_Projection__c> results = new List<Brand_Projection__c>();
         System.Debug('in getsystemdata '+skuMap.get(step)+' '+brandCodeMap.get(step)+' '+skus);
         if(step == 1)
         //return [Select Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,Include_in_Projections_Manual__c from  SKU_Projection__c  where Is_current_G_11_Projection__c = true and (sku_text__c = :skus or SKU__r.SKU__c = :skus) LIMIT :pageSize OFFSET :offset ];
          results=  [select SKU_Projection__c, SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName,SKU_Projection__r.Include_in_Projections_Manual__c,SKU_Projection__r.SKU__r.Id,Brand__r.SKU__c,SKU_Projection__r.Category__c,SKU_Projection__r.SKU__r.Dish_Care_Group__c   from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Is_current_G_11_Projection__c = true  and  SKU_Projection__r.SKU__r.SKU__c in :skus ORDER BY SKU_Projection__r.SKU__r.SKU__c asc ];
         else if(step ==2)
         results = [select SKU_Projection__c,SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName,SKU_Projection__r.Include_in_Projections_Manual__c,SKU_Projection__r.SKU__r.Id,Brand__r.SKU__c,SKU_Projection__r.Category__c,SKU_Projection__r.SKU__r.Dish_Care_Group__c    from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Is_current_G_11_Projection__c = true  and  Brand__r.Brand_Code__c in :skus AND SKU_Projection__r.SKU__r.SKU__c NOT IN :skuMap.get(step)  ORDER BY Brand__r.Brand_Code__c asc ];
         else if(step ==3)         
         results = [select SKU_Projection__c,SKU_Projection__r.Group__c,Brand__r.Brand_Code__c,Brand__r.Brand_Description__c,SKU_Projection__r.Projection_Type__c,Date_of_Projection__c,SKU_Projection__r.SKU__r.SKU__c,SKU_Projection__r.RecordType.DeveloperName,SKU_Projection__r.Include_in_Projections_Manual__c,SKU_Projection__r.SKU__r.Id,Brand__r.SKU__c,SKU_Projection__r.Category__c,SKU_Projection__r.SKU__r.Dish_Care_Group__c  from Brand_Projection__c where SKU_Projection__r.recordtype.DeveloperName='G_11' and sku_Projection__r.Is_current_G_11_Projection__c = true  and  ((SKU_Projection__r.SKU__r.Dish_Care_Group__c in :skus OR  SKU_Projection__r.Category__c in :skus )  AND (SKU_Projection__r.SKU__r.SKU__c NOT IN :skuMap.get(step) AND Brand__r.Brand_Code__c NOT IN :brandCodeMap.get(step)) ) ORDER BY SKU_Projection__r.SKU__r.Dish_Care_Group__c ];

         System.Debug('returning system results for '+step+' '+results.size());
         return results;
     }

     private static List<SKUDetails> getsystemdata2(List<Brand_Projection__c> bpData) {
         List<Brand_Projection__c> results = new List<Brand_Projection__c>();
         List<SKU_Projection__c> spResults;
         List<SKUDetails> skDetails = new List<SKUDetails>();
         
          Set<String> skuIds = new Set<String>();
        
         Map<String,Brand_Projection__c> mapBP = new Map<String,Brand_Projection__c>();
         String key ='';
         for(Brand_Projection__c bp:bpData) {
             key = bp.Brand__r.SKU__c+'-'+bp.SKU_Projection__c;
              If(!mapBP.containsKey(key)) mapBP.put(key,bp);
              skuIds.add(bp.Brand__r.SKU__c);
         }
         

         spResults = [Select SKU__c,Brand_Name__c,Brand_Code__c,Description__c,Projection_Type__c,Manual_Projected_Date__c,SKU_Text__c,Include_in_Projections_Manual__c,Comments__c  from  SKU_Projection__c  where Is_current_G_11_Projection__c = true and recordtype.DeveloperName='G_11' and SKU__c in :skuIds  ];
         
        for(SKU_Projection__c sp:spResults) {
            SKUDetails sd = new SKUDetails();
            Brand_Projection__c bp = mapBP.get(sp.SKU__c+'-'+sp.Id);
            if(bp !=null) {
                //System.Debug('loop bp'+bp);
                sd.Id = sp.id;
                sd.Brand_Code =  bp.Brand__r.Brand_Code__c;
                sd.Description = bp.Brand__r.Brand_Description__c;
                sd.Projected_Date   = bp.Date_of_Projection__c;
                sd.SKU_Text = bp.SKU_Projection__r.SKU__r.SKU__c;
                sd.Projection_Type = bp.SKU_Projection__r.Projection_Type__c;
                sd.Brand_Name = bp.SKU_Projection__r.Group__c;
                sd.Include_In_Projections_Manual = bp.SKU_Projection__r.Include_in_Projections_Manual__c;
                sd.Comments = sp.Comments__c;

                skDetails.add(sd);

            }
           
        }

        System.Debug('returning skDetails list '+skDetails);
         
        return skDetails;
     }

     private static List<SKUDetails> getWrapperData(List<SkU_Projection__c> spData,List<Brand_Projection__c> bpData ) {

         List<SKUDetails> skdList = new List<SKUDetails>();
         System.Debug('wrapper data source list '+spData+' '+bpData);

         if(spData !=null  && spData.size() > 0) {
         for(SKU_Projection__c sp:spData) {
            SKUDetails sd = new SKUDetails();
            sd.Id = sp.Id;
            sd.Brand_Name=sp.Brand_Name__c;
            sd.Brand_Code=sp.Brand_Code__c;
            sd.Description=sp.Description__c;
           // sd.Projected_Date=sp.Manual_Projected_Date__c!=null ?sp.Manual_Projected_Date__c.format():'';
            sd.Projected_Date=sp.Manual_Projected_Date__c;
            sd.Projection_Type = sp.Projection_Type__c;
            sd.SKU_Text=sp.SKU_Text__c;
            sd.isChecked =sp.Include_in_Projections_Manual__c;
            sd.Include_In_Projections_Manual =sp.Include_in_Projections_Manual__c;
            sd.Comments = sp.Comments__c;
            skdList.add(sd);
          }

         }
         else if(bpData !=null && bpData.size() > 0) {

             for(Brand_Projection__c bp:bpData) {
                // System.Debug('in wrapper loop '+bp);
                 SKUDetails sd = new SKUDetails();
                 sd.Id = bp.SKU_Projection__C;
                 sd.Brand_Name = bp.SKU_Projection__r.Group__c;
                 sd.Brand_Code = bp.Brand__r.Brand_Code__c;
                 sd.Description = bp.Brand__r.Brand_Description__c;
                 sd.Projection_Type = bp.SKU_Projection__r.Projection_Type__c;
                 sd.SKU_Text = bp.SKU_Projection__r.SKU__r.SKU__c;
                // sd.Projected_Date = bp.Date_of_Projection__c!=null ? bp.Date_of_Projection__c.format() : '' ;
                 sd.Projected_Date = bp.Date_of_Projection__c ;
                // sd.isChecked = bp.Include_in_Projections_Manual__c;
                 sd.Include_In_Projections_Manual = bp.SKU_Projection__r.Include_in_Projections_Manual__c;
                 skdList.add(sd);
             }
 
         } 
         System.Debug('return wrapper = '+skdList);
         return skdList;

     }

}