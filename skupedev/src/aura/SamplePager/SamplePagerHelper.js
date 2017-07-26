({       
    pageskus : function(component, page, recordToDisply) {
        var totalskus=component.get("v.SKU");		       
        var total = totalskus.length;
        var pages = Math.ceil(total / recordToDisply) ;
        var offset= (page-1)*recordToDisply;
        var pagesku = [];
        
        for(var i=offset;i<(total<(page*recordToDisply) ? total:page*recordToDisply);i++)
        {
            pagesku.push(totalskus[i]); 
        }
        component.set("v.SKUdata",pagesku);
        component.set("v.page", page);
        component.set("v.total", total);
        component.set("v.pages", pages);
        
        var pnums = [];        	
        for(var i=1;i<=pages;i++){
            pnums.push(i);
        }
        component.set("v.pagenumbers",pnums);
        
        
    },
    
})