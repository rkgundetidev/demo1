({
	render : function(cmp, helper) {
        var ret = this.superRender();
        // do custom rendering here
        return ret;
    },
	rerender : function(cmp, helper){
        this.superRerender();
        // do custom rerendering here
    }
})