({
	init : function(component, event, helper) {
		//alert('init'+component.get("v.actuals")+'=='+component.get("v.pProjections")+'==='+component.get("v.fProjections"));
		//alert(component.get("v.passMethod"));
	},
	onChildButtonClick : function(component, event, helper) {
		alert('lick click');
		var parentEvent =  component.getEvent("passMethod");
		alert(JSON.stringify(parentEvent));
        //parentEvent.setParams({"passval":"Hi....... from child component"});       
        parentEvent.fire(); 
        //component.set("v.show", false);
	}
})