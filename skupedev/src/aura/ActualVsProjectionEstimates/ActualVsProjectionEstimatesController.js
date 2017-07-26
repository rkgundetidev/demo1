({
	doInit : function(component, event, helper){
        helper.getEstimateActualSKUCount(component);
        helper.getProjEstimateActualSKUCount(component);
    },
    displaySKUsforEstimates: function(cmp,evt,helper){
        var tagId = evt.currentTarget.id;
        helper.getSKUDetails(cmp,tagId,'Estimate');
	},
    displaySKUsforactuals: function(cmp,evt,helper){
        var tagId = evt.currentTarget.id;
        helper.getSKUDetails(cmp,tagId,'Actual');
	},
    displayDetailedSKUsforEstimates: function(cmp,evt,helper){
        helper.getSKUDetailedInfo(cmp,evt,'Estimate');
	},
    displayDetailedSKUsforActuals: function(cmp,evt,helper){
        helper.getSKUDetailedInfo(cmp,evt,'Actual');
	},
    closeComp : function(cmp, event, helper) {
        cmp.find("modalbody").set("v.body", []);
        $A.util.addClass(cmp.find("thecontainer"),"hidden");
	}
})