public class ProjectionsVsActualsController {
    
    public class wrapperData  implements Comparable{
		@AuraEnabled public id recId;
		@AuraEnabled public string type;
		@AuraEnabled public string category;        
		@AuraEnabled public string SKU;
		@AuraEnabled public string BrandCode;
		@AuraEnabled public string BrandCodeDescription;
		@AuraEnabled public date ProjectionData;
		@AuraEnabled public string OutCome;
		@AuraEnabled public boolean DeleteRecord;
		@AuraEnabled public string color;
		@AuraEnabled public integer lstCnt;
		@AuraEnabled public string LfCycle_ProType;      
		@AuraEnabled public integer projections;        
		@AuraEnabled public integer actuals;
		
		
		public wrapperData(id recId, string type, string category, string SKU, string BrandCode, string BrandCodeDescription,date ProjectionData,string OutCome, boolean DeleteRecord, string color,integer skuCnts) {
			this.recId = recId;
			this.type = type;
			this.category = category;
			this.OutCome = OutCome;
			this.SKU = SKU;
			this.BrandCode = BrandCode;
			this.BrandCodeDescription = BrandCodeDescription;
			this.ProjectionData = ProjectionData;
			this.DeleteRecord = DeleteRecord;
			this.color=color;
			this.lstCnt =skuCnts;
		}
		public Integer compareTo(Object objToCompare) {
			return type.compareTo(((wrapperData)objToCompare).type);
		}	
        public wrapperData(string category,string LfCycle_ProType,integer projections,integer actuals) {
            this.category = category;
            this.LfCycle_ProType = LfCycle_ProType;
            this.projections = projections;
            this.actuals = actuals;
        }
    }
    
    @AuraEnabled public static string monthName(integer month){
        if(month==1)
            return 'January';
        if(month==2)
            return 'February';
        if(month==3)
            return 'March';
        if(month==4)
            return 'April';
        if(month==5)
            return 'May';
        if(month==6)
            return 'June';
        if(month==7)
            return 'July';
        if(month==8)
            return 'August';
        if(month==9)
            return 'September';
        if(month==10)
            return 'October';            
        if(month==11)
            return 'November';
        if(month==12)
            return 'December';
        else return 'Not valid month';
    }        
public static string preLastMonth=monthName(system.today().addMonths(-2).month());
public static integer preLastMon=system.today().addMonths(-2).month();    
public static string LastMonth=monthName(system.today().addMonths(-1).month());    
public static integer ThisYear=system.today().year();  
    
    
        
    @AuraEnabled public static map<string,list<wrapperData>> Allskus(list<string> category,list<string> lifecycle,list<string> brand, list<string> Stype , string userGBU) {
                
/*		User CurrentUsr = [Select GBU__c,Category__c from User where Id=:UserInfo.getUserId()];
        String userGBU = CurrentUsr.GBU__c;
        String userCategory = CurrentUsr.Category__c;
*/
        Date latestActualDate = GetLatestDates.getLatest(Enums.getGBUEnum(userGbu),ENUMS.MODULE.ACTUALS);
        if(userGBU==null || userGBU=='')
        	userGBU='Home Care';
        //system.debug('userGBU======='+userGBU+'userCategory========'+userCategory);

        if(category.isEmpty()){
            category=new list<string>{'Air Care'};
                // category=new list<string>{'Air Care','Dish Care','Surface Care'};
                }
        if(brand.isEmpty()){
            brand=new list<string>{'All Air Care'};
                //  brand=new list<string>{'All Air Care','ADW','HDW','Mr Clean','Swiffer'};
                }
        if(Stype.isEmpty()){
            Stype=new list<string>{'GBU'};
                }
        if(lifecycle.isEmpty()){
            lifecycle=new list<string>{'Active & Planned'};
                }
        map<string,list<wrapperData>> allskus= new  map<string,list<wrapperData>>();
        
        //new SKUS
        list<wrapperData> newskus = new list<wrapperData>();
        integer skucnt =0;
		integer ManualNewSkusCount=0;
        system.debug('category==='+category);
        system.debug('brand==='+brand);
        system.debug('Stype==='+Stype);
        system.debug('userGBU==='+userGBU);
        list<SKU__c> NewDiscoSkus = [SELECT id,Category__c,Name,SKU_Type__c,Status__c,
					(select Brand_Code__c,Brand_Description__c from Brands__r ORDER BY Brand_Code__c) FROM SKU__c 
					where GBU__c=:userGBU 
					and Include_in_last_month_actual_counts__c=true 
					and Category__c in :category 
					and Dish_Care_Group__c in :brand 
					and SKU_Type__c in :Stype 
					ORDER BY SKU_Type__c,Name];
					
		list<SKU__c> NewSkuLst	= new list<SKU__c>();		
		list<SKU__c> DiscoSkusLst	= new list<SKU__c>();
        system.debug('NewDiscoSkus----------'+NewDiscoSkus);
		
		if(NewDiscoSkus.size()>0 && NewDiscoSkus != null){					
			for(SKU__c s : NewDiscoSkus){
				if(s.Status__c=='Active & Planned'){
					NewSkuLst.add(s);
				}
				if(s.Status__c=='Remnant & Historical'){
					DiscoSkusLst.add(s);
				}
			}
		}
                                  
		set<id> skuids = new set<id>();
		set<id> Discoskuids = new set<id>();
		
		if(NewSkuLst.size()>0){
		    for(SKU__c s: NewSkuLst){
				skuids.add(s.id);
		    }
		}
		if(DiscoSkusLst.size()>0){
			for(SKU__c s: DiscoSkusLst){
			    Discoskuids.add(s.id);
			}
		}
		
		String strQuery = 'Select SKU__r.SKU_Type__c,SKU__r.Category__c,SKU__r.Name,Projected_date__c,Projection_Type__c,SKU__r.Status__c, '+
			                     '(select Brand__r.Brand_Code__c, Brand__r.Brand_Description__c '+
								 	'from  Brand_Projections__r ORDER BY Brand__r.Brand_Code__c)'+ 
							'from sku_Projection__c'+
							' WHERE recordtype.DeveloperName=\'G_11\' '+
							' AND SKU__r.GBU__c=:userGBU '+
							' AND SKU__r.Category__c in :category '+
			                ' AND SKU__r.Dish_Care_Group__c in :brand '+
							' AND SKU__r.SKU_Type__c in :Stype ';
		
		if(!Test.isRunningTest()){
			strQuery +=' AND Include_in_Projections__c=true ';
		}
		
		strQuery +=' ORDER BY SKU__r.SKU_Type__c,SKU__r.Name';
		
		/*
		list<sku_Projection__c> AllSkuProj = [Select SKU__r.SKU_Type__c,SKU__r.Category__c,SKU__r.Name,Projected_date__c,Projection_Type__c,SKU__r.Status__c, 
			                                 (select Brand__r.Brand_Code__c, Brand__r.Brand_Description__c 
											 from  Brand_Projections__r ORDER BY Brand__r.Brand_Code__c) 
			                                 from sku_Projection__c where SKU__r.GBU__c=:userGBU and
											 recordtype.DeveloperName='G_11' and 
											 Include_in_Projections__c=true and 
											 SKU__r.Category__c in :category and 
			                                 SKU__r.Dish_Care_Group__c in :brand and
			                                 SKU__r.SKU_Type__c in :Stype ORDER BY SKU__r.SKU_Type__c,SKU__r.Name];
		*/
		system.debug('strQuery==='+strQuery);
		list<sku_Projection__c> AllSkuProj = database.query(strQuery);
		list<sku_Projection__c>	NewSkuProj = new list<sku_Projection__c>();
		list<sku_Projection__c>	DiscSkuProj = new list<sku_Projection__c>();
		list<sku_Projection__c>	IncNewSkuProj = new list<sku_Projection__c>();
		list<sku_Projection__c>	IncDiscSkuProj = new list<sku_Projection__c>();
        system.debug('AllSkuProj----------'+AllSkuProj);
        
		if(AllSkuProj != null && AllSkuProj.size()>0){										 
			for(sku_Projection__c s : AllSkuProj){								 
				if(s.Projection_Type__c=='New' && skuids.contains(s.SKU__c)){
					NewSkuProj.add(s);
				}
				if(s.Projection_Type__c=='Disco' && Discoskuids.contains(s.SKU__c)){
					DiscSkuProj.add(s);
				}
				if(s.Projection_Type__c=='New' && s.SKU__r.Status__c=='Projected' && s.Projected_date__c.month()==system.today().addMonths(-1).month()){
					IncNewSkuProj.add(s);
				}
				if(s.Projection_Type__c=='Disco' && s.SKU__r.Status__c!='Remnant & Historical' && s.Projected_date__c.month()==system.today().addMonths(-1).month()){
					IncDiscSkuProj.add(s);
				}
			}
		}
		list<sku_Projection__c> AllManualSkuProj = [SELECT id,Projection_Type__c,Category__c,SKU__r.Category__c,Name,Brand_Code__c,Brand_Name__c,
                                  Description__c,Group__c,Projected_Date__c,SKU__r.Name,SKU__r.Status__c FROM SKU_Projection__c 
								  where  SKU__r.GBU__c=:userGBU 
								  and Include_in_Projections_Manual__c=true 
								  and recordtype.DeveloperName='Manual' 
								  and Category__c in :category 
                                  and Group__c in :brand 
                                  and SKU__r.SKU_Type__c in :Stype ORDER BY Projection_Type__c,Name,Brand_Code__c];
        
        system.debug('AllManualSkuProj----------'+AllManualSkuProj);
								  
		set<string> Mnews = new set<string>{'New','Customized New SKU','Non-Customized New SKU'};
		set<string> Mdiscos = new set<string>{'Disco','Customized Disco','Non-Customized Disco'};
										  
		list<sku_Projection__c>	NewManualSkuProj = new list<sku_Projection__c>();
		list<sku_Projection__c>	DiscManualSkuProj = new list<sku_Projection__c>();
		list<sku_Projection__c>	IncNewManualSkuProj = new list<sku_Projection__c>();
		list<sku_Projection__c>	IncDiscManualSkuProj = new list<sku_Projection__c>();
		
		if(AllManualSkuProj != null && AllManualSkuProj.size()>0){
			for(sku_Projection__c s : AllManualSkuProj){								 
				if(s.SKU__r.Name!='Manual Projection Default Parent SKU'){
					if(s.SKU__r.Status__c=='Active & Planned' && Mnews.contains(s.Projection_Type__c)){
						NewManualSkuProj.add(s);
					}
					else if	(s.SKU__r.Status__c=='Remnant & Historical' && Mdiscos.contains(s.Projection_Type__c)){
						DiscManualSkuProj.add(s);
					}
				}
				else if(s.SKU__r.Name=='Manual Projection Default Parent SKU' && s.Projected_date__c.month()==system.today().addMonths(-1).month()){
					if(Mnews.contains(s.Projection_Type__c)){
						IncNewManualSkuProj.add(s);
					}
					else if(Mdiscos.contains(s.Projection_Type__c)){
						IncDiscManualSkuProj.add(s);
					}
				}
			}
		}
                               
/*		list<SKU_Projection__c> ManualNewSkus= [SELECT id,Projection_Type__c,SKU__r.Category__c,Name,Brand_Code__c,Brand_Name__c,
                                  Description__c,Group__c,Projected_Date__c,SKU__r.id 
                                  FROM SKU_Projection__c 
                                  where  SKU__r.GBU__c=:userGBU 
                                  and SKU__r.Status__c='Active & Planned'
                                  and Include_in_Projections_Manual__c=true
                                  and Projection_Type__c in ('new','Customized New SKU','Non-Customized New SKU') 
                                  and recordtype.DeveloperName='Manual' 
                                  and SKU__r.Name!='Manual Projection Default Parent SKU' 
                                  and Category__c in :category 
                                  and Group__c in :brand 
                                  and SKU__r.SKU_Type__c in :Stype ORDER BY Projection_Type__c,Name,Brand_Code__c];
*/        
		if(skuids!=null && skuids.size()>0)
            skucnt =skuids.size();
		if(NewManualSkuProj!=null && NewManualSkuProj.size()>0){
            ManualNewSkusCount =NewManualSkuProj.size();
			skucnt+=ManualNewSkusCount;
		}	
        
        set<id> notred=new set<id>();        
        for(sku_Projection__c s:NewSkuProj){
         notred.add(s.SKU__c);                            
         string type1=s.SKU__r.SKU_Type__c=='GBU'?'NON-CUSTOMIZED ':'CUSTOMIZED '; 
		 type1+=' NEW SKU ';
			for(Brand_Projection__c b:s.Brand_Projections__r ){
                 if(s.Projected_date__c.month()==system.today().addMonths(-1).month()){
                     newskus.add(new wrapperData(s.id, type1, s.SKU__r.Category__c, s.SKU__r.Name ,b.Brand__r.Brand_Code__c,b.Brand__r.Brand_Description__c, s.Projected_date__c,'Projected in '+monthName(s.Projected_date__c.MONTH())+' '+s.Projected_date__c.year(), false,'green',skucnt ));
                 }
                 else{
                     newskus.add(new wrapperData(s.id, type1, s.SKU__r.Category__c, s.SKU__r.Name ,b.Brand__r.Brand_Code__c,b.Brand__r.Brand_Description__c, s.Projected_date__c,'Projected in '+monthName(s.Projected_date__c.MONTH())+' '+s.Projected_date__c.year(), false,'blue', skucnt ));
                 }
                 
		 	}
		}
        
        for(SKU__c s: NewSkuLst){
        	if(!notred.contains(s.id)){
	                           
	            string type1=s.SKU_Type__c=='GBU'?'NON-CUSTOMIZED ':'CUSTOMIZED '; 
	            type1+=' NEW SKU ';
	            for(Brand__c b:s.brands__r ){
	                newskus.add(new wrapperData(s.id, type1, s.Category__c, s.Name ,b.Brand_Code__c,b.Brand_Description__c, latestActualDate,'Not Projected', false,'red',skucnt ));
	            }
        	}
        }                
                
        // ManualRecTypeID=Schema.SObjectType.SKU_Projection__c.getRecordTypeInfosByName().get('Manual').getRecordTypeId();
		//Manual
        for(SKU_Projection__c sp:NewManualSkuProj){
                                      if(sp.Projected_date__c.month()==system.today().addMonths(-1).month()){
                                          newskus.add(new wrapperData(sp.id,sp.Projection_Type__c+' SKU',sp.SKU__r.Category__c,sp.Name ,sp.Brand_Code__c,sp.Description__c, sp.Projected_Date__c,'Projected in '+monthName(sp.Projected_Date__c.MONTH())+' '+sp.Projected_Date__c.year(),true,'green',skucnt ));
                                      }
                                      else{
                                          newskus.add(new wrapperData(sp.id,sp.Projection_Type__c+' SKU',sp.SKU__r.Category__c,sp.Name ,sp.Brand_Code__c,sp.Description__c, sp.Projected_Date__c,'Projected in '+monthName(sp.Projected_Date__c.MONTH())+' '+sp.Projected_Date__c.year(),true,'blue',skucnt ));
                                      }                                      
                                  }                          
        newskus.sort();        
        allskus.put('newskus',newskus);
        
        //discskus                
        list<wrapperData> discskus = new list<wrapperData>();
        integer discoSku =0;
		integer ManualDiscSkusCount = 0;
		
/*		list<SKU_Projection__c> ManualDiscSkus =[SELECT id,Projection_Type__c,SKU__r.Category__c,Name,Brand_Code__c,Brand_Name__c,Description__c,Group__c,Projected_Date__c,SKU__r.id FROM SKU_Projection__c 
                                  where  SKU__r.GBU__c=:userGBU and SKU__r.Status__c='Remnant & Historical' and Projection_Type__c in ('Disco','Customized Disco','Non-Customized Disco') 
                                  and Include_in_Projections_Manual__c=true and recordtype.DeveloperName='Manual' and SKU__r.Name!='Manual Projection Default Parent SKU' 
                                  and SKU__r.Category__c in :category and Group__c in :brand and SKU__r.SKU_Type__c in :Stype 
                                  ORDER BY Projection_Type__c,SKU__r.Name,Brand_Code__c];
          	    
        list<SKU__c> Discoskuids=[SELECT Id FROM SKU__c 
                                  where   GBU__c=:userGBU and Status__c = 'Remnant & Historical' 
                                  and  Include_in_last_month_actual_counts__c=true and 
                                  Category__c in :category and 
                                  Dish_Care_Group__c in :brand and SKU_Type__c in :Stype];		*/
        if(Discoskuids!=null && Discoskuids.size()>0)
            discoSku =  Discoskuids.size(); 
		if(DiscManualSkuProj!=null && DiscManualSkuProj.size()>0){
            ManualDiscSkusCount =  DiscManualSkuProj.size(); 
			discoSku+=ManualDiscSkusCount;
		}
        
        set<id> Disconotred=new set<id>();        
        for(sku_Projection__c s : DiscSkuProj){
            
            Disconotred.add(s.SKU__c);
            string type1=s.SKU__r.SKU_Type__c=='GBU'?'NON-CUSTOMIZED ':'CUSTOMIZED '; 
            type1+=' DISCO SKU ';            
            
            for(Brand_Projection__c b:s.Brand_Projections__r ){
                if(s.Projected_date__c.month()==system.today().addMonths(-1).month()){
                    discskus.add(new wrapperData(s.id, type1, s.SKU__r.Category__c, s.SKU__r.Name ,b.Brand__r.Brand_Code__c,b.Brand__r.Brand_Description__c, s.Projected_date__c,'Projected in '+monthName(s.Projected_date__c.MONTH())+' '+s.Projected_date__c.year(), false,'green',discoSku ));
                }
                else{
                    discskus.add(new wrapperData(s.id, type1, s.SKU__r.Category__c, s.SKU__r.Name ,b.Brand__r.Brand_Code__c,b.Brand__r.Brand_Description__c, s.Projected_date__c,'Projected in '+monthName(s.Projected_date__c.MONTH())+' '+s.Projected_date__c.year(), false,'blue',discoSku ));
                }
            }
        }
        
        for(SKU__c s: DiscoSkusLst){
        	if(!Disconotred.contains(s.id)){
	            string type1=s.SKU_Type__c=='GBU'?'NON-CUSTOMIZED ':'CUSTOMIZED '; 
	            type1+=' DISCO SKU ';
	            for(Brand__c b:s.brands__r ){                
	                discskus.add(new wrapperData(s.id, type1, s.Category__c, s.Name ,b.Brand_Code__c,b.Brand_Description__c, latestActualDate,'Not Projected', false,'red',discoSku ));
	            }
        	}
        }
        
    	//Manual	
        for(SKU_Projection__c sp:DiscManualSkuProj){
                                      
            if(sp.Projected_date__c.month()==system.today().addMonths(-1).month()){
                discskus.add(new wrapperData(sp.id,sp.Projection_Type__c+' SKU',sp.SKU__r.Category__c,sp.Name ,sp.Brand_Code__c,sp.Description__c, sp.Projected_Date__c,'Projected in '+monthName(sp.Projected_Date__c.MONTH())+' '+sp.Projected_Date__c.year(),true,'green',discoSku ));
            }
            else{
                discskus.add(new wrapperData(sp.id,sp.Projection_Type__c+' SKU',sp.SKU__r.Category__c,sp.Name ,sp.Brand_Code__c,sp.Description__c, sp.Projected_Date__c,'Projected in '+monthName(sp.Projected_Date__c.MONTH())+' '+sp.Projected_Date__c.year(),true,'blue',discoSku ));
            }
        }                          
        discskus.sort();  
        allskus.put('discskus',discskus);
        
        //incorrectNewskus
        list<wrapperData> incorrectNewskus = new list<wrapperData>();        
        integer cntIncorrectNew =0;
		integer ManualIncorrectNewskusCount=0;
   /*     list<sku_Projection__c> skuProj =[Select Projected_date__c,SKU__r.Category__c,SKU__r.SKU_Type__c,
                                          SKU__r.Name,(select Brand__r.Brand_Code__c, Brand__r.Brand_Description__c from  
                                                       Brand_Projections__r ORDER BY Brand__r.Brand_Code__c) 
                                          from sku_Projection__c 
                                          where  SKU__r.GBU__c=:userGBU and 
                                          recordtype.DeveloperName='G_11' and 
                                          Projection_Type__c='New' and 
                                          Include_in_Projections__c=true and
                                          SKU__r.Status__c='Projected' and 
                                          Projected_date__c=LAST_MONTH and 
                                          SKU__r.Category__c in :category and 
                                          SKU__r.Dish_Care_Group__c in :brand 
                                          and SKU__r.SKU_Type__c in :Stype ORDER BY SKU__r.SKU_Type__c,SKU__r.Name]; 
		list<SKU_Projection__c> ManualIncorrectNewskus = [SELECT id,Projection_Type__c,Category__c,Name,Brand_Code__c,Brand_Name__c,
														  Description__c,Group__c,Projected_Date__c,SKU__r.id FROM SKU_Projection__c 
														  where recordtype.DeveloperName='Manual' and Include_in_Projections_Manual__c=true 
														  and Projection_Type__c in ('new','Customized New SKU','Non-Customized New SKU') 
														  and SKU__r.Name='Manual Projection Default Parent SKU' and Projected_Date__c=LAST_MONTH 
														  and Category__c in :category and Group__c in :brand ORDER BY Projection_Type__c,Name,Brand_Code__c];
*/														  
        if(IncNewSkuProj!=null  && IncNewSkuProj.size()>0){
            cntIncorrectNew =IncNewSkuProj.size();
        }
		if(IncNewManualSkuProj!=null && IncNewManualSkuProj.size()>0){
            ManualIncorrectNewskusCount =IncNewManualSkuProj.size();
			cntIncorrectNew+= ManualIncorrectNewskusCount;
        }

        for(sku_Projection__c s: IncNewSkuProj){
            string type1=s.SKU__r.SKU_Type__c=='GBU'?'NON-CUSTOMIZED ':'CUSTOMIZED '; 
            type1+=' NEW SKU ';            
            for(Brand_Projection__c b:s.Brand_Projections__r ){
                incorrectNewskus.add(new wrapperData(s.id, type1, s.SKU__r.Category__c, s.SKU__r.Name ,b.Brand__r.Brand_Code__c,b.Brand__r.Brand_Description__c, s.Projected_date__c,'Projected in '+monthName(s.Projected_date__c.MONTH())+' '+s.Projected_date__c.year(), false,'black',cntIncorrectNew ));
            }
        }		
        //Manual
        for(SKU_Projection__c sp: IncNewManualSkuProj){
            incorrectNewskus.add(new wrapperData(sp.id,sp.Projection_Type__c+'SKU',sp.Category__c,sp.Name ,sp.Brand_Code__c,sp.Brand_Name__c, sp.Projected_Date__c,'Projected in '+monthName(sp.Projected_Date__c.MONTH())+' '+sp.Projected_Date__c.year(),true,'black',cntIncorrectNew ));
        }   
        incorrectNewskus.sort();
        allskus.put('incorrectNewskus',incorrectNewskus);        
        
        //incorrectDiscoskus
        list<wrapperData> incorrectDiscoskus = new list<wrapperData>();
        integer cntincorrectDiscos =0;
		integer ManualincorrectDiscoskusCount = 0;
   /*     list<sku_Projection__c> lstDisco = [Select Projected_date__c,SKU__r.Category__c,SKU__r.SKU_Type__c,
                                            SKU__r.Name,(select Brand__r.Brand_Code__c, Brand__r.Brand_Description__c from 
                                                         Brand_Projections__r ORDER BY Brand__r.Brand_Code__c) 
                                            from sku_Projection__c 
                                            where  SKU__r.GBU__c=:userGBU and 
                                            recordtype.DeveloperName='G_11' and
                                            Projection_Type__c='Disco' and 
                                            Include_in_Projections__c=true and
                                            SKU__r.Status__c!='Remnant & Historical' and 
                                            Projected_date__c=LAST_MONTH and
                                            SKU__r.Category__c in :category and 
                                            SKU__r.Dish_Care_Group__c in :brand 
                                            and SKU__r.SKU_Type__c in :Stype ORDER BY SKU__r.SKU_Type__c,SKU__r.Name];		
		list<SKU_Projection__c> ManualincorrectDiscoskus = [SELECT id,Projection_Type__c,Category__c,Name,Brand_Code__c,Brand_Name__c,
												  Description__c,Group__c,Projected_Date__c,SKU__r.id FROM SKU_Projection__c 
												  where  SKU__r.GBU__c=:userGBU and recordtype.DeveloperName='Manual' and Include_in_Projections_Manual__c=true 
												  and Projection_Type__c in ('Disco','Customized Disco','Non-Customized Disco') 
												  and SKU__r.Name='Manual Projection Default Parent SKU' and Projected_Date__c=LAST_MONTH 
												  and Category__c in :category and Group__c in :brand ORDER BY Projection_Type__c,Name,Brand_Code__c];
*/												  
        if(IncDiscSkuProj!=null && IncDiscSkuProj.size() >0)
            cntincorrectDiscos =IncDiscSkuProj.size();
		if(IncDiscManualSkuProj!=null && IncDiscManualSkuProj.size() >0){
            ManualincorrectDiscoskusCount =IncDiscManualSkuProj.size();	
			cntincorrectDiscos+= ManualincorrectDiscoskusCount;
		}
        for(sku_Projection__c s: IncDiscSkuProj){
            string type1=s.SKU__r.SKU_Type__c=='GBU'?'NON-CUSTOMIZED ':'CUSTOMIZED '; 
            type1+=' DISCO SKU ';
            for(Brand_Projection__c b:s.Brand_Projections__r ){
                incorrectDiscoskus.add(new wrapperData(s.id, type1, s.SKU__r.Category__c, s.SKU__r.Name ,b.Brand__r.Brand_Code__c,b.Brand__r.Brand_Description__c, s.Projected_date__c,'Projected in '+monthName(s.Projected_date__c.MONTH())+' '+s.Projected_date__c.year(), false,'black',cntincorrectDiscos ));
            }
        }
        //Manual		
        for(SKU_Projection__c sp: IncDiscManualSkuProj){
            incorrectDiscoskus.add(new wrapperData(sp.id,sp.Projection_Type__c+'SKU',sp.Category__c,sp.Name ,sp.Brand_Code__c,sp.Brand_Name__c, sp.Projected_Date__c,'Projected in '+monthName(sp.Projected_Date__c.MONTH())+' '+sp.Projected_Date__c.year(),true,'black',cntincorrectDiscos ));
        }   
        incorrectDiscoskus.sort();
        allskus.put('incorrectDiscoskus',incorrectDiscoskus);
        
        //nochangeskus        
        list<wrapperData> nochangeskus = new list<wrapperData>();
        integer cntnochanges=0;        
        list<SKU__c> ncskus = [SELECT id,Category__c,Name,First_Actual_Date__c,SKU_Type__c,
                               (select Brand_Code__c,Brand_Description__c from Brands__r WHERE IsMissing__c=false ORDER BY Brand_Code__c) FROM SKU__c  
                               where  GBU__c=:userGBU and IsSKUMissing__c=false and status__c!='Projected' and
                               Include_in_last_month_actual_counts__c=false 
                               and Category__c in :category and Dish_Care_Group__c in :brand and SKU_Type__c in :Stype and Status__c in :lifecycle 
                               ORDER BY SKU_Type__c,Name];
        if(ncskus!=null && ncskus.size()>0)
            cntnochanges =ncskus.size();
        
        for(SKU__c s: ncskus){
            string type1=s.SKU_Type__c=='GBU'?'NON-CUSTOMIZED ':'CUSTOMIZED '; 
            type1+=' SKU ';            
            
            for(Brand__c b:s.brands__r ){
                nochangeskus.add(new wrapperData(s.id, type1, s.Category__c, s.Name ,b.Brand_Code__c,b.Brand_Description__c, s.First_Actual_Date__c,'No Changes', false,'black',cntnochanges ));
            }        
        }
        nochangeskus.sort();
        allskus.put('nochangeskus',nochangeskus);
        
        return allskus;
    }
        

    @AuraEnabled public static map<string,list<wrapperData>> fetchTableData(list<string> category,list<string> lifecycle,list<string> brand , list<string> Stype , string userGBU) {
        
/*      User CurrentUsr = [Select GBU__c,Category__c from User where Id=:UserInfo.getUserId()];
        String userGBU = CurrentUsr.GBU__c;
        String userCategory = CurrentUsr.Category__c;    
*/		
		if(userGBU==null || userGBU=='')
        userGBU='Home Care';
        
        map<string,list<wrapperData>> TabledataMap = new  map<string,list<wrapperData>>();                       
        list<wrapperData> Table1Data = new list<wrapperData>();        
        
        if(category.isEmpty()){
            category=new list<string>{'Air Care'};
                }
        if(lifecycle.isEmpty()){
            lifecycle=new list<string>{'Active & Planned'};		                
                    }
        if(brand.isEmpty()){
            brand=new list<string>{'All Air Care'};
              //  brand=new list<string>{'All Air Care','ADW','HDW','Mr Clean','Swiffer'};
                    }
        if(Stype.isEmpty()){
            Stype=new list<string>{'GBU'};
                }
        system.debug('LastMonth=403=='+LastMonth);
        system.debug('category==404='+category);
        
        string query = 'SELECT Actual_Status__c,SKU_Category__c, count(id)TotalSkus '+
                        'FROM SKU_Actual__c '+
                        'where SKU__r.GBU__c=:userGBU and Is_Latest_Actual__c=true and SKU__r.IsSKUMissing__c=false and '+
                        'Actual_Status__c = :lifecycle and '+
                        'SKU_Category__c=:category '+
                        'group by SKU_Category__c,Actual_Status__c';          
        
        system.debug('query==412='+query);
        AggregateResult[] groupedActuals = database.query(query);
        system.debug('groupedActuals==414='+groupedActuals);
        AggregateResult[] preMonGroupedActuals = [SELECT Actual_Status__c,SKU_Category__c, count(id)TotalSkus 
                                                    FROM SKU_Actual__c 
                                                    where SKU__r.GBU__c=:userGBU and 
                                                  	CALENDAR_Month(Date__c) = :preLastMon and
                                                    CALENDAR_Year(Date__c) = :ThisYear and 
                                                    Actual_Status__c = :lifecycle and 
                                                    SKU_Category__c=:category 
                                                    group by SKU_Category__c,Actual_Status__c ];        
        //AggregateResult[] groupedActuals = [SELECT Actual_Status__c,SKU_Category__c, count(id)TotalSkus FROM SKU_Actual__c where Month__c IN ('May') group by SKU_Category__c,Actual_Status__c];
                
           
		Map<string,map<String,integer>> groupedActualsMap = new Map<string,map<String,integer>>();
		Map<string,map<String,integer>> preMonGroupedActualsMap = new Map<string,map<String,integer>>();
		
		if(groupedActuals!=null && groupedActuals.size()>0){
			for(AggregateResult ag :groupedActuals){
                if(groupedActualsMap.containsKey((string)ag.get('SKU_Category__c'))){
					Map<string,integer> CategoryMap = groupedActualsMap.get((string)ag.get('SKU_Category__c'));
					CategoryMap.put((string)ag.get('Actual_Status__c'),(integer)ag.get('TotalSkus'));
					groupedActualsMap.put((string)ag.get('SKU_Category__c'),CategoryMap);
				}
				else{
					Map<string,integer> CategoryMap = new Map<string,integer>();
					CategoryMap.put((string)ag.get('Actual_Status__c'),(integer)ag.get('TotalSkus'));
					groupedActualsMap.put((string)ag.get('SKU_Category__c'),CategoryMap);
				}
            }
		}
		
		if(preMonGroupedActuals!=null && preMonGroupedActuals.size()>0){
			for(AggregateResult ag :preMonGroupedActuals){
                if(preMonGroupedActualsMap.containsKey((string)ag.get('SKU_Category__c'))){
					Map<string,integer> CategoryMap = preMonGroupedActualsMap.get((string)ag.get('SKU_Category__c'));
					CategoryMap.put((string)ag.get('Actual_Status__c'),(integer)ag.get('TotalSkus'));
					preMonGroupedActualsMap.put((string)ag.get('SKU_Category__c'),CategoryMap);
				}
				else{
					Map<string,integer> CategoryMap = new Map<string,integer>(); 
					CategoryMap.put((string)ag.get('Actual_Status__c'),(integer)ag.get('TotalSkus'));
					preMonGroupedActualsMap.put((string)ag.get('SKU_Category__c'),CategoryMap);
				}
            }
		}
		
		AggregateResult[] projecCount= [Select SKU__r.Category__c, SKU__r.Dish_Care_Group__c, Projection_Type__c, SKU__r.SKU_Type__c, 
										count(id)TotalSkus from sku_Projection__c where SKU__r.GBU__c=:userGBU 
										and Include_in_Projections__c=true and Projected_date__c=LAST_MONTH 
										GROUP BY SKU__r.Category__c, SKU__r.Dish_Care_Group__c, Projection_Type__c, SKU__r.SKU_Type__c];
										
    	Map<string,integer> projMap = new Map<string,integer>();
    	for(AggregateResult a : projecCount){
    		    		
    		string Pcategory = (string)a.get('Category__c');
    		string Pbrand = (string)a.get('Dish_Care_Group__c');
    		string Ptype = (string)a.get('SKU_Type__c');
    		string PProType = (string)a.get('Projection_Type__c');
    		integer cont = (integer)a.get('TotalSkus');
    		system.debug(Pcategory+'--'+Pbrand+'--'+PProType+'--'+Ptype+'--'+cont);
    		if( Pcategory!=null && Pbrand!=null && Ptype!=null && PProType!=null ){
    			projMap.put(Pcategory+'~'+Pbrand+'~'+PProType+'~'+Ptype,cont);
    		}    	
    	}
	system.debug(projMap);	
	for(string cate:category){
		for(string lc :lifecycle){
			list<string> CateBrands = new list<string>();
			if(cate=='Air Care'){
				CateBrands= new list<string>{'All Air Care'};
			}
			else if(cate=='Dish Care'){
				CateBrands= new list<string>{'ADW','HDW'};
			}
			else if(cate=='Surface Care'){
				CateBrands= new list<string>{'Mr Clean','Swiffer'};
			}
				integer actualSkus = 0;
				integer preMonactualSkus = 0;
            	integer projectionSkus = 0;
				if(groupedActualsMap.containsKey(cate)){
					Map<string,integer> CategoryMap = groupedActualsMap.get(cate);
					if(CategoryMap.containsKey(lc)){
						actualSkus= CategoryMap.get(lc);
					}					
				}
				if(preMonGroupedActualsMap.containsKey(cate)){
					Map<string,integer> CategoryMap = preMonGroupedActualsMap.get(cate);
					if(CategoryMap.containsKey(lc)){
						preMonactualSkus= CategoryMap.get(lc);
					}					
				}
				
                integer nGBU=0;
                integer nMSO=0;
                integer dGBU=0;
                integer dMSO=0;
                
	                for(string brnd : CateBrands){
	                if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'New'+'~'+'GBU'))
	                    nGBU += projMap.get(cate+'~'+brnd+'~'+'New'+'~'+'GBU');
	                if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'New'+'~'+'MSO'))
	                    nMSO += projMap.get(cate+'~'+brnd+'~'+'New'+'~'+'MSO');
	                if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'Disco'+'~'+'GBU'))
	                    dGBU += projMap.get(cate+'~'+brnd+'~'+'Disco'+'~'+'GBU');
	                if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'Disco'+'~'+'MSO'))
	                    dMSO += projMap.get(cate+'~'+brnd+'~'+'Disco'+'~'+'MSO');
	                }
	                
                if(lc=='Active & Planned'){
                    projectionSkus=preMonactualSkus + nGBU + nMSO - dGBU - dMSO;  
                }
                else{                   
                    projectionSkus= preMonactualSkus + dGBU + dMSO;
                }
            system.debug(cate+'--'+lc+'--'+projectionSkus+'--'+actualSkus);
            Table1Data.add(new wrapperData(cate,lc,projectionSkus,actualSkus));
		}
	
	}
 
    TabledataMap.put('Table1data',Table1Data);
    
        map<string,map<string,integer>> Actuals = new map<string,map<string,integer>>();
        
        for(string cate : category){
            map<String,integer> mapCategory = new map<String,integer>();
            map<String,integer> mapCat = new map<String,integer>();
            for(string pt:new list<string>{'New','Disco'}){
                for(string st:Stype){                   
                    mapCat.put(pt+st,0);                    
                }
            }           
            Actuals.put(cate,mapCat);
        }
        
        AggregateResult[] actualCountsGrp=[SELECT Category__c,SKU_Type__c,Status__c,count(id)Total FROM SKU__c  
                                           where GBU__c=:userGBU and Status__c in ('Active & Planned','Remnant & Historical') and 
                                           Include_in_last_month_actual_counts__c=true and 
                                           Dish_Care_Group__c in :brand and SKU_Type__c in :Stype 
                                           group by Category__c,SKU_Type__c,Status__c];
        
        if(actualCountsGrp!=null && actualCountsGrp.size()>0){
            for(AggregateResult acg : actualCountsGrp){
                
                map<String,integer> map1;
                if(Actuals!=null && Actuals.containsKey((string)acg.get('Category__c')))
                {
                    map1 = Actuals.get((string)acg.get('Category__c'));
                }else
                {
                    map1 = new map<String,integer>();
                }
                string actualKey;
                if((string)acg.get('Status__c')=='Active & Planned'){
                    actualKey='New'+(string)acg.get('SKU_Type__c');
                }
                else{
                    actualKey='Disco'+(string)acg.get('SKU_Type__c');
                }
                
                integer SkuActual=(integer)acg.get('Total');
                map1.put(actualKey,SkuActual);
                Actuals.put((string)acg.get('Category__c'),map1);            
            }
        }
        
        system.debug('PreLastMonth==='+PreLastMonth);
        system.debug('LastMonth==='+LastMonth);
        system.debug('lifecycle==='+lifecycle);
        system.debug('brand==='+brand);
        
        AggregateResult[] LastMonthActuals=[SELECT SKU_Category__c,count(id)Total 
                                                FROM SKU_Actual__c 
                                                where SKU__r.GBU__c=:userGBU 
                                                and Is_Latest_Actual__c=true 
                                            	and SKU__r.IsSKUMissing__c=false
                                                and Actual_Status__c in :lifecycle 
                                                and SKU__r.Dish_Care_Group__c in :brand
                                                and SKU__r.SKU_Type__c in :Stype
                                                group by SKU_Category__c];
        
        system.debug('LastMonthActuals===='+LastMonthActuals);                                      
        AggregateResult[] PreLastMonthActuals=[SELECT SKU_Category__c,count(id)Total 
                                                FROM SKU_Actual__c 
                                                where SKU__r.GBU__c=:userGBU 
                                                and	CALENDAR_Month(Date__c) = :preLastMon 
                                                and CALENDAR_Year(Date__c) = :ThisYear
                                                and Actual_Status__c in :lifecycle 
                                                and SKU__r.Dish_Care_Group__c in :brand
                                                and SKU__r.SKU_Type__c in :Stype
                                                group by SKU_Category__c];
        system.debug('PreLastMonthActuals===='+PreLastMonthActuals);                                        
        map<String,integer> LastMonthActualsMap= new map<String,integer>();
        map<String,integer> PreLastMonthActualsMap= new map<String,integer>();
        if(LastMonthActuals!=null && LastMonthActuals.size()>0)
        {
            for(integer i=0;i<LastMonthActuals.size();i++){
                LastMonthActualsMap.put((string)LastMonthActuals[i].get('SKU_Category__c'),(integer)LastMonthActuals[i].get('Total'));
            }
        }
        
        if(PreLastMonthActuals!=null && PreLastMonthActuals.size()>0)
        {
            for(integer i=0;i<PreLastMonthActuals.size();i++){
                PreLastMonthActualsMap.put((string)PreLastMonthActuals[i].get('SKU_Category__c'),(integer)PreLastMonthActuals[i].get('Total'));
            }
        }
        system.debug('LastMonthActuals===='+LastMonthActuals);
        system.debug('PreLastMonthActuals==='+PreLastMonthActuals);
        
        list<wrapperData> Table2data = new list<wrapperData>();
        category.sort();
        //-------------
        integer NewSkuCount = 0;
        integer DisSkuCount = 0;
        integer IncNewSkuCount = 0;
        integer IncDisSkuCount = 0;
        integer NoChagSkuCount = 0;
        //-------------
        for(string cate : category){
                      
            map<String,integer> ActualCounts=Actuals.get(cate);
            string selectedLifeCycle='';
            integer LastMonthProjectionCount;
                      
            system.debug(ActualCounts);
            integer lMonAct = 0;
            integer plMonAct = 0;
            integer projCountGBU = 0;
            integer projCountMSO = 0;
            
            integer projDiscoGBU = 0;
            integer projDiscoMSO = 0;
            
            if(LastMonthActualsMap!=null && LastMonthActualsMap.containsKey(cate))
            {
                lMonAct = LastMonthActualsMap.get(cate);
            }
            if(PreLastMonthActualsMap!=null && PreLastMonthActualsMap.containsKey(cate))
            {
                plMonAct = PreLastMonthActualsMap.get(cate);
            }
            for(string brnd : brand){
            	if(Stype.size()==2){
					if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'New'+'~'+'GBU'))
	                    projCountGBU += projMap.get(cate+'~'+brnd+'~'+'New'+'~'+'GBU');
	                if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'New'+'~'+'MSO'))
	                    projCountMSO += projMap.get(cate+'~'+brnd+'~'+'New'+'~'+'MSO');
	                if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'Disco'+'~'+'GBU'))
	                    projDiscoGBU += projMap.get(cate+'~'+brnd+'~'+'Disco'+'~'+'GBU');
	                if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'Disco'+'~'+'MSO'))
	                    projDiscoMSO += projMap.get(cate+'~'+brnd+'~'+'Disco'+'~'+'MSO');
            	}
            	else if(Stype.size()==1){
            		if(Stype[0]=='GBU'){
            			if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'New'+'~'+'GBU'))
	                    	projCountGBU += projMap.get(cate+'~'+brnd+'~'+'New'+'~'+'GBU');
	                    if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'Disco'+'~'+'GBU'))
	                    	projDiscoGBU += projMap.get(cate+'~'+brnd+'~'+'Disco'+'~'+'GBU');
            		}
            		else{
            			if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'New'+'~'+'MSO'))
	                    	projCountMSO += projMap.get(cate+'~'+brnd+'~'+'New'+'~'+'MSO');
	                    if(!projMap.isEmpty() && projMap.containsKey(cate+'~'+brnd+'~'+'Disco'+'~'+'MSO'))
	                    	projDiscoMSO += projMap.get(cate+'~'+brnd+'~'+'Disco'+'~'+'MSO');
            		}
            	}
			}
			Map<string,integer> CatProCounts = new Map<string,integer>();
			CatProCounts.put('NewGBU',projCountGBU);
			CatProCounts.put('NewMSO',projCountMSO);
			CatProCounts.put('DiscoGBU',projDiscoGBU);
			CatProCounts.put('DiscoMSO',projDiscoMSO);
				
            if(lifecycle.size()==1){
                selectedLifeCycle=' ('+lifecycle[0]+')';
                if(lifecycle[0]=='Active & Planned'){
                    LastMonthProjectionCount = plMonAct + projCountGBU + projCountMSO - projDiscoGBU - projDiscoMSO;
                }
                else{
                    LastMonthProjectionCount = plMonAct + projDiscoGBU + projDiscoMSO;
                }
            }
            else{                                               
                LastMonthProjectionCount = plMonAct + projCountGBU + projCountMSO;
            }
                         
            Table2data.add(new wrapperData(cate,PreLastMonth+' SKU COUNT '+selectedLifeCycle,PreLastMonthActualsMap.get(cate),98765));
            
            for(string pt:new list<string>{'New','Disco'}){                             
                for(string st:Stype){
                    integer sign2=pt=='Disco'?-1:1;                    
                    string skutype =st=='GBU'?'NON-CUSTOMIZED ':'CUSTOMIZED ';                    
                    skutype+=pt+' SKUs';
                    integer projectioncount=CatProCounts.get(pt+st);
                    integer actualcount=ActualCounts.get(pt+st);
                    if(pt=='New'){
                    	NewSkuCount +=actualcount;
                    }else if(pt=='Disco'){
                    	DisSkuCount +=actualcount;
                    }
                    Table2data.add(new wrapperData(cate,skutype,projectioncount*sign2,actualcount*sign2));            
                }
            }                
            Table2data.add(new wrapperData(cate,LastMonth+' SKU COUNT '+selectedLifeCycle,LastMonthProjectionCount,lMonAct));             
        }
        system.debug('Number of Queries used in this apex code so far: ---------'+Limits.getQueries());
        //return clcy3;        
    	TabledataMap.put('Table2data',Table2data);
    	    	
    	IncNewSkuCount += [SELECT count() from sku_Projection__c WHERE 
						SKU__r.GBU__c=:userGBU and 
						SKU__r.Category__c in :category and 
						SKU__r.Dish_Care_Group__c in :brand and 
						SKU__r.SKU_Type__c in :Stype and 
						Projected_date__c=LAST_MONTH AND 
						Projection_Type__c IN ('New','Customized New SKU','Non-Customized New SKU') 
						AND ((Include_in_Projections__c=true and recordtype.DeveloperName='G_11' AND SKU__r.Status__c='Projected') OR 
						(Include_in_Projections_Manual__c=true and recordtype.DeveloperName='Manual' and SKU__r.Name='Manual Projection Default Parent SKU'))];
    	IncDisSkuCount += [SELECT count() from sku_Projection__c WHERE 
						SKU__r.GBU__c=:userGBU and 
						SKU__r.Category__c in :category and 
						SKU__r.Dish_Care_Group__c in :brand and 
						SKU__r.SKU_Type__c in :Stype and 
						Projected_date__c=LAST_MONTH AND 
						Projection_Type__c IN ('Disco','Customized Disco','Non-Customized Disco') 
						AND ((Include_in_Projections__c=true and recordtype.DeveloperName='G_11' AND SKU__r.Status__c!='Remnant & Historical') OR 
						(Include_in_Projections_Manual__c=true and recordtype.DeveloperName='Manual' and SKU__r.Name='Manual Projection Default Parent SKU'))];
		NoChagSkuCount += [SELECT count() FROM SKU__c where  GBU__c=:userGBU and IsSKUMissing__c=false and status__c!='Projected' and
						Include_in_last_month_actual_counts__c=false 
						and Category__c in :category and Dish_Care_Group__c in :brand and SKU_Type__c in :Stype and Status__c in :lifecycle];
    	list<wrapperData> AccData = new list<wrapperData>();
    	AccData.add(new wrapperData('NewSKUCount','NewSKUCount',0,NewSkuCount));
    	AccData.add(new wrapperData('DisSkuCount','DisSkuCount',0,DisSkuCount));
    	AccData.add(new wrapperData('IncNewSkuCount','IncNewSkuCount',0,IncNewSkuCount));
    	AccData.add(new wrapperData('IncDisSkuCount','IncDisSkuCount',0,IncDisSkuCount));
    	AccData.add(new wrapperData('NoChagSkuCount','NoChagSkuCount',0,NoChagSkuCount));
    	TabledataMap.put('AccData',AccData);
    	
    	return TabledataMap;
    }    
    
  //  @AuraEnabled public static list<wrapperData> fetchCPtype(list<string> category,list<string> lifecycle,list<string> brand, list<string> Stype) {}
    
    @AuraEnabled public static boolean DeleteSKU_Pro_record(id RecordId){
        
        list<SKU_Projection__c> seleRec = [select id,Description__c from SKU_Projection__c where id =:RecordId];        
        if(! seleRec.isEmpty()){
            system.debug(seleRec);
            delete seleRec;
            return true;
        }else{
            return false;            
        }
        
    }

}