({
    doInit : function(component, helper) {
        var Contact = component.get('v.contact');
        var FieldName = component.get('v.fieldName');
        var outputText = component.find("outputTextId");
        //alert(JSON.stringify(Contact));
		if(!$A.util.isEmpty(Contact) && !$A.util.isUndefined(Contact))
		{
			//alert('FieldName==='+FieldName);
			if (FieldName.indexOf(".") >= 0) {
				var ParentSobject = Contact[FieldName.split(".")[0]];
				if(ParentSobject != undefined){
					outputText.set("v.value",ParentSobject[FieldName.split(".")[1]]);
				}
			}
			else{
				outputText.set("v.value",Contact[FieldName]);
			}
		}
		
    }
})