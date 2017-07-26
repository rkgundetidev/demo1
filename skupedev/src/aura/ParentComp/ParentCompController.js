/* parentExprController.js */
({
    updateParentAttr: function(cmp) {
        cmp.set("v.parentAttr", "Parent");
    },

    onParentAttrChange: function(cmp, evt) {
        /*alert("parentAttr has changed");
        alert("old value: " + evt.getParam("oldValue"));
        alert("current value: " + evt.getParam("value"));*/
    }
})