({
    doInit : function(component, helper) {
        var SKU = component.get('v.sku');
        var FieldName = component.get('v.fieldName');
        var outputText = component.find("outputTextId");
        outputText.set("v.value",SKU[FieldName]);
    },
    render : function(component, helper) {
        var ret = this.superRender();

        var SKU = component.get('v.sku');
        var FieldName = component.get('v.fieldName');
        var outputText = component.find("outputTextId");
        outputText.set("v.value",SKU[FieldName]);

        return ret;
    },

})