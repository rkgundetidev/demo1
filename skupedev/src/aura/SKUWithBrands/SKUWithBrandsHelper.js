({
    getSKUsWithBrands: function(component) {
        
        var action = component.get("c.getSKUsWithBrandDetails");
        action.setParams({
                            "skuids":component.get("v.skuids"),
                            "projType":component.get("v.projType")
                        });
        //Set up the callback
        var self = this;
        action.setCallback(this, function(actionResult) {
            component.set("v.lstWrapper", actionResult.getReturnValue());
            self.hideSpinner(component);
        });        
        $A.enqueueAction(action);

        /*
        var savewrapperAction = component.get("c.getSampleWrapper");
        savewrapperAction.setCallback(this,res=>{
            if(component.isValid() && res.getState()=="SUCCESS"){
                var wrap = res.getReturnValue();
                console.log(res);
            }
        }); 

        $A.enqueueAction(savewrapperAction);
        */
    },  
    
    changedRecords:{},
    
    hideSpinner: function(cmp){
      $A.util.addClass(cmp.find('spinner'),'hidden');
    },
    showSpinner:function(cmp){
      $A.util.removeClass(cmp.find('spinner'),'hidden');  
    },
    
    addToChangedList: function(id,newdate,projType){
        var helper = this;
        helper.changedRecords[id]={"brandId":id,"dateoverride":newdate,"projType":projType};
    },

    saveBrands : function(component) {
        var helper = this;
        var action = component.get("c.updateBrands");
       	//action.setParams({"lstWrapperParam": component.get("v.lstWrapper")});
       	//Set up the callback
        var changedRecs = [];
        for(var brandid in helper.changedRecords){
            var rec={};
            rec.brandId = brandid;
            rec.dateoverride = helper.changedRecords[brandid].dateoverride || null;
            rec.projType = helper.changedRecords[brandid].projType;
            changedRecs.push(rec);
        }
        //component.set("v.changedrecords",changedRecs);
        //changedRecs = component.get("v.changedrecords");
        action.setParams({"strWrapperParam": JSON.stringify(changedRecs)});
        action.setCallback(this, function(res) {
            var response = res.getReturnValue();
            var state = action.getState();
            //alert(state);
            if(state == "SUCCESS"){
                 if(response == "Success"){
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                          "title": "Records Updated Successfully!",
                          "message": "Updated Brands"
                    });    
                    toastEvent.fire();
                    $A.get("e.force:refreshView").fire();
                 } 
             }else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                        "title": "An unexpected error occured. Please contact your System Administrator",
                        "message": "Updated Brands"
                });    
                toastEvent.fire();
             }
        });        
        $A.enqueueAction(action);  
	}   
})