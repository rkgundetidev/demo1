public class SkuInventoryController {

    public class InventoryDetails {
       @AuraEnabled 
        public Decimal ToScrapQty {get;set;}
        @AuraEnabled   
        public Decimal ToScrapAmt{get;set;}
          @AuraEnabled 
        public Decimal ElimQty{get;set;}
          @AuraEnabled 
        public Decimal ElimAmt{get;set;}
          @AuraEnabled 
        public Decimal ExcQty{get;set;}
          @AuraEnabled 
        public Decimal ExcAmt{get;set;}
    }
     @AuraEnabled 
    public static List<Inventory__c> getInventoryExceptions(Id skuId) {
            
       System.Debug('received sku getinventoryExceptions '+skuId);
       List<Inventory__c> invList  ;
        try {
            invList  = [Select Brand__r.SKU__r.SKU__c,	Site__c,Batch_Number__c,Total_Quantity__c,Total_Value__c  from Inventory__c 
                                        where Brand__r.SKU__c = :skuId and Status__c = 'In Exception' ORDER BY  Brand__r.SKU__r.SKU__c ];
                
           System.Debug('returning invlist '+invList);
        }catch(Exception ex) {             
             System.Debug('encountered exception '+ex.getMessage());            
        }
        return invList;
    }
    
    @AuraEnabled 
    public static InventoryDetails getInventoryDetails(Id skuId) {
        
        System.Debug('received sku getInventoryDetails '+skuId);
        Sku__c skuObj;
        Inventory__c invObj;
        List<AggregateResult> ar_toscrapinv,ar_eliminv,ar_excinv;
        InventoryDetails invdetails;
        try {
          /*skuObj = [Select Inventories_Eliminated__c,Inventories_Ready_for_Steaming__c,	Inventories_Submitted_for_Steaming__c,Inventories_in_Exception__c,
                           Brands_Ready_for_Steaming__c,Brands_Submitted_for_Steaming__c,Brands_with_Submission_in_Progress__c,Brands_Eliminated__c
                    from SKU__c where id = : skuId ];
            
                 System.Debug('skuObj '+skuObj);    
             */
             ar_toscrapinv = [ Select Brand__r.SKU__r.SKU__c,SUM(Total_Quantity__c) ToScrapQty ,SUM(Total_Value__c) ToScrapAmt from Inventory__c 
                          where Status__c in ('Submitted for Steaming','Ready for Steaming')
                          and brand__r.SKU__c = : skuId 
                            GROUP BY Brand__r.SKU__r.SKU__c
                            ];
            
             ar_eliminv = [ Select Brand__r.SKU__r.SKU__c,SUM(Total_Quantity__c) ElimQty ,SUM(Total_Value__c) ElimAmt from Inventory__c 
                          where Status__c = 'Eliminated'
                          and brand__r.SKU__c = : skuId 
                            GROUP BY Brand__r.SKU__r.SKU__c
                            ];
            

 			ar_excinv = [ Select Brand__r.SKU__r.SKU__c,SUM(Total_Quantity__c) ExcQty ,SUM(Total_Value__c) ExcAmt from Inventory__c 
                          where Status__c = 'In Exception'
                          and brand__r.SKU__c = : skuId 
                            GROUP BY Brand__r.SKU__r.SKU__c
                            ];
         invdetails = new InventoryDetails();

         if(!ar_toscrapinv.isEmpty() && ar_toscrapinv.size() > 0) {
         invdetails.ToScrapQty = (Decimal)ar_toscrapinv[0].get('ToScrapQty');
         invdetails.ToScrapQty =  invdetails.ToScrapQty == null ? 0 : invdetails.ToScrapQty;
         invdetails.ToScrapAmt = (Decimal)ar_toscrapinv[0].get('ToScrapAmt');
         invdetails.ToScrapAmt = invdetails.ToScrapAmt == null ? 0: invdetails.ToScrapAmt;
         System.Debug('to scrap inv'+invdetails);
         }
         else invdetails.ToScrapQty = invdetails.ToScrapAmt = 0;

         if(!ar_eliminv.isEmpty() && ar_eliminv.size() > 0) {
         invdetails.ElimQty = (Decimal)ar_eliminv[0].get('ElimQty');
          invdetails.ElimQty =  invdetails.ElimQty == null ? 0:  invdetails.ElimQty;
         invdetails.ElimAmt = (Decimal)ar_eliminv[0].get('ElimAmt');
         invdetails.ElimAmt = invdetails.ElimAmt == null ? 0: invdetails.ElimAmt;
           System.Debug('elim inv'+invdetails);
         }
         else 
           invdetails.ElimQty = invdetails.ElimAmt= 0;
           
         

       if(!ar_excinv.isEmpty() && ar_excinv.size() > 0) {
        invdetails.ExcQty = (Decimal)ar_excinv[0].get('ExcQty');
         invdetails.ExcQty =  invdetails.ExcQty==null?0: invdetails.ExcQty;
         invdetails.ExcAmt = (Decimal)ar_excinv[0].get('ExcAmt');
         invdetails.ExcAmt = invdetails.ExcAmt==null ? 0:invdetails.ExcAmt;
           System.Debug('exc inv'+invdetails);
       }
         else
         invdetails.ExcQty = invdetails.ExcAmt = 0;
         
             
        }catch(Exception e) {
           System.Debug('encountered exception '+e.getMessage()+' \n'+e.getStackTraceString()); 
        }     
        return invDetails;   
    }
    
}