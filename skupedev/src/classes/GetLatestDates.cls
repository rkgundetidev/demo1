public class GetLatestDates {

    public static void updateLatest(Enums.GBU gbu,ENUMS.MODULE mod,Date dt){
        
        
        if(gbu==ENUMS.GBU.HOME_CARE){
            LatestDates__c ltDate = LatestDates__c.getOrgDefaults();
            if(mod==ENUMS.MODULE.ACTUALS){
                ltDate.Date__c=dt;
            }else if(mod==ENUMS.MODULE.PROJECTIONS){
                ltDate.Projection_Update_Date__c=dt;
            }else if(mod==ENUMS.MODULE.INVENTORIES){
                ltDate.InvUpdateDate__c=dt;
            }
            update ltDate;
        }else if(gbu==ENUMS.GBU.ORAL_CARE){
            Latest_Dates_OralCare__c ltDate = Latest_Dates_OralCare__c.getOrgDefaults();
            if(mod==ENUMS.MODULE.ACTUALS){
                ltDate.ActualDate__c=dt;
            }else if(mod==ENUMS.MODULE.PROJECTIONS){
                ltDate.ProjDate__c=dt;
            }else if(mod==ENUMS.MODULE.INVENTORIES){
                ltDate.InvDate__c=dt;
            }
            update ltDate;
        }else if(gbu==ENUMS.GBU.SKIN_CARE){
            if(mod==ENUMS.MODULE.ACTUALS){
                //TODO: update latest actual date
            }else if(mod==ENUMS.MODULE.PROJECTIONS){
                //TODO: update latest projection date
            }else if(mod==ENUMS.MODULE.INVENTORIES){
                //TODO: update latest inventory date
            }
        }
        
    }

    public static Date getLatest(Enums.GBU gbu,ENUMS.MODULE mod){
        Date retDate = null;
        
        if(gbu==ENUMS.GBU.HOME_CARE){
            LatestDates__c ltDate = LatestDates__c.getOrgDefaults();
            if(mod==ENUMS.MODULE.ACTUALS){
                retDate = ltDate.Date__c;
            }else if(mod==ENUMS.MODULE.PROJECTIONS){
                retDate = ltDate.Projection_Update_Date__c;
            }else if(mod==ENUMS.MODULE.INVENTORIES){
                retDate = ltDate.InvUpdateDate__c;
            }
        }else if(gbu==ENUMS.GBU.ORAL_CARE){
            Latest_Dates_OralCare__c ltDates = Latest_Dates_OralCare__c.getOrgDefaults();
            if(mod==ENUMS.MODULE.ACTUALS){
                retDate = ltDates.ActualDate__c;
            }else if(mod==ENUMS.MODULE.PROJECTIONS){
                retDate = ltDates.ProjDate__c;
            }else if(mod==ENUMS.MODULE.INVENTORIES){
                retDate = ltDates.InvDate__c;
            }
        }else if(gbu==ENUMS.GBU.SKIN_CARE){
            if(mod==ENUMS.MODULE.ACTUALS){
                //TODO: return latest actual date
            }else if(mod==ENUMS.MODULE.PROJECTIONS){
                //TODO: return latest projection date
            }else if(mod==ENUMS.MODULE.INVENTORIES){
                //TODO: return latest inventory date
            }
        }
        return retDate;
    }
}