@isTest
public class TestProjectionReportController {

    @testsetup
    static void setupData(){
        System.debug('>>> In test setup');
        Id orgId = [Select id from Organization].Id;
        Date actualDate = Date.newInstance(2017,5,31);
        Date projUpdateDate = null;
        Date invUpdateDate = null;
        Date uploadDate = null;
        
        
        DataFactory.createLatestDates(orgID, actualDate, projUpdateDate,invUpdateDate);

        Test.startTest();
        List<Brand_Actual_staging__c> actuals = Test.loadData(Brand_Actual_staging__c.SobjectType,'actual_small');
        List<Brand_Projection_staging__c> projections = Test.loadData(Brand_Projection_staging__c.SobjectType,'projection_small');

        Brand_Actual_staging__c actualClone1 = actuals[0].clone();
        actualClone1.Sku_Code_Source__c='pseudosku1';
        actualClone1.Brand_Code_Source__c='pseudobrand1';
        actualClone1.Date__c=Date.newInstance(2016,1,1);

        
        
        insert actualClone1;

        Brand__c newBrand = [Select Missing_from_Latest_Actuals__c from Brand__c where Brand_COde__c='83513557'];
        newBrand.Missing_from_Latest_Actuals__c=true;
        update newBrand;


        Brand_Projection_staging__c projClone = projections[0].clone();
        projClone.Brand_Code__c='testbrandcode';
        projClone.SKU_Code__c ='testnewsku';
        projClone.Type__c='GBU New SKUs';
        insert projClone;

        Test.stopTest();



        system.assert(actuals.size()>100);
        system.debug('>>>> size '+actuals.size());
        System.debug('>>>> size of brand actuals with no actual date '+[Select count() from brand_actual__c where date__c=null]);
        System.debug('>>>> size of brands with no max actual date '+[Select count() from brand__c where max_actual_date__c=null]);
        System.debug('>>>> size of brands that are missing '+[Select count() from brand__c where ismissing__c=true]);
       

        
        system.assert(projections.size()>100);
        system.debug('>>>> size '+projections.size());

    }

    static testmethod void blankTest(){
        system.debug('>>> testing '+[Select Id from Brand_Actual_staging__c].size());
        system.debug('>>> testing '+[Select Id from Brand_Projection_staging__c].size());
        delete [Select Id from brand_actual_staging__c where Sku_Code_Source__c=null];

        Test.startTest();
        Database.executeBatch(new BatchBrandActualStaging(Enums.GBU.HOME_CARE),2000);
        Database.executeBatch(new BatchBrandProjectionStaging(Enums.GBU.HOME_CARE),2000);

        

        Test.stopTest();
        Date maxDate = ProjectionReportController.GetMaxDate();
        ProjectionReportController.GetBaseData(maxDate);
        ProjectionReportController.GetReportData(maxDate);
        
        
        
        System.debug('>>>> size of brand actuals with no actual date '+[Select count() from brand_actual__c where date__c=null]);
        System.debug('>>>> size of brands with no max actual date '+[Select count() from brand__c where max_actual_date__c=null]);
        System.debug('>>>> size of brands that are missing '+[Select count() from brand__c where ismissing__c=true]);

    }

    public static testmethod void testManualProjection(){

        insert new SKU__c(Name='Manual Projection Default Parent SKU',SKU__c='Manual Projection Default Parent SKU',Status__c='Projected',GBU__c='Home Care');
        Id manualProjId = Schema.SObjectType.SKU_Projection__c.getRecordTypeInfosByName().get('Manual').getRecordTypeId();
        SKU_PRojection__c manualprojection =  new SKU_PRojection__c(Brand_Code__c='test',Brand_Name__c='All Air Care',Date_of_Projection__c=System.today(),Include_in_Projections_Manual__c=true,Manual_Projected_Date__c=System.today()+5,Source__c='Manual',SKU_Text__c='testsku',RecordTypeID=manualProjId,Projection_Type__c='Non-customized New SKU',Description__c='Test Manual');
        insert manualprojection;
        manualprojection.SKU_Text__c = '37000706007';
        update manualprojection;


    }

}