({
	saveSKUWithBrands : function(component) {
        var objSKUInfo = component.get("v.objSKURec");
        if($A.util.isEmpty(objSKUInfo.SKU_Description__c) || $A.util.isUndefined(objSKUInfo.SKU_Description__c)){
            alert("SKU Description is Required");
            return;
        } 
        if(objSKUInfo.Category__c == '--Select--' || $A.util.isEmpty(objSKUInfo.Category__c) || $A.util.isUndefined(objSKUInfo.Category__c)){
            alert("Category is Required");
            return;
        } 
        if(objSKUInfo.Dish_Care_Group__c == '--select--' || $A.util.isEmpty(objSKUInfo.Dish_Care_Group__c) || $A.util.isUndefined(objSKUInfo.Dish_Care_Group__c)){
            alert("Group is Required");
            return;
        } 
        
        var objBrandRecInfo = component.get("v.objBrandRec");
        if($A.util.isEmpty(objBrandRecInfo.Projected_Start_Date__c) || $A.util.isUndefined(objBrandRecInfo.Projected_Start_Date__c)){
            alert("Projected Start Date is Required");
            return;
        }         
        if($A.util.isEmpty(objBrandRecInfo.Projected_Disco_Date__c) || $A.util.isUndefined(objBrandRecInfo.Projected_Disco_Date__c)){
            alert("Projected Disco Date is Required");
            return;
        } 
		var action = component.get("c.createSKU");
        action.setParams({objSKU: component.get("v.objSKURec"), objBrnd: component.get("v.objBrandRec")});
       	action.setCallback(this, function(res) {
            var response = res.getReturnValue();
            var state = action.getState();
            if(state == "SUCCESS"){
                 if(response == "Success"){
                    $A.get("e.force:closeQuickAction").fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                          "title": "Records Created Successfully!",
                          "message": "Created New SKU With Brands"
                    });    
                    toastEvent.fire();
                    $A.get("e.force:refreshView").fire();
                 }else{
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                            "title": "An unexpected error occured. Please contact your System Administrator",
                            "message": response
                    });    
                    toastEvent.fire();
                 } 
             }
        });        
        $A.enqueueAction(action);  
    },
    
    getPicklistMethod : function(component, FieldName, CatCmpId) {
        //alert('in Helper'+FieldName);
        var action = component.get("c.getPicklistValues");
        action.setParams({
            strFieldName : FieldName
        });
        var opts=[];
        action.setCallback(this, function(a) {
        var state=a.getState();
        //alert(state);
        for(var i=0;i< a.getReturnValue().length;i++){
            //alert(a.getReturnValue()[i]);
            opts.push({ id: a.getReturnValue()[i],label: a.getReturnValue()[i]});
            //alert(opts);
        }
        
        var cmp = component.find(CatCmpId);
        //alert(cmp);
        cmp.set('v.body', []); // clear all options
        var body = cmp.get('v.body');

        opts.forEach(function (opt) {
            //alert('options=='+opt);
            $A.createComponent(
                'aura:html',
                {
                    tag: 'option',
                    HTMLAttributes: {
                        value: opt.id,
                        text: opt.label
                    }
                },

                function (newOption) {
                    //Add options to the body
					if (component.isValid()) {
                        body.push(newOption);
                        cmp.set('v.body', body);
                    }
                })
        });
      });       
		$A.enqueueAction(action); 
	}   
})