({
	doInit : function(component, event, helper){
        helper.getCount(component);
    },
    closeComp : function(cmp, event, helper) {
        cmp.find("modalbody").set("v.body", []);
        $A.util.addClass(cmp.find("thecontainer"),"hidden");
	},
    displaySKUsforCompleted: function(cmp,evt,helper){
        helper.getSKUDetailsInfo(cmp,evt,'Completed as Planned');
	},
    displaySKUsforUnplan: function(cmp,evt,helper){
        helper.getSKUDetailsInfo(cmp,evt,'Unplanned');
	},
    displaySKUsforNotCompleted: function(cmp,evt,helper){
        helper.getSKUDetailsInfo(cmp,evt,'Not Completed as Planned');
	}
})