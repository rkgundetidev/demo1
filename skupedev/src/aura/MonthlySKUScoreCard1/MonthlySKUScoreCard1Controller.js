({
	doInit : function(component, event, helper) {
		
        helper.getPosition(component);
        //helper.getData(component);
		//helper.getCategoryList(component);
		//helper.getData(component,'','');
		
		/*
		var opts = [
            { class: "optionClass", label: "Option1", value: "opt1", selected: "true" },
            { class: "optionClass", label: "Option2", value: "opt2" },
            { class: "optionClass", label: "Option3", value: "opt3" }
           
        ];
        component.find("InputSelectDynamic").set("v.options", opts);
		*/
		var opts1 = [
            "Air Care",
            "Dish Care",
            "Surface Care"
           
        ];
		component.set("v.lstOptions",opts1);


    },/*
	cboxChange: function(component, event, helper)
	{
		//document.getElementById("boxId").style.display = "none";
		var x = document.getElementById('boxId');
		if (x.style.display === 'none') {
			x.style.display = 'block';
		} else {
			x.style.display = 'none';
		}
	},*/
	checkboxChange: function(component, event, helper){
		//alert(event.target.id+'==='+event.target.checked);
		var cate = event.target.id;
		var arr2 = component.get("v.includedcatbrandmap1");
		var arr1 = component.get("v.selSubCategories");
		for(var i=0; i<arr2.length; i++)
		{
			if(arr2[i].name == cate)
			{
				arr2[i].isSelected = event.target.checked;
				var brands = arr2[i].brands;
				for(var j=0;j<brands.length;j++)
				{
					brands[j].isSelected = event.target.checked;
					if(event.target.checked)
					{
						var arr = component.get("v.selSubCategories");
						arr.push(brands[j].name);
						component.set("v.selSubCategories", arr);
					}else
					{
						var arr = component.get("v.selSubCategories");
						for(var i = 0 ; i < arr.length ; i++) {
							if(arr[i] == brands[j].name) {
							  arr.splice(i, 1);
							}
						}
						component.set("v.selSubCategories", arr);
					}
				}
			}

		}
		//alert(JSON.stringify(arr2));
		component.set("v.includedcatbrandmap1",arr2);

		if(event.target.checked)
		{
			var arr = component.get("v.selectedCategories");
			arr.push(cate);
			component.set("v.selectedCategories", arr);
		}else
		{
			var arr = component.get("v.selectedCategories");
			for(var i = 0 ; i < arr.length ; i++) {
				if(arr[i] == cate) {
				  arr.splice(i, 1);
				}
			}
			component.set("v.selectedCategories", arr);
		}
		component.set("v.lstData",[]);
		document.getElementById("Accspinner").style.display = "block";
		helper.getData(component,cate,component.get("v.selectedCategories"),component.get("v.selSubCategories"));
	},
	checkboxSubChange: function(component, event, helper){
		//alert(event.target.id+'==='+event.target.checked);
		var cate = event.target.id;
		var arr1 = component.get("v.selSubCategories");
		var arr2 = component.get("v.includedcatbrandmap1");
		
		
		//alert(arr2.length);
		for(var i=0; i<arr2.length; i++)
		{
			var brands = arr2[i].brands;
			for(var j=0;j<brands.length;j++)
			{
				if(brands[j].name == cate)
				{
					brands[j].isSelected = event.target.checked;
				}
			}
		}


		for(var i=0; i<arr2.length; i++)
		{
			var checked = true;
			
			//alert(JSON.stringify(arr2[i]));
			var brands = arr2[i].brands;
			var count = brands.length;
			for(var j=0;j<brands.length;j++)
			{
				if(brands[j].isSelected == false)
				{
					count--;
					checked = false;
				}
			}
			//alert(checked);
			if(count>0)
			{
				arr2[i].isSelected = true;
			}else
			{
				arr2[i].isSelected = false;
			}

		}

		var catArr = [];
		for(var i=0; i<arr2.length; i++)
		{
			if(arr2[i].isSelected == true)
			{

				catArr.push(arr2[i].name);
			}
		}

		component.set("v.selectedCategories", catArr);

		//alert(JSON.stringify(arr2));
		component.set("v.includedcatbrandmap1",arr2);
		if(event.target.checked)
		{
			var arr = component.get("v.selSubCategories");
			arr.push(cate);
			component.set("v.selSubCategories", arr);
		}else
		{
			var arr = component.get("v.selSubCategories");
			for(var i = 0 ; i < arr.length ; i++) {
				if(arr[i] == cate) {
				  arr.splice(i, 1);
				}
			}
			component.set("v.selSubCategories", arr);
		}
		component.set("v.lstData",[]);
		//alert(component.get("v.selSubCategories"));
		document.getElementById("Accspinner").style.display = "block";
		helper.getData(component,cate,component.get("v.selectedCategories"),component.get("v.selSubCategories"));
	},
	/*checkboxChange1: function(component, event, helper){
		//alert(event.target.id);
		var checkbox = event.getSource();
		alert(checkbox.get("v.value"));

		//var element = event.getSource ? event.getSource().getElement() : event.target;
        //alert("hanldeInputCheckboxChange - element checked: ", element.checked);
        //component.set("v.myBool", element.checked);
	},
	onMultiSelectChange: function(component) {
         var selectCmp = component.find("InputSelectDynamic");
         var resultCmp = component.find("multiResult");
         resultCmp.set("v.value", selectCmp.get("v.value"));
	 },*/
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
		if(status == 'A & P')
		{
			status = 'ACTIVE & PLANNED';
		}

		if(status == 'R & H')
		{
			status = 'REMNANT & HISTORICAL';
		}

		document.getElementById("CATEGORY").innerHTML = category;
		document.getElementById("GROUP").innerHTML = group;
		document.getElementById("MONTH").innerHTML = mnth;

		document.getElementById("STATUS").innerHTML = status;
		//helper.getSKUData(component);
		helper.getSKUDynamicData(component);
		//document.getElementById("Accspinner").style.display = "none";
		
		
	},

	hideModal : function(component, event, helper) {
		 //Toggle CSS styles for hiding Modal
		helper.toggleClassInverse(component,'backdrop','slds-backdrop--');
		helper.toggleClassInverse(component,'modaldialog','slds-fade-in-');
		
	  }
})