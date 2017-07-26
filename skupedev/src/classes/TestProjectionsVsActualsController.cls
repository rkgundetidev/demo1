@istest
private class TestProjectionsVsActualsController {
    
    //Manual LAST MONTH and Previous-LAST MONTH future
	@testSetup 
    	static void setupManual() {
            
            list<string> category=new list<string>{'Air Care','Dish Care','Surface care'};
            list<string> lifecycle=new list<string>{'Active & Planned','Remnant & Historical'};
            list<string> type=new list<string>{'GBU'};

            date stDate;
            date dtTemp;
            integer month;
            integer Year ;
            dtTemp = system.today().addMonths(-1);
            month = dtTemp.month();
            Year = dtTemp.Year();
            stDate =  Date.newInstance(Year, month, 1);
            
            LatestDates__c setting = new LatestDates__c();
            //setting.Name = 'Test Setting';
            setting.SetupOwnerId=UserInfo.getOrganizationId();
            setting.Date__c = stDate;	//system.today();
            insert setting;
                    
            Test.startTest();
            integer i=0;
            for(string c : category){
            list<string> brand = new list<string>();
                if(c=='Air Care'){
                    brand= new list<string>{'All Air Care'};
                }
                else if(c=='Dish Care'){
                    brand= new list<string>{'ADW'};
                    stDate= stDate.addMonths(-1);
                }
                else if(c=='Surface Care'){
                    brand= new list<string>{'Mr Clean'};
                    stDate= stDate.addMonths(3);
                }			
                for(string b : brand){
                    for(string l : lifecycle){
                        for(string t : type){
                            string pt = l=='Active & Planned'?' New SKUs':' Discos';
                            i ++;                            
                            //system.debug('value of i ---'+string.valueof(i));
                            SKU__c sku = new SKU__c();                            
                            //sku.Name = 'Manual Projection Default Parent SKU';
                            sku.Name = '10037000061056'+string.valueof(i);
                            //system.debug('sku.Name ---'+sku.Name);
                            sku.SKU__c = '10037000061056'+string.valueof(i);
                            sku.Category__c = c;
                            sku.Status__c = l;
                            sku.SKU_Type__c = t;
                            sku.Dish_Care_Group__c = b;
                            sku.GBU__c = 'Home Care';
                            
                            insert sku; 
                            
                            Brand__c brand1 = new Brand__c();
                            brand1.Name = '80280234'+string.valueof(i);
                            brand1.Brand_Description__c = 'SWF S&V Repl Filter 12/2 ct14'+string.valueof(i);
                            brand1.Brand_Code__c = '80280234'+string.valueof(i);
                            brand1.SKU__c = sku.Id;
                            brand1.Status__c = l;
                            brand1.EOH_Inventory__c = 2433.27+i;
                            
                            insert brand1;															
                                    
                            SKU_Actual__c skua = new SKU_Actual__c();
                            skua.Name = '';
                            skua.SKU__c = sku.Id;
                            skua.Date__c = stDate;
                            skua.Actual_Status__c = l;
                            skua.SKU_Category__c = c;
                            
                            insert skua;
                            
                            Brand_Actual__c bact = new Brand_Actual__c();
                            bact.Name = '';
                            bact.Status__c = l;
                            bact.EOH_Inventory__c = 192.21+i;
                            bact.SKU_Actual__c = skua.Id;
                            bact.Date__c = stDate;
                            bact.Brand__c = brand1.ID;
                            insert bact;
                                            
                            SKU_Projection__c skup = new SKU_Projection__c();
                            skup.SKU__c = sku.Id;
                            skup.Name = '10037000061754-2017-03-30 00:00:00-New1007'+string.valueof(i);
                            skup.Source__c = 'Manual';				
                            skup.Projection_Type__c = l=='Active & Planned'?'New':'Disco';
                            skup.Description__c = 'Test1007'+string.valueof(i);
                            skup.Brand_Name__c = b;
                            
                            insert skup;
                            
                            
                            
                            Brand_Projection__c brandp = new Brand_Projection__c();
                            brandp.Name = t+' '+pt+' SKUs-'+'80280234'+string.valueof(i);
                            brandp.Brand__c = brand1.Id;
                            brandp.Date_of_Creation__c = stDate;
                            brandp.Date_of_Projection__c = stDate;
                            brandp.Projection_Type__c = t+pt;
                            brandp.SKU_Projection__c = skup.Id;
                            insert brandp;
                            
                        }		
                    }
                }
		} 
		//system.debug('SKU_Projection__c------Manual-----'+[SELECT Projected_date__c FROM SKU_Projection__c]);            
        Test.stopTest();
    }    
 
  // G_11  LAST MONTH and Previous-LAST MONTH 
    @testSetup 
    static void setupG_11() {
        
       		list<string> category=new list<string>{'Air Care','Dish Care'};
            list<string> lifecycle=new list<string>{'Active & Planned','Remnant & Historical','Projected'};
            list<string> type=new list<string>{'MSO'};
			RecordType rt = [select id,Name from RecordType where SobjectType='SKU_Projection__c' and Name='G-11' Limit 1];
            date stDate;
            date dtTemp;
            integer month;
            integer Year ;
            dtTemp = system.today().addMonths(-1);
            month = dtTemp.month();
            Year = dtTemp.Year();
            stDate =  Date.newInstance(Year, month, 1);
            
			LatestDates__c setting = new LatestDates__c();
            //setting.Name = 'Test Setting';
            setting.SetupOwnerId=UserInfo.getOrganizationId();
            setting.Date__c = stDate;	//system.today();
            insert setting;
        
            Test.startTest();
            integer i=44;
            for(string c : category){
            list<string> brand = new list<string>();
                if(c=='Air Care'){
                    brand= new list<string>{'All Air Care'};
                }
                else if(c=='Dish Care'){
                    brand= new list<string>{'ADW'};
                    stDate= stDate.addMonths(-1);
                }
                else if(c=='Surface Care'){
                    brand= new list<string>{'Mr Clean','Swiffer'};
                }			
                for(string b : brand){
                    for(string l : lifecycle){
                        for(string t : type){
                            string pt = l=='Active & Planned'?' New SKUs':' Discos';
                            i ++;
                            system.debug('value of i ---'+string.valueof(i));
                            SKU__c sku = new SKU__c();
                            sku.Name = '10037000061056'+string.valueof(i);
                            sku.SKU__c = '10037000061056'+string.valueof(i);
                            sku.Category__c = c;
                            sku.Status__c = l;
                            sku.SKU_Type__c = t;
                            sku.Dish_Care_Group__c = b;
                            sku.GBU__c = 'Home Care';
                            
                            insert sku; 
                            
                            Brand__c brand1 = new Brand__c();
                            brand1.Name = '80280234'+string.valueof(i);
                            brand1.Brand_Description__c = 'SWF S&V Repl Filter 12/2 ct14'+string.valueof(i);
                            brand1.Brand_Code__c = '80280234'+string.valueof(i);
                            brand1.SKU__c = sku.Id;
                            brand1.Status__c = l;
                            brand1.EOH_Inventory__c = 2433.27+i;
                            
                            insert brand1;															
                                    
                            SKU_Actual__c skua = new SKU_Actual__c();
                            skua.Name = '';
                            skua.SKU__c = sku.Id;
                            skua.Date__c = stDate;
                            skua.Actual_Status__c = l;
                            skua.SKU_Category__c = c;
                            
                            insert skua;
                            
                            Brand_Actual__c bact = new Brand_Actual__c();
                            bact.Name = '';
                            bact.Status__c = l;
                            bact.EOH_Inventory__c = 192.21+i;
                            bact.SKU_Actual__c = skua.Id;
                            bact.Date__c = stDate;
                            bact.Brand__c = brand1.ID;
                            insert bact;
                                            
                            SKU_Projection__c skup = new SKU_Projection__c();
                            skup.SKU__c = sku.Id;
                            skup.Name = '10037000061754-2017-03-30 00:00:00-New1007'+string.valueof(i);
                            skup.Source__c = 'G-11 Unchanged';
                            skup.RecordTypeid =rt.id;					
                            skup.Projection_Type__c = l=='Active & Planned'?'New':'Disco';
                            skup.Description__c = 'Test1007'+string.valueof(i);
                            skup.Brand_Name__c = b;
                            
                            insert skup;
                            
                            
                            
                            Brand_Projection__c brandp = new Brand_Projection__c();
                            brandp.Name = t+' '+pt+' SKUs-'+'80280234'+string.valueof(i);
                            brandp.Brand__c = brand1.Id;
                            brandp.Date_of_Creation__c = stDate;
                            brandp.Date_of_Projection__c = stDate;
                            brandp.Projection_Type__c = t+pt;
                            brandp.SKU_Projection__c = skup.Id;
                            insert brandp;
                            
                        }		
                    }
                }
		}           
        Test.stopTest();
    }    
 
  // G_11  LAST MONTH Incorrect
    @testSetup 
    static void setupG_11_Inc() {
        
       		list<string> category=new list<string>{'Air Care'};
            list<string> lifecycle=new list<string>{'Projected'};
            list<string> type=new list<string>{'GBU','MSO'};
			RecordType rt = [select id,Name from RecordType where SobjectType='SKU_Projection__c' and Name='G-11' Limit 1];
            date stDate;
            date dtTemp;
            integer month;
            integer Year ;
            dtTemp = system.today().addMonths(-1);
            month = dtTemp.month();
            Year = dtTemp.Year();
            stDate =  Date.newInstance(Year, month, 1);
            
			LatestDates__c setting = new LatestDates__c();
            //setting.Name = 'Test Setting';
            setting.SetupOwnerId=UserInfo.getOrganizationId();
            setting.Date__c = stDate;	//system.today();
            insert setting;
        
            Test.startTest();
            integer i=36;
            for(string c : category){
            list<string> brand = new list<string>();
                if(c=='Air Care'){
                    brand= new list<string>{'All Air Care'};
                }
                else if(c=='Dish Care'){
                    brand= new list<string>{'ADW','HDW'};
                }
                else if(c=='Surface Care'){
                    brand= new list<string>{'Mr Clean','Swiffer'};
                }			
                for(string b : brand){
                    for(string l : lifecycle){
                        for(string t : type){
                            string pt = l=='Projected'?' New SKUs':' Discos';
                            i ++;
                            system.debug('value of i ---'+string.valueof(i));
                            SKU__c sku = new SKU__c();
                            sku.Name = '10037000061056'+string.valueof(i);
                            sku.SKU__c = '10037000061056'+string.valueof(i);
                            sku.Category__c = c;
                            sku.Status__c = l;
                            sku.SKU_Type__c = t;
                            sku.Dish_Care_Group__c = b;
                            sku.GBU__c = 'Home Care';
                            
                            insert sku; 
                            
                            Brand__c brand1 = new Brand__c();
                            brand1.Name = '80280234'+string.valueof(i);
                            brand1.Brand_Description__c = 'SWF S&V Repl Filter 12/2 ct14'+string.valueof(i);
                            brand1.Brand_Code__c = '80280234'+string.valueof(i);
                            brand1.SKU__c = sku.Id;
                            brand1.Status__c = l;
                            brand1.EOH_Inventory__c = 2433.27+i;
                            
                            insert brand1;															
                                    
                            SKU_Actual__c skua = new SKU_Actual__c();
                            skua.Name = '';
                            skua.SKU__c = sku.Id;
                            skua.Date__c = stDate;
                            skua.Actual_Status__c = l;
                            skua.SKU_Category__c = c;
                            
                            insert skua;
                            
                            Brand_Actual__c bact = new Brand_Actual__c();
                            bact.Name = '';
                            bact.Status__c = l;
                            bact.EOH_Inventory__c = 192.21+i;
                            bact.SKU_Actual__c = skua.Id;
                            bact.Date__c = stDate;
                            bact.Brand__c = brand1.ID;
                            insert bact;
                                            
                            SKU_Projection__c skup = new SKU_Projection__c();
                            skup.SKU__c = sku.Id;
                            skup.Name = '10037000061754-2017-03-30 00:00:00-New1007'+string.valueof(i);
                            skup.Source__c = 'G-11 Unchanged';
                            skup.RecordTypeid =rt.id;					
                            skup.Projection_Type__c = l=='Projected'?'New':'Disco';
                            skup.Description__c = 'Test1007'+string.valueof(i);
                            skup.Brand_Name__c = b;
                            
                            insert skup;
                            
                            
                            
                            Brand_Projection__c brandp = new Brand_Projection__c();
                            brandp.Name = t+' '+pt+' SKUs-'+'80280234'+string.valueof(i);
                            brandp.Brand__c = brand1.Id;
                            brandp.Date_of_Creation__c = stDate;
                            brandp.Date_of_Projection__c = stDate;
                            brandp.Projection_Type__c = t+pt;
                            brandp.SKU_Projection__c = skup.Id;
                            insert brandp;
                            
                        }		
                    }
                }
		}           
        Test.stopTest();
    }    

  // Manual  LAST MONTH Incorrect
    @testSetup 
    static void setupManual_Inc() {
        
       		list<string> category=new list<string>{'Air Care'};
            list<string> lifecycle=new list<string>{'Active & Planned'};
            list<string> type=new list<string>{'GBU','MSO'};
			//RecordType rt = [select id,Name from RecordType where SobjectType='SKU_Projection__c' and Name='G-11' Limit 1];
            date stDate;
            date dtTemp;
            integer month;
            integer Year ;
            dtTemp = system.today().addMonths(-1);
            month = dtTemp.month();
            Year = dtTemp.Year();
            stDate =  Date.newInstance(Year, month, 1);
            
			LatestDates__c setting = new LatestDates__c();
            //setting.Name = 'Test Setting';
            setting.SetupOwnerId=UserInfo.getOrganizationId();
            setting.Date__c = stDate;	//system.today();
            insert setting;
        
            Test.startTest();
            integer i=62;
            for(string c : category){
            list<string> brand = new list<string>();
                if(c=='Air Care'){
                    brand= new list<string>{'All Air Care'};
                }
                else if(c=='Dish Care'){
                    brand= new list<string>{'ADW','HDW'};
                }
                else if(c=='Surface Care'){
                    brand= new list<string>{'Mr Clean','Swiffer'};
                }
                SKU__c sku = new SKU__c();
                            sku.Name = 'Manual Projection Default Parent SKU';
                            sku.SKU__c = 'Manual Projection Default Parent SKU';
                            sku.Category__c = c;
                            sku.Status__c = lifecycle[0];
                            sku.SKU_Type__c = type[0];
                            sku.Dish_Care_Group__c = brand[0];
                            sku.GBU__c = 'Home Care';
                            
                            insert sku; 
                for(string b : brand){
                    for(string l : lifecycle){
                        for(string t : type){
                            string pt = l=='Active & Planned'?' New SKUs':' Discos';
                            i ++;                                                        
                            
                            Brand__c brand1 = new Brand__c();
                            brand1.Name = '80280234'+string.valueof(i);
                            brand1.Brand_Description__c = 'SWF S&V Repl Filter 12/2 ct14'+string.valueof(i);
                            brand1.Brand_Code__c = '80280234'+string.valueof(i);
                            brand1.SKU__c = sku.Id;
                            brand1.Status__c = l;
                            brand1.EOH_Inventory__c = 2433.27+i;
                            
                            insert brand1;															
                                    
                            SKU_Actual__c skua = new SKU_Actual__c();
                            skua.Name = '';
                            skua.SKU__c = sku.Id;
                            skua.Date__c = stDate;
                            skua.Actual_Status__c = l;
                            skua.SKU_Category__c = c;
                            
                            insert skua;
                            
                            Brand_Actual__c bact = new Brand_Actual__c();
                            bact.Name = '';
                            bact.Status__c = l;
                            bact.EOH_Inventory__c = 192.21+i;
                            bact.SKU_Actual__c = skua.Id;
                            bact.Date__c = stDate;
                            bact.Brand__c = brand1.ID;
                            insert bact;
                                            
                            SKU_Projection__c skup = new SKU_Projection__c();
                            skup.SKU__c = sku.Id;
                            skup.Name = '10037000061754-2017-03-30 00:00:00-New1007'+string.valueof(i);
                            skup.Source__c = 'Manual';
                            //skup.RecordTypeid =rt.id;					
                            skup.Projection_Type__c = l=='Projected'?'New':'Disco';
                            skup.Description__c = 'Test1007'+string.valueof(i);
                            skup.Brand_Name__c = b;
                            
                            insert skup;
                            
                            
                            
                            Brand_Projection__c brandp = new Brand_Projection__c();
                            brandp.Name = t+' '+pt+' SKUs-'+'80280234'+string.valueof(i);
                            brandp.Brand__c = brand1.Id;
                            brandp.Date_of_Creation__c = stDate;
                            brandp.Date_of_Projection__c = stDate;
                            brandp.Projection_Type__c = t+pt;
                            brandp.SKU_Projection__c = skup.Id;
                            insert brandp;
                            
                        }		
                    }
                }
		}           
        Test.stopTest();
    }        
    
    static testmethod void testAllskus(){
        
        String[] category = new String[]{'Air care','Dish care','Surface care'};
        String[] lifecycle = new String[]{'Active & Planned','Remnant & Historical'};
        string[] brand = new String[]{'All Air Care','ADW','HDW','Mr Clean','Swiffer'};
        string[] Stype = new String[]{'GBU','MSO'};
        //system.debug('SKUS--------'+[select Category__c,SKU_Type__c,Status__c,First_Actual_Date__c,GBU_Latest_Actual_Date__c,Include_in_last_month_actual_counts__c from SKU__c]);                
		//system.debug('SKU_Actual__c--------'+[SELECT Actual_Status__c,SKU_Category__c,Month__c,Date__c FROM SKU_Actual__c]);
                        
        map<string,list<ProjectionsVsActualsController.wrapperData>> Allskus = ProjectionsVsActualsController.Allskus(new list<String>(),new list<String>(),new list<String>(),new list<String>(),'');
        map<string,list<ProjectionsVsActualsController.wrapperData>> Allskus1 = ProjectionsVsActualsController.Allskus(category, lifecycle, brand, Stype, '');
        
        map<string,list<ProjectionsVsActualsController.wrapperData>> FetchTableData = ProjectionsVsActualsController.fetchTableData(category, lifecycle, brand, Stype, '');
        map<string,list<ProjectionsVsActualsController.wrapperData>> FetchTableData1 = ProjectionsVsActualsController.fetchTableData(new list<String>(),new list<String>{'Remnant & Historical'},new list<String>(),new list<String>{'MSO'}, '');
        map<string,list<ProjectionsVsActualsController.wrapperData>> FetchTableData2 = ProjectionsVsActualsController.fetchTableData(new list<String>(),new list<String>(),new list<String>(),new list<String>(), '');
        
        Test.startTest();
        
        SKU__c skuProj = new SKU__c();
        skuProj.Name = 'Manual Projection Default Parent SKU11';
        skuProj.SKU__c = '10037000061229';
        skuProj.Category__c = 'Dish Care';
        skuProj.Status__c = 'Remnant & Historical'; //'Projected';
        skuProj.SKU_Type__c = 'GBU';
        skuProj.Dish_Care_Group__c = 'ADW';
        skuProj.GBU__c = 'Home Care';
        
        insert skuProj;
        
        SKU_Projection__c skup = new SKU_Projection__c();
        skup.SKU__c = skuProj.Id;
        skup.Name = '10037000061745-2017-03-31 00:00:00-Disco2511';
        skup.Source__c = 'Manual';
        skup.Projection_Type__c = 'New';
        skup.Description__c = 'Test25123';
        skup.Brand_Name__c = 'ADW';

        insert skup;
        
        //list<SKU_Projection__c> lstSKUProj = [SELECT Projected_date__c FROM SKU_Projection__c WHERE name like '10037000061745%' limit 1];
        Test.stopTest();
        
        system.debug('skup==='+skup);
        ProjectionsVsActualsController.DeleteSKU_Pro_record(skup.Id);
        id id1=null;
        ProjectionsVsActualsController.DeleteSKU_Pro_record(id1);
        
        
        for(integer i=1;i<=12;i++)
        {
            string LastMonth = ProjectionsVsActualsController.monthName(system.today().addMonths(i).month());
        }        
    }

}