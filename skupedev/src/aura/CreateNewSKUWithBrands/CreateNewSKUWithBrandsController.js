({
	doInit : function(cmp, evt, helper) {
        var CatCmpId = 'categoryId';
        var CatFieldAPIName = 'Category__c';
        helper.getPicklistMethod(cmp, CatFieldAPIName, CatCmpId);
        
        var GrpCmpId = 'groupId';
        var GrpFieldAPIName ='Dish_Care_Group__c';
        helper.getPicklistMethod(cmp, GrpFieldAPIName, GrpCmpId);
	},
    
    createSKUWithBrands : function(component, event, helper) {
        helper.saveSKUWithBrands(component);
    }
    
    /*
     * keypress="{!c.validate}" keyup="{!c.validate}" keydown="{!c.validate}"  
                                        updateOn="keypress, keyup, keydown"
        validate  : function(component, event, helper) {
        var inp = component.get('v.objSKURec.Name');
        if(inp.length > 14)
        {	alert('afdfa');
            component.set('v.objSKURec.Name', parseFloat(inp.substring(0, 14)));
        }
    }*/
})