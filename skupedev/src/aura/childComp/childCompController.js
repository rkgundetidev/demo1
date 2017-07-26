/* childExprController.js */
({
    updateChildAttr: function(cmp) {
        cmp.set("v.childAttr", "Child");
    },

    onChildAttrChange: function(cmp, evt) {
        /*alert("childAttr has changed");
        alert("old value: " + evt.getParam("oldValue"));
        alert("current value: " + evt.getParam("value"));*/
    }
})