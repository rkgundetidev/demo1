({
	doInit : function(cmp, evt, helper) {
		
		/*var projData = [];
		projData.push({date:'2017-01-01',gbunewsku:4,msonewsku:3,gbudisco:2,msodisco:3});
		projData.push({date:'2017-02-01',gbunewsku:2,msonewsku:1,gbudisco:1,msodisco:3});
		projData.push({date:'2017-03-01',gbunewsku:4,msonewsku:2,gbudisco:4,msodisco:1});
		var base = 1000,change=0;
		projData.forEach(obj=>{obj.base=base+change;change+=obj.gbunewsku+obj.msonewsku-obj.gbudisco-obj.msodisco});
		cmp.set("v.projectiondata",projData);
		cmp.set("v.base",base);
		*/
		
		helper.doInit(cmp);
	},
	
	filterByCategory: function(cmp,evt,helper){
		var category = evt.getSource().get("v.label");
		var checked = evt.getSource().get("v.value");
		helper.filterByCategory(cmp,category,checked);
	},

	filterByBrand: function(cmp,evt,helper){
		var brand = evt.getSource().get("v.label");
		var checked = evt.getSource().get("v.value");
		helper.filterByBrands(cmp,brand,checked);
	},

	closeComp : function(cmp, event, helper) {
        cmp.find("modalbody").set("v.body", []);
        $A.util.addClass(cmp.find("thecontainer"),"hidden");
	},
	cancel: function(cmp){
     /*  var cancelEvent=$A.get("e.c:saveOppProductsEvent");
       cancelEvent.setParams({type:'cancel'});
       cancelEvent.fire(); 
	   */
    },
    save: function(cmp){
        var saveEvent=$A.get("e.c:saveoverride");
		saveEvent.fire();
		//alert('save fired');
    },
	openProjDetails: function(cmp,evt,helper){
		helper.openProjDetails(cmp,evt);
	},

	//filtering based on user selection
	handleFilter: function(cmp,evt,helper){
		helper.filter(cmp,evt);
	},

	openReconcile: function(cmp,evt,helper){
		helper.openReconcile(cmp,evt);
	}
})