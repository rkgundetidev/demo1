({
    doInit : function(component, event, helper){
        helper.getSKUsWithBrands(component);
    },
    
    showHidePanel : function(component, event, helper) {
        var id=event.currentTarget.id;  
        var e=document.getElementById("Brands"+id); 
        var plusIcon=document.getElementById("Plus"+id); 
        var minusIcon=document.getElementById("Minus"+id); 
        if (e.style.display == 'block' || e.style.display==''){
            e.style.display = 'none';
        }else{
            e.style.display = '';
        } 
        if (plusIcon.style.display == 'block' || plusIcon.style.display==''){
            plusIcon.style.display = 'none';
            minusIcon.style.display = 'block';
        }else if (minusIcon.style.display == 'block' || minusIcon.style.display==''){
            minusIcon.style.display = 'none';
            plusIcon.style.display = 'block';
        } 
    },
    
    cancel : function (component, event, helper) {
    	$A.get("e.force:closeQuickAction").fire();
        $A.get("e.force:refreshView").fire();
    },
    
    Save : function (component, event, helper) {
    	helper.saveBrands(component); 
    },

    addToChangedList: function(cmp,evt,helper){
        var brandid = evt.getSource().get("v.class");
        var newdate = evt.getSource().get("v.value");
        var projType = cmp.get("v.projType");
        helper.addToChangedList(brandid,newdate,projType);
    },
       
})