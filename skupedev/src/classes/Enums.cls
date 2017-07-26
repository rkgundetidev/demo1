global class Enums{
    global enum GBU{HOME_CARE,ORAL_CARE,SKIN_CARE}
    global enum MODULE{ACTUALS,PROJECTIONS,INVENTORIES}

    public static String getGBUStr(GBU gbu){
        if(gbu == Enums.GBU.HOME_CARE){
            return 'Home Care';
        }else if(gbu == Enums.GBU.ORAL_CARE){
            return 'Oral Care';
        }else if(gbu == Enums.GBU.SKIN_CARE){
            return 'Skin Care';
        }
        return null;
    }

    public static Enums.GBU getGBUEnum(String gbu){
        if(gbu == 'Home Care'){
            return Enums.GBU.HOME_CARE;
        }else if(gbu == 'Oral Care'){
            return Enums.GBU.ORAL_CARE;
        }else if(gbu == 'Skin Care'){
            return Enums.GBU.SKIN_CARE;
        }
        return null;
    }
}