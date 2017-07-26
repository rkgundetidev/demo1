({
	doInit : function(component, event, helper) {
		
        helper.getPosition(component);
        helper.getData(component);
		
    },
	showOppmodal: function(component, event, helper) {
		 //Toggle CSS styles for opening Modal
		 //var spinner = cmp.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-hide");
		
		helper.toggleClass(component,'backdrop','slds-backdrop--');
		helper.toggleClass(component,'modaldialog','slds-fade-in-');
		
		
		document.getElementById("Accspinner").style.display = "block";
		var category = event.currentTarget.dataset.catagory;
		var status = event.currentTarget.dataset.status;
		var group = event.currentTarget.dataset.group;
		var mnth = event.currentTarget.dataset.mnth;
		//alert(category+'==='+status+'==='+group+'==='+mnth);
		
		document.getElementById("CATEGORY").innerHTML = category;
		document.getElementById("GROUP").innerHTML = group;
		document.getElementById("MONTH").innerHTML = mnth;
		document.getElementById("STATUS").innerHTML = status;
		helper.getSKUData(component);
		//document.getElementById("Accspinner").style.display = "none";
		
		
	},

	hideModal : function(component, event, helper) {
		 //Toggle CSS styles for hiding Modal
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
		
	  }
})