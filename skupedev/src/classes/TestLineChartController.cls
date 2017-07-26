/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestLineChartController {
	
	@testSetup 
	static void setup() {
        // Create common test accounts
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
        dtTemp = system.today().addMonths(-2);
		month = dtTemp.month();
		Year = dtTemp.Year();
		stDate =  Date.newInstance(Year, month, 1);
			
        SKU__c sku = new SKU__c();
        sku.Name = '10037000061745';
        sku.SKU__c = '10037000061745';
        sku.Category__c = 'Surface Care';
        sku.Status__c = 'Active & Planned';
        sku.SKU_Type__c = 'GBU';
        sku.Dish_Care_Group__c = 'Swiffer';
        sku.GBU__c = 'Home Care';
        insert sku;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = 'Manual Projection Default Parent SKU';
        sku1.SKU__c = '10037000061746';
        sku1.Category__c = 'Surface Care';
        sku1.Status__c = 'Active & Planned';
        sku1.SKU_Type__c = 'GBU';
        sku1.Dish_Care_Group__c = 'Swiffer';
        sku1.GBU__c = 'Home Care';
        insert sku1;
        
        SKU__c skuProj = new SKU__c();
        skuProj.Name = 'Manual Projection Default Parent SKU';
        skuProj.SKU__c = '10037000061747';
        skuProj.Category__c = 'Surface Care';
        skuProj.Status__c = 'Active & Planned';	//'Projected';
        skuProj.SKU_Type__c = 'GBU';
        skuProj.Dish_Care_Group__c = 'Swiffer';
        skuProj.GBU__c = 'Home Care';
        insert skuProj;
        
        
        Brand__c brand = new Brand__c();
        brand.Name = '80285853';
        brand.Brand_Description__c = 'SWFR S&V Repl Filter 12/2 ct';
        brand.Brand_Code__c = '80285853';
        brand.SKU__c = sku.Id;
        brand.Status__c = 'Active & Planned';
        brand.EOH_Inventory__c = 24333.27;
        
        insert brand;
        
        SKU_Actual__c skua = new SKU_Actual__c();
        skua.Name = '';
        skua.SKU__c = sku.Id;
        skua.Date__c = stDate;
        skua.Actual_Status__c = 'Active & Planned';
        skua.SKU_Category__c = 'Surface Care';
        
        insert skua;
        
        Brand_Actual__c bact = new Brand_Actual__c();
        bact.Name = '';
        bact.Status__c = 'Active & Planned';
        bact.EOH_Inventory__c = 19942.21;
        bact.SKU_Actual__c = skua.Id;
        bact.Date__c = stDate;
        bact.Brand__c = brand.ID;
        insert bact;
        
        SKU_Projection__c skup = new SKU_Projection__c();
        skup.SKU__c = skuProj.Id;
        skup.Name = '10037000061745-2017-03-31 00:00:00-Disco';
        skup.Source__c = 'Manual';
        skup.Projection_Type__c = 'New';
        skup.Description__c = 'Test';
        skup.Brand_Name__c = 'Swiffer';
        //skup.Include_in_Projections__c = true;
        Test.startTest();
        insert skup;
        Test.stopTest();
        
        Brand_Projection__c brandp = new Brand_Projection__c();
        brandp.Name = 'GBU Discos-80285853';
        brandp.Brand__c = brand.Id;
        brandp.Date_of_Creation__c = stDate;
        brandp.Date_of_Projection__c = stDate;
        brandp.Projection_Type__c = 'GBU Discos';
        brandp.SKU_Projection__c = skup.Id;
        insert brandp;    
        
        list<SKU_Projection__c> lstProjections = [select Id,Projected_Date__c from SKU_Projection__c where Id=:skup.Id];
        system.debug('lstProjections===='+lstProjections);
    }
    
    @testSetup 
	static void setupRH() {
        // Create common test accounts
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
        dtTemp = system.today().addMonths(-2);
		month = dtTemp.month();
		Year = dtTemp.Year();
		stDate =  Date.newInstance(Year, month, 1);
			
        SKU__c sku = new SKU__c();
        sku.Name = '10037000061735';
        sku.SKU__c = '10037000061735';
        sku.Category__c = 'Surface Care';
        sku.Status__c = 'Remnant & Historical';
        sku.SKU_Type__c = 'GBU';
        sku.Dish_Care_Group__c = 'Swiffer';
        sku.GBU__c = 'Home Care';
        insert sku;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = 'Manual Projection Default Parent SKU';
        sku1.SKU__c = '10037000061736';
        sku1.Category__c = 'Surface Care';
        sku1.Status__c = 'Remnant & Historical';
        sku1.SKU_Type__c = 'GBU';
        sku1.Dish_Care_Group__c = 'Swiffer';
        sku1.GBU__c = 'Home Care';
        insert sku1;
        
        SKU__c skuProj = new SKU__c();
        skuProj.Name = 'Manual Projection Default Parent SKU';
        skuProj.SKU__c = '10037000061737';
        skuProj.Category__c = 'Surface Care';
        skuProj.Status__c = 'Remnant & Historical';	//'Projected';
        skuProj.SKU_Type__c = 'GBU';
        skuProj.Dish_Care_Group__c = 'Swiffer';
        skuProj.GBU__c = 'Home Care';
        insert skuProj;
        
        
        Brand__c brand = new Brand__c();
        brand.Name = '80285853';
        brand.Brand_Description__c = 'SWFR S&V Repl Filter 12/2 ct';
        brand.Brand_Code__c = '80285852';
        brand.SKU__c = sku.Id;
        brand.Status__c = 'Remnant & Historical';
        brand.EOH_Inventory__c = 24333.27;
        
        insert brand;
        
        SKU_Actual__c skua = new SKU_Actual__c();
        skua.Name = '';
        skua.SKU__c = sku.Id;
        skua.Date__c = stDate;
        skua.Actual_Status__c = 'Remnant & Historical';
        skua.SKU_Category__c = 'Surface Care';
        
        insert skua;
        
        Brand_Actual__c bact = new Brand_Actual__c();
        bact.Name = '';
        bact.Status__c = 'Remnant & Historical';
        bact.EOH_Inventory__c = 19942.21;
        bact.SKU_Actual__c = skua.Id;
        bact.Date__c = stDate;
        bact.Brand__c = brand.ID;
        insert bact;
        
        SKU_Projection__c skup = new SKU_Projection__c();
        skup.SKU__c = skuProj.Id;
        skup.Name = '10037000061745-2017-03-31 00:00:00-Disco11';
        skup.Source__c = 'Manual';
        skup.Projection_Type__c = 'New';
        skup.Description__c = 'Test11';
        skup.Brand_Name__c = 'Swiffer';
        //skup.Include_in_Projections__c = true;
        Test.startTest();
        insert skup;
        Test.stopTest();
        
        Brand_Projection__c brandp = new Brand_Projection__c();
        brandp.Name = 'GBU Discos-80285852';
        brandp.Brand__c = brand.Id;
        brandp.Date_of_Creation__c = stDate;
        brandp.Date_of_Projection__c = stDate;
        brandp.Projection_Type__c = 'GBU Discos';
        brandp.SKU_Projection__c = skup.Id;
        insert brandp;     
    }
    
    @testSetup 
	static void setup1() {
        // Create common test accounts
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
        dtTemp = system.today().addMonths(-2);
		month = dtTemp.month();
		Year = dtTemp.Year();
		stDate =  Date.newInstance(Year, month, 1);
			
        SKU__c sku = new SKU__c();
        sku.Name = '10037000061741';
        sku.SKU__c = '10037000061741';
        sku.Category__c = 'Air Care';
        sku.Status__c = 'Active & Planned';
        sku.SKU_Type__c = 'GBU';
        sku.Dish_Care_Group__c = 'All Air Care';
        sku.GBU__c = 'Home Care';
        insert sku;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = 'Manual Projection Default Parent SKU';
        sku1.SKU__c = '10037000061742';
        sku1.Category__c = 'Air Care';
        sku1.Status__c = 'Active & Planned';
        sku1.SKU_Type__c = 'GBU';
        sku1.Dish_Care_Group__c = 'All Air Care';
        sku1.GBU__c = 'Home Care';
        insert sku1;
        
        SKU__c skuProj = new SKU__c();
        skuProj.Name = 'Manual Projection Default Parent SKU';
        skuProj.SKU__c = '10037000061743';
        skuProj.Category__c = 'Air Care';
        skuProj.Status__c = 'Active & Planned';	//'Projected';
        skuProj.SKU_Type__c = 'GBU';
        skuProj.Dish_Care_Group__c = 'All Air Care';
        skuProj.GBU__c = 'Home Care';
        insert skuProj;
        
        
        Brand__c brand = new Brand__c();
        brand.Name = '80285854';
        brand.Brand_Description__c = 'SWFR S&V Repl Filter 12/2 ct';
        brand.Brand_Code__c = '80285854';
        brand.SKU__c = sku.Id;
        brand.Status__c = 'Active & Planned';
        brand.EOH_Inventory__c = 24333.27;
        
        insert brand;
        
        SKU_Actual__c skua = new SKU_Actual__c();
        skua.Name = '';
        skua.SKU__c = sku.Id;
        skua.Date__c = stDate;
        skua.Actual_Status__c = 'Active & Planned';
        skua.SKU_Category__c = 'Air Care';
        
        insert skua;
        
        Brand_Actual__c bact = new Brand_Actual__c();
        bact.Name = '';
        bact.Status__c = 'Active & Planned';
        bact.EOH_Inventory__c = 19942.21;
        bact.SKU_Actual__c = skua.Id;
        bact.Date__c = stDate;
        bact.Brand__c = brand.ID;
        insert bact;
        
        SKU_Projection__c skup = new SKU_Projection__c();
        skup.SKU__c = skuProj.Id;
        skup.Name = '10037000061745-2017-03-31 00:00:00-Disco1';
        skup.Source__c = 'Manual';
        skup.Projection_Type__c = 'New';
        skup.Description__c = 'Test1';
        skup.Brand_Name__c = 'All Air Care';
        //skup.Include_in_Projections__c = true;
        Test.startTest();
        insert skup;
        Test.stopTest();
        
        Brand_Projection__c brandp = new Brand_Projection__c();
        brandp.Name = 'GBU Discos-80285854';
        brandp.Brand__c = brand.Id;
        brandp.Date_of_Creation__c = stDate;
        brandp.Date_of_Projection__c = stDate;
        brandp.Projection_Type__c = 'GBU Discos';
        brandp.SKU_Projection__c = skup.Id;
        insert brandp;     
    }
    
    @testSetup 
	static void setup1RH() {
        // Create common test accounts
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
        dtTemp = system.today().addMonths(-2);
		month = dtTemp.month();
		Year = dtTemp.Year();
		stDate =  Date.newInstance(Year, month, 1);
			
        SKU__c sku = new SKU__c();
        sku.Name = '10037000061711';
        sku.SKU__c = '10037000061711';
        sku.Category__c = 'Air Care';
        sku.Status__c = 'Remnant & Historical';
        sku.SKU_Type__c = 'GBU';
        sku.Dish_Care_Group__c = 'All Air Care';
        sku.GBU__c = 'Home Care';
        insert sku;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = 'Manual Projection Default Parent SKU';
        sku1.SKU__c = '10037000061712';
        sku1.Category__c = 'Air Care';
        sku1.Status__c = 'Remnant & Historical';
        sku1.SKU_Type__c = 'GBU';
        sku1.Dish_Care_Group__c = 'All Air Care';
        sku1.GBU__c = 'Home Care';
        insert sku1;
        
        SKU__c skuProj = new SKU__c();
        skuProj.Name = 'Manual Projection Default Parent SKU';
        skuProj.SKU__c = '10037000061713';
        skuProj.Category__c = 'Air Care';
        skuProj.Status__c = 'Remnant & Historical';	//'Projected';
        skuProj.SKU_Type__c = 'GBU';
        skuProj.Dish_Care_Group__c = 'All Air Care';
        skuProj.GBU__c = 'Home Care';
        insert skuProj;
        
        
        Brand__c brand = new Brand__c();
        brand.Name = '80285814';
        brand.Brand_Description__c = 'SWFR S&V Repl Filter 12/2 ct';
        brand.Brand_Code__c = '80285814';
        brand.SKU__c = sku.Id;
        brand.Status__c = 'Remnant & Historical';
        brand.EOH_Inventory__c = 24333.27;
        
        insert brand;
        
        SKU_Actual__c skua = new SKU_Actual__c();
        skua.Name = '';
        skua.SKU__c = sku.Id;
        skua.Date__c = stDate;
        skua.Actual_Status__c = 'Remnant & Historical';
        skua.SKU_Category__c = 'Air Care';
        
        insert skua;
        
        Brand_Actual__c bact = new Brand_Actual__c();
        bact.Name = '';
        bact.Status__c = 'Remnant & Historical';
        bact.EOH_Inventory__c = 19942.21;
        bact.SKU_Actual__c = skua.Id;
        bact.Date__c = stDate;
        bact.Brand__c = brand.ID;
        insert bact;
        
        SKU_Projection__c skup = new SKU_Projection__c();
        skup.SKU__c = skuProj.Id;
        skup.Name = '10037000061745-2017-03-31 00:00:00-Disco111';
        skup.Source__c = 'Manual';
        skup.Projection_Type__c = 'New';
        skup.Description__c = 'Test111';
        skup.Brand_Name__c = 'All Air Care';
        //skup.Include_in_Projections__c = true;
        Test.startTest();
        insert skup;
        Test.stopTest();
        
        Brand_Projection__c brandp = new Brand_Projection__c();
        brandp.Name = 'GBU Discos-80285824';
        brandp.Brand__c = brand.Id;
        brandp.Date_of_Creation__c = stDate;
        brandp.Date_of_Projection__c = stDate;
        brandp.Projection_Type__c = 'GBU Discos';
        brandp.SKU_Projection__c = skup.Id;
        insert brandp;     
    }
    
    @testSetup 
	static void setup2() {
        // Create common test accounts
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
        dtTemp = system.today().addMonths(-2);
		month = dtTemp.month();
		Year = dtTemp.Year();
		stDate =  Date.newInstance(Year, month, 1);
			
        SKU__c sku = new SKU__c();
        sku.Name = '10037000061744';
        sku.SKU__c = '10037000061744';
        sku.Category__c = 'Dish Care';
        sku.Status__c = 'Active & Planned';
        sku.SKU_Type__c = 'GBU';
        sku.Dish_Care_Group__c = 'ADW';
        sku.GBU__c = 'Home Care';
        insert sku;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = 'Manual Projection Default Parent SKU';
        sku1.SKU__c = '10037000061748';
        sku1.Category__c = 'Dish Care';
        sku1.Status__c = 'Active & Planned';
        sku1.SKU_Type__c = 'GBU';
        sku1.Dish_Care_Group__c = 'ADW';
        sku1.GBU__c = 'Home Care';
        insert sku1;
        
        SKU__c skuProj = new SKU__c();
        skuProj.Name = 'Manual Projection Default Parent SKU';
        skuProj.SKU__c = '10037000061749';
        skuProj.Category__c = 'Dish Care';
        skuProj.Status__c = 'Active & Planned';	//'Projected';
        skuProj.SKU_Type__c = 'GBU';
        skuProj.Dish_Care_Group__c = 'ADW';
        skuProj.GBU__c = 'Home Care';
        insert skuProj;
        
        
        Brand__c brand = new Brand__c();
        brand.Name = '80285855';
        brand.Brand_Description__c = 'SWFR S&V Repl Filter 12/2 ct';
        brand.Brand_Code__c = '80285855';
        brand.SKU__c = sku.Id;
        brand.Status__c = 'Active & Planned';
        brand.EOH_Inventory__c = 24333.27;
        
        insert brand;
        
        SKU_Actual__c skua = new SKU_Actual__c();
        skua.Name = '';
        skua.SKU__c = sku.Id;
        skua.Date__c = stDate;
        skua.Actual_Status__c = 'Active & Planned';
        skua.SKU_Category__c = 'Dish Care';
        
        insert skua;
        
        Brand_Actual__c bact = new Brand_Actual__c();
        bact.Name = '';
        bact.Status__c = 'Active & Planned';
        bact.EOH_Inventory__c = 19942.21;
        bact.SKU_Actual__c = skua.Id;
        bact.Date__c = stDate;
        bact.Brand__c = brand.ID;
        insert bact;
        
        SKU_Projection__c skup = new SKU_Projection__c();
        skup.SKU__c = skuProj.Id;
        skup.Name = '10037000061745-2017-03-31 00:00:00-Disco5';
        skup.Source__c = 'Manual';
        skup.Projection_Type__c = 'New';
        skup.Description__c = 'Test5';
        skup.Brand_Name__c = 'ADW';
        //skup.Include_in_Projections__c = true;
        Test.startTest();
        insert skup;
        Test.stopTest();
        
        Brand_Projection__c brandp = new Brand_Projection__c();
        brandp.Name = 'GBU Discos-80285855';
        brandp.Brand__c = brand.Id;
        brandp.Date_of_Creation__c = stDate;
        brandp.Date_of_Projection__c = stDate;
        brandp.Projection_Type__c = 'GBU Discos';
        brandp.SKU_Projection__c = skup.Id;
        insert brandp;     
    }
    
    @testSetup 
	static void setup2RH() {
        // Create common test accounts
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
        dtTemp = system.today().addMonths(-2);
		month = dtTemp.month();
		Year = dtTemp.Year();
		stDate =  Date.newInstance(Year, month, 1);
			
        SKU__c sku = new SKU__c();
        sku.Name = '10037000061724';
        sku.SKU__c = '10037000061724';
        sku.Category__c = 'Dish Care';
        sku.Status__c = 'Remnant & Historical';
        sku.SKU_Type__c = 'GBU';
        sku.Dish_Care_Group__c = 'ADW';
        sku.GBU__c = 'Home Care';
        insert sku;
        
        SKU__c sku1 = new SKU__c();
        sku1.Name = 'Manual Projection Default Parent SKU';
        sku1.SKU__c = '10037000061728';
        sku1.Category__c = 'Dish Care';
        sku1.Status__c = 'Remnant & Historical';
        sku1.SKU_Type__c = 'GBU';
        sku1.Dish_Care_Group__c = 'ADW';
        sku1.GBU__c = 'Home Care';
        insert sku1;
        
        SKU__c skuProj = new SKU__c();
        skuProj.Name = 'Manual Projection Default Parent SKU';
        skuProj.SKU__c = '10037000061729';
        skuProj.Category__c = 'Dish Care';
        skuProj.Status__c = 'Remnant & Historical';	//'Projected';
        skuProj.SKU_Type__c = 'GBU';
        skuProj.Dish_Care_Group__c = 'ADW';
        skuProj.GBU__c = 'Home Care';
        insert skuProj;
        
        
        Brand__c brand = new Brand__c();
        brand.Name = '80285825';
        brand.Brand_Description__c = 'SWFR S&V Repl Filter 12/2 ct';
        brand.Brand_Code__c = '80285825';
        brand.SKU__c = sku.Id;
        brand.Status__c = 'Remnant & Historical';
        brand.EOH_Inventory__c = 24333.27;
        
        insert brand;
        
        SKU_Actual__c skua = new SKU_Actual__c();
        skua.Name = '';
        skua.SKU__c = sku.Id;
        skua.Date__c = stDate;
        skua.Actual_Status__c = 'Remnant & Historical';
        skua.SKU_Category__c = 'Dish Care';
        
        insert skua;
        
        Brand_Actual__c bact = new Brand_Actual__c();
        bact.Name = '';
        bact.Status__c = 'Remnant & Historical';
        bact.EOH_Inventory__c = 19942.21;
        bact.SKU_Actual__c = skua.Id;
        bact.Date__c = stDate;
        bact.Brand__c = brand.ID;
        insert bact;
        
        RecordType rt = [select id,Name from RecordType where SobjectType='SKU_Projection__c' and Name='G-11' Limit 1];
        
        SKU_Projection__c skup = new SKU_Projection__c();
        skup.SKU__c = skuProj.Id;
        skup.Name = '10037000061745-2017-03-31 00:00:00-Disco25';
        skup.Source__c = 'Manual';
        skup.Projection_Type__c = 'New';
        skup.Description__c = 'Test25';
        skup.Brand_Name__c = 'ADW';
        skup.Manual_Projected_Date__c = stDate;
        skup.RecordType = rt;
        Test.startTest();
        insert skup;
        Test.stopTest();
        
        Brand_Projection__c brandp = new Brand_Projection__c();
        brandp.Name = 'GBU Discos-80285825';
        brandp.Brand__c = brand.Id;
        brandp.Date_of_Creation__c = stDate;
        brandp.Date_of_Projection__c = stDate;
        brandp.Projection_Type__c = 'GBU Discos';
        brandp.SKU_Projection__c = skup.Id;
        insert brandp;     
    }
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
                
        
        String[] selCat = new String[]{};
        String[] selLCycle = new String[]{};
        string[] selBrand = new String[]{};
        string[] strType1 = new String[]{};
        date startDT;
        date endDt;
        String sDate;
        String eDate;
        
        selCat.add('Aircare');
		selCat.add('Dishcare');
		selCat.add('Surfacecare');
		
		selLCycle.add('AP');
		selLCycle.add('RH');
			
		selBrand.add('AllAirCare');
		selBrand.add('ADW');
		selBrand.add('HDW');
		selBrand.add('MrClean');
		selBrand.add('Swiffer');
		
		strType1.add('Customized');
		strType1.add('Non-customized');
		
		
		//Start date today - 12 months
		dtTemp = system.today().addMonths(-12);
		month = dtTemp.month();
		Year = dtTemp.Year();
		sDate =  String.valueOf(Date.newInstance(Year, month, 1)); //1st of month
		//End date today - last month
		dtTemp = system.today().addMonths(-1);
		month = dtTemp.month();
		Year = dtTemp.Year();
		eDate = String.valueOf(Date.newInstance(Year, month, 31)); //31 st of last month
		
        map<string,LineChartController1.dataHeaderWrapper> mapDHWrap = LineChartController1.loadData1(selCat, selLCycle, selBrand, startDT, endDt, sDate, eDate,strType1
        																,'Home Care');
		
		mapDHWrap = LineChartController1.loadTableData(selCat, selLCycle, selBrand, startDT, endDt, sDate, eDate,strType1
        																,'Home Care');
        
        //Aircare ===#===#Jul-2016 ===#RH ===#AllAirCare,ADW,HDW,MrClean,Swiffer ===#R &amp; H
        
        String cat = 'Aircare';
        String strgroup = '';
        String mon = 'Jul-2016';
        String status = 'RH';
        //String[] selBrand1 = new String[]{};
        String strType = 'R &amp; H';
        List<Brand__c> fetchSKUData  = LineChartController1.fetchSKUData1(cat, strgroup, mon, status, selBrand, strType);
        
        cat = 'Aircare';
        strgroup = 'SKU_Projection__c';
        mon = 'Jul-2016';
        status = 'RH';
        //String[] selBrand1 = new String[]{};
        strType = 'R &amp; H';
        List<Brand__c> fetchSKUData1  = LineChartController1.fetchSKUData1(cat, strgroup, mon, status, selBrand, strType);
        
        cat = 'Surfacecare';
        strgroup = '';
        mon = 'Jul-2016';
        status = 'RH';
        //String[] selBrand1 = new String[]{};
        strType = 'R &amp; H';
        fetchSKUData  = LineChartController1.fetchSKUData1(cat, strgroup, mon, status, selBrand, strType);
        
        cat = 'Surfacecare';
        strgroup = 'SKU_Projection__c';
        mon = 'Jul-2016';
        status = 'RH';
        //String[] selBrand1 = new String[]{};
        strType = 'R &amp; H';
        fetchSKUData1  = LineChartController1.fetchSKUData1(cat, strgroup, mon, status, selBrand, strType);
        
        cat = 'Dishcare';
        strgroup = '';
        mon = 'Jul-2016';
        status = 'AP';
        //String[] selBrand1 = new String[]{};
        strType = 'A &amp; P';
        fetchSKUData  = LineChartController1.fetchSKUData1(cat, strgroup, mon, status, selBrand, strType);
        
        cat = 'Dishcare';
        strgroup = 'SKU_Projection__c';
        mon = 'Jul-2016';
        status = 'AP';
        //String[] selBrand1 = new String[]{};
        strType = 'A &amp; P';
        fetchSKUData1  = LineChartController1.fetchSKUData1(cat, strgroup, mon, status, selBrand, strType);
        
        
     }
     
     static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
                
        
        String[] selCat = new String[]{};
        String[] selLCycle = new String[]{};
        string[] selBrand = new String[]{};
        date startDT;
        date endDt;
        String sDate;
        String eDate;
        
        selCat.add('Aircare');
		selCat.add('Dishcare');
		selCat.add('Surfacecare');
		
		selLCycle.add('AP');
		selLCycle.add('RH');
			
		selBrand.add('AllAirCare');
		selBrand.add('ADW');
		selBrand.add('HDW');
		selBrand.add('MrClean');
		selBrand.add('Swiffer');
		
		
		//Start date today - 12 months
		dtTemp = system.today().addMonths(-12);
		month = dtTemp.month();
		Year = dtTemp.Year();
		sDate =  String.valueOf(Date.newInstance(Year, month, 1)); //1st of month
		//End date today - last month
		dtTemp = system.today().addMonths(-1);
		month = dtTemp.month();
		Year = dtTemp.Year();
		eDate = String.valueOf(Date.newInstance(Year, month, 31)); //31 st of last month
		
		set<string> selectedCate = new set<string>();
		set<string> selectedLC = new set<string>();
		set<String> selectedBrand = new set<String>();
		
		selectedCate.add('Air Care');	
		selectedCate.add('Dish Care');
		selectedCate.add('Surface Care');
		
		selectedLC.add('Active & Planned');	
		selectedLC.add('Remnant & Historical');
		
		selectedBrand.add('All Air Care');
		selectedBrand.add('ADW');
		selectedBrand.add('HDW');
		selectedBrand.add('Mr Clean');
		selectedBrand.add('Swiffer');
		
		set<string> strType1 = new set<String>();
		strType1.add('Customized');
		strType1.add('Non-customized');
		
		string[] strType11 = new String[]{};
		strType11.add('Customized');
		strType11.add('Non-customized');
			
		map<string,decimal> grandTotalsFutureP = LineChartController1.grandTotalsFutureProjections(selectedCate, selectedLC, selectedBrand,null,null,'Projected',strType1
																		,'Home Care');
		
		map<string,decimal> grandTotalsActuals = LineChartController1.grandTotalsActuals(selectedCate, selectedLC, selectedBrand, null, null, strType1
																		,'Home Care');
		
		map<string,decimal> grandTotalsPastProjections = LineChartController1.grandTotalsPastProjections(selectedCate, selectedLC, null, null, strType1
																		,'Home Care');
		
        map<string,LineChartController1.dataHeaderWrapper> mapDHWrap = LineChartController1.loadData1(selCat, selLCycle, selBrand, null, null, sDate, eDate,strType11
        																					,'Home Care');
		
		mapDHWrap = LineChartController1.loadTableData(selCat, selLCycle, selBrand, null, null, sDate, eDate,strType11
        																					,'Home Care');
        
        
        
     }
     
     static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
                
        
        String[] selCat = new String[]{};
        String[] selLCycle = new String[]{};
        string[] selBrand = new String[]{};
        date startDT;
        date endDt;
        String sDate;
        String eDate;
        
        selCat.add('Aircare');
		selCat.add('Dishcare');
		selCat.add('Surfacecare');
		
		selLCycle.add('AP');
		selLCycle.add('RH');
			
		selBrand.add('AllAirCare');
		selBrand.add('ADW');
		selBrand.add('HDW');
		selBrand.add('MrClean');
		selBrand.add('Swiffer');
		
		
		//Start date today - 12 months
		dtTemp = system.today().addMonths(-12);
		month = dtTemp.month();
		Year = dtTemp.Year();
		sDate =  String.valueOf(Date.newInstance(Year, month, 1)); //1st of month
		//End date today - last month
		dtTemp = system.today().addMonths(-1);
		month = dtTemp.month();
		Year = dtTemp.Year();
		eDate = String.valueOf(Date.newInstance(Year, month, 31)); //31 st of last month
		
		set<string> selectedCate = new set<string>();
		set<string> selectedLC = new set<string>();
		set<String> selectedBrand = new set<String>();
		
		selectedCate.add('Air Care');	
		selectedCate.add('Dish Care');
		selectedCate.add('Surface Care');
		
		selectedLC.add('Active & Planned');	
		selectedLC.add('Remnant & Historical');
		
		selectedBrand.add('All Air Care');
		selectedBrand.add('ADW');
		selectedBrand.add('HDW');
		selectedBrand.add('Mr Clean');
		selectedBrand.add('Swiffer');
		
		set<string> strType1 = new set<String>();
		strType1.add('Customized');
		strType1.add('Non-customized');
				
		string[] strType11 = new String[]{};
		strType11.add('Customized');
		strType11.add('Non-customized');

		map<string,decimal> grandTotalsFutureP = LineChartController1.grandTotalsFutureProjections(selectedCate, selectedLC, selectedBrand,null,null,'Projected', strType1
																			,'Home Care');
		
		map<string,decimal> grandTotalsActuals = LineChartController1.grandTotalsActuals(selectedCate, selectedLC, selectedBrand, null, null, strType1
																			,'Home Care');
		
		map<string,decimal> grandTotalsPastProjections = LineChartController1.grandTotalsPastProjections(selectedCate, selectedLC, null, null, strType1
																			,'Home Care');
		
        map<string,LineChartController1.dataHeaderWrapper> mapDHWrap = LineChartController1.loadData1(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
        																	,'Home Care');
		
		
		mapDHWrap = LineChartController1.loadTableData(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
        																	,'Home Care');
        
     }
     
     static testMethod void myUnitTest3() {
        // TO DO: implement unit test
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
                
        
        String[] selCat = new String[]{};
        String[] selLCycle = new String[]{};
        string[] selBrand = new String[]{};
        date startDT;
        date endDt;
        String sDate;
        String eDate;
        
        selCat.add('Aircare');
		selCat.add('Dishcare');
		selCat.add('Surfacecare');
		
		selLCycle.add('AP');
		selLCycle.add('RH');
			
		selBrand.add('AllAirCare');
		selBrand.add('ADW');
		selBrand.add('HDW');
		selBrand.add('MrClean');
		selBrand.add('Swiffer');
		
		
		//Start date today - 12 months
		dtTemp = system.today().addMonths(-12);
		month = dtTemp.month();
		Year = dtTemp.Year();
		sDate =  String.valueOf(Date.newInstance(Year, month, 1)); //1st of month
		//End date today - last month
		dtTemp = system.today().addMonths(-1);
		month = dtTemp.month();
		Year = dtTemp.Year();
		eDate = String.valueOf(Date.newInstance(Year, month, 31)); //31 st of last month
		
		eDate = String.valueOf(system.today());
		
		set<string> selectedCate = new set<string>();
		set<string> selectedLC = new set<string>();
		set<String> selectedBrand = new set<String>();
		
		selectedCate.add('Air Care');	
		selectedCate.add('Dish Care');
		selectedCate.add('Surface Care');
		
		selectedLC.add('Active & Planned');	
		selectedLC.add('Remnant & Historical');
		
		selectedBrand.add('All Air Care');
		selectedBrand.add('ADW');
		selectedBrand.add('HDW');
		selectedBrand.add('Mr Clean');
		selectedBrand.add('Swiffer');
		
		set<string> strType1 = new set<String>();
		strType1.add('Customized');
		strType1.add('Non-customized');
				
		string[] strType11 = new String[]{};
		strType11.add('Customized');
		strType11.add('Non-customized');
		
        map<string,LineChartController1.dataHeaderWrapper> mapDHWrap = LineChartController1.loadData1(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
        																			,'Home Care');
        
        dtTemp = system.today().addMonths(+1);
		month = dtTemp.month();
		Year = dtTemp.Year();
		eDate = String.valueOf(Date.newInstance(Year, month, 31)); //31 st of last month
		
		map<string,LineChartController1.dataHeaderWrapper> mapDHWrap1 = LineChartController1.loadData1(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
																					,'Home Care');
		
		
		
		LineChartController1.exportToExcelSettings();
		LineChartController1.userSettings();
		
		selLCycle = new String[]{};
		selLCycle.add('AP');
		//selLCycle.add('RH');
		
		mapDHWrap = LineChartController1.loadData1(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
																		,'Home Care');
		
		
		selLCycle = new String[]{};
		//selLCycle.add('AP');
		selLCycle.add('RH');
		mapDHWrap = LineChartController1.loadData1(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11 ,'Home Care');
		
																		
		Test.startTest();
		dtTemp = system.today().addMonths(-12);
		month = dtTemp.month();
		Year = dtTemp.Year();
		sDate =  String.valueOf(Date.newInstance(Year, month, 1)); //1st of month
		//End date today - last month
		dtTemp = system.today().addMonths(-1);
		month = dtTemp.month();
		Year = dtTemp.Year();
		integer day = dtTemp.day();
		eDate = String.valueOf(Date.newInstance(Year, month, day)); //31 st of last month
		mapDHWrap = LineChartController1.loadData1(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
															,'Home Care');
		
		//eDate = String.valueOf(system.today());
		
		
		mapDHWrap = LineChartController1.loadData1(selCat, selLCycle, selBrand, null, null, null, null, strType11
															,'Home Care');
															
		
															
		//eDate = String.valueOf(system.today());
		Test.stopTest();
		
     }
     
     static testMethod void myUnitTest4() {
        // TO DO: implement unit test
        date stDate;
        date dtTemp;
		integer month;
		integer Year ;
                
        
        String[] selCat = new String[]{};
        String[] selLCycle = new String[]{};
        string[] selBrand = new String[]{};
        date startDT;
        date endDt;
        String sDate;
        String eDate;
        
        selCat.add('Aircare');
		selCat.add('Dishcare');
		selCat.add('Surfacecare');
		
		selLCycle.add('AP');
		selLCycle.add('RH');
			
		selBrand.add('AllAirCare');
		selBrand.add('ADW');
		selBrand.add('HDW');
		selBrand.add('MrClean');
		selBrand.add('Swiffer');
		
		
		//Start date today - 12 months
		dtTemp = system.today().addMonths(-12);
		month = dtTemp.month();
		Year = dtTemp.Year();
		sDate =  String.valueOf(Date.newInstance(Year, month, 1)); //1st of month
		//End date today - last month
		dtTemp = system.today().addMonths(-1);
		month = dtTemp.month();
		Year = dtTemp.Year();
		eDate = String.valueOf(Date.newInstance(Year, month, 31)); //31 st of last month
		
		eDate = String.valueOf(system.today());
		
		set<string> selectedCate = new set<string>();
		set<string> selectedLC = new set<string>();
		set<String> selectedBrand = new set<String>();
		
		selectedCate.add('Air Care');	
		selectedCate.add('Dish Care');
		selectedCate.add('Surface Care');
		
		selectedLC.add('Active & Planned');	
		selectedLC.add('Remnant & Historical');
		
		selectedBrand.add('All Air Care');
		selectedBrand.add('ADW');
		selectedBrand.add('HDW');
		selectedBrand.add('Mr Clean');
		selectedBrand.add('Swiffer');
		
		set<string> strType1 = new set<String>();
		strType1.add('Customized');
		strType1.add('Non-customized');
				
		string[] strType11 = new String[]{};
		strType11.add('Customized');
		strType11.add('Non-customized');
		
        
        map<string,LineChartController1.dataHeaderWrapper> mapDHWrap = LineChartController1.loadTableData(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
        																			,'Home Care');
        dtTemp = system.today().addMonths(+1);
		month = dtTemp.month();
		Year = dtTemp.Year();
		eDate = String.valueOf(Date.newInstance(Year, month, 31)); //31 st of last month
		
		
		map<string,LineChartController1.dataHeaderWrapper> mapDHWrap1 = LineChartController1.loadTableData(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
																					,'Home Care');
		
		LineChartController1.exportToExcelSettings();
		LineChartController1.userSettings();
		
		selLCycle = new String[]{};
		selLCycle.add('AP');
		//selLCycle.add('RH');
		
		mapDHWrap = LineChartController1.loadTableData(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11 ,'Home Care');
		
		selLCycle = new String[]{};
		//selLCycle.add('AP');
		selLCycle.add('RH');
		
		mapDHWrap = LineChartController1.loadTableData(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
																		,'Home Care');
																		
		Test.startTest();
		dtTemp = system.today().addMonths(-12);
		month = dtTemp.month();
		Year = dtTemp.Year();
		sDate =  String.valueOf(Date.newInstance(Year, month, 1)); //1st of month
		//End date today - last month
		dtTemp = system.today().addMonths(-1);
		month = dtTemp.month();
		Year = dtTemp.Year();
		integer day = dtTemp.day();
		eDate = String.valueOf(Date.newInstance(Year, month, day)); //31 st of last month
		
		mapDHWrap = LineChartController1.loadTableData(selCat, selLCycle, selBrand, null, null, sDate, eDate, strType11
															,'Home Care');
		//eDate = String.valueOf(system.today());
															
		//eDate = String.valueOf(system.today());
		Test.stopTest();
		
     }
}