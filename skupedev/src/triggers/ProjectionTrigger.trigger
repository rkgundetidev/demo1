trigger ProjectionTrigger on Brand_Projection__c (before insert) {
    
    if(trigger.isInsert){
        if(trigger.isBefore){
           // ProjectionHandler.handleInsert();
        }
    }
}