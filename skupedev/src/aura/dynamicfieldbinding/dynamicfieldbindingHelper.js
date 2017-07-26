({
	doInit : function(cmp) {
        var calctype = cmp.get("v.calctype");
        if(calctype=="ststotal")
            this.calcStsTotal(cmp);
        else if(calctype=="total")
            this.calcTotal(cmp);
        else
            this.displaySimple(cmp);
	},
    displaySimple: function(cmp){
        var helper = this;
        var cat = cmp.get("v.cat");
        var projtype = cmp.get("v.projtype");
        var mnth = cmp.get("v.mnth");
        var repData = cmp.get("v.reportdata");
        var sts = cmp.get("v.sts");
        try{
            if(repData.length>0){
                var data = repData[0][cat][sts][projtype][mnth];
                if(!(/Base/.test(projtype)) && data.length>0){
                    cmp.set("v.attachevent",true);
                    var arr=[];
                    data.forEach(rec=>{
                        arr.push(rec.skuid);
                    });
                    cmp.set("v.skuids",arr);
                }else{
                    cmp.set("v.attachevent",false);
                    cmp.set("v.skuids",[]);
                    if(/Base/.test(projtype) && (!helper.firstMnth || mnth==helper.firstMnth)){
                        $A.util.addClass(cmp.find("contentdiv"),"col4");
                        helper.firstMnth = mnth;
                    }
                }
                
                if(projtype.indexOf('Disco')>-1 && sts=='Active & Planned')
                    cmp.set("v.displayval",0-data.length);
                else
                    cmp.set("v.displayval",data.length);
                
            }
        }catch(e){
            //console.log(e.message);
            cmp.set("v.displayval",0);
        }
    },

    calcStsTotal: function(cmp){
        var cat = cmp.get("v.cat");
        var mnth = cmp.get("v.mnth");
        var repData = cmp.get("v.reportdata");
        var sts = cmp.get("v.sts");
        var cnewsku = "Customized New SKU";
        var ncnewsku = "Non-Customized New SKU";
        var cdisco = "Customized Disco";
        var ncdisco = "Non-Customized Disco";

        try{
            if(repData.length>0){
                var data = repData[0][cat][sts];
                var total=data["Base"][mnth].length;
                if(sts=="Active & Planned"){
                    total+=data[ncnewsku][mnth].length;
                    total+=data[cnewsku][mnth].length;
                    total-=data[ncdisco][mnth].length;
                    total-=data[cdisco][mnth].length;
                }
                else{
                    total+=data[ncdisco][mnth].length;
                    total+=data[cdisco][mnth].length;
                }
                cmp.set("v.displayval",total);
                $A.util.addClass(cmp.find("contentdiv"),"col3 bold");
            }
        }catch(e){
            //console.log(e.message);
            cmp.set("v.displayval",0);
        }
    },
    
    calcTotal: function(cmp){
        var cat = cmp.get("v.cat");
        var mnth = cmp.get("v.mnth");
        var repData = cmp.get("v.reportdata");
        var anp = "Active & Planned";
        var rnh = "Remnant & Historical";

        try{
            if(repData.length>0){
                var data =repData[0][cat];
                var total=data[anp]["Base"][mnth].length+data[rnh]["Base"][mnth].length;
                total+=data[anp]["Non-Customized New SKU"][mnth].length;
                total+=data[anp]["Customized New SKU"][mnth].length;
                cmp.set("v.displayval",total);
                $A.util.addClass(cmp.find("contentdiv"),"col2 bold");
            }
        }catch(e){
            //console.log(e.message);
            cmp.set("v.displayval",0);
        }
    },

    showSKUs: function(cmp){
        var helper = this;
        var cat = cmp.get("v.cat");
        var projtype = cmp.get("v.projtype");
        var mnth = cmp.get("v.mnth");
        var repData = cmp.get("v.reportdata");
        var skuids = cmp.get("v.skuids");
        try{
            if(repData.length>0){
                var openPopup = $A.get("e.c:openprojectiondetails");
                openPopup.setParams({"skuids":skuids,"projType":projtype,"mnth":mnth});
                openPopup.fire();
            }
        }catch(e){
            //console.log(e.message);
            cmp.set("v.displayval",0);
        }
    }
})