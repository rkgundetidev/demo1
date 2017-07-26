trigger SKUProjectionTrigger on SKU_Projection__c (before insert,before update) {
    
    if(Trigger.isInsert){
        SKUProjectionTriggerHandler.handleInsert();
    }else if(Trigger.isUpdate){
        SKUProjectionTriggerHandler.handleUpdate();
    }
}