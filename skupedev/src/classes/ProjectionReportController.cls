public class ProjectionReportController{

    public class ReportDataWrapper{
        @AuraEnabled
        public String category;
        @AuraEnabled
        public String projtype;
        @AuraEnabled
        public Date projdate;
        @AuraEnabled
        public String skuid;
        @AuraEnabled
        public String dishcaregroup;
        
        public ReportDataWrapper(String category,String projtype,Date projdate,String skuid,String dishcaregroup){
            this.category = category;
            this.projtype = projtype;
            this.projdate = projdate;
            this.skuid = skuid;
            this.dishcaregroup = dishcaregroup;
        }
    }

    /*
    public class BaseDataWrapper{
        @AuraEnabled
        public String category;
        @AuraEnabled
        public Integer rowcount;
        
        public BaseDataWrapper(String category,Integer rowCount){
            this.category = category;
            this.rowCount = rowCount;
        }
    }*/
    
    /*
    private static String[] getCategories(String catString){
        String[] cats = new String[]{};
        if(catString.indexOf('aircare')>-1){
            cats.add('Air Care');
        }
        if(catString.indexOf('dishcare')>-1){
            cats.add('Dish Care');
        }
        if(catString.indexOf('surfacecare')>-1){
            cats.add('Surface Care');
        }
        return cats;
    } */

    @AuraEnabled
    public static Date GetMaxDate(){
        return Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
    }

    @AuraEnabled
    public static SKU__c[] GetBaseData(Date maxDate){
       /* BaseDataWrapper[] wrapper = new BaseDataWrapper[]{};
        for(aggregateResult ar : [Select Category__c,count(id) rowcount from SKU__c where Status__c='Active & Planned' group by Category__c]){
            wrapper.add(new BaseDataWrapper(String.valueOf(ar.get('Category__c')),Integer.valueOf(ar.get('rowcount'))));
        }
        return wrapper;*/
        //return [Select Category__c,Dish_Care_Group__c from SKU__c where Status__c='Active & Planned'];
        maxDate = Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
        return [Select Category__c,Status__c,Dish_Care_Group__c from SKU__c where Status__c in ('Active & Planned','Remnant & Historical') and Max_Actual_Date__c=:maxdate];
    }

    /*
    private static String getMonthString(String inp){
        DateTime dt = DateTime.valueOf(inp);
        return dt.format('MMMMM-YYYY');
    }*/

    @AuraEnabled
    public static ReportDataWrapper[] GetReportData(Date maxDate){
        
        ReportDataWrapper[] wrapperList = new ReportDataWrapper[]{};
        //cDate maxDate = Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
        maxDate = Date.valueOf([Select MAX(Date__c) maxdate from SKU_Actual__c][0].get('maxdate'));
        Date ayearfromnow = Date.newInstance(maxDate.year(),maxDate.month()+13,1);

        // Getting all New SKU projections
        for(SKU_Projection__c newsku: [Select Id,Projected_Date__c,SKU__r.Category__c,SKU__r.SKU_Type__c,Group__c from SKU_Projection__c where  Projected_Date__c > = :maxDate and Projected_Date__c < :ayearfromnow and Projection_Type__c='New' and RecordType.Name='G-11' and Include_in_Projections__c=true and SKU__r.Status__c='Projected']){
            if(newsku.SKU__r.SKU_Type__c=='MSO'){
                wrapperList.add(new ReportDataWrapper(newsku.SKU__r.Category__c,'Customized New SKU',newsku.Projected_Date__c,newsku.id,newsku.Group__c));
            }else{
                wrapperList.add(new ReportDataWrapper(newsku.SKU__r.Category__c,'Non-Customized New SKU',newsku.Projected_Date__c,newsku.id,newsku.Group__c));
            }
        }

        //Getting all manual new sku projections
        for(SKU_Projection__c newsku: [Select Id,Projected_Date__c,Projection_Type__c,Category__c,Group__c from SKU_Projection__c where  Projected_Date__c > = :maxDate and Projected_Date__c < :ayearfromnow and Projection_Type__c in ('Non-customized New SKU','Customized New SKU') and RecordType.Name='Manual' and Include_in_Projections__c=true and SKU__r.Status__c='Projected']){
            wrapperList.add(new ReportDataWrapper(newsku.Category__c,newsku.Projection_Type__c,newsku.Projected_Date__c,newsku.id,newsku.Group__c));
        }

        
        // Getting all Disco Projections
        for(SKU_Projection__c disco: [Select Id,Projected_Date__c,SKU__r.Category__c,SKU__r.SKU_Type__c,Group__c from SKU_Projection__c where  Projected_Date__c > = :maxDate and Projected_Date__c < :ayearfromnow and SKU__r.Status__c in ('Projected','Active & Planned') and Include_in_Projections__c=true and Projection_Type__c='Disco' and RecordType.Name='G-11']){
            if(disco.SKU__r.SKU_Type__c=='MSO'){
                wrapperList.add(new ReportDataWrapper(disco.SKU__r.Category__c,'Customized Disco',disco.Projected_Date__c,disco.id,disco.Group__c));
            }else{
                wrapperList.add(new ReportDataWrapper(disco.SKU__r.Category__c,'Non-Customized Disco',disco.Projected_Date__c,disco.id,disco.Group__c));
            }
        }


        //Getting all manual disco projections
        for(SKU_Projection__c disco: [Select Id,Projected_Date__c,Projection_Type__c,Category__c,SKU_Type__c,Group__c from SKU_Projection__c where  Projected_Date__c > = :maxDate and Projected_Date__c < :ayearfromnow and Projection_Type__c in ('Non-customized Disco','Customized Disco') and RecordType.Name='Manual' and Include_in_Projections__c=true and SKU__r.Status__c in ('Projected','Active & Planned')]){
            wrapperList.add(new ReportDataWrapper(disco.Category__c,disco.Projection_Type__c,disco.Projected_Date__c,disco.id,disco.Group__c));
        }

       return wrapperList;
      //return new ReportDataWrapper[]{};
    }
}